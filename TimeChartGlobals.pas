unit TimeChartGlobals;    {global variables and constants}

interface

uses  WinProcs, Graphics, Forms,Controls, StdCtrls, classes,sysutils, XML.UTILS, GlobalToTcAndTcextra;


const
  nmbrUsers=200;
//  SupportExpiryDate:tDateTime=EncodeDate(2004,4,7); //  function EncodeDate(Year, Month, Day: Word): TDateTime;
//  UpdateReleaseDate
  //Limitations
  DEETcasesImportExport = false;
  fgConvertClassFlag = true;
  nmbrYears = 15;
  nmbrSubjects = 3000;
  nmbrteachers = 400;
  nmbrRooms = 400;
  nmbrPeriods = 32; // #1474 increased from 30 to 30 | #1474 increased from 20 Mantis
  nmbrClass = 2000;
  nmbrLevels = 150;
  nmbrLabels = 1000;
  nmbrHouse = 80;
  nmbrstudents = 5000;
  nmbrchoices = 100;     // was 30
  nmbrSolutions = 200;
  nmbrOfGroupSubjects = 12;
  nmbrBackupDisks = 3;
  {match new dynamic group subs to nmbrsubs}
  nmbrSubYear = 3000; {new limit for dynamic group subs}
  nmbrBlocks = 100; { previously 80.. prior to mantis #993}
  nmbrFaculty = 60;
  nmbrCustom = 30;
  nmbrSubsInFaculty = 200; // was 100  #996
  nmbrTeFacs = 4;
  nmbrTags = 16;
  nmbrBoxes=21;
  nmbrTrackSems=8;
  nmbrWSTspecials=5;
  boxGap=1;
  maxWinScrollRange : integer = 2140483647;
  minCodeFit = 1;
  LabelBase = 10000;
  LabelBaseOld = 1000;
  nmbrCustomGroupMenus = 20;
  clRelevantControlOnDlg = $00CEFDFF;   {softer yellow than clyellow which is $FFFF}
  endline = chr(13)+chr(10);
  lf = chr(10);   cr = chr(13);  ht = chr(9);
  myGRPALL = 0;
  {timetable box selections}
  bxCell = 0;
  bxLevel = 1;
  bxYear = 2;
  bxYrTime = 3;
  bxTime = 4;
  bxBlock = 5;
  bxDay = 6;
  bxALL = 7; //new in tc5
  {string sizes}
  szSchool = 100;
  szDay = 11;
  szVersion = 20;
  szTCvers = 35;
  szYearname = 10;
  szSubCode = 10;
  szSubnameDefault = 25;
  szSubnameMax = 50;
  szTeCode = 8;
  szTeName = 25;
  szDayName = 15;
  szPeriodName = 15;
  szTslotcode=2;
  szClassName = 10;
  szHouseName = 10;{Woodville HS 20}
  szStName = 30;
  szStFirst = 30;
  szID = 15;
  szDutyCode = 3;
  szTcLabel = 25;
  szCustomAdd = 80;
  szFacName = 15;
  szTagname=30;
  {other sizes}
  szTTDayBlock = 48100; { was 32004 changed in version 4.3}
  sz2000DayBlock = 16002;
  sz2000Params = 1001;
  sz8000Params = 1000;
  szWScell = 12;
 {network version}
  szPassID=8;   {upped from 7 to match teachers}
  szPassword=10;

  szTC52PassRec=17+szPassID+szUserDirName;
  szTCP2rec=25;     {old one for load old users}

  szTCWP1rec=28+szPassID;
  szIdleDelay=100; {number of milliseconds}
  szIdleRetries=50; {number of times to retry}

  RollMarkerCheckFile='RM.DAT';

  {sort data}
  sortName : array [0..2] of string[5] = ('none', 'code', 'name' );
  codeName: array [0..3] of string[10]=('subject','teacher','room','roll class' );
  codeNameCap: array [0..3] of string[10]=('Subject','Teacher','Room','Roll Class' );
  TslotUnitName: array[0..3] of string[10]=('Minutes','Hours','Periods','Units');

  nth : array [1..7] of string[10] = ('first', 'second', 'third',
    'fourth', 'fifth', 'sixth', 'seventh' );
{Network access and encryption}
  accessType: array[0..8] of string[20] =('General','Timetabler',
    'Student Data','Blocking','Extras','Fees','Supervisor','','');
  encryptStr: string[szPassword]='TIME CHART';
  encryptStrDIR: string[szUserDirName]='BART HAD A WITTLE TIME CHART WAMB, HER TIME'+
  ' CHART FWEECE WAS WHITE AS TIME CHART SNOW, AND EVERYWHERE THAT TIME CHART WENT, THE ';

  groupSortName : array [0..7] of string[10] = ('Year', 'Name',
    'Roll Class', 'House', 'ID', 'Value ID', 'Tutor', 'Room' );
  nmbrScrollHints = 37;
  scrollHinttxt : array [1..nmbrScrollHints] of string
  =('Visit our web site at www.amig.com.au for news of updates.',                //1
    'Click the right mouse button to open the context menu for any window.',     //2
    'Open the main window''s context menu for quick student group selection.',   //3
    'Lodge issue reports at our web site - www.amig.com.au',                       //4
    'Double click on an entry on the timetable or worksheet to change it.',      //5
    'Press F1 on any window, dialogue or menu item to see context sensitive Help.',//6
    'Our web site at www.amig.com.au has a Frequently Asked Questions section.',   //7
    'Download the Time Chart manual (pdf format) from our web site.',               //8
    'Click on a code in a code window to select it.  Press Enter to change it.',   //9
    'Lodge suggestions for improvements at our web site - www.amig.com.au',       //10
    'Use Move subject (Blocks window) to step a subject through the blocks.',      //11
    'The Info window shows male and female numbers for each year',                 //12
    'Create your own student groups, save them and add them to the group menu. You can have up to 20 student groups.',  //13
    'Print wide reports for the Timetable, Worksheet, Blocks or Clash matrix '+
       'windows across multiple pages',                                          //14
    'The Worksheet entries dialogue is interactive. Click on a different' +
    ' place on the Worksheet while it''s open to edit that entry.',               //15
    'Use Ctrl+X, Ctrl+C and Ctrl+V to cut copy and paste selected entries' +
    ' for the Timetable, Worksheet and Blocks windows',                          //16
    'When working with list boxes (on Selection dialogues), double click to transfer'+
      ' selected items',                                                           //17
    'The toolbars (General, Blocks, Timetable and Worksheet) can be docked or floating.',//18
    'The timetable entries dialogue is interactive. Click on a different' +
    ' place on the timetable while it''s open to edit that entry.',               //19
    'The Student Input window can print subject selection sheets with barcodes.', //20
    'Press the "V" key to change view on windows with two or more views.',        //21
    'Backup to any drive or folder.  Backup to folders on your USB flash drive.', //22
    'Email your suggestions for improvements to Time Chart to support@amig.com.au',  //23
    'Select Display | Preferences and click on the General page to set how often'
       + ' Time Chart checks for a new update online.',                           //24
    'Select File | New Data to check or set the location of the data files.',     //25
    'A new Time Chart CD is sent when you renew or begin a Time Chart Support Plan.'
      + ' Install Time Chart from this CD to update your support expiry date.',   //26
    'Select Window | Info to check your Support expiry date.',                    //27
    'Use the Group Subjects window to remove, replace or add a subject choice'
      +' for the whole student group.',                                          //28
    'Renew your Time Chart support plan to download updates with new features'
       + ' and enhanements',                                                       //29
    'Use a barcode reader for fast entry of student choices.  Configure your '
       +'barcode reader so it doesn''t add additional characters like linefeeds.', //30
    'Accidentally deleted something on the Timetable or Worksheet window?'
       +' Don''t panic, just select Edit | Undo to get it back.',                 //31                    //31
    'Select Timetable | In Use (or In Use combobox on Timetable toolbar) to set the default timetable.',                   //32
    'Use the the Time Chart backup and restore commands to easily transfer data'
       +' between your school and home computer.',                               //33
    'Transfer student data easily with copy and paste from the Student List window', // 34
    'Copy and paste student data from your spreadsheet into the Student List window.'
    +' Use one line per student and one field per cell (surname first & no headers).', //35
    'Set target times before building your timetable.  You can exclude time slots'
      +' used for duties rather than lessons.',                                     //36
    'When your timetable is nearly complete, use Room Fill to add missing rooms.'); //37

  myLogOnFileExt='.ON';
  accessCountMax=120;

{window numbers}
  wnInfo=1;
  wnSucode=2;
  wnTecode=3;
  wnRocode=4;
  wnRClassCode=5;
  wnFac=6;
  wnHouse=7;
  wnTimes=8;
  wnGroupSub=9;
  wnBlock=10;
  wnSubjectList=11;
  wnTimeList=12;
  wnStudentList=13;
  wnCmatrix=14;
  wnStInput=15;
  wnStudentTt=16;
  wnTtable=17;
  wnCHelp=18;
  wnBlockClashes=19;
  wnTeClash=20;
  wnRoClash=21;
  wnTeFree=22;
  wnRoFree=23;
  wnTeTimes=24;
  wnSuTimes=25;
  wnGroupTe=26;
  wnTeacherTt=27;
  wnRoomTt=28;
  wnSubjectTt=29;
  wnTeList=30;
  wnStBlClash=31;
  wnStFRee=32;
  wnGenTool=33;
  wnTtTool=34;
  wnBlTool=35;
  wnWsTool=36;
  wnFindStud=37;
  wnShowUsers=38;
  wnWorksheet=39;

 {dummy 'windows' for custom text file export only}
  wnUserExport1=40;
  wnUserExport2=41;
  wnUserExport3=42;
  wnUserExportStud=43;

 {clipformat - Clipboard formats}
  cfTtable=1;
  cfBlock=2;

 {user types}
  utGen=0;
  utTime=1;
  utStud=2;
  utBlock=3;
  utExtra=4;
//  utFees=5;  {old student fees}
  utSuper=6;

  {colour pairs}
  cpNormal=1;
  cpSub=2;  {subject codes}
  cpTeach=3; {teacher codes}
  cpRoom=4;  {room codes}
  cpClass=5; {roll class codes}
  cpFac=6; {faculties}
  cpHouse=7; {houses}
  cpInfoHead=8;  {info window headings}
  cpInfo=9;   {info window text}
  cpTclash=10; {teacher clash}
  cpRclash=11; {room clash}
  cpTTblock=12;  {timetable block}
  cpDouble=13;   {timetable double}
  cpDoubleBlock=14; {blocked double}
  cpStList=15;  {student list}
  cpBlockClash=16;
  cpWorksheet=17;
  cpBlocks=18;
  cpTtable=19;
  nmbrColourPairs=20;

  {rotype - room assignment type}
  rtNone=0;
  rtSub=1;
  rtTeach=2;
  rtFac=3;
  rtTTable=4;
 {encryption key}
  KeyStrRt='©Ncevy 2004ª¹°¿ NZVT FLFGRZF¶@±GP5.2 Argjbex¾´·ºß';

type

  tpCmatrixSelection = array [0..nmbrSubYear] of smallint;
  tpYearData = array [0..nmbrSubYear] of smallint;
  tpPeriodData = array[0..nmbrPeriods] of smallint;
  tpSubData = array [0..nmbrSubjects] of smallint;
  tpstudentdata = array [0..nmbrstudents] of smallint;
  tpClassShown = array [0..nmbrLevels, 0..nmbrYears] of smallint;
  tpTeData = array [0..nmbrteachers] of smallint;

  tplevelSub = array [0..nmbrLevels] of smallint;
  tpAdd = array [0..nmbrCustom] of String[szCustomAdd];
  tpTtParameters = array [0..1000] of byte;
  tpEdit9 = array [1..nmbrchoices] of tedit;

  tpWSBlock = array of byte;
  tpWSFclash = array [0..nmbrblocks] of smallint;

type
  tpWinPos = record
    top: smallint;
    left: smallint;
    width: smallint;
    height: smallint;
    state: Twindowstate;
  end;

type
  tpGroupIngredient = record
    slct: smallint;
    meth: smallint;
    e1: string[10];
    e2: string[10];
  end;

type
  tpGroupMix = record
    NumSteps: smallint;
    steps: array of tpGroupIngredient;
    SubOfferName: string;
  end;

type
  tpStudRec = record
    stname: string[szStName];
    first: string[szStName];
    Choices: array [0..nmbrchoices] of smallint;
    Sex: string[1];
    ID: string[szID];
    tcClass: smallint;
    TcYear: smallint; {new 5.0}
    House: smallint;
    tutor: smallint;
    home: smallint;
    TcTag: word;
    strRecord: smallint;
  end;

  tpTrackData=record
   subs: array[1..nmbrTrackSems,0..nmbrchoices] of smallint;
   tes: array[1..nmbrTrackSems,0..nmbrchoices] of smallint;
  end;

var

  JimsDevMode: boolean = False;

//  studID2: array[0..nmbrstudents] of string[szID];
  studID2: array[0..nmbrstudents] of string[50];
  studEmail: array[0..nmbrstudents] of string[100];

  HaveDataLock: bool;
  UpdateReleaseDate: tDateTime;
  SupportExpiryKeyCheckDate: tDateTime;

  LastUpdateCheck: tDateTime;

  textExportExtension           : string='TXT';
  Transfer1Caption: string='Transfer 1';
  Transfer2Caption: string='Transfer 2';

  {passwords}


  passcount: array[0..10] of smallint;

  genderShort: array[0..1] of string[1]=('M','F');
  genderLong: array[0..1] of string=('Male','Female');  

  usrPassTime:            string[8];
  usrPassDate:            string[8];
  usrPassLevel:           smallint;
  usrPassDir:             string[szUserDirName];
  usrPassUse:             smallint;
  usrPassYear:            smallint;
  usrPassYearLock:        smallint;
  usrPassID:              string[szPassID];
  usrPassword:            string[szPassword];
  usrPassBKUP:            boolean;

  usrpassAlter:           bool;
  CurrentUserRecordIndex:          smallint;

  NEW_DateChecks:         array[0..41] of tDateTime;
 //track which sections the user has locked at any stage
  usrDataSectionLocked: array[1..accessCountMax] of bool;
  usrAccessTime: string;
  CheckForMouldyDataFlag: bool;
  MouldyDataCheckTime: smallint;
  MouldAge:            smallint;
  KeyFileOK:    boolean;
  CustomerIDnum: integer=0;
  Cases21Flag : boolean=false;
  OberonShow: boolean=false;


 {tracking data for past choices}
  StudTrack: array of tpTrackData;
  HasStudTrackData: boolean=false;

   {Roll Marker Export flags}
  RollMarkerFlg:       bool=false;
  RollMarkerExport1     : bool=false;     //scourses.txt - student id,class code,subject code,teacher code,year level
  RollMarkerExport2     : bool=false;     //ttable.txt - day (as number),period,class code,subject code,teacher code,room,year level
  RollMarkerExport3     : bool=false;     //students.txt - student id, surname,first name,[preferred name],gender,year level,home group,status (ie current),[home group teacher code]
  RollMarkerExport4     : bool=false;     //staff.txt - teacher code,teacher name,[teacher title (eg Mr Mrs)]

  {Timetable In Use variables}
  TtInUseNum:               smallint=1;
  TtInUseCalendar           : string='';

  ///  debugSpeedTime:    array[0..50,0..4] of word;
  VertTile                      : wordbool=false;
                
  DEETQuiltKey                  : ansistring;
  CF_AMIG_Student_Data          : word;
  CF_AMIG_Timetable_Data        : word;
  CF_AMIG_Block_Data            : word;

  studText,genText              : ansistring;
  GotCr                         : boolean;
  customPaste                   : boolean;
  suMissedCnt,teMissedCnt,
    roMissedCnt                 : integer;


  UseNewTTWTimetable            : wordbool=true;
  {global flags}
  needClashMatrixRecalc         : wordbool;
  loadFinished                  : wordbool;
  wnFlag: array[0..nmbrWindows] of boolean;
  winView:    array[0..nmbrWindows] of smallint;

  previewfont:           Tfont;
  txtHeight                     : smallint;
  Hmargin                       : smallint;
  blankwidth                    : smallint;

  {text files}
  delim                         : string;
  delim2                        : string;
  txt_f                         : textfile;
  {txt_filename: string;}
  {for DISPLAY.DAT}

  {stud list win}
  

  
  liststudentselection          : tpstudentdata;

  {stud ttable}

  {stud find}
  studfindnum                   : smallint;
  {teacher loads}
  Teaching                      :array of smallint; {count of times taught}
  teload:            array of double;  {time allotment taught}
  ClassInYear: array[0..nmbrYears] of boolean; {class in year of timetable}
  TeDoSub:           tpSubData;  {subject count of teacher on timetable for level or year}
  teshare:           tpSubData;   {share flag for teacher subjects}
  teallot:           array[0..nmbrsubjects] of double;  {allotment of teacher subjects}
  SuMale,SuFemale: array[0..nmbrSubjects,-1..nmbryears-1] of smallint; {student counts}
  {room ttable}

  {sub ttable}

  subttGroupCnt                 : smallint;

  {rooms free dlg}
  
  
  SubSexCountFlg                : boolean=true;
  
  {student input}
  
  

 {subjects offered}
  OfferFile,OfferBlocks         : string;
  OfferGOSname                  : string;
  OfferSections                 : smallint;
  OfferBlockFlag                : wordbool;
  OfferTitle,OfferDesc          : array of string;
  OfferSubMax                   : smallint;
  OfferSubs                     : array of array of smallint;


  {flags for dlgs}
  fEntryDlgUp                   : wordbool=false;
  fwsEntryDlgUp                 : wordbool=false;
  fwsMultDlgUp                  : wordbool=false;
  fRemSubyrDlgUp                : wordbool=false;
  fSearchReplaceDlgUp           : wordbool=false;
  fMoveSubDlgUp                 : wordbool=false;
  {1-summary, 2-details, 3-lines (no gaps), 4-lines(with gaps)}
  blockclashesoldyear           : smallint;
  {sub list win}

  {-2 & -1 ==> sub range, 0 = count for group 1+ is group}

  fgTTtoolbar               : wordbool=false;
  fgBlockToolbar            : wordbool=false;
  fgGenToolbar              : wordbool=false;
  fgWStoolbar               : wordbool=false;


  fgReshowGenToolbar        : wordbool=false;

  {fontWidths}
  fwCode                        : array [0..2] of smallint;
  fwCodeBlank                   : array [0..2] of smallint; {used for ttable}
  fwCodename                    : array [0..2] of smallint;
  fwReportCode,fwReportName     : smallint;
  fwStName                      : smallint;
  fwHouse                       : smallint;
  fwFaculty                     : smallint;
  fwSex                         : smallint;
  fwID                          : smallint;
  fwID2                         : smallint;
  fwEmail                       : smallint;
  fwClass                       : smallint;
  fwTag                         : smallint;
  fwYearname                    : smallint;
  fwPeriodname                  : smallint;
  fwTimeUnit                    : smallint;
  fwClockStartEnd               : smallint;
  fwTsName:  array[0..nmbrdays] of smallint;
  fwTsCode                      : smallint;
  fwDayname                     : smallint;
  fwDay                         : smallint;
  fwTeDutycode                  : smallint;
  fwTemail:     smallint;
  fwTeDutyLoad: smallint;
  {printing}
  PrinterOn,PreviewOn,TextFileOut,CopyOut: boolean;

  myCopyString:     AnsiString;
  PreviewWin:       smallint;
  fwprntCode                    : array [0..2] of smallint;
  fwprntCodeBlank               : array [0..2] of smallint; {used for ttable}
  fwprntCodename                : array [0..2] of smallint;
  fwPrntReportCode              : smallint;
  fwPrntReportName              : smallint;
  fwprntStName                  : smallint;
  fwprntHouse                   : smallint;
  fwprntFaculty                 : smallint;
  fwprntSex                     : smallint;
  fwprntID                      : smallint;
  fwprntID2                     : smallint;
  fwprntEmail                   : smallint;
  fwprntClass                   : smallint;
  fwprntTag                     : smallint;
  fwprntYearname                : smallint;
  fwprntPeriodname              : smallint;
  fwprntClockStartEnd           : smallint;
  fwprntTsName:  array[0..nmbrdays] of smallint;
  fwprntTsCode                  : smallint;
  fwprntDayname                 : smallint;
  fwprntDay                     : smallint;
  fwprntTeDutycode              : smallint;
  fwPrntTeDutyLoad:             smallint;
  prnttxtHeight                 : smallint;
  prntHmargin                   : smallint; {canvas units}
  prntVmargin                   : smallint;

  prntblankwidth                : smallint;
  {General}
  School                        : String[szSchool]; {50 sc$}
  TCvers                        : String[szTCvers]; {20 TCvers$}
  NumCodes                      : array [0..2] of smallint; {nsub(2)} {subject,teacher,room}  //Number of Codes
  lencodes                      : array [0..2] of smallint; {lsub(2)}                         //Data Size for the codes
  NumSubRepCodes,
  LenSubRepCode,LenSubRepName   : smallint;
  LenClassCodes                 : smallint;
  TC4fileHeader                 : String[4];
  FontColorPair:   array[0..nmbrColourPairs,1..2] of tcolor;
  FontColorHiLitePair:   array[0..nmbrColourPairs,1..2] of tcolor;
  {timetable data}
  Lnum                          : smallint;
  TcLabel                       : array [0..nmbrLabels] of String[szTcLabel];

  ttFileHeader                  : string[7]; {first 7 bytes in ttfile} {standard one only}
  ttParameters                  : ^tpTtParameters;
  ttNewFormat                   : wordbool;
  ttUndoPtr                     : integer=0;
  ttUndoMax                     : integer=0;
  levelsUsed                    : integer;

 {worksheet}
  wsMain: array of tpWSblock;
  wsBlocks                      : smallint=10; {number of worksheet blocks}
  wsMainSize                    : word;
  wsmem1                        : smallint;
  WSTclash                      : tpWSFclash;
  WSRclash                      : tpWSFclash;
  WSFclash                      : tpWSFclash;
  wsTclashTot,wsRclashTot       : integer;

  wscalcB,wscalcY,wscalcL: smallint;
  wsb1,wsy1,wsl1                : byte; {top left worksheet}
  wsb,wsy,wsl                   : byte; {current position}
  wsbox                         : byte=bxCell; {b - cell,level etc if >6 then 0}
 {worksheet Multiples}
  wsOne,wsTwo,wsThree,wsOrder   : array of smallint;
  wsXorder                      : array of smallint;
  wsMultNum                     : smallint;
  wsMultChangeFlg               : boolean=false;
  {worksheet targets}
  wstSingle,wstDouble,
  wstTriple : array [-1..nmbrYears+nmbrWSTspecials,0..nmbrDays] of integer;
  {strip rooms and fill rooms}
  rotype: array[0..nmbrTeachers] of smallint;
  rassign: array[0..nmbrTeachers] of smallint;
  {student paste}

 {timetable positions}

  Fsub,Fteach,Froom,Fblock,
  Fshare,Fdouble,Ffix           : smallint;
  Rsub,Rteach,Rroom,Rblock,
  Rshare,Rdouble,Rfix           : smallint;

  chTeGroup,chRoGroup           : array [1..8] of smallint;
  chd,chp,chy,chl               : smallint; {clash help position}
  {Blocks data}
  Cmatrix:      array of array of smallint;

  BlFull                        : boolean=false; {blocks full}
  Fix                           : array [0..nmbrBlocks] of smallint;
  FixCount: smallint; {fix}
  sheet: array [0..nmbrBlocks, 0..nmbrLevels] of smallint;
  blockday: string[20]; 
  blockload: smallint; {blockload} {0-none, 1-file, 2-day, 3-new blocks}
  subsinblock: smallint; {newload}
  Hblock: smallint; {block range -high}
  Lblock: smallint; {block range -low}
  FastShuffleFlg: boolean=false;
  Link: tpSubData;
  Linknum: smallint;
  Exclude:  tpYearData;
  SubStMax: tpSubData;
  SubStMaxPoint: array of smallint;
  Excludenum: smallint;

  toomanysubs: bool;
  sexbalance: smallint;

  {student clash help variables}
  BlClash:        array [0..nmbrSolutions, 0..nmbrBlocks] of smallint;
  BlFlag:         array[0..nmbrBlocks] of integer;
  BlBlock:      array[0..nmbrBlocks] of integer;
  BlWork:         array[0..nmbrBlocks] of integer;
  BlInvert:       array[0..nmbrBlocks] of bool;
  ClashOrder:   array[0..nmbrSolutions] of integer;
  MyBlSolution:     integer;  {number of solutions}
  BlPartial: boolean; {flag for partial solution}
  blnum,blnum1: integer;  {blnum1-number of choices, blnum - choices in blocks}

  {flags for saving}
  SaveBlockFlag: wordbool;
  saveStudFlag: wordbool;
  StudYearFlag:       array[0..nmbryears] of wordbool;

  saveSubsFlag: wordbool;
  SaveTimeFlag: wordbool;
  AlterTimeFlag: wordbool;
  AlterWSflag: boolean;
  {Clash data}
  BlockClashes: array [0..nmbrBlocks] of integer; {zero index for totalcount}
  RollClassPoint: array of smallint;
  StGroup: array of smallint;
  StPointer: array of smallint;
  StudSort: array of smallint;
  StudGrpFlg: array of smallint;
  {Groups of Students - GOS}
  GOSnum:  smallint;
  GOSrecipe: tpGroupMix; {using zero rec for count only}
  GOS: array of tpGroupMix;
  GOSname: array of string;
  GOSmenu: array [0..nmbrCustomGroupMenus] of smallint;
  sortChangeFlag: wordbool;
  NumStud: smallint;
  chmax: smallint;
  boxwidth,prntBoxWidth:              smallint;
  YearStat: array [0..nmbrYears] of record
    numstud: smallint;
    chmax: smallint;
    IDlen: smallint;
    RecordSize: smallint;
    namelen: smallint;
    malenum: smallint;
    femalenum: smallint;
  end;
  { - - - -  DYNAMIC STUDENT DATA - - - - }
  Stud: array of tpStudRec;
  MySelStud: integer; {selected student in top student list window}
  {group data}
  GroupName: string[szTagname];
  GroupType: smallint; {Gtype}
  GroupSort: smallint; {Gsort}
  GroupNum: smallint; {Gnum}
  groupSelStr: array [1..2] of string;
  {year data}
  yearTitle: string[10];
  yearShort: string[10];
  currentYear: smallint;
  Yearname: array [-1..nmbrYears] of String[szYearname]; {10 yearname$(10)}
  GroupSubs: array of smallint; {replaces subyear^}
  GroupSubCount: array of smallint; {replaces student^}
  GsubXref: array of smallint; {replaces subyearcode^}
  BlockTop:  array [0..nmbrSubYear] of smallint;
  SubYearDisp: tpYearData;
  
  {day data}
  DateStr: string[30]; {30 date$}
  day: array [0..nmbrDays] of String[szDay]; {60 Day$  CHANGE TO 5 Day$(10)}
  BaseDay:  array [0..nmbrDays] of String[szDay]=
                ('MON. ','TUE. ','WED. ','THU. ','FRI. ','','','','','','');
  Dayname: array [0..nmbrDays] of String[szDayName]; {10 dayname$(10)}
  PeriodName: array [0..nmbrPeriods] of String[szPeriodName];
   {variable time slots in each day}
  tsCode:          array [0..nmbrDays,0..nmbrPeriods] of string[sztslotcode];
  TimeSlotName: array [0..nmbrDays,0..nmbrPeriods] of String[szPeriodName];
  tsShow: array[0..nmbrDays,0..nmbrPeriods] of smallint;
  dg: array[0..nmbrdays,0..nmbrdays] of smallint; {dg - day group}

  tsAllot:  array[0..nmbrdays,0..nmbrperiods] of double;
  tsStart,tsEnd:  array[0..nmbrdays,0..nmbrperiods] of TDateTime;
  tsType: array[0..nmbrdays,0..nmbrperiods] of integer;
  TslotUnit,SlotUnitDec,SlotUnitMain: smallint;  {kind of unit, decimal and main places}
  DayOfMaxPeriods,tsShowMax: smallint;
  tsShowMaxDay: array[0..nmbrdays] of smallint;
  WeekMaxLoad: smallint;
  BaseAllot                     : array [0..nmbrPeriods] of double;

  numDayGroups: smallint;
  DayGroup:            array[-1..nmbrDays] of smallint;
 {weekly timetables - selected days}
  Xday: array[0..nmbrdays] of integer;
  SelDays:      integer;
  ShowTnames: array[0..nmbrdays] of boolean;
  
  {names of files}
  TextFileName: String;
  timefile: String;
  newtimefile: String; {.ttw sequential file}
  custom: String;
  DisFile: string='';
  Blockfile: String;
  namefile:     string;

  ttAccessPos:  smallint; {ttfile name access position}
  blAccessPos:  smallint; {blockfile name access position}
  ttAccess:     boolean;
  blockAccess:  array[0..nmbryears] of boolean;
  yearAccess:   array[0..nmbryears] of boolean;

  ourSafetyMemStream: TStream;
  ourSafetyMemStreamStr: string;


  {display settings}
  DOSscreenmem: string[20];


  Tlimit: array [0..nmbrDays] of smallint;
  ttcalcD,ttcalcP,ttcalcY,ttcalcL: smallint;

  PweekCount: smallint;
  {Student Display settings}

  {Tag data}
  TagName:   array[0..nmbrTags] of string[szTagname];
  TagCode:   array[0..nmbrTags] of string[2];
  TagsUsed:  array[0..nmbrTags] of boolean;
  TagOrder:  array[0..nmbrTags] of smallint;
  TagOrderNum: smallint;
  TagCalcFlag: boolean=true;
  {roll class data}
  ClassShown:  tpClassShown; {whether to show on tt}
  ClassCode: array of string[szClassName];
  classnum: smallint;
  {house data}
  HouseName:        array[0..nmbrHouse] of String[szHouseName];
  housecount: smallint;
  {subject data}
  SubCode:   array [0..nmbrSubjects] of String[szSubCode];
  Subname:   array [0..nmbrSubjects] of String[szSubnameMax];
  SubReportCode: array [0..nmbrSubjects] of String[szSubCode];
  SubReportName: array [0..nmbrSubjects] of String[szSubnameMax];
  snsize: smallint;
  subNA: smallint; {Not Available code}
  excludeNA: boolean=false;
  {custom data}
  Add:  tpAdd; {80 add$(30)}
  customTab: array [0..nmbrCustom] of smallint; {tab(30)}
  AddNum: smallint;
  gotCustom: boolean;
  {backup data}
  backup_number: smallint;
  backup_action,fillRoom_action: smallint; {1=backup, 2=restore}
  backupPath: array[1..nmbrBackupDisks] of string;
  {teacher/room data}
  tecode: array [0..nmbrteachers, 0..1] of String[szTeCode];
  {0- teachers ;  1-rooms ;  }
  tename: array [0..nmbrteachers, 0..1] of String[szTeName];
  Load:  tpTeData;
  Tfaculty:  array [0..nmbrteachers, 1..nmbrTeFacs] of smallint;
  RoSize:  tpTeData;
  Rfaculty:  array [0..nmbrteachers, 1..3] of smallint;
  DutyLoad: array [0..nmbrteachers, 0..2] of double;
  DutyCode: array [0..nmbrteachers, 0..2] of String[szDutyCode];
  {faculty data}
  facCount: array [0..nmbrFaculty] of smallint; {fa(30)}
  facName: array [0..nmbrFaculty] of string[szFacName]; {fa$(30)}
  facSubs: array [0..nmbrFaculty, 0..nmbrSubsInFaculty] of smallint;
  FacNum: smallint; {fn}
  {transfer data}
  fileout: boolean;
  {sort data}
  code: smallint;
  codepoint:      array[0..nmbrSubjects,0..2] of smallint;
  codeCount: array [0..2] of smallint;
  {debug}
  dbgi,
  dbgj,
  dbgk,
  dbgm: smallint;
  dbgbool: bool;
  dbgdword: dword;
  MainDataDir: string;

type
  tpCustomArr = array [0..nmbrCustom] of string;

var
  CustomArr: tpCustomArr;
  CustomCnt: smallint;


(*  BUG FIXES - Network Version

6.01 release

1. changing data directory - remove check for blocking access after directory
  is changed (unnecessary check)

2. (a) Timedir only being set when open a timetable file
in case open from another directory).  Otherwise timedir is set to datadir.
(b) Still using Timedir when check for mouldy data (to prevent wierd behaviour).
(c) All timetable saves are to datadir
(d) If timedir is different from datadir, then File | Save, brings up Save As
   command - to emphasize that save is now to datadir, not to timedir
   (other folder where file was loaded).
(e) Save As dialogue - set ofNoChangeDir to true, to prevent change to
another directory

3. Fixed crash when calling open custom file from context menu of edit custom

4. Corrected help context number for Room Fill dialogue
  (was giving help page for room strip)

5.  Range check tlimit[i] when loading from .cls file (1-periods)

6.  try.. except.. end added to SetCell

7.  Initialize timetable start, current cell and home position when making
a new timetable (new makeNewTtable procedure).

8.  Version variable changed to ttVersion.

9.  Version label on About box, changed to VersionLabel.

10.  RebuildLabels (Tcommon2) - set su, sub to smallint, loop to LevelPrint instead
of LevelMax.

11.  Add  procedure GetTimeLimits(d) to rofree and tefree.  Call this for
frees by time slot, so when all days are selected, the correct time slot or
time slot range is used.  Was using Tlimit from last day - hence showing wrong
time slots for days with a smaller Tlimit.

12.  Updated hint strings in TCglobals

6.01a release

1.  Fixed bug when saving Rollmarker files when setting New Data folder
 - was saving current data (from old folder) to new folder
2.  Bairnsdale - add query before saving rollmarker files (was in
previous custom version).

6.01b release
Fixed bugs in print preview (a) set default pages to '1' instead of
'999'. (b) add  ppPages.Free;  to Close procedure - fixes memory
leakage.

6.01c release
1.  RoFree unit, procedure GetTimeLimits was using TeFreePeriod
 (from teachers free window) instead of roomsfreeperiod.
2. Wrong tab order reported for Entries dialogue.
All dialogues revised and tab orders corrected. Plus some missing
shortcut keys added.

6.01d release
1. Add clash calculations to worksheet load.  Add
     for i:=1 to wsBlocks do WSFclash[i]:=1; WSclash;
   to end of getWSfile in TCload.

2. Remove space before colon on label1 of FlexiPasteQuiz

3. Add longtimeformat:='h:mmam/pm'; to
 (a) StartEndTime (in Tcommon)
 (b) FormPaint in TimesWnd
 (c) FillGrid in EditTime
This is to prevent seconds being shown in start and end times
(if format is changed by another program).

4. Change Numbers for classes view on Student List to use
 RollClassPoint[] order

6.01e release
1.  added
     Bitmap.PixelFormat:=pf24bit;
    in line just before BitBlt call in PrintPreviewForm
    to fix the error about running out of resources
    
2.  Added procedure DblClick to TCodeWin in ClassDefs - fixed problem
of selected code changing when View dialogue opened by double clicking

3. added
 codeStrNEW:=TrimRight(codeStrNEW);    //CodeAlreadyUsed calls validate  which adds the string padding that we don't want
in line just before the SubCode assignment
to fix the codelength problem where the codes window refreshed with different column widths needlessly

*)


(*

Worksheet

 szWScell size of cell (12 = 6 * smallint)
  2 bytes-subject, 2 bytes-teacher, 2 bytes-room
  2 bytes-flags, 2 bytes-allocation (multiples),
  2 bytes-conditions (not used yet)
 tpWSBlock = array of byte;
 tpWSFclash = array [0..nmbrblocks] of smallint;
 wsMain: array of tpWSblock;  main array of worksheet
 wsBlocks: smallint=10; {number of worksheet blocks}
 wsMainSize:word;  {size of wsMain element}
 wsmem1: smallint;  {each year in wsMain has wsmem1 bytes}


Network Usage

Access Levels for Password file TCWP52.DAT
0-General
1-Timetable
2-Student
3-Blocking
4-Extras
5-Fees
6-Supervisor

Data Locking records in access file    TCWP51.DAT
1: teacher
2: room
3: houses
4: classes
5: tags (was group file)
6: subjects
7-13: not used
14: faculties
15: not used - was times
16: timetable (TTABLE)
17-31: year 0 to year 14
32-34: not used
35: students in years with access - sets required years (17-31)
36: students in group - sets required years (17-31)
37: promote
38: supervisor functions
39: not used (was custom file)
40: blocks - default block
41: blocks + students in group
42: all
43-57: block files based on years
61-: named file (timetable or block)


Locking/Unlocking for timetable and blocks file
(a) default names ttable and blocks
(b) other names stored in TCWP53.DAT with 256 byte record
   0 record - number of records
   each record, 1 byte "T" or "B", 255 bytes for file name.

// from TCE5
  szTslotcode=2;

  {encryption key}
  KeyStrRt='©ª¹°¿NZVT FLFGRZF¶@±¾´·ºß';


Variable Prefixes
  nmbr: number
  bx: box
  sz: string size
  wn: window number
  cp: colour pair
  tp: type
  te: teacher
  ro: room
  PE: past extras
  ET: emergency teacher (added staff)
  Wt: weight
  fw: font width
  fwprnt: font width printer
  ts: time slot
  ab: auto build
  ES: Extras Summary
  sT: student
  tt: timetable




   {variable time slots in each day}
  tsCode:          array [0..nmbrDays,0..nmbrPeriods] of string[sztslotcode];
  tsName: array [0..nmbrDays,0..nmbrPeriods] of String[szPeriodName];
  tsOn: array  [0..nmbrDays,0..nmbrPeriods] of boolean;
  tsShow: array[0..nmbrDays,0..nmbrPeriods] of smallint;
  dg: array[0..nmbrdays,0..nmbrdays] of smallint; {dg - day group}

  tsAllot:  array[0..nmbrdays,0..nmbrperiods] of double;
  tsStart,tsEnd:  array[0..nmbrdays,0..nmbrperiods] of TDateTime;




{student data}



  GOSrecipe:    tpGroupMix;  {using zero rec for count only}
  GOS:      array of tpGroupMix;
  GOSname:      array of string[250];
  GOSmenu:      array [0..nmbrCustomGroupMenus] of smallint;


  GsubXref : array of smallint;  {replaces subyearcode^}



  {teacher/room data}
  Temail,ETmail:       array of string;
  EmailHost,EmailUserID,EmailPassword:  string;
  EmailSend,EmailDisplayName: string;
  EmailCoverFlag,EmailAbsentFlag,EmailAddedFlag:  wordbool;
  {Cover dialogue arrays}


  {debug}
 CustomCnt:                smallint;   *)

(*
 *****************  DATA DEFINITIONS  ********************


Files from Time Chart

Timetable - .TTW sequential file format from windows version
Subjects - SUBCODE.DAT and SUBNAME.DAT
Teachers - TECODE.DAT, TENAME.DAT, TELOAD.DAT
Rooms - ROOMS.DAT, ROOMNAME.DAT, ROLOAD.DAT
Faculties - FACULTY.DAT
roll class codes - CLASS.DAT (does not read CLASSn.DAT files)
Houses - HOUSE.DAT
Time Chart time allotments - ALLOT.DAT
Group definitions - GROUP.DAT
Students - CHOICE1.ST, CHOICE2.ST, ...


EmailSetup.DAT - encrypted text file.
 5 lines, lines for email host, user ID, password, sender's email, sender's name

TEMAIL.DAT - text file.
 First line has number of email addresses.  Followed by email addresses (one per line),
 matching tecodes order.


EXALLOT.DAT
 bytes 0-3: header string 'TCE5'
 tmpY (2 byte integer): years-1
 tmpD (2 byte integer): days-1
 tmpP (2 byte integer): periods
 for i:=0 to tmpD read DayGroup[i] (2 byte integer): daygroup number for each day
 for i:=0 to tmpY read YearGroup[i] (2 byte integer): yeargroup number for each year
 for j:=0 to tmpD do
       for k:=1 to tmpP do
            read torder[k,j] (2 byte integer): time slot order for period and day
            read tslotcode[k,j] (1 byte string): time slot code for period and day

 for i:=0 to tmpY do
       for j:=0 to tmpD do
           for k:=1 to tmpP do
              read Eallot[i,j,k] (8 byte real number for time allotment


 {subjects offered}
  OfferFile,OfferBlocks         : string; name of offer file, name of block file
  OfferGOSname                  : string; name of student group
  OfferSections                 : smallint; number of sections
  OfferBlockFlag                : wordbool; true if block file used
  OfferTitle,OfferDesc          : array of string; title and description for each section
  OfferSubMax                   : smallint; max number of subjects in any section
  OfferSubs                     : array of array of smallint;
//  OfferSubs[section,0]:=count; OfferSubs[section,j]=subject in section
*)


function compareValues(a,b: integer):string; overload;
function compareValues(a,b: string):string; overload;
function compareValues(a,b: double):string;   overload;
procedure IntRange(var i: smallint; j,k: smallint);
procedure daygroupCount;
function Space(StringLength: smallint):string;
function StringPad(charcount:smallint; charval:smallint):string;
function StringPadChr(charcount:smallint; charchr:string):string;
function RpadString(S:string; L: smallint):string;
function LpadString(S:string; L: smallint):string;

implementation

{ TFileNames }


function compareValues(a,b: integer):string;   overload;
begin
  Result := '';
  if a <> b then
    Result:= IntToStr(a)+ ' <> ' + IntToStr(b);
end;

function compareValues(a,b: string):string; overload;
begin
  Result := '';
  if a <> b then
    Result:= '"'+a+ '" <> "' + b + '"';
end;

procedure IntRange(var i: smallint; j,k: smallint);
begin
 if i<j then i:=j
  else if i>k then i:=k;
end;

procedure daygroupCount;
var
 gs: array[0..nmbrdays] of smallint;
 i:     smallint;
begin
 numDayGroups:=0;
for i:=1 to days do gs[i]:=0;
 for i:=1 to days do inc(gs[DayGroup[i-1]]);
 for i:=1 to days do if gs[i]>0 then inc(numDayGroups);
end;

function Space(StringLength: smallint):string;
begin
 result:=StringPad(Stringlength,32);
end;

function StringPad(charcount:smallint; charval:smallint):string;
var
 i:     smallint;
 tmpStr:        string;
begin
 tmpStr:=''; result:=tmpStr;
 if charcount<=0 then exit;  {return blank string}
 for i:=1 to charcount do
  tmpStr:=tmpStr+chr(charval);
 result:=tmpStr;
end;

function StringPadChr(charcount:smallint; charchr:string):string;
var
 charval:  smallint;
begin
 charval:=Ord(charchr[1]);
 result:=StringPad(charcount,charval);
end;


function RpadString(S:string; L: smallint):string;
begin
 RpadString:=S+space(L-length(S));
end;

function LpadString(S:string; L: smallint):string;
begin
 LpadString:=space(L-length(S))+S;
end;


function compareValues(a,b: double):string;   overload;
begin
  Result := '';
  if a <> b then
    Result:= FloatToStr(a)+ ' <> ' + FloatToStr(b);
end;




{ TDirectories }


end.



