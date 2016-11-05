unit ExportToTASS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XML.UTILS,GlobalToTcAndTcextra, XML.DISPLAY;

type
  TFrmExportTASS = class(TForm)
    btnExport: TButton;
    btnCancel: TButton;
    chkExcludeNonTtabledChoices: TCheckBox;
    lblPrompt: TLabel;
    procedure RefreshPrompt(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
  private
    FExcludeNonTimetabledChoices: Boolean;
    //FCases21Spec: Boolean;
  public
    property ExcludeNonTimetabledChoices: Boolean read FExcludeNonTimetabledChoices write FExcludeNonTimetabledChoices;
    //property Cases21Spec: Boolean read FCases21Spec write FCases21Spec;
  end;

var
  FrmExportTASS: TFrmExportTASS;

implementation

uses
  uAMGClassSubject, LoadProgress, TimeChartGlobals, TCommon, uAMGConst, TCommon2;

{$R *.dfm}

procedure TFrmExportTASS.btnExportClick(Sender: TObject);
{ Subject Selection
    Student ID              Mandatory       Varchar(7) Student ID, must be a valid student Id in CASES21
    Subject ID              Mandatory       Varchar(5) Subject ID, must be a valid subject ID in CASES21
    Numeric class number    Mandatory       Smallint Numeric class identifier

  Quilt
    Subject ID              Mandatory       Varchar(5) Subject ID, must be a valid subject ID in CASES21
    Numeric class id        Mandatory       Smallint Numeric class identifier
    Teacher ID              Mandatory       Varchar(4) Teacher ID, must be a valid staff ID in CASES21
    Room ID                 Mandatory       Varchar(4) Room ID, must be a valid room ID in CASES21
    Numeric period number   Mandatory       SmallInt Numeric period identifier
    Numeric day number      Mandatory       SmallInt Numeric day identifier
}

var
  //aStr,bStr: string;
  i,j,n,m: integer;
  lMsg: string;
  lList: TStringList;
  lStr: string;
  lSubject: string;
  lClassNo: Integer;
  lTeacher: string;
  lClassSubject: TAMGClassSubject;
  //lFrmSplitSubjectConv: TFrmSplitSubjectConv;
  lFrmLoadProgress: TFrmLoadProgress;
  lProgress: Integer;
  lPrevProgress: Integer;
  lTtabledSubjects: TStringList;
  lStudDataFound: Boolean;

  function GetSubject(var pSubject: string; var pClassNo: Integer): Boolean;
  var
    aClass:   string[1];
    aSubject: string;
    ClassPos : integer;
  begin
    Result := False;
    aSubject := pSubject;
    // Hide these for #274
//    lClassSubject := ClassSubjects.GetClassSubjectByID(pSubject);
//    if Assigned(lClassSubject) then
//    begin
//     pSubject := Trim(lClassSubject.SubjectCode);
//      pClassNo := lClassSubject.ClassNo;
//    end
//    else
    begin
      // #274 - need to allow for variable subject length  BUT CASES21 has char. length of 5
      //if (pCases21Spec) then
      //begin
      //  ClassPos:=6;
      //end else begin
        ClassPos:=lencodes[0];
      //end;

      //if (pCases21Spec) then begin
      //  pSubject := Trim(Copy(pSubject, 1, ClassPos-1));
      //end else begin
        pSubject := Trim(pSubject);
      //end;
      // #70 - fix for the Exporting of Class Number
      aClass   := Trim(Copy(aSubject, ClassPos, 1));
      if (aClass>'') then begin
        pClassNo := Ord(aClass[1])-64;
        if pClassNo<1 then pClassNo:=1;
      end else begin
        pClassNo := 1;
      end;
    end;
    Result := True;
  end;

  procedure RefreshTimetabledSubjects;
  var
    StrtYear, FinDay: Integer;
    YYear, d, p, L, a1: Integer;
    aFnt, bFnt: tpIntPoint;
  begin
      StrtYear := years - 1;
      FinDay := days - 1;
      for YYear := StrtYear downto 0 do
      begin
        for d := 0 to finday do
         for p := 1 to Tlimit[d] do
          for L := 1 to level[yyear] do
          begin
            aFnt := FNT(d, p-1, yyear, L, 0);
            bFnt := aFnt;
            a1 := bFnt^;
            if ((a1 > 0) and (a1 <= LabelBase)) then
            begin
              lSubject := Trim(SubCode[a1]);              ///Trim(FNsub(a1, 0));
              lSubject := Copy(lSubject, 1, lencodes[0]);
              GetSubject(lSubject, lClassNo);
              lTtabledSubjects.Add(lSubject);
            end;
          end; {for L}
      end;
  end;

  function DEETdumpTTableOut: Boolean;
  var
    StrtYear, FinYear, StrtDay, FinDay: Integer;
    YYear,d,p,L,a1: integer;
    aFnt,bFnt: tpIntPoint;
    tmpStr: string;
    lDataFound: Boolean;
  begin
    lDataFound := False;
    try
      lList.Clear;
      StrtYear := years - 1;
      FinYear := 0;
      StrtDay := 0;
      FinDay := days - 1;
      for YYear := StrtYear downto FinYear do
      begin
        for d := strtday to finday do
         for p := 1 to Tlimit[d] do
          for L := 1 to level[yyear] do
          begin
            lStr := '';
            aFnt := FNT(d,p-1,yyear,L,0);
            bFnt := aFnt;
            a1 := bFnt^;
            if ((a1>0) and (a1<=LabelBase)) then
            begin
              lSubject := Trim(FNsub(a1,0));
              lSubject := Copy(lSubject, 1, lencodes[0]);     //Copy(lSubject,1,lencodes[0] - 1);

              // Day
              lStr := Trim(IntToStr(d+1));

              // Period
              lStr := lStr + ',' + Trim(IntToStr(p));



              // Get Teacher
              bFnt := aFnt;
              Inc(bFnt,1);
              a1 := bFnt^;
              tmpStr := FNsub(a1,1);
              //if (pCases21Spec) then begin
              //  lTeacher := Copy(Trim(tmpStr), 1, 4);
              //end else begin
                lTeacher := Trim(tmpStr);
              //end;

              // Get Class number
              GetSubject(lSubject, lClassNo);

              // Yr/Subject
              lStr := lStr + ',' + yearname[YYear]+lSubject;

              // Yr
              lStr := lStr + ',' + yearname[YYear];

              // Class
              lStr := lStr + ',' + IntToStr(lClassNo);

              //3. now add them both Teacher
              lStr := lStr  + ',' +lTeacher;    //te

              // Room
              bFnt := aFnt;
              inc(bFnt,2);
              a1 := bFnt^;
              tmpStr := FNsub(a1,2);
              //if (pCases21Spec) then begin
              //  lStr := lStr + ',' + Copy(Trim(tmpStr), 1, 4);   //ro
              //end else begin
                lStr := lStr + ',' + Trim(tmpStr);
              //end;

              lList.Add(lStr);
              lDataFound := True;
            end;
          end; {for L}
      end;  // for Year
      if lDataFound then
      begin
        lFrmLoadProgress.UpdateProgress(25, Format(AMG_EXPORTING_YEAR_TTABLE_MSG, ['group', GOSname[GOSmenu[XML_DISPLAY.GroupIndexDisplay]]]), 900);
        lFrmLoadProgress.UpdateProgress(25, AMG_TIMETABLE_EXPORT_COMPLETE, 2500);
      end;
    finally
      lList.SaveToFile('TASS_Timetable.csv');
      Application.ProcessMessages;
      Result := lDataFound;
    end;
  end;

begin
  lList := TStringList.Create;
  lFrmLoadProgress := TFrmLoadProgress.Create(Application);
  lTtabledSubjects := TStringList.Create;
  //lFrmSplitSubjectConv := TFrmSplitSubjectConv.Create(Application);     // Afterwards conversion
  try
    //lFrmSplitSubjectConv.ClassSubjects := ClassSubjects;
    //lFrmSplitSubjectConv.RefreshClassSubjects;
    lFrmLoadProgress.Title := 'Export TASS Data';
    lFrmLoadProgress.Show;
    lProgress := 0;
    lPrevProgress := 0;
    ChDir(Directories.datadir);
    delim :=chr(XML_DISPLAY.Txtsep);
    delim2 :=chr(XML_DISPLAY.Txtlim);
    if XML_DISPLAY.Txtlim = 0 then delim2:='';
    lStudDataFound := False;
    RefreshTimetabledSubjects;
    for j := 1 to GroupNum do
    begin
      i := StGroup[j];
      lstr := '';
      lStr := Trim(Stud[i].stname);
      lStr := lStr + ',';
      lStr := lStr + Trim(Stud[i].first);
      lStr := lStr + ',';
      lStr := lStr + trim(Stud[i].Sex);
      lStr := lStr + ',';
      lStr := lStr + trim(Stud[i].ID);
      lStr := lStr + ',';
      lStr := lStr + Trim(YearName[Stud[i].TcYear]);
      lStr := lStr + ',';
      lStr := lStr + ''; // add a blank
      for n := 1 to chmax do
      begin
         // lStr := Trim(Stud[i].ID);
        m := Stud[i].Choices[n];
        if m <= 0 then continue;
        //if (pCases21Spec) then begin
        //  lStr := Copy(Trim(Stud[i].ID), 1, 7);  //skey   10 Char
        //end else begin
        //end;
        lSubject := Trim(SubCode[m]);
        GetSubject(lSubject, lClassNo);
        if not (chkExcludeNonTtabledChoices.Checked and (lTtabledSubjects.IndexOf(lSubject) = -1)) then
        begin
//          lStr := lStr + ',' + lSubject + ',' + IntToStr(lClassNo);
          lStr := lStr + ',' + lSubject;
//          lList.Add(lStr);
          lStudDataFound := True;
        end;
      end;
      if lStudDataFound then
      begin
        lList.Add(lStr);
      if j > 0 then
          lProgress := Round((50 * j) / GroupNum);
        lFrmLoadProgress.UpdateProgress(lProgress - lPrevProgress, Format(AMG_EXPORTING_SUBJECT_SELECTION_MSG, [Stud[i].ID]), 3);
        lPrevProgress := lProgress;
      end;
    end;
    lList.SaveToFile('TASS_Student_Subjects.csv');
    Application.ProcessMessages;
    if lStudDataFound then
    begin
      lMsg := Format(AMG_STUDENT_SUBJECTS_EXPORT_MSG, [lList.Count]);
      if lProgress < 50 then
      begin
        if lProgress = 0 then
        begin
          lProgress := 50;
          lMsg := AMG_NO_STUDENTS_TO_EXOPORT_MSG;
        end;
      end;
      lFrmLoadProgress.UpdateProgress(0, lMsg, 3000);
      lFrmLoadProgress.UpdateProgress(lProgress - lPrevProgress, lMsg, 10);
      lPrevProgress := lProgress;
    end;  // if
    if not DEETdumpTTableOut and not lStudDataFound then
      lMsg := AMG_NO_DATA_FOUND_MSG
    else
      lMsg := Format(AMG_DATA_EXPORTED_TO_CASES21_MSG, [QuotedStr(Directories.DataDir)]);
    MessageDlg(lMsg, mtInformation, [mbOK], 0);
  finally
    //FreeAndNil(lFrmSplitSubjectConv);
    FreeAndNil(lTtabledSubjects);
    FreeAndNil(lFrmLoadProgress);
    FreeAndNil(lList);
  end;
end;

procedure TFrmExportTASS.FormShow(Sender: TObject);
begin
  RefreshPrompt(Self);
end;

procedure TFrmExportTASS.RefreshPrompt(Sender: TObject);
begin
  if chkExcludeNonTtabledChoices.Checked then
    lblPrompt.Caption := 'Non-timetabled student choices will not be exported.'
  else
    lblPrompt.Caption := 'Use this option only when you have student choices that do not exist in the timetable.';
  FExcludeNonTimetabledChoices := chkExcludeNonTtabledChoices.Checked;
  //FCases21Spec := chkCases21Spec.Checked;
end;

end.
