program Kursgleiche00001;

uses
  Forms,
  Kurs00001 in 'Kurs00001.pas' {Kursberechnung},
  Kurs00003 in 'Kurs00003.pas' {Film},
  Kurs00005 in 'Kurs00005.pas' {Windrose},
  Kurs00006 in 'Kurs00006.pas' {Zoominfo},
  Kurs00007 in 'Kurs00007.pas' {Programminfo},
  Kurs00009 in 'Kurs00009.pas' {Sucheform},
  Kurs00002 in 'Kurs00002.pas' {Druckvorschau},
  Kurs00008 in 'Kurs00008.pas' {Formatierung},
  Kurs00004 in 'Kurs00004.pas' {Bilder},
  Kurs00010 in 'Kurs00010.pas' {Druckhilfe},
  Kurs00011 in 'Kurs00011.pas' {Druck};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TKursberechnung, Kursberechnung);
  Application.CreateForm(TFilm, Film);
  Application.CreateForm(TWindrose, Windrose);
  Application.CreateForm(TZoominfo, Zoominfo);
  Application.CreateForm(TProgramminfo, Programminfo);
  Application.CreateForm(TSucheform, Sucheform);
  Application.CreateForm(TFormatierung, Formatierung);
  Application.CreateForm(TDruckvorschau, Druckvorschau);
  Application.CreateForm(TBilder, Bilder);
  Application.CreateForm(TDruckhilfe, Druckhilfe);
  Application.CreateForm(TDruck, Druck);
  Application.Run;
end.
