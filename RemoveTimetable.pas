unit RemoveTimetable;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, XML.UTILS;

type
  TFrmRemoveTimetable = class(TForm)
    cboTimetables: TComboBox;
    btnClose: TBitBtn;
    btnDelete: TBitBtn;
    lblTimetableName: TLabel;
    procedure FormShow(Sender: TObject);
    procedure RemoveTimetable(Sender: TObject);
  private
    FTimetableInUse: string;
  public
    property TimetableInUse: string read FTimetableInUse write FTimetableInUse;
  end;

var
  FrmRemoveTimetable: TFrmRemoveTimetable;

implementation

uses
  TimeChartGlobals, uAMGConst, TCommon;

{$R *.dfm}

procedure TFrmRemoveTimetable.FormShow(Sender: TObject);
var
  fsRec: Tsearchrec;
  FROMdir1, ttwName: string;
begin
  cboTimetables.Clear;
  fsRec.Name := '';
  FROMdir1 := Directories.datadir;
  if FROMdir1[length(FROMdir1)] <> '\' then
     FROMdir1 := FROMdir1 + '\';
  FindFirst(FROMdir1 + '*.ttw', faArchive, fsRec);
  while (fsRec.Name > '') do
  begin
    ttwName := UpperCase(fsrec.Name);
    ttwName := Copy(ttwName, 1, Pos('.TTW', ttwName) - 1);  //just the filename - no extension
    if ttwName <> UpperCase(AMG_TTABLE) then
      cboTimetables.Items.Add(ttwName);

    if FindNext(fsRec) <> 0 then fsRec.Name := '';
  end; //while
  SysUtils.FindClose(fsRec);

  if cboTimetables.Items.Count > 0 then
    cboTimetables.ItemIndex := 0;
end;

procedure TFrmRemoveTimetable.RemoveTimetable(Sender: TObject);
var
  lSelectedTtable: string;
begin
  lSelectedTtable := Trim(UpperCase(cboTimetables.Text));
  if lSelectedTtable = Trim(UpperCase(FTimetableInUse)) then
  begin
    MessageDlg(Format(AMG_CURRENTLY_INUSE_MSG, [lSelectedTtable]), mtInformation, [mbOK], 0);
  end
  else if lSelectedTtable = UpperCase(FileNames.LoadedTimeTable) then
  begin
    MessageDlg(Format(AMG_CURRENTLY_OPEN_TTABLE_MSG, [lSelectedTtable]), mtInformation, [mbOK], 0);
    ModalResult := mrNone;
  end
  else
  begin
    if MessageDlg(Format('You are about to delete %s timetable. Are you sure you want to continue?', [lSelectedTtable]), mtConfirmation, mbYesNo, 0) = mrYes then
    begin
      if FileExists(lSelectedTtable + '.NAM') then
        DeleteFile(lSelectedTtable + '.NAM');
      if FileExists(lSelectedTtable + '.LAB') then
        DeleteFile(lSelectedTtable + '.LAB');
      if FileExists(lSelectedTtable + '.CLS') then
        DeleteFile(lSelectedTtable + '.CLS');
      if FileExists(lSelectedTtable + '.TWS') then
        DeleteFile(lSelectedTtable + '.TWS');
      if FileExists(lSelectedTtable + '.TTW') then
        DeleteFile(lSelectedTtable + '.TTW');
      Application.ProcessMessages;
      MessageDlg(Format('Timetable %s has been deleted.', [lSelectedTtable]), mtError, [mbOK], 0);
      if lSelectedTtable = UpperCase(FileNames.LoadedTimeTable) then
        UpdateTtableWindow;
      ModalResult := mrOK;
    end
    else
    begin
      ModalResult := mrNone;
    end;
  end;
end;

end.
