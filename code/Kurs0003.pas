unit Kurs8;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls;

type
  TFilm = class(TForm)
    Panel1: TPanel;
    Animate1: TAnimate;
    Timer1: TTimer;
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Film: TFilm;

implementation

{$R *.DFM}

procedure TFilm.FormShow(Sender: TObject);
begin
Animate1.Play (1, Animate1.FrameCount, 1);
Timer1.Enabled:= True;
end;

procedure TFilm.Timer1Timer(Sender: TObject);
begin
ModalResult:= mrOK;
Timer1.Enabled:= False;
end;

procedure TFilm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
If (Key = 87)  And (ssAlt in Shift)  // 87 ist Taste 'w'
   Then
   Begin
   ModalResult:= mrOK;
   Timer1.Enabled:= False;
   End;
end;

end.
