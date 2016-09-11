unit uAMGReport;

interface

uses
  uAMGItem, Classes;

type
  //Report objects
  TAMGReport = class(TAMGItem)
  private
    FReportType: Integer;
    FSignRole: string;
    FKeepAssessmentBlank: Boolean;
    FReportTitleSL: string;
    FReportTitleRC: string;
    FReportTitleSR: string;
    FHideSchoolNameSL: Boolean;
    FHideSchoolNameRC: Boolean;
    FHideSchoolNameSR: Boolean;
    FCustomAddOnTitle2: string;
    FCustomAddOnTitle1: string;
    FAdditionalCommentLabel: string;
    FPercentageLabel: string;
    FLetterGradeLabel: string;
    FGradeLabel: string;
    FDescriptiveLabel: string;
    FNumericLabel: string;
  public
    function RefreshFromFile: Boolean;
    function SaveToFile: Boolean;
    property ReportType: Integer read FReportType write FReportType;
    property ReportTitleSR: string read FReportTitleSR write FReportTitleSR;
    property ReportTitleRC: string read FReportTitleRC write FReportTitleRC;
    property ReportTitleSL: string read FReportTitleSL write FReportTitleSL;
    property AdditionalCommentLabel: string read FAdditionalCommentLabel write FAdditionalCommentLabel;
    property HideSchoolNameSR: Boolean read FHideSchoolNameSR write FHideSchoolNameSR;
    property HideSchoolNameRC: Boolean read FHideSchoolNameRC write FHideSchoolNameRC;
    property HideSchoolNameSL: Boolean read FHideSchoolNameSL write FHideSchoolNameSL;
    property GradeLabel: string read FGradeLabel write FGradeLabel;
    property NumericLabel: string read FNumericLabel write FNumericLabel;
    property PercentageLabel: string read FPercentageLabel write FPercentageLabel;
    property LetterGradeLabel: string read FLetterGradeLabel write FLetterGradeLabel;
    property DescriptiveLabel: string read FDescriptiveLabel write FDescriptiveLabel;
    property CustomAddOnTitle1: string read FCustomAddOnTitle1 write FCustomAddOnTitle1;
    property CustomAddOnTitle2: string read FCustomAddOnTitle2 write FCustomAddOnTitle2;
    property SignRole: string read FSignRole write FSignRole;
    property KeepAssessmentBlank: Boolean read FKeepAssessmentBlank write FKeepAssessmentBlank;
  end;

  //Subject Mark objects
  TAMGSubjectMark = class(TAMGItem)
  private
    FTeacherCode: string;
    FStudentCode: string;
    FSubjectCode: string;
    FComment: string;
    FOtherActivities: string;
    FClassCode: string;
    FNumericVal: Integer;
    FCodeVal: string;
    FDescriptive: string;
    FPercentage: Integer;
    FLetterGrade: ShortString;
    FSubjectName: string;
    FCustomAddon2: string;
    FCustomAddon1: string;
    FCommentCount: Integer;
  public
    property StudentCode: string read FStudentCode write FStudentCode;
    property TeacherCode: string read FTeacherCode write FTeacherCode;
    property SubjectCode: string read FSubjectCode write FSubjectCode;
    property SubjectName: string read FSubjectName write FSubjectName;
    property Comment: string read FComment write FComment;
    property CommentCount: Integer read FCommentCount write FCommentCount;
    property CodeVal: string read FCodeVal write FCodeVal;
    property NumericVal: Integer read FNumericVal write FNumericVal;
    property Percentage: Integer read FPercentage write FPercentage;
    property LetterGrade: ShortString read FLetterGrade write FLetterGrade;
    property Descriptive: string read FDescriptive write FDescriptive;
    property CustomAddon1: string read FCustomAddon1 write FCustomAddon1;
    property CustomAddon2: string read FCustomAddon2 write FCustomAddon2;
  end;

  TAMGSubjectMarks = class(TAMGItemList)
  private
    procedure SortList;
  public
    function RefreshFromFile: Boolean; override;
    function SaveToFile: Boolean;
    function IndexOf(const pStudentCode, pSubjectCode: string): Integer; reintroduce;
    function RemoveItem(const pItemIndex: Integer): Boolean;
    function HasMarks(pStudentCode: string): Boolean;
  end;

  //Student Report objects
  TAMGStudentReport = class(TAMGItem)
  private
    FStudentCode: string;
    FClassCode: string;
    FOtherActivities: string;
    FDaysAbsent: Integer;
    FSubjectMarks: TAMGSubjectMarks;
    FStudentName: string;
  public
    property StudentCode: string read FStudentCode write FStudentCode;
    property ClassCode: string read FClassCode write FClassCode;
    property OtherActivities: string read FOtherActivities write FOtherActivities;
    property DaysAbsent: Integer read FDaysAbsent write FDaysAbsent;
    property SubjectMarks: TAMGSubjectMarks read FSubjectMarks  write FSubjectMarks;
  end;

  TAMGStudentReports = class(TAMGItemList)
  public
    function RefreshFromFile: Boolean; override;
    function SaveToFile: Boolean;
    function IndexOf(const pStudentCode: string): Integer;
  end;

var
  Report: TAMGReport;
  StudentReports: TAMGStudentReports;
  SubjectMarks: TAMGSubjectMarks;

implementation

uses
  DCPrijndael, DCPSha1, uAMGConst, SysUtils, uAMGCommon, uAMGGlobal;

{ TAMGReport }

function TAMGReport.RefreshFromFile: Boolean;
var
  lTempList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
begin
  Result := False;
  if FileExists(RWFile + '.RCF') then
  begin
    lTempList := TStringList.Create;
    Cipher := TDCP_Rijndael.Create(nil);
    try
      lTempList.LoadFromFile(RWFile + '.RCF');
      //decrypt string
      Cipher.InitStr(KeyStrRt,TDCP_sha1);
      lTempList.Text := Cipher.DecryptString(lTempList.Text);
      Cipher.Burn;
      //retrieve strings
      for i := 0 to lTempList.Count - 1 do
      begin
        FReportType := StrToInt(GetSubStr(lTempList.Strings[i], 1, AMG_PIPE));
        FReportTitleSR := GetSubStr(lTempList.Strings[i], 2, AMG_PIPE);
        FReportTitleRC := GetSubStr(lTempList.Strings[i], 3, AMG_PIPE);
        FReportTitleSL := GetSubStr(lTempList.Strings[i], 4, AMG_PIPE);
        FAdditionalCommentLabel := GetSubStr(lTempList.Strings[i], 5, AMG_PIPE);
        FHideSchoolNameSR := StrToBool(GetSubStr(lTempList.Strings[i], 6, AMG_PIPE));
        FHideSchoolNameRC := StrToBool(GetSubStr(lTempList.Strings[i], 7, AMG_PIPE));
        FHideSchoolNameSL := StrToBool(GetSubStr(lTempList.Strings[i], 8, AMG_PIPE));
        FGradeLabel := GetSubStr(lTempList.Strings[i], 9, AMG_PIPE);
        FNumericLabel := GetSubStr(lTempList.Strings[i], 10, AMG_PIPE);
        FPercentageLabel := GetSubStr(lTempList.Strings[i], 11, AMG_PIPE);
        FLetterGradeLabel := GetSubStr(lTempList.Strings[i], 12, AMG_PIPE);
        FDescriptiveLabel := GetSubStr(lTempList.Strings[i], 13, AMG_PIPE);
        FCustomAddOnTitle1 := GetSubStr(lTempList.Strings[i], 14, AMG_PIPE);
        FCustomAddOnTitle2 := GetSubStr(lTempList.Strings[i], 15, AMG_PIPE);
        FSignRole := GetSubStr(lTempList.Strings[i], 16, AMG_PIPE);
        FKeepAssessmentBlank := StrToBool(GetSubStr(lTempList.Strings[i], 17, AMG_PIPE));
      end;
    finally
      if Assigned(lTempList) then
        FreeAndNil(lTempList);
      if Assigned(Cipher) then
        FreeAndNil(Cipher);
    end;
  end
  else
  begin  // setup default
    FReportType := 1;
    FReportTitleSR := 'Student Report';
    FReportTitleRC := 'Student Report Card';
    FReportTitleSL := 'Subject List';
    FAdditionalCommentLabel := 'Additional Comment or Activity';
    FHideSchoolNameSR := False;
    FHideSchoolNameRC := False;
    FHideSchoolNameSL := False;
    FGradeLabel := 'Code Mark';
    FNumericLabel := 'Numeric Mark';
    FPercentageLabel := 'Grade %';
    FLetterGradeLabel := 'LetterGrade';
    FDescriptiveLabel := 'Descriptive';
    FCustomAddOnTitle1 := 'Custom Add-on 1';
    FCustomAddOnTitle2 := 'Custom Add-on 2';
    FSignRole := 'MASTERHEAD';
    FKeepAssessmentBlank := False;
  end;
  Result := True;
end;

function TAMGReport.SaveToFile: Boolean;
var
  lTempList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lDir: string;
begin
  lTempList := TStringList.Create;
  Cipher := TDCP_Rijndael.Create(nil);
  lDir := GetCurrentDir;
  try
    ChDir(DataDir);
    lTempList.Add(IntToStr(FReportType) + AMG_PIPE +
                  FReportTitleSR + AMG_PIPE +
                  FReportTitleRC + AMG_PIPE +
                  FReportTitleSL + AMG_PIPE +
                  FAdditionalCommentLabel + AMG_PIPE +
                  BoolToStr(FHideSchoolNameSR) + AMG_PIPE +
                  BoolToStr(FHideSchoolNameRC) + AMG_PIPE +
                  BoolToStr(FHideSchoolNameSL) + AMG_PIPE +
                  FGradeLabel + AMG_PIPE +
                  FNumericLabel + AMG_PIPE +
                  FPercentageLabel + AMG_PIPE +
                  FLetterGradeLabel + AMG_PIPE +
                  FDescriptiveLabel + AMG_PIPE +
                  FCustomAddOnTitle1 + AMG_PIPE +
                  FCustomAddOnTitle2 + AMG_PIPE +
                  FSignRole + AMG_PIPE +
                  BoolToStr(FKeepAssessmentBlank));
    //encrypt
    Cipher.InitStr(KeyStrRt, TDCP_sha1);
    lTempList.Text := Cipher.EncryptString(lTempList.Text);
    Cipher.Burn;
    lTempList.SaveToFile(RWFile + '.RCF');
  finally
    if Assigned(Cipher) then
      FreeAndNil(Cipher);
    if Assigned(lTempList) then
      FreeAndNil(lTempList);
    SetCurrentDir(lDir);
  end;
end;

{ TAMGStudentReports }

function TAMGStudentReports.IndexOf(const pStudentCode: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Self.Count - 1 do
  begin
    if (TAMGStudentReport(Self.Items[i]).FStudentCode = pStudentCode) then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function TAMGStudentReports.RefreshFromFile: Boolean;
var
  lTempList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lStudentReport: TAMGStudentReport;
begin
  inherited RefreshFromFile;
  Result := False;
  Self.Clear;
  if FileExists(RWFile + '.STR') then
  begin
    lTempList := TStringList.Create;
    Cipher := TDCP_Rijndael.Create(nil);
    try
      lTempList.LoadFromFile(RWFile + '.STR');
      //decrypt string
      Cipher.InitStr(KeyStrRt,TDCP_sha1);
      lTempList.Text := Cipher.DecryptString(lTempList.Text);
      Cipher.Burn;
      //retrieve strings
      for i := 0 to lTempList.Count - 1 do
      begin
        lStudentReport := TAMGStudentReport.Create;
        lStudentReport.FStudentCode := GetSubStr(lTempList.Strings[i], 1, AMG_PIPE);
        lStudentReport.FClassCode := GetSubStr(lTempList.Strings[i], 2, AMG_PIPE);
        lStudentReport.FOtherActivities := GetSubStr(lTempList.Strings[i], 3, AMG_PIPE);
        lStudentReport.FDaysAbsent := StrToInt(GetSubStr(lTempList.Strings[i], 4, AMG_PIPE));
        Self.Add(lStudentReport);
      end;
    finally
      if Assigned(lTempList) then
        FreeAndNil(lTempList);
      if Assigned(Cipher) then
        FreeAndNil(Cipher);
    end;
  end;
  Result := True;
end;

function TAMGStudentReports.SaveToFile: Boolean;
var
  lTempList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lStudentReport: TAMGStudentReport;
begin
  lTempList := TStringList.Create;
  Cipher:= TDCP_Rijndael.Create(nil);
  try
    ChDir(DataDir);
    for i := 0 to Self.Count -1 do
    begin
      lStudentReport := TAMGStudentReport(Self.Items[i]);
      lTempList.Add(lStudentReport.FStudentCode + AMG_PIPE +
                    lStudentReport.FClassCode + AMG_PIPE +
                    lStudentReport.FOtherActivities + AMG_PIPE +
                    IntToStr(lStudentReport.FDaysAbsent));
    end;
    //encrypt
    Cipher.InitStr(KeyStrRt, TDCP_sha1);
    lTempList.Text := Cipher.EncryptString(lTempList.Text);
    Cipher.Burn;
    lTempList.SaveToFile(RWFile + '.STR');
  finally
    if Assigned(Cipher) then
      FreeAndNil(Cipher);
    if Assigned(lTempList) then
      FreeAndNil(lTempList);
  end;
end;

{ TAMGSubjectMarks }

function TAMGSubjectMarks.HasMarks(pStudentCode: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to Self.Count - 1 do
  begin
    if TAMGSubjectMark(Self.Items[i]).FStudentCode = pStudentCode then
    begin
      Result := True;
      Break;
    end;
  end;
end;

function TAMGSubjectMarks.IndexOf(const pStudentCode, pSubjectCode: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Self.Count - 1 do
  begin
    if (TAMGSubjectMark(Self.Items[i]).FStudentCode = pStudentCode) and
      (Trim(TAMGSubjectMark(Self.Items[i]).FSubjectCode) = Trim(pSubjectCode)) then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function TAMGSubjectMarks.RefreshFromFile: Boolean;
var
  lTempList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lSubjectMark: TAMGSubjectMark;
begin
  inherited RefreshFromFile;
  Result := False;
  Self.Clear;
  if FileExists(RWFile + '.SBM') then
  begin
    lTempList := TStringList.Create;
    Cipher := TDCP_Rijndael.Create(nil);
    try
      lTempList.LoadFromFile(RWFile + '.SBM');
      //decrypt string
      Cipher.InitStr(KeyStrRt,TDCP_sha1);
      lTempList.Text := Cipher.DecryptString(lTempList.Text);
      Cipher.Burn;
      //retrieve strings
      for i := 0 to lTempList.Count - 1 do
      begin
        lSubjectMark := TAMGSubjectMark.Create;
        lSubjectMark.FStudentCode := GetSubStr(lTempList.Strings[i], 1, AMG_PIPE);
        lSubjectMark.FTeacherCode := GetSubStr(lTempList.Strings[i], 2, AMG_PIPE);
        lSubjectMark.FSubjectCode := GetSubStr(lTempList.Strings[i], 3, AMG_PIPE);
        lSubjectMark.FSubjectName := GetSubStr(lTempList.Strings[i], 4, AMG_PIPE);
        lSubjectMark.FComment := GetSubStr(lTempList.Strings[i], 5, AMG_PIPE);
        lSubjectMark.FCommentCount := StrToInt(GetSubStr(lTempList.Strings[i], 6, AMG_PIPE));
        lSubjectMark.FCodeVal := GetSubStr(lTempList.Strings[i], 7, AMG_PIPE);
        lSubjectMark.FNumericVal := StrToInt(GetSubStr(lTempList.Strings[i], 8, AMG_PIPE));
        lSubjectMark.FPercentage := StrToInt(GetSubStr(lTempList.Strings[i], 9, AMG_PIPE));
        lSubjectMark.FLetterGrade := GetSubStr(lTempList.Strings[i], 10, AMG_PIPE);
        lSubjectMark.FDescriptive := GetSubStr(lTempList.Strings[i], 11, AMG_PIPE);
        lSubjectMark.CustomAddon1 := GetSubStr(lTempList.Strings[i], 12, AMG_PIPE);
        lSubjectMark.CustomAddon2 := GetSubStr(lTempList.Strings[i], 13, AMG_PIPE);
        Self.Add(lSubjectMark);
      end;
    finally
      if Assigned(lTempList) then
        FreeAndNil(lTempList);
      if Assigned(Cipher) then
        FreeAndNil(Cipher);
    end;
  end;
  Result := True;
end;

function TAMGSubjectMarks.RemoveItem(const pItemIndex: Integer): Boolean;
begin
  Result := False;
  Self.Delete(pItemIndex);
  Self.SaveToFile;
  Result := True;
end;

function TAMGSubjectMarks.SaveToFile: Boolean;
var
  lTempList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lSubjectMark: TAMGSubjectMark;
begin
  SortList;
  lTempList := TStringList.Create;
  Cipher:= TDCP_Rijndael.Create(nil);
  try
    ChDir(DataDir);
    for i := 0 to Self.Count -1 do
    begin
      lSubjectMark := TAMGSubjectMark(Self.Items[i]);
      lTempList.Add(lSubjectMark.FStudentCode + AMG_PIPE +
                    lSubjectMark.FTeacherCode + AMG_PIPE +
                    lSubjectMark.FSubjectCode + AMG_PIPE +
                    lSubjectMark.FSubjectName + AMG_PIPE +
                    lSubjectMark.FComment + AMG_PIPE +
                    IntToStr(lSubjectMark.FCommentCount) + AMG_PIPE +
                    lSubjectMark.FCodeVal + AMG_PIPE +
                    IntToStr(lSubjectMark.FNumericVal) + AMG_PIPE +
                    IntToStr(lSubjectMark.FPercentage) + AMG_PIPE +
                    lSubjectMark.FLetterGrade + AMG_PIPE +
                    lSubjectMark.FDescriptive + AMG_PIPE +
                    lSubjectMark.CustomAddon1 + AMG_PIPE +
                    lSubjectMark.CustomAddon2);
    end;
    //encrypt
    Cipher.InitStr(KeyStrRt, TDCP_sha1);
    lTempList.Text := Cipher.EncryptString(lTempList.Text);
    Cipher.Burn;
    lTempList.SaveToFile(RWFile + '.SBM');
  finally
    if Assigned(Cipher) then
      FreeAndNil(Cipher);
    if Assigned(lTempList) then
      FreeAndNil(lTempList);
  end;
end;

procedure TAMGSubjectMarks.SortList;
var
  lStr: string;
  i: Integer;
  lSortList: TStringList;
  lSortSubjectMarks: TAMGSubjectMarks;
  lSubjectMark: TAMGSubjectMark;
  lIdx: Integer;
  lDelimPos: Integer;
begin
  lSortList := TStringList.Create;
  lSortSubjectMarks := TAMGSubjectMarks.Create;
  try
    for i := 0 to Self.Count - 1 do
    begin
      lStr := Trim(TAMGSubjectMark(Self.Items[i]).FStudentCode) + Trim(TAMGSubjectMark(Self.Items[i]).FSubjectCode);
      lSortList.Add(lStr + AMG_PIPE + IntToStr(i))
    end;

    lSortList.Sort;

    for i := 0 to lSortList.Count - 1 do
    begin
      lStr := lSortList.Strings[i];
      lDelimPos := Pos(AMG_PIPE, lStr);
      lIdx := StrToInt(Copy(lStr, lDelimPos + 1, Length(lStr)));
      lSubjectMark := TAMGSubjectMark(Self.Items[lIdx]);
      lSortSubjectMarks.Add(lSubjectMark);
    end;
    Self.Clear;
    for i := 0 to lSortSubjectMarks.Count - 1 do
      Self.Add(lSortSubjectMarks.Items[i]);
  finally
    if Assigned(lSortSubjectMarks) then
      FreeAndnil(lSortSubjectMarks);
    if Assigned(lSortList) then
      FreeAndnil(lSortList)
  end;
end;

end.
