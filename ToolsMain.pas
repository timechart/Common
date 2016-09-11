unit ToolsMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls;

type
  TFrmToolsMain = class(TForm)
    MainMenu: TMainMenu;
    mnuFile: TMenuItem;
    mnuTools: TMenuItem;
    mniToolsDecryptFile: TMenuItem;
    mniToolsEncryptFile: TMenuItem;
    memMain: TMemo;
    OpenDialog: TOpenDialog;
    procedure DecryptDataFile(Sender: TObject);
    procedure EncryptDataFile(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmToolsMain: TFrmToolsMain;

implementation

uses
  DCPrijndael, DCPSha1, uAMGConst, DestinationDir;

{$R *.dfm}

procedure TFrmToolsMain.DecryptDataFile(Sender: TObject);
var
  lTempList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lFileName: string;
begin
  OpenDialog.Filter := 'Data Files | *.DAT';
  if OpenDialog.Execute then
  begin
    lFileName := OpenDialog.FileName;
    lTempList := TStringList.Create;
    Cipher:= TDCP_Rijndael.Create(nil);
    try
      lTempList.LoadFromFile(lFileName);
      //decrypt string
      Cipher.InitStr(KeyStrRt,TDCP_sha1);   // initialize the cipher with a hash of the passphrase
      lTempList.Text := Cipher.DecryptString(lTempList.Text);
      Cipher.Burn;
      memMain.Lines.Text := lTempList.Text;
      //retrieve strings
    finally
      if Assigned(lTempList) then
        FreeAndNil(lTempList);
      if Assigned(Cipher) then
        FreeAndNil(Cipher);
    end;
  end;
end;

procedure TFrmToolsMain.EncryptDataFile(Sender: TObject);
var
  lTempList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lFrmDestinationFile: TFrmDestinationFile;
begin
  lFrmDestinationFile := TFrmDestinationFile.Create(Application);
  try
    if lFrmDestinationFile.ShowModal = mrOK then
    begin

      if Trim(lFrmDestinationFile.DestinationFile) <> '' then

      lTempList := TStringList.Create;
      Cipher:= TDCP_Rijndael.Create(nil);
      try
        lTempList.Text := memMain.Lines.Text ;
        {encrypt}
        Cipher.InitStr(KeyStrRt, TDCP_sha1);         // initialize the cipher with a hash of the passphrase
        lTempList.Text := Cipher.EncryptString(lTempList.Text);
        Cipher.Burn;
        lTempList.SaveToFile(lFrmDestinationFile.DestinationFile);
      finally
        if Assigned(Cipher) then
          FreeAndNil(Cipher);
        if Assigned(lTempList) then
          FreeAndNil(lTempList);
      end;
    end;
  finally
    FreeAndNil(lFrmDestinationFile);
  end;
end;

end.
