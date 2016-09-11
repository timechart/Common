unit uAMGTeacherAbsence;

interface

uses
  Contnrs;

type
  TAMGTeacherAbsence = class
  private
    FTeacherID: Integer;
    FAbsence: string;
    FAbsenceDateStr: string;
    FAbsenceReasonID: Integer;
    FTeacherCode: string;
    FAbsenceReasonCode: string;
    FTeacherName: string;
    FCoverTally: Integer;
    // FAbsenceReasonCodes: string;
  public
    property TeacherID: Integer read FTeacherID write FTeacherID;
    property TeacherCode: string read FTeacherCode write FTeacherCode;
    property TeacherName: string read FTeacherName write FTeacherName;           // Move to Teacher object once created
    property AbsenceDateStr: string read FAbsenceDateStr write FAbsenceDateStr;  // Some of the user systems may have different formats for the date
    property Absence: string read FAbsence write FAbsence;
    property AbsenceReasonID: Integer read FAbsenceReasonID write FAbsenceReasonID;
    property AbsenceReasonCode: string read FAbsenceReasonCode write FAbsenceReasonCode;
    property CoverTally: Integer read FCoverTally write FCoverTally;
    // property AbsenceReasonCodes: string read FAbsenceReasonCodes write FAbsenceReasonCodes;
  end;

  TAMGTeacherAbsences = class(TObjectList)
  public
    function RefreshFromFile: Boolean;
    function SaveToFile: Boolean;
    function GetIndex(const pTeacherCode: string; pDateStr: string): Integer;
  end;

  TAMGTeacherTally = class(TObject)
  private
    FCode: string;
    FCoverTally: Integer;
  public
    property Code: string read FCode write FCode;
    property CoverTally: Integer read FCoverTally write FCoverTally;
  end;

  TAMGTeacherTallies = class(TObjectList)
  public
    function GetIndex(const pCode: string): Integer;
  end;


var
  TeacherAbsences: TAMGTeacherAbsences;
  TeacherTallies: TAMGTeacherTallies;

implementation

uses
  Classes, SysUtils, DCPrijndael, DCPSha1, uAMGConst, uAMGCommon, DateUtils;

{ TAMGTecaherAbsences }

function TAMGTeacherAbsences.GetIndex(const pTeacherCode: string; pDateStr: string): Integer;
var
  i: Integer;
begin
 Result := -1;
  for i := 0 to Self.Count - 1 do
  begin
    if (TAMGTeacherAbsence(Self.Items[i]).FTeacherCode = Trim(pTeacherCode)) and
       (TAMGTeacherAbsence(Self.Items[i]).FAbsenceDateStr = pDateStr) then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function TAMGTeacherAbsences.RefreshFromFile: Boolean;
var
  lTempList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lTeacherAbsence: TAMGTeacherAbsence;
begin
  Result := False;
  Self.Clear;
  if FileExists(AMG_TE_ABSENCE_HISTORY_FILE) then
  begin
    lTempList := TStringList.Create;
    Cipher:= TDCP_Rijndael.Create(nil);
    try
      lTempList.LoadFromFile(AMG_TE_ABSENCE_HISTORY_FILE);
      //decrypt string
      Cipher.InitStr(KeyStrRt,TDCP_sha1);   // initialize the cipher with a hash of the passphrase
      lTempList.Text := Cipher.DecryptString(lTempList.Text);
      Cipher.Burn;
      //Retrieve strings
      for i := 0 to lTempList.Count - 1 do
      begin
        lTeacherAbsence := TAMGTeacherAbsence.Create;
        lTeacherAbsence.FTeacherCode := Trim(GetSubStr(lTempList.Strings[i], 1, '|'));
        lTeacherAbsence.FTeacherName := GetSubStr(lTempList.Strings[i], 2, '|');
        lTeacherAbsence.FAbsenceDateStr := GetSubStr(lTempList.Strings[i], 3, '|');
        lTeacherAbsence.FAbsence := GetSubStr(lTempList.Strings[i], 4, '|');
        lTeacherAbsence.FAbsenceReasonCode := GetSubStr(lTempList.Strings[i], 5, '|');
        Self.Add(lTeacherAbsence);
      end;
    finally
      if Assigned(lTempList) then
        FreeAndNil(lTempList);
      if Assigned(Cipher) then
        FreeAndNil(Cipher);
    end;
  end;
  Result := True;
end;

function TAMGTeacherAbsences.SaveToFile: Boolean;
var
  lTempList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lTeacherAbsence: TAMGTeacherAbsence;
begin
  lTempList := TStringList.Create;
  Cipher := TDCP_Rijndael.Create(nil);
  try
    for i := 0 to Self.Count -1 do
    begin
      lTeacherAbsence := TAMGTeacherAbsence(Self.Items[i]);
      lTempList.Add(lTeacherAbsence.FTeacherCode + '|' +
                    lTeacherAbsence.FTeacherName + '|' +
                    lTeacherAbsence.FAbsenceDateStr + '|' +
                    lTeacherAbsence.FAbsence + '|' +
                    lTeacherAbsence.AbsenceReasonCode);
    end;
    {encrypt}
    Cipher.InitStr(KeyStrRt, TDCP_sha1);         // initialize the cipher with a hash of the passphrase
    lTempList.Text := Cipher.EncryptString(lTempList.Text);
    Cipher.Burn;
    lTempList.SaveToFile(AMG_TE_ABSENCE_HISTORY_FILE);
  finally
    if Assigned(Cipher) then
      FreeAndNil(Cipher);
    if Assigned(lTempList) then
      FreeAndNil(lTempList);
  end;
end;

{ TTeacherTallies }

function TAMGTeacherTallies.GetIndex(const pCode: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Self.Count - 1 do
  begin
    if TAMGTeacherTally(Self.Items[i]).Code = pCode then
    begin
      Result := i;
      Exit;
    end;
  end;
end;

end.
