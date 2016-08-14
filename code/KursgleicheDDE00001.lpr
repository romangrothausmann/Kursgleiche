program KursgleicheDDE00001;

{$MODE Delphi}

uses
  Forms, Interfaces,
  tachartlazaruspkg, // segfaults without if TChart ist used!!!
  KursDDE00001 in 'KursDDE00001.pas' {Kursberechnung},
  KursDDE00003 in 'KursDDE00003.pas' {Film},
  KursDDE00005 in 'KursDDE00005.pas' {Windrose},
  KursDDE00006 in 'KursDDE00006.pas' {Zoominfo},
  KursDDE00007 in 'KursDDE00007.pas' {Programminfo},
  KursDDE00009 in 'KursDDE00009.pas' {Sucheform},
  KursDDE00002 in 'KursDDE00002.pas' {Druckvorschau},
  KursDDE00008 in 'KursDDE00008.pas' {Formatierung},
  KursDDE00004 in 'KursDDE00004.pas' {Bilder},
  KursDDE00010 in 'KursDDE00010.pas' {Druckhilfe},
  KursDDE00011 in 'KursDDE00011.pas' {Druck};

{$R *.res}

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
