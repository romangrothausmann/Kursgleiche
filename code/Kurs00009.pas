unit Kurs0009;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBCtrls, DB;

type
  TSucheform = class(TForm)
    Label1: TLabel;
    Edit2: TEdit;
    Label2: TLabel;
    Spaltenbox: TComboBox;
    Button1: TButton;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Sucheform: TSucheform;

implementation

uses Kurs0001;

{$R *.DFM}

procedure TSucheform.Button1Click(Sender: TObject);
Var Spalte: String;
begin
Case Spaltenbox.ItemIndex of
     0: Spalte:= 'Ort';
     1: Spalte:= 'Breite';
     2: Spalte:= 'Laenge';
     3: Spalte:= 'Land';
     4: Spalte:= 'Besond';
     End;
If Kursberechnung.Orte.Locate(Spalte, Edit2.Text,
   [loCaseInsensitive, loPartialKey])
   Then Label3.Caption:= 'Eintrag '+Kursberechnung.Orte[Spalte]+' gefunden!'
   Else Label3.Caption:= 'Eintrag nicht gefunden!';
end;

procedure TSucheform.FormShow(Sender: TObject);
begin
Spaltenbox.ItemIndex:= 0;
Label3.Caption:='';
end;

end.
