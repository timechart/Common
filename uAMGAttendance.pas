unit uAMGAttendance;

interface

uses
  uAMGItem;

type
  TAMGAttendanceCode = class(TAMGItem)
  private
    FCodeName: string;
  public
    property CodeName: string read FCodeName write FCodeName;
  end;

  TAMGAttendanceCodes = class(TAMGItemList)
  public
    function RefreshFromList(const pList: string): Boolean;
    function GetNameByCode(const pCode: string): string;
  end;

  //Attendance objects
  TAMGAttendance = class(TAMGItem)
  private
    FAbsencePeriod: Integer;
    FYearLevel: string;
    FActualAbsenceType: Integer;
    FStudentFirstName: string;
    FApproved: Boolean;
    FActionTaken: Char;
    FAbsenceDate: TDateTime;
    FStudentCode: string;
    FStudentSurname: string;
    FAttended: Char;
    FComment: string;
    FAttendanceAM: string;
    FAttendancePM: string;
  public
    function Refresh: Boolean; override;
    property StudentCode: string read FStudentCode write FStudentCode;
    property StudentSurname: string read FStudentSurname write FStudentSurname;
    property StudentFirstName: string read FStudentFirstName write FStudentFirstName;
    property Attended: Char read FAttended write FAttended;   // P Present, A Absent, L Late
    property ActualAbsenceType: Integer read FActualAbsenceType write FActualAbsenceType;
    property Approved: Boolean read FApproved write FApproved;
    property ActionTaken: Char read FActionTaken write FActionTaken;  //L letter, P Phone
    property AbsenceDate: TDateTime read FAbsenceDate write FAbsenceDate;
    property AbsencePeriod: Integer read FAbsencePeriod write FAbsencePeriod;
    // 1/2 day attendance
    property YearLevel: string read FYearLevel write FYearLevel;   // 2 char KCT table                    Year Level, Student details could be taken from Student object
    property AttendanceAM: string read FAttendanceAM write FAttendanceAM;  // 3 char  KCT table
    property AttendancePM: string read FAttendancePM write FAttendancePM;  // 3 char  KCT table
    property Comment: string read FComment write FComment;
  end;

  TAMGAttendances = class(TAMGItemList)
  public
    function Refresh: Boolean; override;
    function RefreshFromFile: Boolean; override;
    function SaveToFile: Boolean;
    function GetAttendanceIDByStudentAndDate(const pStudentCode: string; const pDate: TDateTime): Integer;
    function ExportDataToCASES21(const pSchool: string): Boolean;
  end;

  TAMGAttendanceSetup = class(TAMGItem)
  private
    FFromDate: TDateTime;
    FToDate: TDateTime;
    FSchoolLogo: string;
  public
    constructor Create; override;
    function Refresh: Boolean; override;
    function RefreshFromFile: Boolean;
    function SaveToFile: Boolean;

    property FromDate: TDateTime read FFromDate write FFromDate;
    property ToDate: TDateTime read FToDate write FToDate;
    property SchoolLogo: string read FSchoolLogo write FSchoolLogo;
  end;

var
  Attendance: TAMGAttendance;
  Attendances: TAMGAttendances;
  AttendanceSetup: TAMGAttendanceSetup;
  AttendanceCodes: TAMGAttendanceCodes;

implementation

uses
  Classes, DCPrijndael, DCPSha1, SysUtils, uAMGConst, uAMGCommon, uAMGGlobal;

{ TAMGAttendance }

function TAMGAttendance.Refresh: Boolean;
begin
  //ToDo
end;

{ TAMGAttendances }

function TAMGAttendances.ExportDataToCASES21(const pSchool: string): Boolean;
var
  lTempList: TStringList;
  i: Integer;
  lAttendance: TAMGAttendance;
begin
  lTempList := TStringList.Create;
  //First create the header
  lTempList.Add(pSchool + ',' +
                IntToStr(DateTimeToNumeric(AttendanceSetup.FFromDate)) + ',' +
                IntToStr(DateTimeToNumeric(AttendanceSetup.FToDate)) + ',,');
  try
    ChDir(DataDir);
    for i := 0 to Self.Count -1 do
    begin
      lAttendance := TAMGAttendance(Self.Items[i]);
      lTempList.Add(lAttendance.StudentCode + ',' +
                    IntToStr(DateTimeToNumeric(lAttendance.AbsenceDate)) + ',' +
                    lAttendance.YearLevel + ',' +
                    lAttendance.FAttendanceAM + ',' +
                    lAttendance.FAttendancePM);
    end;
    {encrypt}
    lTempList.SaveToFile(AMG_ATTEND_EXPORT_FILE);
  finally
    if Assigned(lTempList) then
      FreeAndNil(lTempList);
  end;
end;

function TAMGAttendances.GetAttendanceIDByStudentAndDate(const pStudentCode: string; const pDate: TDateTime): Integer;
var
  i: Integer;
  lAttendance: TAMGAttendance;
  lResult: Integer;
begin
  lResult := -1;
  if Assigned(Self) then
    for i := 0 to Self.Count -1  do
    begin
      lAttendance := TAMGAttendance(Self.Items[i]);
      if (lAttendance.StudentCode = pStudentCode) and (lAttendance.AbsenceDate = pDate) then
      begin
        lResult := i;
        Break;
      end;
    end;
  Result := lResult;
end;

function TAMGAttendances.Refresh: Boolean;
begin
  //ToDo
end;

function TAMGAttendances.RefreshFromFile: Boolean;
//Teacher Addresses only at this stage, the rest of the details need also to
//be done here, this will get all the object data to gether and will boost performance
var
  lList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lID: string;
  lAttendance: TAMGAttendance;
begin
  inherited RefreshFromFile;
  Result := False;
  Self.Clear;
  if FileExists(AMG_ATTEND_FILE) then
  begin
    lList := TStringList.Create;
    Cipher:= TDCP_Rijndael.Create(nil);
    try
      lList.LoadFromFile(AMG_ATTEND_FILE);
      //decrypt string
      Cipher.InitStr(KeyStrRt, TDCP_sha1);   // initialize the cipher with a hash of the passphrase
      lList.Text := Cipher.DecryptString(lList.Text);
      Cipher.Burn;
      //retrieve strings
      for i := 0 to lList.Count - 1 do
      begin
        lAttendance := TAMGAttendance.Create;
        lAttendance.StudentCode := Trim(GetSubStr(lList.Strings[i], 1));
        lAttendance.FStudentSurname := Trim(GetSubStr(lList.Strings[i], 3));
        lAttendance.FStudentFirstName := Trim(GetSubStr(lList.Strings[i], 2));
        lAttendance.AbsenceDate := NumericToDateTime(StrToInt(Trim(GetSubStr(lList.Strings[i], 4))));
        lAttendance.YearLevel := Trim(GetSubStr(lList.Strings[i], 5));
        lAttendance.AttendanceAM := Trim(GetSubStr(lList.Strings[i], 6));
        lAttendance.AttendancePM := Trim(GetSubStr(lList.Strings[i], 7));
        lAttendance.Comment := Trim(GetSubStr(lList.Strings[i], 8));
        Self.Add(lAttendance);
      end;
    finally
      if Assigned(lList) then
        FreeAndNil(lList);
      if Assigned(Cipher) then
        FreeAndNil(Cipher);
    end;
  end;
  Result := True;
end;

function TAMGAttendances.SaveToFile: Boolean;
//This function is specifically designed to create import file for CASES21
var
  lTempList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lAttendance: TAMGAttendance;
begin
  lTempList := TStringList.Create;
  Cipher:= TDCP_Rijndael.Create(nil);
  try
    ChDir(DataDir);
    for i := 0 to Self.Count -1 do
    begin
      lAttendance := TAMGAttendance(Self.Items[i]);
      lTempList.Add(lAttendance.StudentCode + ',' +
                    lAttendance.FStudentSurname + ',' +
                    lAttendance.FStudentFirstName + ',' +
                    IntToStr(DateTimeToNumeric(lAttendance.AbsenceDate)) + ',' +
                    lAttendance.YearLevel + ',' +
                    lAttendance.FAttendanceAM + ',' +
                    lAttendance.FAttendancePM + ',' +
                    lAttendance.Comment);
    end;
    {encrypt}
    Cipher.InitStr(KeyStrRt, TDCP_sha1);         // initialize the cipher with a hash of the passphrase
    lTempList.Text := Cipher.EncryptString(lTempList.Text);
    Cipher.Burn;
    lTempList.SaveToFile(AMG_ATTEND_FILE);
  finally
    if Assigned(Cipher) then
      FreeAndNil(Cipher);
    if Assigned(lTempList) then
      FreeAndNil(lTempList);
  end;
end;

{ TAMGAttendanceConfig }

constructor TAMGAttendanceSetup.Create;
begin
  inherited;
  Self.FFromDate := Now;
  Self.FToDate := Now;
end;

function TAMGAttendanceSetup.Refresh: Boolean;
begin
  //code
end;

function TAMGAttendanceSetup.RefreshFromFile: Boolean;
var
  lList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lID: string;
  lAttendance: TAMGAttendance;
begin
  Result := False;
  if FileExists(AMG_ATTEND_CONFIG_FILE) then
  begin
    lList := TStringList.Create;
    Cipher:= TDCP_Rijndael.Create(nil);
    try
      lList.LoadFromFile(AMG_ATTEND_CONFIG_FILE);
      //decrypt string
      Cipher.InitStr(KeyStrRt, TDCP_sha1);   // initialize the cipher with a hash of the passphrase
      lList.Text := Cipher.DecryptString(lList.Text);
      Cipher.Burn;
      //retrieve strings
      Self.FFromDate := StrToDateTime(Trim(GetSubStr(lList.Strings[0], 1)));
      Self.FToDate := StrToDateTime(Trim(GetSubStr(lList.Strings[0], 2)));
      Self.FSchoolLogo := Trim(GetSubStr(lList.Strings[0], 3));
    finally
      if Assigned(lList) then
        FreeAndNil(lList);
      if Assigned(Cipher) then
        FreeAndNil(Cipher);
      Result := True;
    end;
  end;
end;

function TAMGAttendanceSetup.SaveToFile: Boolean;
var
  lTempList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
begin
  lTempList := TStringList.Create;
  Cipher:= TDCP_Rijndael.Create(nil);
  try
    ChDir(DataDir);
    lTempList.Add(DateTimeToStr(Self.FFromDate) + ',' + DateTimeToStr(Self.FToDate) + ',' + FSchoolLogo);
    {encrypt}
    Cipher.InitStr(KeyStrRt, TDCP_sha1);         // initialize the cipher with a hash of the passphrase
    lTempList.Text := Cipher.EncryptString(lTempList.Text);
    Cipher.Burn;
    lTempList.SaveToFile(AMG_ATTEND_CONFIG_FILE);
  finally
    if Assigned(Cipher) then
      FreeAndNil(Cipher);
    if Assigned(lTempList) then
      FreeAndNil(lTempList);
  end;
end;

{ TAMGAttendanceCodes }

function TAMGAttendanceCodes.GetNameByCode(const pCode: string): string;
var
  i: Integer;
begin
  for i := 0 to Self.Count -1 do
  begin
    if TAMGAttendanceCode(Self.Items[i]).Code = pCode then
    begin
      Result := TAMGAttendanceCode(Self.Items[i]).FCodeName;
      Break;
    end;
  end;
end;

function TAMGAttendanceCodes.RefreshFromList(const pList: string): Boolean;
var
  lTempList: TStringList;
  i: Integer;
  lAttendanceCode: TAMGAttendanceCode;
  lPos: Integer;
  lStr: string;
begin
  lTempList := TStringList.Create;
  try
    lTempList.Text := pList;
    for i := 0 to lTempList.Count - 1 do
    begin
      lAttendanceCode := TAMGAttendanceCode.Create;
      lStr := lTempList.Strings[i];
      lPos := Pos(' ', lStr);
      if lPos > 0 then
      begin
        lAttendanceCode.Code := Copy(lStr, 1, lPos - 1);
        lAttendanceCode.CodeName := Copy(lStr, lPos + 1, Length(lStr));
        Self.Add(lAttendanceCode);
      end;
    end;
  finally
    FreeAndNil(lTempList);
  end;
end;

end.
