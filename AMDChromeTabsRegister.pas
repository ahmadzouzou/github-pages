unit AMDChromeTabsRegister;

interface

uses
  ToolsApi,
  {$IF CompilerVersion >= 23.0}
  System.SysUtils, System.Classes,
  Vcl.Controls,
  Vcl.Dialogs, Vcl.Menus, Vcl.ActnList,
  WinApi.Windows,
  {$ELSE}
  SysUtils, Classes,
  Controls, ActnList,
  Windows,
  {$ifend}
  DesignIntf, DesignEditors,

	AMDChromeTabs,
  AMDChromeTabsDesign;

  procedure Register;

implementation

resourcestring
  StrTChromeTabsEvery = 'AMD TChromeTabs - Every tab you''ll ever need';

{$R 'Icon.dcr'}

const
  PropertySection = 'AMD Chrome Tabs';
  TChromeTabsName = 'AMD TChromeTabs';

procedure Register;
begin
  RegisterComponents(PropertySection, [TChromeTabs]);

  // Property Editors
  RegisterComponentEditor(TChromeTabs, TChromeTabEditor);
end;

{$IF CompilerVersion >= 18.0}

procedure RegisterSplashScreen;
var
  ProductImage: HBITMAP;
begin
  if Assigned(SplashScreenServices) then
  begin
    ProductImage := LoadBitmap(
      FindResourceHInstance(HInstance),
      'TCHROMETABS');

    SplashScreenServices.AddPluginBitmap(
      TChromeTabsName,
      ProductImage,
      False,
      StrTChromeTabsEvery);
  end;
end;

initialization

  RegisterSplashScreen;

finalization

{$IFEND}

end.
