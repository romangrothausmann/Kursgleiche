unit Kurs00009;

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

uses Kurs00001;


{$R *.DFM}

procedure TSucheform.Button1Click(Sender: TObject);
begin
Kursberechnung.AktuOrt:= Kursberechnung.Finde(Sucheform.Spaltenbox.ItemIndex, Edit2.Text);
If Kursberechnung.AktuOrt.Name <> ''
   Then Label3.Caption:= 'Eintrag '+Kursberechnung.Tabelle.cells[Kursberechnung.AktuOrt.Spalte,Kursberechnung.AktuOrt.Zeile]+' gefunden!'
   Else Label3.Caption:= 'Keinen passenden Eintrag gefunden!'
end;

procedure TSucheform.FormShow(Sender: TObject);
begin
Spaltenbox.ItemIndex:= 1;
Label3.Caption:='';
end;

end.
