unit SchoolLogo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons;

type
  TFrmSchoolLogo = class(TForm)
    imgLogo: TImage;
    btnOK: TBitBtn;
    OpenDialog: TOpenDialog;
    btnClose: TBitBtn;
    btnAssignImage: TButton;
    lblPrompt: TLabel;
    procedure SaveSchoolLogo(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AssignImage(Sender: TObject);
  private
    FLogoFile: string;
    FImageFile: string;
  end;

var
  FrmSchoolLogo: TFrmSchoolLogo;

implementation

uses
  uAMGGlobal, uAMGConst, uAMGAttendance;

{$R *.dfm}

procedure TFrmSchoolLogo.AssignImage(Sender: TObject);
begin
  //OpenDialog.Filter := 'Bitmap(*.bmp)|*.bmp|Gif(*.gif)|*.gif';
  OpenDialog.Title := 'Load School Logo';
  OpenDialog.InitialDir := DataDir;
  if OpenDialog.Execute = True then
  begin
    FImageFile := OpenDialog.FileName;
    imgLogo.Picture.LoadFromFile(FImageFile);
    btnOK.Enabled := True;
  end;
end;

procedure TFrmSchoolLogo.SaveSchoolLogo(Sender: TObject);
var
  lFileExt: string;
  lDestPath: string;
begin
  lDestPath := DataDir + '\' + AMG_IMAGES;
  if not DirectoryExists(lDestPath) then
    ForceDirectories(lDestPath);
  if FileExists(FImageFile) then
  begin
    lFileExt := ExtractFileExt(FImageFile);
  end;
  FLogoFile := lDestPath + '\SchoolLogo' + lFileExt;
  if CopyFile(PAnsiChar(FImageFile), PAnsiChar(FLogoFile), False) then
  begin
    AttendanceSetup.SchoolLogo := FLogoFile;
    AttendanceSetup.SaveToFile;
    MessageDlg('School logo has been saved.', mtInformation, [mbOK], 0);
  end
  else
  begin
    MessageDlg('School logo has not been saved. Please try again', mtInformation, [mbOK], 0);
  end;
end;

procedure TFrmSchoolLogo.FormShow(Sender: TObject);
begin
  if FileExists(AttendanceSetup.SchoolLogo) then
  begin
    imgLogo.Picture.LoadFromFile(AttendanceSetup.SchoolLogo);
    btnOK.Enabled := True;
  end
  else
  begin
    imgLogo.Picture := nil;
    btnOK.Enabled := False;
  end;
end;

end.
