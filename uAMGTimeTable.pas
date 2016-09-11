unit uAMGTimeTable;

interface

uses
  uAMGItem;

type

  TAMGRoom = class;

  TAMGTimeTable = class(TAMGItem)
  private
    FTimeSlotID: Integer;
    FDayID: Integer;
    FLevelID: Integer;
    FYearID: Integer;
    FTeacherID: Integer;
    FRoomID: Integer;
    FSubjectID: Integer;
  public
    function Refresh: Boolean; override;
    function Save: Boolean; override;
    property DayID: Integer read FDayID write FDayID;
    property TimeSlotID: Integer read FTimeSlotID write FTimeSlotID;
    property YearID: Integer read FYearID write FYearID;
    property LevelID: Integer read FLevelID write FLevelID;
    property SubjectID: Integer read FSubjectID write FSubjectID;
    property TeacherID: Integer read FTeacherID write FTeacherID;
    property RoomID: Integer read FRoomID write FRoomID;
  end;

  TAMGTimeTables = class(TAMGItemList)
  public
    function Refresh: Boolean; override;
  end;

  //Room Objects
  TAMGRoom = class(TAMGItem)
  private
    FRoomName: string;
    FRoomDescription: string;
    FAccessibility: Boolean;
    FExamCapacity: Integer;
    FSeating: Integer;
  public
    constructor Create; override;
    function Refresh: Boolean; override;
    function Save: Boolean;
    property RoomName: string read FRoomName write FRoomName;
    property RoomDescription: string read FRoomDescription write FRoomDescription;
    property Seating: Integer read FSeating write FSeating;
    property ExamCapacity: Integer read FExamCapacity write FExamCapacity;
    property Accessibility: Boolean read FAccessibility write FAccessibility;
  end;

  TAMGRooms = class(TAMGItemList)
  private
    FCodeLength: Integer;
    procedure SetCodeLength(const Value: Integer);
  published
  public
    function Refresh: Boolean; override;
    function Save: Boolean;
    function SaveToFile: Boolean;
    function ImportFromCASES21(const pInputFile: string): Boolean;
    property CodeLength: Integer read FCodeLength write SetCodeLength;
  end;

var
  Room: TAMGRoom;
  Rooms: TAMGRooms;

implementation

uses
  Classes, SysUtils, uAMGCommon, uAMGDBCoord;

{ TAMGTimeTables }

function TAMGTimeTables.Refresh: Boolean;
begin
  inherited Refresh;
  Result := False;
end;

{ TAMGTimeTable }

function TAMGTimeTable.Refresh: Boolean;
begin
  inherited Refresh;
  Result := False;
end;

function TAMGTimeTable.Save: Boolean;
begin
  inherited Save;
  Result := True;
end;

{ TAMGRoom }

constructor TAMGRoom.Create;
begin
  inherited;
  FTableName := 'Room';
  FPKName := 'RoomID';
end;

function TAMGRoom.Refresh: Boolean;
begin
  //code
end;

function TAMGRoom.Save: Boolean;
var
  lAccessibility: Integer;
begin
  inherited Save;
  if RoomName = '' then
    RoomName := Code;

  if FAccessibility then
    lAccessibility := 1
  else
    lAccessibility := 0;

  if DBCoord.AlreadyExists(FtableName, 'RoomCode', Code)  then
  begin
    DBCoord.qryMain.SQL.Text := Format('update Room set RoomName = %s, RoomDescription = %s, Seating = %d, ExamCapacity = %d, Accessibility = %d where RoomCode = %s',
                                       [QuotedStr(FRoomName), QuotedStr(FRoomDescription), FSeating, FExamCapacity, lAccessibility, QuotedStr(Code)]);
  end
  else
  begin
    ID := DBCoord.GetNextID(FTableName, FPKName);
    DBCoord.qryMain.SQL.Text := Format('insert into Room (RoomID, RoomCode, RoomName, RoomDescription, Seating, ExamCapacity, Accessibility) values(%d, %s, %s, %s, %d, %d, %d)',
                                       [ID, QuotedStr(Code), QuotedStr(FRoomName), QuotedStr(FRoomDescription), FSeating, FExamCapacity, lAccessibility]);
  end;
  DBCoord.qryMain.ExecSQL;
  Result := True;
end;

{ TAMGRooms }

function TAMGRooms.ImportFromCASES21(const pInputFile: string): Boolean;
var
  lTempList: TStringList;
  lTempStr: string;
  i: Integer;
  lRoom: TAMGRoom;
begin
  if FileExists(pInputFile) then
  begin
    lTempList := TStringList.Create;
    try
      lTempList.LoadFromFile(pInputFile);
      for i := 0 to lTempList.Count - 1 do
      begin
        lRoom := TAMGRoom.Create;
        lTempStr := StringReplace(lTempList.Strings[i], '"', '', [rfReplaceAll, rfIgnoreCase]);
        lTempStr := Trim(lTempStr);
        lRoom.Code := Trim(GetSubStr(lTempStr, 1));
        if lRoom.Code = ''  then
        begin
          FreeAndNil(lRoom);   // ignore the record with empty code
        end
        else
        begin
          lRoom.FRoomName := Trim(GetSubStr(lTempStr, 2));
          if lRoom.FRoomName = '' then
            lRoom.FRoomName := lRoom.Code;
          lRoom.FSeating := StrToInt(Trim(GetSubStr(lTempStr, 3)));
          lRoom.FRoomDescription := Trim(GetSubStr(lTempStr, 4));
          Self.Add(lRoom);
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

function TAMGRooms.Refresh: Boolean;
begin
  //code
end;

function TAMGRooms.Save: Boolean;
var
  i: Integer;
begin
  inherited Save;
  for i := 0 to Self.Count - 1 do
    TAMGRoom(Self.Items[i]).Save;
  Result := True;
end;

function TAMGRooms.SaveToFile: Boolean;
begin
  //code
end;

procedure TAMGRooms.SetCodeLength(const Value: Integer);
begin
  DBCoord.qrySub.SQL.Text := Format('update Code set CodeLength = %d where CodeName = ''Room''', [Value]);
  try
    DBCoord.qrySub.ExecSQL;
  finally
    DBCoord.qrySub.Close;
  end;
  FCodeLength := Value;
end;

end.
