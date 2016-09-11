unit uAMGSysConfig;

interface

uses
  uAMGItem;

type
  TSysConfig = class(TAMGItem)
  private
    FSchoolLogo: string;
    FClassCodeLength: Integer;
  public
    constructor Create; override;
    function RefreshFromFile: Boolean;
    function SaveToFile: Boolean;
    property SchoolLogo: string read FSchoolLogo write FSchoolLogo;
    property ClassCodeLength: Integer read FClassCodeLength write FClassCodeLength;
  end;

var
  SysConfig: TSysConfig;

implementation

uses
  Classes, SysUtils, DCPrijndael, DCPSha1, uAMGConst, uAMGCommon;

{ TSysConfig }

constructor TSysConfig.Create;
begin
  inherited;
  Self.FClassCodeLength := 3; // Default Roll CLass length
end;

function TSysConfig.RefreshFromFile: Boolean;
var
  lList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lID: string;
  lClassCodeLen: string;
begin
  Result := False;
  if FileExists(AMG_TC_CONFIG_FILE) then
  begin
    lList := TStringList.Create;
    Cipher:= TDCP_Rijndael.Create(nil);
    try
      lList.LoadFromFile(AMG_TC_CONFIG_FILE);
      //decrypt string
      Cipher.InitStr(KeyStrRt, TDCP_sha1);   // initialize the cipher with a hash of the passphrase
      lList.Text := Cipher.DecryptString(lList.Text);
      Cipher.Burn;
      //retrieve strings
      for i := 0 to lList.Count - 1 do
      begin
        Self.FSchoolLogo := Trim(GetSubStr(lList.Strings[i], 1));
        lClassCodeLen := Trim(GetSubStr(lList.Strings[i], 2));
        if lClassCodeLen <> '' then
          Self.FClassCodeLength := StrToInt(lClassCodeLen);
      end;
    finally
      if Assigned(lList) then
        FreeAndNil(lList);
      if Assigned(Cipher) then
        FreeAndNil(Cipher);
      Result := True;
    end;
  end;
end;

function TSysConfig.SaveToFile: Boolean;
var
  lTempList: TStringList;
  Cipher: TDCP_Rijndael;
begin
  lTempList := TStringList.Create;
  Cipher:= TDCP_Rijndael.Create(nil);
  try
    lTempList.Add(FSchoolLogo + ',' + IntToStr(FClassCodeLength));
    {encrypt}
    Cipher.InitStr(KeyStrRt, TDCP_sha1);         // initialize the cipher with a hash of the passphrase
    lTempList.Text := Cipher.EncryptString(lTempList.Text);
    Cipher.Burn;
    lTempList.SaveToFile(AMG_TC_CONFIG_FILE);
  finally
    if Assigned(Cipher) then
      FreeAndNil(Cipher);
    if Assigned(lTempList) then
      FreeAndNil(lTempList);
  end;
end;

end.
