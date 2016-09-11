unit uAMGTeacherAvailability;

interface

uses
  Contnrs;

type
  //Teacher Availability objects
  TAMGAddStaffAvailability = class(TObject)
  private
    FAddedCode: string;
    FAvailable: Integer;
    FDayID: Integer;
  public
    property AddedCode: string read FAddedCode write FAddedCode;
    property DayID: Integer read FDayID write FDayID;
    property Available: Integer read FAvailable write FAvailable;
  end;

  TAMGAddStaffAvailabilities = class(TObjectList)
  public
    function RefreshFromFile: Boolean;
    function SaveToFile: Boolean;
    procedure Update(const pAddCode: string; pDay: Integer; pAvailable: Integer);
    function GetAvailable(const pAddCode: string; pDay: Integer): Integer;
  end;

var
  AddStaffAvailabilities: TAMGAddStaffAvailabilities;
implementation

uses
  Classes, DCPrijndael, DCPSha1, SysUtils, uAMGConst, uAMGCommon;

{ TeacherAvailabilties }

function TAMGAddStaffAvailabilities.GetAvailable(const pAddCode: string; pDay: Integer): Integer;
var
  i: Integer;
  lAddStaffAvailability: TAMGAddStaffAvailability;
begin
  Result := 0;
  for i := 0 to Self.Count - 1 do
  begin
    lAddStaffAvailability := TAMGAddStaffAvailability(Self.Items[i]);
    if (lAddStaffAvailability.FAddedCode = pAddCode) and (lAddStaffAvailability.FDayID = pDay) then
    begin
      Result := lAddStaffAvailability.FAvailable;
      Break;
    end;
  end;
end;

function TAMGAddStaffAvailabilities.RefreshFromFile: Boolean;
var
  lTempList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lAddStaffAvailability: TAMGAddStaffAvailability;
begin
  Result := False;
  Self.Clear;
  if FileExists(AMG_ADDED_STAFF_AVAIL_FILE) then
  begin
    lTempList := TStringList.Create;
    Cipher:= TDCP_Rijndael.Create(nil);
    try
      lTempList.LoadFromFile(AMG_ADDED_STAFF_AVAIL_FILE);
      //decrypt string
      Cipher.InitStr(KeyStrRt,TDCP_sha1);   // initialize the cipher with a hash of the passphrase
      lTempList.Text := Cipher.DecryptString(lTempList.Text);
      Cipher.Burn;
      //retrieve strings
      for i := 0 to lTempList.Count - 1 do
      begin
        lAddStaffAvailability := TAMGAddStaffAvailability.Create;
        lAddStaffAvailability.FAddedCode := Trim(GetSubStr(lTempList.Strings[i], 1, '|'));
        lAddStaffAvailability.FDayID := StrToInt(Trim(GetSubStr(lTempList.Strings[i], 2, '|')));
        lAddStaffAvailability.FAvailable := StrToInt(Trim(GetSubStr(lTempList.Strings[i], 3, '|')));
        Self.Add(lAddStaffAvailability);
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

function TAMGAddStaffAvailabilities.SaveToFile: Boolean;
var
  lTempList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lAddStaffAvailability: TAMGAddStaffAvailability;
begin
  lTempList := TStringList.Create;
  Cipher := TDCP_Rijndael.Create(nil);
  try
    for i := 0 to Self.Count -1 do
    begin
      lAddStaffAvailability := TAMGAddStaffAvailability(Self.Items[i]);
      lTempList.Add(lAddStaffAvailability.FAddedCode + '|' +
                    IntToStr(lAddStaffAvailability.FDayID) + '|' +
                    IntToStr(lAddStaffAvailability.FAvailable));
    end;
    {encrypt}
    Cipher.InitStr(KeyStrRt, TDCP_sha1);         // initialize the cipher with a hash of the passphrase
    lTempList.Text := Cipher.EncryptString(lTempList.Text);
    Cipher.Burn;
    lTempList.SaveToFile(AMG_ADDED_STAFF_AVAIL_FILE);
  finally
    if Assigned(Cipher) then
      FreeAndNil(Cipher);
    if Assigned(lTempList) then
      FreeAndNil(lTempList);
  end;
end;

procedure TAMGAddStaffAvailabilities.Update(const pAddCode: string; pDay, pAvailable: Integer);
var
  i: Integer;
  lAddStaffAvailability: TAMGAddStaffAvailability;
  lFound: Boolean;
begin
  lFound := False;
  for i := 0 to Self.Count - 1 do
  begin
    lAddStaffAvailability := TAMGAddStaffAvailability(Self.Items[i]);
    if (lAddStaffAvailability.FAddedCode = pAddCode) and (lAddStaffAvailability.FDayID = pDay) then
    begin
      lAddStaffAvailability.Available := pAvailable;
      lFound := True;
      Break;
    end;
  end;
  if not lFound then
  begin
    lAddStaffAvailability := TAMGAddStaffAvailability.Create;
    lAddStaffAvailability.FAddedCode := pAddCode;
    lAddStaffAvailability.FDayID := pDay;
    lAddStaffAvailability.FAvailable := pAvailable;
    Self.Add(lAddStaffAvailability);
  end;
  Self.SaveToFile;
end;

end.
