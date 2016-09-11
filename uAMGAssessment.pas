unit uAMGAssessment;

interface

uses
  uAMGItem, Classes;

type
  TAMGAssessment = class(TAMGItem)
  private
    FDescription: string;
    FShortcut: string;
    FAssessType: Integer;
  public
    property Description: string read FDescription write FDescription;
    property Shortcut: string read FShortcut write FShortcut;
    property AssessType: Integer read FAssessType write FAssessType;  //1 for Code, 2 for Descriptive
  end;

  TAMGAssessments = class(TAMGItemList)
  public
    function RefreshFromFile: Boolean; override;
    function SaveToFile: Boolean;
    function IndexOf(const pDescription: string): Integer; reintroduce;
    function RemoveItem(const pItem: TAMGAssessment): Boolean;
  end;

var
  Assessments: TAMGAssessments;

implementation

uses
  DCPrijndael, DCPSha1, uAMGConst, SysUtils, uAMGGlobal, uAMGCommon;

{ TAMGAssessments }

function TAMGAssessments.IndexOf(const pDescription: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Self.Count - 1 do
  begin
    if (TAMGAssessment(Self.Items[i]).FDescription = pDescription) then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function TAMGAssessments.RefreshFromFile: Boolean;
var
  lTempList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lAssessment: TAMGAssessment;
begin
  inherited RefreshFromFile;
  Result := False;
  Self.Clear;
  if FileExists(AMG_ASSESS_FILE) then
  begin
    lTempList := TStringList.Create;
    Cipher := TDCP_Rijndael.Create(nil);
    try
      lTempList.LoadFromFile(AMG_ASSESS_FILE);
      //decrypt string
      Cipher.InitStr(KeyStrRt,TDCP_sha1);
      lTempList.Text := Cipher.DecryptString(lTempList.Text);
      Cipher.Burn;
      //retrieve strings
      for i := 0 to lTempList.Count - 1 do
      begin
        lAssessment := TAMGAssessment.Create;
        lAssessment.Code := GetSubStr(lTempList.Strings[i], 1, AMG_PIPE);
        lAssessment.FDescription := GetSubStr(lTempList.Strings[i], 2, AMG_PIPE);
        lAssessment.FShortcut := GetSubStr(lTempList.Strings[i], 3, AMG_PIPE);
        lAssessment.FAssessType := StrToInt(GetSubStr(lTempList.Strings[i], 4, AMG_PIPE));
        Self.Add(lAssessment);
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

function TAMGAssessments.RemoveItem(const pItem: TAMGAssessment): Boolean;
var
  lItemIndex: Integer;
begin
  Result := False;
  lItemIndex := Self.IndexOf(pItem.FDescription);
  if lItemIndex > -1 then
  begin
    Self.Delete(lItemIndex);
    Self.SaveToFile;
    Result := True;
  end;
end;

function TAMGAssessments.SaveToFile: Boolean;
var
  lTempList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lAssessment: TAMGAssessment;
begin
  lTempList := TStringList.Create;
  Cipher:= TDCP_Rijndael.Create(nil);
  try
    ChDir(DataDir);
    for i := 0 to Self.Count -1 do
    begin
      lAssessment := TAMGAssessment(Self.Items[i]);
      lTempList.Add(lAssessment.Code + AMG_PIPE + lAssessment.FDescription + AMG_PIPE + lAssessment.FShortcut + AMG_PIPE + IntToStr(lAssessment.FAssessType));
    end;
    //encrypt
    Cipher.InitStr(KeyStrRt, TDCP_sha1);
    lTempList.Text := Cipher.EncryptString(lTempList.Text);
    Cipher.Burn;
    lTempList.SaveToFile(AMG_ASSESS_FILE);
  finally
    if Assigned(Cipher) then
      FreeAndNil(Cipher);
    if Assigned(lTempList) then
      FreeAndNil(lTempList);
  end;
end;

end.
