unit uAMGSubject;

interface

uses
  uAMGItem;

type
  TAMGSubject = class(TAMGItem)
  private
    FYearID: Integer;
    FSubjectShortName: string;
    FSubjectFullName: string;
    FFacultyName: string;
    FReportSubjectName: string;
    FReportSubjectCode: string;
    FYearCode: string;
  public
    constructor Create; override;
    function Refresh: Boolean; override;
    function Save: Boolean; override;
    property SubjectFullName: string read FSubjectFullName write FSubjectFullName;
    property SubjectShortName: string read FSubjectShortName write FSubjectShortName;
    property FacultyName: string read FFacultyName write FFacultyName;  // This is specifically designed for CASES21
    property ReportSubjectCode: string read FReportSubjectCode write FReportSubjectCode;
    property ReportSubjectName: string read FReportSubjectName write FReportSubjectName;
    property YearID: Integer read FYearID write FYearID;
    property YearCode: string read FYearCode write FYearCode;
  end;

  TAMGSubjects = class(TAMGItemList)
  private
    FCodeLength: Integer;
    procedure SetCodeLength(const Value: Integer);
  public
    constructor Create; override;
    function Refresh: Boolean; override;
    function RefreshFromFile: Boolean; override;
    function Save: Boolean; override;
    function SaveToFile: Boolean;
    function ImportFromCASES21(const pInputFile: string; const pCodeLength: Integer): Boolean;
    function IndexOf(const pCode: string): Integer;
    property CodeLength: Integer read FCodeLength write SetCodeLength;
  end;

var
  Subjects: TAMGSubjects;

implementation

uses
  SysUtils, Classes, uAMGCommon, uAMGDBCoord;

{ TAMGTeacher }

constructor TAMGSubject.Create;
begin
  inherited;
  FTableName := 'Subject';
  FPKName := 'SubjectID';
end;

function TAMGSubject.Refresh: Boolean;
begin
  //code
end;

function TAMGSubject.Save: Boolean;
begin
  inherited Save;
  if FSubjectFullName = '' then
    FSubjectFullName := Code;
  if FSubjectShortName = '' then
    FSubjectShortName := Code;
  if FReportSubjectName = '' then
    FReportSubjectName := Code;

  if DBCoord.AlreadyExists(FtableName, 'SubjectCode', Code)  then
  begin
    DBCoord.qryMain.SQL.Text := Format('update Subject set SubjectFullName = %s, SubjectShortName = %s, SubjectReportCode = %s, SubjectReportName = %s, YearID = %d where SubjectCode = %s',
    [QuotedStr(FSubjectFullName), QuotedStr(FSubjectShortName), QuotedStr(FReportSubjectCode), QuotedStr(FReportSubjectName), FYearID, QuotedStr(Code)]);
  end
  else
  begin
    ID := DBCoord.GetNextID(FTableName, FPKName);
    DBCoord.qryMain.SQL.Text := Format('insert into Subject (SubjectID, SubjectCode, SubjectFullName, SubjectShortName, SubjectReportCode, SubjectReportName, YearID) values(%d, %s, %s, %s, %s, %s, %d)',
    [ID, QuotedStr(Code), QuotedStr(FSubjectFullName), QuotedStr(FSubjectShortName), QuotedStr(FReportSubjectCode), QuotedStr(FReportSubjectName), FYearID]);
  end;
  DBCoord.qryMain.ExecSQL;
  Result := True;
end;

{ TAMGSubjects }

function TAMGSubjects.ImportFromCASES21(const pInputFile: string; const pCodeLength: Integer): Boolean;
var
  lTempList: TStringList;
  lTempStr: string;
  i: Integer;
  lSubject: TAMGSubject;
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
          lSubject := TAMGSubject.Create;
          lSubject.Code := lCode;
          lSubject.FSubjectFullName := Trim(GetSubStr(lTempStr, 2));
          if lSubject.FSubjectFullName = '' then
            lSubject.FSubjectFullName := lSubject.Code;
          lSubject.FSubjectShortName := Trim(GetSubStr(lTempStr, 3));
          if lSubject.FSubjectShortName = '' then
            lSubject.FSubjectShortName := lSubject.Code;
          lSubject.FFacultyName := Trim(GetSubStr(lTempStr, 4));
          lSubject.FYearCode := Trim(GetSubStr(lTempStr, 5));
          Self.Add(lSubject);
        end;
      end;
    finally
      FreeAndNil(lTempList);
    end;
  end;
end;

function TAMGSubjects.IndexOf(const pCode: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Self.Count - 1 do
  begin
    if Trim(TAMGSubject(Self.Items[i]).Code) = Trim(pCode) then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function TAMGSubjects.Refresh: Boolean;
begin
  //Code
end;

function TAMGSubjects.RefreshFromFile: Boolean;
begin
  //Code
end;

function TAMGSubjects.Save: Boolean;
var
  i: Integer;
begin
  inherited Save;
  for i := 0 to Self.Count - 1 do
    TAMGSubject(Self.Items[i]).Save;
  Result := True;
end;

function TAMGSubjects.SaveToFile: Boolean;
begin
  //ToDo
end;

procedure TAMGSubjects.SetCodeLength(const Value: Integer);
begin
  DBCoord.qrySub.SQL.Text := Format('update Code set CodeLength = %d where CodeName = ''Subject''', [Value]);
  try
    DBCoord.qrySub.ExecSQL;
  finally
    DBCoord.qrySub.Close;
  end;
  FCodeLength := Value;
end;

constructor TAMGSubjects.Create;
begin
  if Assigned(DBCoord) then
  begin
    DBCoord.qrySub.SQL.Text := 'select CodeLength from Code where CodeName = ''Subject''';
    try
      DBCoord.qrySub.Open;
      FCodeLength := DBCoord.qrySub.FieldbyName('CodeLength').AsInteger;
    finally
      DBCoord.qrySub.Close;
    end;
  end;
end;

end.
