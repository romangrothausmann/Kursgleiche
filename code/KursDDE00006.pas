unit Kurs00006;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TZoominfo = class(TForm)
    Memo1: TMemo;
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Zoominfo: TZoominfo;

implementation

uses Kurs00005;


{$R *.DFM}

procedure TZoominfo.FormHide(Sender: TObject);
begin
Windrose.Chart1.Refresh;
end;

end.
