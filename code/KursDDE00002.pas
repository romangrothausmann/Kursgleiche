unit KursDDE00002;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Menus, StdCtrls, Printers, ComCtrls;

Const cBreite = 1000;
      Auswahl = 'ü';
      //cMaxFaktor = 900;
      cAnfFak = 65;
      cAbstand = 2;

type
  TDruckvorschau = class(TForm)
    MainMenu1: TMainMenu;
    Datei1: TMenuItem;
    Format1: TMenuItem;
    Zoom: TEdit;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Drucken1: TMenuItem;
    PrinterSetupDialog1: TPrinterSetupDialog;
    Blattanzahl: TLabel;
    Label3: TLabel;
    Eintstellungen1: TMenuItem;
    Neuzeichnen1: TMenuItem;
    ScrollBox1: TScrollBox;
    Blatt1: TImage;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    Hilfe1: TMenuItem;
    N1: TMenuItem;
    Drucken2: TMenuItem;
    procedure Edit1Change(Sender: TObject);
    procedure Drucken1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Eintstellungen1Click(Sender: TObject);
    procedure Neuzeichnen1Click(Sender: TObject);
    procedure ZoomKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure UpDown2Changing(Sender: TObject; var AllowChange: Boolean);
    procedure FormResize(Sender: TObject);
    procedure Hilfe1Click(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure Drucken2Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    DBlattAnz: Integer;
    Quer: Boolean;
    Procedure ExternDrucken;
    Function Grenzen(Anfang: Boolean; Blatt: Integer): Integer;
  end;

var
  Druckvorschau: TDruckvorschau;
  Faktor: Real;
  Blatt, BlattAnz: Byte;
  Spaltenbreite: Array [1..12] of Integer;
  ORand, URand, RRand, LRand, ATitel,
  ASpTitel, AEintr, RAEintrag, Size,
  Breite, Hoehe, yT, ySp, MarkierteEin,
  ANummern, CharSize, TitelSize: Integer;
  Bild: TImage;


implementation

uses KursDDE00001, KursDDE00008, KursDDE00010, KursDDE00011;



{$R *.lfm}



Procedure Spalten(Canvas: TCanvas);
Var ZeichenBreite, h , i: Integer;
Begin
CharSize:= 40;
Repeat
Dec(CharSize);
Canvas.Font.Size:= CharSize;
ZeichenBreite:= 0;
For h:= 1 to 5 do
    Begin
    SpaltenBreite[h]:= 0;
    For i:= 0 to Kursberechnung.Tabelle.RowCount - 1 do
        If SpaltenBreite[h] < Canvas.TextWidth(Kursberechnung.Tabelle.Cells[h, i])
           Then SpaltenBreite[h]:= Canvas.TextWidth(Kursberechnung.Tabelle.Cells[h, i]);
    End;
If SpaltenBreite[2] > SpaltenBreite[3]
   Then SpaltenBreite[3]:= Spaltenbreite[2]
   Else SpaltenBreite[2]:= Spaltenbreite[3];
For h:= 6 to 12 do
    SpaltenBreite[h]:= Canvas.TextWidth('99999,9999');
For h:= 1 to 12 do
    ZeichenBreite:= ZeichenBreite + spaltenBreite[h];
Until (((Breite - RRand - LRand) / (ZeichenBreite + 11 * RAEintrag)) >= 1) Or (CharSize = 1);
If (Breite - RRand - LRand) < (ZeichenBreite + 11 * RAEintrag)
   Then begin
        Faktor:= (ZeichenBreite + 11 * RAEintrag + RRand + LRand) / cBreite;
        Druckvorschau.Neuzeichnen1.Click;
        End
   Else RAEintrag:= (Breite - RRand - LRand - ZeichenBreite) Div 11;
End;

Procedure Titelgroessen(Canvas: TCanvas);
Begin
Canvas.Font.Size:= CharSize;
ySp:= Canvas.TextHeight('Sg');
TitelSize:= Canvas.Font.Height * Formatierung.TitelSize;
Canvas.Font.Height:= TitelSize;
yT:= Canvas.TextHeight('Sg');

End;

Function Blattanzahlermitteln: Integer;

  Function Blattanzahl (a: Integer):Integer;
  Var i, b: Integer;
  Begin
  i:= (Hoehe - ORand - URand - yT - ATitel - ySp - ASpTitel + AEintr) Div (ySp + AEintr);
  b:= 1;
  While i < MarkierteEin do
        Begin
        i:= i + a;
        Inc(b);
        End;
  Result:= b;
  End;

Begin
If Formatierung.ImmerTitel.Checked
   Then Begin
        If Formatierung.ImmerSpT.Checked
           Then Result:= Blattanzahl((Hoehe - ORand - URand - yT - ATitel - YSp
                                       - ASpTitel + Aeintr) Div (ySp + Aeintr))
           Else Result:= Blattanzahl((Hoehe - Orand - URand - yT - ATitel
                                       + AEintr) Div (ySp + Aeintr));
        End
   Else If Formatierung.ImmerSpT.Checked
           then Result:= Blattanzahl((Hoehe - ORand - URand - ySp - ASpTitel
                                       + AEintr) Div (ySp + Aeintr))
           Else Result:= Blattanzahl((Hoehe - ORand - URand + AEintr)
                                       Div (ySp + Aeintr));
End;

Function TDruckvorschau.Grenzen(Anfang: Boolean; Blatt: Integer): Integer;
Var AnzEinTuSpT, AnzEinT, AnzEinSpT, AnzEin: Integer;
Begin
AnzEinTuSpT:= (hoehe - ORand - URand - yT - ATitel - ySp - ASpTitel + Aeintr)
              Div (ySp + AEintr);
AnzEinT:= (Hoehe - ORand - URand - yT - ATitel + Aeintr) Div (ySp + Aeintr);
AnzEinSpT:= (Hoehe - ORand - URand - ySp - AspTitel + Aeintr) Div (ySp + AEintr);
AnzEin:= (Hoehe - ORand - URand + Aeintr) Div (ySp + Aeintr);
If Blatt = 1
   then Begin
        If anfang
           Then Result:= 1
           Else Result:= anzEinTuSpT;
        End
   Else If Formatierung.ImmerTitel.Checked
           Then Begin
                If Formatierung.ImmerSpT.Checked
                   Then Begin
                        If Anfang
                           Then Result:= AnzEinTuSpT + 1 + (blatt - 2) * AnzEinTuSpT
                           Else Result:= AnzEinTuSpT + (blatt - 1) * AnzEinTuSpT;
                        End
                   Else Begin
                        If anfang
                           Then Result:= AnzEinTuSpT + 1 + (blatt - 2) * AnzEinT
                           Else Result:= AnzEinTuSpT + (Blatt - 1) * AnzEinT;
                        End;
                End
           Else If Formatierung.ImmerSpT.Checked
                   Then Begin
                        If Anfang
                           Then Result:= AnzEinTuSpT + 1 + (Blatt - 2) * AnzEinSpT
                           Else Result:= AnzEinTuSpT + (Blatt - 1) * AnzEinSpT;
                        End
                   Else If anfang
                           Then Result:= AnzEinTuSpT + 1 + (Blatt - 2) * AnzEin
                           Else Result:= AnzEinTuSpT + (Blatt - 1) * AnzEin;
End;


Procedure ZeichneBlatt(Canvas: TCanvas);

   Procedure ZeichneTitel;
   begin
   Canvas.Font.Height:= TitelSize;
   Canvas.TextOut((Breite - LRand -RRand - Canvas.TextWidth('Ortsdaten für ' + Kursberechnung.UrOrt.Caption+
                   '  '+Kursberechnung.UrBreite.Caption+' / '+Kursberechnung.UrLaenge.Caption))
                   Div 2, ORand, 'Ortsdaten für ' + Kursberechnung.UrOrt.Caption+
                   '  '+Kursberechnung.UrBreite.Caption+' / '+Kursberechnung.UrLaenge.Caption);
   End;

   Procedure ZeichneSpT(y: Integer);
   Var xSp, i: Integer;
   Begin
   Canvas.Font.Size:= CharSize;
   Canvas.Pen.Width:= 2;
   xSp:= LRand;
   For i:= 1 to 12 do
       Begin
       If i in [1,4,5]
          then Canvas.textout(xSp + (SpaltenBreite[i]
                              - Canvas.TextWidth(Kursberechnung.Tabelle.Cells[i, 0]))
                              Div 2, y, Kursberechnung.Tabelle.Cells[i, 0])
          Else Canvas.textout(xSp + SpaltenBreite[i]
                              - Canvas.TextWidth(Kursberechnung.Tabelle.Cells[i, 0]),
                              y, Kursberechnung.Tabelle.Cells[i, 0]);
       Canvas.Polyline([Point(xSp, y + ySp + 2), Point(xSp + SpaltenBreite[i], y + ySp + 2)]);
       xSp:= xSp + SpaltenBreite[i] + RAEintrag;
       End;
   End;

   Procedure ZeichneEin(ZAnfang, ZEnde, y: Integer);
   var xSp, yZ, j, i, k: Integer;
   Begin
   Canvas.Font.Size:= CharSize;
   yZ:= y;
   k:= 0;
   j:= 0;
   Repeat
   Inc(k);
   If Kursberechnung.Tabelle.Cells[13, k] = Auswahl
      then Inc(j);
   Until (j >= ZAnfang) or (k >= Kursberechnung.Tabelle.RowCount - 1);
   dec(j);
   Repeat
   If Kursberechnung.Tabelle.Cells[13, k] = Auswahl
      Then Begin
           xSp:= LRand;
           If Formatierung.Nummern.Checked
              Then Canvas.TextOut((LRand - ANummern
                                  - Canvas.TextWidth(Kursberechnung.Tabelle.Cells[0, k])),
                                  yZ, Kursberechnung.Tabelle.Cells[0, k]);
           For i:= 1 to 12 do
               Begin
               If i in [1, 4, 5]
                  Then Canvas.TextOut(xSp {+ RAEintrag}, yZ,
                                      Kursberechnung.Tabelle.Cells[i, k])
                  Else Canvas.TextOut(xSp + SpaltenBreite[i]
                                      - Canvas.TextWidth(Kursberechnung.Tabelle.Cells[i, k]),
                                      yZ, Kursberechnung.Tabelle.Cells[i, k]);
               xSp:= xSp + SpaltenBreite[i] + RAEintrag;
               End;
           yZ:= yZ + ySp + Aeintr;
           Inc(j);
           End;
   Inc(k);
   Until (j >= Zende) or (k >= Kursberechnung.Tabelle.RowCount);// - 1);
   End;

Begin
Canvas.Brush.Style:= bsClear;
If Blatt = 1
   Then Begin
        ZeichneTitel;
        ZeichneSpT(ORand + yT + ATitel);
        ZeichneEin(1, Druckvorschau.Grenzen(False, Blatt), ORand + yT + ATitel + ySp + ASpTitel);
        End
   Else If Formatierung.ImmerTitel.Checked
           Then Begin
                If Formatierung.ImmerSpT.Checked
                   Then Begin
                        ZeichneTitel;
                        ZeichneSpT(ORand + yT + Atitel);
                        ZeichneEin(Druckvorschau.Grenzen(true, Blatt), Druckvorschau.Grenzen(False, Blatt),
                                   ORand + yT + ATitel + ySp + ASpTitel);
                        End
                   Else Begin
                        ZeichneTitel;
                        ZeichneEin(Druckvorschau.Grenzen(true, Blatt), Druckvorschau.Grenzen(False, Blatt),
                                   ORand + yT + ATitel);
                        End;
                End
           Else If Formatierung.ImmerSpT.Checked
                   Then Begin
                        ZeichneSpT(ORand);
                        ZeichneEin(Druckvorschau.Grenzen(true, Blatt), Druckvorschau.Grenzen(False, Blatt),
                                   ORand + ySp + ASpTitel);
                        End
                   Else ZeichneEin(Druckvorschau.Grenzen(true, Blatt), Druckvorschau.Grenzen(False, Blatt), ORand);
End;

Procedure Umrechnen;
Begin
ORand:= Round(Formatierung.ORand * Faktor);
URand:= Round(Formatierung.URand * Faktor);
LRand:= Round(Formatierung.LRand * Faktor);
RRand:= Round(Formatierung.RRand * Faktor);
ATitel:= Round(Formatierung.Atitel * Faktor);
ASpTitel:= Round(Formatierung.ASpTitel * Faktor);
AEintr:= Round(Formatierung.AEintr * Faktor);
RAEintrag:= Round(Formatierung.RAEintrag * Faktor);
ANummern:= Round(Formatierung.ANummern * Faktor);
End;

Procedure ZeichneBildschirm;
Begin
Screen.Cursor:= crHourGlass;
Try
  Druckvorschau.Blatt1.free;
Finally
  Druckvorschau.Blatt1:= TImage.Create(Druckvorschau.ScrollBox1);
  Druckvorschau.Blatt1.Parent := Druckvorschau.ScrollBox1;
  If Formatierung.Querformat.Checked
     Then Printer.Orientation:= poLandscape
     Else Printer.Orientation:= poPortrait;
  Druckvorschau.Blatt1.Width:= Round(cBreite * Faktor);
  Druckvorschau.Blatt1.Height:= Round((Printer.PageHeight / Printer.PageWidth * cBreite) * Faktor);
  Breite:= Druckvorschau.Blatt1.Width;
  Hoehe:= Druckvorschau.Blatt1.Height;
  If Druckvorschau.ScrollBox1.HorzScrollBar.IsScrollBarVisible//.Width < Breite
     Then Druckvorschau.Blatt1.Left:= 0
     Else Druckvorschau.Blatt1.Left:= (Druckvorschau.ScrollBox1.Width - Breite) div 2 - CAbstand;
  If Druckvorschau.ScrollBox1.VertScrollBar.IsScrollBarVisible//Height < Hoehe
     Then Druckvorschau.Blatt1.Top:= 0
     Else Druckvorschau.Blatt1.Top:= (Druckvorschau.ScrollBox1.Height - Hoehe) div 2 - CAbstand;
End;
Druckvorschau.Blatt1.Canvas.Brush.Color:= ClWhite;
Druckvorschau.Blatt1.Canvas.Font.Name:= Formatierung.schriften.Items[Formatierung.schriften.ItemIndex];
Druckvorschau.Blatt1.Canvas.FillRect(Rect(0, 0, Druckvorschau.Blatt1.Width, Druckvorschau.Blatt1.Height));
Umrechnen;
Spalten(Druckvorschau.Blatt1.Canvas);
Titelgroessen(Druckvorschau.Blatt1.Canvas);
BlattAnz:= Blattanzahlermitteln;
Druckvorschau.Blattanzahl.Caption:= IntToStr(BlattAnz);
Druckvorschau.UpDown1.Max:= BlattAnz;
If Blatt > Blattanz
   then blatt:= Blattanz;
If Blatt < 1
   Then Blatt:= 1;
Druckvorschau.Zoom.Text:= FloatToStr(Faktor * 100);
ZeichneBlatt(Druckvorschau.Blatt1.Canvas);
Druckvorschau.Edit1.Text:= IntToStr(Blatt);
Screen.Cursor:= crDefault;
End;

Procedure Drucken;
Begin
With Printer do
     Begin
     Hoehe:= PageHeight;
     Breite:= PageWidth;
     Faktor:= Breite / cBreite;
     Umrechnen;
     Spalten(Printer.Canvas);
     Titelgroessen(Printer.Canvas);
     Druckvorschau.DBlattAnz:= Blattanzahlermitteln;
     End;
End;

Procedure TDruckvorschau.ExternDrucken;
Var i: Integer;
Begin
Screen.Cursor:= crHourGlass;
If Druckvorschau.Quer
   Then Printer.Orientation:= poLandscape
   Else Printer.Orientation:= poPortrait;
Drucken;
Screen.Cursor:= crDefault;
For i:= 1 to Druckvorschau.DBlattAnz do
    Begin
    Blatt:= i;
    Printer.BeginDoc;
    ZeichneBlatt(Printer.Canvas);
    Printer.EndDoc;
    End;
Faktor:= cAnfFak / 100;
End;

procedure TDruckvorschau.Edit1Change(Sender: TObject);
Var Code: Integer;
begin
Val(Edit1.Text, Blatt, Code);
ZeichneBildschirm;
end;

procedure TDruckvorschau.Drucken1Click(Sender: TObject);
begin
PrinterSetupDialog1.Execute
end;

procedure TDruckvorschau.FormCreate(Sender: TObject);
Var Code: Integer;
begin
Faktor:= cAnfFak / 100;
Val(Formatierung.Edit1.Text, Formatierung.ORand, Code);
Val(Formatierung.Edit2.Text, Formatierung.URand, Code);
Val(Formatierung.Edit3.Text, Formatierung.RRand, Code);
Val(Formatierung.Edit4.Text, Formatierung.LRand, Code);
Val(Formatierung.Edit5.Text, Formatierung.ATitel, Code);
Val(Formatierung.Edit6.Text, Formatierung.ASpTitel, Code);
Val(Formatierung.Edit7.Text, Formatierung.Aeintr, Code);
Val(Formatierung.Edit8.Text, Formatierung.RAEintrag, Code);
Val(Formatierung.Edit9.Text, Formatierung.ANummern, Code);
Val(Formatierung.Edit10.Text, Formatierung.TitelSize, Code);
end;

procedure TDruckvorschau.FormActivate(Sender: TObject);
Var i: Integer;
begin
MarkierteEin:= 0;
For i:= 1 to Kursberechnung.Tabelle.RowCount - 1 do
    If Kursberechnung.Tabelle.Cells[13, i] = Auswahl
       then Inc(MarkierteEin);
ZeichneBildschirm;
end;

procedure TDruckvorschau.Eintstellungen1Click(Sender: TObject);
begin
Formatierung.ShowModal;
ZeichneBildschirm;
end;

procedure TDruckvorschau.Neuzeichnen1Click(Sender: TObject);
begin
ZeichneBildschirm;
end;

procedure TDruckvorschau.ZoomKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
Var Code: Integer;
    r: Integer;
begin
If (Key = 13)
   Then Begin
        Blatt:= 1;
        Val(Zoom.Text, r, Code);
        If Code <> 0
           then r:= cAnfFak;
        If (r > 0)
           Then Begin
                Faktor:= r / 100;
                Try ZeichneBildschirm;
                Except ShowMessage('Nicht genug Speicher vorhanden!');
                       Faktor:= cAnfFak / 100;
                       Zoom.Text:= FloatToStr(Faktor * 100);
                       ZeichneBildschirm;
                       End;
                End;
        End;
end;

procedure TDruckvorschau.UpDown2Changing(Sender: TObject;
  var AllowChange: Boolean);
Var Code: Integer;
    r: Integer;
begin
Blatt:= 1;
Val(Zoom.Text, r, Code);
If (r > 0)
   Then Begin
        Faktor:= r / 100;
        Try ZeichneBildschirm;
        Except AllowChange:= False;
               ShowMessage('Nicht genug Speicher vorhanden!');
               Faktor:= cAnfFak / 100;
               Zoom.Text:= FloatToStr(Faktor * 100);
               ZeichneBildschirm;
               End;
        End;
end;

procedure TDruckvorschau.FormResize(Sender: TObject);
begin
If Druckvorschau.ScrollBox1.HorzScrollBar.IsScrollBarVisible//Width < Breite
   Then Druckvorschau.Blatt1.Left:= 0
   Else Druckvorschau.Blatt1.Left:= (Druckvorschau.ScrollBox1.Width - Breite) div 2 - CAbstand;
If Druckvorschau.ScrollBox1.VertScrollBar.IsScrollBarVisible//Height < Hoehe
   Then Druckvorschau.Blatt1.Top:= 0
   Else Druckvorschau.Blatt1.Top:= (Druckvorschau.ScrollBox1.Height - Hoehe) div 2 - CAbstand;
end;

procedure TDruckvorschau.Hilfe1Click(Sender: TObject);
begin
Druckhilfe.Show;
end;

procedure TDruckvorschau.FormHide(Sender: TObject);
begin
Druckhilfe.Hide;
end;

procedure TDruckvorschau.Drucken2Click(Sender: TObject);
Var i, r, Code, Ublatt: Integer;
begin
Screen.Cursor:= crHourGlass;
Drucken;
Screen.Cursor:= crDefault;
If Druck.ShowModal = mrOk
   then Begin
        UBlatt:= Blatt;
        If Druck.CheckBox1.Checked
           then For i:= 1 to Druckvorschau.DBlattAnz do
                    Begin
                    Blatt:= i;
                    Printer.BeginDoc;
                    ZeichneBlatt(Printer.Canvas);
                    Printer.EndDoc;
                    End
           Else For i:= 0 to Druck.box.Items.Count - 1 do
                    If Druck.Box.Selected[i]
                       Then Begin
                            Blatt:= i + 1;
                            Printer.BeginDoc;
                            ZeichneBlatt(Printer.Canvas);
                            Printer.EndDoc;
                            End;
        Blatt:= UBlatt;
        End;
Val(Zoom.Text, r, Code);
        If Code <> 0
           then r:= cAnfFak;
        If (r > 0)
           Then Begin
                Faktor:= r / 100;
                ZeichneBildschirm;
                End;
end;

end.
