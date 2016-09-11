unit PTIglobals;    {global variables and constants}

interface

uses  WinProcs, Graphics, Forms;

const
  fgConvertClassFlag = true;
  nmbrPTbreaks=5;
  nmbrTimes = 120;
  nmbrYears=15;
  nmbrLevels=150;
  nmbrMinChmax=5;

  nmbrSubjects=3000;
  nmbrTeachers=400;
  nmbrPTITeachers=200; {leaving teachers 400 above for shared arrays like tename^}
                       {simpler that way}
  nmbrRooms=400;
  nmbrDays=10;
  nmbrPeriods = 20;
  nmbrClass=2000;
  nmbrLabels=1000;
  nmbrHouse=80; {was 50}  {50;  Woodville HS 75}
  nmbrStudents= 5000;
  nmbrChoices=100; // was 30
  nmbrSiblings=6;
  nmbrOfGroupSubjects=12;
  nmbrBackupDisks=3;

  nmbrSubYear=3000;

  nmbrFaculty=30;
  nmbrCustom=30;
  nmbrSubsInFaculty=100; {30  QDE 100}
  nmbrcodeWindows=7;
  nmbrWindows=31;  {31 is find student}
  nmbrTags=8;
  nmbrBoxes=21;
  boxGap=1;

  maxWinScrollRange : integer = 2140483647;
  minCodeFit=10;
  LabelBase=10000;  {1000  QDE 10,000}
  LabelBaseOld=1000;
                            {   $74ffff - yellow , any higher ie $75ffff and we get greyed}
  clRelevantControlOnDlg = $00CEFDFF; {softer yellow than clyellow which is $FFFF}
  endline = chr(13)+chr(10);
  lf = chr(10);
  cr=chr(13); ht=chr(9);
  myGRPALL = 0;
  {timetable box selections}
  bxCell=0;
  bxLevel=1;
  bxYear=2;
  bxYrTime=3;
  bxTime=4;
  bxBlock=5;
  bxDay=6;
  bxALL = 7; //new in tc5

  {string sizes}
  szPTbreakname=15;
  szSchool = 100;
  szDay=5;
  szVersion=20;
  szVersionD=50;
  szTCvers=35;
  szYearname=10;
  szDirName=100;
  szSubCode = 10;
  szSubname=25;
  szTeCode=8;
  szTeName=25;
  szDayName=15;
  szPeriodName=15;
  szTslotcode=2;
  szClassName=10;
  szHouseName=10;
  szStName=30;
  szStSex = 1;
  szStFirst=30;
  szID=15;
  szDutyCode=3;
  szTcLabel=25;
  szCustomAdd=80;
  szFilename=8;
  szFacName=15;
  szTagname=30;

  {other sizes}
  szTTDayBlock=48100;  { was 32004 changed in version 4.3}
  sz2000DayBlock=16002;
  sz2000Params=1001;
  sz8000Params=1000;

  InuseDataFile='TTinUse.DAT';
  PACcustom=1;

  {window numbers}
  wnInfo=1;
  wnSucode=2;
  wnTecode=3;
  wnRocode=4;
  wnRClassCode=5;
  wnHouse=6;
  wnTtable=7;
  wnTeInterview=8;
  wnSubjectList=16;
  wnStudentList=13;
  wnStudRequest=14;
  wnStudNotify=15;
  wnIntTimes=20;
  wnFindStud=24;
  wnFindTeach=25;
  wnFindRoom=26;
  wnTeInterviews = 27;
  {colour pairs}

  tbBase=10000; // base for teacher break,0=not available, 1-nmbrbreaks=break
  tbAbsent=3000; // teacher absent


  cpNormal=1;
  cpSub=2;  {subject codes}
  cpTeach=3; {teacher codes}
  cpRoom=4;
  cpClass=5; {roll class codes}
  cpHouse=6;
  cpInfoHead=7;  {info window headings}
  cpInfo=8;   {info window text}
  cpTclash=9; {teacher clash}
  cpRclash=10; {room clash}
  cpTTblock=11;  {timetable block}
  cpDouble=12;   {timetable double}
  cpDoubleBlock=13; {blocked double}
  cpStList=14;  {student list}
  cpTtable=15;
  nmbrColourPairs=20;


 {sort data}
  sortName: array[0..2] of string[5] =('none','code','name');
  codeName: array[0..2] of string[10] =('subject','teacher','room'); {10 n$(2)}
  codeNameCap: array[0..2] of string[10] =('Subject','Teacher','Room');
  nth: array[1..7] of string[10]=('first','second','third','fourth','fifth',
				  'sixth','seventh');
  groupSortName: array[1..7] of string[8] =('Name','Class','House','ID',
                                            'Value ID','Tutor','Room');

  type tpIntPoint=  ^smallint;
  type tpBytePoint= ^byte;
  type tpSubYearData = array[0..nmbrSubYear] of smallint;
  type tpYearData = array[0..nmbrSubYear] of smallint;
  type tpSubData = array[0..nmbrSubjects] of smallint;
  type tpStudentData = array[0..nmbrStudents] of smallint;

  type tpWinInt = array[0..nmbrWindows] of smallint;
  type tpsibdat = array[1..6] of smallint;
  type tpsibling = array[0..nmbrStudents] of tpsibdat;
  type tpClassName = array[0..nmbrClass,0..nmbrYears] of String[szClassName];
  type tpFclash = array[0..nmbrDays,0..nmbrPeriods] of smallint;
  type tpTeData = array[0..nmbrTeachers] of smallint;
  type tplevelSub2=array[0..nmbrClass,0..nmbryears] of integer;
  type tpfacsubs=array[0..nmbrFaculty,0..nmbrSubsInFaculty] of integer;
  type tpAdd = array[0..nmbrCustom] of String[szCustomAdd];
  type tpTtParameters = array[0..1000] of byte;
  type tpTtDayBlock = array[1..szTTDayBlock] of byte;

  type tpPTTtime = array[0..nmbrPTITeachers,0..nmbrTimes] of smallint;
  type tpPTroom = array[0..nmbrPTITeachers] of smallint;
  type tpFalloc = array[0..600] of smallint;
  tpCustomArr=array[0..nmbrCustom] of string;

  type tpStrRecord = array[0..nmbrStudents] of smallint; {string[2];}
  type tpWinPos=record
                      top:     smallint;
                      left:    smallint;
                      width:   smallint;
                      height:  smallint;
                      state:   Twindowstate;
                end;

 type tpStudRec4=record      {record size 193 bytes}
            StName:       string[20];
            First:        string[20];
            ID:           string[10];
            Sex:          string[1];
            StudYear:     byte;
            tcClass:    smallint;
            House:    byte;
            Tutor:        smallint;
            Home:         smallint;
            earliest:     byte;
            latest:       byte;
            tag:          byte;
            choice:  array[1..nmbrchoices] of record
                                Sub: smallint;
                                Te: byte;
                                Time: byte;
                               end;
            sib:  array[1..6] of smallint;
          end;
type tpStudRec6=record      {record size 218 bytes}
            StName:       string[szStName];
            First:        string[szStName];
            ID:           string[szID];
            Sex:          string[1];
            StudYear:     byte;
            tcClass:    smallint;
            House:    byte;
            Tutor:        smallint;
            Home:         smallint;
            earliest:     byte;
            latest:       byte;
            tag:          byte;
            choice:  array[1..nmbrchoices] of record
                                Sub: smallint;
                                Te: byte;
                                Time: byte;
                               end;
            sib:  array[1..6] of smallint;
          end;




var

  PTMajorVersion:      shortint;
  PTMinorVersion:      shortint;
  PTReleaseVersion:    shortint;
  
  flgNewClassCodes:    bool;
  flgHideNR:  bool;

  InupdateToolbar:     bool;
  showTools:           wordbool;
  UseNewTTWTimetable:     bool;

  UseStudentInterviewDropdowns: WordBool;
  {global flags}
  StHeadShow:          wordbool=true;
  newdataloadcancel:      bool;
  MatchAllYears:      boolean=true;
  scalingGridCellsFlag:   bool;
  LoadFinished:           bool;
  wnFlag: array[0..nmbrWindows] of boolean;
  winView,winViewMax: tpWinInt;

  StudentYearFlag               : array [0..nmbrYears] of wordbool; {from TC6}

  winttLoaded: bool;

  winCodeBrief: array[1..nmbrcodeWindows] of bool;
  tcFont,previewFont:       Tfont;
  txtHeight:    integer;
  Hmargin:      integer;
  blankwidth:   integer;
  Formfeed:     WordBool;
  colorPrinterFlag:                boolean;
  GenericTtableFlag       : wordbool=true;

  {Timetable In Use variables}
  TtInUseNum:               smallint=1;
  TtInUseName               : string;
  TtInUseCalendar           : string='';

  {for DISPLAY.DAT}
  winOrder:       array[0..nmbrWindows] of smallint;    {display.dat}
  winOrderNum:                     smallint;
  prefNotebookPageIndex:           smallint;
  prefTabedNotebookPageIndex:      smallint;
  sTfind:                          smallint;  {1-8 ,by name, sex etc}
  commonDataAll:                   smallint;

  customRequestFrm: smallint;

  {stud list win}
  StudListType:     smallint;  {1-6}
  listNumbertype:   smallint;  {1-5}
  listInterviews:   smallint;
  list24Hrs:        bool;
  listSiblings:     bool;
  listEnrolment:  bool;
  listShowClashes: bool;
  listRanges:    array[1..4,1..2] of smallint; {class to & from, then house then tutor then room}
  liststudentselection: tpstudentdata;

  intTimesBrief: bool;

  {teacher Interview}
  teSelection:  tpteData;
  teIntSelectOn:    wordbool;
  TeWithIntvw:        wordbool;


  {fontWidths}
  fwCode:       array[0..2] of smallint;
  fwCodeBlank:  array[0..2] of smallint;  {used for ttable}
  fwCodename:   array[0..2] of smallint;
  fwStName:     smallint;
  fwHouse:      smallint;
  fwFaculty:    smallint;
  fwSex:        smallint;
  fwID:         smallint;
  fwClass:      smallint;
  fwYearName:   smallint;
  fwPeriodname: smallint;
  fwDayName:    smallint;
  fwDay:        smallint;
  fwTemail:     smallint;
  fwTimeShow:       smallint;
  boxWidth:       smallint;




  {printing}
  PrinterOn,PreviewOn,TextFileOut,CopyOut: boolean;
  PreviewLastZoom: smallint;
  myCopyString:     String;
  PreviewWin:       smallint;
  fwprntCode:       array[0..2] of integer;
  fwprntCodeBlank:  array[0..2] of integer;  {used for ttable}
  fwprntCodename:   array[0..2] of integer;
  fwprntStName:     integer;
  fwprntHouse:      integer;
  fwprntSex:        integer;
  fwprntID:         integer;
  fwprntClass:      integer;
  fwprntYearname:   integer;
  fwprntPeriodname: integer;
  fwprntDayname:    integer;
  fwprntDay:        integer;
  fwPrntTemail:     integer;
  fwPrntTimeShow:       integer;
  prnttxtHeight:    integer;
  prntHmargin:      integer; {canvas units}
  prntVmargin:      integer;
  prntLeftMargin,
  prntTopMargin:    single; {keep cm wanted}

  prntblankwidth:   integer;
  prntboxwidth:   integer;
  prntTopGap:       integer; {grids alligning}

  {General}
  School:       String[szSchool];
  ttVersion:      String[szVersion];
  TCvers:       String[szTCvers];  {20 TCvers$}
  NumCodes:     array[0..2] of smallint;  {subject,teacher,room}
  LenCodes:     array[0..2] of smallint;  {lsub(2)}
  TC4fileHeader:        String[4];
  FontColorPair:   array[0..nmbrColourPairs,1..2] of tcolor;
  FontColorHiLitePair:   array[0..nmbrColourPairs,1..2] of tcolor;

  winpos:       array[0..nmbrWindows] of tpWinPos;
  {timetable data}
  Lnum:         smallint; {Lnum%}
  TcLabel:      array[0..nmbrLabels] of String[szTcLabel];
  Tclash:       tpFclash; {tclash(10,15)}
  Rclash:       tpFclash; {rclash(10,15)}
  Fclash:       tpFclash; {fclash(10,15)}
  TclashTot,RclashTot:   integer;
  Level:        array[0..nmbrYears] of smallint;  {no. of levels in year}
  Blocks:       array[0..nmbrYears] of smallint;  {number of blocks in year}
  LevelMax:     smallint;
  LevelPrint:   smallint;

  ttmem1,ttmem2,ttmem3: smallint;
  ttFileHeader: string[7]; {first 7 bytes in ttfile} {standard one only}
  ttParameters: ^tpTtParameters;
  ttMain:        array[0..nmbrDays-1] of ^tpTtDayBlock;
  ttMainFormat:    byte;
  ttNewFormat:     bool;

  years:          byte;  {years}
  yr:             byte;  {years-1}
  periods:        byte;  {periods}
  days:           byte;  {days}
  dl,pl,yl,ll:    byte; {top left timetable}
  nd,np,ny,nl:    byte;  {current position}
  hd,hp,hy,hl:    byte;  {home position}
  ttxpos,ttypos:  byte; {tt screen cursor pos}
  warn:           byte;  {warning level}
  arrow:          byte;  {a}
  box:            byte;  {b - cell,level etc if >6 then 0}
  {c-cell           0
   l-level          1
   y-year           2
   z-year time slot 3
   t-time slot      4
   b-block          5
   d-day            6
  }
  Bshow,Dshow,Tshow,Rshow:   integer;  {block, double, teach clash, room clash}

  {flags for saving}
  alterTimeFlag:      bool;

  {student data}
  Stud:  array of tpStudRec6;
  StGroup: array of smallint;
  StudSort: array of smallint;
  StPointer: array of smallint;

  YearStat: array [0..nmbrYears] of record
    NumStud: smallint;
    chmax: smallint;
    IDlen: smallint;
    RecordSize: smallint;
    namelen: smallint;
    malenum: smallint;
    femalenum: smallint;
  end;
  numstud:        smallint;
  chmax:          smallint;
  IDlen:          smallint;
  chuse,strec:  smallint;
  {student paste}
  StudPasteID: smallint=2;
  StudPasteSub: smallint=1;
  StudPasteFields: smallint=1;
  StudPasteAddSub               : wordbool=false;

  CF_AMIG_Student_Data          : word;
  CF_AMIG_Timetable_Data        : word;
  CF_AMIG_Block_Data            : word;


  studText,genText              : ansistring;
  GotCr                         : boolean;
  customPaste                   : boolean;
  suMissedCnt,teMissedCnt,
    roMissedCnt                 : integer;

   {Tag data}
  Tagname:   array[0..nmbrTags] of string[szTagname];
  TagCode:   array[0..nmbrTags] of string[2];
  TagsUsed:  array[0..nmbrTags] of boolean;
  TagOrder:  array[0..nmbrTags] of smallint;
  TagOrderNum: smallint;
  TagCalcFlag: boolean=true;

  {group data}
  GroupName:  string[20]; {group$}
  GroupType:  integer;     {Gtype}
  GroupSort:  integer;     {Gsort}
  GroupNum:   integer;     {Gnum}
  groupSelStr:             array[1..2] of string;
  tagGroupAll:              bool;
  tagOverwrite:             bool;

  {year data}
  yearTitle:            string[10]; {Y$}
  yearShort:            string[10]; {Yshort$}
  currentYear:          smallint;   {year}
  currentYearname:      string[szYearName];    {10 year$}
  Yearname:             array[0..nmbrYears] of String[szYearname];  {10 yearname$(10)}

  NumSubYear:           array[0..nmbrYears] of smallint; {numsubyear(9)}
  NumStudYear:          array[0..nmbrYears] of smallint;
  GroupSubs: tpSubYearData; {replaces subyear^}
  GroupSubCount: tpSubYearData; {replaces student^}
  GsubXref: tpSubYearData; {replaces subyearcode^}



  {day data}
  DateStr:      string[30];  {30 date$}
  Day:          array[0..nmbrDays] of String[szDay];  {60 Day$  CHANGE TO 5 Day$(10)}
  Dayname:      array[0..nmbrDays] of String[szDayname]; {10 dayname$(10)}
  PeriodName:   array[0..nmbrPeriods] of String[szPeriodName];
     {variable time slots in each day}
  tsCode:          array [0..nmbrDays,0..nmbrPeriods] of string[sztslotcode];
  tsName: array [0..nmbrDays,0..nmbrPeriods] of String[szPeriodName];
  tsOn: array  [0..nmbrDays,0..nmbrPeriods] of boolean;
  tsShow: array[0..nmbrDays,0..nmbrPeriods] of smallint;
  dg: array[0..nmbrdays,0..nmbrdays] of smallint; {dg - day group}
  tsAllot:  array[0..nmbrdays,0..nmbrperiods] of double;
  tsStart,tsEnd:  array[0..nmbrdays,0..nmbrperiods] of TDateTime;
  TslotUnit,SlotUnitDec,SlotUnitMain: smallint;  {kind of unit, decimal and main places}
  BaseAllot                     : array [0..nmbrPeriods] of double;

  numDayGroups: smallint;
  DayGroup:            array[-1..nmbrDays] of smallint;


  {names of files}
  ttfile:       String;
  TextFileName: String;
  timefile:     String;
  newtimeFile:  String;
  custom:       String;
  PTfile:       String;
  STfile:       String;

  {parent teacher interview data}
  PTheading: string[100];
  PTdate,
  PTReturnBy:     string[50];
  PTstarttime,
  PTendtime,
  PTtimelength,
  PTtimeNum,
  PTmingap,
  PTmaxgap,
  PTTmultiple:    smallint;
  PTallocSpreadType: bool;
  PTbestfit:      bool;
  PTtnum,
  PTfilled,
  PTbestnum,
  PTbestcount:       integer;

  PTbreaknum:     integer;
  PTbreakstart,
  PTbreakend,
  PTbreaklength,
  PTbreaktype:    array[0..nmbrPTbreaks] of integer;
  PTbreakname:    array[0..nmbrPTbreaks] of string[szPTbreakname];
  PTsorttype:       smallint;
  PTconfirm:        bool;

  tiTime: tpPTTtime; // teacher interview times
  teIsAbsent: array[0..nmbrPTITeachers] of wordbool;
  PTroom: tpPTroom;

  {allocate }
  PTfrec:      array[0..7] of integer;

  showStudTimeRange: WordBool;

   {names of directories}
  progdir:      String[szDirName];
  //datadir:      String[szDirName];
  textdir:      String[szDirName];
  timedir:      String[szDirName];
  browsedir:    String[szDirName];
  backupDir:    String[szDirName];


  browsefile:   string;

  {printer settings}
  datestamp:    wordbool;
  double_space: wordbool;
  double_print: smallint;

  {display settings}
  DOSscreenmem: string[20];

  sexselect:    smallint;
  sTselect:     smallint;
  Tslot:        array[0..nmbrPeriods] of smallint;
  Pshow:        array[0..nmbrPeriods] of smallint;
  Pshowmax:     smallint;
  Tyr:          smallint;
  Txtsep:       smallint;
  Txtlim:       smallint;
  Txtsubout:    smallint;
  FAfirst:      wordbool;
  FASex:        Boolean;
  FAyear:       wordbool;
  FAteach:      wordbool;
  FAclass:      wordbool;
  FAhouse:      wordbool;
  FAID:         wordbool;
  FAsubnum:     smallint;
  FAreplace:    wordbool;
  FAtutor:      wordbool;
  FAhome:       wordbool;
  Tlimit:       array[0..nmbrDays] of smallint;
  ttcalcD,ttcalcP,ttcalcY,ttcalcL:     smallint;

  Dprint: array[0..nmbrDays] of boolean;

 {Student Display settings}
  sTyear:     boolean;
  sTsex:      boolean;
  sTclass:    boolean;
  sThouse:      boolean;
  sTtutor:      boolean;
  sThome:       boolean;
  sTID:         boolean;

  {class data}
  TC5WClassCount:   integer;
  LenRollClassCodes: smallint;
  Classcount:       array[0..nmbrYears] of integer;   {num of distinct codes}
  Classnum:         smallint;

  ClassShown:          array[0..nmbrLevels,0..nmbrYears] of smallint;    {whether to show on tt}
  ClassCode:  array of string[szClassName];
  //LenClassCodes                 : smallint;

  RollClassPoint: array of smallint;

  {house data}
  HouseName:        array[0..nmbrHouse] of String[szHouseName];
  HouseCount:       smallint;

  {subject data}
  SubCode:          array[0..nmbrSubjects] of String[szSubCode];
  Subname:          array[0..nmbrSubjects] of String[szSubname];
  subNA:            integer;  //Not Available code
  SubReportCode: array [0..nmbrSubjects] of string[szSubCode];
  SubReportName: array [0..nmbrSubjects] of string[szSubname];
  NumSubRepCodes: Integer;
  LenSubRepCode: Integer;
  LenSubRepName: Integer;

  {custom data}
  Add:              tpAdd;  {80 add$(30)}
  customTab:        array[0..nmbrCustom] of integer; {tab(30)}
  AddNum:           integer;
  gotCustom:        integer;

  {backup data}
  backup_action:        integer;
  backup_number:        integer;
  backup_drive:         string[3];

  {teacher/room data}
  TeCode:       array[0..nmbrTeachers,0..1] of String[szTeCode];
   {0- teachers ;  1-rooms ;  }
  TeName:       array[0..nmbrTeachers,0..1] of String[szTeName];
  Temail:       array of string;
  EmailCoverFlag,EmailAbsentFlag,EmailAddedFlag:  wordbool;

 {transfer data}
 fileout:       boolean;

 {sort data}
 sortType:       array [0..2] of smallint; {0,1, or 2}
 code:           integer;
 codepoint:      array[0..nmbrSubjects,0..2] of smallint;
 codeCount:        array[0..2] of smallint;

 {debug}
 dbgi,dbgj:      integer;

 CustomArr:  tpCustomArr;
 CustomCnt: integer;



implementation

end.
