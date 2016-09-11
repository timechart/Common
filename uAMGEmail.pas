unit uAMGEmail;

interface

uses
  uAMGItem;

type
  TAMGEmail = class(TAMGItem)
  public
    constructor Create; override;
    destructor Destroy; override;
    function Refresh: Boolean; override;
  end;

  TAMGEmails = class(TAMGItemList)
  private
    FEmailHost: string;
    FEmailUserID: string;
    FEmailPassword: string;
    FEmailSender: string;
    FEmailDisplayName: string;
    FPort: Integer;
  public
    function Refresh: Boolean; override;
    function RefreshFromFile: Boolean; override;
    function SaveToFile: Boolean;
    property EmailHost: string read FEmailHost write FEmailHost;
    property EmailUserID: string read FEmailUserID write FEmailUserID;
    property EmailPassword: string read FEmailPassword write FEmailPassword;
    property EmailSender: string read FEmailSender write FEmailSender;
    property EmailDisplayName: string read FEmailDisplayName write FEmailDisplayName;
    property Port: Integer read FPort write FPort;
  end;

var
  Email: TAMGEmail;
  Emails: TAMGEmails;

implementation

uses
  Classes, DCPrijndael, DCPSha1, SysUtils, uAMGConst, uAMGGlobal, TCommon;

{ TAMGEmail }

constructor TAMGEmail.Create;
begin
  inherited;

end;

destructor TAMGEmail.Destroy;
begin

  inherited;
end;

function TAMGEmail.Refresh: Boolean;
begin
  Result := inherited Refresh;

end;

{ TAMGEmails }

function TAMGEmails.Refresh: Boolean;
begin
  Result := inherited Refresh;
end;

function TAMGEmails.RefreshFromFile: Boolean;
var
  lTempList: TStringList;
  Cipher: TDCP_Rijndael;
  lCurrentDir: string;
  i: Integer;
begin
  inherited RefreshFromFile;
  lCurrentDir := GetCurrentDir;
  try
    ChDir(DataDir);
    if FileExists(AMG_EMAIL_SETUP_FILE) then
    begin
      lTempList := TStringList.Create;
      Cipher:= TDCP_Rijndael.Create(nil);
      try
        lTempList.LoadFromFile(AMG_EMAIL_SETUP_FILE);
        //decrypt string
        Cipher.InitStr(KeyStrRt,TDCP_sha1);   // initialize the cipher with a hash of the passphrase
        lTempList.Text := Cipher.DecryptString(lTempList.Text);
        Cipher.Burn;
        //retrieve strings
          Self.FEmailHost := lTempList.Strings[0];
          if lTempList.Count > 1 then
            Self.FEmailUserID := lTempList.Strings[1];
          if lTempList.Count > 2 then
            Self.EmailPassword := lTempList.Strings[2];
          if lTempList.Count > 3 then
            Self.EmailSender := lTempList.Strings[3];
          if lTempList.Count > 4 then
            Self.EmailDisplayName := lTempList.Strings[4];
          if lTempList.Count > 5 then
            Self.Port := StrToInt(lTempList.Strings[5]);
      finally
        if Assigned(lTempList) then
          FreeAndNil(lTempList);
        if Assigned(Cipher) then
          FreeAndNil(Cipher);
      end;
      Result := True;
    end;
  finally
    ChDir(lCurrentDir);
  end;
end;

function TAMGEmails.SaveToFile: Boolean;
var
  TempList: Tstrings;
  Cipher: TDCP_Rijndael;
  KeyStr: string;
begin
  Result := False;
  TempList := TStringList.Create;	{ construct the list object }
  Cipher:= TDCP_Rijndael.Create(nil);
  try
    ChDir(DataDir);
    TempList.Add(Emails.EmailHost);
    TempList.Add(Emails.EmailUserID);
    TempList.Add(Emails.EmailPassword);
    TempList.Add(Emails.EmailSender);
    TempList.Add(Emails.EmailDisplayName);
    TempList.Add(IntToStr(Emails.Port));
    {encrypt}
    KeyStr := KeyStrRt;
    Cipher.InitStr(KeyStr, TDCP_sha1);         // initialize the cipher with a hash of the passphrase
    TempList.text:= Cipher.EncryptString(TempList.text);
    Cipher.Burn;
    TempList.SaveToFile(AMG_EMAIL_SETUP_FILE);
  finally
    if Assigned(Cipher) then
      FreeAndNil(Cipher);
  end;
    if Assigned(TempList) then
      FreeAndNil(TempList);
  end;
end.
