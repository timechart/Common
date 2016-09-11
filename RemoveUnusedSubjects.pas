unit RemoveUnusedSubjects;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, uAMGSubject;

type
  TFrmRemoveUnusedSubjects = class(TForm)
    lsvUnusedSubjects: TListView;
    pnlControls: TPanel;
    pnlButtons: TPanel;
    btnRemove: TButton;
    btnCancel: TButton;
    lblPrompt: TLabel;
    lblUnusedSubjectCount: TLabel;
    lblUsedSubjectCount: TLabel;
    lblTotalSubjectCount: TLabel;
    lblTotalSubjectCountCap: TLabel;
    lblUsedSubjectCountCap: TLabel;
    lblUnusedSubjectCountCap: TLabel;
    rgpSelectSubjects: TRadioGroup;
    procedure FormShow(Sender: TObject);
    procedure RemoveUnusedSubjects(Sender: TObject);
    procedure SetSelectedSubjects(Sender: TObject);
    procedure SetupRemoveButton(Sender: TObject; Item: TListItem; Change: TItemChange);
  private
    FUnusedSubjects: TAMGSubjects;
    FTotalSubCount: Integer;
    FUsedSubCount: Integer;
  public
    property UnusedSubjects: TAMGSubjects read FUnusedSubjects write FUnusedSubjects;
    property TotalSubCount: Integer read FTotalSubCount write FTotalSubCount;
    property UsedSubCount: Integer read FUsedSubCount write FUsedSubCount;
  end;

var
  FrmRemoveUnusedSubjects: TFrmRemoveUnusedSubjects;

implementation

{$R *.dfm}

uses
  DelSCode;


procedure TFrmRemoveUnusedSubjects.FormShow(Sender: TObject);
var
  lListItem: TListItem;
  i: Integer;
  lSubject: TAMGSubject;
begin
  for i := 0 to FUnusedSubjects.Count - 1 do
  begin
    lListItem := lsvUnusedSubjects.Items.Add;
    lSubject := TAMGSubject(FUnusedSubjects.Items[i]);
    lListItem.Caption := lSubject.Code;
    lListItem.SubItems.Add(lSubject.SubjectFullName);
    lListItem.Checked := True;
    lListItem.Data := Pointer(lSubject);
  end;

  lblTotalSubjectCount.Caption := IntToStr(FTotalSubCount);
  lblUsedSubjectCount.Caption := IntToStr(FUsedSubCount);
  lblUnusedSubjectCount.Caption := IntToStr(lsvUnusedSubjects.Items.Count);
end;

procedure TFrmRemoveUnusedSubjects.SetupRemoveButton(Sender: TObject; Item: TListItem; Change: TItemChange);
var
  i: Integer;
  lChkCount: Integer;
begin
  lChkCount := 0;
  for i:= 0 to lsvUnusedSubjects.Items.Count - 1 do
    if lsvUnusedSubjects.Items[i].Checked then
    begin
      Inc(lChkCount);
      Break;
    end;
  btnRemove.Enabled := lChkCount > 0;
end;

procedure TFrmRemoveUnusedSubjects.RemoveUnusedSubjects(Sender: TObject);
var
  lSubCountText: string;
  lSelectedSubjected: TAMGSubjects;
  i: Integer;
begin
  DelSCodeDlg := TDelSCodeDlg.Create(Application);
  ModalResult := mrOK;
  try
    lSelectedSubjected := TAMGSubjects.Create;
    for i := 0 to lsvUnusedSubjects.Items.Count - 1 do
    begin
      if lsvUnusedSubjects.Items[i].Checked then
        lSelectedSubjected.Add(TAMGSubject(lsvUnusedSubjects.Items[i].Data));
    end;

    if lSelectedSubjected.Count = 1 then
      lSubCountText := IntToStr(lSelectedSubjected.Count) + ' Subject. It is not assigned to any student and does '
    else
      lSubCountText := IntToStr(lSelectedSubjected.Count) + ' Subjects. They are not assigned to any student and do ';

    if MessageDlg('Time Chart is about to delete ' + lSubCountText  + 'not exist in the current timetable. ' + #10#13 +
                  'Please make sure they do not exist in any other timetable. ' + #10#13#10#13 +
                  'Click Yes when you are ready otherwise click No.', mtConfirmation, mbYesNo, 0) = mrYes then
    begin
      lblPrompt.Caption := 'Please wait while Time Chart is removing unused subjects...';
      Application.ProcessMessages;
      DelSCodeDlg.DeleteUnusedSubjects(lSelectedSubjected);
    end
    else
      ModalResult := mrNone;
  finally
    FreeAndNil(DelSCodeDlg);
  end;
end;

procedure TFrmRemoveUnusedSubjects.SetSelectedSubjects(Sender: TObject);
  procedure SelectAll(const pChecked: Boolean);
  var
    i: Integer;
  begin
    for i:= 0 to lsvUnusedSubjects.Items.Count - 1 do
      lsvUnusedSubjects.Items[i].Checked := pChecked;
  end;
begin
  case rgpSelectSubjects.ItemIndex of
    0: SelectAll(True);
    1: SelectAll(False);
  end;
end;

end.
