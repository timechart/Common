  unit GlobalToTcAndTcextra;

interface

const

        OldUserPasswordFilename='TCWP52.DAT';
  OldExtrasUserPasswordFilename='TCEWP52.DAT';
  // UserPasswordFilename='TCEWP52.DAT';

  szTTDayBlock=48100;

  nmbrDays=10;
  nmbrYears=15;
  nmbrLevels=150;
  nmbrSubjects=3000;
  nmbrTeachers=400;
  nmbrRooms=400;
  nmbrPeriods = 20;
  nmbrClass=2000;
  nmbrLabels=1000;
  nmbrHouse=50;
  nmbrStudents=5000;
  nmbrChoices=100;    // was 30
  nmbrOfGroupSubjects=12;
  nmbrBackupDisks=3;
  nmbrFaculty=30;
  nmbrCustom=30;
  nmbrSubsInFaculty=200;  // was 100
  nmbrTeFacs = 4;
  nmbrWindows = 40; {extra for floating toolbars etc.}
  nmbrTags=8;
  maxWinScrollRange:integer=2140483647;
  minCodeFit=5;
  LabelBase=10000;
  LabelBaseOld=1000;
   clRelevantControlOnDlg = $00CEFDFF;   {softer yellow than clyellow which is $FFFF}
  endline = chr(13)+chr(10);
   myGRPALL=0;
  {timetable box selections}
  bxCell=0;
  bxLevel=1;
  bxYear=2;
  bxYrTime=3;
  bxTime=4;
  bxBlock=5;
  bxDay=6;
  bxALL=7; //new in tc5
  szSchool=100;
  szDay = 11;
  szVersion=20;
  szTCvers=35;
  szYearname=10;
  szSubCode=10;
  szSubnameDefault = 25;
  szSubnameMax = 50;
  szTeCode=8;
  szTeName=25;
  szDayName=15;
  szPeriodName=15;
   szClassName=10;

  szHouseName=10;
  szStName=30;
  szStFirst=30;
  szID=15;
  szDutyCode=3;
  szTcLabel=25;
  szCustomAdd=80;

   szPassID=8;   {upped from 7 to match teachers}
  szPassword=10;

  {colour pairs}
  cpNormal=1;
  cpSub=2;  {subject codes}
  cpTeach=3; {teacher codes}
  cpRoom=4;  {room codes}
  cpClass=5; {roll class codes}

type
  tpTtDayBlock = array[1..szTTDayBlock] of byte;
  tpFclash = array [0..nmbrDays, 0..nmbrPeriods] of smallint;
  tpIntPoint = ^smallint;
  tpBytePoint = ^ byte;

  TIntOnChange = Class
    FValue: integer;
    FName: string;
    function getValue: integer;
    procedure setValue(_Value: integer);
  public
    property Value: integer read GetValue write SetValue;
  end;

var
  UserRecordsCount:                smallint;
  ttMain:        array[0..nmbrDays-1] of ^tpTtDayBlock;
  years                         : byte; {years}
  years_minus_1                            : byte; {years-1}
  periods                       : byte; {periods}
  days                          : byte; {days}

  LevelMax:     smallint;
  LevelPrint:   smallint;
  
  ttMainFormat:    byte;

  level                         : array [-1..nmbrYears] of smallint; {no. of levels in year}
  Blocks                        : array [-1..nmbrYears] of smallint; {number of blocks in year}

  Tclash:       tpFclash;
  Rclash:       tpFclash;
  Fclash:       tpFclash;
  TclashTot,RclashTot:   integer;

  dl,pl,yl,ll                   : byte; {top left timetable}
  nd,np,ny,nl                   : byte; {current position}
  hd,hp,hy,hl                   : byte; {home position}
  warn,WSeWarn,WSmWarn          : bytebool; {warning flag}
  arrow                         : byte; {a}
  box                           : byte; {b - cell,level etc if >6 then 0}
 {c-cell           0
   l-level          1
   y-year           2
   z-year time slot 3
   t-time slot      4
   b-block          5
   d-day            6
  }

  ttMemorySetting1: TIntOnChange;
  ttMemSetting2: TIntOnChange;
  ttMemSetting3: TIntOnChange;

  Version:      String[szVersion];  {20 version$}

function FNT(_Day,_Period,_Year,_Level,offset: smallint): tpIntPoint;
function FNTbyte(d,p,y,l,offset: smallint): tpBytePoint;




implementation

function FNT(_Day,_Period,_Year,_Level,offset: smallint): tpIntPoint;
var
 Ad:            word;
 TempPointer:   pointer;
 IntPoint:      tpIntPoint;
begin
  tempPointer:=TtMain[_Day]; //ttMain : array [0..nmbrDays - 1] of ^ tpTtDayBlock;
  Ad:=(word(ttMemSetting2.Value)*word(_Period))+(word(ttMemorySetting1.Value)*word(_Year))+(8*word(_Level))+word(offset);
  //ttmem1, ttmem2, ttmem3        : smallint;
  IntPoint:=tempPointer;
  inc(IntPoint,(Ad div 2));
  result:=IntPoint;
end;

function FNTbyte(d,p,y,l,offset: smallint): tpBytePoint;
var
 Ad:            word;
 TempPointer:   pointer;
 BytePoint:      tpBytePoint;
begin
  tempPointer:=TtMain[d];
  Ad:=(word(ttMemSetting2.Value)*word(P))+(word(ttMemorySetting1.Value)*word(Y))+(8*word(L))+word(offset);
  BytePoint:=tempPointer;
  inc(BytePoint,Ad);
  result:=BytePoint;
end;


{ TIntOnChange }

function TIntOnChange.getValue: integer;
begin
    result := fValue;
end;

procedure TIntOnChange.setValue(_Value: integer);
begin
   fValue :=  _Value;
end;

initialization
  ttMemorySetting1:= TIntOnChange.Create;
  ttMemorySetting1.FName :=  'ttMemorySetting1';
  ttMemSetting2:= TIntOnChange.Create;
  ttMemorySetting1.FName :=  'ttMemSetting2';
  ttMemSetting3:= TIntOnChange.Create;
  ttMemorySetting1.FName :=  'ttMemSetting3';

finalization
  ttMemorySetting1.Free;
  ttMemSetting2.Free;
  ttMemSetting3.Free;

end.
