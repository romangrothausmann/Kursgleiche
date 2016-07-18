unit KursDDE00011;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TDruck = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    box: TListBox;
    Bevel1: TBevel;
    Label2: TLabel;
    Button2: TButton;
    CheckBox1: TRadioButton;
    CheckBox2: TRadioButton;
    procedure FormShow(Sender: TObject);
    procedure boxClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Druck: TDruck;
  BlattAnz: Integer;

implementation

uses KursDDE00002, KursDDE00001;

{$R *.lfm}


procedure TDruck.FormShow(Sender: TObject);
Var i: Integer;
begin
Label1.Caption:= 'Gesamtanzahl der druckbaren Blätter: '
                 + IntToStr(Druckvorschau.DBlattAnz) ;
Box.Items.Clear;
Label2.Caption:= '';
For i:= 1 to Druckvorschau.DBlattAnz do
    Box.Items.Add(IntToStr(i));
end;

procedure TDruck.boxClick(Sender: TObject);
Var s, t: String;
    j, k: Integer;
begin
k:= 0;
j:= 0;
Repeat
Inc(k);
If Kursberechnung.Tabelle.Cells[13, k] = Auswahl
   then Inc(j);
Until (j >= Druckvorschau.Grenzen(True, Box.ItemIndex + 1))
      or (k >= Kursberechnung.Tabelle.RowCount - 1);
s:= Kursberechnung.Tabelle.Cells[0, k];
k:= 0;
j:= 0;
Repeat
Inc(k);
If Kursberechnung.Tabelle.Cells[13, k] = Auswahl
   then Inc(j);
Until (j >= Druckvorschau.Grenzen(False, Box.ItemIndex + 1))
      or (k >= Kursberechnung.Tabelle.RowCount - 1);
t:= Kursberechnung.Tabelle.Cells[0, k];
{If s = ''
   then s:= Kursberechnung.Tabelle.Cells[0, Kursberechnung.Tabelle.RowCount - 1];
If Druckvorschau.Grenzen(True, Box.ItemIndex + 1) = 1
   Then t:= Kursberechnung.Tabelle.Cells[0, 1]
   Else t:= Kursberechnung.Tabelle.Cells[0, Druckvorschau.Grenzen(True, Box.ItemIndex + 1) + 1];}
Label2.Caption:= 'Blatt ' + Box.Items[Box.ItemIndex] + ' reicht'
                 + #13'von Eintrag Nummer: '
                 + s
                 + #13'bis Eintrag Nummer: '
                 + t;
end;

procedure TDruck.CheckBox1Click(Sender: TObject);
begin
Box.Enabled:= False;
end;

procedure TDruck.CheckBox2Click(Sender: TObject);
begin
Box.Enabled:= True;
end;

end.
