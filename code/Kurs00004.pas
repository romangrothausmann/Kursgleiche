unit Kurs0004;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Menus;

type
  TBild = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Panel2: TPanel;
    Panel3: TPanel;
    Image2: TImage;
    procedure Panel2Click(Sender: TObject);
    procedure Panel3Click(Sender: TObject);
    procedure Panel2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    {procedure Panel2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);}
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Bild: TBild;

implementation

{$R *.DFM}



procedure TBild.Panel2Click(Sender: TObject);
begin
Image1.Visible:= False;
Image2.Visible:= True;
end;

procedure TBild.Panel3Click(Sender: TObject);
begin
Image2.Visible:= False;
Image1.Visible:= True;
end;

procedure TBild.Panel2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
Panel2.BevelOuter:= bvRaised;
end;

procedure TBild.Panel2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
Panel2.BevelOuter:= bvNone;
end;

procedure TBild.Panel3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
Panel3.BevelOuter:= bvNone;
end;

procedure TBild.Panel3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
Panel3.BevelOuter:= bvRaised;
end;

procedure TBild.FormCreate(Sender: TObject);
begin
If FileExists('Kursdreieck1.bmp')
   Then Image1.Picture.LoadFromFile('Kursdreieck1.bmp');
If FileExists('Kursdreieck2.bmp')
   Then Image2.Picture.LoadFromFile('Kursdreieck2.bmp');
end;

end.
