unit uAMGImage;

interface

uses
  uAMGItem;

type
  TAMGImage = class(TAMGItem)
  private
    FImageName: string;
  public
    function Refresh: Boolean; override;
    function RefreshFromFile: Boolean;
    property ImageName: string read FImageName write FImageName;
  end;

  TAMGImages = class(TAMGItemList)
  private
    FImagePath: string;
  public
    function Refresh: Boolean; override;
    property ImagePath: string read FImagePath write FImagePath;
  end;


implementation

{ TAMGImage }

function TAMGImage.Refresh: Boolean;
begin
  inherited Refresh;
end;

function TAMGImage.RefreshFromFile: Boolean;
begin
  Result := False;
end;

{ TAMGImages }

function TAMGImages.Refresh: Boolean;
begin
  inherited Refresh;
end;

end.
