unit ImportCases21;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, uAMGStudent;

type
  TFrmImportCases21 = class(TForm)
    pnlImportCases21: TPanel;
    pnlButtons: TPanel;
    btnImportCASES21Close: TBitBtn;
    lsbImportCASES21Data: TListBox;
    procedure FormShow(Sender: TObject);
    procedure CopyTextToClipboad(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FImportTeacherOK: Boolean;
    FImportRoomOK: Boolean;
    FImportStudentOK: Boolean;
    FImportSubjectOK: Boolean;
    procedure LoadCases21Students(const pStudents: TAMGImportStudents);
    //procedure LoadStudentSubjecsts(const pStudClassSubjects: TAMGStudentClassSubs);
    procedure AddToLog(const pMsg: string);
    function IsExistingTeacher(const pTeacherCode: string): Boolean;
    function IsExistingRoom(const pRoomCode: string): Boolean;
    function IsExistingSubject(const pSubjectCode: string): Boolean;
  public
    property ImportStudentOK: Boolean read FImportStudentOK write FImportStudentOK;
    property ImportTeacherOK: Boolean read FImportTeacherOK write FImportTeacherOK;
    property ImportSubjectOK: Boolean read FImportSubjectOK write FImportSubjectOK;
    property ImportRoomOK: Boolean read FImportRoomOK write FImportRoomOK;
  end;

var
  FrmImportCases21: TFrmImportCases21;

implementation

uses
  uAMGTeacher, uAMGConst, uAMGCommon, uAMGTimeTable, uAMGSubject, EdHouse,
  TeWnd, RoWnd, SuWnd, uAMGGlobal, TCommon, TimeChartGlobals, TCLoad, StCommon,
  Clipbrd, HouseWnd, uAMGClassSubject, Tcommon2;

{$R *.dfm}

procedure TFrmImportCases21.FormShow(Sender: TObject);
var
  lStudents: TAMGImportStudents;
  lCurrentDir: string;
  lCodePalce: Integer;
  lTeacher: TAMGTeacher;
  lTeachers: TAMGTeachers;
  lRoom: TAMGRoom;
  lRooms: TAMGRooms;
  lSubjects: TAMGSubjects;
  lSubject: TAMGSubject;
  i: Integer;
  lRoomCount: Integer;
  lTeacherCount: Integer;
  lSubjectCount: Integer;
  lFileExt: string;

  function DataFileExists(const pFileName: string): Boolean;
  var
    lFileExists: Boolean;
  begin
    Result := False;
    lFileExt := '';
    lFileExists := FileExists(pFileName + '.txt');
    if lFileExists then
    begin
      lFileExt := '.txt';
      Result := True;
    end
    else
    begin
      lFileExists := FileExists(pFileName + '.csv');
      if lFileExists then
      begin
        lFileExt := '.csv';
        Result := True;
      end;
    end;
  end;
begin
  lCurrentDir := GetCurrentDir;
  try
    ChDir(DataDir);
    AddToLog('CASES21 (Maze) import started.');

    //TT51003 Student data
    if FImportStudentOK then
    begin
      if DataFileExists(AMG_VIC_STUDENT_EXPORT_FILE) then
      begin
        lStudents := TAMGImportStudents.Create;
        try
          lStudents.ConvertDataFile(AMG_VIC_STUDENT_EXPORT_FILE + lFileExt);
          LoadCases21Students(lStudents);
        finally
          FreeAndNil(lStudents);
        end;
      end
      else
      begin
        AddToLog('No student data file was found.');
      end;
    end;

    {//ST51001 Class and Subjects data
    if FileExists(AMG_VIC_CLASSSUBJECTS_EXPORT_FILE) then
    begin
      ClassSubjects.ImportFromCASES21(AMG_VIC_CLASSSUBJECTS_EXPORT_FILE);
      ClassSubjects.SaveToFile;  // It is now persistant

      if ClassSubjects.Count > 0 then
        AddToLog(IntToStr(ClassSubjects.Count) + ' class and subjects records were imported/updated.')
      else
        AddToLog('No class and subjects data were found.');

    end
    else
    begin
      AddToLog('No class and subjects data file was found.');
    end;}

    //TT51002 Staff data
    if FImportTeacherOK then
    begin
      if DataFileExists(AMG_VIC_STAFF_EXPORT_FILE) then
      begin
        lTeacherCount := 0;
        lTeachers := TAMGTeachers.Create;    // This needs to be re-structured to fit within the main Teachers object when data files are gone
        try
          lTeachers.ImportFromCASES21(AMG_VIC_STAFF_EXPORT_FILE + lFileExt, LenCodes[1]);
          if lTeachers.Count > 0 then
          begin
            for i := 0 to lTeachers.Count - 1 do
            begin
              lTeacher := TAMGTeacher(lTeachers.Items[i]);
              if not IsExistingTeacher(lTeacher.Code) then
              begin
                if Copy(lTeacher.Code, 1, 2) = AMG_RESERVED_CODE  then
                begin
                  AddToLog('Teacher ' + lTeacher.Code + ' was ignored because the code starts with 00.');
                end
                else
                begin
                  lCodePalce := FindNextCode(1);
                  TeCode[lCodePalce, 0] := lTeacher.Code;
                  TeName[lCodePalce, 0]:= lTeacher.TeacherFirstName + ' ' + lTeacher.TeacherSurname;

                  Load[lCodePalce] := 0;
                  InsertCode(1, lCodePalce);
                  Inc(lTeacherCount);
                end;
              end;
            end; // for
            if lTeacherCount > 0 then
            begin
              getCodeFontWidths(1);
              UpdateSub(1);
              if (TeWindow <> nil) and Assigned(TeWindow) then
                TeWindow.UpdateWin;
              UpdateWindow(wnInfo);
              if winView[wnFac] > 0 then
                TeCodeWinSelect;
                //UpdateWindow(wnFac);
              AlterTimeFlag := True;
              AlterWSflag := True;
            end;
          end;  // if
          if lTeacherCount > 0 then
            AddToLog(IntToStr(lTeacherCount) + ' staff records have been imported.')
          else
            AddToLog('No staff record was imported.');
        finally
          FreeAndNil(lTeachers);
        end;
      end
      else
      begin
        AddToLog('No staff data file was found.');
      end;
    end;


    //TT51001 Room data
    if FImportRoomOK then
    begin
      if DataFileExists(AMG_VIC_ROOM_EXPORT_FILE) then
      begin
        lRoomCount := 0;
        lRooms := TAMGRooms.Create;
        try
          lRooms.ImportFromCASES21(AMG_VIC_ROOM_EXPORT_FILE + lFileExt);
          if lRooms.Count > 0 then
          begin
            for i := 0 to lRooms.Count - 1 do
            begin
              lRoom := TAMGRoom(lRooms.Items[i]);
              if not IsExistingRoom(lRoom.Code) then
              begin
                if Copy(lRoom.Code, 1, 2) = AMG_RESERVED_CODE  then
                begin
                  AddToLog('Room ' + lRoom.Code + ' was ignored because the code starts with 00.');
                  FreeAndNil(lRoom);
                end
                else
                begin
                  lCodePalce := FindNextCode(2);
                  TeCode[lCodePalce, 1] := lRoom.Code;
                  TeName[lCodePalce, 1]:= lRoom.RoomName;

                  Rosize[lCodePalce] := lRoom.Seating;
                  InsertCode(2, lCodePalce);
                  Inc(lRoomCount);
                end;
              end;
            end;  // for

            if lRoomCount > 0 then
            begin
              getCodeFontWidths(2);
              UpdateSub(2);
              if Assigned(RoWindow) then
                RoWindow.UpdateWin;
              UpdateWindow(wnInfo);
              if winView[wnFac] > 0 then
                UpdateWindow(wnFac);
              AlterTimeFlag := True;
              AlterWSflag := True;
            end;

          end;  // if
          if lRoomCount > 0 then
            AddToLog(IntToStr(lRoomCount) + ' room records have been imported.')
          else
            AddToLog('No room record was imported.');
        finally
          FreeAndNil(lRooms);
        end;
      end
      else
      begin
        AddToLog('No room data file was found.');
      end;
    end;

    //TT51005 Subject data
    if FImportSubjectOK then
    begin
      if DataFileExists(AMG_VIC_SUBJECT_EXPORT_FILE) then
      begin
        lSubjectCount := 0;
        lSubjects := TAMGSubjects.Create;
        try
          lSubjects.ImportFromCASES21(AMG_VIC_SUBJECT_EXPORT_FILE + lFileExt, LenCodes[0]);
          if lSubjects.Count > 0 then
          begin
            for i := 0 to lSubjects.Count - 1 do
            begin
              lSubject := TAMGSubject(lSubjects.Items[i]);
              if not IsExistingSubject(lSubject.Code) then
              begin
                if Copy(lSubject.Code, 1, 2) = AMG_RESERVED_CODE  then
                begin
                  AddToLog('Subject ' + lSubject.Code + ' was ignored because the code starts with 00.');
                  FreeAndNil(lSubject);
                end
                else
                begin
                  lCodePalce := FindNextCode(0);

                  if UpperCase(Trim(lSubject.Code)) = AMG_NA_SUBJECT then
                    subNA := lCodePalce
                  else
                  begin
                    SubCode[lCodePalce] := lSubject.Code;
                    SubName[lCodePalce] := lSubject.SubjectFullName;
                    Link[lCodePalce] := 0;
                    InsertCode(0, lCodePalce);
                    Inc(lSubjectCount);
                  end;
                end;
              end;
            end;  // for

            if lSubjectCount > 0 then
            begin
              getCodeFontWidths(0);
              UpdateSub(0);
              if Assigned(SuWindow) then
                SuWindow.UpdateWin;
              UpdateWindow(wnInfo);
              AlterTimeFlag := True;
              AlterWSflag := True;
              UpdateTimeTableWins;
            end;
          end;  // if
          if lSubjectCount > 0 then
            AddToLog(IntToStr(lSubjectCount) + ' subject records have been imported.')
          else
            AddToLog('No subject record was imported.');
        finally
          FreeAndNil(lSubjects);
        end;
      end
      else
      begin
        AddToLog('No subject data file was found.');
      end;
    end;

    GetCodes;
    loadGroups;
    //UpdateCustomMenus;
    AddToLog('CASES21 (Maze) import is complete.');
  finally
    SetCurrentDir(lCurrentDir);
  end;
end;

function TFrmImportCases21.IsExistingTeacher(const pTeacherCode: string): Boolean;
var
  aStr: string;
  i: Integer;
begin
  Result := False;
  aStr := UpperCase(Trim(pTeacherCode));
  if Length(aStr) > 0 then
    for i := 1 to NumCodes[1] do
      if aStr = Trim(TeCode[i, 0]) then
      begin
        Result := True;
        Break;
      end;
end;

function TFrmImportCases21.IsExistingRoom(const pRoomCode: string): Boolean;
var
  aStr: string;
  i: Integer;
begin
  Result := False;
  aStr := UpperCase(Trim(pRoomCode));
  if Length(aStr) > 0 then
    for i := 1 to NumCodes[2] do
      if aStr = Trim(TeCode[i, 1]) then
      begin
        Result := True;
        Break;
      end;
end;

function TFrmImportCases21.IsExistingSubject(const pSubjectCode: string): Boolean;
var
  aStr: string;
  i: Integer;
begin
  Result := False;
  aStr := UpperCase(Trim(pSubjectCode));
  if Length(aStr) > 0 then
    for i := 1 to NumCodes[0] do
      if aStr = Trim(SubCode[i]) then
      begin
        Result := True;
        Break;
      end;
end;


(*procedure TFrmImportCases21.LoadStudentSubjecsts(const pStudClassSubjects: TAMGStudentClassSubs);
var
  stxFirst, stxName, stxSex, stxID: string;
  stxYear, stxClass, stxHouse,
  stxTutor, stxHome, j, oldnum: Integer;
  sn, tn: array[0..nmbrchoices] of Integer;
  lCount: Integer;
  lStudentClassSub: TAMGStudentClassSub;

  function CheckSkip: Boolean;
  var
    k: Integer;
  begin
    Result := False;
    if oldnum = 0 then
      Exit;
    for k := 1 to oldnum do
    begin
      if ((Stud[k].ID = stxID) and (Stud[k].tcClass = stxClass) and (Stud[k].tutor = stxTutor)) then
      begin
        Result := True;
        Break;
      end;
    end;
  end;

begin
  oldnum := NumStud;
  if FAsubnum > nmbrChoices then
  begin
    MessageDlg('From 0 to ' + IntToStr(nmbrChoices) + ' subjects only!', mtError, [mbOK],0);
    exit;
  end;

  while (lCount < pStudClassSubjects.Count) and (numstud<nmbrStudents) do
  begin
    try
       lStudentClassSub := TAMGStudentClassSub(pStudClassSubjects.Items[lCount]);
       stxfirst := '';
       stxname := '';
       stxsex := '';
       stxyear := 0;
       stxclass := 0;
       stxID := lStudentClassSub.StudentCode;
       stxclass := 0;
       stxclass := lStudentClassSub.ClassNo;   //findClass2(lStudentClassSub.ClassNo);
       stxHouse := 0;
       stxTutor := 0;
       stxTutor := findtutor2(Copy(lStudentClassSub.TeacherCode, 1, LenCodes[1]));
       stxHome := 0;
       {for j:=1 to nmbrchoices do
       begin
         sn[j]:=0;
         tn[j]:=0;
       end;
       if FAsubnum > 0 then
       begin
         for j := 1 to FAsubnum do
           sn[j] := checkCode(0, lStudentClassSub.SubjectCode);
        end;}
    except
    end;

    if checkSkip then
      Continue;
    if TooMany('students',numstud,nmbrStudents) then
    begin
      break;
    end;
    {add stud}
    Inc(numstud);
    SetLength(Stud, (numStud + 1)); {zero based so +1}

    Stud[numstud].stname := stxName;
    Stud[numstud].first := stxFirst;
    Stud[numstud].TCyear := stxYear;
    StudYearFlag[stxyear] := True;
    Stud[numstud].sex := stxSex;
    Stud[numstud].id := stxID;
    Stud[numstud].tcclass := stxClass;
    Stud[numstud].house := stxHouse;
    Stud[numstud].tutor := stxTutor;
    Stud[numstud].home := stxHome;
    Stud[numstud].TCTag := 0;
    for j := 1 to NmbrChoices do
    begin
      Stud[numstud].Choices[j] := sn[j];
      if sn[j] > 0 then
        if j > chmax then
          chmax := j;
      end;

    SetStArrays;

    StudSort[NumStud] := NumStud;

    resetStudentOrder(NumStud);
    Inc(lCount);
  end; {while}
  sortStudents;
  UpdateStudCalcs;
  SaveAllStudentYears;
end;*)

procedure TFrmImportCases21.LoadCases21Students(const pStudents: TAMGImportStudents);
var
  stxFirst, stxName, stxSex, stxID: string;
  stxYear, stxClass, stxHouse, stxTutor, stxHome, OldNum: Integer;
  //sn: array[0..nmbrchoices] of Integer;
  lCount: Integer;
  lStudCount: Integer;
  lStudent: TAMGImportStudent;
  lFound: Boolean;

  function CheckSkip: Bool;
  var
    k: Integer;
  begin
    Result := False;
    if OldNum = 0 then
      Exit;
    for k := 1 to OldNum do
    begin
      try
        if ((Stud[k].stname=stxname) and (Stud[k].first=stxfirst) and (Stud[k].house = stxhouse)  and (Stud[k].TCyear = stxyear)) then
        begin
          Result := True;
          Break;
        end;
      except

      end;
    end;
  end;

begin
  lCount := 0;
  lStudCount := 0;
  lFound := False;
  while (lCount < pStudents.Count) and (numstud < nmbrStudents) do
  begin
    lStudent := TAMGImportStudent(pStudents.Items[lCount]);
    stxname := lStudent.Surname;
    stxfirst := lStudent.Firstname;
    stxyear := 0;
    stxYear := FindYear(lStudent.SchoolYear);
    stxsex := lStudent.Gender;
    stxID := lStudent.StudentCode;
    if stxYear > -1 then
    begin
      if stxyear > -1 then
        stxclass := findclass2(lStudent.HomeGroup)
      else
        stxclass := 0;

      stxhouse := 0;
      stxhouse := findhouse2(lStudent.House);
      if (stxHouse = 0) and (lStudent.House <> '') then  // house not found
      begin
        Inc(HouseCount);
        HouseName[HouseCount] := lStudent.House;
        UpdateHouse;
        HouseLoad;
        if Assigned(HouseWindow) then
          HouseWindow.UpdateWin;

        AddToLog('House "' + lStudent.House + '" was not found and has been added to the list of houses.');
        stxhouse := findhouse2(lStudent.House);
      end;

      stxtutor := 0;
      //stxhome := 0;
      stxhome := findroom2(Copy(lStudent.HomeRoom, 1, LenCodes[2]));

      OldNum := NumStud;
      if not CheckSkip then
      begin
        if TooMany('students', numstud, nmbrStudents) then
          Break;
        //add student
        Inc(numstud);
        SetLength(Stud, (NumStud + 1)); {zero based so +1}

        Stud[numstud].stname := stxname;
        Stud[numstud].first := stxfirst;
        Stud[numstud].TCyear := stxyear;

        StudYearFlag[stxyear] := True;

        Stud[numstud].sex := stxsex;
        Stud[numstud].id := stxid;
        Stud[numstud].tcclass := stxclass;
        Stud[numstud].house := stxhouse;
        Stud[numstud].tutor := stxtutor;
        Stud[numstud].home := stxhome;
        Stud[numstud].tctag := 0;

        SetStArrays;
        StudSort[numStud] := NumStud;
        ResetStudentOrder(NumStud);
        Inc(lStudCount);
        lFound := True;
      end;
    end
    else
    begin
      AddToLog('The record of student "' + stxID + '" was ignored becasue year ' + lStudent.SchoolYear + ' was not found.');
    end;
    Inc(lCount);
  end; //while
  if lStudCount > 0 then
    AddToLog(IntToStr(lStudCount) + ' Student records have been imported.')
  else
    AddToLog('No student record was imported.');

  if lFound then
  begin
    sortStudents;
    UpdateStudCalcs;
    SaveAllStudentYears;
  end;
end;

procedure TFrmImportCases21.AddToLog(const pMsg: string);
begin
  if pMsg <> '' then
  begin
    lsbImportCASES21Data.Items.Add(pMsg);
  end;
end;

procedure TFrmImportCases21.CopyTextToClipboad(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if ((ssCtrl in Shift) and (Key = Ord('C'))) then
    ClipBoard.AsText := lsbImportCASES21Data.Items.Text;
end;

end.
