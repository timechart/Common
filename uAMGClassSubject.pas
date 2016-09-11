unit uAMGClassSubject;

interface

uses
  uAMGItem;

type

  //Class subject objects designed for CASES21 Export
  TAMGClassSubject = class(TAMGItem)
  private
    FSubjectFullName: string;
    FClassNo: Integer;
    FSubjectCode: string;
    FSplitSubjectCode: string;
  public
    function Refresh: Boolean; override;
    property SubjectCode: string read FSubjectCode write FSubjectCode;
    property SubjectFullName: string read FSubjectFullName write FSubjectFullName;
    property SplitSubjectCode: string read FSplitSubjectCode write FSplitSubjectCode;
    property ClassNo: Integer read FClassNo write FClassNo;
  end;

  TAMGClassSubjects = class(TAMGItemList)
  private
    function GetNextClassNumber(const pSubjectCode: string): Integer;
    procedure AddPendingClassSubjects;
    procedure PoplulatePeningClassSubjects;
  public
    function Refresh: Boolean; override;
    function RefreshFromFile: Boolean; override;
    function SaveToFile: Boolean;
    function IndexOf(const pSlitCode: string): Integer;
    function ClassNoOf(const pSplitCode: string): Integer;
    function AddClassSubject(const pSubjectCode, pSplitCode: string): Boolean;
    function RemoveClassSubject(const pSplitCode: string): Boolean;
    function GetRootSubject(const pSplitCode: string): string;
    //function ImportFromCASES21(const pInputFile: string): Boolean;
    function GetClassSubjectByID(const pSplitCode: string): TAMGClassSubject;
    procedure RemoveDuplicates;
  end;

var
  ClassSubjects: TAMGClassSubjects;
  PendingClassSubjects: TAMGClassSubjects;  // this is designed to avoid

implementation

uses
  Classes, SysUtils, uAMGCommon, DCPrijndael, DCPSha1, uAMGConst;

{ TAMGClassSubject }

function TAMGClassSubject.Refresh: Boolean;
begin
  //ToDo
end;

{ TAMGClassSubjects }

function TAMGClassSubjects.GetClassSubjectByID(const pSplitCode: string): TAMGClassSubject;
var
  i: Integer;
  lClassSubject: TAMGClassSubject;
begin
  Result := nil;
  for i := 0 to Self.Count -1 do
  begin
    lClassSubject := TAMGClassSubject(Self.Items[i]);
    if (Trim(lClassSubject.FSplitSubjectCode) = pSplitCode) then
    begin
      Result := lClassSubject;
      Break;
    end;
  end;
end;

{function TAMGClassSubjects.ImportFromCASES21(const pInputFile: string): Boolean;
//When user decides to import form CAES21 file
var
  lTempList: TStringList;
  lTempStr: string;
  i: Integer;
  lClassSubject: TAMGClassSubject;
begin
  if FileExists(pInputFile) then
  begin
    Self.Clear;
    lTempList := TStringList.Create;
    try
      lTempList.LoadFromFile(pInputFile);
      for i := 0 to lTempList.Count - 1 do
      begin
        lClassSubject := TAMGClassSubject.Create;
        lTempStr := StringReplace(lTempList.Strings[i], '"', '', [rfReplaceAll, rfIgnoreCase]);
        lTempStr := Trim(lTempStr);
        lClassSubject.FStudentCode := Trim(GetSubStr(lTempStr, 1));
        lClassSubject.FSubjectCode := Trim(GetSubStr(lTempStr, 2));
        lClassSubject.FSubjectFullName := Trim(GetSubStr(lTempStr, 3));
        lClassSubject.FClassNo := StrToInt(Trim(GetSubStr(lTempStr, 4)));
        lClassSubject.FTeacherCode := Trim(GetSubStr(lTempStr, 5));
        Self.Add(lClassSubject);
      end;
    finally
      FreeAndNil(lTempList);
    end;
  end;
end;}

function TAMGClassSubjects.AddClassSubject(const pSubjectCode, pSplitCode: string): Boolean;
var
  lClassSubject: TAMGClassSubject;
begin
  lClassSubject := TAMGClassSubject.Create;
  lClassSubject.FSubjectCode := GetRootSubject(pSubjectCode);
  lClassSubject.FSplitSubjectCode := pSplitCode;
  lClassSubject.ClassNo := GetNextClassNumber(lClassSubject.FSubjectCode);
  Self.Add(lClassSubject);
end;

function TAMGClassSubjects.GetNextClassNumber(const pSubjectCode: string): Integer;
//Determine the biggest class number and add one to it
var
  lClassSubject: TAMGClassSubject;
  i: Integer;
  lClassNo: Integer;
begin
  lClassNo := 0;
  for i := 0 to Self.Count -1 do
  begin
    lClassSubject := TAMGClassSubject(Self.Items[i]);
    if lClassSubject.FSubjectCode = pSubjectCode then
    begin
      if lClassNo < lClassSubject.FClassNo then
        lClassNo := lClassSubject.FClassNo;
    end;
  end;
  Result := lClassNo + 1;
end;

function TAMGClassSubjects.GetRootSubject(const pSplitCode: string): string;
var
  i: Integer;
begin
  Result := pSplitCode;
  for i :=  0 to Self.Count - 1 do
  begin
    if TAMGClassSubject(Self.Items[i]).FSplitSubjectCode = pSplitCode then
    begin
      Result := TAMGClassSubject(Self.Items[i]).FSubjectCode;
      Break;
    end;
  end;
end;

procedure TAMGClassSubjects.AddPendingClassSubjects;
var
  lSubjectCode: string;
  lSplitCode: string;
  lClassNo: Integer;
  lClassSubject: TAMGClassSubject;
  i: Integer;
begin
  Self.Clear;
  for i := 0 to PendingClassSubjects.Count - 1 do
  begin
    lSubjectCode := TAMGClassSubject(PendingClassSubjects.Items[i]).FSubjectCode;
    lSplitCode := TAMGClassSubject(PendingClassSubjects.Items[i]).FSplitSubjectCode;
    lClassNo := TAMGClassSubject(PendingClassSubjects.Items[i]).FClassNo;
    lClassSubject := TAMGClassSubject.Create;
    lClassSubject.FSubjectCode := lSubjectCode;
    lClassSubject.FSplitSubjectCode := lSplitCode;
    lClassSubject.FClassNo := lClassNo;
    Self.Add(lClassSubject);
  end;
end;

function TAMGClassSubjects.ClassNoOf(const pSplitCode: string): Integer;
var
  i: Integer;
begin
  Result := 1;  // 1 for all the subjects that are not split
  for i :=  0 to Self.Count - 1 do
  begin
    if TAMGClassSubject(Self.Items[i]).FSplitSubjectCode = pSplitCode then
    begin
      Result := TAMGClassSubject(Self.Items[i]).ClassNo;
      Break;
    end;
  end;
end;

function TAMGClassSubjects.IndexOf(const pSlitCode: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i :=  0 to Self.Count - 1 do
  begin
    if TAMGClassSubject(Self.Items[i]).FSplitSubjectCode = pSlitCode then
    begin
      Result := i;
      Break;
    end;
  end;
end;

procedure TAMGClassSubjects.PoplulatePeningClassSubjects;
var
  lSubjectCode: string;
  lSplitCode: string;
  lClassNo: Integer;
  lClassSubject: TAMGClassSubject;
  i: Integer;
begin
  PendingClassSubjects.Clear;
  for i := 0 to Self.Count - 1 do
  begin
    lSubjectCode := TAMGClassSubject(Self.Items[i]).FSubjectCode;
    lSplitCode := TAMGClassSubject(Self.Items[i]).FSplitSubjectCode;
    lClassNo := TAMGClassSubject(Self.Items[i]).FClassNo;
    lClassSubject := TAMGClassSubject.Create;
    lClassSubject.FSubjectCode := GetRootSubject(lSubjectCode);
    lClassSubject.FSplitSubjectCode := lSplitCode;
    lClassSubject.FClassNo := lClassNo;
    PendingClassSubjects.Add(lClassSubject);
  end;
end;

function TAMGClassSubjects.Refresh: Boolean;
begin
  //ToDo
end;

function TAMGClassSubjects.RefreshFromFile: Boolean;
//Class subject is only designed for CASES21 data handling. It occurs in the startup.
var
  lTempList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lClassSubject: TAMGClassSubject;
  lClassNoStr: string;
begin
  inherited RefreshFromFile;
  Result := False;
  if FileExists(AMG_CLASS_SUBJECT_FILE) then
  begin
    Self.Clear;
    lTempList := TStringList.Create;
    Cipher:= TDCP_Rijndael.Create(nil);
    try
      lTempList.LoadFromFile(AMG_CLASS_SUBJECT_FILE);
      //decrypt string
      Cipher.InitStr(KeyStrRt,TDCP_sha1);   // initialize the cipher w  ith a hash of the passphrase
      lTempList.Text := Cipher.DecryptString(lTempList.Text);
      Cipher.Burn;
      //retrieve strings
      for i := 0 to lTempList.Count - 1 do
      begin
        lClassSubject := TAMGClassSubject.Create;
        lClassSubject.FSubjectCode := Trim(GetSubStr(lTempList.Strings[i], 1));
        lClassSubject.FSplitSubjectCode := Trim(GetSubStr(lTempList.Strings[i], 2));
        lClassNoStr := Trim(GetSubStr(lTempList.Strings[i], 3));
        if lClassNoStr <> '' then
          lClassSubject.FClassNo := StrToInt(lClassNoStr)
        else
          lClassSubject.FClassNo := 1;
        Self.Add(lClassSubject);
      end;
    finally
      if Assigned(lTempList) then
        FreeAndNil(lTempList);
      if Assigned(Cipher) then
        FreeAndNil(Cipher);
    end;
  end;
  PoplulatePeningClassSubjects;
  Result := True;
end;

function TAMGClassSubjects.RemoveClassSubject(const pSplitCode: string): Boolean;
var
  lClassSubject: TAMGClassSubject;
  i: Integer;
  lClassNo: Integer;
  lItemIdx: Integer;
  lSubjectCode: string;
begin
  lItemIdx := IndexOf(pSplitCode);
  if lItemIdx <> -1  then
  begin
    lClassSubject := TAMGClassSubject(Self.Items[lItemIdx]);
    lClassNo := lClassSubject.FClassNo;
    lSubjectCode := lClassSubject.FSubjectCode;
    Self.Delete(lItemIdx);
    for i := 0 to Self.Count - 1 do
    begin
      lClassSubject := TAMGClassSubject(Self.Items[i]);
      if (lClassSubject.FSubjectCode = lSubjectCode) and (lClassSubject.FClassNo > lClassNo) then
        Dec(lClassSubject.FClassNo);
    end;
  end;
end;

procedure TAMGClassSubjects.RemoveDuplicates;
var
  i: Integer;
  lCount1: Integer;
  lCount2: Integer;
  lClassSubject: TAMGClassSubject;
begin
  lCount1 := 0;
  while lCount1 < Self.Count do
  begin
    lClassSubject := TAMGClassSubject(Self.Items[lCount1]);
    lCount2 := lCount1 + 1;
    while lCount2 < Self.Count do
    begin
      if (TAMGClassSubject(Self.Items[lCount2]).FSubjectCode = lClassSubject.FSubjectCode) and
        (TAMGClassSubject(Self.Items[lCount2]).FSplitSubjectCode = lClassSubject.FSplitSubjectCode) then
      begin
        Self.Delete(lCount2);
      end;
      Inc(lCount2);
    end;
    Inc(lCount1);
  end;
end;

function TAMGClassSubjects.SaveToFile: Boolean;
//Class subject is only designed to handle CASES21 data
var
  lTempList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lClassSubject: TAMGClassSubject;
begin
  AddPendingClassSubjects;
  RemoveDuplicates;
  lTempList := TStringList.Create;
  Cipher:= TDCP_Rijndael.Create(nil);
  try
    for i := 0 to Self.Count -1 do
    begin
      lClassSubject := TAMGClassSubject(Self.Items[i]);
      lTempList.Add(lClassSubject.FSubjectCode + ',' + lClassSubject.FSplitSubjectCode + ',' + IntToStr(lClassSubject.FClassNo));
    end;
    {encrypt}
    Cipher.InitStr(KeyStrRt, TDCP_sha1);
    lTempList.Text := Cipher.EncryptString(lTempList.Text);
    Cipher.Burn;
    lTempList.SaveToFile(AMG_CLASS_SUBJECT_FILE);
  finally
    if Assigned(Cipher) then
      FreeAndNil(Cipher);
    if Assigned(lTempList) then
      FreeAndNil(lTempList);
  end;
end;

end.
