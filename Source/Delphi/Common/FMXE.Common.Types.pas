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
unit FMXE.Common.Types;

interface

{
  About this unit:
    - This unit provides Base Types for the FMXE Library

  Changelog (latest changes first):
    27th September 2014:
      - Prepared for Release
}

uses
  System.Classes,
  LKSL.Common.Types, LKSL.Threads.Base;

type
  { Forward Declarations }
  TFECullablePersistent = class;

  {
    TFECullablePersistent
      - An Abstract Base Type for Persistent Objects that are designed to be culled after a desired period
        of non-use.
  }
  TFECullablePersistent = class(TLKPersistent)
  private
    FLastUsed: Double;
  public
    constructor Create; override;

    procedure Cull(const ANotUsedForSeconds: Double); virtual;
    procedure UpdateLastUsed;
  end;

implementation

{ TFECullablePersistent }

constructor TFECullablePersistent.Create;
begin
  inherited;
  UpdateLastUsed;
end;

procedure TFECullablePersistent.Cull(const ANotUsedForSeconds: Double);
begin
  if FLastUsed < (GetReferenceTime - ANotUsedForSeconds) then
    Free;
end;

procedure TFECullablePersistent.UpdateLastUsed;
begin
  FLastUsed := GetReferenceTime;
end;

end.
