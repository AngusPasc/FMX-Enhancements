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
unit FMXE.Helpers.Canvas;

interface

uses
  System.Classes, System.SysUtils, System.UITypes, System.Types, System.Math,
  FMX.Graphics, FMX.Types, FMX.TextLayout;

{
  About this unit:
    - This unit provides a useful helper class for TCanvas (integrates FMXE features directly into TCanvas)

  Changelog (latest changes first):
    27th September 2014:
      - Prepared for Release
}

type
  TFECanvasHelper = class helper for TCanvas
  public
    procedure DrawCachedText(const APosition: TPointF; const AAngle: Integer; const AColor: TAlphaColor; const AFont: TFont; const AText: String; const AWordWrap: Boolean; const AOpacity: Single; const AFlags: TFillTextFlags; const AHTextAlign, AVTextAlign: TTextAlign; const AHighSpeed: Boolean = False); overload;
    procedure DrawCachedText(const ARect: TRectF; const AAngle: Integer; const AColor: TAlphaColor; const AFont: TFont; const AText: String; const AWordWrap: Boolean; const AOpacity: Single; const AFlags: TFillTextFlags; const AHTextAlign, AVTextAlign: TTextAlign; const AHighSpeed: Boolean = False); overload;
  end;

implementation

uses
  FMXE.Caching.Text;

{ TFECanvasHelper }

procedure TFECanvasHelper.DrawCachedText(const APosition: TPointF; const AAngle: Integer; const AColor: TAlphaColor; const AFont: TFont; const AText: String; const AWordWrap: Boolean; const AOpacity: Single; const AFlags: TFillTextFlags; const AHTextAlign, AVTextAlign: TTextAlign; const AHighSpeed: Boolean);
begin
  TextFactory.Render(Self, APosition, AAngle, AColor, AFont, AText, AWordWrap, AOpacity, AFlags, AHTextAlign, AVTextAlign, AHighSpeed);
end;

procedure TFECanvasHelper.DrawCachedText(const ARect: TRectF; const AAngle: Integer; const AColor: TAlphaColor; const AFont: TFont; const AText: String; const AWordWrap: Boolean; const AOpacity: Single; const AFlags: TFillTextFlags; const AHTextAlign, AVTextAlign: TTextAlign; const AHighSpeed: Boolean);
begin
  TextFactory.Render(Self, ARect, AAngle, AColor, AFont, AText, AWordWrap, AOpacity, AFlags, AHTextAlign, AVTextAlign, AHighSpeed);
end;

end.
