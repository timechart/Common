unit BlockTeachers;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ComCtrls, StdCtrls, Buttons, ExtCtrls, Menus, ppParameter,
  ppBands, ppCtrls, GIFImg, ppVar, ppPrnabl, ppClass, ppCache, ppProd, ppReport,
  ppDB, ppComm, ppRelatv, ppDBJIT, Contnrs, uAMGCommon;

type
  TBlockTeachers = class;

  TFrmBlockTeachers = class(TForm)
    pnlBlockteachersButtons: TPanel;
    btnBlockTeachersClose: TBitBtn;
    popBlockTeachers: TPopupMenu;
    popBlockTeachersCopy: TMenuItem;
    pipBlockTeachers: TppJITPipeline;
    ppJITBlockName: TppField;
    ppJITSubjectName: TppField;
    ppJITNoOfStudents: TppField;
    ppJITTeacherName: TppField;
    repBlockTeachers: TppReport;
    ppHeaderBand1: TppHeaderBand;
    lblSchoolName: TppLabel;
    ppLabel2: TppLabel;
    ppLabel3: TppLabel;
    ppLabel4: TppLabel;
    ppLine1: TppLine;
    ppLabel1: TppLabel;
    ppSystemVariable1: TppSystemVariable;
    ppLabel5: TppLabel;
    imgSchoolLogo: TppImage;
    ppLine2: TppLine;
    ppShape1: TppShape;
    ppShape2: TppShape;
    ppDetailBand1: TppDetailBand;
    ppDBText1: TppDBText;
    ppDBText2: TppDBText;
    ppDBText3: TppDBText;
    ppDBText4: TppDBText;
    ppLine3: TppLine;
    ppShape3: TppShape;
    ppShape4: TppShape;
    ppFooterBand1: TppFooterBand;
    ppParameterList1: TppParameterList;
    popBlockTeachersPrintPreview: TMenuItem;
    popBlockTeachersPrint: TMenuItem;
    lblBlockFile: TppLabel;
    lblTeachersAllocated: TLabel;
    trvBlockTeachers: TTreeView;
    procedure FormShow(Sender: TObject);
    //procedure ListView1AdvancedCustomDrawItem(Sender: TCustomListView;
      //Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      //var DefaultDraw: Boolean);
    procedure CopyBlockTeachersToClipboard(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    function PopulateFieldData(aFieldName: string): Variant;
    procedure PrintPreviewReport(Sender: TObject);
    procedure PrintReport(Sender: TObject);
  private
    FBlocks: Integer;
    FLevels: Integer;
    TeachersToClipboard: TStringList;
    FBlockTeachers: TBlockTeachers;
    procedure SetNodeState(node: TTreeNode; Flags: Integer);
    function GetFieldValue(pRecIndex: Integer; const pFieldName: string): Variant;
    procedure PrintBlockTeachers(const pOutputType: TOutputType);
    procedure RefreshBlockTeachers;
  public
    property Blocks: Integer read FBlocks write FBlocks;
    property Levels: Integer read FLevels write FLevels;
  end;


  TBlockTeacher = class
  private
    FTeacherName: string;
    FSubjectName: string;
    FNoOfStud: Integer;
    FBlockName: string;
  public
    property BlockName: string read FBlockName write FBlockName;
    property SubjectName: string read FSubjectName write FSubjectName;
    property NoOfStud: Integer read FNoOfStud write FNoOfStud;
    property TeacherName: string read FTeacherName write FTeacherName;
  end;

  TBlockTeachers = class(TObjectList)
  end;
var
  FrmBlockTeachers: TFrmBlockTeachers;

implementation

uses
  TimeChartGlobals, TCommon2, uAMGTeacher, uAMGSubject, CommCtrl, Clipbrd;

{$R *.dfm}

procedure TFrmBlockTeachers.CopyBlockTeachersToClipboard(Sender: TObject);
begin
  genText := '';
  studText := '';
  genText := TeachersToClipboard.GetText;
  studText := Copy(genText, 1, Length(genText));
  CopyTextToClipboard(cfBlock);
end;

procedure TFrmBlockTeachers.FormCreate(Sender: TObject);
begin
  TeachersToClipboard := TStringList.Create;
  FBlockTeachers := TBlockTeachers.Create;
end;

procedure TFrmBlockTeachers.FormDestroy(Sender: TObject);
begin
  if Assigned(TeachersToClipboard) then
    FreeAndNil(TeachersToClipboard);
  if Assigned(FBlockTeachers) then
    FreeAndNil(FBlockTeachers);
end;

procedure TFrmBlockTeachers.FormShow(Sender: TObject);
begin
  RefreshBlockTeachers;
end;

function TFrmBlockTeachers.GetFieldValue(pRecIndex: Integer; const pFieldName: string): Variant;
begin
  //lFieldIndex := lFieldList.IndexOf(aFieldName);
  if pFieldName = 'fldBlockName' then
    Result := TBlockTeacher(FBlockTeachers.Items[PRecIndex -1]).FBlockName
  else if pFieldName = 'fldSubjectName' then
    Result := TBlockTeacher(FBlockTeachers.Items[PRecIndex -1]).FSubjectName
  else if pFieldName = 'fldNoOfStudents' then
    Result := TBlockTeacher(FBlockTeachers.Items[PRecIndex -1]).FNoOfStud
  else if pFieldName = 'fldTeacherName' then
    Result := TBlockTeacher(FBlockTeachers.Items[PRecIndex -1]).FTeacherName;
end;

{procedure TFrmBlockTeachers.ListView1AdvancedCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  Stage: TCustomDrawStage; var DefaultDraw: Boolean);
var
  year : integer;
  sign : string;
begin
  year := StrToInt(item.SubItems[0]) ;
  sign := item.SubItems[1];

  //20th century blue FONT COLOR
  if year < 2000 then
    Sender.Canvas.Font.Color := clBlue
  else
    Sender.Canvas.Font.Color := clRed;

  //bold "aquarius"
  if sign = 'Aquarius' then
    Sender.Canvas.Font.Style := Sender.Canvas.Font.Style + [fsBold];
end;}

function TFrmBlockTeachers.PopulateFieldData(aFieldName: string): Variant;
begin
  Result := GetFieldValue(pipBlockTeachers.RecordIndex, aFieldName);
end;

procedure TFrmBlockTeachers.PrintBlockTeachers(const pOutputType: TOutputType);
begin
  lblSchoolName.Caption := School;
  lblBlockFile.Caption := 'Block File: ' + BlockFile;
  repBlockTeachers.DeviceType := GetDeviceType(pOutputType);
  repBlockTeachers.Print;
end;

procedure TFrmBlockTeachers.PrintPreviewReport(Sender: TObject);
begin
  PrintBlockTeachers(otScreen);
end;

procedure TFrmBlockTeachers.PrintReport(Sender: TObject);
begin
  PrintBlockTeachers(otPrinter);
end;

procedure TFrmBlockTeachers.RefreshBlockTeachers;
var
  i: Integer;
  j: Integer;
  k: Integer;
  l: Integer;
  m: Integer;
  tmpStr: string;
  lRow: Integer;
  lCol: Integer;
  lSubject: string;
  lSubjectName: string;
  lStudNo: Integer;
  lNodeBlock: TTreeNode;
  lNodeSubject: TTreeNode;
  lNodeTeacher: TTreeNode;
  lPtr: Pointer;
  lTeacher: TAMGTeacher;
  lBlockStr: string;
  lSubDetails: string;
  lTeacherDetails: string;
  lTempStr: string;
  lBlockTeacher: TBlockTeacher;
  lAddRec: Boolean;
  lFound: Boolean;

  procedure UpdateBlockTeacher;
  begin
    TeachersToClipboard.Add(lTempStr);
    lBlockTeacher := TBlockTeacher.Create;
    lBlockTeacher.BlockName := lBlockStr;
    lBlockTeacher.SubjectName := lSubDetails;
    lBlockTeacher.NoOfStud := lStudNo;
    lBlockTeacher.TeacherName := lTeacherDetails;
    FBlockTeachers.Add(lBlockTeacher);
    lAddRec := True;
  end;

begin
  Self.Caption := Self.Caption + ' - ' + Blockfile;
  TeachersToClipboard.Clear;
  trvBlockTeachers.Items.BeginUpdate;  // keep the node from painting until it's built
  lFound := False;
  try
    for i := 1 to Blocks do
    begin
      lNodeBlock := TTreeNode.Create(trvBlockTeachers.Items);
      lBlockStr := 'Block ' + IntToStr(i);
      trvBlockTeachers.Items.AddNode(lNodeBlock, nil, lBlockStr, lPtr, naAdd);
      SetNodeState(lNodeBlock, TVIS_BOLD or TVIS_CUT);
      for j := 1 To Levels do
      begin
        lTeacherDetails := '';
        lSubDetails := '';
        k := Sheet[i, j];
        lSubject := SubCode[k];
        lSubjectName := Trim(SubName[k]);

        if Trim(lSubject) <> '' then
        begin
          lTempStr := '';
          lTempStr := lTempStr + lBlockStr + ',';
          lStudNo := GroupSubCount[GsubXref[k]];
          lNodeSubject := TTreeNode.Create(trvBlockTeachers.Items);
          if lSubjectName <> '' then
            lSubjectName := ' ('  + lSubjectName + ')';
          lSubDetails := lSubject + lSubjectName;
          trvBlockTeachers.Items.AddNode(lNodeSubject, lNodeBlock, lSubDetails+ '   ' + IntToStr(lStudNo), lPtr, naAddChild);
          lTempStr := lTempStr + lSubDetails + ',' + IntToStr(lStudNo) + ',';
          lAddRec := False;
          for l := 0 to Teachers.Count -1 do
          begin
            lTeacher := TAMGTeacher(Teachers.Items[l]);
            lTeacherDetails := '';
            for m := 0 to lTeacher.Subjects.Count - 1 do
            begin
              if TAMGSubject(lTeacher.Subjects.Items[m]).ID = k then
              begin
                lNodeTeacher := TTreeNode.Create(trvBlockTeachers.Items);
                lTeacherDetails := lTeacher.TeacherName + ' (' + Trim(lTeacher.Code) + ')';
                trvBlockTeachers.Items.AddNode(lNodeTeacher, lNodeSubject, lTeacherDetails, lPtr, naAddChild);
                lTempStr := lTempStr + lTeacherDetails;
                SetNodeState(lNodeTeacher, TVIS_BOLD);
                lFound := True;

                UpdateBlockTeacher;
              end;
            end;  // for m
          end;  // for l
          if not lAddRec then
          begin
            UpdateBlockTeacher;
          end;
        end;
      end;
    end;
  finally
    if trvBlockTeachers.Items.Count > 0 then
    begin
      trvBlockTeachers.Items.EndUpdate;
      trvBlockTeachers.FullExpand;
      trvBlockTeachers.Items.GetFirstNode.MakeVisible;
      lblTeachersAllocated.Visible := not lFound;
  pipBlockTeachers.InitialIndex := 1;
  pipBlockTeachers.RecordCount := FblockTeachers.Count;
    end;
  end;
end;

procedure TFrmBlockTeachers.SetNodeState(node: TTreeNode; Flags: Integer);
var
  tvi: TTVItem;
begin
  FillChar(tvi, SizeOf(tvi), 0);
  tvi.hItem := node.ItemID;
  tvi.Mask := TVIF_STATE;
  tvi.StateMask := TVIS_BOLD or TVIS_CUT;
  tvi.State := Flags;
  TreeView_SetItem(node.Handle, tvi);
end;

end.
