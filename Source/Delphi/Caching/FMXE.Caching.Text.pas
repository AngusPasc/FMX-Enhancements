{
  FireMonkey Enhancements Library [FMXE]
  Copyright (c) 2014, LaKraven Studios Ltd, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/FireMonkey-Enhancements

  License:
    - You may use this library as you see fit, including use within commercial applications.
    - You may modify this library to suit your needs, without the requirement of distributing
      modified versions.
    - You may redistribute this library (in part or whole) individually, or as part of any
      other works.
    - You must NOT charge a fee for the distribution of this library (compiled or in its
      source form). It MUST be distributed freely.
    - This license and the surrounding comment block MUST remain in place on all copies and
      modified versions of this source code.
    - Modified versions of this source MUST be clearly marked, including the name of the
      person(s) and/or organization(s) responsible for the changes, and a SEPARATE "changelog"
      detailing all additions/deletions/modifications made.

  Disclaimer:
    - Your use of this source constitutes your understanding and acceptance of this
      disclaimer.
    - LaKraven Studios Ltd and its employees (including but not limited to directors,
      programmers and clerical staff) cannot be held liable for your use of this source
      code. This includes any losses and/or damages resulting from your use of this source
      code, be they physical, financial, or psychological.
    - There is no warranty or guarantee (implicit or otherwise) provided with this source
      code. It is provided on an "AS-IS" basis.

  Donations:
    - While not mandatory, contributions are always appreciated. They help keep the coffee
      flowing during the long hours invested in this and all other Open Source projects we
      produce.
    - Donations can be made via PayPal to PayPal [at] LaKraven (dot) Com
                                          ^  Garbled to prevent spam!  ^
}
unit FMXE.Caching.Text;

interface

uses
  System.Classes, System.SysUtils, System.UITypes, System.Types, System.Math,
  FMX.Graphics, FMX.Types, FMX.TextLayout,
  FMXE.Common.Types;

{
  About this unit:
    - This unit provides a rendering and caching solution for Text.
    - Note that the LKSL is used within this unit.

  Changelog (latest changes first):
    27th September 2014 (feature update):
      - Added Culling methods at every level of the Text Cache Factory.
      - No longer just referencing the passed TFont value, copying it internally instead.
    27th September 2014 (bug fix update):
      - Fixed two minor bugs.
    27th September 2014:
      - Prepared for Release
}

type
  { Forward Declarations }
  TFETextCacheFactory = class;
  TFETextCacheString = class;
  TFETextCacheColor = class;
  TFETextCacheFont = class;
  TFETextCacheTextSettings = class;
  TFETextCache = class;

  { Array Types }
  TFETextCacheStringArray = Array of TFETextCacheString;
  TFETextCacheColorArray = Array of TFETextCacheColor;
  TFETextCacheFontArray = Array of TFETextCacheFont;
  TFETextCacheTextSettingsArray = Array of TFETextCacheTextSettings;

  {
    TFETextCacheFactory
      - Manages the Text Cache
      - Provides standardized call to render Text onto a Canvas
      - When rendering text for the first time with a set of properties, it is automatically cached.
  }
  TFETextCacheFactory = class(TPersistent)
  private
    FStrings: TFETextCacheStringArray;
    procedure AddString(const ATextString: TFETextCacheString);
    procedure DeleteString(const ATextString: TFETextCacheString);
    procedure ClearStrings;
    function GetStringIndex(const AValue: String): Integer;
    function GetString(const AValue: String): TFETextCacheString;

    procedure DrawText(const ABitmap: TBitmap; const ACanvas: TCanvas; const ARect: TRectF; const AOpacity: Single; const AHighSpeed: Boolean = False);
  public
    destructor Destroy; override;

    procedure CullCache(const ANotUsedForSeconds: Double);

    procedure Render(const ACanvas: TCanvas; const APosition: TPointF; const AAngle: Integer; const AColor: TAlphaColor; const AFont: TFont; const AText: String; const AWordWrap: Boolean; const AOpacity: Single; const AFlags: TFillTextFlags; const AHTextAlign, AVTextAlign: TTextAlign; const AHighSpeed: Boolean = False); overload;
    procedure Render(const ACanvas: TCanvas; const ARect: TRectF; const AAngle: Integer; const AColor: TAlphaColor; const AFont: TFont; const AText: String; const AWordWrap: Boolean; const AOpacity: Single; const AFlags: TFillTextFlags; const AHTextAlign, AVTextAlign: TTextAlign; const AHighSpeed: Boolean = False); overload;

    property Strings[const AValue: String]: TFETextCacheString read GetString;
  end;

  {
    TFETextCacheString
      -
  }
  TFETextCacheString = class(TFECullablePersistent)
  private
    FColors: TFETextCacheColorArray;
    FIndex: Integer;
    FManager: TFETextCacheFactory;
    FValue: String;
    procedure AddColor(const AColor: TFETextCacheColor);
    procedure ClearColors;
    procedure DeleteColor(const AColor: TFETextCacheColor);
    function GetColorIndex(const AColor: TAlphaColor): Integer;
    function GetColor(const AColor: TAlphaColor): TFETextCacheColor;
  public
    constructor Create(const ACacheManager: TFETextCacheFactory; const AValue: String); reintroduce;
    destructor Destroy; override;

    procedure Cull(const ANotUsedForSeconds: Double); override;

    property Colors[const AColor: TAlphaColor]: TFETextCacheColor read GetColor;
    property Value: String read FValue;
  end;

  {
    TFETextCacheColor
      -
  }
  TFETextCacheColor = class(TFECullablePersistent)
  private
    FFonts: TFETextCacheFontArray;
    FIndex: Integer;
    FString: TFETextCacheString;
    FValue: TAlphaColor;
    procedure AddFont(const AFont: TFETextCacheFont);
    procedure ClearFonts;
    procedure DeleteFont(const AFont: TFETextCacheFont);
    function GetFontIndex(const AFont: TFont): Integer;
    function GetFont(const AFont: TFont): TFETextCacheFont;
  public
    constructor Create(const AString: TFETextCacheString; const AValue: TAlphaColor); reintroduce;
    destructor Destroy; override;

    procedure Cull(const ANotUsedForSeconds: Double); override;

    property Fonts[const AFont: TFont]: TFETextCacheFont read GetFont;
    property Value: TAlphaColor read FValue;
  end;

  {
    TFETextCacheFont
      -
  }
  TFETextCacheFont = class(TFECullablePersistent)
  private
    FColor: TFETextCacheColor;
    FIndex: Integer;
    FTextSettings: TFETextCacheTextSettingsArray;
    FValue: TFont;
    procedure AddTextSettings(const ATextSettings: TFETextCacheTextSettings);
    procedure ClearTextSettings;
    procedure DeleteTextSettings(const ATextSettings: TFETextCacheTextSettings);
    function GetTextSettingsIndex(const AFlags: TFillTextFlags; const AWordWrap: Boolean; const AAlignHor, AAlignVer: TTextAlign): Integer;
    function GetTextSettings(const AFlags: TFillTextFlags; const AWordWrap: Boolean; const AAlignHor, AAlignVer: TTextAlign): TFETextCacheTextSettings;
  public
    constructor Create(const AFill: TFETextCacheColor; const AFont: TFont); reintroduce;
    destructor Destroy; override;

    procedure Cull(const ANotUsedForSeconds: Double); override;

    property Settings[const AFlags: TFillTextFlags; const AWordWrap: Boolean; const AAlignHor, AAlignVer: TTextAlign]: TFETextCacheTextSettings read GetTextSettings;
    property Value: TFont read FValue;
  end;

  {
    TFETextCacheTextSettings
      -
  }
  TFETextCacheTextSettings = class(TFECullablePersistent)
  private
    FAlignHor: TTextAlign;
    FAlignVer: TTextAlign;
    FFlags: TFillTextFlags;
    FFont: TFETextCacheFont;
    FImages: TFETextCache;
    FIndex: Integer;
    FWordWrap: Boolean;
    function GetImages: TFETextCache;
  public
    constructor Create(const AFont: TFETextCacheFont; const AFlags: TFillTextFlags; const AWordWrap: Boolean; const AAlignHor, AAlignVer: TTextAlign); reintroduce;
    destructor Destroy; override;

    property AlignHor: TTextAlign read FAlignHor;
    property AlignVer: TTextAlign read FAlignVer;
    property Flags: TFillTextflags read FFlags;
    property Images: TFETextCache read GetImages;
    property WordWrap: Boolean read FWordwrap;
  end;

  {
    TFETextCache
      -
  }
  TFETextCache = class(TFECullablePersistent)
  private
    FAngles: Array[0..359] of TBitmap;
    FSettings: TFETextCacheTextSettings;
    procedure GenerateText;
    procedure GenerateRotation(const AAngle: Integer);
    function GetAngle(const AAngle: Integer): TBitmap;
  public
    constructor Create(const ASettings: TFETextCacheTextSettings); reintroduce;
    destructor Destroy; override;

    property Angles[const AAngle: Integer]: TBitmap read GetAngle;
  end;

var
  TextFactory: TFETextCacheFactory;

implementation

{ TFETextCacheFactory }

procedure TFETextCacheFactory.AddString(const ATextString: TFETextCacheString);
  function GetSortedPosition: Integer;
  var
    LIndex, LLow, LHigh: Integer;
  begin
    Result := 0;
    LLow := 0;
    LHigh := Length(FStrings) - 1;
    if LHigh = - 1 then
      Exit;
    if LLow < LHigh then
    begin
      while (LHigh - LLow > 1) do
      begin
        LIndex := (LHigh + LLow) div 2;
        if ATextString.Value <= FStrings[LIndex].Value then
          LHigh := LIndex
        else
          LLow := LIndex;
      end;
    end;
    if (FStrings[LHigh].Value < ATextString.Value) then
      Result := LHigh + 1
    else if (FStrings[LLow].Value < ATextString.Value) then
      Result := LLow + 1
    else
      Result := LLow;
  end;
var
  LIndex, I: Integer;
begin
  LIndex := GetStringIndex(ATextString.Value);
  if LIndex = -1 then
  begin
    LIndex := GetSortedPosition;
    SetLength(FStrings, Length(FStrings) + 1);
    // Shift items to the RIGHT
    if LIndex < Length(FStrings) - 1 then
      for I := Length(FStrings) - 1 downto (LIndex + 1) do
      begin
        FStrings[I] := FStrings[I - 1];
        FStrings[I].FIndex := I;
      end;
    // Insert new Event Group
    FStrings[LIndex] := ATextString;
    ATextString.FIndex := LIndex;
  end;
end;

procedure TFETextCacheFactory.ClearStrings;
var
  I: Integer;
begin
  for I := High(FStrings) downto Low(FStrings) do
    FStrings[I].Free;
  SetLength(FStrings, 0);
end;

procedure TFETextCacheFactory.CullCache(const ANotUsedForSeconds: Double);
var
  I: Integer;
begin
  for I := High(FStrings) downto Low(FStrings) do
    FStrings[I].Cull(ANotUsedForSeconds);
end;

procedure TFETextCacheFactory.DeleteString(const ATextString: TFETextCacheString);
var
  LCount, I: Integer;
begin
  LCount := Length(FStrings);
  if (ATextString.FIndex < 0) or (ATextString.FIndex > LCount - 1) then
    Exit;
  if (ATextString.FIndex < (LCount - 1)) then
    for I := ATextString.FIndex to LCount - 2 do
    begin
      FStrings[I] := FStrings[I + 1];
      FStrings[I].FIndex := I;
    end;
  SetLength(FStrings, LCount - 1);
end;

destructor TFETextCacheFactory.Destroy;
begin
  ClearStrings;
  inherited;
end;

procedure TFETextCacheFactory.DrawText(const ABitmap: TBitmap; const ACanvas: TCanvas; const ARect: TRectF; const AOpacity: Single; const AHighSpeed: Boolean = False);
var
  LTextRect: TRectF;
begin
  LTextRect := RectF(0, 0, ABitmap.Width, ABitmap.Height);
  ACanvas.DrawBitmap(ABitmap, LTextRect, ARect, AOpacity);
end;

function TFETextCacheFactory.GetString(const AValue: String): TFETextCacheString;
var
  LIndex: Integer;
begin
  LIndex := GetStringIndex(AValue);
  if LIndex = -1 then
    Result := TFETextCacheString.Create(Self, AValue)
  else
    Result := FStrings[LIndex];
end;

function TFETextCacheFactory.GetStringIndex(const AValue: String): Integer;
var
  LIndex, LLow, LHigh: Integer;
begin
  Result := -1;
  LLow := 0;
  LHigh := Length(FStrings) - 1;
  if LHigh > -1 then
  begin
    if LLow < LHigh then
    begin
      while (LHigh - LLow > 1) do
      begin
        LIndex := (LHigh + LLow) div 2;
        if AValue <= FStrings[LIndex].Value then
          LHigh := LIndex
        else
          LLow := LIndex;
      end;
    end;
    if (FStrings[LHigh].Value = AValue) then
      Result := LHigh
    else if (FStrings[LLow].Value = AValue) then
      Result := LLow;
  end;
end;

procedure TFETextCacheFactory.Render(const ACanvas: TCanvas; const APosition: TPointF; const AAngle: Integer; const AColor: TAlphaColor; const AFont: TFont; const AText: String; const AWordWrap: Boolean; const AOpacity: Single; const AFlags: TFillTextFlags; const AHTextAlign, AVTextAlign: TTextAlign; const AHighSpeed: Boolean = False);
var
  LRect: TRectF;
  LBitmap: TBitmap;
begin
  LBitmap := GetString(AText).GetColor(AColor).GetFont(AFont).GetTextSettings(AFlags, AWordWrap, AHTextAlign, AVTextAlign).Images.Angles[AAngle];
  LRect.Left := APosition.X;
  LRect.Top := APosition.Y;
  LRect.Right := APosition.X + LBitmap.Width;
  LRect.Bottom := APosition.Y + LBitmap.Height;
  DrawText(LBitmap, ACanvas, LRect, AOpacity);
end;

procedure TFETextCacheFactory.Render(const ACanvas: TCanvas; const ARect: TRectF; const AAngle: Integer; const AColor: TAlphaColor; const AFont: TFont; const AText: String; const AWordWrap: Boolean; const AOpacity: Single; const AFlags: TFillTextFlags; const AHTextAlign, AVTextAlign: TTextAlign; const AHighSpeed: Boolean = False);
var
  LBitmap: TBitmap;
begin
  LBitmap := GetString(AText).GetColor(AColor).GetFont(AFont).GetTextSettings(AFlags, AWordWrap, AHTextAlign, AVTextAlign).Images.Angles[AAngle];
  DrawText(LBitmap, ACanvas, ARect, AOpacity);
end;

{ TFETextCacheString }

procedure TFETextCacheString.AddColor(const AColor: TFETextCacheColor);
  function GetSortedPosition: Integer;
  var
    LIndex, LLow, LHigh: Integer;
  begin
    Result := 0;
    LLow := 0;
    LHigh := Length(FColors) - 1;
    if LHigh = - 1 then
      Exit;
    if LLow < LHigh then
    begin
      while (LHigh - LLow > 1) do
      begin
        LIndex := (LHigh + LLow) div 2;
        if AColor.Value <= FColors[LIndex].Value then
          LHigh := LIndex
        else
          LLow := LIndex;
      end;
    end;
    if (FColors[LHigh].Value < AColor.Value) then
      Result := LHigh + 1
    else if (FColors[LLow].Value < AColor.Value) then
      Result := LLow + 1
    else
      Result := LLow;
  end;
var
  LIndex, I: Integer;
begin
  LIndex := GetColorIndex(AColor.Value);
  if LIndex = -1 then
  begin
    LIndex := GetSortedPosition;
    SetLength(FColors, Length(FColors) + 1);
    // Shift items to the RIGHT
    if LIndex < Length(FColors) - 1 then
      for I := Length(FColors) - 1 downto (LIndex + 1) do
      begin
        FColors[I] := FColors[I - 1];
        FColors[I].FIndex := I;
      end;
    // Insert new Event Group
    FColors[LIndex] := AColor;
    AColor.FIndex := LIndex;
  end;
end;

procedure TFETextCacheString.ClearColors;
var
  I: Integer;
begin
  for I := High(FColors) downto Low(FColors) do
    FColors[I].Free;
  SetLength(FColors, 0);
end;

constructor TFETextCacheString.Create(const ACacheManager: TFETextCacheFactory; const AValue: String);
begin
  inherited Create;
  FValue := AValue;
  FManager := ACacheManager;
  FManager.AddString(Self);
end;

procedure TFETextCacheString.Cull(const ANotUsedForSeconds: Double);
var
  I: Integer;
begin
  for I := High(FColors) downto Low(FColors) do
    FColors[I].Cull(ANotUsedForSeconds);
  inherited;
end;

procedure TFETextCacheString.DeleteColor(const AColor: TFETextCacheColor);
var
  I: Integer;
begin
  for I := AColor.FIndex to High(FColors) - 1 do
  begin
    FColors[I] := FColors[I + 1];
    FColors[I].FIndex := I;
  end;
  SetLength(FColors, Length(FColors) - 1);
end;

destructor TFETextCacheString.Destroy;
begin
  FManager.DeleteString(Self);
  ClearColors;
  inherited;
end;

function TFETextCacheString.GetColor(const AColor: TAlphaColor): TFETextCacheColor;
var
  LIndex: Integer;
begin
  LIndex := GetColorIndex(AColor);
  if LIndex = -1 then
    Result := TFETextCacheColor.Create(Self, AColor)
  else
    Result := FColors[LIndex];

  UpdateLastUsed;
end;

function TFETextCacheString.GetColorIndex(const AColor: TAlphaColor): Integer;
var
  LIndex, LLow, LHigh: Integer;
begin
  Result := -1;
  LLow := 0;
  LHigh := Length(FColors) - 1;
  if LHigh > -1 then
  begin
    if LLow < LHigh then
    begin
      while (LHigh - LLow > 1) do
      begin
        LIndex := (LHigh + LLow) div 2;
        if AColor <= FColors[LIndex].Value then
          LHigh := LIndex
        else
          LLow := LIndex;
      end;
    end;
    if (FColors[LHigh].Value = AColor) then
      Result := LHigh
    else if (FColors[LLow].Value = AColor) then
      Result := LLow;
  end;
end;

{ TFETextCacheColor }

procedure TFETextCacheColor.AddFont(const AFont: TFETextCacheFont);
var
  LIndex: Integer;
begin
  LIndex := Length(FFonts);
  SetLength(FFonts, LIndex + 1);
  FFonts[LIndex] := AFont;
  AFont.FIndex := LIndex;
end;

procedure TFETextCacheColor.ClearFonts;
var
  I: Integer;
begin
  for I := High(FFonts) downto Low(FFonts) do
    FFonts[I].Free;
  SetLength(FFonts, 0);
end;

constructor TFETextCacheColor.Create(const AString: TFETextCacheString; const AValue: TAlphaColor);
begin
  inherited Create;
  FValue := AValue;
  FString := AString;
  FString.AddColor(Self);
end;

procedure TFETextCacheColor.Cull(const ANotUsedForSeconds: Double);
var
  I: Integer;
begin
  for I := High(FFonts) downto Low(FFonts) do
    FFonts[I].Cull(ANotUsedForSeconds);
  inherited;
end;

procedure TFETextCacheColor.DeleteFont(const AFont: TFETextCacheFont);
var
  I: Integer;
begin
  for I := AFont.FIndex to High(FFonts) - 1 do
  begin
    FFonts[I] := FFonts[I + 1];
    FFonts[I].FIndex := I;
  end;
  SetLength(FFonts, Length(FFonts) - 1);
end;

destructor TFETextCacheColor.Destroy;
begin
  FString.DeleteColor(Self);
  ClearFonts;
  inherited;
end;

function TFETextCacheColor.GetFont(const AFont: TFont): TFETextCacheFont;
var
  LIndex: Integer;
begin
  LIndex := GetFontIndex(AFont);
  if LIndex = -1 then
    Result := TFETextCacheFont.Create(Self, AFont)
  else
    Result := FFonts[LIndex];

  UpdateLastUsed;
end;

function TFETextCacheColor.GetFontIndex(const AFont: TFont): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := Low(FFonts) to High(FFonts) do
    if (FFonts[I].Value.Equals(AFont)) then
      begin
        Result := I;
        Break;
      end;
end;

{ TFETextCacheFont }

procedure TFETextCacheFont.AddTextSettings(const ATextSettings: TFETextCacheTextSettings);
var
  LIndex: Integer;
begin
  LIndex := Length(FTextSettings);
  SetLength(FTextSettings, LIndex + 1);
  FTextSettings[LIndex] := ATextSettings;
  ATextSettings.FIndex := LIndex;
end;

procedure TFETextCacheFont.ClearTextSettings;
var
  I: Integer;
begin
  for I := High(FTextSettings) downto Low(FTextSettings) do
    FTextSettings[I].Free;
  SetLength(FTextSettings, 0);
end;

constructor TFETextCacheFont.Create(const AFill: TFETextCacheColor; const AFont: TFont);
begin
  inherited Create;
  FColor := AFill;
  FValue := TFont.Create;
  FValue.Assign(AFont);
  FColor.AddFont(Self);
end;

procedure TFETextCacheFont.Cull(const ANotUsedForSeconds: Double);
var
  I: Integer;
begin
  for I := High(FTextSettings) downto Low(FTextSettings) do
    FTextSettings[I].Cull(ANotUsedForSeconds);
  inherited;
end;

procedure TFETextCacheFont.DeleteTextSettings(const ATextSettings: TFETextCacheTextSettings);
var
  I: Integer;
begin
  for I := ATextSettings.FIndex to High(FTextSettings) - 1 do
  begin
    FTextSettings[I] := FTextSettings[I + 1];
    FTextSettings[I].FIndex := I;
  end;
  SetLength(FTextSettings, Length(FTextSettings) - 1);
end;

destructor TFETextCacheFont.Destroy;
begin
  FColor.DeleteFont(Self);
  ClearTextSettings;
  FValue.Free;
  inherited;
end;

function TFETextCacheFont.GetTextSettings(const AFlags: TFillTextFlags; const AWordWrap: Boolean; const AAlignHor, AAlignVer: TTextAlign): TFETextCacheTextSettings;
var
  LIndex: Integer;
begin
  LIndex := GetTextSettingsIndex(AFlags, AWordWrap, AAlignHor, AAlignVer);
  if LIndex = -1 then
    Result := TFETextCacheTextSettings.Create(Self, AFlags, AWordWrap, AAlignHor, AAlignVer)
  else
    Result := FTextSettings[LIndex];

  UpdateLastUsed;
end;

function TFETextCacheFont.GetTextSettingsIndex(const AFlags: TFillTextFlags; const AWordWrap: Boolean; const AAlignHor, AAlignVer: TTextAlign): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := Low(FTextSettings) to High(FTextSettings) do
    if (FTextSettings[I].Flags = AFlags) and
       (FTextSettings[I].WordWrap = AWordWrap) and
       (FTextSettings[I].AlignHor = AAlignHor) and
       (FTextSettings[I].AlignVer = AAlignVer) then
      begin
        Result := I;
        Break;
      end;
end;

{ TFETextCacheTextSettings }

constructor TFETextCacheTextSettings.Create(const AFont: TFETextCacheFont; const AFlags: TFillTextFlags; const AWordWrap: Boolean; const AAlignHor, AAlignVer: TTextAlign);
begin
  inherited Create;
  FFont := AFont;
  FFlags := AFlags;
  FWordWrap := AWordWrap;
  FAlignHor := AAlignHor;
  FAlignVer := AAlignVer;
  FFont.AddTextSettings(Self);
  FImages := TFETextCache.Create(Self);
end;

destructor TFETextCacheTextSettings.Destroy;
begin
  FFont.DeleteTextSettings(Self);
  FImages.Free;
  inherited;
end;

function TFETextCacheTextSettings.GetImages: TFETextCache;
begin
  UpdateLastUsed;
  Result := FImages;
end;

{ TFETextCache }

constructor TFETextCache.Create(const ASettings: TFETextCacheTextSettings);
var
  I: Integer;
begin
  inherited Create;
  FSettings := ASettings;
  for I := Low(FAngles) to High(FAngles) do
    FAngles[I] := nil;
  FAngles[0] := TBitmap.Create;
  GenerateText;
end;

destructor TFETextCache.Destroy;
var
  I: Integer;
begin
  for I := Low(FAngles) to High(FAngles) do
    if FAngles[I] <> nil then
      FAngles[I].Free;
  inherited;
end;

procedure TFETextCache.GenerateRotation(const AAngle: Integer);
begin
  FAngles[AAngle] := TBitmap.Create;
  FAngles[AAngle].Assign(FAngles[0]);
  FAngles[AAngle].Rotate(AAngle);
end;

procedure TFETextCache.GenerateText;
var
  LRect: TRectF;
  LText: String;
begin
  LText := FSettings.FFont.FColor.FString.Value;
  FAngles[0].SetSize(10, 10);
  FAngles[0].Canvas.Font.Assign(FSettings.FFont.Value);
  FAngles[0].Canvas.Fill.Color := FSettings.FFont.FColor.Value;
  LRect := RectF(0, 0, FAngles[0].Canvas.TextWidth(LText), FAngles[0].Canvas.TextHeight(LText));
  FAngles[0].SetSize(Floor(LRect.Right), Floor(LRect.Bottom));
  if FAngles[0].Canvas.BeginScene then
  begin
    FAngles[0].Canvas.Clear(TAlphaColors.Null);
    FAngles[0].Canvas.Font.Assign(FSettings.FFont.Value);
    FAngles[0].Canvas.Fill.Color := FSettings.FFont.FColor.Value;
    //
    FAngles[0].Canvas.FillText(LRect,
                               LText,
                               FSettings.WordWrap,
                               1.00,
                               FSettings.Flags,
                               FSettings.AlignHor,
                               FSettings.AlignVer);
    //
    FAngles[0].Canvas.EndScene;
  end;
end;

function TFETextCache.GetAngle(const AAngle: Integer): TBitmap;
var
  LAngle: Integer;
begin
  if AAngle < 0 then
    LAngle := 360 + AAngle
  else
    LAngle := AAngle;

  if LAngle > 0 then
    if FAngles[LAngle] = nil then
      GenerateRotation(LAngle);

  Result := FAngles[LAngle];
  UpdateLastUsed;
end;

initialization
  TextFactory := TFETextCacheFactory.Create;
finalization
  TextFactory.Free;

end.
