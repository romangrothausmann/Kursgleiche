unit Kurs00008;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TFormatierung = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Button1: TButton;
    ImmerTitel: TCheckBox;
    ImmerSpT: TCheckBox;
    Nummern: TCheckBox;
    Label9: TLabel;
    Edit9: TEdit;
    Edit10: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    Schriften: TComboBox;
    Querformat: TCheckBox;
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure Edit5Change(Sender: TObject);
    procedure Edit6Change(Sender: TObject);
    procedure Edit7Change(Sender: TObject);
    procedure Edit8Change(Sender: TObject);
    procedure Edit9Change(Sender: TObject);
    procedure Edit10Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure schriftenDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
  private
    { Private-Deklarationen }
    code: Integer;
  public
    { Public-Deklarationen }      //
    ORand, URand, RRand, LRand, ATitel,
    ASpTitel, AEintr, RAEintrag, ANummern, TitelSize: Integer;
  end;

var
  Formatierung: TFormatierung;

implementation


{$R *.DFM}

Function Check(Code: Integer): Boolean;
Begin
Result:= False;
If Code <> 0
   Then Begin
        ShowMessage('Sie dürfen nur ganze Zahlen eingeben!');
        result:= True;
        End;
End;

procedure TFormatierung.Edit1Change(Sender: TObject);
begin
Val(Edit1.Text, ORand, Code);
If Edit1.Text <> ''
   Then if check(code)
        then Edit1.Text:= '1';
end;

procedure TFormatierung.Edit2Change(Sender: TObject);
begin
Val(Edit2.Text, URand, Code);
If Edit2.Text <> ''
   Then if check(code)
        then Edit2.Text:= '1';
end;

procedure TFormatierung.Edit3Change(Sender: TObject);
begin
Val(Edit3.Text, RRand, Code);
If Edit3.Text <> ''
   Then if check(code)
        then Edit3.Text:= '5';
end;

procedure TFormatierung.Edit4Change(Sender: TObject);
begin
Val(Edit4.Text, LRand, Code);
If Edit4.Text <> ''
   Then if check(code)
        then Edit4.Text:= '25';
end;

procedure TFormatierung.Edit5Change(Sender: TObject);
begin
Val(Edit5.Text, ATitel, Code);
If Edit5.Text <> ''
   Then if check(code)
        then Edit5.Text:= '5';
end;

procedure TFormatierung.Edit6Change(Sender: TObject);
begin
Val(Edit6.Text, ASpTitel, Code);
If Edit6.Text <> ''
   Then if check(code)
        then Edit6.Text:= '3';
end;

procedure TFormatierung.Edit7Change(Sender: TObject);
begin
Val(Edit7.Text, AEintr, Code);
If Edit7.Text <> ''
   Then if check(code)
        then Edit7.Text:= '2';
end;

procedure TFormatierung.Edit8Change(Sender: TObject);
begin
Val(Edit8.Text, RAEintrag, Code);
If Edit8.Text <> ''
   Then if check(code)
        then Edit8.Text:= '4';
end;

procedure TFormatierung.Edit9Change(Sender: TObject);
begin
Val(Edit9.Text, ANummern, Code);
If Edit9.Text <> ''
   Then if check(code)
        then Edit9.Text:= '5';
end;

procedure TFormatierung.Edit10Change(Sender: TObject);
begin
Val(Edit10.Text, TitelSize, Code);
If Edit10.Text <> ''
   Then if check(code)
        then Edit10.Text:= '2';
end;

procedure TFormatierung.FormCreate(Sender: TObject);
Var i: Integer;
begin
schriften.Items := Screen.Fonts;
for i:= 0 to schriften.items.count - 1 do
    if schriften.Items[i] = 'Tahoma'
       then begin
            Schriften.ItemIndex:= i;
            exit;
            end;
end;

procedure TFormatierung.schriftenDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  with schriften.Canvas do
  begin
    FillRect(Rect);
    Font.Name := schriften.Items[Index];
    Font.height := 20;    // use font's preferred size
    TextOut(Rect.Left+1, Rect.Top+1, schriften.Items[Index]);
  end;
end;

{procedure TFormatierung.schriftenMeasureItem(Control: TWinControl;
  Index: Integer; var Height: Integer);
begin                     //Funzt nicht!!!???
with Canvas do
  begin
    Font.Name := schriften.Items[Index];
    Font.Size := 0;                 // use font's preferred size
    Height := TextHeight('Wg') + 2; // measure ascenders and descenders
  end;
end; }

end.
