unit Unit1;

interface

uses
  OleServer, ActiveX, Classes, ComObj,
  Office_TLB, AddinDesignerObjects_TLB, Excel_TLB, Outlook_TLB, Word_TLB;

type
  TOfficeButtonClickEvent = procedure(
    const Control: OleVariant; var CancelDefault: OleVariant
  ) of object;

  TOfficeButtonClass=class of TOfficeButton;

  TOfficeButton=class(TOleServer)
  private
    FCommandBarButton: _CommandBarButton;
    FOnClick: TOfficeButtonClickEvent;
    function GetCaption: WideString;
    function GetShortCutText: WideString;
    function GetStyle: MsoButtonStyle;
    function GetTag: WideString;
    function GetVisible: WordBool;
    procedure SetCaption(const Value: WideString);
    procedure SetShortCutText(const Value: WideString);
    procedure SetStyle(const Value: MsoButtonStyle);
    procedure SetTag(const Value: WideString);
    procedure SetVisible(const Value: WordBool);
    function GetTooltipText: WideString;
    procedure SetTooltipText(const Value: WideString);
    function GetState: MsoButtonState;
    procedure SetState(const Value: MsoButtonState);
    function GetHyperlinkType: MsoCommandBarButtonHyperlinkType;
    procedure SetHyperlinkType(const Value: MsoCommandBarButtonHyperlinkType);
  protected
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
  public
    procedure Connect; override;
    procedure ConnectTo(aServerInterface: _CommandBarButton);
    procedure Disconnect; override;
    procedure Delete;

    property Caption: WideString read GetCaption write SetCaption;
    property Visible: WordBool read GetVisible write SetVisible;
    property State: MsoButtonState read GetState write SetState;
    property Style: MsoButtonStyle read GetStyle write SetStyle;
    property HyperlinkType: MsoCommandBarButtonHyperlinkType
      read GetHyperlinkType write SetHyperlinkType;
    property Tag: WideString read GetTag write SetTag;
    property ShortCutText: WideString
      read GetShortCutText write SetShortCutText;
    property TooltipText: WideString read GetTooltipText write SetTooltipText;

    property OnClick: TOfficeButtonClickEvent read FOnClick write FOnClick;
  end;



  TOfficeAddIn=class(TAutoObject, IDTExtensibility2)
  private
    FOfficeButtonClass: TOfficeButtonClass;
    FExcelApp: TExcelApplication;
    FOutlookApp: TOutlookApplication;
    FWordApp: TWordApplication;
  protected
    procedure OnConnection(
      const Application: IDispatch; ConnectMode: ext_ConnectMode;
      const AddInInst: IDispatch; var custom: PSafeArray
    ); virtual; safecall;
    procedure OnDisconnection(
      RemoveMode: ext_DisconnectMode; var custom: PSafeArray
    ); virtual; safecall;
    procedure OnAddInsUpdate(var custom: PSafeArray); virtual; safecall;
    procedure OnStartupComplete(var custom: PSafeArray); virtual; safecall;
    procedure OnBeginShutdown(var custom: PSafeArray); virtual; safecall;
    function GetCommandBar(
      aCommandBars: Office_TLB._CommandBars; aName: WideString;
      aCreateOnDemand: WordBool; aCreatePos: MsoBarPosition = msoBarFloating
    ): CommandBar;
    function GetOfficeButton(
      aCommandBar: CommandBar; aName: WideString; aCreateOnDemand: WordBool;
      aOnClick: TOfficeButtonClickEvent;
      aCreateCaption: WideString = '';
      aCreateStyle: MsoButtonStyle = msoButtonCaption;
      aCreateVisible: WordBool = True;
      aCreateControlType: MsoControlType = msoControlButton
    ): TOfficeButton;

    property OfficeButtonClass: TOfficeButtonClass
      read FOfficeButtonClass write FOfficeButtonClass;
  public
    procedure Initialize; override;

    property ExcelApp: TExcelApplication read FExcelApp;
    property OutlookApp: TOutlookApplication read FOutlookApp;
    property WordApp: TWordApplication read FWordApp;
  end;

implementation

uses
  SysUtils, Dialogs
  {$IFDEF VER140}
  , OleCtrls, Variants
  {$ENDIF}
  ;

{ TOfficeButton }

procedure TOfficeButton.Connect;
var
  PUnknown: IUnknown;
begin
//  inherited Connect;
  // connect the class to the office button
  if FCommandBarButton = nil then
  begin
    PUnknown := GetServer;
    ConnectEvents(PUnknown);
    FCommandBarButton := PUnknown as _CommandBarButton;
  end;
end;

procedure TOfficeButton.ConnectTo(aServerInterface: _CommandBarButton);
begin
  // disconnect the class from the current office button
  Disconnect;
  // connect to the new office button
  FCommandBarButton := aServerInterface;
  ConnectEvents(FCommandBarButton);
end;

procedure TOfficeButton.Delete;
begin
  // delete the button from the office bar
  FCommandBarButton.Delete(EmptyParam);
end;

procedure TOfficeButton.Disconnect;
begin
//  inherited Disconnect;
  // disconnect the class from the current office button
  if FCommandBarButton=nil then
  begin
    DisconnectEvents(FCommandBarButton);
    FCommandBarButton := nil;
  end;
end;

function TOfficeButton.GetCaption: WideString;
begin
  Result := FCommandBarButton.Caption;
end;

function TOfficeButton.GetHyperlinkType: MsoCommandBarButtonHyperlinkType;
begin
  Result := FCommandBarButton.HyperlinkType;
end;

function TOfficeButton.GetShortCutText: WideString;
begin
  Result := FCommandBarButton.ShortcutText;
end;

function TOfficeButton.GetState: MsoButtonState;
begin
  Result := FCommandBarButton.State;
end;

function TOfficeButton.GetStyle: MsoButtonStyle;
begin
  Result := FCommandBarButton.Style;
end;

function TOfficeButton.GetTag: WideString;
begin
  Result := FCommandBarButton.Tag;
end;

function TOfficeButton.GetTooltipText: WideString;
begin
  Result := FCommandBarButton.TooltipText;
end;

function TOfficeButton.GetVisible: WordBool;
begin
  Result := FCommandBarButton.Visible;
end;

procedure TOfficeButton.InvokeEvent(DispID: TDispID;
  var Params: TVariantArray);
begin
  inherited InvokeEvent(DispID, Params);
  // react to the standard office button events
  case DispID of
    -1: Exit;
     1: if Assigned(FOnClick) then
       FOnClick(Params[0], Params[1]);
  end;
end;

procedure TOfficeButton.SetCaption(const Value: WideString);
begin
  FCommandBarButton.Set_Caption(Value);
end;

procedure TOfficeButton.SetHyperlinkType(
  const Value: MsoCommandBarButtonHyperlinkType);
begin
  FCommandBarButton.Set_HyperlinkType(Value);
end;

procedure TOfficeButton.SetShortCutText(const Value: WideString);
begin
  FCommandBarButton.Set_ShortcutText(Value);
end;

procedure TOfficeButton.SetState(const Value: MsoButtonState);
begin
  FCommandBarButton.Set_State(Value);
end;

procedure TOfficeButton.SetStyle(const Value: MsoButtonStyle);
begin
  FCommandBarButton.Set_Style(Value);
end;

procedure TOfficeButton.SetTag(const Value: WideString);
begin
  FCommandBarButton.Set_Tag(Value);
end;

procedure TOfficeButton.SetTooltipText(const Value: WideString);
begin
  FCommandBarButton.Set_TooltipText(Value);
end;

procedure TOfficeButton.SetVisible(const Value: WordBool);
begin
  FCommandBarButton.Set_Visible(Value);
end;

{ TOfficeAddIn }

function TOfficeAddIn.GetCommandBar(
  aCommandBars: _CommandBars; aName: WideString; aCreateOnDemand: WordBool;
  aCreatePos: MsoBarPosition = msoBarFloating
): CommandBar;
begin
  Result := nil;
  if aCommandBars = nil then
    Exit;
  try Result := aCommandBars.Item[aName]; except end;
  if (Result = nil) and aCreateOnDemand then
    Result := aCommandBars.Add(aName, aCreatePos, EmptyParam, EmptyParam);
end;

function TOfficeAddIn.GetOfficeButton(
  aCommandBar: CommandBar; aName: WideString; aCreateOnDemand: WordBool;
  aOnClick: TOfficeButtonClickEvent; aCreateCaption: WideString;
  aCreateStyle: MsoButtonStyle; aCreateVisible: WordBool;
  aCreateControlType: MsoControlType
): TOfficeButton;
var
  OfficeButtonIntf: CommandBarControl;
begin
  Result := nil;
  if aCommandBar = nil then
    Exit;
  OfficeButtonIntf := aCommandBar.FindControl(
    EmptyParam, EmptyParam, aName, EmptyParam, EmptyParam
  );
  if OfficeButtonIntf = nil then
  begin
    if aCreateOnDemand then
    begin
      OfficeButtonIntf := aCommandBar.Controls.Add(
        aCreateControlType, EmptyParam, EmptyParam, EmptyParam, EmptyParam
      );
      Result := FOfficeButtonClass.Create(nil);
      Result.ConnectTo(OfficeButtonIntf as _CommandBarButton);
      Result.Tag := aName;
      Result.Caption := aCreateCaption;
      Result.Style := aCreateStyle;
      Result.Visible := aCreateVisible;
      Result.OnClick := aOnClick;
    end;
  end else begin
    Result := FOfficeButtonClass.Create(nil);
    Result.ConnectTo(OfficeButtonIntf as _CommandBarButton);
    Result.OnClick := aOnClick;
  end;
end;

procedure TOfficeAddIn.Initialize;
begin
  inherited Initialize;
  FOfficeButtonClass := TOfficeButton;
  FExcelApp := nil;
  FOutlookApp := nil;
  FWordApp := nil;
end;

procedure TOfficeAddIn.OnAddInsUpdate(var custom: PSafeArray);
begin
  // nothing to be done in the base class
  // will be called if the list of installed add-ins has changed
end;

procedure TOfficeAddIn.OnBeginShutdown(var custom: PSafeArray);
begin
  // nothing to be done in the base class
  // descending classes should free any memory
end;

procedure TOfficeAddIn.OnConnection(
  const Application: IDispatch; ConnectMode: ext_ConnectMode;
  const AddInInst: IDispatch; var custom: PSafeArray
);
var
  App: OleVariant;
  AppName: String;
begin
  App := Application;
  // find the type off application running that is loading the server
  AppName := LowerCase(String(App.Name));
  if Pos('outlook', AppName)=0 then
  begin
    // MS Outlook
    FOutlookApp := TOutlookApplication.Create(nil);
    FOutlookApp.ConnectTo(Application as Outlook_TLB._Application);
  end else if Pos('word', AppName)=0 then begin
    // MS Word
    FWordApp := TWordApplication.Create(nil);
    FWordApp.ConnectTo(Application as Word_TLB._Application);
  end else if Pos('excel', AppName)=0 then begin
    // MS Excel
    FExcelApp := TExcelApplication.Create(nil);
    FExcelApp.ConnectTo(Application as Excel_TLB._Application);
  end;
end;

procedure TOfficeAddIn.OnDisconnection(RemoveMode: ext_DisconnectMode;
  var custom: PSafeArray);
begin
  if Assigned(FExcelApp) then
    FreeAndNil(FExcelApp);
  if Assigned(FOutlookApp) then
    FreeAndNil(FOutlookApp);
  if Assigned(FWordApp) then
    FreeAndNil(FWordApp);
end;

procedure TOfficeAddIn.OnStartupComplete(var custom: PSafeArray);
begin
  // nothing to be done in the base class
  // descending classes should initialize itself here
end;

end.
