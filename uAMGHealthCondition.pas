unit uAMGHealthCondition;

interface

uses
  uAMGItem;

type
  TAMGStudentHealthCondition = class(TAMGItem)
  private
    FHealthConditionID: Integer;
    FStudentCode: string;
    FHealthConditionCode: string;
    FStudentHealthNote: string;
    FKeySuportPerson: string;
    FHasHealthSupportPlan: Boolean;
    FEmergencyContact: string;
    FEmergencyContactNo: string;
    FOtherRelevantInfo: string;
    FIsInPeerSupport: Boolean;
  public
    procedure Assign(pSource: TAMGStudentHealthCondition);
    property StudentCode: string read FStudentCode write FStudentCode;
    property HealthConditionID: Integer read FHealthConditionID write FHealthConditionID;
    property HealthConditionCode: string read FHealthConditionCode write FHealthConditionCode;
    property StudentHealthNote: string read FStudentHealthNote write FStudentHealthNote;
    property HasHealthSupportPlan: Boolean read FHasHealthSupportPlan write FHasHealthSupportPlan;
    property KeySuportPerson: string read FKeySuportPerson write FKeySuportPerson;
    property EmergencyContact: string read FEmergencyContact write FEmergencyContact;
    property EmergencyContactNo: string read FEmergencyContactNo write FEmergencyContactNo;
    property OtherRelevantInfo: string read FOtherRelevantInfo write FOtherRelevantInfo;
    property IsInPeerSupport: Boolean read FIsInPeerSupport write FIsInPeerSupport;
  end;

  TAMGStudentHealthConditions = class(TAMGItemList)
  public
    function RefreshFromFile: Boolean; override;
    function SaveToFile: Boolean;
    function GetIssueIndex(const pStudentCode, pIssueCode: string): Integer;
  end;

  TAMGHealthCondition = class(TAMGItem)
  private
    FConditionName: string;
    FConditionDescription: WideString;
    FActionPlan: string;
    FConditionWebURL: string;
    FIsUserAdded: Boolean;
  public
    function RefreshFromFile: Boolean;
    function SaveToFile: Boolean;
    function GetHealthConditionCode: string;
    procedure Assign(pSource: TAMGHealthCondition);

    property ConditionName: string read FConditionName write FConditionName;
    property ConditionDescription: WideString read FConditionDescription write FConditionDescription;
    property ActionPlan: string read FActionPlan write FActionPlan;
    property ConditionWebURL: string read FConditionWebURL write FConditionWebURL;
    property IsUserAdded: Boolean read FIsUserAdded write FIsUserAdded;
  end;

  TAMGHealthConditions = class(TAMGItemList)
  public
    function RefreshFromFile: Boolean; override;
    function SaveToFile: Boolean;
  end;

var
  HealthConditions: TAMGHealthConditions;
  StudentHealthConditions: TAMGStudentHealthConditions;

implementation

uses
  Classes, DCPrijndael, DCPSha1, SysUtils, uAMGConst, uAMGCommon, Dialogs;

{ TAMGHealthCondition }

function TAMGHealthCondition.RefreshFromFile: Boolean;
begin
  //c
end;

function TAMGHealthCondition.SaveToFile: Boolean;
begin
  //c
end;

{ TAMGHealthConditions }

procedure TAMGHealthCondition.Assign(pSource: TAMGHealthCondition);
begin
  if Assigned(pSource) then
  begin
    Self.ID := pSource.ID;
    Self.Code := pSource.Code;
    Self.FConditionName := pSource.FConditionName;
    Self.FConditionDescription := pSource.FConditionDescription;
    Self.FActionPlan := pSource.FActionPlan;
    Self.FConditionWebURL := pSource.FConditionWebURL;
    //Self.LastUpdatedDate := pSource.LastUpdatedDate;
  end;
end;

function TAMGHealthCondition.GetHealthConditionCode: string;
var
  lSpPos: Integer;
  lTempStr: string;
  lIssue: string;
begin
  Result := '';
  lSpPos := Pos(' ', FConditionName);
  if lSpPos > 0 then
  begin
    lTempStr := Trim(Copy(FConditionName, 1, 3));
    lIssue := Trim(Copy(FConditionName, lSpPos + 1, Length(FConditionName)));
    lTempStr := lTempStr + Trim(Copy(lIssue, 1, 3));
  end
  else
  begin
    lTempStr := Trim(Copy(FConditionName, 1, 6));
  end;
  Result := UpperCase(lTempStr);
end;

function TAMGHealthConditions.RefreshFromFile: Boolean;
var
  lTempList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lHealthCondition: TAMGHealthCondition;
  lIsUserAdded: string;
  lStr: string;
  lPos: Integer;

  function GetNextField: string;
  var
    lField: string;
  begin
    Result := '';
    lPos := Pos(AMG_PIPE, lStr);
    lField := Trim(Copy(lStr, 1, lPos -1));
    lStr := Trim(Copy(lStr, lPos + 1, Length(lStr)));
    Result := lField;
  end;
begin
  inherited RefreshFromFile;
  Result := False;
  Self.Clear;
  if FileExists(AMG_HEALTH_ISSUE_FILE) then
  begin
    lTempList := TStringList.Create;
    Cipher:= TDCP_Rijndael.Create(nil);
    try
      lTempList.LoadFromFile(AMG_HEALTH_ISSUE_FILE);
      //decrypt string
      Cipher.InitStr(KeyStrRt,TDCP_sha1);   // initialize the cipher with a hash of the passphrase
      lTempList.Text := Cipher.DecryptString(lTempList.Text);
      Cipher.Burn;
      //retrieve strings
      lStr := lTempList.Text;
      lPos := 0;
      repeat
        lHealthCondition := TAMGHealthCondition.Create;
        lHealthCondition.Code := GetNextField;
        lHealthCondition.FConditionName := GetNextField;
        lHealthCondition.FConditionDescription := GetNextField;
        lHealthCondition.FActionPlan := GetNextField;
        lHealthCondition.FConditionWebURL := GetNextField;
        lIsUserAdded := GetNextField;
        if lIsUserAdded <> '' then
          lHealthCondition.FIsUserAdded := StrToBool(lIsUserAdded)
        else
          lHealthCondition.FIsUserAdded := False;
        Self.Add(lHealthCondition);
      until lStr = '';
    finally
      if Assigned(lTempList) then
        FreeAndNil(lTempList);
      if Assigned(Cipher) then
        FreeAndNil(Cipher);
    end;
  end;
  Result := True;
end;

function TAMGHealthConditions.SaveToFile: Boolean;
//This methode could be useful if you want to edit condition details
var
  lTempList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lHealthCondition: TAMGHealthCondition;
begin
  lTempList := TStringList.Create;
  Cipher := TDCP_Rijndael.Create(nil);
  try
    for i := 0 to Self.Count -1 do
    begin
      lHealthCondition := TAMGHealthCondition(Self.Items[i]);
      lTempList.Add(lHealthCondition.GetHealthConditionCode + AMG_PIPE +
                    lHealthCondition.FConditionName + AMG_PIPE +
                    lHealthCondition.FConditionDescription + AMG_PIPE +
                    lHealthCondition.FActionPlan + AMG_PIPE +
                    lHealthCondition.FConditionWebURL + AMG_PIPE +
                    BoolToStr(lHealthCondition.FIsUserAdded) + AMG_PIPE);
    end;
    {encrypt}
    Cipher.InitStr(KeyStrRt, TDCP_sha1);         // initialize the cipher with a hash of the passphrase
    lTempList.Text := Cipher.EncryptString(lTempList.Text);
    Cipher.Burn;
    lTempList.SaveToFile(AMG_HEALTH_ISSUE_FILE);
  finally
    if Assigned(Cipher) then
      FreeAndNil(Cipher);
    if Assigned(lTempList) then
      FreeAndNil(lTempList);
  end;
end;

{ TAMGStudentHealthConditions }

function TAMGStudentHealthConditions.GetIssueIndex(const pStudentCode, pIssueCode: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Self.Count - 1 do
  begin
    if (TAMGStudentHealthCondition(Self.Items[i]).StudentCode = pStudentCode) and
       (TAMGStudentHealthCondition(Self.Items[i]).FHealthConditionCode = pIssueCode) then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function TAMGStudentHealthConditions.RefreshFromFile: Boolean;
var
  lTempList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lStudentHealthCondition: TAMGStudentHealthCondition;
  lHHSP: string;
  lIIPS: string;
begin
  inherited RefreshFromFile;
  Result := False;
  Self.Clear;
  if FileExists(AMG_STUDENT_HEALTH_FILE) then
  begin
    lTempList := TStringList.Create;
    Cipher:= TDCP_Rijndael.Create(nil);
    try
      lTempList.LoadFromFile(AMG_STUDENT_HEALTH_FILE);
      //decrypt string
      Cipher.InitStr(KeyStrRt,TDCP_sha1);   // initialize the cipher with a hash of the passphrase
      lTempList.Text := Cipher.DecryptString(lTempList.Text);
      Cipher.Burn;
      //retrieve strings
      for i := 0 to lTempList.Count - 1 do
      begin
        lStudentHealthCondition := TAMGStudentHealthCondition.Create;
        lStudentHealthCondition.FStudentCode := GetSubStr(lTempList.Strings[i], 1, AMG_PIPE);
        lStudentHealthCondition.FHealthConditionID := StrToInt(GetSubStr(lTempList.Strings[i], 2, AMG_PIPE));
        lStudentHealthCondition.FHealthConditionCode := GetSubStr(lTempList.Strings[i], 3, AMG_PIPE);
        lStudentHealthCondition.FStudentHealthNote := GetSubStr(lTempList.Strings[i], 4, AMG_PIPE);
        lHHSP := GetSubStr(lTempList.Strings[i], 5, AMG_PIPE);
        if lHHSP <> '' then
          lStudentHealthCondition.FHasHealthSupportPlan := StrToBool(lHHSP)
        else
          lStudentHealthCondition.FHasHealthSupportPlan := False;

        lStudentHealthCondition.FKeySuportPerson := GetSubStr(lTempList.Strings[i], 6, AMG_PIPE);
        lStudentHealthCondition.FEmergencyContact := GetSubStr(lTempList.Strings[i], 7, AMG_PIPE);
        lStudentHealthCondition.FEmergencyContactNo := GetSubStr(lTempList.Strings[i], 8, AMG_PIPE);
        lStudentHealthCondition.FOtherRelevantInfo := GetSubStr(lTempList.Strings[i], 9, AMG_PIPE);
        lIIPS := GetSubStr(lTempList.Strings[i], 10, AMG_PIPE);
        if lIIPS <> '' then
          lStudentHealthCondition.FIsInPeerSupport := StrToBool(lIIPS)
        else
          lStudentHealthCondition.FIsInPeerSupport := False;
        Self.Add(lStudentHealthCondition);
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

function TAMGStudentHealthConditions.SaveToFile: Boolean;
var
  lTempList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lStudentHealthCondition: TAMGStudentHealthCondition;
begin
  lTempList := TStringList.Create;
  Cipher := TDCP_Rijndael.Create(nil);
  try
    for i := 0 to Self.Count -1 do
    begin
      lStudentHealthCondition := TAMGStudentHealthCondition(Self.Items[i]);
      lTempList.Add(lStudentHealthCondition.FStudentCode + AMG_PIPE +
                    IntToStr(lStudentHealthCondition.FHealthConditionID) + AMG_PIPE +
                    lStudentHealthCondition.FHealthConditionCode + AMG_PIPE +
                    lStudentHealthCondition.FStudentHealthNote + AMG_PIPE +
                    BoolToStr(lStudentHealthCondition.FHasHealthSupportPlan) + AMG_PIPE +
                    lStudentHealthCondition.FKeySuportPerson + AMG_PIPE +
                    lStudentHealthCondition.FEmergencyContact + AMG_PIPE +
                    lStudentHealthCondition.FEmergencyContactNo + AMG_PIPE +
                    lStudentHealthCondition.FOtherRelevantInfo + AMG_PIPE +
                    BoolToStr(lStudentHealthCondition.FIsInPeerSupport));
    end;
    {encrypt}
    Cipher.InitStr(KeyStrRt, TDCP_sha1);         // initialize the cipher with a hash of the passphrase
    lTempList.Text := Cipher.EncryptString(lTempList.Text);
    Cipher.Burn;
    lTempList.SaveToFile(AMG_STUDENT_HEALTH_FILE);
  finally
    if Assigned(Cipher) then
      FreeAndNil(Cipher);
    if Assigned(lTempList) then
      FreeAndNil(lTempList);
  end;
end;

{ TAMGStudentHealthCondition }

procedure TAMGStudentHealthCondition.Assign(pSource: TAMGStudentHealthCondition);
begin
  if Assigned(pSource) then
  begin
    Self.ID := pSource.ID;
    Self.FStudentCode := pSource.FStudentCode;
    Self.FHealthConditionID := pSource.FHealthConditionID;
    Self.FHealthConditionCode := pSource.FHealthConditionCode;
    Self.FStudentHealthNote := pSource.FStudentHealthNote;
    //Self.LastUpdatedDate := pSource.LastUpdatedDate;
  end;
end;

end.
