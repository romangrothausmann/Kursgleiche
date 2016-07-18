unit KursDDE00001;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  sqldb, Math, Db, Menus, Grids, DBGrids, StdCtrls, ExtCtrls;

Const //cMaxWerte = 500;
      Winkel = 1;
      Indexdatei = 'KursindexDBF.mdx';
      //Haken = 'ü';
      MeinOrt = 'Bochum-Dahlhausen';
      Auswahl = 'ü';
      SpaltenTitel0 = '#';
      SpaltenTitel1 = 'Ort';
      SpaltenTitel2 = 'geogr. Breite';
      SpaltenTitel3 = 'geogr. Länge';
      SpaltenTitel4 = 'Land';
      SpaltenTitel5 = 'Besonderheit';
      SpaltenTitel6 = 'Lat. [°]';
      SpaltenTitel7 = 'Lon. [°]';
      SpaltenTitel8 = 'DLon. l [°]';
      SpaltenTitel9 = 'Dist. e [°]';
      SpaltenTitel10= 'Dist. e [km]';
      SpaltenTitel11= 'Alpha a [°]';
      SpaltenTitel12= 'Kurs g [°]';
      SpaltenBreite0 = 30;
      SpaltenBreite1 = 165;
      SpaltenBreite2 = 90;
      SpaltenBreite4 = 165;
      SpaltenBreite5 = 165;
      SpaltenBreite6 = 80;
      SpaltenBreite13= 25;

type
  TSort = Record Col: Integer;
                 Auf: Boolean;
                 End;
  TAktuOrt = Record Spalte, Zeile: Integer;
                    Name: String;
                    End;
  TSpeicher = Array of Array [0..13] of String ;

  { TKursberechnung }

  TKursberechnung = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    StaticText1: TStaticText;
    MainMenu1: TMainMenu;
    Datei: TMenuItem;
    ffnen1: TMenuItem;
    Speichern1: TMenuItem;
    N1: TMenuItem;
    Drucken1: TMenuItem;
    N2: TMenuItem;
    Beenden1: TMenuItem;
    Bearbeiten1: TMenuItem;
    Filtern: TMenuItem;
    Kurs1: TMenuItem;
    Kurswinkelberechnen1: TMenuItem;
    Windroseerstellen1: TMenuItem;
    Info1: TMenuItem;
    Eingabeinfo1: TMenuItem;
    offnen: TOpenDialog;
    speichern: TSaveDialog;
    UrOrt: TLabel;
    UrBreite: TLabel;
    UrLaenge: TLabel;
    Neu1: TMenuItem;
    Suchen1: TMenuItem;
    N3: TMenuItem;
    Label3: TLabel;
    Image2: TImage;
    Tabelle: TStringGrid;
    Neunumerieren1: TMenuItem;
    NeueZeile1: TMenuItem;
    letzteZeilelschen1: TMenuItem;
    PopupMenu1: TPopupMenu;
    DieseZeilelschen1: TMenuItem;
    Rckgngiglschen1: TMenuItem;
    Tabelleinitialisieren1: TMenuItem;
    N4: TMenuItem;
    Label4: TLabel;
    Zeilekopieren1: TMenuItem;
    ZeilenEinfgen1: TMenuItem;
    Speicherlschen1: TMenuItem;
    Speichern2: TMenuItem;
    AlleHakenentfernen1: TMenuItem;
    Hakeninvertieren1: TMenuItem;
    N5: TMenuItem;
    procedure Drucken1Click(Sender: TObject);
    procedure Beenden1Click(Sender: TObject);
    //procedure OrteAfterOpen(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
    procedure Kurswinkelberechnen1Click(Sender: TObject);
    procedure FilternClick(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Windroseerstellen1Click(Sender: TObject);
    procedure Eingabeinfo1Click(Sender: TObject);
    procedure Suchen1Click(Sender: TObject);
    procedure Neu1Click(Sender: TObject);
    procedure ffnen1Click(Sender: TObject);
    procedure Speichern1Click(Sender: TObject);
    //procedure OrteAfterClose(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure TabelleMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TabelleMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TabelleDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure TabelleDblClick(Sender: TObject);
    procedure TabelleSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Neunumerieren1Click(Sender: TObject);
    procedure TabelleSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure NeueZeile1Click(Sender: TObject);
    procedure letzteZeilelschen1Click(Sender: TObject);
    procedure DieseZeilelschen1Click(Sender: TObject);
    procedure Rckgngiglschen1Click(Sender: TObject);
    procedure Tabelleinitialisieren1Click(Sender: TObject);
    procedure UrOrtDblClick(Sender: TObject);
    procedure Zeilekopieren1Click(Sender: TObject);
    procedure ZeilenEinfgen1Click(Sender: TObject);
    procedure Speicherlschen1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Speichern2Click(Sender: TObject);
    procedure Label4DblClick(Sender: TObject);
    procedure KursserverExecuteMacro(Sender: TObject; Msg: TStrings);
    procedure Hakeninvertieren1Click(Sender: TObject);
    procedure AlleHakenentfernen1Click(Sender: TObject);
  private
    Anfang: TPoint;
    Doppelklick, rechts, Modified, Gestartet: Boolean;
  Protected
    Procedure WMDropFiles(var Msg: TMessage);
              message wm_DropFiles;
  public
    AktuOrt: TAktuOrt;
    Speicher: TSpeicher;
    Function Komma(s: String): String;
    //Function Finde(a: Integer; s: String; Ganz: Boolean): TAktuOrt;
  end;

var
  Kursberechnung: TKursberechnung;
  Sorted: TSort;
  Dateiname, SMakro: String;

implementation

uses KursDDE00002, KursDDE00003, KursDDE00004, KursDDE00005,
     KursDDE00007, KursDDE00008, KursDDE00009;

{$R *.lfm}

Procedure TabelleInitialisieren;
Var i: Integer;
begin
With Kursberechnung.Tabelle do
     Begin
     ColWidths[0]:= SpaltenBreite0;
     ColWidths[1]:= SpaltenBreite1;
     ColWidths[2]:= SpaltenBreite2;
     ColWidths[3]:= SpaltenBreite2;
     ColWidths[4]:= SpaltenBreite4;
     ColWidths[5]:= SpaltenBreite5;
     For i:= 6 to 12 do
         ColWidths[i]:= SpaltenBreite6;
     ColWidths[13]:= SpaltenBreite13;
     Cells[0, 0]:= SpaltenTitel0;
     Cells[1, 0]:= SpaltenTitel1;
     Cells[2, 0]:= SpaltenTitel2;
     Cells[3, 0]:= SpaltenTitel3;
     Cells[4, 0]:= SpaltenTitel4;
     Cells[5, 0]:= SpaltenTitel5;
     Cells[6, 0]:= SpaltenTitel6;
     Cells[7, 0]:= SpaltenTitel7;
     Cells[8, 0]:= SpaltenTitel8;
     Cells[9, 0]:= SpaltenTitel9;
     Cells[10, 0]:= SpaltenTitel10;
     Cells[11, 0]:= SpaltenTitel11;
     Cells[12, 0]:= SpaltenTitel12;
     Cells[13, 0]:= Auswahl;
     Cells[0, 1]:= '1';
     RowCount:= 2;
     DefaultRowHeight:= 23;
     End;
End;

Procedure Eintraege;
Var i, l: Integer;
Begin
l:= 0;
Kursberechnung.Tabelle.Canvas.Font.Name:= 'MS Sans Serif';//Haken hat Windings!!!
Kursberechnung.Tabelle.Canvas.Font.Size:= 9;
For i:= 1 to Kursberechnung.Tabelle.RowCount - 1 do
    if Kursberechnung.Tabelle.Canvas.TextWidth(Kursberechnung.Tabelle.Cells[0, i]) > l
       Then l:= Kursberechnung.Tabelle.Canvas.TextWidth(Kursberechnung.Tabelle.Cells[0, i]);
Kursberechnung.Tabelle.ColWidths[0]:= 10 + l;
If Kursberechnung.Tabelle.RowCount = 2
   Then Kursberechnung.Label3.Caption:= 'Die Tabelle enthält einen Eintrag'
   Else Kursberechnung.Label3.Caption:= Format('Die Tabelle enthält %d Einträge', [Kursberechnung.Tabelle.RowCount - 1]);
End;

Function Finde(a: Integer; s: String): TAktuOrt;
Var i: Integer;
Begin
For i:= 1 to Kursberechnung.Tabelle.RowCount - 1 do
    if s = Kursberechnung.Tabelle.Cells[a, i]
       then Begin
            Kursberechnung.Tabelle.TopRow:= i;
            Result.Spalte:= a;
            Result.Zeile:= i;
            Result.Name:= Kursberechnung.Tabelle.Cells[a,i];
            Exit;
            End;
Result.Spalte:= 1;
Result.Zeile:= 1;
Result.Name:= '';
Kursberechnung.Tabelle.TopRow:= 1;
End;

Function Vertausche(h, i: Integer): boolean;
Var Zeile: Array [0..13] of String;
    j: Integer;
Begin
For j:= 0 to 13 do
    Begin
    Zeile[j]:= Kursberechnung.Tabelle.Cells[j, h];
    Kursberechnung.Tabelle.Cells[j, h]:= Kursberechnung.Tabelle.Cells[j, i];
    Kursberechnung.Tabelle.Cells[j, i]:= Zeile[j];
    End;
Result:= True;
End;

Function UmlauteRaus(s: String):String;
Var i: Integer;
begin
s:= UpperCase(s);
If Length(s) > 0
   Then For I:= 0 to Length(s) do
            Begin If s[i] = 'Ä'
                     Then s[i]:= 'A';
                  If s[i] = 'Ö'
                     Then s[i]:= 'O';
                  If s[i] = 'Ü'
                     Then s[i]:= 'U';
                  If s[i] = 'ß'
                     Then Begin
                          s[i]:= 'S';
                          Insert('S', s, i);
                          End;
            End;
Result:= s;
End;

Procedure QuickSortSAb(Spalte: Integer; Links, Rechts: Longint);
Var i, j: Longint;
    S: String;
Begin
i:= Links;
j:= Rechts;
s:= UmlauteRaus(Kursberechnung.tabelle.Cells[Spalte,(links + Rechts) Div 2]);
Repeat
while UmlauteRaus(Kursberechnung.tabelle.Cells[Spalte, i]) < s do
      inc(i);
while UmlauteRaus(Kursberechnung.tabelle.Cells[Spalte, j]) > s do
      dec(j);
If i <= j
   Then Begin
        Vertausche(i, j);
        Inc(i);
        Dec(j);
        End;
Until i > j;
If Links < j
   then QuickSortSAb(Spalte, links, j);
If Rechts > i
   then QuickSortSAb(Spalte, i, Rechts);
End;

Procedure QuickSortSAuf(Spalte: Integer; Links, Rechts: Longint);
Var i, j: Longint;
    S: String;
Begin
i:= Links;
j:= Rechts;
s:= UmlauteRaus(Kursberechnung.tabelle.Cells[Spalte,(links + Rechts) Div 2]);
Repeat
while UmlauteRaus(Kursberechnung.tabelle.Cells[Spalte, i]) > s do
      inc(i);
while UmlauteRaus(Kursberechnung.tabelle.Cells[Spalte, j]) < s do
      dec(j);
If i <= j
   Then Begin
        Vertausche(i, j);
        Inc(i);
        Dec(j);
        End;
Until i > j;
If Links < j
   then QuickSortSAuf(Spalte, links, j);
If Rechts > i
   then QuickSortSAuf(Spalte, i, Rechts);
End;

Function Reelle(s: String): Real;
Var r: Real;
    Code: Integer;
Begin
If s = ''
   Then Result:= 0
   Else Begin
        s[pos(',', s)]:= '.';
        Val(s, r, code);
        Result:= r;
        End;
End;

Procedure QuickSortZAb(Spalte: Integer; Links, Rechts: Longint);
Var i, j: Longint;
    r: Real;
Begin
i:= Links;
j:= Rechts;
r:= Reelle(Kursberechnung.tabelle.Cells[Spalte,(links + Rechts) Div 2]);
Repeat
while Reelle(Kursberechnung.tabelle.Cells[Spalte, i]) < r do
      inc(i);
while Reelle(Kursberechnung.tabelle.Cells[Spalte, j]) > r do
      dec(j);
If i <= j
   Then Begin
        Vertausche(i, j);
        Inc(i);
        Dec(j);
        End;
Until i > j;
If Links < j
   then QuickSortZAb(Spalte, links, j);
If Rechts > i
   then QuickSortZAb(Spalte, i, Rechts);
End;

Procedure QuickSortZAuf(Spalte: Integer; Links, Rechts: Longint);
Var i, j: Longint;
    r: Real;
Begin
i:= Links;
j:= Rechts;
r:= Reelle(Kursberechnung.tabelle.Cells[Spalte,(links + Rechts) Div 2]);
Repeat
while Reelle(Kursberechnung.tabelle.Cells[Spalte, i]) > r do
      inc(i);
while Reelle(Kursberechnung.tabelle.Cells[Spalte, j]) < r do
      dec(j);
If i <= j
   Then Begin
        Vertausche(i, j);
        Inc(i);
        Dec(j);
        End;
Until i > j;
If Links < j
   then QuickSortZAuf(Spalte, links, j);
If Rechts > i
   then QuickSortZAuf(Spalte, i, Rechts);
End;

Procedure Sortiere(Spalte: Integer; Art, Typ: Char);
Var Auf: Boolean;
Begin
If Art = '?'
   Then Begin
        if Sorted.Col = Spalte
           Then Auf:= not Sorted.auf
           Else Auf:= True;
        End
   Else If Art = 'a'
             Then Auf:= True
             Else Auf:= False;
If Typ = 'S'
   Then Begin
        If auf
           Then QuicksortSAb(Spalte, 1, Kursberechnung.Tabelle.RowCount - 1)
           Else QuicksortSAuf(Spalte, 1, Kursberechnung.Tabelle.RowCount - 1);
        End
   Else If auf
           Then QuicksortZAb(Spalte, 1, Kursberechnung.Tabelle.RowCount - 1)
           Else QuicksortZAuf(Spalte, 1, Kursberechnung.Tabelle.RowCount - 1);
Sorted.Col:= Spalte;
Sorted.Auf:= Auf;
End;

Procedure Haken(Zeile: Integer);
Var i: Integer;
Begin
If Zeile = 0
   Then Begin
        For i:= 1 to Kursberechnung.Tabelle.RowCount - 1 Do
        Kursberechnung.Tabelle.Cells[13, i]:= Auswahl
        End
   Else If Kursberechnung.Tabelle.Cells[13, Zeile] = Auswahl
           Then Kursberechnung.Tabelle.Cells[13, Zeile]:= ''
           Else Kursberechnung.Tabelle.Cells[13, Zeile]:= Auswahl;
Kursberechnung.Modified:= True;
End;

procedure TKursberechnung.TabelleMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Column, Row: Longint;
begin
Tabelle.MouseToCell(X, Y, Column, Row);
If (Anfang.x = X) and (Anfang.y = Y) and (Row = 0) and (Button = mbLeft)
   Then Begin
        Screen.Cursor:= crHourGlass;
        Case Column of
          0: Sortiere(column, '?', 'Z');
          1: Sortiere(column, '?', 'S');
          2: Sortiere(6, '?', 'Z');
          3: Sortiere(7, '?', 'Z');
          4: Sortiere(column, '?', 'S');
          5: Sortiere(column, '?', 'S');
          6: Sortiere(6, '?', 'Z');
          7: Sortiere(7, '?', 'Z');
          8: Sortiere(8, '?', 'Z');
          9: Sortiere(9, '?', 'Z');
         10: Sortiere(10, '?', 'Z');
         11: Sortiere(11, '?', 'Z');
         12: Sortiere(12, '?', 'Z');
             End;
        Tabelle.TopRow:= Finde(1, AktuOrt.Name).zeile;
        Screen.Cursor:= crDefault;
        End;
End;

Procedure SchreibeR(s: String; Rect: TRect; C: TColor; Canvas: TCanvas);
Begin
Canvas.Brush.Color:= C;
Canvas.FillRect(Rect);
Canvas.Font.Color:= clBlack;
Canvas.TextOut(Rect.Right - Canvas.TextWidth(s) - 5,
               Rect.Top + (Kursberechnung.Tabelle.DefaultRowHeight
               - Canvas.TextHeight(s)) Div 2, s);
End;

Procedure SchreibeL(s: String; Rect: TRect; C: TColor; Canvas: TCanvas);
Begin
Canvas.Brush.Color:= C;
//Canvas.brush.Style:= bsClear;
Canvas.Font.Color:= clBlack;
Canvas.FillRect(Rect);
Canvas.TextOut(Rect.Left + 5,
               Rect.Top + (Kursberechnung.Tabelle.DefaultRowHeight
               - Canvas.TextHeight(s)) Div 2, s);
End;

Procedure Nummeriere(Zeile: Integer);
Begin
With Kursberechnung.Tabelle.Canvas do
     Begin
     Font.Size:= 9;
     //Font.Style:= [fsBold];
     SchreibeR(Kursberechnung.Tabelle.Cells[0, Zeile],
               Kursberechnung.Tabelle.CellRect(0, Zeile),
               clBtnFace,
               Kursberechnung.Tabelle.Canvas);
     //Schriftgröße zurück setzen?
     End;
End;

Procedure ZeichneHaken(Zeile: Integer; C: TColor);
Begin
With Kursberechnung.Tabelle.Canvas Do
     Begin
     Font.Size:= 12;
     Font.Name:= 'Wingdings';
     Brush.Color:= C;
     FillRect(Kursberechnung.Tabelle.CellRect(13, Zeile));
     Font.Color:= clBlack;
     TextOut(Kursberechnung.Tabelle.CellRect(13, Zeile).Left + 5,
             Kursberechnung.Tabelle.CellRect(13, Zeile).Top +
             (Kursberechnung.Tabelle.DefaultRowHeight
               - TextHeight(Auswahl)) Div 2,
             Kursberechnung.Tabelle.Cells[13, Zeile]);
     Brush.Style:= bsClear;
     End;
End;

Procedure KursdateiSpeichern(Datei: String);
Var tf: TextFile;
    i, j: Integer;
Begin
AssignFile(tf, Datei);
Rewrite(tf);
Writeln(tf, Kursberechnung.UrOrt.Caption);
For i:= 1 to Kursberechnung.Tabelle.RowCount - 1 do
    For j:= 0 to Kursberechnung.Tabelle.ColCount - 1 do
        Writeln(tf, Kursberechnung.Tabelle.cells[j, i]);
CloseFile(tf);
End;

Procedure KursDateiOeffnen(Datei: String);
Var tf: Textfile;
    i, j: Integer;
    s, t: String;
Begin
Assignfile(tf, Datei);
Reset(tf);
i:= 0;
Readln(tf, t);
Kursberechnung.Tabelle.RowCount:= 2;
While not EoF(tf) do
Begin
i:= i + 1;
Kursberechnung.Tabelle.RowCount:= Kursberechnung.Tabelle.RowCount + 1;
For j:= 0 to Kursberechnung.Tabelle.ColCount - 1 do
    Begin
    Readln(tf, s);
    Kursberechnung.Tabelle.Cells[j, i]:= s;
    End;
End;
If Kursberechnung.Tabelle.RowCount > 2
   Then Kursberechnung.Tabelle.RowCount:= Kursberechnung.Tabelle.RowCount - 1;
CloseFile(tf);
Kursberechnung.AktuOrt:= Finde(1, t);
Kursberechnung.Label4.Caption:= 'Aktueller Ort: ' + Kursberechnung.AktuOrt.Name;
Eintraege;
Dateiname:= Datei;
If Kursberechnung.AktuOrt.Name <> ''
   Then Begin
        Kursberechnung.UrOrt.Caption:= Kursberechnung.AktuOrt.Name;
        Kursberechnung.UrBreite.Caption:= Kursberechnung.Tabelle.Cells[2, Kursberechnung.AktuOrt.Zeile];
        Kursberechnung.UrLaenge.Caption:= Kursberechnung.Tabelle.Cells[3, Kursberechnung.AktuOrt.Zeile];
        Kursberechnung.Tabelle.Cells[13, Kursberechnung.AktuOrt.Zeile]:= '';
        End;
Kursberechnung.Caption:= 'Kursberechnung [' + ExtractFileName(Datei) + ']';// ist vielleicht nur lokal!
End;

Procedure CSVOpen(Datei: String);
Var tf: TextFile;
    Zeile, i: Integer;

 Function LeseWert: String;
 Var c: String[1];
     s: String;
 Begin
 c:= '';
 s:= '';
 Repeat
 s:= s + c;
 Read(tf, c);
 Until c = ';';
 Result:= s;
 End;

Begin
TabelleInitialisieren;
AssignFile(tf, Datei);
reset(tf);
Zeile:= 0;
Kursberechnung.Tabelle.RowCount:= 2;
Readln(tf);
While not EoF(tf) do
      Begin
      Zeile:= Zeile + 1;
      Kursberechnung.Tabelle.RowCount:= Kursberechnung.Tabelle.RowCount + 1;
      For i:= 1 to 12 do   //Hat nur bis 5 sinn
          Kursberechnung.Tabelle.Cells[i, Zeile]:= LeseWert;
      Kursberechnung.Tabelle.Cells[13, Zeile]:= '';
      Readln(tf);
      End;
CloseFile(tf);
If Kursberechnung.Tabelle.RowCount > 2
   then Kursberechnung.Tabelle.RowCount:= Kursberechnung.Tabelle.RowCount - 1;
Kursberechnung.Neunumerieren1.Click;
Eintraege;
Dateiname:= Datei;
Kursberechnung.AktuOrt:= Finde(1, MeinOrt);
Kursberechnung.Label4.Caption:= 'Aktueller Ort: ' + Kursberechnung.AktuOrt.Name;
Kursberechnung.UrOrt.Caption:= Kursberechnung.Aktuort.Name;
Kursberechnung.UrBreite.Caption:= Kursberechnung.Tabelle.Cells[2, Kursberechnung.AktuOrt.Zeile];
Kursberechnung.UrLaenge.Caption:= Kursberechnung.Tabelle.Cells[3, Kursberechnung.AktuOrt.Zeile];
Kursberechnung.Caption:= 'Kursberechnung [' + ExtractFileName(Datei) + ']';// ist vielleicht nur lokal!
Kursberechnung.Kurswinkelberechnen1.Click;
End;

Procedure TKursberechnung.WMDropFiles(Var Msg: TMessage);
Var FileName: Array[0..256] of Char;
Begin
DragQueryFile(THandle(Msg.WParam),0,FileName,SizeOf(FileName));
DragFinish(THandle(Msg.WParam));
If ExtractFileExt(FileName) = '.csv'
   Then CSVOpen(FileName)
   Else Kursdateioeffnen(FileName);
End;

procedure TKursberechnung.TabelleMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var Spalte, Zeile: Integer;
begin
if button = mbRight
   then rechts:= True
   else rechts:= False;
Anfang.x:= X;
Anfang.y:= Y;
Tabelle.MouseToCell(x, y, Spalte, Zeile);
If Zeile <> 0
   Then Begin
   AktuOrt.Spalte:= Spalte;
   AktuOrt.Zeile:= Zeile;
   AktuOrt.Name:= Tabelle.Cells[1, Zeile];
   Kursberechnung.Label4.Caption:= 'Aktueller Ort: ' + AktuOrt.Name;
   End;
If Spalte <> 1
   then Doppelklick:= False;
If Doppelklick And (Spalte = 1) and (Zeile <> 0)
   Then Begin
        Urort.Caption:= Tabelle.Cells[1, Zeile];
        UrBreite.Caption:= Tabelle.Cells[2, Zeile];
        UrLaenge.Caption:= Tabelle.Cells[3, Zeile];
        Kursberechnung.Kurswinkelberechnen1.Click;
        Doppelklick:= False;
        //Tabelle.TopRow:= Zeile;
        End;
If Spalte = 13
   then Haken(Zeile);

end;

Function Umrechnen (c: String): Real;
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

Function BerechneLm (UL, L: real): real;
Begin
Result:= Abs (L - UL);
End;

Function BerechneE (h, n, Lm: Real): Real;
Var e: real;
Begin
e:= cos (h / 180 * pi)
  * cos (n / 180 * pi)
  + sin (h / 180 * pi)
  * sin (n / 180 * pi)
  * cos (Lm / 180 * pi);  //ohne e gibts bei Dresden einen Fehler!!! Warum???
Result:= (ArcCos (e)) * 180 / pi;
End;

Function BerechneA (e, n, Lm, h: Real): Real;
Var a, m: Real;
Begin
If e <> 0
   Then a:=(Arcsin (sin (Lm / 180 * pi)
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

Function BerechneG (Lm, a, h, Ul, le: Real): Real;
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



Procedure CsvTabelleErzeugen(Dateiname: String);
Var CsvDatei: Textfile;
    i, j: Integer;

 Function Pruefe(s: String): String;
 Begin
 If Pos(';', s) <> 0
    Then ShowMessage('Um eine Tabelle als CSV-Datei zu speichern, dürfen '
                     + 'in ihr keine Semikola vorkommen! Eine Zelle enthält aber diesen Text: "'
                     + s + '"  Das Semikolon wird nicht in der CSV-Datei gespeichert!');
 Delete(s, Pos(';', s), 1);
 Result:= s + ';';
 End;

Begin
Assignfile(CsvDatei, Dateiname);
Rewrite(CsvDatei);
For j:= 0 to Kursberechnung.Tabelle.RowCount - 1 do
    Begin
    For i:= 1 to 12{Kursberechnung.Tabelle.ColCount - 1} do
        Write(CsvDatei, Pruefe(Kursberechnung.Tabelle.Cells[i,j]));
    Writeln(CsvDatei);
    End;
CloseFile(CsvDatei);
Finde(1, Kursberechnung.AktuOrt.Name);
End;

Function Punkt(s: String): String;
Begin
if s <> ''
   Then s[Pos('.',s)]:= ',';
Result:= s;
End;

Function TKursberechnung.Komma(s: String): String;
Begin
if s <> ''
   Then s[Pos(',',s)]:= '.';
Result:= s;
End;

Procedure Open(s: String);
Begin
If LowerCase(ExtractFileExt(s)) = '.krs'
   Then Kursdateioeffnen(s);
If LowerCase(ExtractFileExt(s)) = '.csv'
   Then CSVOpen(s);
Kursberechnung.Modified:= False;
End;

procedure Ausfuehren(Befehl: String);
Var s, t, d: String;
    a, e: Integer;
Begin
t:= Befehl;//LowerCase(Befehl);
d:= Dateiname;
a:= Pos('[', t);
While a > 0 do
Begin  
e:= Pos(']', t);
If e <= a
   Then Begin
        MessageDlg('Kann Makros nicht ausführen!', mtError, [mbOk], 0);
        Exit;
        End;
s:= copy(t,a + 1, e - a - 1);
Delete(t, 1, e);
If pos('open(', s) <> 0
   Then Begin
        delete(s, 1, pos('(', s));
        delete(s, pos(')', s), Length(s));
        If Kursberechnung.Modified
           Then If MessageDlg('Datei ' + Kursberechnung.Caption + ' speichern?',
                               mtConfirmation, [mbYes, mbNo], 0) = mrYes
                   Then Kursberechnung.Speichern1.Click;
        Open(s);
        End
Else If pos('quer', s) <> 0
        Then Druckvorschau.Quer:= True
Else If pos('hoch', s) <> 0
        Then Druckvorschau.Quer:= False
Else If pos('print', s) <> 0
        Then Druckvorschau.ExternDrucken
Else If pos('windrose_drucken', s) <> 0
        Then Begin
             Windrose.Caption:= 'Windrose für '  + Kursberechnung.UrOrt.Caption
               + '  ' + Kursberechnung.UrBreite.Caption + ' / '
               + Kursberechnung.UrLaenge.Caption;
             Windrose.gesamteWindrose1.Click;
             End
Else If pos('quit', s) <> 0
        Then Kursberechnung.Beenden1.click
Else If pos('exit', s) <> 0
        Then Open(d)
Else MessageDlg('Kenne Makro nicht! <' + s + '>', mtError, [mbOk], 0);
a:= Pos('[',t);
End;
End;

procedure TKursberechnung.Drucken1Click(Sender: TObject);
begin
Druckvorschau.Show;
Finde(1, AktuOrt.Name);
end;

procedure TKursberechnung.Beenden1Click(Sender: TObject);
begin
Close;
end;

procedure TKursberechnung.FormShow(Sender: TObject);
begin
Film.ShowModal;
//ShowMessage(SMakro + ' !');
Ausfuehren(SMakro);
Gestartet:= True;
end;

procedure TKursberechnung.Kurswinkelberechnen1Click(Sender: TObject);
Var i: Integer;
    B: String;
    UrBreiteR, UrLaengeR, Breite, Laenge,
    e, e2, Lm, h, n, a, g: Real;
begin
If UrBreite.Caption = ''
   then ShowMessage('Um die Berechnung ausführen zu können, müssen Sie erst'
                    + ' einen Urort festlegen! Klicken Sie dazu auf einen Ort in der Tabelle doppelt.'
                    + ' Für diesen Ort müssen Koordinaten eingetragen sein!')
   Else With Tabelle do
        Begin
        UrBreiteR:= Umrechnen (UrBreite.Caption);
        UrLaengeR:= Umrechnen (UrLaenge.Caption);
        For i:= 1 to RowCount - 1 do
            Begin
            B:= Cells [2,i];
            Breite:= Umrechnen (B);
            Str (Breite:5:4, B);
            Cells [6,i]:= Punkt(B);
            B:= Cells [3,i];
            Laenge:= Umrechnen (B);
            Str (Laenge:5:4, B);
            Cells [7,i]:= Punkt(B);
            h:= 90 - UrBreiteR;
            n:= 90 - Breite;
            Lm:= BerechneLm (UrLaengeR, Laenge);
            Str (Lm:5:4, B);
            Cells [8,i]:= Punkt(B);
            e:= BerechneE (h, n, Lm);
            Str (e:5:4, B);
            Cells [9,i]:= Punkt(B);
            e2:= ((BerechneE (h, n, Lm)) * 40075)/360;
            Str (e2:5:3, B);
            Cells [10,i]:= Punkt(B);
            a:= berechneA (e, n, Lm, h);
            Str (a:5:4, B);
            Cells [11,i]:= Punkt(B);
            g:= berechneG (Lm, a, h, UrlaengeR, laenge);
            Str (g:5:4, B);
            Cells [12,i]:= Punkt(B);
            End;
        //Haken(0);
        //ShowMessage('Noch keine neuen Haken gesetzt!');
        Tabelle.Cells[13, Finde(1, UrOrt.Caption).Zeile]:= '';
        Finde(1, AktuOrt.Name);
        Modified:= True;
        End;
end;

procedure TKursberechnung.FilternClick(Sender: TObject);
Var Gradfeld: Array [1..cMaxWerte] of Real;
    i, j, k, Code: Integer;
begin
For k:= 1 to Tabelle.RowCount - 1 do
    Val(Komma(Tabelle.Cells[12,k]),Gradfeld[k],Code);
For i:= 1 To Tabelle.RowCount - 1 do
    If Tabelle.Cells[13,i] = Auswahl
       Then For j:= 1 to Tabelle.RowCount - 1 do
                Begin
                If (Gradfeld[i] < Gradfeld[j]) and (Gradfeld[j] < Gradfeld[i]+Winkel)
                   Then Tabelle.Cells[13,j]:='';
                If (Gradfeld[i] >= 360 - Winkel) and (Gradfeld[j] < Gradfeld[i] + Winkel - 360)
                   Then If (Gradfeld[i] < Gradfeld[j] + 360) and (Gradfeld[j] + 360 < Gradfeld[i]+Winkel)
                        Then Tabelle.Cells[13,j]:='';
                End;
Finde(1, AktuOrt.Name);
Modified:= True;
end;

procedure TKursberechnung.Image2Click(Sender: TObject);
begin
Bilder.show;
end;

procedure TKursberechnung.Windroseerstellen1Click(Sender: TObject);
begin
Windrose.Caption:= 'Windrose für '  +
  UrOrt.Caption+'  '+UrBreite.Caption+' / '+UrLaenge.Caption;
Windrose.Show;
end;

procedure TKursberechnung.Eingabeinfo1Click(Sender: TObject);
begin
Programminfo.ShowModal;
end;

procedure TKursberechnung.Suchen1Click(Sender: TObject);
begin
Sucheform.Show;
end;

procedure TKursberechnung.Neu1Click(Sender: TObject);
Var i: Integer;
begin
If Modified
   Then case MessageDlg('Datei ' + Caption + ' speichern?',
                       mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
             mrYes: Begin
                    Speichern1.Click;
                    Exit;
                    End;
             mrCancel: Exit;
             End;
Dateiname:= 'Unbenannt';
Caption:= 'Kursberechnung [' + ExtractFileName(Dateiname) + ']';
Tabelle.RowCount:= 2;
for i:= 1 to Tabelle.ColCount - 1 do
    Tabelle.Cells[i, 1]:= '';
Tabelle.Cells[0, 1]:= '1';
Eintraege;
Label4.Caption:= '';
UrOrt.Caption:= '';
Modified:= False;
end;

procedure TKursberechnung.ffnen1Click(Sender: TObject);
begin
If Modified
   Then Case MessageDlg('Datei ' + Caption + ' speichern?',
                       mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
             mrYes: Begin
                    Speichern1.Click;
                    Exit;
                    End;
             mrCancel: Exit;
             End;
If Offnen.Execute
   Then Begin
        If ExtractFileExt(Offnen.FileName) = ''
        Then Case Offnen.FilterIndex Of
                   1: Offnen.FileName:= Offnen.FileName + '.krs';
                   2: Offnen.FileName:= Offnen.FileName + '.csv';
                   3: Kursdateioeffnen(Offnen.FileName);
                   End;
        Open(Offnen.FileName);
        End;
end;

procedure TKursberechnung.Speichern1Click(Sender: TObject);
begin
Speichern.Filter:= 'Kurs Dateien (*.krs)|*.krs|' +
                   'CSV Dateien (*.csv)|*.csv|Alle Dateien (*.*)|*.*';
If Speichern.Execute
   Then Begin
        If ExtractFileExt(Speichern.FileName) = ''
           Then Case Speichern.FilterIndex Of
                     1: Speichern.FileName:= Speichern.FileName + '.krs';
                     2: Speichern.FileName:= Speichern.FileName + '.csv';
                     3: KursdateiSpeichern(Speichern.FileName);
                     End;
        If FileExists(Speichern.FileName)
           Then If MessageDlg('Die Datei existiert bereits! Datei überschreiben?',
                   mtConfirmation, [mbYes, mbNo], 0) = mrNo
                   Then Exit;
        If ExtractFileExt(Speichern.FileName) = '.csv'
           Then CSVTabelleerzeugen(Speichern.FileName);
        If ExtractFileExt(Speichern.FileName) = '.krs'
           Then KursdateiSpeichern(Speichern.FileName);
        Modified:= False;
        End;
end;

procedure TKursberechnung.FormCreate(Sender: TObject);
begin
SetCurrentDir(ExtractFileDir(ParamStr(0)));//Wichtig für Dateiverbindung
If FileExists('Kursdreieck3.bmp')
   Then Image2.Picture.LoadFromFile('Kursdreieck3.bmp')
   Else ShowMessage('Bilddatei Kursdreieck3.bmp fehlt!');
Dateiname:= 'Unbennant';
Tabelleinitialisieren;
Eintraege;
DragAcceptFiles(Handle, True);
//ShowMessage((ParmStr(1)));
Open(ParamStr(1));
end;

procedure TKursberechnung.TabelleDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
If ARow = 0
   Then Case ACol of
             0: SchreibeR(Tabelle.Cells[Acol,aRow],Rect,clBtnFace,Tabelle.canvas);
             1: SchreibeL(Tabelle.Cells[Acol,aRow],Rect,clBtnFace,Tabelle.canvas);
             2: SchreibeR(Tabelle.Cells[Acol,aRow],Rect,clBtnFace,Tabelle.canvas);
             3: SchreibeR(Tabelle.Cells[Acol,aRow],Rect,clBtnFace,Tabelle.canvas);
             4: SchreibeL(Tabelle.Cells[Acol,aRow],Rect,clBtnFace,Tabelle.canvas);
             5: SchreibeL(Tabelle.Cells[Acol,aRow],Rect,clBtnFace,Tabelle.canvas);
             6: SchreibeR(Tabelle.Cells[Acol,aRow],Rect,clBtnFace,Tabelle.canvas);
             7: SchreibeR(Tabelle.Cells[Acol,aRow],Rect,clBtnFace,Tabelle.canvas);
             8: SchreibeR(Tabelle.Cells[acol,aRow],Rect,clBtnFace,Tabelle.canvas);
             9: SchreibeR(Tabelle.Cells[acol,aRow],Rect,clBtnFace,Tabelle.canvas);
            10: SchreibeR(Tabelle.Cells[acol,aRow],Rect,clBtnFace,Tabelle.canvas);
            11: SchreibeR(Tabelle.Cells[acol,aRow],Rect,clBtnFace,Tabelle.canvas);
            12: SchreibeR(Tabelle.Cells[acol,aRow],Rect,clBtnFace,Tabelle.canvas);
            13: ZeichneHaken(ARow, clBtnFace);
            End
   Else Case ACol of
             0: Nummeriere(ARow);
             1: SchreibeL(Tabelle.Cells[Acol,aRow],Rect,clWhite,Tabelle.canvas);
             2: SchreibeR(Tabelle.Cells[Acol,aRow],Rect,clWhite,Tabelle.canvas);
             3: SchreibeR(Tabelle.Cells[Acol,aRow],Rect,clWhite,Tabelle.canvas);
             4: SchreibeL(Tabelle.Cells[Acol,aRow],Rect,clWhite,Tabelle.canvas);
             5: SchreibeL(Tabelle.Cells[Acol,aRow],Rect,clWhite,Tabelle.canvas);
             6: SchreibeR(Tabelle.Cells[Acol,aRow],Rect,clWhite,Tabelle.canvas);
             7: SchreibeR(Tabelle.Cells[Acol,aRow],Rect,clWhite,Tabelle.canvas);
             8: SchreibeR(Tabelle.Cells[acol,aRow],Rect,clWhite,Tabelle.canvas);
             9: SchreibeR(Tabelle.Cells[acol,aRow],Rect,clWhite,Tabelle.canvas);
            10: SchreibeR(Tabelle.Cells[acol,aRow],Rect,clWhite,Tabelle.canvas);
            11: SchreibeR(Tabelle.Cells[acol,aRow],Rect,clWhite,Tabelle.canvas);
            12: SchreibeR(Tabelle.Cells[acol,aRow],Rect,clWhite,Tabelle.canvas);
            13: ZeichneHaken(aRow, ClWhite);
            End;
end;

procedure TKursberechnung.TabelleDblClick(Sender: TObject);
begin
Doppelklick:= True;
end;

procedure TKursberechnung.TabelleSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
If ACol in [6..13]
   Then CanSelect:= False;
end;

procedure TKursberechnung.Neunumerieren1Click(Sender: TObject);
Var i: Integer;
begin
For i:= 1 to Tabelle.RowCount - 1 do
    Begin
    Tabelle.Cells[0, i]:= IntToStr(i);
    Nummeriere(i);
    End;
Modified:= True;
end;

procedure TKursberechnung.TabelleSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
Var s: String;
begin
Doppelklick:= False;
Modified:= True;
If ACol = 2
   then Begin
        Str (Umrechnen(Value):5:4, s);
        Tabelle.Cells[6, ARow]:= Punkt(s);
        end;
If ACol = 3
   then Begin
        Str (Umrechnen(Value):5:4, s);
        Tabelle.Cells[7, ARow]:= Punkt(s);
        end;
end;

procedure TKursberechnung.NeueZeile1Click(Sender: TObject);
Var i: Integer;
begin
Tabelle.RowCount:= Tabelle.RowCount + 1;
for i:= 1 to Tabelle.ColCount - 1 do
    Tabelle.Cells[i, Tabelle.RowCount - 1]:= '';
Tabelle.Cells[0, Tabelle.RowCount - 1]:= IntToStr(Tabelle.RowCount - 1);
Eintraege;
Tabelle.TopRow:= Tabelle.RowCount - 1;
Modified:= True;
end;

procedure TKursberechnung.letzteZeilelschen1Click(Sender: TObject);
begin
If Aktuort.Name = Tabelle.Cells[1, Tabelle.RowCount - 1]
   Then Begin
        Aktuort.Name:= '';
        Aktuort.Zeile:= 1;
        Aktuort.Spalte:= 1;
        Label4.Caption:= '';
        end;
If Tabelle.RowCount <= 2
   Then ShowMessage('Die Tabelle muss mindestens einen Eintrag enthalten!')
   Else Tabelle.RowCount:= Tabelle.RowCount - 1;
Eintraege;
Modified:= True;
end;

procedure TKursberechnung.DieseZeilelschen1Click(Sender: TObject);
Var Spalte, Zeile, i: Integer;
begin
Tabelle.MouseToCell(Anfang.x, Anfang.y, Spalte, Zeile);
If Zeile = 0
   Then Exit;
If Aktuort.Name = Tabelle.Cells[1, Zeile]
   Then Begin
        Aktuort.Name:= '';
        Aktuort.Zeile:= 1;
        Aktuort.Spalte:= 1;
        Label4.Caption:= '';
        end;
//ShowMessage('Eintrag Nummer ' + Tabelle.Cells[0, Zeile] + ' wird gelöscht!');
If Tabelle.RowCount <= 2
   Then Begin
        for i:= 1 to Tabelle.ColCount - 1 do
            Tabelle.Cells[i, Tabelle.RowCount - 1]:= '';
        Eintraege;
        Exit;
        end;
for i:= Zeile to Tabelle.RowCount - 2 do
    Vertausche(i, i + 1);
Tabelle.RowCount:= Tabelle.RowCount - 1;
Eintraege;
Modified:= True;
end;

procedure TKursberechnung.Rckgngiglschen1Click(Sender: TObject);
begin
Tabelle.RowCount:= Tabelle.RowCount + 1;
Eintraege;
Modified:= True;
end;

procedure TKursberechnung.Tabelleinitialisieren1Click(Sender: TObject);
Var i: Integer;
begin
With Kursberechnung.Tabelle do
     Begin
     //ColWidths[0]:= SpaltenBreite0;
     ColWidths[1]:= SpaltenBreite1;
     ColWidths[2]:= SpaltenBreite2;
     ColWidths[3]:= SpaltenBreite2;
     ColWidths[4]:= SpaltenBreite4;
     ColWidths[5]:= SpaltenBreite5;
     For i:= 6 to 12 do
         ColWidths[i]:= SpaltenBreite6;
     ColWidths[13]:= SpaltenBreite13;
     End;
Eintraege;
end;

procedure TKursberechnung.UrOrtDblClick(Sender: TObject);
begin
finde(1, UrOrt.Caption);
end;

procedure TKursberechnung.Zeilekopieren1Click(Sender: TObject);
Var Spalte, Zeile, i: Integer;
begin
Tabelle.MouseToCell(Anfang.x, Anfang.y, Spalte, Zeile);
ZeilenEinfgen1.Enabled:= True;
SetLength(Speicher, Length(Speicher) + 1);
For i:= 0 to 13 do
    Speicher[High(Speicher), i]:= Tabelle.Cells[i, Zeile];
end;

procedure TKursberechnung.ZeilenEinfgen1Click(Sender: TObject);
Var l, i, j: Integer;
begin
l:= Tabelle.RowCount;
Tabelle.RowCount:= l + Length(Speicher);
For i:= 0 to High(Speicher) do
    For j:= 0 to 13 do
        Tabelle.Cells[j, i + l]:= Speicher[i, j];
Eintraege;
Modified:= True;
end;

procedure TKursberechnung.Speicherlschen1Click(Sender: TObject);
begin
SetLength(Speicher, 0);
ZeilenEinfgen1.Enabled:= False;
end;

procedure TKursberechnung.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
CanClose:= False;
If Modified
   Then case MessageDlg('Datei ' + Caption + ' speichern?',
                       mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
             mrYes: Speichern1.Click;
             mrNo: CanClose:= True;
             End
   Else CanClose:= True;
end;

procedure TKursberechnung.Speichern2Click(Sender: TObject);
begin
If ExtractFileExt(Dateiname) = '.csv'
   Then Begin
        CSVTabelleerzeugen(Dateiname);
        Modified:= False;
        Exit;
        End;
If ExtractFileExt(Dateiname) = '.krs'
   Then Begin
        KursdateiSpeichern(Dateiname);
        Modified:= False;
        Exit;
        End;
Speichern1.Click;
end;

procedure TKursberechnung.Label4DblClick(Sender: TObject);
var s: String;
begin
s:= Label4.Caption;
delete(s, 1, 15);
finde(1, s);
end;

procedure TKursberechnung.KursserverExecuteMacro(Sender: TObject;
  Msg: TStrings);
begin
{ShowMessage(InttoStr(Msg.Count) + ' Makros!');
ShowMessage(Sender.ClassName);
ShowMessage(StartMakros.CommaText);
{SMakro.Clear;
For i:= 0 to Msg.Count - 1 do
    SMakro.Add(Msg[i]);  }
If Msg = Nil
   Then Exit;
SMakro:= Msg.CommaText;
{If not Gestartet//Msg.Count = 1
   Then SMakro:= Msg[0];//Nach start des Programms auch TStrings möglich}
If Gestartet
   then Ausfuehren(SMakro);
end;

procedure TKursberechnung.Hakeninvertieren1Click(Sender: TObject);
Var i: Integer;
begin
For i:= 1 to Tabelle.RowCount - 1 do
    If Tabelle.Cells[13, i] = Auswahl
       Then Tabelle.Cells[13, i]:= ''
       Else Tabelle.Cells[13, i]:= Auswahl;
end;

procedure TKursberechnung.AlleHakenentfernen1Click(Sender: TObject);
Var i: Integer;
begin
For i:= 1 to Tabelle.RowCount - 1 do
    Tabelle.Cells[13, i]:= '';
end;

End.
