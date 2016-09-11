unit BulkRenameSubjects;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls, uAMGSubject;

type
  TFrmBulkRenameSubjects = class(TForm)
    lblBulkRenameMsg: TLabel;
    pnlControls: TPanel;
    pnlGrid: TPanel;
    pnlButtons: TPanel;
    btnBulkRenameOK: TBitBtn;
    btnBulkRenameCancel: TBitBtn;
    lblFind: TLabel;
    edtFindText: TEdit;
    lblReplaceWith: TLabel;
    edtReplaceText: TEdit;
    lsvBulkRenameSubjects: TListView;
    lblShowMeTheList: TLabel;
    rgpSelectSubjects: TRadioGroup;
    chkNames: TCheckBox;
    rgpReplaceCreate: TRadioGroup;
    procedure DoBulkRenameSubjects(Sender: TObject);
    procedure PrepareSave(Sender: TObject);
    procedure SupressSpaceChar(Sender: TObject; var Key: Char);
    procedure DisplayListAfterReplacement(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SetSelectedSubjects(Sender: TObject);
    procedure RefreshSubjectList(Sender: TObject);
    procedure RefreshSave(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DisableCheck(Sender: TObject; Item: TListItem; Change: TItemChange; var AllowChange: Boolean);
  private
    FSubjects: TAMGSubjects;
    FAlreadyUsed: Boolean;
    FSubjectToRename: string;
    procedure EnableSave;
    function IsCodeAlreadyUsed(var pNewCode: string; pOldNo, pNewNo: Integer): Boolean;
  public
    property SubjectToRename: string read FSubjectToRename write FSubjectToRename;
  end;

var
  FrmBulkRenameSubjects: TFrmBulkRenameSubjects;

implementation

uses
  TCglobals, uAMGConst, tcommon, TCLoad, Main;

{$R *.dfm}

function TFrmBulkRenameSubjects.IsCodeAlreadyUsed(var pNewCode: string; pOldNo, pNewNo: Integer): Boolean;
var
  lNewCodeNo: Integer;
begin
  Result := False;
  lNewCodeNo := CheckCode(pNewNo, pNewCode);
  if ((lNewCodeNo > 0) and (pOldNo <> lNewCodeNo)) then  //code already in use
  begin
    Result := True;
  end;
end;

procedure TFrmBulkRenameSubjects.DisableCheck(Sender: TObject; Item: TListItem; Change: TItemChange; var AllowChange: Boolean);
begin
  if Assigned(Item) then
    if (Change = ctState) and (Item.Indent = 1)then
      AllowChange := False;
end;

procedure TFrmBulkRenameSubjects.RefreshSave(Sender: TObject);
begin
  EnableSave;
end;

procedure TFrmBulkRenameSubjects.DisplayListAfterReplacement(Sender: TObject);
var
  lFindStr: string;
  lNewCode: string;
  lReplaceStr: string;
  i: Integer;
  lSubNo: Integer;
  lListItem: TlistItem;
  lSubject: TAMGSubject;
begin
  lsvBulkRenameSubjects.Clear;
  if (edtFindText.Text <> ' ') then
  begin
    lFindStr := Trim(edtFindText.Text);
  end else begin
    lFindStr := edtFindText.Text;
  end;
  lReplaceStr := Trim(edtReplaceText.Text);

  for i := 1 to CodeCount[0] do
  begin
    if UpperCase(SubCode[CodePoint[i, 0]]) <> AMG_NA_SUBJECT then
    begin
      if Pos(lFindStr, SubCode[CodePoint[i, 0]]) > 0 then
      begin
        lSubNo := CodePoint[i, 0];
        if not (Copy(SubCode[lSubNo], 1, 2) = '00') then
        begin
          lNewCode := UpperCase(StringReplace(SubCode[lSubNo], lFindStr, lReplaceStr, [rfReplaceAll, rfIgnoreCase]));
          lNewCode := Copy(TrimRight(lNewCode), 1, LenCodes[0]);
          lListItem := lsvBulkRenameSubjects.Items.Add;
          lListItem.Caption := SubCode[lSubNo];
          lSubject := TAMGSubject.Create;
          lSubject.ID := lSubNo;

          lSubject.Code := lNewCode;
          lListItem.SubItems.Add(lSubject.Code);

          if chkNames.Checked then
            lSubject.SubjectFullName := StringReplace(Subname[lSubNo], lFindStr, lReplaceStr, [rfReplaceAll, rfIgnoreCase])
          else
            lSubject.SubjectFullName := SubName[lSubNo];
          lListItem.SubItems.Add(lSubject.SubjectFullName);

          lSubject.ReportSubjectCode := StringReplace(SubReportCode[lSubNo], lFindStr, lReplaceStr, [rfReplaceAll, rfIgnoreCase]);
          lListItem.SubItems.Add(lSubject.ReportSubjectCode);

          if chkNames.Checked then
            lSubject.ReportSubjectName := StringReplace(SubReportName[lSubNo], lFindStr, lReplaceStr, [rfReplaceAll, rfIgnoreCase])
          else
            lSubject.ReportSubjectName := SubReportName[lSubNo];
          lListItem.SubItems.Add(lSubject.ReportSubjectName);
          if IsCodeAlreadyUsed(lNewCode, lSubject.ID, 0) then
          begin
            lListItem.SubItems.Add('The new code is already used');
            lListItem.Indent := 1;   // Could be done on object level
          end
          else
          begin
            lListItem.Checked := True;
            lListItem.Indent := 2;
          end;
          lListItem.Data := Pointer(lSubject);
        end
        else
        begin
        end;
      end;
    end;
  end;  // for
  EnableSave;
end;

procedure TFrmBulkRenameSubjects.DoBulkRenameSubjects(Sender: TObject);
var
  tmpStr: string;
  tmpInt: Integer;
  i: Integer;
  lListItem: TListItem;
  lSubject: TAMGSubject;
  lSubNo: Integer;
  lNewPlace: Integer;
begin
 for i := 0 to lsvBulkRenameSubjects.Items.count - 1 do
  begin
    if lsvBulkRenameSubjects.Items[i].Checked then
    begin
      if rgpReplaceCreate.ItemIndex = 0 then    //Replace
      begin
        lSubject := TAMGSubject(lsvBulkRenameSubjects.Items[i].Data);
        SubCode[lSubject.ID] := lSubject.Code;
        Subname[lSubject.ID] := lSubject.SubjectFullName;
        SubReportCode[lSubject.ID] := lSubject.ReportSubjectCode;
        SubReportName[lSubject.ID] := lSubject.ReportSubjectName;
      end
      else  // Create new subjects
      begin
        lSubject := TAMGSubject(lsvBulkRenameSubjects.Items[i].Data);
        if TooMany('subject codes', codeCount[0], nmbrSubjects) then Exit;
        if Trim(lSubject.Code) <> '' then
        begin
          lNewPlace := FindNextCode(0);
          if UpperCase(Trim(lSubject.Code)) = 'NA' then
            subNA := lNewPlace;

          Subcode[lNewPlace] := lSubject.Code;
          Subname[lNewPlace] := lSubject.SubjectFullName;
          if NumSubRepCodes > 0 then
          begin
            SubReportCode[lNewPlace] := lSubject.ReportSubjectCode;
            SubReportName[lNewPlace] := lSubject.ReportSubjectName;
          end
          else
          begin
            SubReportCode[lNewPlace] := lSubject.Code;
            SubReportName[lNewPlace] := lSubject.SubjectFullName;
          end;
          Link[lNewPlace] := 0;

          if NumSubRepCodes > 0 then
            NumSubRepCodes := NumCodes[0];
          InsertCode(0, lNewPlace);
          AlterTimeFlag := True;
          AlterWSflag := True;
        end;
      end;
    end;
  end;  // for

  SortCodes(0);
  //update font widths if necessary
  tmpInt := MainForm.Canvas.TextWidth(lSubject.Code);
  if tmpint > fwCode[0] then fwCode[0] := tmpint;
  if tmpint > fwCodeBlank[0]then fwCodeBlank[0] := tmpInt;
  tmpInt := MainForm.Canvas.TextWidth(tmpStr);
  if tmpInt > fwCodename[0] then fwCodename[0] := tmpInt;
  tmpInt := mainform.canvas.textwidth(SubReportCode[lSubject.ID]);
  if tmpInt > fwReportCode then fwReportCode := tmpInt;
  tmpInt := mainform.canvas.textwidth(SubReportName[lSubject.ID]);
  if tmpInt > fwReportName then fwReportName := tmpInt;

  UpdateAllWins;

  UpdateSub(0); //update subject data files
  GetSubjectCodes;
  btnBulkRenameOK.Enabled := False;
end;

procedure TFrmBulkRenameSubjects.EnableSave;
var
  i: Integer;
  lFound: Boolean;
begin
  lFound := False;
  for i := 0 to lsvBulkRenameSubjects.Items.Count - 1 do
  begin
    if lsvBulkRenameSubjects.Items[i].Checked then
    begin
      lFound := True;
      Break;
    end;
  end;
  btnBulkRenameOK.Enabled := (lsvBulkRenameSubjects.Items.Count > 0) and (lFound);
  rgpReplaceCreate.Enabled := btnBulkRenameOK.Enabled;
end;

procedure TFrmBulkRenameSubjects.FormCreate(Sender: TObject);
begin
  FSubjects := TAMGSubjects.Create;
  edtFindText.MaxLength := LenCodes[0];
  edtReplaceText.MaxLength := LenCodes[0];
  lsvBulkRenameSubjects.Color := clRelevantControlOnDlg;
  FSubjectToRename := '';
end;

procedure TFrmBulkRenameSubjects.FormDestroy(Sender: TObject);
begin
  if Assigned(FSubjects) then
    FreeAndNil(FSubjects);
end;

procedure TFrmBulkRenameSubjects.FormShow(Sender: TObject);
begin
  if FSubjectToRename <> '' then
    edtFindText.Text := FSubjectToRename;
end;

procedure TFrmBulkRenameSubjects.SetSelectedSubjects(Sender: TObject);
  procedure SelectAll(const pChecked: Boolean);
  var
    i: Integer;
  begin
    for i:= 0 to lsvBulkRenameSubjects.Items.Count - 1 do
      lsvBulkRenameSubjects.Items[i].Checked := pChecked;
  end;
begin
  case rgpSelectSubjects.ItemIndex of
    0: SelectAll(True);
    1: SelectAll(False);
  end;
  EnableSave;
end;

procedure TFrmBulkRenameSubjects.SupressSpaceChar(Sender: TObject; var Key: Char);
begin
   if Key = Chr(32) then Key := Chr(0) ;
end;

procedure TFrmBulkRenameSubjects.PrepareSave(Sender: TObject);
var
  lEnable: Boolean;
begin
  lEnable := ((Copy(Trim(edtFindText.Text), 1, 2) <> '00') and (Trim(edtFindText.Text) <> '') and
             (Copy(Trim(edtReplaceText.Text), 1, 2) <> '00') and (Trim(edtReplaceText.Text) <> '') and
             (Trim(edtFindText.Text) <> Trim(edtReplaceText.Text)) and
             (Trim(edtReplaceText.Text) <> AMG_NA_SUBJECT))
              or
              ((edtFindText.Text = ' ') and (edtReplaceText.Text = ''));
  lblShowMeTheList.Enabled := lEnable;
end;

procedure TFrmBulkRenameSubjects.RefreshSubjectList(Sender: TObject);
begin
   if lsvBulkRenameSubjects.Items.Count > 0 then
     DisplayListAfterReplacement(Self);
end;

end.
