unit ExportToCASES21;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFrmExportCASES21 = class(TForm)
    btnExport: TButton;
    btnCancel: TButton;
    chkExcludeNonTtabledChoices: TCheckBox;
    lblPrompt: TLabel;
    chkCases21Spec: TCheckBox;
    procedure RefreshPrompt(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FExcludeNonTimetabledChoices: Boolean;
    FCases21Spec: Boolean;
  public
    property ExcludeNonTimetabledChoices: Boolean read FExcludeNonTimetabledChoices write FExcludeNonTimetabledChoices;
    property Cases21Spec: Boolean read FCases21Spec write FCases21Spec;
  end;

var
  FrmExportCASES21: TFrmExportCASES21;

implementation

{$R *.dfm}

procedure TFrmExportCASES21.FormShow(Sender: TObject);
begin
  RefreshPrompt(Self);
end;

procedure TFrmExportCASES21.RefreshPrompt(Sender: TObject);
begin
  if chkExcludeNonTtabledChoices.Checked then
    lblPrompt.Caption := 'Non-timetabled student choices will not be exported.'
  else
    lblPrompt.Caption := 'Use this option only when you have student choices that do not exist in the timetable.';
  FExcludeNonTimetabledChoices := chkExcludeNonTtabledChoices.Checked;
  FCases21Spec := chkCases21Spec.Checked;
end;

end.
