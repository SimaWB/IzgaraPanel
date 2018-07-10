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

  TIzgaraPanel = class(TCustomPanel)
  private
    FSutunSayisi: Integer;
    FSatirSayisi: Integer;
    FRenk: TColor;
    FKalinlik: Integer;

    FCizgiList: TList;
    FKenar: Boolean;
    FSol, FSag, FUst, FAlt: TCizgi;
    procedure CizgiListesiniYenile(ct: TCizgiType);

    procedure SetRenk(const Value: TColor);
    procedure SetSatirSayisi(const Value: Integer);
    procedure SetSutunSayisi(const Value: Integer);
    procedure SetKalinlik(const Value: Integer);
    procedure SetKenar(const Value: Boolean);
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
  Enabled := False;
  FParent := AOwner;
  FCizgiTipi := CizgiTipi;
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

  FSol := TCizgi.Create(Self, ctDikey);
  FSag := TCizgi.Create(Self, ctDikey);
  FUst := TCizgi.Create(Self, ctYatay);
  FAlt := TCizgi.Create(Self, ctYatay);

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

  if not FKenar then
  begin
    FSol.Width := 0;
    FSag.Width := 0;
    FUst.Height := 0;
    FAlt.Height := 0;
  end else
  begin
    FSol.UpdatePosition(0);
    FSag.UpdatePosition(Width - FKalinlik);
    FUst.UpdatePosition(0);
    FAlt.UpdatePosition(Height - FKalinlik);
  end;
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

end.