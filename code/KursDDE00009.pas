unit KursDDE00009;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBCtrls, DB, ExtCtrls;

type
  TSucheform = class(TForm)
    Label1: TLabel;
    Edit2: TEdit;
    Label2: TLabel;
    Spaltenbox: TComboBox;
    Button1: TButton;
    Label3: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Bevel1: TBevel;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Sucheform: TSucheform;

implementation

uses KursDDE00001;


{$R *.DFM}

Function Suche(s, t: String; Gross, Anf: boolean): boolean;
Begin
Result:= False;
If Anf
   Then Begin
        If gross
        Then Begin
             if Pos(s, t) = 1
                Then Result:= True;
             End
        Else if Pos(LowerCase(s), LowerCase(t)) = 1
                Then Result:= True;
        End
   Else If gross
        Then Begin
             if Pos(s, t) <> 0
                Then Result:= True;
             End
        Else if Pos(LowerCase(s), LowerCase(t)) <> 0
                Then Result:= True;
End;


Function Finde(a: Integer; s: String; Gross, Anf: Boolean): TAktuOrt;
Var i: Integer;
    c: Char;
Begin
If Length(s) > 0
   then c:= LowerCase(s)[1];
While Length(s) > 0 do
      Begin
      For i:= 1 to Kursberechnung.Tabelle.RowCount - 1 do
          if Suche(s, Kursberechnung.Tabelle.Cells[a, i], Gross, Anf)
             Then Begin
                  Kursberechnung.Tabelle.TopRow:= i;
                  Result.Spalte:= a;
                  Result.Zeile:= i;
                  Result.Name:= Kursberechnung.Tabelle.Cells[a,i];
                  Exit;
                  End;
      If Length(s) = 1
         then While c > 'a' do
                    Begin
                    For i:= 1 to Kursberechnung.Tabelle.RowCount - 1 do
                        if Pos(c, LowerCase(Kursberechnung.Tabelle.Cells[a, i])) = 1
                           Then Begin
                                Kursberechnung.Tabelle.TopRow:= i;
                                Result.Spalte:= a;
                                Result.Zeile:= i;
                                Result.Name:= Kursberechnung.Tabelle.Cells[a,i];
                                Exit;
                                End;
                    dec(c);
                    End;
      delete(s, Length(s), 1)
      End;
Result.Spalte:= 1;
Result.Zeile:= 1;
Result.Name:= '';
Kursberechnung.Tabelle.TopRow:= 1;
End;

procedure TSucheform.Button1Click(Sender: TObject);
begin
Kursberechnung.AktuOrt:= Finde(Sucheform.Spaltenbox.ItemIndex,
                               Edit2.Text, CheckBox1.Checked, CheckBox2.Checked);
If Kursberechnung.AktuOrt.Name <> ''
   Then Label3.Caption:= 'Eintrag '
        + Kursberechnung.Tabelle.cells[Kursberechnung.AktuOrt.Spalte
        , Kursberechnung.AktuOrt.Zeile]+' gefunden!'
   Else Label3.Caption:= 'Keinen passenden Eintrag gefunden!'
end;

procedure TSucheform.FormShow(Sender: TObject);
begin
Spaltenbox.ItemIndex:= 1;
Label3.Caption:='';
end;

end.
