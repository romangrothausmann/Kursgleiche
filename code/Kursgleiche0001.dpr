program Kursgeiche0001;

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
 { Film := TFilm.Create(Application);
  Film.Show;
  Film.Update;  }
  Application.Initialize;
  Application.CreateForm(TKursberechnung, Kursberechnung);
  Application.CreateForm(TFilm, Film);
  Application.CreateForm(TVorschau, Vorschau);
  Application.CreateForm(TBild, Bild);
  Application.CreateForm(TWindrose, Windrose);
  Application.CreateForm(TZoominfo, Zoominfo);
  Application.CreateForm(TProgramminfo, Programminfo);
  Application.CreateForm(TEintrag, Eintrag);
  Application.CreateForm(TSucheform, Sucheform);
  Application.Run;
end.

{begin
  SplashForm := TSplashForm.Create(Application);
  SplashForm.Show;
  SplashForm.Update;
  Application.Title := 'Marine Adventures Order Entry';
  Application.HelpFile := 'MASTAPP.HLP';
  Application.CreateForm(TMastData, MastData);
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TBrPartsForm, BrPartsForm);
  Application.CreateForm(TQueryCustDlg, QueryCustDlg);
  Application.CreateForm(TEdPartsForm, EdPartsForm);
  Application.CreateForm(TBrCustOrdForm, BrCustOrdForm);
  Application.CreateForm(TEdCustForm, EdCustForm);
  Application.CreateForm(TEdOrderForm, EdOrderForm);
  Application.CreateForm(TSearchDlg, SearchDlg);
  Application.CreateForm(TBrDateForm, BrDateForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TPickRpt, PickRpt);
  Application.CreateForm(TCustomerByInvoiceReport, CustomerByInvoiceReport);
  Application.CreateForm(TOrdersByDateReport, OrdersByDateReport);
  Application.CreateForm(TInvoiceByOrderNoReport, InvoiceByOrderNoReport);
  Application.CreateForm(TPickOrderNoDlg, PickOrderNoDlg);
  SplashForm.Hide;
  SplashForm.Free;
  Application.Run;
end.}
