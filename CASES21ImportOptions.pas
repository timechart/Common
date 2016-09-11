unit CASES21ImportOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFrmCASES21ImportOptions = class(TForm)
    btnImport: TButton;
    lblCancel: TButton;
    chkStudentData: TCheckBox;
    chkTeacherData: TCheckBox;
    chkStubjectData: TCheckBox;
    chkRoomData: TCheckBox;
    lblPrompot: TLabel;
    lblPrompt: TLabel;
    procedure SetupImportOptions(Sender: TObject);
  private
    FImportTeacherOK: Boolean;
    FImportRoomOK: Boolean;
    FImportStudentOK: Boolean;
    FImportSubjectOK: Boolean;
  public
    property ImportStudentOK: Boolean read FImportStudentOK write FImportStudentOK;
    property ImportTeacherOK: Boolean read FImportTeacherOK write FImportTeacherOK;
    property ImportSubjectOK: Boolean read FImportSubjectOK write FImportSubjectOK;
    property ImportRoomOK: Boolean read FImportRoomOK write FImportRoomOK;
  end;

var
  FrmCASES21ImportOptions: TFrmCASES21ImportOptions;

implementation

{$R *.dfm}

procedure TFrmCASES21ImportOptions.SetupImportOptions(Sender: TObject);
begin
  FImportStudentOK := chkStudentData.Checked;
  FImportTeacherOK := chkTeacherData.Checked;
  FImportSubjectOK := chkStubjectData.Checked;
  FImportRoomOK := chkRoomData.Checked;
end;

end.
