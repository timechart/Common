unit CASES21ExportDataView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, NiceGrid, Contnrs, StdCtrls, Grids, XML.UTILS;

type
  TFrmCASES21ExportDataView = class(TForm)
    grdQuilt: TNiceGrid;
    grdSubjectSelections: TNiceGrid;
    lblQuiltLabel: TLabel;
    lblSubjectSelectionLabel: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FDataFound: Boolean;
    procedure RefreshData;
  end;

  TQuiltLine = class(TObject)
  private
    FSubjectCode: string;
    FClassNo: Integer;
    FTeachertCode: string;
    FRoomCode: string;
    FDayNo: Integer;
    FPeriodNo: Integer;
  public
    property SubjectCode: string read FSubjectCode write FSubjectCode;
    property ClassNo: Integer read FClassNo write FClassNo;
    property TeachertCode: string read FTeachertCode write FTeachertCode;
    property RoomCode: string read FRoomCode write FRoomCode;
    property DayNo: Integer read FDayNo write FDayNo;
    property PeriodNo: Integer read FPeriodNo write FPeriodNo;
  end;

  TQuiltLines = class(TObjectList)
  public
    FExportList: TStringList;
    function RefreshFromExport: Boolean;
  end;

  TSubjectSelection = class(TObject)
  private
    FStudentID: string;
    FSubjectCode: string;
    FClassNo: Integer;
  public
    property StudentID: string read FStudentID write FStudentID;
    property SubjectCode: string read FSubjectCode write FSubjectCode;
    property ClassNo: Integer read FClassNo write FClassNo;
  end;

  TSubjectSelections = class(TObjectList)
  public
    FExportList: TStringList;
    function RefreshFromExport: Boolean;
  end;

var
  FrmCASES21ExportDataView: TFrmCASES21ExportDataView;

implementation

uses
  TimeChartGlobals, uAMGCommon;

{$R *.dfm}

procedure TFrmCASES21ExportDataView.FormCreate(Sender: TObject);
begin
  RefreshData;
end;

procedure TFrmCASES21ExportDataView.FormShow(Sender: TObject);
begin
  if not FDataFound then
  begin
    MessageDlg('No CASES21 export data were found.', mtInformation, [mbOK], 0);
    Self.Close;
  end;
end;

procedure TFrmCASES21ExportDataView.RefreshData;
var
  lDataList: TStringList;
  lCurrentDir: string;
  lQuiltLines: TQuiltLines;
  lQuiltLine: TQuiltLine;
  lSubjectSelections: TSubjectSelections;
  lSubjectSelection: TSubjectSelection;
  i: Integer;
begin
  lCurrentDir := GetCurrentDir;
  try
    SetCurrentDir(Directories.DataDir);
    lDataList := TStringList.Create;
    FDataFound := False;
    try
      if FileExists('Quilt.Txt') then
      begin
        lQuiltLines := TQuiltLines.Create;
        try
          lDataList.Clear;
          lDataList.LoadFromFile('Quilt.Txt');
          lQuiltLines.FExportList := lDataList;
          lQuiltLines.RefreshFromExport;
          grdQuilt.Clear;
          grdQuilt.RowCount := lQuiltLines.Count;
          FDataFound := lQuiltLines.Count > 0;
          for i := 0 to lQuiltLines.Count - 1 do
          begin
            lQuiltLine := TQuiltLine(lQuiltLines.Items[i]);
            grdQuilt[0, i] := lQuiltLine.FSubjectCode;
            grdQuilt[1, i] := IntToStr(lQuiltLine.FClassNo);
            grdQuilt[2, i] := lQuiltLine.FTeachertCode;
            grdQuilt[3, i] := lQuiltLine.FRoomCode;
            grdQuilt[4, i] := IntToStr(lQuiltLine.FPeriodNo);
            grdQuilt[5, i] := IntToStr(lQuiltLine.FDayNo);
          end;
        finally
          if Assigned(lQuiltLines) then
            FreeAndNil(lQuiltLines);
        end;
      end;

      if FileExists('Subject_Selections.txt') then
      begin
        lSubjectSelections := TSubjectSelections.Create;
        try
          lDataList.Clear;
          lDataList.LoadFromFile('Subject_Selections.txt');
          lSubjectSelections.FExportList := lDataList;
          lSubjectSelections.RefreshFromExport;
          grdSubjectSelections.Clear;
          grdSubjectSelections.RowCount := lSubjectSelections.Count;
          if not FDataFound then
            FDataFound := lSubjectSelections.Count > 0;
          for i := 0 to lSubjectSelections.Count - 1 do
          begin
            lSubjectSelection := TSubjectSelection(lSubjectSelections.Items[i]);
            grdSubjectSelections[0, i] := lSubjectSelection.FStudentID;
            grdSubjectSelections[1, i] := lSubjectSelection.FSubjectCode;
            grdSubjectSelections[2, i] := IntToStr(lSubjectSelection.FClassNo);
          end;
        finally
          if Assigned(lSubjectSelections) then
            FreeAndNil(lSubjectSelections);
        end;
      end;
    finally
      FreeAndNil(lDataList);
    end;
  finally
    SetCurrentDir(lCurrentDir);
  end;
end;

{ TQuiltLines }

function TQuiltLines.RefreshFromExport: Boolean;
var
  i: Integer;
  lLine: string;
  lQuiltLine: TQuiltLine;
begin
  Self.Clear;
  for i := 0 to FExportList.Count - 1 do
  begin
    lLine := FExportList.Strings[i];
    lQuiltLine := TQuiltLine.Create;
    lQuiltLine.FSubjectCode := GetSubStr(lLine, 1);
    lQuiltLine.FClassNo := StrToInt(GetSubStr(lLine, 2));
    lQuiltLine.FTeachertCode := GetSubStr(lLine, 3);
    lQuiltLine.FRoomCode := GetSubStr(lLine, 4);
    lQuiltLine.FPeriodNo := StrToInt(GetSubStr(lLine, 5));
    lQuiltLine.FDayNo := StrToInt(GetSubStr(lLine, 6));
    Self.Add(lQuiltLine);
  end;
end;

{ TSubjectSelections }

function TSubjectSelections.RefreshFromExport: Boolean;
var
  i: Integer;
  lLine: string;
  lSubjectSelection: TSubjectSelection;
begin
  Self.Clear;
  for i := 0 to FExportList.Count - 1 do
  begin
    lLine := FExportList.Strings[i];
    lSubjectSelection := TSubjectSelection.Create;
    lSubjectSelection.FStudentID := GetSubStr(lLine, 1);
    lSubjectSelection.FSubjectCode := GetSubStr(lLine, 2);
    lSubjectSelection.FClassNo := StrToInt(GetSubStr(lLine, 3));
    Self.Add(lSubjectSelection);
  end;
end;

end.
