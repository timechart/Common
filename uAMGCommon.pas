unit uAMGCommon;

interface

uses
  StdCtrls, Grids, Classes, Types;

type
  TOutputType = (otUnknown, otScreen, otPrinter, otPDF);
  TLoginStat = (lsUnknown, lsLogin, lsGeneral, lsQuit);

  function GetVersion: string;
  function GetDeviceType(const pOutputType: TOutputType): string;
  function GetSubStr(const pStr: string; const pPostion: Integer; const pSeparator: string = ','): string;
  function DateTimeToNumeric(const pDateTime: TDateTime): Integer;
  function NumericToDateTime(const pValue: Integer): TDateTime;
  procedure ShuffleTimeTable(const pTimeSlot: Integer);
  function FillSubjectCombo(const pCombo: TComboBox): Integer;
  procedure DisplayGridText(StringGrid: TStringGrid; Rect: TRect; const S: string; Alignment: TAlignment);
  function GetEmailSendMessage(const pEmailCount: Integer): string;
  procedure SetFolderContentAS(const pDir: string; pAttribute: Cardinal);
  function ShortGenderToDescription(const pGender: ShortString): string;
  procedure SortStringGrid(var pStrGrid: TStringGrid; const pCol: Integer; const pAscending: Boolean);
  procedure FindFiles(const FileMask: string; SearchAttr: Integer; FileList: TStringList; Recurse: Boolean);
  function PatternMatch(const Source: string; iSrc: Integer; const Pattern: string; iPat: Integer ): Boolean;
  function ExecWait(strFile, strPath, strOpts: string; Wait: Boolean): Boolean;
  function DownloadFile(pSourceFile, pDestFile: string): Boolean;
  function GetTeacherCoverTally(const pCode: string): Integer;
  function IsAlphaNumeric(const pStr: string): Boolean;
  function IsAlphabetic(const pStr: string): Boolean;
  function IsDirEmpty(const pDir: string): Boolean;
  function IsDirectoryWriteable(const pDir: string): Boolean;
  function GetTtableToRemove(const pDir: string): Boolean;
  function ArchiveData(const pFileName: string): Boolean;
  procedure MessageToLog(const pMsg: string);

implementation

uses
  Windows, Forms, SysUtils, Graphics,
  {$IF PTI} then
    PTIglobals, TimeChartGlobals
  {$ELSEIF TC6NET} then
  TimeChartGlobals
  {$IFEND}
  DateUtils, urlmon, uAMGTeacherAbsence, IDGlobal, uAMGConst, AbZipper, LoadProgress;

function GetVersion: string;
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
  lFileName: string;
begin
  lFileName := Application.ExeName;
  VerInfoSize := GetFileVersionInfoSize(PChar(lFileName), Dummy);
  GetMem(VerInfo, VerInfoSize);
  GetFileVersionInfo(PChar(lFileName), 0, VerInfoSize, VerInfo);
  if Assigned(VerInfo) then
  begin
    VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
    with VerValue^ do
    begin
      Result := IntToStr(dwFileVersionMS shr 16);
      Result := Result + '.' + IntToStr(dwFileVersionMS and $FFFF);
      Result := Result + '.' + IntToStr(dwFileVersionLS shr 16);
      Result := Result + '.' + IntToStr(dwFileVersionLS and $FFFF);
    end;
    FreeMem(VerInfo, VerInfoSize);
  end;
end;

function GetDeviceType(const pOutputType: TOutputType): string;
begin
  case pOutputType of
    otScreen: Result := 'Screen';
    otPrinter: Result := 'Printer';
    otPDF: Result := 'PDF';
  end;
end;

function GetSubStr(const pStr: string; const pPostion: Integer; const pSeparator: string): string;
//Returns substring of a comma separated string pStr that is located between
//comma at number pPosition and the previous comma
var
  CommaPos: Integer;
  i: Integer;
  TempStr: string;
begin
  if pPostion > 0 then
  begin
    CommaPos := Pos(pSeparator, pStr);
    if pPostion = 1 then
    begin
      CommaPos := Pos(pSeparator, pStr);
      if CommaPos = 0 then   // only one field in the text
        Result := Copy(pStr, 1, Length(pStr))
      else
        Result := Copy(pStr, 1, CommaPos - 1);
    end
    else
    begin
      TempStr := Copy(pStr, CommaPos + 1, Length(pStr));
      for i := 2 to pPostion do
      begin
        CommaPos := Pos(pSeparator, TempStr);
        if CommaPos = 0 then
          CommaPos := Length(TempStr) + 1;

        if i = pPostion then
          Result := Copy(TempStr, 1, CommaPos - 1);

        TempStr := Copy(TempStr, CommaPos + 1, Length(TempStr));
      end;
    end;
  end
  else
  begin
    Result := '';
  end;
end;

function DateTimeToNumeric(const pDateTime: TDateTime): Integer;
//This routine takes a DateTime as input and formates it into YYYYMMDD as output.
begin
  Result := YearOf(pDateTime)* 10000 + MonthOf(pDateTime) * 100 + dayOf(pDateTime);
end;

function NumericToDateTime(const pValue: Integer): TDateTime;
//This routine takes a numric value in YYYYMMDD format for a Date as input
//and formates it into TDateTime as output.
begin
  Result := EncodeDateTime(StrToInt(Copy(IntToStr(pValue), 1, 4)),
                           StrToInt(Copy(IntToStr(pValue), 5, 2)),
                           StrToInt(Copy(IntToStr(pValue), 7, 2)), 0, 0, 0, 0);
end;

procedure ShuffleTimeTable(const pTimeSlot: Integer);
{var
  y, d,p,l,b: Integer;
  aFnt, bFnt: tpintpoint;}
begin
 {Optype := 'Move';

 PushTtStackStart(17 + 1);    //utBoxClear  17
 copyTime;

 if CopyStop then exit;
 ttclash;
 UpdateTimetableWins;
 SaveTimeFlag:=True;}
end;

function FillSubjectCombo(const pCombo: TComboBox): Integer;
//Input Combobox to fill, output number of subjects
var
  i: Integer;
begin
  Result := 0;
{$IF not TCP} then
  for i := 1 to CodeCount[0] do
    pCombo.Items.AddObject(SubCode[CodePoint[i, 0]], TObject(i));
  Result := CodeCount[0];
{$IFEND}
end;

procedure DisplayGridText(StringGrid: TStringGrid; Rect: TRect; const S: string; Alignment: TAlignment);
const
  Formats: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);

  procedure WriteText(StringGrid: TStringGrid; ACanvas: TCanvas; const ARect: TRect;
    const Text: string; Format: Word);
  const
    DX = 2;
    DY = 2;
  var
    S: array[0..255] of Char;
  begin
    with Stringgrid, ACanvas, ARect do
    begin
      case Format of
        DT_LEFT: ExtTextOut(Handle, Left + DX, Top + DY,
            ETO_OPAQUE or ETO_CLIPPED, @ARect, StrPCopy(S, Text), Length(Text), nil);

        DT_RIGHT: ExtTextOut(Handle, Right - TextWidth(Text) - 3, Top + DY,
            ETO_OPAQUE or ETO_CLIPPED, @ARect, StrPCopy(S, Text),
            Length(Text), nil);

        DT_CENTER: ExtTextOut(Handle, Left + (Right - Left - TextWidth(Text)) div 2,
            Top + DY, ETO_OPAQUE or ETO_CLIPPED, @ARect,
            StrPCopy(S, Text), Length(Text), nil);
      end;
    end;
  end;

begin
  WriteText(StringGrid, StringGrid.Canvas, Rect, S, Formats[Alignment]);
end;

function GetEmailSendMessage(const pEmailCount: Integer): string;
begin
  if pEmailCount = 0 then
    Result := 'No emails have been sent.'
  else if pEmailCount = 1 then
    Result := '1 email has been sent.'
  else
    Result := IntToStr(pEmailCount) + ' emails have been sent.';
end;

procedure SetFolderContentAS(const pDir: string; pAttribute: Cardinal);
var
  fsRec: Tsearchrec;
  PTfile: string;
begin
  SetFileAttributes(PAnsiChar(pDir), pAttribute);
//  SetFileAttributes(PWideChar(pDir), pAttribute);

  FindFirst(pDir + '\*.*', faArchive, fsRec);
  PTfile := fsRec.Name;
  while (PTfile>'') do
   begin
     SetFileAttributes(PAnsiChar(PTfile), pAttribute);
//     SetFileAttributes(PWideChar(PTfile), pAttribute);
    if FindNext(fsRec) <> 0 then
      PTfile := ''
    else
      PTfile := fsRec.Name;
   end; //while
  FindClose(fsRec);
end;

function ShortGenderToDescription(const pGender: ShortString): string;
begin
  if Trim(UpperCase(pGender)) = 'F' then
    Result := 'Female'
  else if Trim(UpperCase(pGender)) = 'M' then
    Result := 'Male'
  else
    Result := '';
end;

procedure SortStringGrid(var pStrGrid: TStringGrid; const pCol: Integer; const pAscending: Boolean);
const
  TheSeparator = '@';
var
  CountItem, I, J, K, ThePosition: integer;
  MyList: TStringList;
  MyString, TempString: string;
begin
  CountItem := pStrGrid.RowCount;
  MyList := TStringList.Create;
  try
      MyList.Sorted := False;
      begin
        for I := 1 to (CountItem - 1) do
          MyList.Add(pStrGrid.Rows[I].Strings[pCol] + TheSeparator + pStrGrid.Rows[I].Text);
        Mylist.Sort;
        for K := 1 to Mylist.Count do
        begin
          MyString := MyList.Strings[(K - 1)];
          ThePosition := Pos(TheSeparator, MyString);
          TempString  := '';
          {Eliminate the Text of the column on which we have sorted the StringGrid}
          TempString := Copy(MyString, (ThePosition + 1), Length(MyString));
          MyList.Strings[(K - 1)] := '';
          MyList.Strings[(K - 1)] := TempString;
        end;
        if pAscending then
        begin
          for J := 1 to (CountItem - 1) do
            pStrGrid.Rows[J].Text := MyList.Strings[(J - 1)];
        end
        else
        begin
          for J := 1 to (CountItem - 1) do
            pStrGrid.Rows[J].Text := MyList.Strings[(CountItem - J -1)];
        end;
      end;
  finally
    MyList.Free;
  end;
end;

procedure FindFiles(const FileMask: string; SearchAttr: Integer; FileList: TStringList; Recurse: Boolean);
var
  NewFile : string;
  SR : TSearchRec;
  Found : Integer;
  NameMask: string;
begin
  Found := FindFirst( FileMask, SearchAttr, SR );
  if Found = 0 then
  begin
    try
      NameMask := UpperCase(ExtractFileName(FileMask));
      while Found = 0 do
      begin
        NewFile := ExtractFilePath( FileMask ) + SR.Name;
        if (SR.Name <> '.') and (SR.Name <> '..') and PatternMatch(UpperCase(SR.Name), 1, NameMask, 1) then
          FileList.Add(NewFile);
        Found := FindNext(SR);
      end;
    finally
      FindClose(SR);
    end;
  end;
  if not Recurse then
    Exit;
  NewFile := ExtractFilePath(FileMask);
  if (NewFile <> '') and ( NewFile[Length(NewFile)] <> '\') then
    NewFile := NewFile + '\';
  NewFile := NewFile + '*.*';

  Found := FindFirst(NewFile, faDirectory, SR);
  if Found = 0 then
  begin
    try
      while ( Found = 0 ) do
      begin
        if (SR.Name <> '.') and (SR.Name <> '..') and ((SR.Attr and faDirectory) > 0 ) then
          FindFiles(ExtractFilePath( NewFile) + SR.Name + '\' + ExtractFileName(FileMask), SearchAttr,          {!!.04}
                       FileList, True);
        Found := FindNext(SR);
      end;
    finally
      FindClose( SR );
    end;
  end;
end;

function PatternMatch(const Source: string; iSrc: Integer; const Pattern: string; iPat: Integer): Boolean;
{ recursive routine to see if the source string matches
  the pattern.  Both ? and * wildcard characters are allowed.
  Compares Source from iSrc to Length(Source) to
  Pattern from iPat to Length(Pattern)}
var
  Matched : Boolean;
  k : Integer;
begin
  if Length( Source ) = 0 then begin
    Result := Length( Pattern ) = 0;
    Exit;
  end;

  if iPat = 1 then begin
    if CompareStr( Pattern, '*.*') = 0  then
    begin
      Result := True;
      Exit;
    end;
  end;

  if Length( Pattern ) = 0 then
  begin
    Result := (Length( Source ) - iSrc + 1 = 0);
    Exit;
  end;

  while True do
  begin
    if ( Length( Source ) < iSrc ) and (Length(Pattern) < iPat) then
    begin
      Result := True;
      Exit;
    end;

    if Length( Pattern ) < iPat then
    begin
      Result := False;
      Exit;
    end;

    if Pattern[iPat] = '*' then
    begin
      k := iPat;
      if ( Length( Pattern ) < iPat + 1 ) then
      begin
        Result := True;
        Exit;
      end;

      while True do
      begin
        Matched := PatternMatch(Source, k, Pattern, iPat + 1);
        if Matched or (Length(Source) < k) then
        begin
          Result := Matched;
          Exit;
        end;
        inc( k );
      end;
    end
    else begin
      if ( (Pattern[iPat] = '?') and
           ( Length( Source ) <> iSrc - 1 ) ) or
           ( Pattern[iPat] = Source[iSrc] ) then begin
        inc( iPat );
        inc( iSrc );
      end
      else begin
        Result := False;
        Exit;
      end;
    end;
  end;
end;

function ExecWait(strFile, strPath, strOpts: string; Wait: Boolean): Boolean;
 { ---------------------------------------------------------------
   Executes an external program and waits for it to exit.  The
   parameters are:

   -- strFile: The name of the program to execute
   -- strPath: The directory to use.
   -- strOpts: Any command line options needed.
   -- Wait:    Decide whether to wait or not.

   Return value indicates if the application executed and
 completed
   successfully (TRUE).  If not, FALSE is returned.  (Note full
   error handling deleted for this posting.)

   Please note that this implementation is based on Pat Richey's
   WinExecAndWait32, as posted to several newsgroups over the past
   few years; for more info, search groups.google.com
   ---------------------------------------------------------------
 }
var
  si: tStartupInfo;         //Startup info for spawned process
  pi: tProcessInformation;  //Process handle for spawned process
  dwRetval: dWORD;          //Return value from createProcess
begin
  // Initialize the startup info record
  FillChar(si, sizeOf( si ), #0 );
  with si do
  begin
    cb := Sizeof(StartupInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := sw_ShowNormal;
  end; { with }

   //try to launch the application
  strPath := IncludeTrailingBackslash(strPath);
  if not CreateProcess( nil, pchar(strPath + strFile + ' ' + strOpts), nil, nil, FALSE, CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil, pchar(strPath), si, pi) then
  begin
    dwRetval := GetLastError;  //save system error info
     // error handling deleted for brevity; see online help.
    Result := False;  //trigger offer to cancel remaining items
  end
  else
  begin
    if Wait then
      repeat
        Application.ProcessMessages;  //wait
      until (WaitforSingleObject(pi.hProcess, 500) <> WAIT_TIMEOUT);
    //the following saved for future use
    GetExitCodeProcess(pi.hProcess, dwRetval);
    CloseHandle(pi.hProcess);  //clean up
    CloseHandle(pi.hThread);
    Result := True;
  end;
end;

function DownloadFile(pSourceFile, pDestFile: string): Boolean;
begin
  try
    Result := UrlDownloadToFile(nil, PChar(pSourceFile), PChar(pDestFile), 0, nil) = 0;
  except
    Result := False;
  end;
end;

function GetTeacherCoverTally(const pCode: string): Integer;
var
  lTeIdx: Integer;
begin
  Result := 0;
  lTeIdx := TeacherTallies.GetIndex(pCode);
  if lTeIdx > -1  then
  begin
    if TAMGTeacherTally(TeacherTallies.Items[lTeIDx]).Code = pCode then
    begin
      Result := TAMGTeacherTally(TeacherTallies.Items[lTeIDx]).CoverTally;
    end;
  end;
end;

function IsAlphaNumeric(const pStr: string): Boolean;
var
  i: Integer;
  l: integer;
begin
  Result := True;
  if Trim(pStr) <> '' then
  begin
    l := length(trim(PStr));
    for i := 1 to L do
      if not(pStr[i] in ['a'..'z','A'..'Z','0'..'9',' ', ',', '.', '/', '?', ':', ';', '\', '|', '}', ']', '{', '[', '=', '+', '_', '-', ')', '(', '*', '&', '^', '%', '$', '#', '@', '!', '~', '`']) then
      begin
        Result := False;
        Break;
      end;
  end;
end;

function IsAlphabetic(const pStr: string): Boolean;
var
  i: Integer;
  lStr: string;
begin
  Result := True;
  lStr := UpperCase(pStr);
  for i := 1 to Length(lStr) do
  begin
    if not (lStr[i] in ['A'..'Z']) then
    begin
      Result := False;
      Exit;
    end;
  end;
  
end;

function IsDirEmpty(const pDir: string): Boolean;
var
  lSR: TSearchRec;
  i: Integer;
begin
  Result := False;
  FindFirst(IncludeTrailingPathDelimiter(pDir) + '*', faAnyFile, lSR);
  for i := 1 to 2 do
    if (lSR.Name = '.') or (lSR.Name = '..') then
      Result := FindNext(lSR) <> 0;
  FindClose(lSR);
end;

function IsDirectoryWriteable(const pDir: string): Boolean;
var
  lFileName: PChar;
  //lHandle: THandle;
begin
  lFileName := PChar(IncludeTrailingPathDelimiter(pDir) + 'chk.tmp');
  try
    //lHandle := CreateFile(lFileName, GENERIC_READ or GENERIC_WRITE, 0, nil, CREATE_NEW, FILE_ATTRIBUTE_TEMPORARY or FILE_FLAG_DELETE_ON_CLOSE, 0);
    CreateFile(lFileName, GENERIC_READ or GENERIC_WRITE, 0, nil, CREATE_NEW, FILE_ATTRIBUTE_TEMPORARY or FILE_FLAG_DELETE_ON_CLOSE, 0);
  finally
    //Result := lHandle <> INVALID_HANDLE_VALUE;
    Result := FileExists(lFileName);
    if Result  then
      DeleteFile(lFileName);
  end;
end;

function GetTtableToRemove(const pDir: string): Boolean;
var
  fsRec: Tsearchrec;
  FROMdir1, ttwName: string;
begin
  Result := False;
  fsRec.Name := '';
  FROMdir1 := pDir;
  if FROMdir1[length(FROMdir1)] <> '\' then
     FROMdir1 := FROMdir1 + '\';
  FindFirst(FROMdir1 + '*.ttw', faArchive, fsRec);
  while (fsRec.Name > '') do
  begin
    ttwName := UpperCase(fsrec.Name);
    ttwName := Copy(ttwName, 1, Pos('.TTW', ttwName) - 1);  //just the filename - no extension
    if ttwName <> UpperCase(AMG_TTABLE) then
    begin
      Result := True;
      Break;
    end;
    if FindNext(fsRec) <> 0 then fsRec.Name := '';
  end; //while
  FindClose(fsRec);
end;

function ArchiveData(const pFileName: string): Boolean;
var
  AbZipper: TAbZipper;
  lFileList: TStringList;
  i: Integer;
  lFrmLoadProgress: TFrmLoadProgress;
  lProgress: Integer;
  lPrevProgress: Integer;
  lFileName: LPCTSTR;
begin
  Result := False;
  lFileList := TStringList.Create;
  try
    FindFiles('*.*', faAnyFile, lFileList, True);
    AbZipper:= TAbZipper.Create(Application);
    lFrmLoadProgress := TFrmLoadProgress.Create(Application);
    lFrmLoadProgress.Title := AMG_ARCHIVING_DATA;
    try
      lFrmLoadProgress.Show;
      AbZipper.FileName := pFileName;
      Application.ProcessMessages;
      lFileName := PChar(AbZipper.FileName);
      if FileExists(lFileName) then
      begin
        AbZipper.DeleteFiles('*.*');
        Application.ProcessMessages;
      end;

      lProgress := 0;
      lPrevProgress := 0;
      for i := 0 to lFileList.Count - 1 do
      begin
        AbZipper.AddFiles(lFileList.Strings[i], faAnyFile);
        if i > 0 then
          lProgress := Round(i * (100 / lFileList.Count));
        lFrmLoadProgress.UpdateProgress(lProgress - lPrevProgress, 'Adding ' + lFileList.Strings[i] + ' to the archive...', 10);
        lPrevProgress := lProgress;
      end;
      lFrmLoadProgress.UpdateProgress(lProgress - lPrevProgress, AMG_FILES_ARCHIVING_COMPLETE_MSG, 50);
      Application.ProcessMessages;
      if FileExists(AbZipper.FileName) then
        Result := True
      else
        Result := False;
    finally
      AbZipper.CloseArchive;
      AbZipper.Save;
      FreeAndNil(AbZipper);
    end;
  finally
    FreeAndNil(lFrmLoadProgress);
    FreeAndNil(lFileList);
  end;
end;

procedure MessageToLog(const pMsg: string);
var
  lList: TStringList;
  lLogFile: string;
begin
  lLogFile := ExtractFilePath(Application.ExeName) + '\log.txt';
  lList := TStringList.Create;
  if not FileExists(lLogFile) then
    lList.SaveToFile(lLogFile);
  try
    lList.LoadFromFile(lLogFile);
    lList.Add(DateTimetoStr(Now) + Chr(9) + pMsg);
  finally
    lList.SaveToFile(lLogFile);
    FreeAndNil(lList);
  end;
end;

end.
