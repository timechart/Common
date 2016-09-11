unit DestinationDir;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFrmDestinationFile = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    lblDestination: TLabel;
    edtDestination: TEdit;
    btnSelectDir: TButton;
    procedure SelectTargetDirectory(Sender: TObject);
    procedure SaveFileName(Sender: TObject);
  private
    FDestinationFile: string;
  public
    property DestinationFile: string read FDestinationFile write FDestinationFile;
  end;

var
  FrmDestinationFile: TFrmDestinationFile;

implementation

uses
  FileCtrl;

{$R *.dfm}

procedure TFrmDestinationFile.SaveFileName(Sender: TObject);
begin
  FDestinationFile := edtDestination.Text;
end;

procedure TFrmDestinationFile.SelectTargetDirectory(Sender: TObject);
var
  lDir: string;
begin
  FDestinationFile := '';
  //if SelectDirectory(lDir, [sdAllowCreate], 0) then
  if SelectDirectory('Select directory', 'C:\',  lDir, [sdNewFolder, sdValidateDir]) then
  begin
    edtDestination.Text := lDir;
  end;


end;

end.
