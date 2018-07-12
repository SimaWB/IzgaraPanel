unit uIzgaraPanel;

interface

uses
  Windows, Classes, Messages, Controls, Graphics, ExtCtrls, SysUtils;

type
  TIzgaraPanel = class;
  TCizgiType = (ctYatay, ctDikey);

  TCizgi = class(TCustomControl)
  private
    FCizgiTipi: TCizgiType;
    FParent: TIzgaraPanel;
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TIzgaraPanel; CizgiTipi: TCizgiType); reintroduce;
    procedure UpdatePosition(const newLen: Integer);
    property CizgiTipi: TCizgiType read FCizgiTipi write FCizgiTipi;
  end;

  TKenar = class(TCustomControl)
  private
    FParent: TIzgaraPanel;
    procedure RecreateHRGN; virtual;
    procedure Paint; override;
  protected
    procedure CreateWnd; override;
    procedure Resize; override;
  public
    constructor Create(AOwner: TIzgaraPanel); reintroduce;
  end;

  TKosegen = class(TKenar)
  private
    procedure RecreateHRGN; override;
  end;

  TIzgaraPanel = class(TCustomPanel)
  private
    FSutunSayisi: Integer;
    FSatirSayisi: Integer;
    FRenk: TColor;
    FKalinlik: Integer;

    FCizgiList: TList;
    FKenar: Boolean;
    FKenarlar: TKenar;
    FKosegenler: TKosegen;
    FKosegen: Boolean;
    procedure CizgiListesiniYenile(ct: TCizgiType);

    procedure SetRenk(const Value: TColor);
    procedure SetSatirSayisi(const Value: Integer);
    procedure SetSutunSayisi(const Value: Integer);
    procedure SetKalinlik(const Value: Integer);
    procedure SetKenar(const Value: Boolean);
    procedure SetKosegen(const Value: Boolean);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Renk: TColor read FRenk write SetRenk default clRed;
    property SutunSayisi: Integer read FSutunSayisi write SetSutunSayisi default 2;
    property SatirSayisi: Integer read FSatirSayisi write SetSatirSayisi default 2;
    property Kalinlik: Integer read FKalinlik write SetKalinlik default 1;
    property Kenar: Boolean read FKenar write SetKenar default True;
    property Kosegen: Boolean read FKosegen write SetKosegen default True;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TIzgaraPanel]);
end;

{ TCizgi }

constructor TCizgi.Create(AOwner: TIzgaraPanel; CizgiTipi: TCizgiType);
begin
  inherited Create(AOwner);
  Parent := AOwner;
  FParent := AOwner;
  FCizgiTipi := CizgiTipi;
  Enabled := False;
end;

procedure TCizgi.Paint;
begin
  Canvas.Pen.Color := FParent.Renk;
  Canvas.Brush.Color := FParent.Renk;
  Canvas.Rectangle(0, 0, Width, Height);
end;

procedure TCizgi.UpdatePosition(const newLen: Integer);
begin
  if FCizgiTipi = ctDikey then
  begin
    Top := 0;
    Left := newLen;
    Height := FParent.Height;
    Width := FParent.Kalinlik;
  end
  else
  begin
    Top := newLen;
    Left := 0;
    Height := FParent.Kalinlik;
    Width := FParent.Width;
  end;
  BringToFront;
  Invalidate;
end;

{ TIzgaraPanel }

procedure TIzgaraPanel.CizgiListesiniYenile(ct: TCizgiType);
var
  I: Integer;
begin
  for I := FCizgiList.Count-1 downto 0 do
    if Assigned(FCizgiList[i]) and (TCizgi(FCizgiList[I]).CizgiTipi = ct) then
    begin
      TCizgi(FCizgiList[I]).Free;
      FCizgiList.Delete(I);
    end;

  Invalidate;

  if ct = ctDikey then
    for I := 1 to FSutunSayisi-1 do
      FCizgiList.Add(TCizgi.Create(Self, ctDikey));

  if ct = ctYatay then
    for I := 1 to FSatirSayisi-1 do
      FCizgiList.Add(TCizgi.Create(Self, ctYatay));
end;

constructor TIzgaraPanel.Create(AOwner: TComponent);
begin
  inherited;
  BevelOuter := bvNone;

  FRenk := clRed;
  FSutunSayisi := 2;
  FSatirSayisi := 2;
  FKalinlik := 1;
  FKenar := True;
  FKosegen := True;

  FKenarlar := TKenar.Create(Self);
  FKosegenler := TKosegen.Create(Self);

  FCizgiList := TList.Create;
  CizgiListesiniYenile(ctDikey);
  CizgiListesiniYenile(ctYatay);
end;

destructor TIzgaraPanel.Destroy;
begin
  FCizgiList.Free;
  inherited;
end;

procedure TIzgaraPanel.Paint;
var
  FShape: TCizgi;
  I, W, H, dikCnt, yatCnt: Integer;
begin
  inherited;
  if FCizgiList.Count > 0 then
  begin
    dikCnt := 1;
    yatCnt := 1;
    for I := 0 to FCizgiList.Count-1 do
    begin
      if TCizgi(FCizgiList[I]).CizgiTipi = ctDikey then
        Inc(dikCnt)
      else
        Inc(yatCnt);
    end;

    { TODO: FKalinlik dikkate elýnarak çizim yapýlabilir}
    W := Width div dikCnt;
    H := Height div yatCnt;
    dikCnt := 0;
    yatCnt := 0;
    for I := 0 to FCizgiList.Count-1 do
    begin
      FShape := FCizgiList[I];
      if FShape.CizgiTipi = ctDikey then
      begin
        Inc(dikCnt);
        FShape.UpdatePosition(W * dikCnt);
      end else
      begin
        Inc(yatCnt);
        FShape.UpdatePosition(H * yatCnt);
      end;
    end;
  end;

  FKenarlar.Invalidate;
  FKenarlar.BringToFront;

  FKosegenler.Invalidate;
  FKosegenler.BringToFront;
end;

procedure TIzgaraPanel.SetKalinlik(const Value: Integer);
begin
  { TODO: Maksimum deðer kontrolü yapýlmalý}
  if FKalinlik <> Value then
  begin
    FKalinlik := Value;
    if Value < 1 then
      FKalinlik := 1;
    Invalidate;
  end;
end;

procedure TIzgaraPanel.SetKenar(const Value: Boolean);
begin
  if FKenar <> Value then
  begin
    FKenar := Value;
    Invalidate;
  end;
end;

procedure TIzgaraPanel.SetKosegen(const Value: Boolean);
begin
  if FKosegen <> Value then
  begin
    FKosegen := Value;
    Invalidate;
  end;
end;

procedure TIzgaraPanel.SetRenk(const Value: TColor);
begin
  if FRenk <> Value then
  begin
    FRenk := Value;
    Invalidate;
  end;
end;

procedure TIzgaraPanel.SetSatirSayisi(const Value: Integer);
begin
  { TODO: Maksimum deðer kontrolü yapýlmalý}
  if FSatirSayisi <> Value then
  begin
    FSatirSayisi := Value;
    if Value < 1 then
      FSatirSayisi := 1;
    CizgiListesiniYenile(ctYatay);
  end;
end;

procedure TIzgaraPanel.SetSutunSayisi(const Value: Integer);
begin
  { TODO: Maksimum deðer kontrolü yapýlmalý}
  if FSutunSayisi <> Value then
  begin
    FSutunSayisi := Value;
    if Value < 0 then
      FSutunSayisi := 0;
    CizgiListesiniYenile(ctDikey);
  end;
end;

{ TKenar }

constructor TKenar.Create(AOwner: TIzgaraPanel);
begin
  inherited Create(AOwner);
  FParent := AOwner;
  Parent := TWinControl(AOwner);
  ParentBackground := False;
  ParentColor := False;
  Align := alClient;
  Enabled := False;
  Color := FParent.Renk;
end;

procedure TKenar.CreateWnd;
begin
  inherited;
  RecreateHRGN;
end;

procedure TKenar.Paint;
begin
  inherited;
  RecreateHRGN;
end;

procedure TKenar.RecreateHRGN;
var
  L1, L2, L3, L4, LCombine: HRGN;
begin
  Color := FParent.Renk;
  LCombine := CreateRectRgn(0, 0, 0, 0);
  if FParent.Kenar then
  begin
    L1 := CreateRectRgn(0, 0, Width, FParent.Kalinlik);
    L2 := CreateRectRgn(0, 0, FParent.Kalinlik, Height);
    L3 := CreateRectRgn(Width, Height, Width-FParent.Kalinlik, 0);
    L4 := CreateRectRgn(Width, Height, 0, Height-FParent.Kalinlik);
    CombineRgn(LCombine, L1, L2, RGN_OR);
    CombineRgn(LCombine, LCombine, L3, RGN_OR);
    CombineRgn(LCombine, LCombine, L4, RGN_OR);
  end;
  SetWindowRgn(Handle, LCombine, True);
end;

procedure TKenar.Resize;
begin
  inherited;
  RecreateHRGN;
end;

{ TKosegen }

procedure TKosegen.RecreateHRGN;
var
  Kose1, Kose2, Koseler: HRGN;
  FPoints1, FPoints2: array[0..5] of TPoint;
  W: Integer;
begin
  Color := FParent.Renk;
  Koseler := CreateRectRgn(0, 0, 0, 0);
  if FParent.Kosegen then
  begin
    W := Round(Sqrt(((FParent.Kalinlik * FParent.Kalinlik) / 2)));

    FPoints1[0] := Point(0, 0);
    FPoints1[1] := Point(0, W);
    FPoints1[2] := Point(Width-W, Height);
    FPoints1[3] := Point(Width, Height);
    FPoints1[4] := Point(Width, Height-W);
    FPoints1[5] := Point(W, 0);
    Kose1 := CreatePolygonRgn(FPoints1, 6, WINDING);

    FPoints2[0] := Point(Width, 0);
    FPoints2[1] := Point(Width-W, 0);
    FPoints2[2] := Point(0, Height-W);
    FPoints2[3] := Point(0, Height);
    FPoints2[4] := Point(W, Height);
    FPoints2[5] := Point(Width, W);
    Kose2 := CreatePolygonRgn(FPoints2, 6, WINDING);

    CombineRgn(Koseler, Kose1, Kose2, RGN_OR);
  end;
  SetWindowRgn(Handle, Koseler, True);
end;

end.