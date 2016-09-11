unit uAMGTeacher;

interface
uses
  uAMGItem, uAMGTimeTable, uAMGSubject;

type
  TAMGDuties = class;

  //Teacher Objects
  TAMGTeacher = class(TAMGItem)
  private
    FTeacherName: string;
    FTimeTable: TAMGTimeTable;
    FHasInterview: Boolean;
    FEmailAddress: string;
    FSubjects: TAMGSubjects;
    FTeacherSurname: string;
    FTitle: string;
    FTeacherFirstName: string;
    FTeacherLoad: Integer;
    FNotes: string;
    FTallyID: Integer;
    FRoomID: Integer;
    FTeacherType: Integer;
    FDuties: TAMGDuties;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Refresh: Boolean; override;
    function Save: Boolean; override;
    property TeacherName: string read FTeacherName write FTeacherName;  // This is only for compatibility with the current Flat file data
    property TeacherFirstName: string read FTeacherFirstName write FTeacherFirstName;
    property TeacherSurname: string read FTeacherSurname write FTeacherSurname;
    property Title: string read FTitle write FTitle;
    property EmailAddress: string read FEmailAddress write FEmailAddress;
    property TeacherLoad: Integer read FTeacherLoad write FTeacherLoad;
    property TeacherType: Integer read FTeacherType write FTeacherType;
    property TallyID: Integer read FTallyID write FTallyID;
    property RoomID: Integer read FRoomID write FRoomID;
    property TimeTable: TAMGTimeTable read FTimeTable write FTimeTable;
    property HasInterview: Boolean read FHasInterview write FHasInterview;
    property Subjects: TAMGSubjects read FSubjects write FSubjects;
    property Notes: string read FNotes write FNotes;
    property Duties: TAMGDuties read FDuties write FDuties;
  end;

  TAMGTeachers = class(TAMGItemList)
  private
    FCodeLength: Integer;
    procedure SetCodeLength(const Value: Integer);
  public
    function Refresh: Boolean; override;
    function RefreshFromFile: Boolean; override;
    function Save: Boolean; override;
    function SaveToFile: Boolean;
    function ImportFromCASES21(const pInputFile: string; const pCodeLength: Integer): Boolean;
    function ImportFromFile(const pFileName: string): Boolean;
    function GetTeacherNameBySubject(const pSubCode: string): string;
    function GetTeacherNameByCode(const pCode: string): string;
    property CodeLength: Integer read FCodeLength write SetCodeLength;
  end;

  //Duty Objects
  TAMGDuty = class(TAMGItem)
  private
    FDutyLoad: Double;
    FDutyName: string;
    FTeacherID: Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Refresh: Boolean; override;
    function Save: Boolean; override;
    property TeacherID: Integer read FTeacherID write FTeacherID;
    property DutyName: string read FDutyName write FDutyName;
    property DutyLoad: Double read FDutyLoad write FDutyLoad;
  end;

  TAMGDuties = class(TAMGItemList)
  private
    FTeacherID: Integer;
  public
    function Refresh: Boolean; override;
    function RefreshFromFile: Boolean; override;
    function Save: Boolean; override;
    function SaveToFile: Boolean;
    property TeacherID: Integer read FTeacherID write FTeacherID;
  end;

  //Teacher free time Objects
  TAMGTeacheFreeTime = class(TAMGItem)
  private
    FTeacherID: Integer;
    FTeacherName: string;
    FFreeTimes: Integer;
    FFirstTime: Integer;
    FLastTime: Integer;
    FLocationName: string;
    FLocationCode: string;
    FTeacherCode: string;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Refresh: Boolean; override;
    function Save: Boolean; override;
    property TeacherID: Integer read FTeacherID write FTeacherID;
    property TeacherCode: string read FTeacherCode write FTeacherCode;
    property TeacherName: string read FTeacherName write FTeacherName;
    property LocationCode: string read FLocationCode write FLocationCode;
    property LocationName: string read FLocationName write FLocationName;
    property FirstTime: Integer read FFirstTime write FFirstTime;
    property LastTime: Integer read FLastTime write FLastTime;
    property FreeTimes: Integer read FFreeTimes write FFreeTimes;
  end;

  TAMGTeacheFreeTimes = class(TAMGItemList)
  public
    function Refresh: Boolean; override;
    function RefreshFromFile: Boolean; override;
    function Save: Boolean; override;
    function SaveToFile: Boolean;
  end;

var
  Teacher: TAMGTeacher;
  Teachers: TAMGTeachers;

implementation

uses
  Classes, DCPrijndael, DCPSha1, SysUtils, uAMGConst, uAMGGlobal, uAMGCommon,
  uAMGDBCoord;

{ TAMGTeacher }

constructor TAMGTeacher.Create;
begin
  inherited;
  FSubjects := TAMGSubjects.Create;
  FDuties := TAMGDuties.Create;
  FTableName := 'Teacher';
  FPKName := 'TeacherID';
end;

destructor TAMGTeacher.Destroy;
begin
  if Assigned(FSubjects) then
    FreeAndNil(FSubjects);
  if Assigned(FDuties) then
    FreeAndNil(FDuties);

  inherited;
end;

function TAMGTeacher.Refresh: Boolean;
begin
  inherited Refresh;
  Result := False;
end;

function TAMGTeacher.Save: Boolean;
var
  lSubjectID: Integer;
begin
  inherited Save;
  lSubjectID := 0; //ToDo get the first ID from the subject list
  if DBCoord.AlreadyExists(FTableName, 'TeacherCode', Code)  then
  begin
    DBCoord.qryMain.SQL.Text := Format('update Teacher set FullName = %s,  Title = %s, EmailAddress = %s, TeacherLoad = %d, TeacherType = %d, ' +
                                       'TeacherTallyID = %d, SubjectID = %d, RoomID = %d, Notes = %s where TeacherCode = %s',
                                       [QuotedStr(FTeacherName),
                                        QuotedStr(FTitle),
                                        QuotedStr(FEmailAddress),
                                        FTeacherLoad,
                                        FTeacherType,
                                        FTallyID,
                                        lSubjectID,
                                        FRoomID,
                                        QuotedStr(FNotes),
                                        QuotedStr(Code)]);
  end
  else
  begin
    ID := DBCoord.GetNextID(FTableName, FPKName);
    DBCoord.qryMain.SQL.Text := Format('insert into Teacher (TeacherID, TeacherCode, FullName, Title, EmailAddress, TeacherLoad, TeacherType, TeacherTallyID, SubjectID, RoomID, Notes) ' +
                                       'values(%d, %s, %s, %s, %s, %d, %d, %d, %d, %d, %s)',
                                       [ID,
                                        QuotedStr(Code),
                                        QuotedStr(FTeacherName),
                                        QuotedStr(FTitle),
                                        QuotedStr(FEmailAddress),
                                        FTeacherLoad,
                                        FTeacherType,
                                        FTallyID,
                                        lSubjectID,
                                        FRoomID,
                                        QuotedStr(FNotes)]);
  end;
  DBCoord.qryMain.ExecSQL;

  //ToDo remove when refresh is implemented
  DBCoord.qryMain.SQL.Text := Format('Select TeacherID from Teacher where TeacherCode = %s', [QuotedStr(Code)]);
  DBCoord.qryMain.Open;
  Self.ID := DBCoord.qryMain.FieldByName('TeacherID').AsInteger;
  Self.Duties.TeacherID := Self.ID;
  Self.Duties.Save;
  Result := True;
end;

{ TAMGTimeTeachers }

function TAMGTeachers.GetTeacherNameBySubject(const pSubCode: string): string;
var
  i,j: Integer;
  lTeacher: TAMGTeacher;
begin
  Result := '';
  for i := 0 to Teachers.Count  -1 do
  begin
    lTeacher := TAMGTeacher(Teachers.Items[i]);
    for j := 0 to lTeacher.Subjects.Count - 1 do
    begin
      if Trim(TAMGSubject(lTeacher.Subjects.Items[j]).Code) = Trim(pSubCode) then
      begin
        Result := lTeacher.TeacherName;
        Break;
      end;
    end;  // for m
  end;  // for l
end;

function TAMGTeachers.GetTeacherNameByCode(const pCode: string): string;
var
  i,j: Integer;
  lTeacher: TAMGTeacher;
begin
  Result := '';
  for i := 0 to Teachers.Count  -1 do
  begin
    lTeacher := TAMGTeacher(Teachers.Items[i]);
    if Trim(lTeacher.Code) = Trim(pCode) then
    begin
      Result := lTeacher.TeacherName;
      Break;
    end;
  end;  // for l
end;

function TAMGTeachers.ImportFromCASES21(const pInputFile: string; const pCodeLength: Integer): Boolean;
var
  lTempList: TStringList;
  lTempStr: string;
  i: Integer;
  lTeacher: TAMGTeacher;
  lCode: string;
begin
  if FileExists(pInputFile) then
  begin
    lTempList := TStringList.Create;
    try
      lTempList.LoadFromFile(pInputFile);
      for i := 0 to lTempList.Count - 1 do
      begin
        lTempStr := StringReplace(lTempList.Strings[i], '"', '', [rfReplaceAll, rfIgnoreCase]);
        lTempStr := Trim(lTempStr);
        lCode := Trim(GetSubStr(lTempStr, 1));
        lCode := Copy(lCode, 1, pCodeLength);
        if Self.IndexOf(lCode) = -1 then
        begin
          lTeacher := TAMGTeacher.Create;
          lTeacher.Code := lCode;
          lTeacher.FTeacherSurname := Trim(GetSubStr(lTempStr, 2));
          lTeacher.FTitle := Trim(GetSubStr(lTempStr, 3));
          lTeacher.FTeacherFirstName := Trim(GetSubStr(lTempStr, 4));
          Self.Add(lTeacher);
        end;
      end;
      for i := 0 to Self.Count - 1 do
      begin
      end;
    finally
      FreeAndNil(lTempList);
    end;
  end;
end;

function TAMGTeachers.ImportFromFile(const pFileName: string): Boolean;
var
  lTempList: TStringList;
  i: Integer;
  lTeacher: TAMGTeacher;
  lLine: string;
  lStudentID: string;
  lTeacherIdx: Integer;
  lSubCode: string;
  lTeachCode: string;

  procedure AddSubject(const pSubCode: string);
  var
    lSubject: TAMGSubject;
    lNewSubject: TAMGSubject;
  begin
    if lSubCode <> '' then
    begin
      if Subjects.IndexOf(lSubCode) = -1 then
      begin
        lNewSubject := TAMGSubject.Create;
        lNewSubject.Code := lSubCode;
        Subjects.Add(lNewSubject);
      end;

      if lTeacher.Subjects.IndexOf(lSubCode) = -1 then
      begin
        lSubject := TAMGSubject.Create;
        lSubject.Code := lSubCode;
        lTeacher.Subjects.Add(lSubject);
      end;
    end;
  end;

begin
  lTempList := TStringList.Create;
  try
    lTempList.LoadFromFile(pFileName);
    if lTempList.Count > 0 then
    begin
      for i := 0 to lTempList.Count - 1 do
      begin
        lLine := lTempList.Strings[i];
        if Trim(lLine) <> ''  then
        begin
          lTeachCode := Trim(GetSubStr(lLine, 1));
          lTeacherIdx := Teachers.IndexOf(lTeachCode);
          lSubCode := Trim(GetSubStr(lLine, 4));
          if lTeacherIdx = -1 then
          begin
            lTeacher := TAMGTeacher.Create;
            lTeacher.Code := lTeachCode;
            lTeacher.FTeacherName := GetSubStr(lLine, 2);
            Teachers.Add(lTeacher);
          end
          else
          begin
            lTeacher := TAMGTeacher(Teachers.Items[lTeacherIdx]);
            lTeacher.FTeacherName := GetSubStr(lLine, 2);
          end;
          lTeacher.FEmailAddress := GetSubStr(lLine, 3);
          AddSubject(lSubCode);
        end;
      end;
      Teachers.SaveToFile;
      Result := True;
    end;
  finally
    FreeAndNil(lTempList);
  end;
end;

function TAMGTeachers.Refresh: Boolean;
begin
  inherited Refresh;
  Result := False;
end;

function TAMGTeachers.RefreshFromFile: Boolean;
//Teacher Addresses only at this stage, the rest of the details need also to be done here
var
  lTempList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lCode: string;
  lTeacherIDx: Integer;
begin
  inherited RefreshFromFile;
  Result := False;
  //ChDir(GetCurrentDir);
  if FileExists(AMG_TEACHER_FILE) then
  begin
    lTempList := TStringList.Create;
    Cipher:= TDCP_Rijndael.Create(nil);
    try
      lTempList.LoadFromFile(AMG_TEACHER_FILE);
      //decrypt string
      Cipher.InitStr(KeyStrRt,TDCP_sha1);   // initialize the cipher with a hash of the passphrase
      lTempList.Text := Cipher.DecryptString(lTempList.Text);
      Cipher.Burn;
      //retrieve strings
      for i := 0 to lTempList.Count - 1 do
      begin
        lCode := Trim(GetSubStr(lTempList.Strings[i], 1));
        lTeacherIDx := Self.IndexOf(lCode);
        if lTeacherIDx >= 0 then
        begin
          TAMGTeacher(Self.Items[lTeacherIDx]).FTeacherName := GetSubStr(lTempList.Strings[i], 2);
          TAMGTeacher(Self.Items[lTeacherIDx]).FEmailAddress := GetSubStr(lTempList.Strings[i], 3);
        end;
        //TAMGTeacher(Self.Items[lTeacherIDx]).Subjects.Refresh; // #ToDo
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

function TAMGTeachers.Save: Boolean;
var
  i: Integer;
begin
  inherited Save;
  for i := 0 to Self.Count - 1 do
    TAMGTeacher(Self.Items[i]).Save;
  Result := True;
end;

function TAMGTeachers.SaveToFile: Boolean;
//Teacher Addresses only at this stage, the rest of the details need also to be done here
var
  lTempList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lTeacher: TAMGTeacher;
begin
  lTempList := TStringList.Create;
  Cipher:= TDCP_Rijndael.Create(nil);
  try
    ChDir(DataDir);
    for i := 0 to Self.Count -1 do
    begin
      lTeacher := TAMGTeacher(Self.Items[i]);
      lTempList.Add(lTeacher.Code + ',' + lTeacher.TeacherName + ',' + lTeacher.EmailAddress);
    end;
    {encrypt}
    Cipher.InitStr(KeyStrRt, TDCP_sha1);         // initialize the cipher with a hash of the passphrase
    lTempList.Text := Cipher.EncryptString(lTempList.Text);
    Cipher.Burn;
    lTempList.SaveToFile(AMG_TEACHER_FILE);
  finally
    if Assigned(Cipher) then
      FreeAndNil(Cipher);
    if Assigned(lTempList) then
      FreeAndNil(lTempList);
  end;
end;

procedure TAMGTeachers.SetCodeLength(const Value: Integer);
begin
  DBCoord.qrySub.SQL.Text := Format('update Code set CodeLength = %d where CodeName = ''Teacher''', [Value]);
  try
    DBCoord.qrySub.ExecSQL;
  finally
    DBCoord.qrySub.Close;
  end;
  FCodeLength := Value;
end;

{ TAMGDuty }

constructor TAMGDuty.Create;
begin
  inherited;
  FTableName := 'TeacherDuty';
  FPKName := 'TeacherDutyID';
end;

destructor TAMGDuty.Destroy;
begin
  //ToDo
  inherited;
end;

function TAMGDuty.Refresh: Boolean;
begin
  //ToDo
end;

function TAMGDuty.Save: Boolean;
var
  lSubjectID: Integer;
begin
  inherited Save;
  if ID > 0  then
  begin
    DBCoord.qryMain.SQL.Text := Format('update TeacherDuty set DutyCode = %s, DutyName = %s,  DutyLoad = %f where TeacherDutyID = %d',
                                       [QuotedStr(Code),
                                        QuotedStr(FDutyName),
                                        FDutyLoad,
                                        ID]);
  end
  else
  begin
    ID := DBCoord.GetNextID(FTableName, FPKName);
    DBCoord.qryMain.SQL.Text := Format('insert into TeacherDuty(TeacherDutyID, TeacherID, DutyCode, DutyName, DutyLoad) ' +
                                       'values(%d, %d, %s, %s, %f)',
                                       [ID,
                                        FTeacherID,
                                        QuotedStr(Code),
                                        QuotedStr(FDutyName),
                                        FDutyLoad]);
  end;
  DBCoord.qryMain.ExecSQL;
  Result := True;
end;

{ TAMGDuties }

function TAMGDuties.Refresh: Boolean;
begin
  //ToDo
end;

function TAMGDuties.RefreshFromFile: Boolean;
begin
  //ToDo
end;

function TAMGDuties.Save: Boolean;
var
  i: Integer;
begin
  inherited Save;
  for i := 0 to Self.Count - 1 do
  begin
    TAMGDuty(Self.Items[i]).TeacherID := Self.FTeacherID;
    TAMGDuty(Self.Items[i]).Save;
  end;
  Result := True;
end;

function TAMGDuties.SaveToFile: Boolean;
begin
  //ToDo
end;

{ TAMGTeacheFreeTimes }

function TAMGTeacheFreeTimes.Refresh: Boolean;
begin
  //ToDo
end;

function TAMGTeacheFreeTimes.RefreshFromFile: Boolean;
begin
  //ToDo
end;

function TAMGTeacheFreeTimes.Save: Boolean;
begin
  //ToDo
end;

function TAMGTeacheFreeTimes.SaveToFile: Boolean;
begin
  //ToDo
end;

{ TAMGTeacheFreeTime }

constructor TAMGTeacheFreeTime.Create;
begin
  inherited;
  //ToDo
end;

destructor TAMGTeacheFreeTime.Destroy;
begin
  //ToDo
  inherited;
end;

function TAMGTeacheFreeTime.Refresh: Boolean;
begin
  //ToDo
end;

function TAMGTeacheFreeTime.Save: Boolean;
begin
  //ToDo
end;

end.
