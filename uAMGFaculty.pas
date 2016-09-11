unit uAMGFaculty;

interface

uses
  uAMGItem;

type
  TAMGFaculty = class(TAMGItem)
  private
    FSubjectName: string;
    FSubjectDescription: string;
    FYearID: Integer;
    FHOD: string;
    FFacultyTypeID: Integer;
  public
    function Refresh: Boolean; override;
    property FacultyName: string read FSubjectName write FSubjectName;
    property FacultyDescription: string read FSubjectDescription write FSubjectDescription;
    property HOD: string read FHOD write FHOD;
    property FacultyTypeID: Integer read FFacultyTypeID write FFacultyTypeID;
  end;

  TAMGFaculties = class(TAMGItemList)
  public
    function Refresh: Boolean; override;
    function RefreshFromFile: Boolean; override;
    function SaveToFile: Boolean;
  end;

  TAMGFacultySubject = class(TAMGItem)
  private
    FSubjectID: Integer;
    FFacultyID: Integer;
  public
    function Refresh: Boolean; override;
    property FacultyID: Integer read FFacultyID write FFacultyID;
    property SubjectID: Integer read FSubjectID write FSubjectID;
  end;

  TAMGFacultySubjects = class(TAMGItemList)
  public
    function Refresh: Boolean; override;
    function RefreshFromFile: Boolean; override;
    function SaveToFile: Boolean;
  end;


implementation

{ TAMGFaculty }

function TAMGFaculty.Refresh: Boolean;
begin
  inherited Refresh;
end;

{ TAMGFaculties }

function TAMGFaculties.Refresh: Boolean;
begin
  inherited Refresh;
end;

function TAMGFaculties.RefreshFromFile: Boolean;
begin
  inherited RefreshFromFile;
end;

function TAMGFaculties.SaveToFile: Boolean;
begin
  Result := False;
end;

{ TAMGFacultySubject }

function TAMGFacultySubject.Refresh: Boolean;
begin
  inherited Refresh;
end;

{ TAMGFacultySubjects }

function TAMGFacultySubjects.Refresh: Boolean;
begin
  inherited Refresh;
end;

function TAMGFacultySubjects.RefreshFromFile: Boolean;
begin
  inherited RefreshFromFile;
end;

function TAMGFacultySubjects.SaveToFile: Boolean;
begin
  Result := False;
end;

end.
