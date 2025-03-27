{
  IceTabSet v1.2.1
  Developed by Norbert Mereg (mereg.norbert@gmail.com)
  (Thanks for Stefan Ascher (TMDTabSet))

  Web: https://sourceforge.net/projects/icetabset/

  Description:
  This component is a 'Google Chrome style' TTabSet component for Delphi.

  Required:
  - Delphi GDI+ API (http://www.progdigy.com/files/gdiplus.zip)

  Features:
  - Show icon in tab items
  - Gradient color tab and component background
  - Close icon in tab
  - Rounded tab edges
  - Scrollable, if have more item
  - TabItems has a Modified property
  - Dragging of tabs
  - New tab button


  History:
  v1.2.1  2011.10.10:
  - modified new tab button
  v1.2.0  2011.07.08:
  - reworked scroller class
  - no flickering, Double buffered paint method

  v1.1.2  2010.11.25:
  - New feature: added dragging of tabs (Thanks for Omar Reis)
  - Fixed: changed some hard coded wast of space in the end of the texts (Thanks for Omar Reis)

  v1.1.0  2010.10.18:
  - New feature: 'New tab' button with event
  - New feature: Tab auto-width property
  - New feature: Double click event
  - Fixed: Make D7 compatible (thx for Nilson)
  - Fixed: MaxTabWidth long-text problem

  v1.0.1  2010.07.14:
  - Bug fixed: Icon draw problem, when a foreground window goes to hide.


  v1.0.0  2010.06.14 - First release.
}

unit IceTabSet;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  Menus,
  ImgList,
  GDIPAPI,
  GDIPOBJ;

type
  TIceTab=class(TCollectionItem)
  private
    fCaption:TCaption;
    fSelected:boolean;
    fData:TObject;
    fModified:boolean;
    fImageIndex:TImageIndex;
    FTag:integer;
    procedure SetSelected(Value:boolean);
    procedure SetModified(Value:boolean);
    procedure DoChange;
    procedure SetCaption(Value:TCaption);
    procedure SetImageIndex(Value:TImageIndex);
    procedure SetTag(const Value:integer);
  protected
    fStartPos:integer;
    fSize:integer;
    function GetDisplayName:string;override;
  public
    constructor Create(Collection:TCollection);override;
    destructor Destroy;override;
    property Data:TObject read fData write fData;
  published
    property Caption:TCaption read fCaption write SetCaption;
    property Selected:boolean read fSelected write SetSelected;
    property Modified:boolean read fModified write SetModified;
    property Tag:integer read FTag write SetTag default 0;
    property ImageIndex:TImageIndex read fImageIndex write SetImageIndex default -1;
  end;

  TIceTabList=class(TOwnedCollection)
  protected
    procedure DoSelected(ATab:TIceTab;ASelected:boolean);dynamic;
    procedure DoChanged(ATab:TIceTab);dynamic;
    procedure SetItem(Index:integer;Value:TIceTab);
    function GetItem(Index:integer):TIceTab;
  public
    function IndexOf(ATab:TIceTab):integer;
    property Items[Index:integer]:TIceTab read GetItem write SetItem;default;
  end;

  TScrollButton=(sbNone,sbLeft,sbRight);

  TScrollButtonClickEvent=procedure(Sender:TObject;const AButton:TScrollButton) of object;

  TBeforeShowPopupMenuEvent=procedure(Sender:TObject;ATab:TIceTab;MousePos:TPoint) of object;

  TTabSelectedEvent=procedure(Sender:TObject;ATab:TIceTab;ASelected:boolean) of object;
  TTabCloseEvent=procedure(Sender:TObject;ATab:TIceTab) of object;

  TIceTabSet=class(TCustomControl)
  private
    fTabs:TIceTabList;
    // fScroller: TIceTabScroller;
    fTabBorderColor:TColor;
    fListMenu:TPopupMenu;
    fFont:TFont;
    fSelectedFont:TFont;
    fFirstIndex:integer;
    fVisibleTabs:integer;
    fTabIndex:integer;
    fMaxTabWidth:integer;
    fImages:TCustomImageList;
    fMaintainMenu:boolean;
    fOnScrollButtonClick:TScrollButtonClickEvent;
    fOnTabSelected:TTabSelectedEvent;
    FTabHeight:integer;
    FEdgeWidth:integer;
    FCloseTab:boolean;
    FTabStopColor:TColor;
    FTabStartColor:TColor;
    FSelectedTabStopColor:TColor;
    FSelectedTabStartColor:TColor;
    FModifiedTabStopColor:TColor;
    FModifiedTabStartColor:TColor;
    FTabCloseColor:TColor;
    FModifiedFont:TFont;
    FBackgroundStopColor:TColor;
    FBackgroundStartColor:TColor;
    FOnBeforeShowPopupMenu:TBeforeShowPopupMenuEvent;
    FOnTabClose:TTabCloseEvent;
    FHighlightTabClose:TIceTab;
    FOnDblClick:TTabCloseEvent;
    FShowNewTab:boolean;
    FAutoTabWidth:boolean;
    FNewButtonArea:TRect;
    FHighlightNewButton:boolean;
    FOnNewButtonClick:TNotifyEvent;
    // Om: tab drag functionality
    fCanDragTabs:boolean;
    fIxTabStartDrag:integer; // move tab "from" index
    fIxTabEndDrag:integer; // move tab "to" index
    fTabDragPointerVisible:boolean;
    // /tab drag

    // Scroll variables
    fScrollWidth:integer;
    fScrollHeight:integer;
    fScrollLeft:integer;
    fScrollTop:integer;
    fScrollPushed:TScrollButton;
    FArrowColor:TColor;
    FArrowHighlightColor:TColor;

    procedure ScrollClick(const AButton:TScrollButton);
    function GetTabHeight:integer;
    procedure SetTab(NewTab:TIceTab);
    procedure SetTabIndex(Value:integer); // overload;
    // procedure SetTabIndex(NewTab: TIceTab); overload;
    function CalcTabPositions(Start,Stop:integer;Canvas:TCanvas;JumpTab:TIceTab):integer;

    function GetSelected:TIceTab;
    procedure SetSelected(Value:TIceTab);
    procedure SetFont(Value:TFont);
    procedure SetSelectedFont(Value:TFont);
    procedure SetTabBorderColor(Value:TColor);
    procedure WMSize(var Message:TWMSize);message WM_SIZE;
    procedure WMLButtonDblClk(var Message:TWMLButtonDblClk);message WM_LBUTTONDBLCLK;
    procedure SetMaxTabWidth(Value:integer);
    procedure SetTabHeight(const Value:integer);
    function GetGDIPFont(Canvas:TCanvas;Font:TFont):TGPFont;
    function GetTextSize(Canvas:TCanvas;Font:TGPFont;Text:string):TSize;
    procedure SetEdgeWidth(const Value:integer);
    procedure SetCloseTab(const Value:boolean);
    procedure SetTabStartColor(const Value:TColor);
    procedure SetTabStopColor(const Value:TColor);
    procedure SetSelectedTabStartColor(const Value:TColor);
    procedure SetSelectedTabStopColor(const Value:TColor);
    procedure SetModifiedTabStartColor(const Value:TColor);
    procedure SetModifiedTabStopColor(const Value:TColor);
    procedure SetTabCloseColor(const Value:TColor);
    procedure SetModifiedFont(const Value:TFont);
    procedure SetBackgroundStartColor(const Value:TColor);
    procedure SetBackgroundStopColor(const Value:TColor);
    procedure SetImages(const Value:TCustomImageList);
    procedure SetOnBeforeShowPopupMenu(const Value:TBeforeShowPopupMenuEvent);
    function IsInCloseButton(ATab:TIceTab;X,Y:integer):boolean;
    procedure SetOnTabClose(const Value:TTabCloseEvent);
    procedure SetHighlightTabClose(const Value:TIceTab);
    procedure ClearSelection;
    procedure InnerDraw(Canvas:TCanvas;TabRect:TRect;Item:TIceTab);
    procedure SetArrowColor(const Value:TColor);
    procedure SetOnDblClick(const Value:TTabCloseEvent);
    procedure SetShowNewTab(const Value:boolean);
    procedure SetAutoTabWidth(const Value:boolean);
    procedure DrawNewButton(Canvas:TCanvas);
    procedure SetHighlightNewButton(const Value:boolean);
    procedure SetOnNewButtonClick(const Value:TNotifyEvent);
    procedure DrawDragTabPointer(aTabIndex:integer);
    procedure DrawScroll(Canvas:TCanvas);
    procedure DrawScrollLeftArrow(Canvas:TCanvas;X,Y:integer;Button:TScrollButton;State:boolean);
    procedure DrawScrollRightArrow(Canvas:TCanvas;X,Y:integer;Button:TScrollButton;State:boolean);
    procedure SetArrowHighlightColor(const Value:TColor); // Om:
  protected
    property HighlightTabClose:TIceTab read FHighlightTabClose write SetHighlightTabClose;
    property HighlightNewButton:boolean read FHighlightNewButton write SetHighlightNewButton;

    procedure CreateParams(var Params:TCreateParams);override;
    procedure Paint;override;

    procedure ShowRightPopup(Sender:TObject;MousePos:TPoint;var Handled:boolean);

    procedure DoOnScrollButtonClick(const AButton:TScrollButton);dynamic;
    procedure TabSelected(ATab:TIceTab;ASelected:boolean);dynamic;

    procedure MouseDown(Button:TMouseButton;Shift:TShiftState;X,Y:integer);override;

    procedure MouseMove(Shift:TShiftState;X:integer;Y:integer);override;
    procedure CMHintShow(var Message:TCMHintShow);message CM_HINTSHOW;
    procedure MouseUp(Button:TMouseButton;Shift:TShiftState;X:integer;Y:integer);override;
    procedure DragOver(Source:TObject;X,Y:integer;State:TDragState;var Accept:boolean);override;
    // Om:
    procedure DragDrop(Source:TObject;X,Y:integer);override; // Om:
    procedure DoTabEndDrag; // Om:
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;

    procedure DoDoubleClick(ATab:TIceTab);
    function GetButtonRect(const AButton:TScrollButton):TRect;
    function GetItemFromPos(X,Y:integer):TIceTab;
    procedure LookThisTab(ATab:TIceTab);

    function AddTab(const ACaption:string;const ImageIndex:integer=-1;
      const Data:TObject=nil):TIceTab;
    function RemoveTab(ATab:TIceTab):integer;
    procedure SelectNext(ANext:boolean);
    function IndexOfTabData(Data:TObject):integer;

    property Selected:TIceTab read GetSelected write SetSelected;
  published
    property Align;
    property Anchors;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Visible;

    property Font:TFont read fFont write SetFont;
    property SelectedFont:TFont read fSelectedFont write SetSelectedFont;
    property ModifiedFont:TFont read FModifiedFont write SetModifiedFont;
    property Tabs:TIceTabList read fTabs write fTabs;
    property TabIndex:integer read fTabIndex write SetTabIndex default -1;
    property TabBorderColor:TColor read fTabBorderColor write SetTabBorderColor
      default clInactiveCaptionText;
    property ListMenu:TPopupMenu read fListMenu write fListMenu;
    property Images:TCustomImageList read fImages write SetImages;
    property MaintainMenu:boolean read fMaintainMenu write fMaintainMenu;
    property MaxTabWidth:integer read fMaxTabWidth write SetMaxTabWidth default 0;
    property TabHeight:integer read FTabHeight write SetTabHeight default 24;
    property EdgeWidth:integer read FEdgeWidth write SetEdgeWidth default 20;
    property CloseTab:boolean read FCloseTab write SetCloseTab default true;
    property ShowNewTab:boolean read FShowNewTab write SetShowNewTab default false;
    property TabCloseColor:TColor read FTabCloseColor write SetTabCloseColor default clMedGray;
    property ArrowColor:TColor read FArrowColor write SetArrowColor default clBlack;
    property ArrowHighlightColor:TColor read FArrowHighlightColor write SetArrowHighlightColor
      default cl3DLight;
    property AutoTabWidth:boolean read FAutoTabWidth write SetAutoTabWidth default true;

    property TabStartColor:TColor read FTabStartColor write SetTabStartColor
      default clActiveCaption;
    property TabStopColor:TColor read FTabStopColor write SetTabStopColor default clActiveCaption;

    property SelectedTabStartColor:TColor read FSelectedTabStartColor write SetSelectedTabStartColor
      default clWhite;
    property SelectedTabStopColor:TColor read FSelectedTabStopColor write SetSelectedTabStopColor
      default cl3DLight;

    property ModifiedTabStartColor:TColor read FModifiedTabStartColor
      write SetModifiedTabStartColor;
    property ModifiedTabStopColor:TColor read FModifiedTabStopColor write SetModifiedTabStopColor;

    property BackgroundStartColor:TColor read FBackgroundStartColor write SetBackgroundStartColor
      default clInactiveCaption;
    property BackgroundStopColor:TColor read FBackgroundStopColor write SetBackgroundStopColor
      default clInactiveCaption;

    property CanDragTabs:boolean read fCanDragTabs write fCanDragTabs;
    // Om: tabs can be moved by dragging

    property OnClick;
    property OnDblClick:TTabCloseEvent read FOnDblClick write SetOnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;

    property OnScrollButtonClick:TScrollButtonClickEvent read fOnScrollButtonClick
      write fOnScrollButtonClick;
    property OnTabSelected:TTabSelectedEvent read fOnTabSelected write fOnTabSelected;
    property OnBeforeShowPopupMenu:TBeforeShowPopupMenuEvent read FOnBeforeShowPopupMenu
      write SetOnBeforeShowPopupMenu;
    property OnTabClose:TTabCloseEvent read FOnTabClose write SetOnTabClose;
    property OnNewButtonClick:TNotifyEvent read FOnNewButtonClick write SetOnNewButtonClick;
  end;

procedure Register;

implementation

uses
  CommCtrl,
  Consts,
  Math;

const
  BMP_SIZE=12;
  BTN_MARGIN=2;
  BTN_SIZE=BMP_SIZE+BTN_MARGIN*2;

procedure Register;
begin
  RegisterComponents('IcePackage',[TIceTabSet]);
end;

function MakeGDIPColor(C:TColor):Cardinal;
var
  tmpRGB:TColorRef;
begin
  tmpRGB:=ColorToRGB(C);
  result:=((DWORD(GetBValue(tmpRGB)) shl BlueShift)or(DWORD(GetGValue(tmpRGB)) shl GreenShift)or
    (DWORD(GetRValue(tmpRGB)) shl RedShift)or(DWORD(255) shl AlphaShift));
end;

{ TIceTab }

constructor TIceTab.Create(Collection:TCollection);
begin
  inherited;
  fImageIndex:=-1;
end;

destructor TIceTab.Destroy;
begin
  inherited;
end;

procedure TIceTab.SetModified(Value:boolean);
begin
  if fModified<>Value then begin
    fModified:=Value;
    DoChange;
  end;
end;

procedure TIceTab.SetSelected(Value:boolean);
var
  i:integer;
begin
  if fSelected<>Value then begin
    fSelected:=Value;
    if fSelected then begin
      with (GetOwner as TIceTabList) do begin
        for i:=0 to Count-1 do begin
          // Only one can be selected
          if (Items[i]<>Self)and(Items[i].Selected) then begin
            Items[i].Selected:=false;
          end;
        end;
      end;
    end;
    (Collection as TIceTabList).DoSelected(Self,fSelected);
  end;
end;

procedure TIceTab.SetTag(const Value:integer);
begin
  FTag:=Value;
end;

function TIceTab.GetDisplayName:string;
begin
  if fCaption<>'' then result:=fCaption
  else result:=inherited GetDisplayName;
end;

procedure TIceTab.DoChange;
begin
  (Collection as TIceTabList).DoChanged(Self)
end;

procedure TIceTab.SetCaption(Value:TCaption);
begin
  if fCaption<>Value then begin
    fCaption:=Value;
    DoChange;
  end;
end;

procedure TIceTab.SetImageIndex(Value:TImageIndex);
begin
  if fImageIndex<>Value then begin
    fImageIndex:=Value;
    DoChange;
  end;
end;

{ TIceTabList }

procedure TIceTabList.DoSelected(ATab:TIceTab;ASelected:boolean);
begin
  (GetOwner as TIceTabSet).TabSelected(ATab,ASelected);
end;

procedure TIceTabList.DoChanged(ATab:TIceTab);
begin
  (GetOwner as TIceTabSet).Invalidate;
end;

procedure TIceTabList.SetItem(Index:integer;Value:TIceTab);
begin
  inherited SetItem(Index,Value);
end;

function TIceTabList.GetItem(Index:integer):TIceTab;
begin
  result:=inherited GetItem(Index) as TIceTab;
end;

function TIceTabList.IndexOf(ATab:TIceTab):integer;
var
  i,C:integer;
begin
  C:=Count;
  for i:=0 to C-1 do
    if Items[i]=ATab then begin
      result:=i;
      Exit;
    end;
  result:=-1;
end;

{ TMDTabSet }

constructor TIceTabSet.Create(AOwner:TComponent);
begin
  inherited;
  ControlStyle:=[csCaptureMouse,csDoubleClicks,csOpaque];
  Width:=185;
  Height:=30;
  FTabHeight:=24;
  FEdgeWidth:=20;
  FCloseTab:=true;
  FShowNewTab:=false;
  FHighlightNewButton:=false;
  AutoTabWidth:=true;
  Align:=alTop;
  FHighlightTabClose:=nil;

  OnContextPopup:=ShowRightPopup;

  fTabs:=TIceTabList.Create(Self,TIceTab);
  fFont:=TFont.Create;
  fFont.Color:=clWhite;
  FModifiedFont:=TFont.Create;
  FModifiedFont.Color:=$00B3B3FF;
  fSelectedFont:=TFont.Create;
  fSelectedFont.Color:=clBlack;
  fTabBorderColor:=$00706453;
  FTabCloseColor:=$00B8AFA9;
  FArrowColor:=clBlack;
  FArrowHighlightColor:=$00EAE6E1;

  FBackgroundStartColor:=$00C8BDB0;
  FBackgroundStopColor:=$00C8BDB0;

  FTabStartColor:=$00A19078;
  FTabStopColor:=$00A19078;

  FSelectedTabStartColor:=$00FBF9F7;
  FSelectedTabStopColor:=$00EAE6E1;

  FModifiedTabStartColor:=$00A19078;
  FModifiedTabStopColor:=$00A19078;

  fTabIndex:=-1;

  fScrollPushed:=sbNone;
  fScrollWidth:=BTN_SIZE*2+1;
  fScrollHeight:=BTN_SIZE;
  fScrollTop:=(Height div 2)-(fScrollHeight div 2);
  fScrollLeft:=Width-fScrollWidth-1;

  fCanDragTabs:=true; // Om: default=allow tab dragging
  fIxTabStartDrag:=-1; // Om: -1=none
  fIxTabEndDrag:=-1; // Om: -1=none
  fTabDragPointerVisible:=false; // Om: drag tab pointer is a little triangle
end;

destructor TIceTabSet.Destroy;
begin
  fTabs.Free;
  fFont.Free;
  fSelectedFont.Free;
  FModifiedFont.Free;
  inherited;
end;

procedure TIceTabSet.CreateParams(var Params:TCreateParams);
begin
  inherited CreateParams(Params);
  with Params.WindowClass do begin
    style:=style and not(CS_VREDRAW or CS_HREDRAW);
  end;
end;

procedure TIceTabSet.ScrollClick(const AButton:TScrollButton);
begin
  case AButton of
    sbLeft: if fFirstIndex>0 then fFirstIndex:=fFirstIndex-1;
    sbRight: if fFirstIndex<fTabs.Count-fVisibleTabs then fFirstIndex:=fFirstIndex+1;
  end;
  DoOnScrollButtonClick(AButton);
end;

procedure TIceTabSet.DoDoubleClick(ATab:TIceTab);
begin
  if Assigned(OnDblClick) then OnDblClick(Self,ATab);
end;

procedure TIceTabSet.DoOnScrollButtonClick(const AButton:TScrollButton);
begin
  if Assigned(fOnScrollButtonClick) then fOnScrollButtonClick(Self,AButton);
end;

function TIceTabSet.CalcTabPositions(Start,Stop:integer;Canvas:TCanvas;JumpTab:TIceTab):integer;
var
  Index:integer;
  W:integer;
  tw:integer;
  Tab:TIceTab;
  actFont,prevFont:TGPFont;
  MaxTabWidth,OrigStart:integer;
  reqWidth:integer;
  bJumped:boolean;

  procedure ClearTabPositions;
  var
    i:integer;
  begin
    for i:=0 to fTabs.Count-1 do begin
      fTabs[i].fStartPos:=0;
      fTabs[i].fSize:=0;
    end;
  end;

begin
  bJumped:=false;
  ClearTabPositions;

  if Assigned(JumpTab)and(JumpTab.Index<fFirstIndex) then fFirstIndex:=JumpTab.Index;
  Index:=fFirstIndex;
  OrigStart:=Start;

  if not Assigned(JumpTab) then bJumped:=true;

  // Get the largest font width for the tabs
  actFont:=GetGDIPFont(Canvas,fFont);
  tw:=GetTextSize(Canvas,actFont,'WOWOWOWOWOWOWOW').cx;
  actFont.Free;
  actFont:=GetGDIPFont(Canvas,fSelectedFont);
  if tw>GetTextSize(Canvas,actFont,'WOWOWOWOWOWOWOW').cx then begin
    actFont.Free;
    actFont:=GetGDIPFont(Canvas,fFont);
  end;
  prevFont:=actFont;
  actFont:=GetGDIPFont(Canvas,FModifiedFont);
  if tw>GetTextSize(Canvas,actFont,'WOWOWOWOWOWOWOW').cx then begin
    actFont.Free;
    actFont:=prevFont;
  end
  else prevFont.Free;

  MaxTabWidth:=0;
  if FAutoTabWidth and(fTabs.Count>0) then MaxTabWidth:=(Stop div fTabs.Count)+FEdgeWidth;
  if (fMaxTabWidth>0)and(MaxTabWidth>fMaxTabWidth) then MaxTabWidth:=fMaxTabWidth;

  while (Start<Stop)and(Index<fTabs.Count) do begin
    Tab:=fTabs[Index];
    Tab.fStartPos:=Start;
    W:=GetTextSize(Canvas,actFont,Tab.Caption).cx+FEdgeWidth*2+10;
    // W := GetTextSize(Canvas, actFont, Tab.Caption).cx + fEdgeWidth * 2 - 1 ;   //Om: nov10: commented '+ 10' in the end.  Added '-1' instead...
    if FCloseTab then Inc(W,10);
    if Assigned(fImages)and(Tab.ImageIndex>-1) then begin
      Inc(W,fImages.Width+4);
    end;
    if (MaxTabWidth>0)and(W>MaxTabWidth) then W:=MaxTabWidth;

    // Calculate minimum tab width;
    reqWidth:=FEdgeWidth*2;
    if FCloseTab then Inc(reqWidth,10);
    if Assigned(fImages)and(Tab.ImageIndex>-1) then Inc(reqWidth,fImages.Width+4);
    if W<reqWidth then W:=reqWidth;

    Tab.fSize:=W;
    Inc(Start,Tab.fSize-FEdgeWidth); { next usable position }
    if Tab=JumpTab then bJumped:=true;

    if Start<=Stop then Inc(Index)
    else begin
      Tab.fStartPos:=0;
      Tab.fSize:=0;
      if not bJumped or(Tab=JumpTab) then begin
        ClearTabPositions;
        Inc(fFirstIndex);
        Index:=fFirstIndex;
        Start:=OrigStart;
        bJumped:=false;
      end;
    end;
  end;
  result:=Index-fFirstIndex;
  actFont.Free;
end;

procedure TIceTabSet.CMHintShow(var Message:TCMHintShow);
var
  Item:TIceTab;
begin
  Item:=GetItemFromPos(Message.HintInfo^.CursorPos.X,Message.HintInfo^.CursorPos.Y);
  if Assigned(Item) then Message.HintInfo^.HintStr:=Item.Caption;
end;

function TIceTabSet.GetGDIPFont(Canvas:TCanvas;Font:TFont):TGPFont;
var
  style:integer;
begin
  style:=FontStyleRegular;
  if fsBold in Font.style then style:=style+FontStyleBold;
  if fsItalic in Font.style then style:=style+FontStyleItalic;
  if fsUnderLine in Font.style then style:=style+FontStyleUnderline;
  if fsStrikeOut in Font.style then style:=style+FontStyleStrikeout;

  result:=TGPFont.Create(Font.Name,Font.Size,style,UnitPoint);
end;

function TIceTabSet.GetTextSize(Canvas:TCanvas;Font:TGPFont;Text:string):TSize;
var
  Graphics:TGPGraphics;
  rect:TGPRectF;
begin
  Graphics:=TGPGraphics.Create(Canvas.Handle);
  Graphics.MeasureString(Text,-1,Font,MakePoint(0.0,0.0),rect);
  result.cx:=Round(rect.Width);
  result.cy:=Round(rect.Height);

  Graphics.Free;
end;

procedure TIceTabSet.Paint;
var
  i:integer;
  TabStart,LastTabPos:integer;
  Tab:TIceTab;
  TabHeight:integer;

  Graphics:TGPGraphics;
  linGrBrush:TGPLinearGradientBrush;

  fBuffer:TBitmap;
begin
  if not HandleAllocated then Exit;

  fBuffer:=TBitmap.Create;
  fBuffer.SetSize(ClientRect.Right-ClientRect.Left,ClientRect.Bottom-ClientRect.Top);

  Graphics:=TGPGraphics.Create(fBuffer.Canvas.Handle);

  linGrBrush:=TGPLinearGradientBrush.Create(MakePoint(0,ClientRect.Top),
    MakePoint(0,ClientRect.Bottom),MakeGDIPColor(FBackgroundStartColor),
    MakeGDIPColor(FBackgroundStopColor));
  Graphics.FillRectangle(linGrBrush,MakeRect(ClientRect));

  linGrBrush.Free;
  Graphics.Free;

  TabStart:=0;
  LastTabPos:=Width-fScrollWidth;
  if FShowNewTab then Dec(LastTabPos,FEdgeWidth+10);
  fVisibleTabs:=CalcTabPositions(TabStart,LastTabPos-FEdgeWidth,fBuffer.Canvas,nil);
  TabHeight:=GetTabHeight;

  { fScroller.Min := 0;
    fScroller.Max := fTabs.Count - fVisibleTabs;
    fScroller.Position := fFirstIndex; }

  // Draw all not selected tab
  for i:=fFirstIndex+fVisibleTabs-1 downto fFirstIndex do begin
    Tab:=fTabs[i];
    if not Tab.Selected then
        InnerDraw(fBuffer.Canvas,rect(Tab.fStartPos,ClientHeight-TabHeight,Tab.fStartPos+Tab.fSize,
        ClientHeight),Tab);
  end;

  // Draw the selected tab
  if Assigned(Selected)and(Selected.fSize>0) then
      InnerDraw(fBuffer.Canvas,rect(Selected.fStartPos,ClientHeight-TabHeight,
      Selected.fStartPos+Selected.fSize,ClientHeight),Selected);

  if FShowNewTab then DrawNewButton(fBuffer.Canvas);

  DrawScroll(fBuffer.Canvas);

  Canvas.Draw(ClientRect.Left,ClientRect.Top,fBuffer);
  fBuffer.Free;
end;

procedure TIceTabSet.DrawScroll(Canvas:TCanvas);
begin
  if fFirstIndex>0 then
      DrawScrollLeftArrow(Canvas,fScrollLeft+BTN_MARGIN,fScrollTop+BTN_MARGIN,sbLeft,
      fScrollPushed=sbLeft);

  if fFirstIndex<fTabs.Count-fVisibleTabs then
      DrawScrollRightArrow(Canvas,fScrollLeft+BTN_SIZE+BTN_MARGIN,fScrollTop+BTN_MARGIN,sbRight,
      fScrollPushed=sbRight);
end;

procedure TIceTabSet.DrawScrollRightArrow(Canvas:TCanvas;X,Y:integer;Button:TScrollButton;
  State:boolean);
var
  Graphics:TGPGraphics;
  path:TGPGraphicsPath;
  brush:TGPSolidBrush;
  innerRect:TRect;
begin
  if State then begin
    Canvas.brush.Color:=FArrowHighlightColor;
    Canvas.Rectangle(X-BTN_MARGIN,Y-1,X+BTN_SIZE-BTN_MARGIN,Y+BTN_SIZE);
  end;

  Graphics:=TGPGraphics.Create(Canvas.Handle);
  Graphics.SetSmoothingMode(SmoothingModeAntiAlias);

  path:=TGPGraphicsPath.Create();
  innerRect:=rect(X+2,Y+2,X+2+6,Y+2+8);
  path.AddLine(innerRect.Left,innerRect.Top,innerRect.Right,innerRect.Top+4);
  path.AddLine(innerRect.Right,innerRect.Top+4,innerRect.Left,innerRect.Bottom);
  path.AddLine(innerRect.Left,innerRect.Bottom,innerRect.Left,innerRect.Top);

  brush:=TGPSolidBrush.Create(MakeGDIPColor(FArrowColor));
  Graphics.FillPath(brush,path);

  brush.Free;
  path.Free;
  Graphics.Free;
end;

procedure TIceTabSet.DrawScrollLeftArrow(Canvas:TCanvas;X,Y:integer;Button:TScrollButton;
  State:boolean);
var
  Graphics:TGPGraphics;
  path:TGPGraphicsPath;
  brush:TGPSolidBrush;
  innerRect:TRect;
begin
  if State then begin
    Canvas.brush.Color:=FArrowHighlightColor;
    Canvas.Rectangle(X,Y-1,X+BTN_SIZE,Y+BTN_SIZE);
  end;

  Graphics:=TGPGraphics.Create(Canvas.Handle);
  Graphics.SetSmoothingMode(SmoothingModeAntiAlias);

  path:=TGPGraphicsPath.Create();
  innerRect:=rect(X+3,Y+2,X+3+6,Y+2+8);
  path.AddLine(innerRect.Right,innerRect.Top,innerRect.Left,innerRect.Top+4);
  path.AddLine(innerRect.Left,innerRect.Top+4,innerRect.Right,innerRect.Bottom);
  path.AddLine(innerRect.Right,innerRect.Bottom,innerRect.Right,innerRect.Top);

  brush:=TGPSolidBrush.Create(MakeGDIPColor(FArrowColor));
  Graphics.FillPath(brush,path);

  brush.Free;
  path.Free;
  Graphics.Free;
end;

procedure TIceTabSet.DrawNewButton(Canvas:TCanvas);
var
  Graphics:TGPGraphics;
  Pen:TGPPen;
  path,linePath:TGPGraphicsPath;
  linGrBrush:TGPLinearGradientBrush;
  solidBrush:TGPSolidBrush;
  borderColor:Cardinal;
  TabHeight,LastPos:integer;
  X1,Y1,X2,Y2,FixLine:integer;
  dX,dY:Extended;
  signW,i:integer;
  plusSign: array [0..12] of TGPPointF;
  fillColor1,fillColor2,plusColor:Cardinal;
  NBPath: array [0..8] of TGPPointF;
begin
  Graphics:=TGPGraphics.Create(Canvas.Handle);
  Graphics.SetSmoothingMode(SmoothingModeAntiAlias);

  if FHighlightNewButton then begin
    fillColor1:=MakeColor(160,255,255,255);
    fillColor2:=MakeColor(128,255,255,255);
    plusColor:=MakeColor(255,255,255,255);
  end else begin
    fillColor1:=MakeColor(128,255,255,255);
    fillColor2:=MakeColor(64,255,255,255);
    plusColor:=MakeColor(200,255,255,255);
  end;

  borderColor:=MakeGDIPColor(fTabBorderColor); // MakeColor(255, 83, 100, 112);
  Pen:=TGPPen.Create(borderColor);

  LastPos:=Width-fScrollWidth;
  TabHeight:=GetTabHeight;
  FixLine:=14;

  X1:=0;
  for i:=fFirstIndex+fVisibleTabs-1 downto fFirstIndex do
    if (fTabs[i].fStartPos+fTabs[i].fSize)>X1 then X1:=fTabs[i].fStartPos+fTabs[i].fSize;

  X2:=X1+20;
  Y1:=ClientHeight-TabHeight+((TabHeight-15)div 2);
  Y2:=Y1+15;
  // X1 := LastPos - fEdgeWidth;
  { Y1 := ClientHeight - TabHeight + 3;
    X2 := X1 + FixLine + fEdgeWidth div 2 + 5;
    Y2 := Y1 + TabHeight - 8; }

  FNewButtonArea:=rect(X1,Y1,X2,Y2);

  path:=TGPGraphicsPath.Create();

  NBPath[0].X:=X1+3;
  NBPath[0].Y:=Y2;
  NBPath[1].X:=X1;
  NBPath[1].Y:=Y2-2;
  NBPath[2].X:=X1-4;
  NBPath[2].Y:=Y1+2;
  NBPath[3].X:=X1-3;
  NBPath[3].Y:=Y1;
  NBPath[4].X:=X2-7;
  NBPath[4].Y:=Y1;
  NBPath[5].X:=X2-4;
  NBPath[5].Y:=Y1+2;
  NBPath[6].X:=X2;
  NBPath[6].Y:=Y2-2;
  NBPath[7].X:=X2;
  NBPath[7].Y:=Y2;

  path.AddPolygon(PGPPointF(@NBPath),8);

  { path.AddLine(X1, Y1, X1 + FixLine, Y1);
    path.AddBezier(
    X1 + FixLine, Y1, X2 - 2, Y1 + 1,
    X2 - 2, Y2, X2, Y2);
    path.AddLine(X2, Y2, X2 - FixLine, Y2);
    path.AddBezier(
    X2 - FixLine, Y2, X1 - 2, Y2 - 1,
    X1 + 2, Y1, X1, Y1); }

  linePath:=TGPGraphicsPath.Create();
  linePath.AddPath(path,false);

  linGrBrush:=TGPLinearGradientBrush.Create(MakePoint(0,Y1),MakePoint(0,Y2),fillColor1,fillColor2);

  Graphics.DrawPath(Pen,linePath);
  Graphics.FillPath(linGrBrush,path);

  // Draw + sign
  signW:=3;
  dX:=8-signW*1.5;
  dY:=signW;

  plusSign[0]:=MakePoint(X1+dX,Y1+dY+signW);
  plusSign[1]:=MakePoint(X1+dX+signW,Y1+dY+signW);
  plusSign[2]:=MakePoint(X1+dX+signW,Y1+dY);
  plusSign[3]:=MakePoint(X1+dX+signW*2,Y1+dY);
  plusSign[4]:=MakePoint(X1+dX+signW*2,Y1+dY+signW);
  plusSign[5]:=MakePoint(X1+dX+signW*3,Y1+dY+signW);
  plusSign[6]:=MakePoint(X1+dX+signW*3,Y1+dY+signW*2);
  plusSign[7]:=MakePoint(X1+dX+signW*2,Y1+dY+signW*2);
  plusSign[8]:=MakePoint(X1+dX+signW*2,Y1+dY+signW*3);
  plusSign[9]:=MakePoint(X1+dX+signW,Y1+dY+signW*3);
  plusSign[10]:=MakePoint(X1+dX+signW,Y1+dY+signW*2);
  plusSign[11]:=MakePoint(X1+dX,Y1+dY+signW*2);
  plusSign[12]:=MakePoint(X1+dX,Y1+dY+signW);

  path.Reset;
  path.AddLines(PGPPointF(@plusSign),13);

  linePath.Reset;
  linePath.AddPath(path,false);

  solidBrush:=TGPSolidBrush.Create(plusColor);

  Graphics.DrawPath(Pen,linePath);
  Graphics.FillPath(solidBrush,path);

  Pen.Free;
  linePath.Free;
  path.Free;
  linGrBrush.Free;
  solidBrush.Free;
  Graphics.Free;
end;

procedure TIceTabSet.InnerDraw(Canvas:TCanvas;TabRect:TRect;Item:TIceTab);
var
  Graphics:TGPGraphics;
  Pen:TGPPen;
  path,linePath:TGPGraphicsPath;
  linGrBrush:TGPLinearGradientBrush;

  Font:TGPFont;
  pointF:TGPPointF;
  solidBrush,mainBrush:TGPSolidBrush;

  rectF:TGPRectF;
  stringFormat:TGPStringFormat;
  DC:HDC;
  marginRight:integer;

  iconY,iconX:integer;
  textStart:Extended;

  startColor,EndColor,textColor,borderColor:Cardinal;
begin
  DC:=Canvas.Handle;

  if Item.Selected then begin
    startColor:=MakeGDIPColor(FSelectedTabStartColor); // MakeColor(255, 247, 249, 251);
    EndColor:=MakeGDIPColor(FSelectedTabStopColor); // MakeColor(255, 225, 230, 234);
    textColor:=MakeGDIPColor(fSelectedFont.Color); // MakeColor(255, 0, 0, 0);
  end else if Item.Modified then begin
    startColor:=MakeGDIPColor(FModifiedTabStartColor);
    EndColor:=MakeGDIPColor(FModifiedTabStopColor);
    textColor:=MakeGDIPColor(FModifiedFont.Color);
  end else begin
    startColor:=MakeGDIPColor(FTabStartColor);
    EndColor:=MakeGDIPColor(FTabStopColor);
    textColor:=MakeGDIPColor(fFont.Color); // MakeColor(255, 255, 255, 255);
  end;
  borderColor:=MakeGDIPColor(fTabBorderColor); // MakeColor(255, 83, 100, 112);

  Graphics:=TGPGraphics.Create(DC);
  Graphics.SetSmoothingMode(SmoothingModeAntiAlias);
  Pen:=TGPPen.Create(borderColor);

  path:=TGPGraphicsPath.Create();
  path.AddBezier(TabRect.Left,TabRect.Bottom,TabRect.Left+FEdgeWidth/2,TabRect.Bottom,
    TabRect.Left+FEdgeWidth/2,TabRect.Top,TabRect.Left+FEdgeWidth,TabRect.Top);
  path.AddLine(TabRect.Left+FEdgeWidth,TabRect.Top,TabRect.Right-FEdgeWidth,TabRect.Top);
  path.AddBezier(TabRect.Right-FEdgeWidth,TabRect.Top,TabRect.Right-FEdgeWidth/2,TabRect.Top,
    TabRect.Right-FEdgeWidth/2,TabRect.Bottom,TabRect.Right,TabRect.Bottom);
  linePath:=TGPGraphicsPath.Create();
  linePath.AddPath(path,false);
  path.AddLine(TabRect.Right,TabRect.Bottom,TabRect.Left,TabRect.Bottom);

  linGrBrush:=TGPLinearGradientBrush.Create(MakePoint(0,TabRect.Top),MakePoint(0,TabRect.Bottom),
    startColor,EndColor);

  Graphics.DrawPath(Pen,linePath);
  Graphics.FillPath(linGrBrush,path);

  marginRight:=0;
  if FCloseTab then begin
  /// /////////////////////////////////
    Pen.SetWidth(2);
    if HighlightTabClose=Item then Pen.SetColor(MakeGDIPColor(clRed))
    else Pen.SetColor(MakeGDIPColor(FTabCloseColor));

    Graphics.DrawLine(Pen,TabRect.Right-FEdgeWidth-7,
      TabRect.Top+((TabRect.Bottom-TabRect.Top-7)div 2),TabRect.Right-FEdgeWidth,
      TabRect.Top+((TabRect.Bottom-TabRect.Top+7)div 2));

    Graphics.DrawLine(Pen,TabRect.Right-FEdgeWidth,
      TabRect.Top+((TabRect.Bottom-TabRect.Top-7)div 2),TabRect.Right-FEdgeWidth-7,
      TabRect.Top+((TabRect.Bottom-TabRect.Top+7)div 2));
    marginRight:=10;
  end;

  if Item.Selected then Font:=GetGDIPFont(Canvas,fSelectedFont)
  else if Item.Modified then Font:=GetGDIPFont(Canvas,FModifiedFont)
  else Font:=GetGDIPFont(Canvas,fFont);

  solidBrush:=TGPSolidBrush.Create(textColor);
  stringFormat:=TGPStringFormat.Create;
  stringFormat.SetAlignment(StringAlignmentNear);
  stringFormat.SetLineAlignment(StringAlignmentCenter);
  stringFormat.SetTrimming(StringTrimmingEllipsisCharacter);
  stringFormat.SetFormatFlags(StringFormatFlagsNoWrap);

  SelectClipRgn(Canvas.Handle,0);
  textStart:=TabRect.Left+FEdgeWidth;
  if Assigned(Images)and(Item.ImageIndex<>-1) then begin
    iconY:=TabRect.Top+((TabRect.Bottom-TabRect.Top-Images.Height)div 2);
    iconX:=Round(textStart);
    textStart:=textStart+Images.Width+4;
  end;

  rectF:=MakeRect(textStart,TabRect.Top,TabRect.Right-textStart-FEdgeWidth-marginRight,
    TabRect.Bottom-TabRect.Top);
  // graphics.SetClip(rectF);
  if rectF.Width>10 then Graphics.DrawString(Item.Caption,-1,Font,rectF,stringFormat,solidBrush);
  // graphics.ResetClip;

  // mainBrush := TGPSolidBrush.Create(endColor);

  Font.Free;
  solidBrush.Free;
  linGrBrush.Free;
  linePath.Free;
  path.Free;
  Pen.Free;
  Graphics.Free;

  if Assigned(Images)and(Item.ImageIndex<>-1) then
      Images.Draw(Canvas,iconX,iconY,Item.ImageIndex,true);
end;

procedure TIceTabSet.SetCloseTab(const Value:boolean);
begin
  if FCloseTab<>Value then begin
    FCloseTab:=Value;
    Invalidate;
  end;
end;

procedure TIceTabSet.SetEdgeWidth(const Value:integer);
begin
  if FEdgeWidth<>Value then begin
    FEdgeWidth:=Value;
    Invalidate;
  end;
end;

procedure TIceTabSet.WMLButtonDblClk(var Message:TWMLButtonDblClk);
var
  Tab:TIceTab;
begin
  inherited;

  Tab:=GetItemFromPos(Message.XPos,Message.YPos);
  if Assigned(Tab) then DoDoubleClick(Tab);
end;

procedure TIceTabSet.WMSize(var Message:TWMSize);
begin
  inherited;
  fScrollTop:=(Height div 2)-(fScrollHeight div 2);
  fScrollLeft:=Width-fScrollWidth-1;
  Invalidate;
end;

function TIceTabSet.GetButtonRect(const AButton:TScrollButton):TRect;
begin
  result.Left:=fScrollLeft+Ord(AButton)*BTN_SIZE;
  result.Top:=fScrollTop;
  result.Bottom:=fScrollTop+fScrollHeight;
  result.Right:=result.Left+BTN_SIZE;
end;

function TIceTabSet.AddTab(const ACaption:string;const ImageIndex:integer=-1;
  const Data:TObject=nil):TIceTab;
begin
  result:=fTabs.Add as TIceTab;
  result.Caption:=ACaption;
  result.Data:=Data;
  result.ImageIndex:=ImageIndex;
  Invalidate;
end;

function TIceTabSet.IndexOfTabData(Data:TObject):integer;
var
  i:integer;
begin
  result:=-1;
  for i:=0 to fTabs.Count-1 do
    if fTabs[i].Data=Data then begin
      result:=i;
      Exit;
    end;
end;

function TIceTabSet.RemoveTab(ATab:TIceTab):integer;
var
  s:boolean;
  i:integer;
begin
  result:=fTabs.IndexOf(ATab);
  if result<>-1 then begin
    s:=ATab.Selected;
    i:=ATab.Index;
    fTabs.Delete(result);
    if s then begin
      if (i>=0)and(i<fTabs.Count) then SetTabIndex(i)
      else if i>=fTabs.Count then SetTabIndex(fTabs.Count-1);
    end;
    Invalidate;
  end;
end;

procedure TIceTabSet.TabSelected(ATab:TIceTab;ASelected:boolean);
begin
  if ASelected then begin
    LookThisTab(ATab);
    fTabIndex:=ATab.Index;
  end;
  if Assigned(fOnTabSelected) then fOnTabSelected(Self,ATab,ASelected);
end;

procedure TIceTabSet.SetFont(Value:TFont);
begin
  fFont.Assign(Value);
  Invalidate;
end;

procedure TIceTabSet.SetHighlightNewButton(const Value:boolean);
begin
  if FHighlightNewButton<>Value then begin
    FHighlightNewButton:=Value;
    Invalidate;
  end;
end;

procedure TIceTabSet.SetHighlightTabClose(const Value:TIceTab);
begin
  if FHighlightTabClose<>Value then begin
    FHighlightTabClose:=Value;
    Invalidate;
  end;
end;

procedure TIceTabSet.SetImages(const Value:TCustomImageList);
begin
  if fImages<>Value then begin
    fImages:=Value;
    Invalidate;
  end;
end;

procedure TIceTabSet.SetSelectedFont(Value:TFont);
begin
  fSelectedFont.Assign(Value);
  Invalidate;
end;

procedure TIceTabSet.SetSelectedTabStartColor(const Value:TColor);
begin
  if FSelectedTabStartColor<>Value then begin
    FSelectedTabStartColor:=Value;
    Invalidate;
  end;
end;

procedure TIceTabSet.SetSelectedTabStopColor(const Value:TColor);
begin
  if FSelectedTabStopColor<>Value then begin
    FSelectedTabStopColor:=Value;
    Invalidate;
  end;
end;

procedure TIceTabSet.SetShowNewTab(const Value:boolean);
begin
  if FShowNewTab<>Value then begin
    FShowNewTab:=Value;
    Invalidate;
  end;
end;

procedure TIceTabSet.SetArrowColor(const Value:TColor);
begin
  if FArrowColor<>Value then begin
    FArrowColor:=Value;
    Invalidate;
  end;
end;

procedure TIceTabSet.SetArrowHighlightColor(const Value:TColor);
begin
  if FArrowHighlightColor<>Value then begin
    FArrowHighlightColor:=Value;
    Invalidate;
  end;
end;

procedure TIceTabSet.SetAutoTabWidth(const Value:boolean);
begin
  if FAutoTabWidth<>Value then begin
    FAutoTabWidth:=Value;
    Invalidate;
  end;
end;

procedure TIceTabSet.SetBackgroundStartColor(const Value:TColor);
begin
  if FBackgroundStartColor<>Value then begin
    FBackgroundStartColor:=Value;
    Invalidate;
  end;
end;

procedure TIceTabSet.SetBackgroundStopColor(const Value:TColor);
begin
  if FBackgroundStopColor<>Value then begin
    FBackgroundStopColor:=Value;
    Invalidate;
  end;
end;

procedure TIceTabSet.DrawDragTabPointer(aTabIndex:integer); // Om:
var
  X,yMx:integer;
  Pts: Array [0..2] of TPoint;
  innerRect:TRect;

  Graphics:TGPGraphics;
  path:TGPGraphicsPath;
  brush:TGPSolidBrush;

begin
  if (aTabIndex>=0)and(aTabIndex<fTabs.Count) then begin
    X:=fTabs[aTabIndex].fStartPos;
    yMx:=Height;
    Canvas.Pen.Width:=1;
    Canvas.Pen.Mode:=pmNot;
    Canvas.Pen.style:=psSolid;
    Canvas.brush.style:=bsClear;
    Canvas.Pen.Color:=FArrowColor;

    Pts[0]:=Point(X,0);
    Pts[1]:=Point(X+3,6);
    Pts[2]:=Point(X+6,0);

    Canvas.Polygon(Pts); // drag tab cursor = triangle
    Canvas.brush.style:=bsSolid;
    Canvas.Pen.Mode:=pmCopy;
  end;
end;

procedure TIceTabSet.DragOver(Source:TObject;X,Y:integer;State:TDragState;var Accept:boolean);
// Om:
var
  Ix:integer;
  R:TRect;
  Tab:TIceTab;
begin
  inherited;

  Accept:=false;
  if fCanDragTabs and(Source=Self) then // we're NOT accepting drags from other IceTabSets
  begin
    Tab:=GetItemFromPos(X,Y);
    if Assigned(Tab) then begin
      Ix:=fTabs.IndexOf(Tab);
      Accept:=(Ix<>-1)and(Ix<>fIxTabStartDrag);

      if (Ix<>fIxTabStartDrag) then begin
        if fTabDragPointerVisible and(fIxTabEndDrag>=0) then DrawDragTabPointer(fIxTabEndDrag);
        // erase pointer

        fIxTabEndDrag:=Ix;

        if Accept then begin
          DrawDragTabPointer(fIxTabEndDrag);
          fTabDragPointerVisible:=true;
        end else if fTabDragPointerVisible then begin
          DrawDragTabPointer(fIxTabEndDrag);
          fTabDragPointerVisible:=false;
        end;
      end;
    end;

    if (State=dsDragLeave)and fTabDragPointerVisible then begin
      DrawDragTabPointer(fIxTabEndDrag);
      fTabDragPointerVisible:=false;
    end;
  end;
end;

procedure TIceTabSet.DoTabEndDrag; // Om: mova tab from fIxTabStartDrag to fIxTabEndDrag
var
  Tab:TIceTab;
begin
  if fCanDragTabs and(fIxTabStartDrag>=0)and(fIxTabEndDrag>=0)and(fIxTabStartDrag<>fIxTabEndDrag)
  then begin
    Tab:=fTabs[fIxTabStartDrag];
    Tab.Index:=fIxTabEndDrag; // change tab index
    fTabs.DoSelected(Tab,true);
  end;
end;

procedure TIceTabSet.DragDrop(Source:TObject;X,Y:integer); // Om: drop event
var
  Ix:integer;
  Tab:TIceTab;
begin
  if fCanDragTabs and(Source=Self) then begin
    if fTabDragPointerVisible then DrawDragTabPointer(fIxTabEndDrag); // apaga

    fTabDragPointerVisible:=false;

    DoTabEndDrag;
    fIxTabStartDrag:=-1; // reset dragging
  end;

  inherited;
end;

procedure TIceTabSet.MouseDown(Button:TMouseButton;Shift:TShiftState;X,Y:integer);
var
  Tab:TIceTab;
  scrollRect:TRect;
begin
  inherited MouseDown(Button,Shift,X,Y);

  if (Button=mbLeft) then begin
    Tab:=GetItemFromPos(X,Y);
    if Assigned(Tab) then begin
      SetTab(Tab);
      fIxTabStartDrag:=fTabs.IndexOf(Tab); // Om: save start drag tab
    end else begin
      // Check scroll buttons
      scrollRect:=rect(fScrollLeft+BTN_MARGIN,fScrollTop+BTN_MARGIN,fScrollLeft+BTN_MARGIN+BTN_SIZE,
        fScrollTop+BTN_MARGIN+BTN_SIZE);
      if PtInRect(scrollRect,Point(X,Y))and(fFirstIndex>0) then begin
        fScrollPushed:=sbLeft;
        Invalidate;
      end else begin
        scrollRect:=rect(fScrollLeft+BTN_MARGIN+BTN_SIZE,fScrollTop+BTN_MARGIN,
          fScrollLeft+BTN_MARGIN+(BTN_SIZE*2),fScrollTop+BTN_MARGIN+BTN_SIZE);
        if PtInRect(scrollRect,Point(X,Y))and(fFirstIndex<fTabs.Count-fVisibleTabs) then begin
          fScrollPushed:=sbRight;
          Invalidate;
        end;
      end;
    end;
  end;
end;

function TIceTabSet.GetItemFromPos(X,Y:integer):TIceTab;
var
  th,i,MinLeft,MaxRight:integer;
begin
  result:=nil;
  th:=GetTabHeight;
  if (Y<=ClientHeight)and(Y>=ClientHeight-th) then begin
    for i:=fFirstIndex to fTabs.Count-1 do begin
      MinLeft:=fTabs.Items[i].fStartPos;
      MaxRight:=MinLeft+fTabs.Items[i].fSize;
      if (X>=MinLeft)and(X<=MaxRight) then begin
        result:=fTabs.Items[i];
        Break;
      end;
    end;
  end;
end;

procedure TIceTabSet.MouseMove(Shift:TShiftState;X,Y:integer);
var
  Tab:TIceTab;
begin
  inherited MouseMove(Shift,X,Y);

  Tab:=GetItemFromPos(X,Y);
  if FCloseTab then begin
    if Assigned(Tab)and IsInCloseButton(Tab,X,Y) then HighlightTabClose:=Tab
    else HighlightTabClose:=nil;
  end;
  if FShowNewTab then begin
    HighlightNewButton:=PtInRect(FNewButtonArea,Point(X,Y));
  end;

  if fCanDragTabs and(ssLeft in Shift)and(fIxTabStartDrag>=0) then // Om: Start dragging the tab
      BeginDrag(false);
end;

function TIceTabSet.IsInCloseButton(ATab:TIceTab;X,Y:integer):boolean;
var
  closeRect:TRect;
  TabRight,TabTop:integer;
begin
  TabRight:=ATab.fStartPos+ATab.fSize;
  TabTop:=Height-TabHeight;

  closeRect:=rect(TabRight-FEdgeWidth-9,TabTop+((Height-TabTop-10)div 2),TabRight-FEdgeWidth+2,
    TabTop+((Height-TabTop+10)div 2));
  result:=PtInRect(closeRect,Point(X,Y));

end;

procedure TIceTabSet.LookThisTab(ATab:TIceTab);
var
  Start,Stop:integer;
begin
  if Assigned(ATab) then begin
    Start:=0;
    Stop:=Width-fScrollWidth-FEdgeWidth;
    if FShowNewTab then Dec(Stop,FEdgeWidth+10);
    CalcTabPositions(Start,Stop,Canvas,ATab);

    Invalidate;
  end;
end;

procedure TIceTabSet.MouseUp(Button:TMouseButton;Shift:TShiftState;X,Y:integer);
var
  Tab:TIceTab;
begin
  inherited;

  Tab:=GetItemFromPos(X,Y);
  if Assigned(Tab)and FCloseTab and IsInCloseButton(Tab,X,Y) then begin
    if Assigned(OnTabClose) then OnTabClose(Self,Tab);
  end;
  if FShowNewTab then begin
    if PtInRect(FNewButtonArea,Point(X,Y)) then
      if Assigned(OnNewButtonClick) then begin
        OnNewButtonClick(Self);
      end;
  end;

  if fScrollPushed<>sbNone then begin
    ScrollClick(fScrollPushed);
    fScrollPushed:=sbNone;
    Invalidate;
  end;
end;

function TIceTabSet.GetTabHeight:integer;
begin
  result:=FTabHeight;
end;

procedure TIceTabSet.SetTab(NewTab:TIceTab);
begin
  if Assigned(NewTab) then NewTab.Selected:=true
  else TabIndex:=-1;
end;

procedure TIceTabSet.SetTabIndex(Value:integer);
var
  t:TIceTab;
begin
  // if fTabIndex <> Value then
  begin
    fTabIndex:=Value;
    if (Value<-1)or(Value>=fTabs.Count) then raise Exception.CreateRes(@SInvalidTabIndex);
    if Value<>-1 then begin
      t:=fTabs.Items[Value];
      t.Selected:=true;
    end
    else ClearSelection;
  end;
end;

procedure TIceTabSet.ClearSelection;
var
  i:integer;
begin
  for i:=0 to fTabs.Count-1 do fTabs[i].Selected:=false;
end;

procedure TIceTabSet.SetTabStartColor(const Value:TColor);
begin
  if FTabStartColor<>Value then begin
    FTabStartColor:=Value;
    Invalidate;
  end;
end;

procedure TIceTabSet.SetTabStopColor(const Value:TColor);
begin
  if FTabStopColor<>Value then begin
    FTabStopColor:=Value;
    Invalidate;
  end;
end;

procedure TIceTabSet.ShowRightPopup(Sender:TObject;MousePos:TPoint;var Handled:boolean);
var
  Tab:TIceTab;
  Poz:TPoint;
begin
  Poz:=Mouse.CursorPos;
  Tab:=GetItemFromPos(MousePos.X,MousePos.Y);
  if Assigned(OnBeforeShowPopupMenu) then OnBeforeShowPopupMenu(Self,Tab,MousePos);

  if Assigned(PopupMenu) then begin
    Handled:=true;
    PopupMenu.Popup(Poz.X,Poz.Y);
  end;
end;

procedure TIceTabSet.SelectNext(ANext:boolean);
var
  NewIndex:integer;
begin
  if fTabs.Count>1 then begin
    NewIndex:=fTabIndex;
    if ANext then Inc(NewIndex)
    else Dec(NewIndex);
    if NewIndex=fTabs.Count then NewIndex:=0
    else if NewIndex<0 then NewIndex:=fTabs.Count-1;
    SetTabIndex(NewIndex);
  end;
end;

function TIceTabSet.GetSelected:TIceTab;
begin
  if (fTabIndex>-1)and(fTabIndex<fTabs.Count) then result:=fTabs[fTabIndex]
  else result:=nil;
end;

procedure TIceTabSet.SetSelected(Value:TIceTab);
begin
  if Assigned(Value) then Value.Selected:=true;
end;

procedure TIceTabSet.SetModifiedFont(const Value:TFont);
begin
  FModifiedFont.Assign(Value);
  Invalidate;
end;

procedure TIceTabSet.SetModifiedTabStartColor(const Value:TColor);
begin
  if FModifiedTabStartColor<>Value then begin
    FModifiedTabStartColor:=Value;
    Invalidate;
  end;
end;

procedure TIceTabSet.SetModifiedTabStopColor(const Value:TColor);
begin
  if FModifiedTabStopColor<>Value then begin
    FModifiedTabStopColor:=Value;
    Invalidate;
  end;
end;

procedure TIceTabSet.SetOnBeforeShowPopupMenu(const Value:TBeforeShowPopupMenuEvent);
begin
  FOnBeforeShowPopupMenu:=Value;
end;

procedure TIceTabSet.SetOnDblClick(const Value:TTabCloseEvent);
begin
  FOnDblClick:=Value;
end;

procedure TIceTabSet.SetOnNewButtonClick(const Value:TNotifyEvent);
begin
  FOnNewButtonClick:=Value;
end;

procedure TIceTabSet.SetOnTabClose(const Value:TTabCloseEvent);
begin
  FOnTabClose:=Value;
end;

procedure TIceTabSet.SetTabBorderColor(Value:TColor);
begin
  if fTabBorderColor<>Value then begin
    fTabBorderColor:=Value;
    Invalidate;
  end;
end;

procedure TIceTabSet.SetTabCloseColor(const Value:TColor);
begin
  if FTabCloseColor<>Value then begin
    FTabCloseColor:=Value;
    Invalidate;
  end;
end;

procedure TIceTabSet.SetTabHeight(const Value:integer);
begin
  if FTabHeight<>Value then begin
    FTabHeight:=Value;
    Invalidate;
  end;
end;

procedure TIceTabSet.SetMaxTabWidth(Value:integer);
begin
  if fMaxTabWidth<>Value then begin
    fMaxTabWidth:=Value;
    Invalidate;
  end;
end;

end.
