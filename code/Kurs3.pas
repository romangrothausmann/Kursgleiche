unit Kurs3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ToolWin, ImgList;

type
  TForm3 = class(TForm)
    Druckvorschau: TRichEdit;
    StandardToolBar: TToolBar;
    ToolButton1: TToolButton;
    ToolButton5: TToolButton;
    ToolbarImages: TImageList;
    PrintDialog1: TPrintDialog;
    PrinterSetupDialog1: TPrinterSetupDialog;
    procedure ToolButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.DFM}


procedure TForm3.ToolButton1Click(Sender: TObject);
begin
IF PrinterSetupDialog1.execute
    And PrintDialog1.Execute
   Then Form3.Druckvorschau.Print ('');

end;

end.
