unit KursDDE00004;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Menus;

type
  TBilder = class(TForm)
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Bilder: TBilder;

implementation

{$R *.DFM}



procedure TBilder.Panel2Click(Sender: TObject);
begin
Image1.Visible:= False;
Image2.Visible:= True;
end;

procedure TBilder.Panel3Click(Sender: TObject);
begin
Image2.Visible:= False;
Image1.Visible:= True;
end;

procedure TBilder.Panel2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
Panel2.BevelOuter:= bvRaised;
end;

procedure TBilder.Panel2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
Panel2.BevelOuter:= bvNone;
end;

procedure TBilder.Panel3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
Panel3.BevelOuter:= bvNone;
end;

procedure TBilder.Panel3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
Panel3.BevelOuter:= bvRaised;
end;

procedure TBilder.FormCreate(Sender: TObject);
begin
If FileExists('Kursdreieck1.bmp')
   Then Image1.Picture.LoadFromFile('Kursdreieck1.bmp')
   Else ShowMessage('Bilddatei Kursdreieck1.bmp fehlt!');
If FileExists('Kursdreieck2.bmp')
   Then Image2.Picture.LoadFromFile('Kursdreieck2.bmp')
   Else ShowMessage('Bilddatei Kursdreieck2.bmp fehlt!');
end;

end.
