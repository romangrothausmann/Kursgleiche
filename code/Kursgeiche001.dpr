program Kursgeiche02;

uses
  Forms,
  Kurs02 in 'Kurs02.pas' {Form1},
  Kurs2 in 'Kurs2.pas' {Form2},
  Kurs3 in 'Kurs3.pas' {Form3},
  Kurs5 in 'Kurs5.pas' {Bild},
  Kurs4 in 'Kurs4.pas' {Windrose},
  Kurs7 in 'Kurs7.pas' {Zoominfo},
  Kurs8 in 'Kurs8.pas' {Film},
  Kurs9 in 'Kurs9.pas' {Programminfo};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TBild, Bild);
  Application.CreateForm(TZoominfo, Zoominfo);
  Application.CreateForm(TFilm, Film);
  Application.CreateForm(TProgramminfo, Programminfo);
  Application.CreateForm(TWindrose, Windrose);
  Application.Run;
end.
