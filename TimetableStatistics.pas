unit TimetableStatistics;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Grids;

type
  TFrmTimetableStatistics = class(TForm)
    grdTTStatistics: TStringGrid;
    pnlButtons: TPanel;
    btnClose: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SortList(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure AlignText(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
  private
    FSortColumn: Integer;
    FAscending: Boolean;
    procedure RefreshStatistics;
    function GetAMLoad(const pSubjectCode: string): Integer;
    function GetAMAverageLoad: Integer;
    function GetPMLoad(const pSubjectCode: string): Integer;
    function GetPMAverageLoad: Integer;
    procedure FormatGridCell(ACol, ARow: Integer; Rect: TRect; State: TGridDrawState; AColour: TColor);
  end;

var
  FrmTimetableStatistics: TFrmTimetableStatistics;

implementation

uses
  uAMGSubject, uAMGCommon, TCommon, TimeChartGlobals;

{$R *.dfm}

procedure TFrmTimetableStatistics.AlignText(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if ARow = 0 then
  begin
    DisplayGridText(grdTTStatistics, Rect, grdTTStatistics.Cells[ACol, ARow], taCenter);
  end;
  FormatGridCell(ACol, ARow, Rect, State, clFuchsia);
end;

procedure TFrmTimetableStatistics.FormCreate(Sender: TObject);
begin
  grdTTStatistics.ColWidths[0] := 12;
  grdTTStatistics.ColWidths[1] := 80;   //Code
  grdTTStatistics.ColWidths[2] := 260;  //Name
  grdTTStatistics.ColWidths[3] := 70;   //AM load of subject
  grdTTStatistics.ColWidths[4] := 95;   //AM Average of All
  grdTTStatistics.ColWidths[5] := 70;   //PM load of subject
  grdTTStatistics.ColWidths[6] := 95;   //PM Average of All
  grdTTStatistics.RowHeights[0] := 18;  //PM Average
  grdTTStatistics.Cells[1, 0] := 'Subject Code';
  grdTTStatistics.Cells[2, 0] := 'Subject Name';
  grdTTStatistics.Cells[3, 0] := 'AM Load';
  grdTTStatistics.Cells[4, 0] := 'AM Average Load';
  grdTTStatistics.Cells[5, 0] := 'PM Load';
  grdTTStatistics.Cells[6, 0] := 'PM Average Load';
  FSortColumn := 0;
end;

procedure TFrmTimetableStatistics.FormShow(Sender: TObject);
begin
  RefreshStatistics;
end;

function TFrmTimetableStatistics.GetAMAverageLoad: Integer;
begin
  //code
end;

function TFrmTimetableStatistics.GetAMLoad(const pSubjectCode: string): Integer;
begin
 {dayuse := dg[MyDayGroup,1];
 longtimeformat:='h:mmam/pm';
 for i:=1 to nmbrperiods do grdTimeSlot.cells[0,i]:='  '+inttostr(i);
 for i:=1 to Tlimit[dayuse] do
  begin
   grdTimeSlot.cells[1,i]:=tsName[dayuse,i-1];
   grdTimeSlot.cells[2,i]:=tsCode[dayuse,i-1];
   str(tsAllot[dayuse,i-1]:tmpSlotUnitMain:tmpSlotUnitDec,astr);
   grdTimeSlot.cells[3,i]:=trim(astr);
   grdTimeSlot.cells[4,i]:=TimeToStr(tsStart[dayuse,i-1]);
   grdTimeSlot.cells[5,i]:=TimeToStr(tsEnd[dayuse,i-1]);
  end;}
end;

function TFrmTimetableStatistics.GetPMAverageLoad: Integer;
begin
  Result := 0;
end;

function TFrmTimetableStatistics.GetPMLoad(const pSubjectCode: string): Integer;
begin
  Result := 0;
end;

procedure TFrmTimetableStatistics.SortList(Sender: TObject;  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  lCol: Integer;
  lRow: Integer;
begin
  grdTTStatistics.MouseToCell(X, Y, lCol, lRow);
  if (lRow = 0) and (lCol <> 4) and (lCol <> 6)then
  begin
    if FSortColumn <> lCol then
      FAscending := True;
    SortStringGrid(grdTTStatistics, lCol, FAscending);
    FAscending := not FAscending;
    FSortColumn := lCol;
  end;
end;

procedure TFrmTimetableStatistics.RefreshStatistics;
var
  i: Integer;
  lAMAverage: Integer;
  lAMAverageLoad: Integer;
  lPMAverageLoad: Integer;
begin
  lAMAverageLoad := GetAllSubjectsAverageLoad(True);
  lPMAverageLoad := GetAllSubjectsAverageLoad(False);
  for i := 0 to Subjects.Count - 1 do
  begin
    grdTTStatistics.RowCount := grdTTStatistics.RowCount + 1;
    grdTTStatistics.Cells[1, i + 1] := TAMGSubject(Subjects.Items[i]).Code;
    grdTTStatistics.Cells[2, i + 1] := TAMGSubject(Subjects.Items[i]).SubjectFullName;
    grdTTStatistics.Cells[3, i + 1] := IntToStr(GetAverageSubjectLoad(True, TAMGSubject(Subjects.Items[i]).Code));
    grdTTStatistics.Cells[4, i + 1] := IntToStr(lAMAverageLoad);
    grdTTStatistics.Cells[5, i + 1] := IntToStr(GetAverageSubjectLoad(False, TAMGSubject(Subjects.Items[i]).Code));
    grdTTStatistics.Cells[6, i + 1] := IntToStr(lPMAverageLoad);
  end;
  if grdTTStatistics.RowCount > 2 then
    grdTTStatistics.RowCount := grdTTStatistics.RowCount - 1;
end;

procedure TFrmTimetableStatistics.FormatGridCell(ACol, ARow: Integer; Rect: TRect; State: TGridDrawState; AColour: TColor);
var
  lStr: string;
begin
  if (ARow > 0) and (ACol > 0) then
  begin
    lStr := grdTTStatistics.Cells[ACol, ARow];
    with grdTTStatistics do
    begin
      Canvas.FillRect(Rect);
      if (ACol = 1) or (ACol = 2) then
        Canvas.Font.Color := AColour
      else
        Canvas.Font.Color := clBlack;
      Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, lStr);
    end;
  end;
  if ARow = 0 then
    DisplayGridText(grdTTStatistics, Rect, grdTTStatistics.Cells[ACol, ARow], taCenter);
end;

end.
