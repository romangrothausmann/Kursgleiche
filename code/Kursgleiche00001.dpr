program Kursgleiche0001;

uses
  Forms,
  Kurs0001 in 'Kurs0001.pas' {Kursberechnung},
  Kurs0002 in 'Kurs0002.pas' {Vorschau},
  Kurs0003 in 'Kurs0003.pas' {Film},
  Kurs0004 in 'Kurs0004.pas' {Bild},
  Kurs0005 in 'Kurs0005.pas' {Windrose},
  Kurs0006 in 'Kurs0006.pas' {Zoominfo},
  Kurs0007 in 'Kurs0007.pas' {Programminfo},
  Kurs0008 in 'Kurs0008.pas' {Eintrag},
  Kurs0009 in 'Kurs0009.pas' {Sucheform};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TKursberechnung, Kursberechnung);
  Application.CreateForm(TVorschau, Vorschau);
  Application.CreateForm(TFilm, Film);
  Application.CreateForm(TBild, Bild);
  Application.CreateForm(TWindrose, Windrose);
  Application.CreateForm(TZoominfo, Zoominfo);
  Application.CreateForm(TProgramminfo, Programminfo);
  Application.CreateForm(TEintrag, Eintrag);
  Application.CreateForm(TSucheform, Sucheform);
  Application.Run;
end.
