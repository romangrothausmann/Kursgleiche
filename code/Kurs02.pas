unit Kurs02;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, Menus, StdCtrls, Math, ExtCtrls;

Const Markierung = 252;
      Winkel = 1;
      cMaxWerte = 500;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Datei: TMenuItem;
    ffnen1: TMenuItem;
    Speichern1: TMenuItem;
    Tabelle: TStringGrid;
    Bearbeiten1: TMenuItem;
    Kurs1: TMenuItem;
    Kurswinkelberechnen1: TMenuItem;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    offnen: TOpenDialog;
    SaveDialog1: TSaveDialog;
    N1: TMenuItem;
    Drucken1: TMenuItem;
    N2: TMenuItem;
    Beenden1: TMenuItem;
    ListBox1: TListBox;
    Panel1: TPanel;
    Image2: TImage;
    StaticText1: TStaticText;
    Windroseerstellen1: TMenuItem;
    Sortieren1: TMenuItem;
    Info1: TMenuItem;
    Eingabeinfo1: TMenuItem;
    procedure Zeilehinzufgen1Click(Sender: TObject);
    procedure Spaltehinzufgen1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Kurswinkelberechnen1Click(Sender: TObject);
    procedure ffnen1Click(Sender: TObject);
    procedure Beenden1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Speichern1Click(Sender: TObject);
    procedure Drucken1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Windroseerstellen1Click(Sender: TObject);
    procedure TabelleSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure TabelleMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Sortieren1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Eingabeinfo1Click(Sender: TObject);
    procedure TabelleDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    Dateiname: String;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Kurs2, Kurs3, Kurs4, Kurs5, Kurs8, Kurs9, Kurs6;


{$R *.DFM}

Function Umrechnen (Var c: String): Real;
Var v, w, x, y, z, Grad, Minuten, Sekunde, Code: Integer;
    G, M, S: String;
    Breit: Real;
Begin
Grad:= 0;
Minuten:= 0;
Sekunde:= 0;
x:= Pos ('°', c);
y:= Pos ('''', c);
z:= Pos ('"', c);
w:= Pos ('W', c);
v:= Pos ('S', c);
IF x <> 0
Then
Begin
G:= Copy (c, 1, x - 1);
Val (G, Grad, Code);
End;
IF y <> 0
Then
Begin
M:= Copy (c, x + 1, y - 1 - x);
Val (M, Minuten, Code);
End;
IF z <> 0
Then
Begin
S:= Copy (c, y + 1, z - y - 1);
Val (S, Sekunde, Code);
End;
Breit:= Grad + Minuten / 60 + Sekunde / 3600;
If (w <> 0) or (v <> 0)
   Then Breit:= -Breit;
Result:= Breit;
End;

Function BerechneLm (Var UL, L: real): real;
Begin
Result:= Abs (L - UL);
End;

Function BerechneE (Var h, n, Lm: Real): Real;
Begin
Result:= (ArcCos ( cos (h / 180 * pi)
                * cos (n / 180 * pi)
                + sin (h / 180 * pi)
                * sin (n / 180 * pi)
                * cos (Lm / 180 * pi)))
                * 180 / pi;
End;

Function BerechneA (Var e, n, Lm, h: Real): Real;
Var a, m: Real;
Begin
If e <> 0
   Then a:= {(Arccos (cos (n / 180 * pi)
            / ((cos (h / 180 * pi)
            * cos (e / 180 * pi))
            + (sin (h / 180 * pi)
            * sin (e / 180 * pi)))))
            * 180 / pi}
           (Arcsin (sin (Lm / 180 * pi)
           / sin (e / 180 * pi)
           * sin (n / 180 * pi)))
           * 180 / pi
   Else a:= 360;
m:= (ArcCos (cos ( h / 180 * pi)
           * cos ( e / 180 * pi)
           + sin ( h / 180 * pi)
           * sin ( e / 180 * pi)
           * cos ( a / 180 * pi)))
           * 180 / pi;
m:= Round ((m - n) * 10000000000);
If  m <> 0
   Then Result:= 180 - a
   Else Result:= a;
End;

Function BerechneG (Var Lm, a, h, Ul, le: Real): Real;
Var z, y: Real;
Begin
z:= Le - Ul;
y:= 180 - (ArcCos ( (- cos ((Lm / 2) / 180 * pi))
                 * cos (a / 180 * pi)
                 + sin ((Lm / 2) / 180 * pi)
                 * sin ( a / 180 * pi)
                 * cos ( h / 180 * pi)))
                 * 180 / pi;
If z < 0
   Then Result:= 360 - y
   Else Result:= y;
End;

Function Leerzeichen (Var L: Integer; s: String): String;
Var i, z: Integer;
    r: String;
Begin
r:= '';
z:= L - Length (s);
For i:= 1 to z do
r:= r + ' ';
Result:= r;
End;


Procedure Speichern;
Var i: Integer;
Begin
IF Form1.SaveDialog1.execute
   Then
   Begin
   Form1.ListBox1.Items.Clear;
   For i:= 1 to Form1.Tabelle.ColCount - 1 Do
       Begin
       Form1.ListBox1.Items.AddStrings (Form1.Tabelle.cols[i]);
       Form1.ListBox1.Items.Add ('§$%&');
       End;
   If not Fileexists (Form1.SaveDialog1.FileName)
      then Form1.ListBox1.Items.SaveToFile (Form1.SaveDialog1.FileName + '.krs')
      Else If MessageDlg('Die Datei existiert bereits! Datei überschreiben?',
              mtConfirmation, [mbYes, mbNo], 0) = mrYes
              then Form1.ListBox1.Items.SaveToFile (Form1.SaveDialog1.FileName + '.krs');
   End;
End;

procedure TForm1.Zeilehinzufgen1Click(Sender: TObject);
begin
Tabelle.RowCount:= Tabelle.RowCount + 1;
Tabelle.Cells [0,Tabelle.RowCount]:= IntToStr (Tabelle.RowCount);
end;

procedure TForm1.Spaltehinzufgen1Click(Sender: TObject);
begin
Tabelle.colCount:= Tabelle.colCount + 1;
end;

procedure TForm1.FormCreate(Sender: TObject);
Var i: Integer;
begin
Tabelle.Font.Name:= 'MS Sans Serif'; // geht nur so!?!
With Tabelle do
Begin
Cells [1,0]:= 'Ort';
Cells [2,0]:= 'geo. Breite';
Cells [3,0]:= 'geo. Länge';
Cells [4,0]:= 'Land';
Cells [5,0]:= 'Besonderheit';
For i:= 1 to RowCount do
Cells [0,i]:= IntToStr (i);
End;
end;

procedure TForm1.Kurswinkelberechnen1Click(Sender: TObject);
Var i: Integer;
    B: String;
    UrBreite, UrLaenge, Breite, Laenge,
    e, e2, Lm, h, n, a, g: Real;
begin
B:= Edit1.Text;
UrBreite:= Umrechnen (B);
B:= Edit2.Text;
UrLaenge:= Umrechnen (B);
With Tabelle Do
Begin
ColCount:= 14;
Cells [6,0]:= 'Lat. [°]';
Cells [7,0]:= 'Lon. [°]';
Cells [8,0]:= 'DLon. l [°]';
Cells [9,0]:= 'Dist. e [°]';
Cells [10,0]:= 'Dist. e [km]';
Cells [11,0]:= 'Alpha a [°]';
Cells [12,0]:= 'Kurs g [°]';
Cells [13,0]:= Chr(Markierung);
ColWidths[13]:= 15;
For i:= 1 to Rowcount - 1 Do
Begin
B:= Cells [2,i];
Breite:= Umrechnen (B);
Str (Breite:5:4, B);
Cells [6,i]:= B;
B:= Cells [3,i];
Laenge:= Umrechnen (B);
Str (Laenge:5:4, B);
Cells [7,i]:= B;
h:= 90 - UrBreite;
n:= 90 - Breite;
Lm:= BerechneLm (UrLaenge, Laenge);
Str (Lm:5:4, B);
Cells [8,i]:= B;
e:= BerechneE (h, n, Lm);
Str (e:5:4, B);
Cells [9,i]:= B;
e2:= ((BerechneE (h, n, Lm)) * 40075)/360;
Str (e2:5:3, B);
Cells [10,i]:= B;
a:= berechneA (e, n, Lm, h);
Str (a:5:4, B);
Cells [11,i]:= B;
g:= berechneG (Lm, a, h, Urlaenge, laenge);
Str (g:5:4, B);
Cells [12,i]:= B;
Cells [13,i]:= Chr(Markierung);

End;
End;
end;

{Procedure Lesen(s: String; z: Integer);
Var i: Integer;
Begin
While s <> '§$%&' Do
   begin
   i:= i + 1;
   ReadLn (tf, s);
   IF s <> '§$%&'
      Then Form1.Tabelle.cells[z,i]:= s;
   End;
i:= 0;
Readln (tf);
End;  }

procedure TForm1.ffnen1Click(Sender: TObject);
Var tf: Textfile;
    i: Integer;
    Ort, Breite, Laenge, Land, Besonderheit: String;
begin
If offnen.execute
   Then
   Begin
   Assignfile (tf, offnen.FileName);
   Reset (tf);
   Dateiname:= offnen.FileName;
   i:= 0;
   Ort:= '';
   Breite:= '';
   Laenge:= '';
   Land:= '';
   Besonderheit:= '';
   Readln (tf);
   While  Ort <> '§$%&' Do
   begin
   i:= i + 1;
   ReadLn (tf, Ort);
   IF Ort <> '§$%&'
      Then
      Begin
      Tabelle.RowCount:= i + 1;
      Tabelle.cells [0,i]:= IntToStr (i);
      Tabelle.cells[1,i]:= Ort;
      End;
   End;
   i:= 0;
   Readln (tf);
   While Breite <> '§$%&' Do
   begin
   i:= i + 1;
   ReadLn (tf, Breite);
   IF Breite <> '§$%&'
      Then Tabelle.cells[2,i]:= Breite;
   End;
   i:= 0;
   Readln (tf);
   While Laenge <> '§$%&' Do
   begin
   i:= i + 1;
   ReadLn (tf, Laenge);
   IF Laenge <> '§$%&'
      Then Tabelle.cells[3,i]:= Laenge;
   End;
   i:= 0;
   Readln (tf);
   While Land <> '§$%&' Do
   begin
   i:= i + 1;
   ReadLn (tf, Land);
   IF Land <> '§$%&'
      Then Tabelle.cells[4,i]:= Land;
   End;
   i:= 0;
   Readln (tf);
   While Besonderheit <> '§$%&' Do
   begin
   i:= i + 1;
   ReadLn (tf, Besonderheit);
   IF Besonderheit <> '§$%&'
      Then Tabelle.cells[5,i]:= Besonderheit;
   End;
   Closefile (tf);
   End;
end;

procedure TForm1.Beenden1Click(Sender: TObject);
begin
Close;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
IF Dateiname <> ''
   Then  
   Begin
   Form2.Label1.Caption:= 'Wollen Sie die Änderung in '
   + extractfilename (offnen.FileName) + ' speichern?';
   IF form2.showmodal = mrYes
      Then Speichern
      Else IF form2.Modalresult = MrCancel
           Then CanClose:= False;
   End;
end;

procedure TForm1.Speichern1Click(Sender: TObject);
begin
Speichern;
end;

procedure TForm1.Drucken1Click(Sender: TObject);
Const L = '                              ';
      f = 10;
      k = 15;
      d = 25;
      c = 30;
Var i, j: Integer;
    Line, Zahl: String;
    Breite, Laenge: String[k];
    B, Le, e, e2, Lm, a, g: String[f];
    Besonderheit: String[c];
    Ort, Land: String[d];
begin
For j:= 0 to Tabelle.RowCount - 1 do
Begin
Line:= '';
    {For i:= 0 to Tabelle.ColCount - 1 do
    begin}
Zahl:= Format ('%4s ',[Form1.Tabelle.Cells [0,j]]);
Ort:= Form1.Tabelle.Cells [1,j] + L;
i:= k;
Breite:= Form1.Tabelle.Cells [2,j];
Breite:= Leerzeichen (i, Breite) + Breite;
Laenge:= Form1.Tabelle.Cells [3,j];
Laenge:= Leerzeichen (i, Laenge) + Laenge;
Land:= '  ' + Form1.Tabelle.Cells [4,j] + L;
Besonderheit:=Form1.Tabelle.Cells [5,j] + L;
i:= f;
B:= Form1.Tabelle.Cells [6,j];
b:= Leerzeichen (i, b) + b;
Le:= Form1.Tabelle.Cells [7,j];
le:= Leerzeichen (i, le) + le;
e:= Form1.Tabelle.Cells [8,j];
e:= Leerzeichen (i, e) + e;
e2:= Form1.Tabelle.Cells [8,j];
e2:= Leerzeichen (i, e2) + e;
Lm:= Form1.Tabelle.Cells [9,j];
lm:= Leerzeichen (i, lm) + lm;
a:= Form1.Tabelle.Cells [10,j];
a:= Leerzeichen (i, a) + a;
g:= Form1.Tabelle.Cells [11,j];
g:= Leerzeichen (i, g) + g;
Line:= Zahl + Ort + Breite + Laenge + Land
       +B+Le+e+e2+Lm+a+g;
Form3.Druckvorschau.Lines.Add (Line);
End;
Form3.Show;
end;

procedure TForm1.Image2Click(Sender: TObject);
begin
Bild.show;
end;

procedure TForm1.Windroseerstellen1Click(Sender: TObject);
begin
Windrose.Show;
end;

Procedure Sortiere(Spalte: Integer);   //?
Begin
Form1.ListBox1.Items:= Form1.Tabelle.Cols[Spalte];
End;

procedure TForm1.TabelleSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
IF ACol=13
   Then
   If Tabelle.Cells[13,ARow]=Chr(Markierung)
      Then Tabelle.Cells[13,ARow]:= ''
      Else Tabelle.Cells[13,ARow]:=Chr(Markierung);
CanSelect := (ACol<>13);
end;

procedure TForm1.TabelleMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var Col, Row: Integer;
begin
Tabelle.MouseToCell(x,y,col,Row);
If (col=12) and (Row=0)
   Then Sortiere(col);
end;

procedure TForm1.Sortieren1Click(Sender: TObject);
Var Gradfeld: Array [1..cMaxWerte] of Real;
    i, j, k, Code: Integer;
begin
For k:= 1 to Tabelle.RowCount do
    Val(Tabelle.Cells[12,k],Gradfeld[k],Code);
For i:= 1 To Tabelle.RowCount do
    If Tabelle.Cells[13,i] = Chr(Markierung)
       Then For j:= 1 to Tabelle.RowCount do
                If (Gradfeld[i]<Gradfeld[j]) and (Gradfeld[j]<Gradfeld[i]+Winkel)
                   Then Tabelle.Cells[13,j]:='';
end;

procedure TForm1.FormShow(Sender: TObject);
begin
Film.ShowModal;
end;

procedure TForm1.Eingabeinfo1Click(Sender: TObject);
begin
Programminfo.ShowModal;
end;

procedure TForm1.TabelleDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
If Acol = 13
   Then If Tabelle.Cells[13,ARow]=Chr(Markierung)
        Then
        Begin
        With Tabelle.Canvas do
            Begin
            FillRect(Rect);
            Font.Name:= 'Wingdings';
            Font.Size := 10;
            TextOut(Rect.Left + 2, Rect.Top + 2, 'ü');
            Font.Name:= 'MS Sans Serif';
            Font.Size := 8;
            End;
        End
        Else Tabelle.Canvas.FillRect(Rect);

end;

end.

