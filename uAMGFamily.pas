unit uAMGFamily;

interface

uses
  uAMGItem, uAMGStudent, XML.UTILS;

type
  TAMGFamily = class(TAMGItem)
  private
    FFamilyCode: string;
    FStudents: TAMGStudents;
    FHasMultiStudents: Boolean;
    function GetHasMultiStudents: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    function Refresh: Boolean; override;

    property FamilyCode: string read FFamilyCode write FFamilyCode;
    property Students: TAMGStudents read FStudents write FStudents;
    property HasMultiStudents: Boolean read GetHasMultiStudents write FHasMultiStudents;
  end;

  TAMGFamilies = class(TAMGItemList)
  public
    constructor Create; override;
    function Refresh: Boolean; override;
    function RefreshFromFile: Boolean; override;
    function ImportFromSMSFile: Boolean; override;
  end;

  TAMGFamilyClash = class(TAMGItem)
  private
    FFamilyCode: string;
    FStudentCode: string;
    FDay: string;
    FTimeSlot: string;
    FSubjectCode: string;
  public
    property FamilyCode: string read FFamilyCode write FFamilyCode;
    property StudentCode: string read FStudentCode write FStudentCode;
    property Day: string read FDay write FDay;
    property TimeSlot: string read FTimeSlot write FTimeSlot;
    property SubjectCode: string read FSubjectCode write FSubjectCode;
  end;

  TAMGFamilyClashes = class(TAMGItemList)
  public
    constructor Create; override;
    function IsClash(const pIndex: Integer): Boolean;
    function HasFamilyClashOnSubject(const pStudentCode, pSubjectCode: string): Boolean;
    function IsClashAlreadyExist(const pFamilyClash: TAMGFamilyClash): Boolean;
  end;

var
  FamilyClashes:  TAMGFamilyClashes;

implementation

uses
  SysUtils, CLasses, TimeChartGlobals, uAMGCommon;

{ TAMGFamily }

constructor TAMGFamily.Create;
begin
  FStudents := TAMGStudents.Create;
end;

destructor TAMGFamily.Destroy;
begin
  if Assigned(FStudents) then
    FreeAndNil(FStudents);
  inherited;
end;

function TAMGFamily.GetHasMultiStudents: Boolean;
begin
  FHasMultiStudents := Self.Students.Count > 1;
  Result := FHasMultiStudents;
end;

function TAMGFamily.Refresh: Boolean;
begin
  inherited Refresh;
  Result := False;
end;

{ TAMGFamilies }

constructor TAMGFamilies.Create;
begin
  inherited;
  DataFileName := 'FAMILY.DAT';
end;

function TAMGFamilies.ImportFromSMSFile: Boolean;
var
  F: TextFile;
  aStr: string;
  lFamily: TAMGFamily;
  TempList: TStringList;
  j: Integer;
  lFamilyCode: string;
  lPrevFamilyCode: string;
  lStudent: TAMGStudent;
begin
  inherited ImportFromSMSFile;
  Result := False;

  if FileExists(SMSFileName) then
  begin
    try
      AssignFile(F, SMSFileName);
      TempList := TStringList.Create;

      try
        FileMode := fmOpenRead + fmShareDenyNone;
        Reset(F);
        while not Eof(F) do
        begin
          aStr := '';
          Readln(F, aStr);
          aStr := Trim(aStr);
          TempList.Add(GetSubStr(aStr, 2) + ',' + GetSubStr(aStr, 1));
        end;
        TempList.Sort;
        TempList.SaveToFile(Directories.DataDir + '\FAMILY.DAT');
        lPrevFamilyCode := '';
        for j := 0 to TempList.Count - 1 do
        begin
          lFamilyCode := GetSubStr(TempList.Strings[j], 1);
          if lFamilyCode <> lPrevFamilyCode then
          begin
            lFamily := TAMGFamily.Create;
            Self.Add(lFamily);
          end;
          lPrevFamilyCode := lFamilyCode;

          if Assigned(lFamily) then
            lFamily.FamilyCode := lFamilyCode;
          lStudent := TAMGStudent.Create;
          lStudent.Code := GetSubStr(TempList.Strings[j], 2);
          lFamily.Students.Add(lStudent);
        end;
        Result := True;
      finally
         //Testing only
         {aStr := '';
         for j := 0 to Self.Count - 1 do
         begin
           if TAMGFamily(Self.Items[j]).Students.Count > 1 then
             aStr := aStr + #10#13 + TAMGFamily(Self.Items[j]).FamilyCode + '   ' + IntToStr(TAMGFamily(Self.Items[j]).Students.Count);
         end;
         ShowMessage(aStr);}
         CloseFile(F);
         FreeAndNil(TempList);
      end;
    except
    end;
  end;  // if
end;

function TAMGFamilies.Refresh: Boolean;
begin
  inherited Refresh;
  Result := False;
end;

function TAMGFamilies.RefreshFromFile: Boolean;
var
  lFamily: TAMGFamily;
  TempList: TStringList;
  i: Integer;
  lFamilyCode: string;
  lPrevFamilyCode: string;
  lStudent: TAMGStudent;
begin
  inherited RefreshFromFile;
  Result := False;

  if FileExists(DataFileName) then
  begin
    try
      TempList := TStringList.Create;

      try
        TempList.LoadFromFile(DataFileName);
        TempList.Sort;
        lPrevFamilyCode := '';
        for i := 0 to TempList.Count - 1 do
        begin
          lFamilyCode := GetSubStr(TempList.Strings[i], 1);
          if lFamilyCode <> lPrevFamilyCode then
          begin
            lFamily := TAMGFamily.Create;
            Self.Add(lFamily);
          end;
          lPrevFamilyCode := lFamilyCode;

          lFamily.FamilyCode := lFamilyCode;
          lStudent := TAMGStudent.Create;
          lStudent.Code := GetSubStr(TempList.Strings[i], 2);
          lFamily.Students.Add(lStudent);
        end;
      finally
        FreeAndNil(TempList);
      end;
    except
    end;
  end;  // if
end;

{ TAMGFamilyClashes }

constructor TAMGFamilyClashes.Create;
begin
  inherited;
  //ToDo
end;

function TAMGFamilyClashes.HasFamilyClashOnSubject(const pStudentCode, pSubjectCode: string): Boolean;
// This method determines on a certain subject for a certain student whether they have any Family Clash with any other subjects
var
  lFamilyClash: TAMGFamilyClash;
  i: Integer;
begin
  Result := False;
  for i := 0 to Self.Count -1 do
  begin
    lFamilyClash := TAMGFamilyClash(Self.Items[i]);
    if (lFamilyClash.FStudentCode = pStudentCode) and
       (lFamilyClash.FSubjectCode = pSubjectCode) then
    begin
      Result := Self.IsClash(i);
      if Result then
        Break;
    end;
  end;
end;

function TAMGFamilyClashes.IsClash(const pIndex: Integer): Boolean;
var
  i: Integer;
  lDay: string;
  lTimeSlot: string;
begin
  Result := False;
  lDay := TAMGFamilyClash(Self.Items[pIndex]).FDay;
  lTimeSlot := TAMGFamilyClash(Self.Items[pIndex]).FTimeSlot;
  for i := 0 to Self.Count - 1 do
  begin
    if i <> pIndex then
      if (TAMGFamilyClash(Self.Items[i]).FDay = lDay) and (TAMGFamilyClash(Self.Items[i]).FTimeSlot = lTimeSlot) then
      begin
        Result := True;
        Break;
      end;
  end;
end;

function TAMGFamilyClashes.IsClashAlreadyExist(const pFamilyClash: TAMGFamilyClash): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i:= 0 to Self.Count - 1 do
  begin
    if (TAMGFamilyClash(Self.Items[i]).FStudentCode = pFamilyClash.FStudentCode) and
       (TAMGFamilyClash(Self.Items[i]).FDay = pFamilyClash.FDay) and
       (TAMGFamilyClash(Self.Items[i]).FTimeSlot = pFamilyClash.FTimeSlot) and
       (TAMGFamilyClash(Self.Items[i]).FSubjectCode = pFamilyClash.FSubjectCode) then
    begin
      Result := True;
      Break;
    end;
  end;
end;

end.
