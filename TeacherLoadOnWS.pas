unit TeacherLoadOnWS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ppParameter, ppBands, ppCtrls, ppVar, ppPrnabl, ppClass,
  ppCache, ppProd, ppReport, ppDB, ppComm, ppRelatv, ppDBJIT, Contnrs, uAMGCommon,
  ppStrtch, ppMemo,GlobalToTcAndTcextra;

type
  TTeacherLoads = class;

  TFrmTeacherLoadOnWS = class(TForm)
    pipTeacherLoadOnWS: TppJITPipeline;
    ppJITSubjectName: TppField;
    ppJITNoOfStudents: TppField;
    ppJITTeacherName: TppField;
    repTeacherLoadOnWS: TppReport;
    ppHeaderBand1: TppHeaderBand;
    lblSchoolName: TppLabel;
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
    ppDBText3: TppDBText;
    ppDBText4: TppDBText;
    ppLine3: TppLine;
    ppShape3: TppShape;
    ppShape4: TppShape;
    ppFooterBand1: TppFooterBand;
    ppParameterList1: TppParameterList;
    memTeacherSubjects: TppDBMemo;
    ppLine4: TppLine;
    ppLine5: TppLine;
    ppSystemVariable2: TppSystemVariable;
    lblTeachTotal: TppLabel;
    function PopulateFieldData(aFieldName: string): Variant;
    procedure FormCreate(Sender: TObject);
  private
    FTeacherLoads: TTeacherLoads;
    FSelectedTeacher: Integer;
    procedure RefreshTeacherLoad;
    function GetFieldValue(pRecIndex: Integer; const pFieldName: string): Variant;
    function GetTeacherSubjectsOnWS(const pTeacherNo: Integer): TStringList;
  public
    procedure PrintTeacherLoadOnWS(const pOutputType: TOutputType);
    property SelectedTeacher: Integer read FSelectedTeacher write FSelectedTeacher;
  end;

  TTeacherLoad = class
  private
    FTeacherLoad: Integer;
    FTeacherName: string;
    FSubjectList: string;
    FTeacherCode: string;
  public
    property TeacherCode: string read FTeacherCode write FTeacherCode;
    property TeacherName: string read FTeacherName write FTeacherName;
    property TeacherLoad: Integer read FTeacherLoad write FTeacherLoad;
    property SubjectList: string read FSubjectList write FSubjectList;
  end;

  TTeacherLoads = class(TObjectList)
  public
    function IndexOf(const pTeacherCode: string): Integer;
  end;

var
  FrmTeacherLoadOnWS: TFrmTeacherLoadOnWS;

implementation

uses
  uAMGTeacher, TCommon, TimeChartGlobals;

{$R *.dfm}

{ TForm1 }

procedure TFrmTeacherLoadOnWS.FormCreate(Sender: TObject);
begin
  FTeacherLoads := TTeacherLoads.Create;
end;

function TFrmTeacherLoadOnWS.GetFieldValue(pRecIndex: Integer; const pFieldName: string): Variant;
var
  lNoOfStud: Integer;
  i: Integer;
  lFieldIndex: Integer;
  lTeacherLoad: TTeacherLoad;
begin
  lTeacherLoad := TTeacherLoad(FTeacherLoads.Items[pRecIndex -1]);
  if pFieldName = 'fldTeacherName' then
    Result := lTeacherLoad.FTeacherName
  else if pFieldName = 'fldTeacherLoad' then
    Result := IntToStr(lTeacherLoad.FTeacherLoad)
  else if pFieldName = 'fldSubjectList' then
    Result := lTeacherLoad.FSubjectList;
end;

function TFrmTeacherLoadOnWS.GetTeacherSubjectsOnWS(const pTeacherNo: Integer): TStringList;
var
  b, y, l: Integer;
  lSubNo, lTeNo, lRoomNo: Integer;
  aFnt: TPIntPoint;
  lSubjects: string;
  lSubFound: string;
  lLongestLength: Integer;
  lTempList: TStringList;
begin
  lTempList := TStringList.Create;
  lLongestLength := GetLongestLength;
  lSubjects := '';
  for y := 0 to years_minus_1 do
  begin
    for b := 1 to Blocks[y] do
      for l:=1 to Level[y] do
      begin
        aFnt := FNws(b, y, l, 0);
        lSubNo := aFnt^;
        Inc(aFnt);
        lTeNo := aFnt^;
        Inc(aFnt);
        lRoomNo := aFnt^;

        if (lTeNo = pTeacherNo) and (lSubNo <> 0) then
        begin
          lSubFound := Trim(SubCode[lSubNo]);
          if Copy(lSubFound, 1, 2) <> '00' then
            if Pos(lSubFound, lSubjects ) = 0 then
            begin
              lSubjects := lSubjects + lSubFound;
              lTempList.Add(lSubFound + GetSpacesToAlign(Trim(lSubFound), lLongestLength) + ' ');
            end;
        end;
      end; // for
  end;  // for
  Result := lTempList;
end;

function TFrmTeacherLoadOnWS.PopulateFieldData(aFieldName: string): Variant;
begin
  Result := GetFieldValue(pipTeacherLoadOnWS.RecordIndex, aFieldName);
end;

procedure TFrmTeacherLoadOnWS.PrintTeacherLoadOnWS(const pOutputType: TOutputType);
begin
  RefreshTeacherLoad;
  lblSchoolName.Caption := School;
  repTeacherLoadOnWS.DeviceType := GetDeviceType(pOutputType);
  lblTeachTotal.Caption := 'Teacher Total: ' + IntToStr(FTeacherLoads.Count);
  repTeacherLoadOnWS.Print;
end;

procedure TFrmTeacherLoadOnWS.RefreshTeacherLoad;
var
  lSubNo: Integer;
  lTeNo: Integer;
  tmpStr: string;
  lTeacherLoad: TTeacherLoad;
  lTempList: TStringList;
  tefound: tpTeData;
  i: Integer;
  j: Integer;

  procedure CalculateTeClasses;
  var
    su, te:  Integer;
    b, y, l: Integer;
    afnt: tpIntPoint;
  begin
    FillChar(TeFound, sizeof(tefound), chr(0));

    for y := 0 to years_minus_1 do
    begin
      for b := 1 to Blocks[y] do
        for l:=1 to Level[y] do
        begin
          aFnt := FNws(b, y, l, 0);
          su := aFnt^;
          Inc(aFnt);
          te:=aFnt^;
          if ((su>0) and (su<=LabelBase) and (su<>subNA)) then
          begin
            Inc(tefound[te]);
          end;
        end; //for l
    end; //for y
  end;

begin
  FTeacherLoads.Clear;
  CalculateTeClasses;
  try
    for lTeNo := 1 to NumCodes[1] do
    begin
      i := CodePoint[lTeNo, 1];
      lTeacherLoad := TTeacherLoad.Create;
      if (Copy(TeCode[i, 0], 1, 2) <> '00') and (Trim(TeCode[i, 0]) <> '') then
      begin
         lTeacherLoad.TeacherCode := Trim(TeCode[i, 0]);
         lTeacherLoad.TeacherName := Trim(TeName[i, 0]) + ' (' + lTeacherLoad.TeacherCode + ')';
         lTeacherLoad.TeacherLoad := TeFound[i];
         lTempList := GetTeacherSubjectsOnWS(i);
         try
           for j := 0 to lTempList.Count - 1 do
           begin
             lTeacherLoad.SubjectList := lTeacherLoad.SubjectList + lTempList.Strings[j];
           end;
         finally
           FreeAndNil(lTempList);
         end;
         if FTeacherLoads.IndexOf(lTeacherLoad.TeacherCode) = -1 then
         begin
           if FSelectedTeacher > 0 then
           begin
             if FSelectedTeacher = i then
               FTeacherLoads.Add(lTeacherLoad);  //only selected teacher
           end
           else
           begin
             FTeacherLoads.Add(lTeacherLoad);
           end;
         end;
      end;
    end;
  finally
    pipTeacherLoadOnWS.InitialIndex := 1;
    pipTeacherLoadOnWS.RecordCount := FTeacherLoads.Count;
  end;


(*
  FTeacherLoads.Clear;
  CalculateTeClasses;
  try
    for y := 0 to yr do
    begin
      for b:= 1 to Blocks[y] do
        for l:=1 to Level[y] do
        begin
          lTeacherLoad := TTeacherLoad.Create;
          IntPoint := FNws(b, y, l, 0);
          lSubNo := IntPoint^;
          Inc(IntPoint);
          lTeNo := IntPoint^;
          Inc(IntPoint);
          lRoomNo := IntPoint^;
          if lSubNo <= LabelBase then   //normal entry
          begin
             tmpStr := '';   //subject code
             if ((lSubNo > 0) and (lSubNo <= NumCodes[0])) then
               tmpStr := SubCode[lSubNo];
             tmpStr:='';   //teacher code
             if ((lTeNo > 0) and (lTeNo <= NumCodes[1])) then
             begin
               lTeacherLoad.TeacherCode := Trim(TeCode[lTeNo, 0]);
               lTeacherLoad.TeacherName := Trim(TeName[lTeNo, 0]) + ' (' + lTeacherLoad.TeacherCode + ')';
               lTeacherLoad.TeacherLoad := TeFound[lTeNo];
               lTempList := GetTeacherSubjectsOnWS(lTeNo);
               try
                 for j := 0 to lTempList.Count - 1 do
                 begin
                   lTeacherLoad.SubjectList := lTeacherLoad.SubjectList + lTempList.Strings[j];
                 end;
               finally
                 FreeAndNil(lTempList);
               end;
               if FTeacherLoads.IndexOf(lTeacherLoad.TeacherCode) = -1 then
               begin
                 if FSelectedTeacher > 0 then
                 begin
                   if FSelectedTeacher = lTeNo then
                     FTeacherLoads.Add(lTeacherLoad);  //only selected teacher
                 end
                 else
                 begin
                   FTeacherLoads.Add(lTeacherLoad);
                 end;
               end;
             end;
          end;
        end;
    end;
  finally
    pipTeacherLoadOnWS.InitialIndex := 1;
    pipTeacherLoadOnWS.RecordCount := FTeacherLoads.Count;
  end;
*)

end;


{ TTeacherLoads }

function TTeacherLoads.IndexOf(const pTeacherCode: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Self.Count - 1 do
  begin
    if TTeacherLoad(Self.Items[i]).TeacherCode = pTeacherCode then
    begin
      Result := i;
      Break;
    end;
  end;
end;

end.
