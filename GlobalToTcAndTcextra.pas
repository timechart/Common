  unit GlobalToTcAndTcextra;

interface

const
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
  nmbrWindows=30; // was 29
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

var
  ttMain:        array[0..nmbrDays-1] of ^tpTtDayBlock;
  years                         : byte; {years}
  yr                            : byte; {years-1}
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



implementation

end.
