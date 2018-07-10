unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uIzgaraPanel, Spin;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    IzgaraPanel1: TIzgaraPanel;
    Button2: TButton;
    Edit2: TEdit;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    ColorBox1: TColorBox;
    Label3: TLabel;
    Label2: TLabel;
    SpinEdit1: TSpinEdit;
    Label4: TLabel;
    SpinEdit2: TSpinEdit;
    Label5: TLabel;
    SpinEdit3: TSpinEdit;
    procedure CheckBox1Click(Sender: TObject);
    procedure ColorBox1Change(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure SpinEdit2Change(Sender: TObject);
    procedure SpinEdit3Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  IzgaraPanel1.Kenar := CheckBox1.Checked;
end;

procedure TForm1.ColorBox1Change(Sender: TObject);
begin
  IzgaraPanel1.Renk := ColorBox1.Selected;
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
  IzgaraPanel1.Kalinlik := SpinEdit1.Value;
end;

procedure TForm1.SpinEdit2Change(Sender: TObject);
begin
  IzgaraPanel1.SatirSayisi := SpinEdit2.Value;
end;

procedure TForm1.SpinEdit3Change(Sender: TObject);
begin
  IzgaraPanel1.SutunSayisi := SpinEdit3.Value;
end;

end.
