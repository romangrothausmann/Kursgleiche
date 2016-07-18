unit KursDDE00006;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
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

uses KursDDE00005;


{$R *.lfm}

procedure TZoominfo.FormHide(Sender: TObject);
begin
Windrose.Chart1.Refresh;
end;

end.
