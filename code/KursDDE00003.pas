unit KursDDE00003;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls;

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

{$R *.lfm}

procedure TFilm.FormShow(Sender: TObject);
begin
If Fileexists('Kursgleiche.avi')
   Then Animate1.Play (1, Animate1.FrameCount, 1)
   Else Begin
        ShowMessage('Filmdatei Kursgleiche.avi fehlt!');
        Animate1.CommonAVI:= aviNone;
        Animate1.Width:= 10;
        Animate1.ParentColor:= True;
        End;
Timer1.Enabled:= True;
end;

procedure TFilm.Timer1Timer(Sender: TObject);
begin
Timer1.Enabled:= False;
ModalResult:= mrOK;
end;

procedure TFilm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
If (Key = 87)  And (ssAlt in Shift)  // 87 ist Taste 'w'
   Then
   Begin
   Timer1.Enabled:= False;
   ModalResult:= mrOK;
   End;
end;

end.
