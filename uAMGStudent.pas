unit uAMGStudent;

interface

uses
  uAMGItem, Classes;

type
  TAMGChoices = class;
  TAMGSiblings = class;

  //Student objects
  TAMGStudent = class(TAMGItem)
  private
    FStudYear: Integer;
    FHouse: Integer;
    FtcClass: Integer;
    FLatest: Integer;
    FTag: Integer;
    FTutor: Integer;
    FStName: string;
    FSex: ShortString;
    FEarliest: Integer;
    FHome: Integer;
    FFirst: string;
    FChoices: TAMGChoices;
    FSiblings: TAMGSiblings;
    FFathersFirstName: string;
    FMothersFirstName: string;
    FMothersEmail: string;
    FFathersEmail: string;
    FPrefrerredName: string;
    FCode2: string;
    FMobileNo: string;
    FEmail: string;
    FParentID: Integer;
    FRecordNo: Integer;
    FDOB: TDateTime;
    FAddress: string;
    FComment: string;
    FSubTeachList: string;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Refresh: Boolean; override;
    function Save: Boolean; override;
    property StName: string read FStName write FStName;
    property First: string read FFirst write FFirst;
    property PrefrerredName: string read FPrefrerredName write FPrefrerredName;
    property MobileNo: string read FMobileNo write FMobileNo;
    property Email: string read FEmail write FEmail;
    property ParentID: Integer read FParentID write FParentID;
    property Code2: string read FCode2 write FCode2;
    property Sex: ShortString read FSex write FSex;
    property StudYear: Integer read FStudYear write FStudYear;
    property tcClass: Integer read FtcClass write FtcClass;
    property House: Integer read FHouse  write FHouse;
    property Tutor: Integer read FTutor write FTutor;
    property Home: Integer read FHome write FHome;
    property SubTeachList: string read FSubTeachList write FSubTeachList;
    property Earliest: Integer read FEarliest write FEarliest;
    property Latest: Integer read FLatest write FLatest;
    property Tag: Integer read FTag write FTag;
    property RecordNo: Integer read FRecordNo write FRecordNo;
    property DOB: TDateTime read FDOB write FDOB;
    property Choices: TAMGChoices read FChoices write FChoices;
    property Siblings: TAMGSiblings read FSiblings write FSiblings;
    property Address: string read FAddress write FAddress;
    property FathersFirstName: string read FFathersFirstName write FFathersFirstName;
    property FathersEmail: string read FFathersEmail write FFathersEmail;
    property MothersFirstName: string read FMothersFirstName write FMothersFirstName;
    property MothersEmail: string read FMothersEmail write FMothersEmail;
    property Comment: string read FComment write FComment;
  end;

  TAMGStudents = class(TAMGItemList)
  public
    function Refresh: Boolean; override;
    function RefreshFromFile: Boolean; override;
    function Save: Boolean; override;
    function SaveToFile: Boolean;
  end;

  TAMGChoice = class(TAMGItem)
  private
    FTeacherNo: Integer;
    FTime: Integer;
    FSub: Integer;
  public
    property Sub: Integer read FSub write FSub;
    property TeacherNo: Integer read FTeacherNo write FTeacherNo;
    property Time: Integer read FTime write FTime;
  end;

  TAMGChoices = class(TAMGItemList)
  public
    function Refresh: Boolean; override;
    function IndexOf(pSubjectNo: Integer): Integer;
    function RemoveItem(const pItemIndex: Integer): Boolean;
  end;

  TAMGSibling = class(TAMGItem)
  private
    FSib: Integer;
  public
    property Sib: Integer read FSib write FSib;
  end;

  TAMGSiblings = class(TAMGItemList)
  public
    function Refresh: Boolean; override;
  end;

  TAMGParent = class(TAMGItem)
  private
    FStudentID: string;
    FFathersName: string;
    FMothersName: string;
    FMothersEmail: string;
    FFathersEmail: string;
  public
    property StudentID: string read FStudentID write FStudentID;
    property FathersName: string read FFathersName write FFathersName;
    property FathersEmail: string read FFathersEmail write FFathersEmail;
    property MothersName: string read FMothersName write FMothersName;
    property MothersEmail: string read FMothersEmail write FMothersEmail;
  end;

  TAMGParents = class(TAMGItemList)
  private
    FLog: TStringList;
    FRecordsImported: Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Refresh: Boolean; override;
    function RefreshFromFile: Boolean; override;
    function SaveToFile: Boolean;
    function ImportFromFile(const pFileName: string): Boolean;
    function IndexOf(const pStudentID: string): Integer;
    property Log: TStringList read FLog write FLog;
    property RecordsImported: Integer read FRecordsImported write FRecordsImported;
  end;

  //Import Student class is designed to enable swapping the order of field in a file
  TAMGImportStudent = class
  private
    FHomeRoom: string;
    FHouse: string;
    FSurname: string;
    FSchoolYear: string;
    FGender: Char;
    FHomeGroup: string;
    FFirstname: string;
    FStudentCode: string;
    FDateOfBirth: TDateTime;
  public
    property StudentCode: string read FStudentCode write FStudentCode;
    property Surname: string read FSurname write FSurname;
    property Firstname: string read FFirstname write FFirstname;
    property Gender: Char read FGender write FGender;
    property DateOfBirth: TDateTime read FDateOfBirth write FDateOfBirth;
    property SchoolYear: string read FSchoolYear write FSchoolYear;
    property HomeGroup: string read FHomeGroup write FHomeGroup;
    property HomeRoom: string read FHomeRoom write FHomeRoom;
    property House: string read FHouse write FHouse;
  end;

  TAMGImportStudents = class(TAMGItemList)
  public
    function ConvertDataFile(const pInputFile: string): Boolean;
  end;

  //Student class subjects is desined specificalyfor CASES21
  TAMGStudentClassSub = class(TAMGItem)
  private
    FSubjectFullName: string;
    FTeacherCode: string;
    FClassNo: Integer;
    FStudentCode: string;
    FSubjectCode: string;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Refresh: Boolean; override;
    property StudentCode: string read FStudentCode write FStudentCode;
    property SubjectCode: string read FSubjectCode write FSubjectCode;
    property SubjectFullName: string read FSubjectFullName write FSubjectFullName;
    property ClassNo: Integer read FClassNo write FClassNo;
    property TeacherCode: string read FTeacherCode write FTeacherCode;
  end;

  TAMGStudentClassSubs = class(TAMGItemList)
  public
    function Refresh: Boolean; override;
    function RefreshFromFile: Boolean; override;
    function SaveToFile: Boolean;
    function ImportFromCASES21(const pInputFile: string): Boolean;
  end;

  //Year Status objects
  TAMGYearStat = class(TAMGItem)
  public
    constructor Create; override;
    destructor Destroy; override;
    function Refresh: Boolean; override;
    function Save: Boolean; override;
  end;

  TAMGYearStats = class(TAMGItemList)
  public
    function Refresh: Boolean; override;
    function Save: Boolean;
  end;

  //Tag Objects
  TAMGTag = class(TAMGItem)
  private
    FTagName: string;
    FIsUsed: Boolean;
    FTagOrder: Integer;
  public
    property TagName: string read FTagName write FTagName;
    property IsUsed: Boolean read FIsUsed write FIsUsed;
    property TagOrder: Integer read FTagOrder write FTagOrder;
  end;

  TAMGTags = class(TAMGItemList)
  public
    function RefreshFromFile: Boolean; override;
    function SaveToFile: Boolean;
  end;

  //Subject List
  TAMGSubjectStudent = class(TAMGItem)
  private
    FReportSubjectName: string;
    FStudent: TAMGStudent;
    FTagName: string;
    FTeacherName: string;
  public
    property Student: TAMGStudent read FStudent write FStudent;
    property SubjectCode: string read FTagName write FTagName;
    property ReportSubjectName: string read FReportSubjectName write FReportSubjectName;
    property TeacherName: string read FTeacherName write FTeacherName;
  end;

  TAMGSubjectStudents = class(TAMGItemList)
  end;

var
  Students: TAMGStudents;
  Parents: TAMGParents;
  Tags: TAMGTags;
  SubjectStudents: TAMGSubjectStudents;

implementation

uses
  SysUtils, uAMGGlobal, uAMGConst, uAMGCommon, DCPrijndael, DCPSha1,
  uAMGDBCoord;

{ TAMGStudents }

function TAMGStudents.Refresh: Boolean;
begin
  inherited Refresh;
  Result := False;
end;

function TAMGStudents.RefreshFromFile: Boolean;
begin
  inherited RefreshFromFile;
  Result := False;
end;

function TAMGStudents.Save: Boolean;
var
  i: Integer;
begin
  inherited Save;
  for i := 0 to Self.Count - 1 do
    TAMGStudent(Self.Items[i]).Save;
  Result := True;
end;

function TAMGStudents.SaveToFile: Boolean;
//At the moment it is about family details. The rest of the details will be setup when the object is used
var
  i: Integer;
  lParentIdx: Integer;
  lStudentID: string;
  lParent: TAMGParent;
  lFatherName: string;
  lFatherEmail: string;
  lMotherName: string;
  lMotherEmail: string;
begin
  for i := 0 to Self.Count - 1 do
  begin
    lStudentID := Trim(TAMGStudent(Self.Items[i]).Code);
    if lStudentID <> '' then
    begin
      lParentIdx := Parents.IndexOf(lStudentID);
      lFatherName := TAMGStudent(Self.Items[i]).FFathersFirstName;
      lFatherEmail := TAMGStudent(Self.Items[i]).FFathersEmail;
      lMotherName := TAMGStudent(Self.Items[i]).FMothersFirstName;
      lMotherEmail := TAMGStudent(Self.Items[i]).FMothersEmail;

      if lParentIdx = -1 then
      begin
        lParentIdx := Parents.Count; // To append to the list
        if (lFatherName <> '') or (lMotherName <> '') then
        begin
          lParent := TAMGParent.Create;
          lParent.FStudentID := lStudentID;
          lParent.FFathersName := lFatherName;
          lParent.FFathersEmail := lFatherEmail;
          lParent.FMothersName := lMotherName;
          lParent.FMothersEmail := lMotherEmail;
          Parents.Add(lParent);
        end;
      end
      else
      begin
        TAMGParent(Parents.Items[lParentIdx]).FFathersName := TAMGStudent(Self.Items[i]).FFathersFirstName;
        TAMGParent(Parents.Items[lParentIdx]).FFathersEmail := TAMGStudent(Self.Items[i]).FFathersEmail;
        TAMGParent(Parents.Items[lParentIdx]).FMothersName := TAMGStudent(Self.Items[i]).FMothersFirstName;
        TAMGParent(Parents.Items[lParentIdx]).FMothersEmail := TAMGStudent(Self.Items[i]).FMothersEmail;
      end;
    end;
  end;  // for
  Parents.SaveToFile;
  Result := True;
end;

{ TAMGStudent }

constructor TAMGStudent.Create;
begin
  inherited;
  FChoices := TAMGChoices.Create;
  FSiblings := TAMGSiblings.Create;
  FTableName := 'Student';
  FPKName := 'StudentID';
end;

destructor TAMGStudent.Destroy;
begin
  if Assigned(FChoices) then
    FreeAndNil(FChoices);
  if Assigned(FSiblings) then
    FreeAndNil(FSiblings);
  inherited;
end;

function TAMGStudent.Refresh: Boolean;
begin
  inherited Refresh;
  Result := False;
end;

function TAMGStudent.Save: Boolean;
begin
  inherited Save;
  if FPrefrerredName = '' then
    FPrefrerredName := FFirst;

  if DBCoord.AlreadyExists(FTableName, 'StudentID', IntToStr(ID))  then
  begin
    DBCoord.qryMain.SQL.Text := Format('update Student set StudentCode = %s, StudentCode2 = %s, StudentSurname = %s, StudentFirstName = %s, ' +
                                       'PrefrerredName = %s, MobileNo = %s, Email = %s, ParentID = %d, StudentSex = %s, TCClass = %d, ' +
                                       'TCClassYear = %d, HouseID= %d, TutorID = %d, HomeID = %d, TagID = %d, RecordNo = %d, StudentDOB = %f, ' +
                                       'StudentAddress = %s, where StudentID = %d',
                                       [QuotedStr(Code), QuotedStr(FCode2), QuotedStr(FStName), QuotedStr(FFirst), QuotedStr(FPrefrerredName), QuotedStr(FMobileNo), QuotedStr(FEmail), FParentID, QuotedStr(FSex), FtcClass,
                                       FStudYear, FHouse, FTutor, FHome, FTag, FRecordNo, FDOB, QuotedStr(FAddress), ID]);
  end
  else
  begin
    ID := DBCoord.GetNextID(FTableName, FPKName);
    DBCoord.qryMain.SQL.Text := Format('insert into Student (StudentID, StudentCode, StudentCode2, StudentSurname, StudentFirstName, ' +
                                       'PrefrerredName, MobileNo, Email, ParentID, StudentSex, TCClass, ' +
                                       'TCClassYear, HouseID, TutorID, HomeID, TagID, RecordNo, StudentDOB, StudentAddress) ' +
                                       'values (%d, %s, %s, %s, %s, %s, %s, %s, %d, %s, %d, %d, %d, %d, %d, %d, %d, %f, %s)',
                                       [ID, QuotedStr(Code), QuotedStr(FCode2), QuotedStr(FStName), QuotedStr(FFirst), QuotedStr(FPrefrerredName), QuotedStr(FMobileNo), QuotedStr(FEmail), FParentID, QuotedStr(FSex),
                                       FtcClass, FStudYear, FHouse, FTutor, FHome, FTag, FRecordNo, FDOB, QuotedStr(FAddress)]);
  end;
  DBCoord.qryMain.ExecSQL;
  Result := True;
end;

{ TAMGSiblings }

function TAMGSiblings.Refresh: Boolean;
begin
  inherited Refresh;
  Result := False;
end;

{ TAMGChoices }

function TAMGChoices.IndexOf(pSubjectNo: Integer): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Self.Count - 1 do
  begin
    if TAMGChoice(Self.Items[i]).Sub = pSubjectNo then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function TAMGChoices.Refresh: Boolean;
begin
  inherited Refresh;
  Result := False;
end;

function TAMGChoices.RemoveItem(const pItemIndex: Integer): Boolean;
begin
  Result := False;
  Self.Delete(pItemIndex);
  Result := True;
end;

{ TAMGParents }

constructor TAMGParents.Create;
begin
  inherited;
  FLog := TStringList.Create;
end;

destructor TAMGParents.Destroy;
begin
  if Assigned(FLog) then
    FreeAndNil(FLog);
  inherited;
end;

function TAMGParents.ImportFromFile(const pFileName: string): Boolean;
var
  lTempList: TStringList;
  i: Integer;
  lParent: TAMGParent;
  lLine: string;
  lStudentID: string;
  lParentIdx: Integer;
  lFieldCount: Integer;

  function IsValidLine(const pLine: string): Boolean;
  var
    lCommaCount: Integer;
    i: Integer;
  begin
    Result := True;
    if Trim(pLine) <> '' then
    begin
      lCommaCount := 0;
      for i := 1 to Length(pLine) do
      begin
        if pLine[i] = ',' then
          Inc(lCommaCount);
      end;
      if lCommaCount <> lFieldCount - 1 then
      begin
        Result := False;
        FLog.Add(pLine);
      end;
    end
    else
    begin
      Result := False;
    end;
  end;

begin
  lFieldCount := 5;
  FLog.Clear;
  FRecordsImported := 0;
  lTempList := TStringList.Create;
  try
    lTempList.LoadFromFile(pFileName);
    if lTempList.Count > 0 then
    begin
      for i := 0 to lTempList.Count - 1 do
      begin
        lLine := Trim(lTempList.Strings[i]);
        if IsValidLine(lLine) then
        begin
          Inc(FRecordsImported);
          lStudentID := Trim(GetSubStr(lLine, 1));
          lParentIdx := Parents.IndexOf(lStudentID);
          if lParentIdx = -1 then
          begin
            lParent := TAMGParent.Create;
            lParent.StudentID := lStudentID;
            lParent.FathersName := Trim(GetSubStr(lLine, 2));
            lParent.FathersEmail := Trim(GetSubStr(lLine, 3));
            lParent.MothersName := Trim(GetSubStr(lLine, 4));
            lParent.MothersEmail := Trim(GetSubStr(lLine, 5));
            Parents.Add(lParent);
          end
          else
          begin
            TAMGPArent(Parents.Items[lParentIdx]).StudentID := lStudentID;
            TAMGPArent(Parents.Items[lParentIdx]).FathersName := Trim(GetSubStr(lLine, 2));
            TAMGPArent(Parents.Items[lParentIdx]).FathersEmail := Trim(GetSubStr(lLine, 3));
            TAMGPArent(Parents.Items[lParentIdx]).MothersName := Trim(GetSubStr(lLine, 4));
            TAMGPArent(Parents.Items[lParentIdx]).MothersEmail := Trim(GetSubStr(lLine, 5));
          end;
        end;
      end;  // for
      Parents.SaveToFile;
      Result := True;
    end;
  finally
    FreeAndNil(lTempList);
  end;
end;

function TAMGParents.IndexOf(const pStudentID: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Self.Count - 1 do
  begin
    if TAMGParent(Self.Items[i]).FStudentID = pStudentID then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function TAMGParents.Refresh: Boolean;
begin
  inherited Refresh;
  Result := False;
end;

function TAMGParents.RefreshFromFile: Boolean;
var
  lParentList: TStringList;
  i: Integer;
  lTempStr: string;
  lParent: TAMGPArent;
  Cipher: TDCP_Rijndael;
begin
  Result := inherited RefreshFromFile;
  Self.Clear;
  if FileExists(AMG_PARENTS_DAT) then
  begin
    lParentList := TStringList.Create;
    Cipher:= TDCP_Rijndael.Create(nil);
    try
      lParentList.LoadFromFile(AMG_PARENTS_DAT);
      //decrypt string
      Cipher.InitStr(KeyStrRt, TDCP_sha1);   // initialize the cipher with a hash of the passphrase
      lParentList.Text := Cipher.DecryptString(lParentList.Text);
      Cipher.Burn;
      //retrieve strings
      for i := 0 to lParentList.Count - 1 do
      begin
        lTempStr := lParentList.Strings[i];
        if Trim(StringReplace(lTempStr, ',', '', [rfReplaceAll, rfReplaceAll])) <> '' then
        begin
          lTempStr := lParentList.Strings[i];
          lParent := TAMGPArent.Create;
          lParent.FStudentID := GetSubStr(lTempStr, 1);
          lParent.FFathersName := GetSubStr(lTempStr, 2);
          lParent.FFathersEmail := GetSubStr(lTempStr, 3);
          lParent.FMothersName := GetSubStr(lTempStr, 4);
          lParent.FMothersEmail := GetSubStr(lTempStr, 5);
          Parents.Add(lParent);
        end;
      end;
    finally
      if Assigned(Cipher) then
        FreeAndNil(Cipher);
      FreeAndNil(lParentList);
    end;
    Result := True;
  end; // if
end;

function TAMGParents.SaveToFile: Boolean;
var
  lParentList: TStringList;
  i: Integer;
  Cipher: TDCP_Rijndael;
begin
  if Self.Count > 0 then
  begin
    lParentList := TStringList.Create;
    try
      Cipher := TDCP_Rijndael.Create(nil);
      try
        for i := 0 to Self.Count - 1 do
        begin
          lParentList.Add(TAMGParent(Self.Items[i]).FStudentID + ',' +
                          TAMGParent(Self.Items[i]).FFathersName + ',' +
                          TAMGParent(Self.Items[i]).FFathersEmail + ',' +
                          TAMGParent(Self.Items[i]).FMothersName + ',' +
                          TAMGParent(Self.Items[i]).FMothersEmail);
        end;
      {encrypt}
      Cipher.InitStr(KeyStrRt, TDCP_sha1);         // initialize the cipher with a hash of the passphrase
      lParentList.Text := Cipher.EncryptString(lParentList.Text);
      Cipher.Burn;
      lParentList.SaveToFile(AMG_PARENTS_DAT);
      finally
        FreeAndNil(Cipher);
      end;
    finally
      FreeAndNil(lParentList);
    end;
    Result := True;
  end;
end;

{ TStudentSwap }

function TAMGImportStudents.ConvertDataFile(const pInputFile: string): Boolean;
var
  lTempList: TStringList;
  lTempStr: string;
  i: Integer;
  lStudentSwap: TAMGImportStudent;
begin
  if FileExists(pInputFile) then
  begin
    lTempList := TStringList.Create;
    try
      lTempList.LoadFromFile(pInputFile);
      for i := 0 to lTempList.Count - 1 do
      begin
        lStudentSwap := TAMGImportStudent.Create;
        lTempStr := StringReplace(lTempList.Strings[i], '"', '', [rfReplaceAll, rfIgnoreCase]);
        lTempStr := Trim(lTempStr);
        lStudentSwap.FStudentCode := GetSubStr(lTempStr, 1);
        lStudentSwap.FSurname := Copy(UpperCase(GetSubStr(lTempStr, 2)), 1, 20);    // only 20 char
        lStudentSwap.FFirstname := Copy(UpperCase(GetSubStr(lTempStr, 3)), 1, 20);  // only 20 char
        lStudentSwap.FGender := GetSubStr(lTempStr, 4)[1];
        lStudentSwap.FDateOfBirth := StrToDate(GetSubStr(lTempStr, 5));
        lStudentSwap.FSchoolYear := GetSubStr(lTempStr, 6);
        lStudentSwap.FHomeGroup := GetSubStr(lTempStr, 7);
        lStudentSwap.FHomeRoom := GetSubStr(lTempStr, 8);
        lStudentSwap.FHouse := UpperCase(GetSubStr(lTempStr, 9));
        Self.Add(lStudentSwap);
      end;
      {for i := 0 to Self.Count - 1 do
      begin
        lConvertList.Add(TAMGImportStudent(Self.Items[i]).FSurname + ',' +
                         TAMGImportStudent(Self.Items[i]).FFirstname + ',' +
                         TAMGImportStudent(Self.Items[i]).FSchoolYear + ',' +
                         TAMGImportStudent(Self.Items[i]).FGender + ',' +
                         TAMGImportStudent(Self.Items[i]).FStudentCode + ',' +
                         TAMGImportStudent(Self.Items[i]).FHomeGroup + ',' +   //Roll Class
                         TAMGImportStudent(Self.Items[i]).FHouse + ',' +
                         ',' +    //Tutor place holder
                         TAMGImportStudent(Self.Items[i]).FHomeRoom);
      end;}
    finally
      FreeAndNil(lTempList);
    end;
  end;
end;

{ TAMGStudentClassSub }

constructor TAMGStudentClassSub.Create;
begin
  inherited;
  //code
end;

destructor TAMGStudentClassSub.Destroy;
begin
  //code
  inherited;
end;

function TAMGStudentClassSub.Refresh: Boolean;
begin
  //code
end;

{ TAMGStudentClassSubs }

function TAMGStudentClassSubs.ImportFromCASES21(const pInputFile: string): Boolean;
var
  lTempList: TStringList;
  lTempStr: string;
  i: Integer;
  lStudentClassSubs: TAMGStudentClassSub;
begin
  Result := False;
  if FileExists(pInputFile) then
  begin
    lTempList := TStringList.Create;
    try
      lTempList.LoadFromFile(pInputFile);
      for i := 0 to lTempList.Count - 1 do
      begin
        lStudentClassSubs := TAMGStudentClassSub.Create;
        lTempStr := StringReplace(lTempList.Strings[i], '"', '', [rfReplaceAll, rfIgnoreCase]);
        lTempStr := Trim(lTempStr);
        lStudentClassSubs.FStudentCode := Trim(GetSubStr(lTempStr, 1));
        lStudentClassSubs.FSubjectCode := Trim(GetSubStr(lTempStr, 2));
        lStudentClassSubs.FSubjectFullName := Trim(GetSubStr(lTempStr, 3));
        lStudentClassSubs.FClassNo := StrToInt(Trim(GetSubStr(lTempStr, 4)));
        lStudentClassSubs.FTeacherCode := Trim(GetSubStr(lTempStr, 5));
        Self.Add(lStudentClassSubs);
      end;
      Result := True;
    finally
      FreeAndNil(lTempList);
    end;
  end;
end;

function TAMGStudentClassSubs.Refresh: Boolean;
begin
  //ToDo
end;

function TAMGStudentClassSubs.RefreshFromFile: Boolean;
begin
  //ToDo
end;

function TAMGStudentClassSubs.SaveToFile: Boolean;
begin
  //ToDo
end;

{ TAMGYearStat }

constructor TAMGYearStat.Create;
begin
  inherited;
  //ToDo
end;

destructor TAMGYearStat.Destroy;
begin
  //ToDo
  inherited;
end;

function TAMGYearStat.Refresh: Boolean;
begin
  //ToDo
end;

function TAMGYearStat.Save: Boolean;
begin
  //ToDo
end;

{ TAMGYearStats }

function TAMGYearStats.Refresh: Boolean;
begin
  //ToDo
end;

function TAMGYearStats.Save: Boolean;
begin
  //ToDo
end;


{ TAMGTags }

function TAMGTags.RefreshFromFile: Boolean;
//This method is not used at the moment and it will be used when needed.
var
  lTempList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lTag: TAMGTag;
  lIsUsed: string;
begin
  inherited RefreshFromFile;
  Result := False;
  Self.Clear;
  if FileExists(AMG_TAG_FILE) then
  begin
    lTempList := TStringList.Create;
    Cipher:= TDCP_Rijndael.Create(nil);
    try
      lTempList.LoadFromFile(AMG_TAG_FILE);
      //decrypt string
      Cipher.InitStr(KeyStrRt,TDCP_sha1);   // initialize the cipher with a hash of the passphrase
      lTempList.Text := Cipher.DecryptString(lTempList.Text);
      Cipher.Burn;
      //retrieve strings
      for i := 0 to lTempList.Count - 1 do
      begin
        lTag := TAMGTag.Create;
        lTag.Code := GetSubStr(lTempList.Strings[i], 1, AMG_PIPE);
        lTag.FTagName := GetSubStr(lTempList.Strings[i], 2, AMG_PIPE);
        lIsUsed := GetSubStr(lTempList.Strings[i], 3, AMG_PIPE);
        if lIsUsed <> '' then
          lTag.FIsUsed := StrToBool(lIsUsed)
        else
          lTag.FIsUsed := False;
        lTag.FTagOrder := StrToInt(GetSubStr(lTempList.Strings[i], 4, AMG_PIPE));
        Self.Add(lTag);
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

function TAMGTags.SaveToFile: Boolean;
var
  lTempList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lTag: TAMGTag;
begin
//This method is not used at the moment and it will be used when needed.
  lTempList := TStringList.Create;
  Cipher := TDCP_Rijndael.Create(nil);
  try
    for i := 0 to Self.Count -1 do
    begin
      lTag := TAMGTag(Self.Items[i]);
      lTempList.Add(lTag.Code + '|' + lTag.FTagName + '|' + BoolToStr(lTag.FIsUsed) + '|' + IntToStr(lTag.TagOrder));
    end;
    {encrypt}
    Cipher.InitStr(KeyStrRt, TDCP_sha1);         // initialize the cipher with a hash of the passphrase
    lTempList.Text := Cipher.EncryptString(lTempList.Text);
    Cipher.Burn;
    lTempList.SaveToFile(AMG_TAG_FILE);
  finally
    if Assigned(Cipher) then
      FreeAndNil(Cipher);
    if Assigned(lTempList) then
      FreeAndNil(lTempList);
  end;
end;

end.
