unit Kurs0007;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TProgramminfo = class(TForm)
    RichEdit1: TRichEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Programminfo: TProgramminfo;

implementation

{$R *.DFM}

procedure TProgramminfo.FormCreate(Sender: TObject);
begin
With RichEdit1 do
     Begin
     Lines.Clear;
     SelAttributes.Style := [fsBold, fsUnderline];
     SelAttributes.Size:= 10;
     Lines.Add('Programm Kursgleiche');
     SelAttributes.Style := [];
     SelAttributes.Size:= 8;
     Lines.Add('');
     Lines.Add('Copyright © 4.8.2001 Roman Grothausmann, Version 3.04');
     Lines.Add('');
     Lines.Add('');
     Lines.Add('Dieses Programm berechnet den Kurswinkel vom Ursprungsort zu den'
              +' Orten, die in der Tabelle eingetragen sind. Der Kurswinkel ist'
              +' der Winkel, der die Himmelsrichtung angibt, in die man sich vom Urs'
              +'prungsort bewegen müsste, um am Zielort anzukommen. Um einen '
              +'Ursprungsort festzulegen, doppelklicken Sie auf einen eingetragen'
              +'en Ortsnamen in der Tabelle. Falls Sie einen neuen Ort eintrage'
              +'n wollen, können Sie dies unter ''Bearbeiten'' ''Ort bearbeiten''. M'
              +'it den Pfeiltasten kann man die bisherigen Einträge durchgehen. '
              +'Die Plustaste fügt der Tabelle einen neuen leeren Datensatz ein, die Mi'
              +'nustaste löscht ihn wieder. Die Hakentaste überträgt die neuen E'
              +'ingaben in die Tabelle und speichert sie gleichzeitig ab, daher '
              +'gibt es keinen Menüpunkt ''Speichern''.');
     Lines.Add('');
     Lines.Add('In der ersten Spalte müssen die Namen der Orte eingegeben werden'
              +'. Die Spalte für die geographische Breite muss die Koordinaten f'
              +'ür die Breitengrade beinhalten, die Spalte für die geographische'
              +' Länge benötigt die Längenkoordinaten. Die Koordinaten können in'
              +' Grad, Minuten und Sekunden angegeben werden ( 56° 12'' 34" N ) '
              +'oder nur in Grad, Minuten oder Sekunden ( 56° N/ 3372'' N / 2023'
              +'54" N). Wenn die Himmelsrichtung nicht angegeben wird (N/S oder '
              +'O/W), dann wird für die Breite die Richtung Nord verwendet und '
              +'für die Länge Ost. Man kann deshalb auch die Koordinaten negativ'
              +' angeben, man muss dann aber vor jede Zahl ein Minuszeichen setz'
              +'en (-56°-12''-34"). Die Buchstaben N, S, O, W müssen als Großbuch'
              +'staben eingegeben werden, sonst werden sie nicht beachtet. Die Spalten Land und Besonderheiten haben fü'
              +'r die Berechnung keine Bedeutung.');
     Lines.Add('');
     Lines.Add('Um nach der Eingabe der Koordinaten die verschiedenen Kurswinkel'
              +' zu berechnen, muss man unter ''Kurs'' ''Kurswinkel berechnen'''
              +' klicken. Die ersten beiden neuen Spalten geben die Koordinaten '
              +'in realen Zahlen wieder, die nächste den Betrag der Differenz d'
              +'er Längen zum Ursprungsort, dann kommt die Distanz zwischen Ort'
              +' und Ursprungsort (in ° und km) und dann folgt der Winkel, der i'
              +'n die Richtung der kürzesten Entfernung zeigt (nur Werte von 0°'
              +'- 180°) und zuletzt der Winkel der Kursgleiche.');
     Lines.Add('');
     Lines.Add('Die Tabelle kann man nun unter ''Datei'' ausdrucken oder kopiere'
              +'n. Das Kopieren speichert die Datensätze der geöffneten Tabelle '
              +'in einer neuen Datei. Es stehen vier Dateitypen zum Speichern zu'
              +'r Verfügung. Kursdateien (*.krs), DBase-Dateien (*.dbf), CSV-Dat'
              +'eien (*.csv) und Textdateien (*.txt). Kursdateien und DBase-Date'
              +'ien sind vom Typ Visual dBASE7. Leider kann Excel diesen Typ nic'
              +'ht öffnen, dafür aber die CSV- und Textdateien. CSV- und Textdatei'
              +'en lassen sich auch mit diesem Programm öffnen und wieder in ein'
              +'en anderen Typ kopieren. Sie können allerdings nicht sortiert we'
              +'rden. Zum Sortieren erstellt das Programm eine von der DBase-Dat'
              +'ei unabhängige MDX-Datei (KursindexDBF.mdx), die im selben Verze'
              +'ichnis steht wie die Programmdatei (Kursgleiche0001.exe). Sie wird beim Schließen einer Tabelle wieder gelöscht '
              +'und beim Öffnen neu erstellt. Durch Klicken auf einen Spa'
              +'ltentitel kann man die gesamte Tabelle nach dieser Spalte sortie'
              +'ren lassen. Wenn man ein weiteres Mal auf den selben Titel klick'
              +'t, wird die Sortierung umgekehrt. Die beim Programmstart erstellte '
              +'Kursdatei (Unbenannt.krs) wird beim nächsten Programmstart überschrieben. '
              +'Eingetragene Daten gehen verloren, wenn sie nicht in eine andere Datei '
              +'kopiert wurden, oder die Datei (Unbenannt.krs) vor dem nächsten Start nicht umbenannt wurde.');
     Lines.Add('');
     Lines.Add('Will man eine Windrose mit Hilfe der Kurswinkel erstellen'
              +', so kann man dies mit ''Kurs'' ''Windrose erstellen''. Die'
              +'se Windrose kann man ausschnittsweise vergrößern und auch ausdru'
              +'cken. Im Windrosenfenster gibt es noch eine Zoominfo. Falls einige Orte zu eng '
              +'bei einander liegen, kann man sie in der Tabelle durch die Optio'
              +'n ''Bearbeiten'' ''Filtern'' herausfiltern oder per Hand auswähl'
              +'en, indem man in die letzte Spalte des entsprechenden Ortes klic'
              +'kt, in der der Haken ist. Wenn dann das Windrosenfenster aktivie'
              +'rt wird, werden nur die Orte gezeichnet, die einen Haken haben. '
              +'Um alle Orte mit einem Haken zu versehen, muss man die Kurswinkel '
              +'neu berechnen lassen. Zur graphischen Darstellung der Berechnung'
              +'en kann man auf das Bild im Hauptfenster klicken.');
     SelStart:= 500;
     End;
end;

end.
 