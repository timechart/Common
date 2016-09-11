unit uAMGInterview;

interface

uses
  uAMGItem, uAMGTimeTable;

type
  //Break objects

  TAMGPTIVBreak = class(TAMGItem)
  private
    FStartTime: TDateTime;
    FEndTime: TDateTime;
    FBreakLength: Integer;
    FIsFixed: Boolean;
    FBreakName: string;
  public
    function Refresh: Boolean; override;
    property StartTime: TDateTime read FStartTime write FStartTime;
    property EndTime: TDateTime read FEndTime write FEndTime;
    property BreakLength: Integer read FBreakLength write FBreakLength;
    property BreakName: string read FBreakName write FBreakName;  //Max 15 characters
    property IsFixed: Boolean read FIsFixed write FIsFixed;
  end;

  TAMGPTIVBreaks = class(TAMGItemList)
  private
    FMaxBreaks: Integer;
  public
    function Refresh: Boolean; override;
    property MaxBreaks: Integer read FMaxBreaks write FMaxBreaks default 5;
  end;

  //Interview Times objects
  TAMGPTITime = class(TAMGItem)
  private
    FITime: string;
    FPTITimeID: Integer;
  public
    function Refresh: Boolean; override;
    property PTITimeID: Integer read FPTITimeID write FPTITimeID;
    property ITime: string read FITime write FITime;
  end;

  TAMGPTITimes = class(TAMGItemList)
  private
    FNextInterviewTime: string;
    function GetNextInterviewTime: string;
  public
    function Refresh: Boolean; override;
    property NextInterviewTime: string read GetNextInterviewTime write FNextInterviewTime;
  end;

  //Interview objects
  TAMGInterview = class(TAMGItem)
  private
    FTimeID: Integer;
    FTeacherID: Integer;
    FStudentID: Integer;
    FSubjectID: Integer;
    FStudentCode: string;
    FComment: string;
    FFollowUp: string;
    FRoomCode: string;
  public
    function Refresh: Boolean; override;
    property TimeID: Integer read FTimeID write FTimeID;
    property TeacherID: Integer read FTeacherID write FTeacherID;
    property StudentID: Integer read FStudentID write FStudentID;
    property StudentCode: string read FStudentCode write FStudentCode;
    property SubjectID: Integer read FSubjectID write FSubjectID;
    property FollowUp: string read FFollowUp write FFollowUp;
    property Comment: string read FComment write FComment;
    property RoomCode: string read FRoomCode write FRoomCode;
  end;

  TAMGInterviews = class(TAMGItemList)
  private
    FLatestTime: TDateTime;
    FEarliestTime: TDateTime;
    FDayID: Integer;
  public
    function Refresh: Boolean; override;
    function RefreshFromFile: Boolean; override;
    function SaveToFile(const pFileName: string): Boolean;
    function GetIndexByTimeID(const pTimeID: Integer): Integer;
    property DayID: Integer read FDayID write FDayID;
    property EarliestTime: TDateTime read FEarliestTime write FEarliestTime;
    property LatestTime: TDateTime read FLatestTime write FLatestTime;
  end;

var
  PTIVBreaks: TAMGPTIVBreaks;
  PTITime: TAMGPTITime;
  PTITimes: TAMGPTITimes;
  Interview: TAMGInterview;
  Interviews: TAMGInterviews;

implementation

uses
  DateUtils, SysUtils, uAMGCommon, Classes, DCPrijndael, DCPSha1, uAMGGlobal,
  TCommon, uAMGConst;

{ TAMGInterview }

function TAMGInterview.Refresh: Boolean;
begin
  inherited Refresh;
  Result := False;
end;

{ TAMGInterviews }

function TAMGInterviews.GetIndexByTimeID(const pTimeID: Integer): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Self.Count - 1 do
  begin
    if TAMGInterview(Self.Items[i]).TimeID = pTimeID then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function TAMGInterviews.Refresh: Boolean;
begin
  inherited Refresh;
  Result := False;
end;

function TAMGInterviews.RefreshFromFile: Boolean;
//Teacher Addresses only at this stage, the rest of the details need also to
//be done here, this will get all the object data to gether and will boost performance
var
  lList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lTeacherID: Integer;
  lSubjectID: Integer;
  lStudentID: Integer;
  lIntIdx: Integer;

  function GetInterviewsIndex: Integer;
  var
    i: Integer;
  begin
    Result := -1;
    for i := 0 to Self.Count -1 do
    begin
      if (TAMGInterview(Self.Items[i]).FTeacherID = lTeacherID) and
         (TAMGInterview(Self.Items[i]).FSubjectID = lSubjectID) and
         (TAMGInterview(Self.Items[i]).FStudentID = lStudentID) then
        Result := i;
    end;
  end;

begin
  inherited RefreshFromFile;
  Result := False;
  ChDir(GetCurrentDir);
  if (FileExists(AMG_TEACHER_FILE)) and (FileExists(AMG_INTERVIEW_FILE)) then
  begin
    lList := TStringList.Create;
    Cipher:= TDCP_Rijndael.Create(nil);
    try
      lList.LoadFromFile(AMG_INTERVIEW_FILE);
      //decrypt string
      Cipher.InitStr(KeyStrRt, TDCP_sha1);   // initialize the cipher with a hash of the passphrase
      lList.Text := Cipher.DecryptString(lList.Text);
      Cipher.Burn;
      //retrieve strings
      for i := 0 to lList.Count - 1 do
      begin
        lTeacherID := StrToInt(Trim(GetSubStr(lList.Strings[i], 1)));
        lSubjectID := StrToInt(Trim(GetSubStr(lList.Strings[i], 2)));
        lStudentID := StrToInt(Trim(GetSubStr(lList.Strings[i], 3)));
        lIntIdx := GetInterviewsIndex;
        if lIntIdx >= 0 then
        begin
          TAMGInterview(Self.Items[lIntIdx]).FTeacherID := lTeacherID;
          TAMGInterview(Self.Items[lIntIdx]).FSubjectID := lSubjectID;
          TAMGInterview(Self.Items[lIntIdx]).FStudentID := lStudentID;
          TAMGInterview(Self.Items[lIntIdx]).FFollowUp := GetSubStr(lList.Strings[i], 4);
          TAMGInterview(Self.Items[lIntIdx]).FComment := GetSubStr(lList.Strings[i], 5);
        end;
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

function TAMGInterviews.SaveToFile(const pFileName: string): Boolean;
//Interview details such as Commentd and  only at this stage, the rest of the details need also to be done here
var
  Cipher: TDCP_Rijndael;
  i: Integer;
  lInterview: TAMGInterview;
  lList: TStringList;
begin
  lList := TStringList.Create;
  try
    Cipher:= TDCP_Rijndael.Create(nil);
    try
      ChDir(DataDir);
      for i := 0 to Self.Count -1 do
      begin
        lInterview := TAMGInterview(Self.Items[i]);
        if (lInterview.Followup <> '') or (lInterview.Comment <> '') then
          lList.Add(IntToStr(lInterview.FTeacherID) + ',' +
                    IntToStr(lInterview.FSubjectID) + ',' +
                    IntToStr(lInterview.FStudentID) + ',' +
                    lInterview.Followup + ',' +
                    lInterview.Comment);
      end;
      {encrypt}
      Cipher.InitStr(KeyStrRt, TDCP_sha1);         // initialize the cipher with a hash of the passphrase
      lList.Text := Cipher.EncryptString(lList.Text);
      Cipher.Burn;
      lList.SaveToFile(pFileName);
    finally
      if Assigned(Cipher) then
        FreeAndNil(Cipher);
      if Assigned(lList) then
        FreeAndNil(lList);
    end;
  finally
    FreeAndNil(lList);
  end;
end;

{ TAMGPTITime }

function TAMGPTITime.Refresh: Boolean;
begin
  inherited Refresh;
  Result := False;
end;

{ TAMGPTITimes }

function TAMGPTITimes.GetNextInterviewTime: string;
var
  i: Integer;
  lPTITime: TAMGPTITime;
  lPrevTime: string;
  lTime: TDateTime;
  lTimeStr: string;
begin
  lPrevTime := '';
  Result := '';
  lTime := TimeOf(Now);
  for i := 0 to Self.Count - 1 do
  begin
    lPTITime := TAMGPTITime(Self.Items[i]);
    lTimeStr := DateTimeToStr(TimeFrom12HrFormat(lPTITime.ITime));
    if (lPrevTime = '') and (lTime <= StrToDateTime(lTimeStr)) then   //lPTITime.ITime
    begin
      Result := lTimeStr;   //lPTITime.ITime
      Break;
    end
    else if (lPrevTime = '') and (lTime > StrToDateTime(lTimeStr)) then         //lPTITime.ITime
    begin
      //Keep looping
    end
    else if (lPrevTime <> '') and (lTime <= StrToDateTime(lTimeStr)) then    //lPTITime.ITime
    begin
      Result := lTimeStr;  //lPTITime.ITime;
      Break;
    end;

    lPrevTime := lPTITime.ITime;
  end;
end;

function TAMGPTITimes.Refresh: Boolean;
begin
  inherited Refresh;
  Result := False;
end;

{ TAMGPTIVBreak }

function TAMGPTIVBreak.Refresh: Boolean;
begin
  inherited Refresh;
end;

{ TAMGPTIVBreaks }

function TAMGPTIVBreaks.Refresh: Boolean;
begin
  inherited Refresh;
end;

end.
