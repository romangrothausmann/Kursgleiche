unit KursDDE00005;

interface


uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, UStiftWindr2, TeeProcs, TeEngine, Chart, StdCtrls, Menus,
  Series, Clipbrd, ComCtrls, Printers;

const Breite  = 500;
      Abstand1= 10;
      Abstand2= 15;
      Abstand3=  5;
      Markierung= 252;
      z = 3.68;
      Rand = 80;
      cMaxWerte = 500;
      
type
  TWindrose = class(TForm)
    Panel1: TPanel;
    MainMenu1: TMainMenu;
    Drucken1: TMenuItem;
    Chart1: TChart;
    Series1: TLineSeries;
    Panel2: TPanel;
    Chart2: TChart;
    Series2: TLineSeries;
    PrinterSetupDialog1: TPrinterSetupDialog;
    gesamteWindrose1: TMenuItem;
    Fensterausschnitt1: TMenuItem;
    StatusBar1: TStatusBar;
    Ansicht1: TMenuItem;
    Einszueins1: TMenuItem;
    Image1: TImage;
    Zoominfo1: TMenuItem;
    Kopieren1: TMenuItem;
    Fensterausschnitt2: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Druckereinstellungen1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Series1AfterDrawValues(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Series2AfterDrawValues(Sender: TObject);
    procedure Chart1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Chart1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Chart1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure gesamteWindrose1Click(Sender: TObject);
    procedure Fensterausschnitt1Click(Sender: TObject);
    procedure Einszueins1Click(Sender: TObject);
    procedure Zoominfo1Click(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure Fensterausschnitt2Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure Druckereinstellungen1Click(Sender: TObject);
  private
    Stift1, Stift2: TStiftWindr2;
    Malen, Verschieben, Zoomen, Ausschnitt: Boolean;
  public
    {Procedure Zeichnen;}
  end;

var
  Windrose: TWindrose;
  Neuepos, RKRunter, LKRunter, MausRunter,
  UrsprungVorher, EndpunktVorher,
  UrsprungG, EndpunktG: TPoint;
  Verhaeltnis: Real;
  //Gradfeld: Array [1..2, 1..cMaxWerte] of Real;
  //Ortfeld: Array [1..cMaxWerte] of String;
  //Werte: Integer;

implementation

uses KursDDE00001, KursDDE00006;



{$R *.DFM}



{Function Komma(s: String): String;
Begin
if s <> ''
   Then s[Pos(',',s)]:= '.';
Result:= s;
End;}

Procedure Zeichnevergr(Ursprung, EndPunkt: TPoint);
Var zx, zy, i, HilfsKoordinate, Code: Integer;
    s: String;
    Grad: real;

Begin
If EndPunkt.x < Ursprung.x
   Then Begin
        HilfsKoordinate:= Ursprung.x;
        Ursprung.x:= Endpunkt.x;
        Endpunkt.x:= HilfsKoordinate;
        End;
If EndPunkt.y < Ursprung.y
   Then Begin
        HilfsKoordinate:= Ursprung.y;
        Ursprung.y:= Endpunkt.y;
        Endpunkt.y:= HilfsKoordinate;
        End;
If (EndPunkt.x<>Ursprung.x) Or (EndPunkt.y<>Ursprung.y)
  Then Begin
       If EndPunkt.x - Ursprung.x > EndPunkt.y - Ursprung.y
          Then Begin
               Verhaeltnis:= Breite/(EndPunkt.x - Ursprung.x);
               EndPunkt.y:= Ursprung.y + (EndPunkt.x - Ursprung.x);
               End
          Else Begin
               Verhaeltnis:= Breite/(EndPunkt.y - Ursprung.y);
               EndPunkt.x:= Ursprung.x + (EndPunkt.y - Ursprung.y);
               End;
       UrsprungG:= Ursprung;
       EndpunktG:= Endpunkt;
       If Verhaeltnis < 501
          Then Begin
               zx:= Round((- Ursprung.x + Breite/2) * Verhaeltnis);
               zy:= Round((- Ursprung.y + Breite/2) * Verhaeltnis);
               Windrose.StatusBar1.Panels[0].Text := Format('Vergrößerung: %f', [Verhaeltnis]);
               Windrose.StatusBar1.Panels[1].Text :=
                        Format('Fensterausschnitt: %d/%d - %d/%d', [Ursprung.x, Ursprung.y, Endpunkt.x, Endpunkt.y]);
               With Windrose.Chart1.Canvas do
                    Begin
                    brush.color := clWhite;
                    Pen.Color:= clblack;
                    Pen.Style:= psSolid;
                    Pen.Mode:= pmCopy;
                    FillRect (Rect (0, 0, Breite, Breite));
                    Ellipse(Round((Abstand1 - Ursprung.x) * Verhaeltnis),
                            Round((Abstand1 - Ursprung.y) * Verhaeltnis),
                            Round((Breite - Abstand1 - Ursprung.x) * Verhaeltnis),
                            Round((Breite - Abstand1 - Ursprung.y) * Verhaeltnis));
                    Font.Name:= 'Arial';
                    Font.Height:=-10;
                    Font.Color:= clBlack;
                    Pen.Width:=1;
                    End;
               For i:=1 to 360 do
                   With Windrose.Stift1 do
                        Begin
                        Hoch;
                        BewegeBis(zx, zy);
                        DreheBis(i);
                        BewegeUm((Breite/2 - Abstand2) * Verhaeltnis);
                        Runter;
                        BewegeUm((Abstand1) * Verhaeltnis);
                        End;
                For i:= 1 to Kursberechnung.Tabelle.RowCount - 1 do
                    If Kursberechnung.Tabelle.Cells[13,i] = Auswahl   // wert von 'ü'
                       Then Begin
                            Val (Kursberechnung.Komma(Kursberechnung.Tabelle.Cells [12, i]), Grad, Code);
                            If code = 0
                               Then With Windrose.Stift1 do
                                         Begin
                                         Hoch;
                                         BewegeBis(zx, zy);
                                         DreheBis(Grad);
                                         Runter;
                                         BewegeUm(Breite/2 * Verhaeltnis);
                                         Pfeil((Verhaeltnis - 1) + 10);
                                         DreheBis(Grad);
                                         Str(Grad:0:2 , s);
                                         Schreibe(zx, zy, (Breite/2 - Abstand2 - 5) * Verhaeltnis,
                                                  Grad, (Kursberechnung.Tabelle.Cells[1, i] + ' ' + s + '°'));
                                         End;
                            End;
                End;
       End;
End;

procedure TWindrose.Series1AfterDrawValues(Sender: TObject);
begin
Zeichnevergr(UrsprungG,EndpunktG);
end;

procedure TWindrose.FormActivate(Sender: TObject);
begin
//Werte:= 0;
Windrose.Caption:= 'Windrose für '  +
  Kursberechnung.UrOrt.Caption+'  '+Kursberechnung.UrBreite.Caption+' / '
  +Kursberechnung.UrLaenge.Caption;
{Kursberechnung.Orte.First;
While not Kursberechnung.Orte.Eof do
      Begin
      Werte:= Werte + 1;
      Gradfeld[1,Werte]:= Kursberechnung.Orte['g'];
      If Kursberechnung.Orte['x'] = 'ü'
         Then Gradfeld[2,Werte]:= 1
         Else Gradfeld[2,Werte]:= 0;
      Ortfeld[Werte]:= Kursberechnung.Orte['Ort'];
      Kursberechnung.Orte.Next;
      End;
Kursberechnung.Orte.Locate('Ort',Kursberechnung.AktuOrt, []); }
Chart1.Refresh;
end;

procedure TWindrose.Series2AfterDrawValues(Sender: TObject);
Var i, Code: Integer;
    s: String;
    Grad: real;

Begin
With Chart2.Canvas do
     Begin
     brush.color := clWhite;
     Pen.Color:= clblack;
     FillRect (Rect (0, 0, Round(Breite * z)-1+2*Rand, Round(Breite * z)-1+ 2*Rand));
     Ellipse(Round(Abstand1*z) + Rand, Round(Abstand1*z) + Rand,
             Round((Breite - Abstand1)*z) + Rand, Round((Breite - Abstand1)*z) + Rand) ;
     Font.Name:= 'Arial';
     Font.Color:= clBlack;
     Font.Height:=-20;
     Pen.Width:=1;
     End;
For i:=1 to 360 do
    With Stift2 do
         Begin
         Hoch;
         BewegeBis(Breite/2*z + Rand, Breite/2*z + Rand);
         DreheBis(i);
         BewegeUm((Breite/2 - Abstand2)*z);
         Runter;
         BewegeUm(Abstand1*z);
         End;
For i:=1 to Kursberechnung.Tabelle.RowCount - 1 do
    If Kursberechnung.Tabelle.Cells[13,i] = Auswahl   // wert von 'ü'
       Then Begin
            Val (Kursberechnung.Komma(Kursberechnung.Tabelle.Cells [12, i]), Grad, Code);
            If code = 0
               Then With Stift2 do
                         Begin
                         Hoch;
                         BewegeBis(Breite/2*z + Rand, Breite/2*z + Rand);
                         DreheBis(Grad);
                         Runter;
                         BewegeUm(Breite/2*z);
                         Pfeil(30);
                         DreheBis(Grad);
                         Str(Grad:0:2 , s);
                         Schreibe(Breite/2*z + Rand, Breite/2*z + Rand, (Breite/2 - Abstand2 - 5)*z,
                                  Grad, (Kursberechnung.Tabelle.Cells[1, i] + ' ' + s + '°'));
                         End;
            End;
end;

procedure TWindrose.FormCreate(Sender: TObject);
begin
Stift1:= TStiftWindr2.Create;
Stift1.Init(chart1.Canvas);
Series1.FillSampleValues(20);
Stift2:= TStiftWindr2.Create;
Stift2.Init(chart2.Canvas);
Series2.FillSampleValues(20);
Malen:= False;
Verschieben:= False;
Zoomen:= False;
Ausschnitt:= False;
UrsprungG:= Point(0,0);
EndpunktG:= Point(Breite, Breite);
MausRunter:= Point(0,0);
end;

procedure TWindrose.Chart1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
If Button = mbRight
  Then
  Begin
  If Malen
     Then Chart1.Canvas.Rectangle(MausRunter.x,MausRunter.y, x, y)
     Else
     Begin
     Verschieben:= True;
     UrsprungVorher:= UrsprungG;
     EndpunktVorher:= EndpunktG;
     End;
  Malen:= False;
  RKRunter:= Point(x,y);
  End;
If (Button = mbLeft) and (ssRight in Shift)
   Then
   Begin
   LKRunter:= Point(x,y);
   Verschieben:= False;
   Zoomen:= True;
   UrsprungVorher:= UrsprungG;
   EndpunktVorher:= EndpunktG;
   End;
If not (ssRight in Shift)
  Then
  begin
  Malen:= True;
  MausRunter:= Point(x,y);
  Neuepos:= MausRunter;
  Chart1.Canvas.Brush.Style:= bsclear;
  Chart1.Canvas.Pen.Mode:= pmNotXor;
  Chart1.Canvas.Pen.Style:= psDot;
  End;
end;

procedure TWindrose.Chart1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
Var dx, dy, ux: Integer;
begin
IF Malen
   Then
   Begin
   Ausschnitt:= True;
   Chart1.Canvas.Rectangle(MausRunter.x,MausRunter.y, Neuepos.x, Neuepos.y);
   Neuepos:= Point(x,y);
   Chart1.Canvas.Rectangle(MausRunter.x,MausRunter.y, Neuepos.x, Neuepos.y);
   End;
If Verschieben
   Then
   Begin
   dx:= RKRunter.x - x;
   dy:= RKRunter.y - y;
   UrsprungG.x:= UrsprungVorher.x - dx;
   UrsprungG.y:= UrsprungVorher.y - dy;
   EndPunktG.x:= EndpunktVorher.x - dx;
   EndPunktG.y:= EndpunktVorher.y - dy;
   Zeichnevergr(UrsprungG, EndpunktG);
   End;
If Zoomen and (ssLeft in Shift)
   Then
   Begin
   ux:= y - LKRunter.y;
   If EndPunktG.x - UrsprungG.x > EndPunktG.y - UrsprungG.y
     Then EndPunktG.y:= UrsprungG.y + (EndPunktG.x - UrsprungG.x)
     Else EndPunktG.x:= UrsprungG.x + (EndPunktG.y - UrsprungG.y);
   If ((EndpunktVorher.x + ux) - (UrsprungVorher.x - ux)) <> 0
       Then
       If ((EndpunktG.x - UrsprungG.x)/((EndpunktVorher.x + ux) - (UrsprungVorher.x - ux)))>0
          Then
          Begin
          UrsprungG.x:= UrsprungVorher.x - ux;
          UrsprungG.y:= UrsprungVorher.y - ux;
          EndpunktG.x:= EndpunktVorher.x + ux;
          EndpunktG.y:= EndpunktVorher.y + ux;
          Zeichnevergr(UrsprungG, EndpunktG);
          End
   End;
end;

procedure TWindrose.Chart1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
If Button = mbRight
   Then
   Begin
   Ausschnitt:= False;
   End;
Verschieben:= False;
Zoomen:= False;
If Ausschnitt
   Then
   Begin
   UrsprungG:= Point(Round(MausRunter.x/Verhaeltnis + UrsprungG.x),
                     Round(MausRunter.y/Verhaeltnis + UrsprungG.y));
   EndpunktG:= Point(Round(EndpunktG.x - (Breite - x)/Verhaeltnis),
                     Round(EndpunktG.y - (Breite - y)/Verhaeltnis));
   Chart1.Canvas.Rectangle(MausRunter.x,MausRunter.y, x, y);
   Zeichnevergr(UrsprungG, EndpunktG);
   Ausschnitt:= False;
   End;
Malen:= False;
Chart1.Refresh;
end;

procedure TWindrose.gesamteWindrose1Click(Sender: TObject);
begin
Chart2.Refresh;
Printer.Orientation:= poPortrait;
Printer.BeginDoc;
 Try
  With Printer.Canvas do
     begin
     Font.Name:= 'MS Sans Serif';
     Font.Size:= 12;
     Font.Style:= [];
     TextOut((Printer.PageWidth - TextWidth(Caption)) Div 2,
              Printer.PageWidth + 60, Caption);
     Chart2.Printpartial(Rect(0, 0, Printer.PageWidth - 1, Printer.PageWidth - 1));
     end;
 Finally
 Printer.EndDoc;
 End;
end;

procedure TWindrose.Fensterausschnitt1Click(Sender: TObject);
begin
Chart1.Refresh;
Chart1.Draw(Image1.Canvas, Rect(0,0, 500, 500));//Rect wird bewirkt nichts!
Printer.Orientation:= poPortrait;
Printer.BeginDoc;
 Try
  With Printer.Canvas do
   begin
     Font.Name:= 'MS Sans Serif';
     Font.Size:= 12;
     Font.Style:= [];
     TextOut((Printer.PageWidth - TextWidth('Fensterausschnitt der ' + Caption)) Div 2,
              Printer.PageHeight Div 20, 'Fensterausschnitt der ' + Caption);
     StretchDraw(Rect((Printer.PageWidth - 1000) Div 2, Printer.PageHeight Div 20 + 200,
     (Printer.PageWidth - 1000) Div 2 + 1000, Printer.PageHeight Div 20 + 1200), Image1.Picture.Graphic);
   end;
 Finally
 Printer.EndDoc;
 End;
end;

procedure TWindrose.Einszueins1Click(Sender: TObject);
begin
UrsprungG:= Point(0,0);
EndpunktG:= Point(Breite, Breite);
Zeichnevergr(UrsprungG, EndpunktG);
end;

procedure TWindrose.Zoominfo1Click(Sender: TObject);
begin
Chart1.Refresh;
Zoominfo.Show;
end;

procedure TWindrose.FormHide(Sender: TObject);
begin
Zoominfo.Hide;
end;

procedure TWindrose.Fensterausschnitt2Click(Sender: TObject);
begin
Chart1.CopyToClipboardBitmap;
end;

procedure TWindrose.N2Click(Sender: TObject);
begin
Clipboard.Clear;
end;

procedure TWindrose.Druckereinstellungen1Click(Sender: TObject);
begin
PrinterSetupDialog1.Execute;
end;

end.

