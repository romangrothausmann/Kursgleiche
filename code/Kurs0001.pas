unit Kurs001;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBTables, Math, Db, Menus, Grids, DBGrids, StdCtrls, ExtCtrls, Bde;

Const cMaxWerte = 500;
      Winkel = 1;
      Indexdatei = 'KursindexDBF.mdx';
      Haken = 'ü';

type
  TKursberechnung = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    Image2: TImage;
    StaticText1: TStaticText;
    Tabelle: TDBGrid;
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
    Orteverteiler: TDataSource;
    Orte: TTable;
    UrOrt: TLabel;
    UrBreite: TLabel;
    UrLaenge: TLabel;
    Neu1: TMenuItem;
    Orteinfgen1: TMenuItem;
    Suchen1: TMenuItem;
    N3: TMenuItem;
    Label3: TLabel;
    Schlieen1: TMenuItem;
    Kopierer: TBatchMove;
    Kopierte: TTable;
    procedure TabelleCellClick(Column: TColumn);
    procedure Drucken1Click(Sender: TObject);
    procedure Beenden1Click(Sender: TObject);
    procedure OrteAfterOpen(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
    procedure Kurswinkelberechnen1Click(Sender: TObject);
    procedure TabelleDblClick(Sender: TObject);
    procedure FilternClick(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Windroseerstellen1Click(Sender: TObject);
    procedure TabelleTitleClick(Column: TColumn);
    procedure Eingabeinfo1Click(Sender: TObject);
    procedure Orteinfgen1Click(Sender: TObject);
    procedure Suchen1Click(Sender: TObject);
    procedure Neu1Click(Sender: TObject);
    procedure ffnen1Click(Sender: TObject);
    procedure Speichern1Click(Sender: TObject);
    procedure OrteAfterPost(DataSet: TDataSet);
    procedure OrteAfterDelete(DataSet: TDataSet);
    procedure Schlieen1Click(Sender: TObject);
    procedure OrteAfterClose(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
  private
    Doppelklick: Boolean;
    Spaltenummer: Integer;
  public
    AktuOrt: String;
  end;

var
  Kursberechnung: TKursberechnung;

implementation

uses Kurs0002, Kurs0003, Kurs0004, Kurs0005, Kurs0007, Kurs0008, Kurs0009;

{$R *.DFM}

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
Begin
Result:= (ArcCos ( cos (h / 180 * pi)
                * cos (n / 180 * pi)
                + sin (h / 180 * pi)
                * sin (n / 180 * pi)
                * cos (Lm / 180 * pi)))
                * 180 / pi;
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

Procedure AddMdx(FileName: DbiTblName; IndexName: DbiName; Des: Boolean;
                 Fieldnumber: Integer; Tbl: TTable);
Var NewIndex: IDXDesc;
Begin
{Tbl.Active:= False;
Tbl.Exclusive:= true;
Tbl.Active:= True; }
With NewIndex do
    Begin
    szName:= FileName;
    szTagName:= IndexName;
    bPrimary := False;
    bUnique := False;
    bDescending := Des;
    bMaintained := False;
    bSubset:= False;//????
    bExpIdx := False;
    bCaseInsensitive:= False;
    iFldsInKey := 1;
    iBlockSize:= 0;//Muss auf Null gesetzt werden!!!
    //iRestrNum:= 1;
    //iUnUsed[16]:= 1000;
    //iIndexId:= 1;
    aiKeyFld[0] := Fieldnumber;
    szKeyExp := '';   // Although this is not an Expression index,
    szKeyCond := '';  // szKeyExp and szKeyCond must be set blank
    End;
Check(DbiAddIndex(Tbl.dbhandle, nil{Tbl.handle}, PChar(Tbl.TableName),
      szDBASE, NewIndex, nil));
End;

Procedure Indizeserstellen;
Begin
AddMdx(Indexdatei, 'Orti', False, 1, Kursberechnung.Orte);
AddMdx(Indexdatei, 'Orta', True, 1, Kursberechnung.Orte);
AddMdx(Indexdatei, 'Landi', False, 4, Kursberechnung.Orte);
AddMdx(Indexdatei, 'Landa', True, 4, Kursberechnung.Orte);
AddMdx(Indexdatei, 'Lati', False, 14, Kursberechnung.Orte);
AddMdx(Indexdatei, 'Lata', True, 14, Kursberechnung.Orte);
AddMdx(Indexdatei, 'Loni', False, 15, Kursberechnung.Orte);
AddMdx(Indexdatei, 'Lona', True, 15, Kursberechnung.Orte);
AddMdx(Indexdatei, 'DLoni', False, 16, Kursberechnung.Orte);
AddMdx(Indexdatei, 'DLona', True, 16, Kursberechnung.Orte);
AddMdx(Indexdatei, 'ei', False, 17, Kursberechnung.Orte);
AddMdx(Indexdatei, 'ea', True, 17, Kursberechnung.Orte);
AddMdx(Indexdatei, 'ai', False, 19, Kursberechnung.Orte);
AddMdx(Indexdatei, 'aa', True, 19, Kursberechnung.Orte);
AddMdx(Indexdatei, 'gi', False, 20, Kursberechnung.Orte);
AddMdx(Indexdatei, 'ga', True, 20, Kursberechnung.Orte);
End;


Procedure TabelleErzeugen(Dateiname: String; Typ: TTableType; Var Tbl: TTable);
Begin
With Tbl Do
     Begin
     Close;
     Indexdefs.Clear;
     IndexName:= '';
     IndexFiles.Clear;
     TableName:= Dateiname;
     TableType:= Typ;
     With FieldDefs do
          Begin
          Clear;
          Add('Ort', ftString, 100, True);
          Add('Breite', ftString, 100, False);
          Add('Laenge', ftString, 100, False);
          Add('Land', ftString, 100, False);
          Add('Besonderheit', ftString, 100, False);
          Add('Lats', ftString, 10, False);
          Add('Lons', ftString, 10, False);
          Add('DLons', ftString, 10, False);
          Add('Dists', ftString, 10, False);
          Add('Distkms', ftString, 10, False);
          Add('Alphas', ftString, 10, False);
          Add('Kurss', ftString, 10, False);
          Add('x', ftString, 1, False);
          Add('Lat', ftFloat, 0, False);
          Add('Lon', ftFloat, 0, False);
          Add('DLon', ftFloat, 0, False);
          Add('e', ftFloat, 0, False);
          Add('ekm', ftFloat, 0, False);
          Add('a', ftFloat, 0, False);
          Add('g', ftFloat, 0, False);
          End;
     CreateTable;
     End;
End;

Procedure CsvTabelleErzeugen(Dateiname: String);
Var CsvDatei: Textfile;
    i: Integer;

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
Kursberechnung.Orte.First;
For i:= 0 to Kursberechnung.Tabelle.Columns.Count - 2 Do
    Write(CsvDatei, Kursberechnung.Tabelle.Columns[i].Title.Caption + ';');
WriteLn(CsvDatei);
While not Kursberechnung.Orte.Eof do
      Begin
      WriteLn(CsvDatei, Pruefe(Kursberechnung.Orte.FieldbyName('Ort').asString),
                        Pruefe(Kursberechnung.Orte.FieldbyName('Breite').asString),
                        Pruefe(Kursberechnung.Orte.FieldbyName('Laenge').asString),
                        Pruefe(Kursberechnung.Orte.FieldbyName('Land').asString),
                        Pruefe(Kursberechnung.Orte.FieldbyName('Besonderheit').asString),
                        Pruefe(Kursberechnung.Orte.FieldbyName('Lats').asString),
                        Pruefe(Kursberechnung.Orte.FieldbyName('Lons').asString),
                        Pruefe(Kursberechnung.Orte.FieldbyName('DLons').asString),
                        Pruefe(Kursberechnung.Orte.FieldbyName('Dists').asString),
                        Pruefe(Kursberechnung.Orte.FieldbyName('Distkms').asString),
                        Pruefe(Kursberechnung.Orte.FieldbyName('Alphas').asString),
                        Pruefe(Kursberechnung.Orte.FieldbyName('Kurss').asString));
      Kursberechnung.Orte.Next;
      End;
CloseFile(CsvDatei);
Kursberechnung.Orte.Locate('Ort', AktuOrt, []);
End;

Function Punkt(s: String): String;
Begin
s[Pos('.',s)]:= ',';
Result:= s;
End;

Procedure CSVOffnen(DateiName, TblName: String);
Var tf: TextFile;
 Function LeseWert: String;
 Var c: String[1];
     v: String;
 Begin
 c:= '';
 v:= '';
 Repeat
 v:= v + c;
 Read(tf, c);
 Until (c = ';');
 Result:= v;
 End;

Begin
TabelleErzeugen(TblName, TTDBase, Kursberechnung.Orte);
Assignfile(tf, DateiName);
Reset(tf);
With Kursberechnung Do
      Begin
      Orte.Exclusive:= True;
      Orte.Open;
      ReadLn(tf);
      While not Eof(tf) Do
            begin
            Orte.AppendRecord([LeseWert, LeseWert, LeseWert, LeseWert, LeseWert]);//Ort, Breite, Laenge, Land, Besonderheit]);
            ReadLn(tf);
            End;
      End;
CloseFile(tf);
Kursberechnung.Kurswinkelberechnen1.Click;
End;



procedure TKursberechnung.TabelleCellClick(Column: TColumn);
begin
AktuOrt:= Orte['Ort'];
Spaltenummer:= Column.Index;
IF (Column.Index = 0) and (Doppelklick)
  Then
  Begin
  UrOrt.Caption:= Orte.FieldbyName('Ort').asString;
  UrBreite.Caption:= Orte.FieldbyName('Breite').asString;
  UrLaenge.Caption:= Orte.FieldbyName('Laenge').asString;
  Kursberechnung.Kurswinkelberechnen1.Click;
  {Orte.Edit;
  Orte['x']:= '';
  Orte.Post;}
  Doppelklick:= False;
  End;
IF Column.Index = 12
  Then Begin
       Orte.Edit;
       If Orte['x'] = Haken
          Then Orte['x']:= ''
          Else Orte['x']:= Haken;
       Orte.Post;
       End;
end;

procedure TKursberechnung.Drucken1Click(Sender: TObject);
begin
Vorschau.Titel.Caption:= 'Ortsdaten für ' +
  UrOrt.Caption+'  '+UrBreite.Caption+' / '+UrLaenge.Caption;
Vorschau.QuickRep1.Preview;
Orte.Locate('Ort', AktuOrt, []);
end;

procedure TKursberechnung.Beenden1Click(Sender: TObject);
begin
Close;
end;

procedure TKursberechnung.OrteAfterOpen(DataSet: TDataSet);
Var i: integer;
begin
If not Fileexists(ExtractFilePath(Offnen.filename) + Indexdatei)
   Then Indizeserstellen;
//Check(DbiRegenIndexes(Kursberechnung.Orte.Handle));//Das bringt nichts!?
Speichern1.Enabled:= True;
Drucken1.Enabled:= True;
Suchen1.Enabled:= True;
If Orte.TableType = ttDbase
   Then Begin
        For i:= 1 to 16 Do
            Check(DbiRegenIndex(orte.DBHandle, nil, PChar(Orte.TableName), szDBASE,
            PChar(IndexDatei), nil, i));//Aktualisiert den Index!!!
        Orte.IndexFiles.Add(Indexdatei);
        Orte.IndexName:= 'Orti';
        Kurswinkelberechnen1.Enabled:= True;
        Windroseerstellen1.Enabled:= True;
        Filtern.Enabled:= True;
        Orteinfgen1.Enabled:= True;
        End
   Else ShowMessage('Es können nur Tabellen vom Typ *.krs oder *.dbf sortiert werden!');
Label3.Caption:= Format('Die Tabelle enthält %d Einträge', [Orte.RecordCount]);
Orte.Locate('Ort','Dahlhausen',[]);
UrOrt.Caption:= Orte.FieldbyName('Ort').asString;
UrBreite.Caption:= Orte.FieldbyName('Breite').asString;
UrLaenge.Caption:= Orte.FieldbyName('Laenge').asString;
Kursberechnung.Caption:= 'Kursberechnung [' + ExtractFileName(Orte.TableName) + ']';
If Orte.RecordCount > 0
   Then Begin
   AktuOrt:= Orte['Ort'];
   Kursberechnung.Kurswinkelberechnen1.Click;
   End;
end;

procedure TKursberechnung.FormShow(Sender: TObject);
begin
Film.ShowModal;
end;

procedure TKursberechnung.Kurswinkelberechnen1Click(Sender: TObject);
Var UrBreiteR, UrLaengeR, h, n: Real;
    t: String;
begin
If UrBreite.Caption = ''
   then ShowMessage('Um die Berechnung ausführen zu können, müssen Sie erst'
                    + ' einen Urort festlegen! Klicken Sie dazu auf einen Ort in der Tabelle doppelt.')
   Else Begin
        UrBreiteR:= Umrechnen (UrBreite.Caption);
        UrLaengeR:= Umrechnen (UrLaenge.Caption);
        Orte.First;
        While not Orte.Eof do
              Begin
              Orte.Edit;
              h:= 90 - UrBreiteR;
              Orte['Lat']:= Umrechnen (Orte.FieldbyName('Breite').asString);//Breite
              n:= 90 - Orte['Lat'];
              Orte['Lon']:= Umrechnen (Orte.FieldbyName('Laenge').asString);// Laenge
              Orte['DLon']:= BerechneLm (UrLaengeR, Orte['Lon']);//Lm
              Orte['e']:= BerechneE (h, n, Orte['DLon']);//e
              Orte['ekm']:= ((BerechneE (h, n, Orte['DLon'])) * 40075)/360;//e2
              Orte['a']:= berechneA (Orte['e'], n, Orte['DLon'], h);//a
              Orte['g']:= berechneG (Orte['DLon'], Orte['a'], h, UrLaengeR, Orte['Lon']);//g
              Orte['x']:= Haken;
              Str(Orte['Lat']:5:4, t);
              Orte['Lats']:= Punkt(t);
              Str(Orte['Lon']:5:4, t);
              Orte['Lons']:= Punkt(t);
              Str(Orte['DLon']:5:4, t);
              Orte['DLons']:= Punkt(t);
              Str(Orte['e']:5:4, t);
              Orte['Dists']:= Punkt(t);
              Str(Orte['ekm']:5:4, t);
              Orte['Distkms']:= Punkt(t);
              Str(Orte['a']:5:4, t);
              Orte['Alphas']:= Punkt(t);
              Str(Orte['g']:5:4, t);
              Orte['Kurss']:= Punkt(t);
              Orte.Post;
              Orte.Next;
              End;
        Orte.Locate('Ort', UrOrt.Caption, []);
        Orte.Edit;
        Orte['x']:= '';
        Orte.Post;
        Orte.Locate('Ort', AktuOrt, []);
        End;
end;

procedure TKursberechnung.TabelleDblClick(Sender: TObject);
begin
If Spaltenummer = 0
   Then Doppelklick:= True;
end;

procedure TKursberechnung.FilternClick(Sender: TObject);
Var Gradfeld: Array [1..cMaxWerte] of Real;
    i, j, k: Integer;
begin
k:= 0;
i:= 0;
Orte.First;
While not Orte.Eof do
      Begin
      k:= k + 1;
      Gradfeld[k]:= Orte['g'];
      Orte.Next;
      End;
Orte.First;
While not Orte.Eof do
      Begin
      i:= i + 1;
      If Orte['x'] = Haken
         Then For j:= 1 to k do
              If (i <> j) And (Gradfeld[i]<=Gradfeld[j]) and (Gradfeld[j]<Gradfeld[i]+Winkel)
                 Then Gradfeld[j]:= 1000;
      Orte.Next;
      End;
i:= 0;
Orte.First;
While not Orte.Eof do
      Begin
      i:= i + 1;
      If Gradfeld[i] = 1000
         Then Begin
              Orte.Edit;
              Orte['x']:= '';
              Orte.Post;
              End;
      Orte.Next;
      End;
Orte.Locate('Ort', AktuOrt, []);
end;

procedure TKursberechnung.Image2Click(Sender: TObject);
begin
Bild.show;
end;

procedure TKursberechnung.Windroseerstellen1Click(Sender: TObject);
begin
Windrose.Caption:= 'Windrose für '  +
  UrOrt.Caption+'  '+UrBreite.Caption+' / '+UrLaenge.Caption;
Windrose.Show;
end;

procedure TKursberechnung.TabelleTitleClick(Column: TColumn);
begin
Doppelklick:= False;
Spaltenummer:= 1;
If Orte.TableType = ttDbase
   Then Case Column.Index of
             0: If Orte.IndexName = 'Orti'
                   Then Orte.IndexName:= 'Orta'
                   Else Orte.IndexName:= 'Orti';
             1: If Orte.IndexName = 'Lati'
                   Then Orte.IndexName:= 'Lata'
                   Else Orte.IndexName:= 'Lati';
             2: If Orte.IndexName = 'Loni'
                   Then Orte.IndexName:= 'Lona'
                   Else Orte.IndexName:= 'Loni';
             3: If Orte.IndexName = 'Landi'
                   Then Orte.IndexName:= 'Landa'
                   Else Orte.IndexName:= 'Landi';
             5: If Orte.IndexName = 'Lati'
                   Then Orte.IndexName:= 'Lata'
                   Else Orte.IndexName:= 'Lati';
             6: If Orte.IndexName = 'Loni'
                   Then Orte.IndexName:= 'Lona'
                   Else Orte.IndexName:= 'Loni';
             7: If Orte.IndexName = 'DLoni'
                   Then Orte.IndexName:= 'DLona'
                   Else Orte.IndexName:= 'DLoni';
             8: If Orte.IndexName = 'ei'
                   Then Orte.IndexName:= 'ea'
                   Else Orte.IndexName:= 'ei';
             9: If Orte.IndexName = 'ei'
                   Then Orte.IndexName:= 'ea'
                   Else Orte.IndexName:= 'ei';
            10: If Orte.IndexName = 'ai'
                   Then Orte.IndexName:= 'aa'
                   Else Orte.IndexName:= 'ai';
            11: If Orte.IndexName = 'gi'
                   Then Orte.IndexName:= 'ga'
                   Else Orte.IndexName:= 'gi';
             End
   Else ShowMessage('Es können nur Tabellen vom Typ *.krs oder *.dbf sortiert werden!');
end;

procedure TKursberechnung.Eingabeinfo1Click(Sender: TObject);
begin
Programminfo.ShowModal;
end;

procedure TKursberechnung.Orteinfgen1Click(Sender: TObject);
begin
Eintrag.ShowModal;
end;

procedure TKursberechnung.Suchen1Click(Sender: TObject);
begin
Sucheform.Show;
end;

procedure TKursberechnung.Neu1Click(Sender: TObject);
begin
Speichern.Title:= 'Tabelle erstellen';
Speichern.FilterIndex:= 1;
Speichern.Filter:= 'Kurs Dateien (*.krs)|*.krs|Dbase  Dateien (*.dbf)|*.dbf|Alle Dateien (*.*)|*.*';
If Speichern.Execute
   Then Begin
        If ExtractFileExt(Speichern.FileName) = ''
           Then If Speichern.FilterIndex = 1
                   Then Speichern.FileName:= Speichern.FileName + '.krs'
                   Else Speichern.FileName:= Speichern.FileName + '.dbf';
        If Fileexists(Speichern.FileName)
           Then If MessageDlg('Die Datei existiert bereits! Datei überschreiben?',
                   mtConfirmation, [mbYes, mbNo], 0) = mrNo
                   Then Exit;
        TabelleErzeugen(Speichern.FileName, ttDBase, Orte);
        Orte.Exclusive:= True;
        Orte.Open;
        End;
end;

procedure TKursberechnung.ffnen1Click(Sender: TObject);
Var s: String;
begin
Offnen.Title:= 'Tabelle öffnen';
If Offnen.Execute
  Then Begin
       With Orte do
           Begin
           Close;
           Exclusive:= False;
           Indexdefs.Clear;
           IndexName:= '';
           IndexFiles.Clear;
           TableType:= ttDBase;
           If ExtractFileExt(Offnen.FileName) = ''
              Then Case Offnen.FilterIndex Of
                         1: Offnen.FileName:= Offnen.FileName + '.krs';
                         2: Offnen.FileName:= Offnen.FileName + '.dbf';
                         3: Offnen.FileName:= Offnen.FileName + '.csv';
                         4: Offnen.FileName:= Offnen.FileName + '.txt';
                         5: Offnen.FileName:= Offnen.FileName + '.dbf';
                         End;
           If ExtractFileExt(Offnen.FileName) = '.txt'
              Then TableType:= ttASCII;
           End;
       If ExtractFileExt(Offnen.FileName) = '.csv'
          Then Begin
               ShowMessage('CSV-Dateien können nur durch Umschreiben in eine DBase-Datei geöffnet werden!');
               s:= Offnen.FileName;
               Delete(s, Pos('.', Offnen.FileName), 5);
               s:= s + '.krs';
               If FileExists(s)
                  Then If MessageDlg('Die Datei existiert bereits! Datei überschreiben?',
                          mtConfirmation, [mbYes, mbNo], 0) = mrNo
                          Then Exit;
               CSVOffnen(Offnen.FileName, s);
               Exit;
               End;
       Orte.TableName:= Offnen.FileName;
       Orte.Exclusive:= True;
       Orte.Open;
       End;
end;

procedure TKursberechnung.Speichern1Click(Sender: TObject);
Var Typ: TTableType;
begin
Typ:= ttDBase;
Speichern.Filter:= 'Kurs Dateien (*.krs)|*.krs|Dbase  Dateien (*.dbf)|*.dbf|' +
                   'CSV Dateien (*.csv)|*.csv|Textdateien (*.txt)|*.txt|Alle Dateien (*.*)|*.*';
If Speichern.Execute
   Then Begin
        If ExtractFileExt(Speichern.FileName) = '.csv'
           Then Typ:= ttASCII;
        If ExtractFileExt(Speichern.FileName) = '.txt'
           Then Typ:= ttASCII;
        If ExtractFileExt(Speichern.FileName) = ''
           Then Case Speichern.FilterIndex Of
                     1: Speichern.FileName:= Speichern.FileName + '.krs';
                     2: Speichern.FileName:= Speichern.FileName + '.dbf';
                     3: Begin
                        Speichern.FileName:= Speichern.FileName + '.csv';
                        Typ:= ttASCII;
                        End;
                     4: Begin
                        Speichern.FileName:= Speichern.FileName + '.txt';
                        Typ:= ttASCII;
                        End;
                     5: Speichern.FileName:= Speichern.FileName + '.dbf';
                     End;
        If FileExists(Speichern.FileName)
           Then If MessageDlg('Die Datei existiert bereits! Datei überschreiben?',
                   mtConfirmation, [mbYes, mbNo], 0) = mrNo
                   Then Exit;
        If ExtractFileExt(Speichern.FileName) = '.csv'
           Then CSVTabelleerzeugen(Speichern.FileName)
           Else Begin
                Tabelleerzeugen(Speichern.FileName, Typ, Kopierte);
                Kopierer.Execute;
                ShowMessage(IntToStr(Kopierer.MovedCount) + ' Datensätze kopiert');
                End;
        End;
end;


procedure TKursberechnung.OrteAfterPost(DataSet: TDataSet);
begin
label3.Caption:= Format('Die Tabelle enthält %d Einträge', [Orte.RecordCount]);
end;

procedure TKursberechnung.OrteAfterDelete(DataSet: TDataSet);
begin
label3.Caption:= Format('Die Tabelle enthält %d Einträge', [Orte.RecordCount]);
end;

procedure TKursberechnung.Schlieen1Click(Sender: TObject);
begin
Orte.Close;
end;

procedure TKursberechnung.OrteAfterClose(DataSet: TDataSet);
begin
Kursberechnung.Caption:= 'Kursberechnung';
Label3.Caption:= '';
Kurswinkelberechnen1.Enabled:= False;
Windroseerstellen1.Enabled:= False;
Speichern1.Enabled:= False;
Drucken1.Enabled:= False;
Filtern.Enabled:= False;
Orteinfgen1.Enabled:= False;
Suchen1.Enabled:= False;
UrOrt.Caption:= '';
UrBreite.Caption:= '';
UrLaenge.Caption:= '';
Orte.Exclusive:= False;
Orte.TableType:= ttDefault;
end;

procedure TKursberechnung.FormCreate(Sender: TObject);
begin
Image2.Picture.LoadFromFile('Kursdreieck3.bmp');
end;

End.
