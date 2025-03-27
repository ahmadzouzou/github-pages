(*************************************************)

(**)

(*Delphi TPropertyGrid component v.1.15*)

(*= freeware =*)

(*based on a Grids.pas from Delphi 4 VCL*)

(**)

{* (C) Copyright 1995, 98 Inprise Corporation    *}

(*(C) Copyright 2000-2001, Dmitry H. Bubniewski*)

(**)

(*E-mail: sb3@mail.ru, dmitry@algosoft.nsk.su*)

(*ICQ # 37115452*)

(**)

(*************************************************)

unit PrpGrid;

{$R-}

interface

uses
  Messages,
  Windows,
  SysUtils,
  Classes,
  Graphics,
  Menus,
  Controls,
  Forms,

  StdCtrls,
  Mask,
  Dialogs,
  DsIntf,
  Spin,
  Buttons;

const

  MaxCustomExtents=MaxListSize;

  MaxShortInt=High(ShortInt);

  SMyMaskEditErr='EditMask error. See what you enter!';

type

  EInvalidGridOperation=class(Exception);

  {Internal grid types}

  TGetExtentsFunc=function(Index:Longint):Integer of object;

  TGridAxisDrawInfo=record

    EffectiveLineWidth:Integer;

    FixedBoundary:Integer;

    GridBoundary:Integer;

    GridExtent:Integer;

    LastFullVisibleCell:Longint;

    FullVisBoundary:Integer;

    FixedCellCount:Integer;

    FirstGridCell:Integer;

    GridCellCount:Integer;

    GetExtent:TGetExtentsFunc;

  end;

  TGridDrawInfo=record

    Horz,Vert:TGridAxisDrawInfo;

  end;

  TGridState=(gsNormal,gsSelecting,gsRowSizing,gsColSizing,

    gsRowMoving,gsColMoving);

  TGridMovement=gsRowMoving..gsColMoving;

  {TPopupListBox - definition of class taken from DBGrids.pas}

  TPopupListBox=class(TCustomListbox)

  private

    FSearchText:String;

    FSearchTickCount:Longint;

  protected

    procedure CreateParams(var Params:TCreateParams);override;

    procedure CreateWnd;override;

    procedure KeyPress(var Key:Char);override;

    procedure MouseUp(Button:TMouseButton;Shift:TShiftState;X,Y:Integer);override;

  end;

  {TPropSpinButton - definition of class taken from Spin.pas,

   just added Flat property}

  TPropSpinButton=class(TWinControl)

  private

    FUpButton:TTimerSpeedButton;

    FDownButton:TTimerSpeedButton;

    FFocusedButton:TTimerSpeedButton;

    FFocusControl:TWinControl;

    FOnUpClick:TNotifyEvent;

    FOnDownClick:TNotifyEvent;

    FFlat:Boolean;

    function CreateButton:TTimerSpeedButton;

    function GetUpGlyph:TBitmap;

    function GetDownGlyph:TBitmap;

    procedure SetUpGlyph(Value:TBitmap);

    procedure SetDownGlyph(Value:TBitmap);

    function GetUpNumGlyphs:TNumGlyphs;

    function GetDownNumGlyphs:TNumGlyphs;

    procedure SetUpNumGlyphs(Value:TNumGlyphs);

    procedure SetDownNumGlyphs(Value:TNumGlyphs);

    procedure BtnClick(Sender:TObject);

    procedure BtnMouseDown(Sender:TObject;Button:TMouseButton;

      Shift:TShiftState;X,Y:Integer);

    procedure SetFocusBtn(Btn:TTimerSpeedButton);

    procedure AdjustSize(var W,H:Integer);reintroduce;

    procedure WMSize(var Message:TWMSize);message WM_SIZE;

    procedure WMSetFocus(var Message:TWMSetFocus);message WM_SETFOCUS;

    procedure WMKillFocus(var Message:TWMKillFocus);message WM_KILLFOCUS;

    procedure WMGetDlgCode(var Message:TWMGetDlgCode);message WM_GETDLGCODE;

    procedure SetFlat(const Value:Boolean);

  protected

    procedure Loaded;override;

    procedure KeyDown(var Key:Word;Shift:TShiftState);override;

    procedure Notification(AComponent:TComponent;

      Operation:TOperation);override;

  public

    constructor Create(AOwner:TComponent);override;

    procedure SetBounds(ALeft,ATop,AWidth,AHeight:Integer);override;

  published

    property Align;

    property Anchors;

    property Constraints;

    property Ctl3D;

    property DownGlyph:TBitmap read GetDownGlyph write SetDownGlyph;

    property DownNumGlyphs:TNumGlyphs read GetDownNumGlyphs write SetDownNumGlyphs default 1;

    property DragCursor;

    property DragKind;

    property DragMode;

    property Enabled;

    property Flat:Boolean read FFlat write SetFlat default False;

    property FocusControl:TWinControl read FFocusControl write FFocusControl;

    property ParentCtl3D;

    property ParentShowHint;

    property PopupMenu;

    property ShowHint;

    property TabOrder;

    property TabStop;

    property UpGlyph:TBitmap read GetUpGlyph write SetUpGlyph;

    property UpNumGlyphs:TNumGlyphs read GetUpNumGlyphs write SetUpNumGlyphs default 1;

    property Visible;

    property OnDownClick:TNotifyEvent read FOnDownClick write FOnDownClick;

    property OnDragDrop;

    property OnDragOver;

    property OnEndDock;

    property OnEndDrag;

    property OnEnter;

    property OnExit;

    property OnStartDock;

    property OnStartDrag;

    property OnUpClick:TNotifyEvent read FOnUpClick write FOnUpClick;

  end;

  {TPropertyInplaceEdit}

  TCustomPrGrid=class;

  TPropEditMode=(emSimple,emPickList,emEllipsis,emNoEdit,emSpinEdit);// my insert

  TSpinValueType=(svtInteger,svtFloat);

  TCellValueProp=class;

  TPropertyInplaceEdit=class;

  TSpinProps=class(TPersistent)

  private

    FOwner:TCellValueProp;

    FEditor:TPropertyInplaceEdit;

    FDecimal:Byte;

    FEditorEnabled:Boolean;

    FMaxValue:Extended;

    FIncrement:Extended;

    FMinValue:Extended;

    FValueType:TSpinValueType;

    procedure SetDecimal(const Value:Byte);

    procedure SetValueType(const Value:TSpinValueType);

    function IsIncrementStored:Boolean;

    function IsMaxStored:Boolean;

    function IsMinStored:Boolean;

  public

    destructor Destroy;override;

    constructor Create(AOwner:TObject);

    procedure Assign(Source:TPersistent);override;

    property Editor:TPropertyInplaceEdit read FEditor write FEditor;

  published

    property Decimal:Byte read FDecimal write SetDecimal default 2;

    property EditorEnabled:Boolean read FEditorEnabled write FEditorEnabled default True;

    property Increment:Extended read FIncrement write FIncrement stored IsIncrementStored;

    property MaxValue:Extended read FMaxValue write FMaxValue stored IsMaxStored;

    property MinValue:Extended read FMinValue write FMinValue stored IsMinStored;

    property ValueType:TSpinValueType read FValueType write SetValueType default svtInteger;

  end;

  TCellValueProp=class(TCollectionItem)

  private

    FCollection:TCollection;

    FDropDownRows:Cardinal;

    FEditMode:TPropEditMode;

    FPickList:TStrings;

    FTag:Longint;

    FPropertyLabel:string;

    FPropertyValue:string;

    FChecked:Boolean;

    FReadOnly:Boolean;

    FEditMask:string;

    FText:string;

    FEnabled:Boolean;

    FSpinProps:TSpinProps;

    procedure SetDropDownRows(const Value:Cardinal);

    procedure SetEditMode(const Value:TPropEditMode);

    procedure SetPickList(const Value:TStrings);

    procedure SetPropertyLabel(const Value:string);

    procedure SetPropertyValue(const Value:string);

    procedure SetChecked(const Value:Boolean);

    procedure SetReadOnly(const Value:Boolean);

    function GetPickList:TStrings;

    function GetReadOnly:Boolean;

    procedure SetEditMask(const Value:string);

    function GetText:string;

    function GetPropertyValue:string;

    procedure SetText(const Value:string);

    procedure SetEnabled(const Value:Boolean);

    procedure SetSpinProps(const Value:TSpinProps);

  public

    constructor Create(Collection:TCollection);override;

    destructor Destroy;override;

    property Text:string read GetText write SetText;

  published

    property DropDownRows:Cardinal read FDropDownRows write SetDropDownRows default 7;

    property Tag:Longint read FTag write FTag default 0;

    property EditMode:TPropEditMode read FEditMode write SetEditMode default emSimple;

    property EditMask:string read FEditMask write SetEditMask;

    property PickList:TStrings read GetPickList write SetPickList;

    property PropertyLabel:string read FPropertyLabel write SetPropertyLabel;

    property PropertyValue:string read GetPropertyValue write SetPropertyValue;

    property ReadOnly:Boolean read GetReadOnly write SetReadOnly default False;

    property Checked:Boolean read FChecked write SetChecked default False;

    property Enabled:Boolean read FEnabled write SetEnabled default True;

    property SpinProps:TSpinProps read FSpinProps write SetSpinProps;

  end;

  TCellValuePropClass=class of TCellValueProp;

  TCellValueProps=class(TCollection)

  private

    FGrid:TCustomPrGrid;

    procedure SetCellValueProp(Index:Integer;const Value:TCellValueProp);

    function GetCellValueProp(Index:Integer):TCellValueProp;

  protected

    procedure Update(Item:TCollectionItem);override;

    function GetOwner:TPersistent;override;

  public

    constructor Create(Grid:TCustomPrGrid;CellValuePropClass:TCellValuePropClass);

    procedure Delete(Index:Integer);

    procedure Clear;

    procedure DeleteLastSpareItems(iDeleted:Integer);

    procedure AddLastNeedItems(iAdded:Integer);

    procedure AddCellInfo;

    function Last:TCellValueProp;

    function Add:TCellValueProp;

    function AddInfo(ddRows:Cardinal;iTag:Longint;iEditMode:TPropEditMode;

      iPickList:TStrings):TCellValueProp;

    property Grid:TCustomPrGrid read FGrid;

    property Items[Index:Integer]:TCellValueProp read GetCellValueProp

      write SetCellValueProp;default;

  end;

  TPropTitleValue=(pvTitleFont,pvTitleAlignment,pvTitleColor,

    pvTitleNameText,pvTitleValueText);

  TTitleAssignedValues=set of TPropTitleValue;

  TPropGridTitle=class(TPersistent)

  private

    FGrid:TCustomPrGrid;

    FColor:TColor;

    FAlignment:TAlignment;

    FTitleValueText:string;

    FTitleNameText:string;

    FFont:TFont;

    FAssignedValues:TTitleAssignedValues;

    procedure SetAlignment(Value:TAlignment);

    procedure SetColor(Value:TColor);

    procedure SetTitleNameText(const Value:string);

    procedure SetTitleValueText(const Value:string);

    procedure SetFont(const Value:TFont);

    function GetAlignment:TAlignment;

    function GetColor:TColor;

    function GetTitleNameText:string;

    function GetTitleValueText:string;

    function GetFont:TFont;

    function IsFontStored:Boolean;

    function IsColorStored:Boolean;

  protected

    procedure FontChanged(Sender:TObject);

    property AssignedValues:TTitleAssignedValues read FAssignedValues;

  public

    constructor Create(Grid:TCustomPrGrid);

    procedure Assign(Source:TPersistent);override;

    function DefaultAlignment:TAlignment;

    function DefaultColor:TColor;

    function DefaultFont:TFont;

  published

    property Alignment:TAlignment read GetAlignment write SetAlignment;

    property TitleNameText:string read GetTitleNameText write SetTitleNameText;

    property TitleValueText:string read GetTitleValueText write SetTitleValueText;

    property Color:TColor read GetColor write SetColor stored IsColorStored;

    property Font:TFont read GetFont write SetFont stored IsFontStored;

  end;

  TPropertyInplaceEdit=class(TCustomMaskEdit)

  private

    FGrid:TCustomPrGrid;

    FClickTime:Longint;

    FEditMode:TPropEditMode;

    FPickList:TPopupListBox;

    FButtonWidth:Integer;

    FActiveList:TWinControl;

    FListVisible:Boolean;

    FTracking:Boolean;

    FPressed:Boolean;

    FChecked:Boolean;

    FChanging:Boolean;

    FCellReadOnly:Boolean;

    FKeyPressList:Boolean;

    FButton:TPropSpinButton;

    CurProps:TSpinProps;

    procedure InternalMove(const Loc:TRect;Redraw:Boolean);

    procedure SetGrid(Value:TCustomPrGrid);

    procedure CMShowingChanged(var Message:TMessage);message CM_SHOWINGCHANGED;

    procedure WMGetDlgCode(var Message:TWMGetDlgCode);message WM_GETDLGCODE;

    procedure WMPaste(var Message);message WM_PASTE;

    procedure WMCut(var Message);message WM_CUT;

    procedure WMClear(var Message);message WM_CLEAR;

    procedure CMEnter(var Message:TCMGotFocus);message CM_ENTER;

    procedure CMExit(var Message:TCMExit);message CM_EXIT;

    procedure SetEditMode(const Value:TPropEditMode);

    // my changes

    procedure ListMouseUp(Sender:TObject;Button:TMouseButton;

      Shift:TShiftState;X,Y:Integer);

    procedure StopTracking;

    procedure TrackButton(X,Y:Integer);

    procedure CMCancelMode(var Message:TCMCancelMode);message CM_CancelMode;

    procedure WMCancelMode(var Message:TMessage);message WM_CancelMode;

    procedure WMKillFocus(var Message:TMessage);message WM_KILLFOCUS;

    procedure WMLButtonDblClk(var Message:TWMLButtonDblClk);message wm_LButtonDblClk;

    procedure WMPaint(var Message:TWMPaint);message wm_Paint;

    procedure WMSetCursor(var Message:TWMSetCursor);message WM_SetCursor;

    function OverButton(const P:TPoint):Boolean;

    function ButtonRect:TRect;

    function GetValue:Extended;

  protected

    procedure CreateParams(var Params:TCreateParams);override;

    procedure DblClick;override;

    function DoMouseWheel(Shift:TShiftState;WheelDelta:Integer;

      MousePos:TPoint):Boolean;override;

    function EditCanModify:Boolean;override;

    procedure KeyDown(var Key:Word;Shift:TShiftState);override;

    procedure KeyPress(var Key:Char);override;

    procedure KeyUp(var Key:Word;Shift:TShiftState);override;

    procedure BoundsChanged;virtual;

    procedure UpdateContents;virtual;

    procedure WndProc(var Message:TMessage);override;

    property Grid:TCustomPrGrid read FGrid;

    // my changes

    procedure ValidateError;override;

    procedure Change;override;

    procedure CloseUp(Accept:Boolean);

    procedure DoDropDownKeys(var Key:Word;Shift:TShiftState);

    procedure DropDown;

    procedure MouseDown(Button:TMouseButton;Shift:TShiftState;

      X,Y:Integer);override;

    procedure MouseMove(Shift:TShiftState;X,Y:Integer);override;

    procedure MouseUp(Button:TMouseButton;Shift:TShiftState;

      X,Y:Integer);override;

    procedure PaintWindow(DC:HDC);override;

    property ActiveList:TWinControl read FActiveList write FActiveList;

    property PickList:TPopupListBox read FPickList;

    property EditMode:TPropEditMode read FEditMode write SetEditMode default emSimple;

    property Button:TPropSpinButton read FButton;

    // for spin

    procedure UpClick(Sender:TObject);virtual;

    procedure DownClick(Sender:TObject);virtual;

    procedure SetValue(const Value:Extended);

    function IsValueStored:Boolean;

    function CheckValue(Value:Extended):Extended;

    function IsValidChar(Key:Char):Boolean;

    property Value:Extended read GetValue write SetValue stored IsValueStored;

  public

    constructor Create(AOwner:TComponent);override;

    destructor Destroy;override;

    procedure Deselect;

    procedure Hide;

    procedure Invalidate;reintroduce;

    procedure Move(const Loc:TRect);

    procedure SetFocus;reintroduce;

    procedure UpdateLoc(const Loc:TRect);

    function PosEqual(const Rect:TRect):Boolean;

    function Visible:Boolean;

  end;

  {TCustomPrGrid}

  TPropGridOption=(goTitle,goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,

    goRangeSelect,goDrawFocusSelected,goRowSizing,goColSizing,goRowMoving,

    goColMoving,goEditing,goTabs,{goRowSelect,}goAlwaysShowEditor,goThumbTracking);

  TGridOptions=set of TPropGridOption;

  TGridDrawState=set of (gdSelected,gdFocused,gdFixed);

  TGridScrollDirection=set of (sdLeft,sdRight,sdUp,sdDown);

  TGridCoord=record

    X:Longint;

    Y:Longint;

  end;

  TGridRect=record

    case Integer of

      0:(Left,Top,Right,Bottom:Longint);

      1:(TopLeft,BottomRight:TGridCoord);

  end;

  TSelectCellEvent=procedure(Sender:TObject;ACol,ARow:Longint;

    var CanSelect:Boolean) of object;

  TDrawCellEvent=procedure(Sender:TObject;ACol,ARow:Longint;

    Rect:TRect;State:TGridDrawState) of object;

  TCellButtonClickEvent=procedure(Sender:TObject;ARow:Longint) of object;

  TEditFrameStyle=(efFlat,efThinFramed,efFramed);

  TCustomPrGrid=class(TCustomControl)

  private

    FAnchor:TGridCoord;

    FBorderStyle:TBorderStyle;

    FCanEditModify:Boolean;

    FColCount:Longint;

    FColWidths:Pointer;

    FTabStops:Pointer;

    FCurrent:TGridCoord;

    FDefaultNameColWidth:Integer;

    FDefaultRowHeight:Integer;

    FFixedCols:Integer;

    FFixedRows:Integer;

    FFixedColor:TColor;

    FGridLineWidth:Integer;

    FOptions:TGridOptions;

    FRowCount:Longint;

    FRowHeights:Pointer;

    FScrollBars:TScrollStyle;

    FTopLeft:TGridCoord;

    FSizingIndex:Longint;

    FSizingPos,FSizingOfs:Integer;

    FMoveIndex,FMovePos:Longint;

    FHitTest:TPoint;

    FInplaceEdit:TPropertyInplaceEdit;

    FInplaceCol,FInplaceRow:Longint;

    FColOffset:Integer;

    FDefaultDrawing:Boolean;

    FEditorMode:Boolean;

    FPropValues:TCellValueProps;

    FOnEditButtonClick:TCellButtonClickEvent;

    FCustUpdateEvent:TNotifyEvent;

    FEditFrameStyle:TEditFrameStyle;

    FPropGridTitle:TPropGridTitle;

    FNotUpdateSR:Boolean;

    FSaveCount:Integer;

    function CalcCoordFromPoint(X,Y:Integer;

      const DrawInfo:TGridDrawInfo):TGridCoord;

    procedure CalcDrawInfoXY(var DrawInfo:TGridDrawInfo;

      UseWidth,UseHeight:Integer);

    function CalcMaxTopLeft(const Coord:TGridCoord;

      const DrawInfo:TGridDrawInfo):TGridCoord;

    procedure CancelMode;

    procedure ChangeGridOrientation(RightToLeftOrientation:Boolean);

    procedure ChangeSize(NewColCount,NewRowCount:Longint);

    procedure ClampInView(const Coord:TGridCoord);

    procedure DrawSizingLine(const DrawInfo:TGridDrawInfo);

    procedure DrawMove;

    procedure FocusCell(ACol,ARow:Longint;MoveAnchor:Boolean);

    procedure GridRectToScreenRect(GridRect:TGridRect;

      var ScreenRect:TRect;IncludeLine:Boolean);

    procedure HideEdit;

    procedure Initialize;

    procedure InvalidateGrid;

    procedure InvalidateRect(ARect:TGridRect);

    procedure ModifyScrollBar(ScrollBar,ScrollCode,Pos:Cardinal;

      UseRightToLeft:Boolean);

    procedure MoveAdjust(var CellPos:Longint;FromIndex,ToIndex:Longint);

    procedure MoveAnchor(const NewAnchor:TGridCoord);

    procedure MoveAndScroll(Mouse,CellHit:Integer;var DrawInfo:TGridDrawInfo;

      var Axis:TGridAxisDrawInfo;ScrollBar:Integer;const MousePt:TPoint);

    procedure MoveCurrent(ACol,ARow:Longint;MoveAnchor,Show:Boolean);

    procedure MoveTopLeft(ALeft,ATop:Longint);

    procedure ResizeCol(Index:Longint;OldSize,NewSize:Integer);

    procedure ResizeRow(Index:Longint;OldSize,NewSize:Integer);

    procedure SelectionMoved(const OldSel:TGridRect);

    procedure ScrollDataInfo(DX,DY:Integer;var DrawInfo:TGridDrawInfo);

    procedure TopLeftMoved(const OldTopLeft:TGridCoord);

    procedure UpdateScrollPos;

    procedure UpdateScrollRange;

    function GetColWidths(Index:Longint):Integer;

    function GetRowHeights(Index:Longint):Integer;

    function GetSelection:TGridRect;

    function GetTabStops(Index:Longint):Boolean;

    function GetVisibleColCount:Integer;

    function GetVisibleRowCount:Integer;

    function IsActiveControl:Boolean;

    procedure ReadColWidths(Reader:TReader);

    procedure ReadRowHeights(Reader:TReader);

    procedure SetBorderStyle(Value:TBorderStyle);

    procedure SetCol(Value:Longint);

    procedure SetColCount(Value:Longint);

    procedure SetColWidths(Index:Longint;Value:Integer);

    procedure SetDefaultNameColWidth(Value:Integer);

    procedure SetDefaultRowHeight(Value:Integer);

    procedure SetEditorMode(Value:Boolean);

    procedure SetFixedColor(Value:TColor);

    procedure SetFixedCols(Value:Integer);

    procedure SetFixedRows(Value:Integer);

    procedure SetGridLineWidth(Value:Integer);

    procedure SetLeftCol(Value:Longint);

    procedure SetOptions(Value:TGridOptions);

    procedure SetRow(Value:Longint);

    procedure SetRowCount(Value:Longint);

    procedure SetRowHeights(Index:Longint;Value:Integer);

    procedure SetScrollBars(Value:TScrollStyle);

    procedure SetSelection(Value:TGridRect);

    procedure SetTabStops(Index:Longint;Value:Boolean);

    procedure SetTopRow(Value:Longint);

    procedure UpdateEdit;

    procedure UpdateText;

    procedure WriteColWidths(Writer:TWriter);

    procedure WriteRowHeights(Writer:TWriter);

    procedure CMCancelMode(var Msg:TMessage);message CM_CancelMode;

    procedure CMFontChanged(var Message:TMessage);message CM_FONTCHANGED;

    procedure CMCtl3DChanged(var Message:TMessage);message CM_CTL3DCHANGED;

    procedure CMDesignHitTest(var Msg:TCMDesignHitTest);message CM_DESIGNHITTEST;

    procedure CMWantSpecialKey(var Msg:TCMWantSpecialKey);message CM_WANTSPECIALKEY;

    procedure CMShowingChanged(var Message:TMessage);message CM_SHOWINGCHANGED;

    procedure WMChar(var Msg:TWMChar);message WM_CHAR;

    procedure WMCancelMode(var Msg:TWMCancelMode);message WM_CancelMode;

    procedure WMCommand(var Message:TWMCommand);message WM_COMMAND;

    procedure WMGetDlgCode(var Msg:TWMGetDlgCode);message WM_GETDLGCODE;

    procedure WMHScroll(var Msg:TWMHScroll);message WM_HSCROLL;

    procedure WMKillFocus(var Msg:TWMKillFocus);message WM_KILLFOCUS;

    procedure WMLButtonDown(var Message:TMessage);message WM_LBUTTONDOWN;

    procedure WMNCHitTest(var Msg:TWMNCHitTest);message WM_NCHITTEST;

    procedure WMSetCursor(var Msg:TWMSetCursor);message WM_SetCursor;

    procedure WMSetFocus(var Msg:TWMSetFocus);message WM_SETFOCUS;

    procedure WMSize(var Msg:TWMSize);message WM_SIZE;

    procedure WMTimer(var Msg:TWMTimer);message WM_TIMER;

    procedure WMVScroll(var Msg:TWMVScroll);message WM_VSCROLL;

    // my methods

    procedure SetPropValues(const Value:TCellValueProps);

    procedure UpdateProps;

    procedure UpdateGrid;

    procedure CorrectWidths;virtual;abstract;

    procedure SetEditFrameStyle(const Value:TEditFrameStyle);

    procedure SetPropGridTitle(const Value:TPropGridTitle);

  protected

    FGridState:TGridState;

    FSaveCellExtents:Boolean;

    DesignOptionsBoost:TGridOptions;

    VirtualView:Boolean;

    procedure CalcDrawInfo(var DrawInfo:TGridDrawInfo);

    procedure CalcFixedInfo(var DrawInfo:TGridDrawInfo);

    procedure CalcSizingState(X,Y:Integer;var State:TGridState;

      var Index:Longint;var SizingPos,SizingOfs:Integer;

      var FixedInfo:TGridDrawInfo);virtual;

    function CreateEditor:TPropertyInplaceEdit;virtual;

    procedure CreateParams(var Params:TCreateParams);override;

    procedure KeyDown(var Key:Word;Shift:TShiftState);override;

    procedure KeyPress(var Key:Char);override;

    procedure MouseDown(Button:TMouseButton;Shift:TShiftState;

      X,Y:Integer);override;

    procedure MouseMove(Shift:TShiftState;X,Y:Integer);override;

    procedure MouseUp(Button:TMouseButton;Shift:TShiftState;

      X,Y:Integer);override;

    procedure AdjustSize(Index,Amount:Longint;Rows:Boolean);reintroduce;dynamic;

    function BoxRect(ALeft,ATop,ARight,ABottom:Longint):TRect;

    procedure DoExit;override;

    function CellRect(ACol,ARow:Longint):TRect;

    function CanEditAcceptKey(Key:Char):Boolean;dynamic;

    function CanGridAcceptKey(Key:Word;Shift:TShiftState):Boolean;dynamic;

    function CanEditModify:Boolean;dynamic;

    function CanEditShow:Boolean;virtual;

    function DoMouseWheelDown(Shift:TShiftState;MousePos:TPoint):Boolean;override;

    function DoMouseWheelUp(Shift:TShiftState;MousePos:TPoint):Boolean;override;

    function GetEditText(ACol,ARow:Longint):string;dynamic;

    procedure SetEditText(ACol,ARow:Longint;const Value:string);dynamic;

    function GetEditMask(ACol,ARow:Longint):string;dynamic;

    function GetEditLimit:Integer;dynamic;

    function GetGridWidth:Integer;

    function GetGridHeight:Integer;

    procedure HideEditor;

    procedure ShowEditor;

    procedure ShowEditorChar(Ch:Char);

    procedure InvalidateEditor;

    procedure MoveColumn(FromIndex,ToIndex:Longint);

    procedure ColumnMoved(FromIndex,ToIndex:Longint);dynamic;

    procedure MoveRow(FromIndex,ToIndex:Longint);

    procedure RowMoved(FromIndex,ToIndex:Longint);dynamic;

    procedure DrawCell(ACol,ARow:Longint;ARect:TRect;

      AState:TGridDrawState);virtual;abstract;

    procedure DefineProperties(Filer:TFiler);override;

    procedure MoveColRow(ACol,ARow:Longint;MoveAnchor,Show:Boolean);

    function SelectCell(ACol,ARow:Longint):Boolean;virtual;

    procedure SizeChanged(OldColCount,OldRowCount:Longint);dynamic;

    function Sizing(X,Y:Integer):Boolean;

    procedure ScrollData(DX,DY:Integer);

    procedure InvalidateCell(ACol,ARow:Longint);

    procedure InvalidateCol(ACol:Longint);

    procedure InvalidateRow(ARow:Longint);

    procedure TopLeftChanged;dynamic;

    procedure TimedScroll(Direction:TGridScrollDirection);dynamic;

    procedure Paint;override;

    procedure ColWidthsChanged;dynamic;

    procedure RowHeightsChanged;dynamic;

    procedure DeleteColumn(ACol:Longint);virtual;

    procedure DeleteRow(ARow:Longint);virtual;

    procedure UpdateDesigner;

    function BeginColumnDrag(var Origin,Destination:Integer;

      const MousePt:TPoint):Boolean;dynamic;

    function BeginRowDrag(var Origin,Destination:Integer;

      const MousePt:TPoint):Boolean;dynamic;

    function CheckColumnDrag(var Origin,Destination:Integer;

      const MousePt:TPoint):Boolean;dynamic;

    function CheckRowDrag(var Origin,Destination:Integer;

      const MousePt:TPoint):Boolean;dynamic;

    function EndColumnDrag(var Origin,Destination:Integer;

      const MousePt:TPoint):Boolean;dynamic;

    function EndRowDrag(var Origin,Destination:Integer;

      const MousePt:TPoint):Boolean;dynamic;

    property BorderStyle:TBorderStyle read FBorderStyle write SetBorderStyle default bsNone;

    property Col:Longint read FCurrent.X write SetCol;

    property Color default clWindow;

    property ColCount:Longint read FColCount write SetColCount default 5;

    property ColWidths[Index:Longint]:Integer read GetColWidths write SetColWidths;

    property DefaultNameColWidth:Integer read FDefaultNameColWidth write SetDefaultNameColWidth
      default 64;

    property DefaultDrawing:Boolean read FDefaultDrawing write FDefaultDrawing default True;

    property DefaultRowHeight:Integer read FDefaultRowHeight write SetDefaultRowHeight default 24;

    property EditorMode:Boolean read FEditorMode write SetEditorMode;

    property FixedColor:TColor read FFixedColor write SetFixedColor default clBtnFace;

    property FixedCols:Integer read FFixedCols write SetFixedCols default 1;

    property FixedRows:Integer read FFixedRows write SetFixedRows default 1;

    property GridHeight:Integer read GetGridHeight;

    property GridLineWidth:Integer read FGridLineWidth write SetGridLineWidth default 1;

    property GridWidth:Integer read GetGridWidth;

    property HitTest:TPoint read FHitTest;

    property InplaceEditor:TPropertyInplaceEdit read FInplaceEdit;

    property LeftCol:Longint read FTopLeft.X write SetLeftCol;

    property Options:TGridOptions read FOptions write SetOptions

      default [goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goEditing,goAlwaysShowEditor];

    property ParentColor default False;

    property Row:Longint read FCurrent.Y write SetRow;

    property RowCount:Longint read FRowCount write SetRowCount default 5;

    property RowHeights[Index:Longint]:Integer read GetRowHeights write SetRowHeights;

    property ScrollBars:TScrollStyle read FScrollBars write SetScrollBars default ssBoth;

    property Selection:TGridRect read GetSelection write SetSelection;

    property TabStops[Index:Longint]:Boolean read GetTabStops write SetTabStops;

    property TopRow:Longint read FTopLeft.Y write SetTopRow;

    property VisibleColCount:Integer read GetVisibleColCount;

    property VisibleRowCount:Integer read GetVisibleRowCount;

    // my change

    procedure EditButtonClick(ARow:Longint);dynamic;

    property PropGridTitle:TPropGridTitle read FPropGridTitle write SetPropGridTitle;

    property CustUpdateEvent:TNotifyEvent read FCustUpdateEvent write FCustUpdateEvent;

    property EditFrameStyle:TEditFrameStyle read FEditFrameStyle write SetEditFrameStyle
      default efFramed;

  public

    constructor Create(AOwner:TComponent);override;

    destructor Destroy;override;

    function MouseCoord(X,Y:Integer):TGridCoord;

    property PropValues:TCellValueProps read FPropValues write SetPropValues;

    property OnEditButtonClick:TCellButtonClickEvent read FOnEditButtonClick
      write FOnEditButtonClick;

  published

    property TabStop default True;

  end;

  {TPropertyGrid}

  TGetEditEvent=procedure(Sender:TObject;ACol,ARow:Longint;var Value:string) of object;

  TSetEditEvent=procedure(Sender:TObject;ACol,ARow:Longint;const Value:string) of object;

  TMovedEvent=procedure(Sender:TObject;FromIndex,ToIndex:Longint) of object;

  TStringPrGridStrings=class;

  TPropertyGrid=class(TCustomPrGrid)

  private

    FData:Pointer;

    FRows:Pointer;

    FCols:Pointer;

    FUpdating:Boolean;

    FNeedsUpdating:Boolean;

    FEditUpdate:Integer;

    FOnColumnMoved:TMovedEvent;

    FOnDrawCell:TDrawCellEvent;

    FOnGetEditMask:TGetEditEvent;

    FOnGetEditText:TGetEditEvent;

    FOnRowMoved:TMovedEvent;

    FOnSelectCell:TSelectCellEvent;

    FOnSetEditText:TSetEditEvent;

    FOnTopLeftChanged:TNotifyEvent;

    FOnCheckBoxClick:TCellButtonClickEvent;

    FValueColAutoSize:Boolean;

    FAlignment:TAlignment;

    FShowCheckColumn:Boolean;

    // my changes

    procedure DisableEditUpdate;

    procedure EnableEditUpdate;

    procedure Initialize;

    procedure Update(ACol,ARow:Integer);reintroduce;

    procedure SetUpdateState(Updating:Boolean);

    function EnsureColRow(Index:Integer;IsCol:Boolean):TStringPrGridStrings;

    function EnsureDataRow(ARow:Integer):Pointer;

    procedure SetValueColAutoSize(const Value:Boolean);

    function GetCells(ACol,ARow:Integer):string;

    function GetObjects(ACol,ARow:Integer):TObject;

    procedure SetCells(ACol,ARow:Integer;const Value:string);

    procedure SetObjects(ACol,ARow:Integer;const Value:TObject);

    procedure SetAlignment(const Value:TAlignment);

    procedure SetShowCheckColumn(const Value:Boolean);

  protected

    procedure ColumnMoved(FromIndex,ToIndex:Longint);override;

    procedure DrawCell(ACol,ARow:Longint;ARect:TRect;

      AState:TGridDrawState);override;

    function GetEditMask(ACol,ARow:Longint):string;override;

    function GetEditText(ACol,ARow:Longint):string;override;

    procedure RowMoved(FromIndex,ToIndex:Longint);override;

    function SelectCell(ACol,ARow:Longint):Boolean;override;

    procedure SetEditText(ACol,ARow:Longint;const Value:string);override;

    procedure TopLeftChanged;override;

    procedure Paint;override;

    procedure Resize;override;

    // my properties & methods

    procedure MouseDown(Button:TMouseButton;Shift:TShiftState;

      X,Y:Integer);override;

    procedure UpdateNames(Sender:TObject);

    procedure UpdateValues;

    procedure UpdateTitle;

    procedure CorrectWidths;override;

  public

    constructor Create(AOwner:TComponent);override;

    destructor Destroy;override;

    function CellRect(ACol,ARow:Longint):TRect;

    procedure MouseToCell(X,Y:Integer;var ACol,ARow:Longint);

    property Canvas;

    property Col;

    property ColCount;

    property ColWidths;

    property EditorMode;

    property GridHeight;

    property GridWidth;

    property LeftCol;

    property Selection;

    property Row;

    property RowHeights;

    property TabStops;

    property TopRow;

    // my properties & methods

    procedure AddPropertyRow(pName,pValue:string;pEditMode:TPropEditMode);

    procedure ChangePropertyRow(Index:Integer;pName,pValue:string;pEditMode:TPropEditMode);

    procedure DeletePropertyRow(Index:Integer);

    property Cells[ACol,ARow:Integer]:string read GetCells write SetCells;

    property Objects[ACol,ARow:Integer]:TObject read GetObjects write SetObjects;

  published

    property Align;

    property Anchors;

    property BiDiMode;

    property BorderStyle;

    property Color;

    property Constraints;

    property Ctl3D;

    property DefaultNameColWidth;

    property DefaultRowHeight;

    property DefaultDrawing;

    property DragCursor;

    property DragKind;

    property DragMode;

    property Enabled;

    property FixedColor;

    property RowCount;

    property Font;

    property GridLineWidth;

    property Options;

    property ParentBiDiMode;

    property ParentColor;

    property ParentCtl3D;

    property ParentFont;

    property ParentShowHint;

    property PopupMenu;

    property ScrollBars;

    property ShowHint;

    property TabOrder;

    property TabStop;

    property Visible;

    property VisibleColCount;

    property VisibleRowCount;

    property OnClick;

    property OnColumnMoved:TMovedEvent read FOnColumnMoved write FOnColumnMoved;

    property OnDblClick;

    property OnDragDrop;

    property OnDragOver;

    property OnDrawCell:TDrawCellEvent read FOnDrawCell write FOnDrawCell;

    property OnEndDock;

    property OnEndDrag;

    property OnEnter;

    property OnExit;

    property OnGetEditMask:TGetEditEvent read FOnGetEditMask write FOnGetEditMask;

    property OnGetEditText:TGetEditEvent read FOnGetEditText write FOnGetEditText;

    property OnKeyDown;

    property OnKeyPress;

    property OnKeyUp;

    property OnMouseDown;

    property OnMouseMove;

    property OnMouseUp;

    property OnMouseWheelDown;

    property OnMouseWheelUp;

    property OnRowMoved:TMovedEvent read FOnRowMoved write FOnRowMoved;

    property OnSelectCell:TSelectCellEvent read FOnSelectCell write FOnSelectCell;

    property OnSetEditText:TSetEditEvent read FOnSetEditText write FOnSetEditText;

    property OnStartDock;

    property OnStartDrag;

    property OnTopLeftChanged:TNotifyEvent read FOnTopLeftChanged write FOnTopLeftChanged;

    // my properties

    property OnEditButtonClick;

    property OnCheckBoxClick:TCellButtonClickEvent read FOnCheckBoxClick write FOnCheckBoxClick;

    property EditFrameStyle;

    property PropGridTitle;

    property PropValues;

    property ValueColAutoSize:Boolean read FValueColAutoSize write SetValueColAutoSize;

    property ShowCheckColumn:Boolean read FShowCheckColumn write SetShowCheckColumn default True;

    property NameAlignment:TAlignment read FAlignment write SetAlignment default taLeftJustify;

  end;

  {TStringPrGridStrings}

  TStringPrGridStrings=class(TStrings)

  private

    FGrid:TPropertyGrid;

    FIndex:Integer;

    procedure CalcXY(Index:Integer;var X,Y:Integer);

  protected

    function Get(Index:Integer):string;override;

    function GetCount:Integer;override;

    function GetObject(Index:Integer):TObject;override;

    procedure Put(Index:Integer;const S:string);override;

    procedure PutObject(Index:Integer;AObject:TObject);override;

    procedure SetUpdateState(Updating:Boolean);override;

  public

    constructor Create(AGrid:TPropertyGrid;AIndex:Longint);

    function Add(const S:string):Integer;override;

    procedure Assign(Source:TPersistent);override;

    procedure Clear;override;

    procedure Delete(Index:Integer);override;

    procedure Insert(Index:Integer;const S:string);override;

  end;

procedure Register;

implementation

// {$R *.RES}
uses
  Math,
  Consts;

procedure Register;

begin

  RegisterComponents('CED',[TPropertyGrid]);

end;

type

  PIntArray=^TIntArray;

  TIntArray=array [0..MaxCustomExtents] of Integer;

procedure KillMessage(Wnd:HWnd;Msg:Integer);

// Delete the requested message from the queue, but throw back

// any WM_QUIT msgs that PeekMessage may also return

var

  M:TMsg;

begin

  M.Message:=0;

  if PeekMessage(M,Wnd,Msg,Msg,pm_Remove)and(M.Message=WM_QUIT) then

      PostQuitMessage(M.wparam);

end;

procedure InvalidOp(const id:string);

begin

  raise EInvalidGridOperation.Create(id);

end;

function GridRect(Coord1,Coord2:TGridCoord):TGridRect;

begin

  with Result do

  begin

    Left:=Coord2.X;

    if Coord1.X<Coord2.X then Left:=Coord1.X;

    Right:=Coord1.X;

    if Coord1.X<Coord2.X then Right:=Coord2.X;

    Top:=Coord2.Y;

    if Coord1.Y<Coord2.Y then Top:=Coord1.Y;

    Bottom:=Coord1.Y;

    if Coord1.Y<Coord2.Y then Bottom:=Coord2.Y;

  end;

end;

function PointInGridRect(Col,Row:Longint;const Rect:TGridRect):Boolean;

begin

  Result:=(Col>=Rect.Left)and(Col<=Rect.Right)and(Row>=Rect.Top)

    and(Row<=Rect.Bottom);

end;

type

  TXorRects=array [0..3] of TRect;

procedure XorRects(const R1,R2:TRect;var XorRects:TXorRects);

var

  Intersect,Union:TRect;

  function PtInRect(X,Y:Integer;const Rect:TRect):Boolean;

  begin

    with Rect do Result:=(X>=Left)and(X<=Right)and(Y>=Top)and

        (Y<=Bottom);

  end;

  function Includes(const P1:TPoint;var P2:TPoint):Boolean;

  begin

    with P1 do

    begin

      Result:=PtInRect(X,Y,R1)or PtInRect(X,Y,R2);

      if Result then P2:=P1;

    end;

  end;

  function Build(var R:TRect;const P1,P2,P3:TPoint):Boolean;

  begin

    Build:=True;

    with R do

      if Includes(P1,TopLeft) then

      begin

        if not Includes(P3,BottomRight) then BottomRight:=P2;

      end

      else if Includes(P2,TopLeft) then BottomRight:=P3

      else Build:=False;

  end;

begin

  FillChar(XorRects,SizeOf(XorRects),0);

  if not Bool(IntersectRect(Intersect,R1,R2)) then

  begin

    {Don't intersect so its simple}

    XorRects[0]:=R1;

    XorRects[1]:=R2;

  end

  else

  begin

    UnionRect(Union,R1,R2);

    if Build(XorRects[0],

      Point(Union.Left,Union.Top),

      Point(Union.Left,Intersect.Top),

      Point(Union.Left,Intersect.Bottom)) then

        XorRects[0].Right:=Intersect.Left;

    if Build(XorRects[1],

      Point(Intersect.Left,Union.Top),

      Point(Intersect.Right,Union.Top),

      Point(Union.Right,Union.Top)) then

        XorRects[1].Bottom:=Intersect.Top;

    if Build(XorRects[2],

      Point(Union.Right,Intersect.Top),

      Point(Union.Right,Intersect.Bottom),

      Point(Union.Right,Union.Bottom)) then

        XorRects[2].Left:=Intersect.Right;

    if Build(XorRects[3],

      Point(Union.Left,Union.Bottom),

      Point(Intersect.Left,Union.Bottom),

      Point(Intersect.Right,Union.Bottom)) then

        XorRects[3].Top:=Intersect.Bottom;

  end;

end;

procedure ModifyExtents(var Extents:Pointer;Index,Amount:Longint;

  Default:Integer);

var

  LongSize,OldSize:Longint;

  NewSize:Integer;

  I:Integer;

begin

  if Amount<>0 then

  begin

    if not Assigned(Extents) then OldSize:=0

    else OldSize:=PIntArray(Extents)^[0];

    if (Index<0)or(OldSize<Index) then InvalidOp(SIndexOutOfRange);

    LongSize:=OldSize+Amount;

    if LongSize<0 then InvalidOp(STooManyDeleted)

    else if LongSize>=MaxListSize-1 then InvalidOp(SGridTooLarge);

    NewSize:=Cardinal(LongSize);

    if NewSize>0 then Inc(NewSize);

    ReallocMem(Extents,NewSize*SizeOf(Integer));

    if Assigned(Extents) then

    begin

      I:=Index+1;

      while I<NewSize do

      begin

        PIntArray(Extents)^[I]:=Default;

        Inc(I);

      end;

      PIntArray(Extents)^[0]:=NewSize-1;

    end;

  end;

end;

procedure UpdateExtents(var Extents:Pointer;NewSize:Longint;

  Default:Integer);

var

  OldSize:Integer;

begin

  OldSize:=0;

  if Assigned(Extents) then OldSize:=PIntArray(Extents)^[0];

  ModifyExtents(Extents,OldSize,NewSize-OldSize,Default);

end;

procedure MoveExtent(var Extents:Pointer;FromIndex,ToIndex:Longint);

var

  Extent:Integer;

begin

  if Assigned(Extents) then

  begin

    Extent:=PIntArray(Extents)^[FromIndex];

    if FromIndex<ToIndex then

        Move(PIntArray(Extents)^[FromIndex+1],PIntArray(Extents)^[FromIndex],

        (ToIndex-FromIndex)*SizeOf(Integer))

    else if FromIndex>ToIndex then

        Move(PIntArray(Extents)^[ToIndex],PIntArray(Extents)^[ToIndex+1],

        (FromIndex-ToIndex)*SizeOf(Integer));

    PIntArray(Extents)^[ToIndex]:=Extent;

  end;

end;

function CompareExtents(E1,E2:Pointer):Boolean;

var

  I:Integer;

begin

  Result:=False;

  if E1<>nil then

  begin

    if E2<>nil then

    begin

      for I:=0 to PIntArray(E1)^[0] do

        if PIntArray(E1)^[I]<>PIntArray(E2)^[I] then Exit;

      Result:=True;

    end

  end

  else Result:=E2=nil;

end;

{Private. LongMulDiv multiplys the first two arguments and then

 divides by the third.  This is used so that real number

 (floating point) arithmetic is not necessary.  This routine saves

 the possible 64-bit value in a temp before doing the divide.  Does

 not do error checking like divide by zero.  Also assumes that the

 result is in the 32-bit range (Actually 31-bit, since this algorithm

 is for unsigned).}

function LongMulDiv(Mult1,Mult2,Div1:Longint):Longint;stdcall;

  external 'kernel32.dll' name 'MulDiv';

type

  TSelection=record

    StartPos,EndPos:Integer;

  end;

  {TPropertyInplaceEdit}

constructor TPropertyInplaceEdit.Create(AOwner:TComponent);

begin

  inherited Create(AOwner);

  ParentCtl3D:=False;

  Ctl3D:=False;

  TabStop:=False;

  BorderStyle:=bsNone;

  DoubleBuffered:=False;

  FKeyPressList:=False;

  FButtonWidth:=GetSystemMetrics(SM_CXVSCROLL);

  FButton:=TPropSpinButton.Create(Self);

  FButton.Width:=FButtonWidth;

  FButton.Height:=17;

  FButton.Visible:=False;

  FButton.Parent:=Self;

  FButton.FocusControl:=Self;

  FButton.OnUpClick:=UpClick;

  FButton.OnDownClick:=DownClick;

  FEditMode:=emSimple;

end;

procedure TPropertyInplaceEdit.CreateParams(var Params:TCreateParams);

begin

  inherited CreateParams(Params);

  case Grid.EditFrameStyle of

    efFramed:Params.ExStyle:=Params.ExStyle+WS_EX_CLIENTEDGE;

    efThinFramed:Params.ExStyle:=Params.ExStyle+WS_EX_STATICEDGE;

  end;

  Params.Style:=Params.Style or ES_MULTILINE;

end;

procedure TPropertyInplaceEdit.SetGrid(Value:TCustomPrGrid);

begin

  FGrid:=Value;

end;

procedure TPropertyInplaceEdit.CMShowingChanged(var Message:TMessage);

begin

  {Ignore showing using the Visible property}

end;

procedure TPropertyInplaceEdit.WMGetDlgCode(var Message:TWMGetDlgCode);

begin

  inherited;

  if goTabs in Grid.Options then

      Message.Result:=Message.Result or DLGC_WANTTAB;

end;

procedure TPropertyInplaceEdit.WMPaste(var Message);

begin

  if not EditCanModify then Exit;

  if not CurProps.EditorEnabled or ReadOnly then Exit;

  inherited

end;

procedure TPropertyInplaceEdit.WMClear(var Message);

begin

  if not EditCanModify then Exit;

  // if not CurProps.EditorEnabled or ReadOnly then Exit;

  inherited;

end;

procedure TPropertyInplaceEdit.WMCut(var Message);

begin

  if not EditCanModify then Exit;

  if not CurProps.EditorEnabled or ReadOnly then Exit;

  inherited;

end;

procedure TPropertyInplaceEdit.DblClick;

begin

  Grid.DblClick;

end;

function TPropertyInplaceEdit.DoMouseWheel(Shift:TShiftState;WheelDelta:Integer;

  MousePos:TPoint):Boolean;

begin

  Result:=Grid.DoMouseWheel(Shift,WheelDelta,MousePos);

end;

function TPropertyInplaceEdit.EditCanModify:Boolean;

begin

  Result:=Grid.CanEditModify;

end;

procedure TPropertyInplaceEdit.KeyDown(var Key:Word;Shift:TShiftState);

  procedure SendToParent;

  begin

    if Grid.PropValues[Grid.Row].EditMode=emSpinEdit then

      if CheckValue(Value)<>Value then SetValue(Value);

    Grid.KeyDown(Key,Shift);

    Key:=0;

  end;

  procedure ParentEvent;

  var

    GridKeyDown:TKeyEvent;

  begin

    GridKeyDown:=Grid.OnKeyDown;

    if Assigned(GridKeyDown) then GridKeyDown(Grid,Key,Shift);

  end;

  function ForwardMovement:Boolean;

  begin

    Result:=goAlwaysShowEditor in Grid.Options;

  end;

  function Ctrl:Boolean;

  begin

    Result:=ssCtrl in Shift;

  end;

  function Selection:TSelection;

  begin

    SendMessage(Handle,EM_GETSEL,Longint(@Result.StartPos),Longint(@Result.EndPos));

  end;

  function RightSide:Boolean;

  begin

    with Selection do

        Result:=((StartPos=0)or(EndPos=StartPos))and

        (EndPos=GetTextLen);

  end;

  function LeftSide:Boolean;

  begin

    with Selection do

        Result:=(StartPos=0)and((EndPos=0)or(EndPos=GetTextLen));

  end;

begin

  if (FEditMode=emEllipsis)and(Key=VK_RETURN)and(Shift=[ssCtrl]) then

  begin

    TCustomPrGrid(Grid).EditButtonClick(Grid.Row);

    KillMessage(Handle,WM_CHAR);

  end

  else

  begin

    case Key of

      VK_UP,VK_DOWN:

        begin

          if (FEditMode=emSpinEdit)and(Shift=[ssAlt]) then

          begin

            if Key=VK_UP then UpClick(Self)

            else DownClick(Self);

          end

          else SendToParent;

        end;

      VK_PRIOR,VK_NEXT,VK_ESCAPE:SendToParent;

      VK_INSERT:

        if Shift=[] then SendToParent

        else if (Shift=[ssShift])and not Grid.CanEditModify then Key:=0;

      VK_LEFT: if ForwardMovement and(Ctrl or LeftSide) then SendToParent;

      VK_RIGHT: if ForwardMovement and(Ctrl or RightSide) then SendToParent;

      VK_HOME: if ForwardMovement and(Ctrl or LeftSide) then SendToParent;

      VK_END: if ForwardMovement and(Ctrl or RightSide) then SendToParent;

      VK_F2:

        begin

          ParentEvent;

          if Key=VK_F2 then

          begin

            Deselect;

            Exit;

          end;

        end;

      VK_TAB: if not(ssAlt in Shift) then SendToParent;

    end;

    if (Key=VK_DELETE)and not Grid.CanEditModify then Key:=0;

    if Key<>0 then

    begin

      ParentEvent;

      inherited KeyDown(Key,Shift);

    end;

  end;

end;

procedure TPropertyInplaceEdit.KeyPress(var Key:Char);

var

  Selection:TSelection;

begin

  if not FKeyPressList then Grid.KeyPress(Key)

  else FKeyPressList:=False;

  if (Key in [#32..#255])and not Grid.CanEditAcceptKey(Key) then

  begin

    Key:=#0;

    MessageBeep(0);

  end;

  if (Key in [#32..#255])and(Grid.PropValues[Grid.Row].EditMode=emSpinEdit) then

    if not IsValidChar(Key) then

    begin

      Key:=#0;

      MessageBeep(0);

    end;

  case Key of

    #9,#27:Key:=#0;

    #13:

      begin

        SendMessage(Handle,EM_GETSEL,Longint(@Selection.StartPos),Longint(@Selection.EndPos));

        if (Selection.StartPos=0)and(Selection.EndPos=GetTextLen) then

            Deselect
        else

            SelectAll;

        Key:=#0;// disable if want CheckMask

      end;

    ^H,^V,^X,#32..#255:

      if (not Grid.CanEditModify)or

        ((Grid.PropValues[Grid.Row].EditMode=emSpinEdit)and not CurProps.EditorEnabled) then
          Key:=#0;

  end;

  if Key<>#0 then inherited KeyPress(Key);

end;

function TPropertyInplaceEdit.IsValidChar(Key:Char):Boolean;
begin
  Result:=(Key in [FormatSettingS.DecimalSeparator,'+','-','0'..'9'])or

    ((Key<#32)and(Key<>Chr(VK_RETURN)));

  if not CurProps.EditorEnabled and Result and((Key>=#32)or

    (Key=Char(VK_BACK))or(Key=Char(VK_DELETE))) then

      Result:=False;

end;

procedure TPropertyInplaceEdit.KeyUp(var Key:Word;Shift:TShiftState);

begin

  Grid.KeyUp(Key,Shift);

end;

procedure TPropertyInplaceEdit.WndProc(var Message:TMessage);

begin

  case Message.Msg of

    wm_KeyDown,wm_SysKeyDown,WM_CHAR:

      if EditMode=emPickList then

        with TWMKey(Message) do

        begin

          DoDropDownKeys(CharCode,KeyDataToShiftState(KeyData));

          if (CharCode<>0)and FListVisible then

          begin

            with TMessage(Message) do

                SendMessage(FActiveList.Handle,Msg,wparam,LParam);

            Exit;

          end;

        end

  end;

  case Message.Msg of

    WM_SETFOCUS:

      begin

        if (GetParentForm(Self)=nil)or GetParentForm(Self).SetFocusedControl(Grid) then
            Dispatch(Message);

        Exit;

      end;

    WM_LBUTTONDOWN:

      begin

        if UINT(GetMessageTime-FClickTime)<GetDoubleClickTime then

            Message.Msg:=wm_LButtonDblClk;

        FClickTime:=0;

      end;

  end;

  inherited WndProc(Message);

end;

procedure TPropertyInplaceEdit.Deselect;

begin

  SendMessage(Handle,EM_SETSEL,$7FFFFFFF,Longint($FFFFFFFF));

end;

procedure TPropertyInplaceEdit.Invalidate;

var

  Cur:TRect;

begin

  ValidateRect(Handle,nil);

  InvalidateRect(Handle,nil,True);

  Windows.GetClientRect(Handle,Cur);

  MapWindowPoints(Handle,Grid.Handle,Cur,2);

  ValidateRect(Grid.Handle,@Cur);

  InvalidateRect(Grid.Handle,@Cur,False);

end;

procedure TPropertyInplaceEdit.Hide;

begin

  if HandleAllocated and IsWindowVisible(Handle) then

  begin

    Invalidate;

    SetWindowPos(Handle,0,0,0,0,0,SWP_HIDEWINDOW or SWP_NOZORDER or

      SWP_NOREDRAW);

    if Focused then Windows.SetFocus(Grid.Handle);

  end;

end;

function TPropertyInplaceEdit.PosEqual(const Rect:TRect):Boolean;

var

  Cur:TRect;

begin

  GetWindowRect(Handle,Cur);

  MapWindowPoints(HWND_DESKTOP,Grid.Handle,Cur,2);

  Result:=EqualRect(Rect,Cur);

end;

procedure TPropertyInplaceEdit.InternalMove(const Loc:TRect;Redraw:Boolean);

begin

  if IsRectEmpty(Loc) then Hide

  else

  begin

    CreateHandle;

    Redraw:=Redraw or not IsWindowVisible(Handle);

    Invalidate;

    with Loc do

        SetWindowPos(Handle,HWND_TOP,Left,Top,Right-Left,Bottom-Top,

        SWP_SHOWWINDOW or SWP_NOREDRAW);

    BoundsChanged;

    if Redraw then Invalidate;

    if Grid.Focused then

        Windows.SetFocus(Handle);

  end;

end;

procedure TPropertyInplaceEdit.BoundsChanged;

var
  R:TRect;

begin

  if Grid.EditFrameStyle=efFramed then

      SetRect(R,2,0,Width-2,Height)

  else

      SetRect(R,2,2,Width-2,Height);

  if FEditMode<>emSimple then

    if not TCustomPrGrid(Owner).UseRightToLeftAlignment then

        Dec(R.Right,FButtonWidth)

    else

        Inc(R.Left,FButtonWidth-2);

  SendMessage(Handle,EM_SETRECTNP,0,Longint(@R));

  SendMessage(Handle,EM_SCROLLCARET,0,0);

  if SysLocale.FarEast then

      SetImeCompositionWindow(Font,R.Left,R.Top);

end;

procedure TPropertyInplaceEdit.UpdateLoc(const Loc:TRect);

begin

  InternalMove(Loc,False);

end;

function TPropertyInplaceEdit.Visible:Boolean;

begin

  Result:=IsWindowVisible(Handle);

end;

procedure TPropertyInplaceEdit.Move(const Loc:TRect);

begin

  InternalMove(Loc,True);

end;

procedure TPropertyInplaceEdit.SetFocus;

begin

  if IsWindowVisible(Handle) then

      Windows.SetFocus(Handle);

end;

procedure TPropertyInplaceEdit.UpdateContents;

begin

  with Grid do

  begin

    EditMode:=PropValues.Items[Row].EditMode;

    FChecked:=PropValues.Items[Row].Checked;

    FCellReadOnly:=PropValues.Items[Row].ReadOnly;

  end;

  Text:='';

  if (Grid.PropValues.Items[Grid.Row].EditMask<>'')and(EditMode=emSimple) then

      EditMask:=Grid.PropValues.Items[Grid.Row].EditMask

  else EditMask:=Grid.GetEditMask(Grid.Col,Grid.Row);

  Text:=Grid.GetEditText(Grid.Col,Grid.Row);

  MaxLength:=Grid.GetEditLimit;

  // if EditMode = emSpinEdit then

  CurProps:=Grid.PropValues[Grid.Row].SpinProps;

  CurProps.Editor:=Self;

end;

function TPropertyInplaceEdit.ButtonRect:TRect;

begin

  if not TCustomPrGrid(Owner).UseRightToLeftAlignment then

      Result:=Rect(Width-FButtonWidth-4,0,Width,Height)

  else

      Result:=Rect(0,0,FButtonWidth,Height);

end;

procedure TPropertyInplaceEdit.CMCancelMode(var Message:TCMCancelMode);

begin

  if (Message.Sender<>Self)and(Message.Sender<>FActiveList) then

      CloseUp(False);

end;

procedure TPropertyInplaceEdit.ListMouseUp(Sender:TObject;

  Button:TMouseButton;Shift:TShiftState;X,Y:Integer);

begin

  if Button=mbLeft then

      CloseUp(PtInRect(FActiveList.ClientRect,Point(X,Y)));

end;

function TPropertyInplaceEdit.OverButton(const P:TPoint):Boolean;

begin

  Result:=PtInRect(ButtonRect,P);

end;

procedure TPropertyInplaceEdit.StopTracking;

begin

  if FTracking then

  begin

    TrackButton(-1,-1);

    FTracking:=False;

    MouseCapture:=False;

  end;

end;

procedure TPropertyInplaceEdit.TrackButton(X,Y:Integer);

var
  NewState:Boolean;

  R:TRect;

begin

  R:=ButtonRect;

  NewState:=PtInRect(R,Point(X,Y));

  if FPressed<>NewState then

  begin

    FPressed:=NewState;

    InvalidateRect(Handle,@R,False);

  end;

end;

procedure TPropertyInplaceEdit.WMCancelMode(var Message:TMessage);

begin

  StopTracking;

  inherited;

end;

procedure TPropertyInplaceEdit.WMKillFocus(var Message:TMessage);

begin

  if not SysLocale.FarEast then inherited

  else

  begin

    ImeName:=Screen.DefaultIme;

    ImeMode:=imDontCare;

    inherited;

    if HWnd(Message.wparam)<>TCustomPrGrid(Grid).Handle then

        ActivateKeyboardLayout(Screen.DefaultKbLayout,KLF_ACTIVATE);

  end;

  if Grid.PropValues[Grid.Row].EditMode=emSpinEdit then

    if CheckValue(Value)<>Value then SetValue(Value);

  CloseUp(False);

end;

procedure TPropertyInplaceEdit.WMLButtonDblClk(

  var Message:TWMLButtonDblClk);

begin

  with Message do

    if (FEditMode<>emSimple)and OverButton(Point(XPos,YPos)) then

        Exit;

  inherited;

end;

procedure TPropertyInplaceEdit.WMPaint(var Message:TWMPaint);

begin

  PaintHandler(Message);

end;

procedure TPropertyInplaceEdit.WMSetCursor(var Message:TWMSetCursor);

var
  P:TPoint;

begin

  GetCursorPos(P);

  if (FEditMode<>emSimple)and

    PtInRect(Rect(Width-FButtonWidth,0,Width,Height),ScreenToClient(P)) then

      Windows.SetCursor(LoadCursor(0,idc_Arrow))

  else

      inherited;

end;

procedure TPropertyInplaceEdit.SetEditMode(const Value:TPropEditMode);

begin

  if Value=FEditMode then Exit;

  FEditMode:=Value;

  case Value of

    emPickList:

      begin

        if FPickList=nil then

        begin

          FPickList:=TPopupListBox.Create(Self);

          FPickList.Visible:=False;

          FPickList.Parent:=Self;

          FPickList.OnMouseUp:=ListMouseUp;

          FPickList.IntegralHeight:=True;

          FPickList.ItemHeight:=11;

        end;

        FActiveList:=FPickList;

      end;

  else

    FActiveList:=nil;

  end;

  Repaint;

end;

procedure TPropertyInplaceEdit.CloseUp(Accept:Boolean);

var
  ListValue:string;

begin

  if FListVisible then

  begin

    if GetCapture<>0 then SendMessage(GetCapture,WM_CancelMode,0,0);

    if FPickList.ItemIndex<>-1 then

        ListValue:=FPickList.Items[FPickList.ItemIndex];

    SetWindowPos(FActiveList.Handle,0,0,0,0,0,SWP_NOZORDER or

      SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_HIDEWINDOW);

    FListVisible:=False;

    FKeyPressList:=True;

    Invalidate;

    if Accept then

      if (not(ListValue=''))and EditCanModify then

        with TPropertyGrid(Grid) do

          if FShowCheckColumn then

          begin

            Cells[2,Row]:=ListValue;

            SetEditText(2,Row,ListValue)

          end

          else

          begin

            Cells[1,Row]:=ListValue;

            SetEditText(1,Row,ListValue);

          end;

  end;

end;

procedure TPropertyInplaceEdit.DoDropDownKeys(var Key:Word;

  Shift:TShiftState);

begin

  case Key of

    VK_UP,VK_DOWN:

      if ssAlt in Shift then

      begin

        if FListVisible then CloseUp(True)
        else DropDown;

        Key:=0;

      end;

    VK_RETURN,VK_ESCAPE:

      if FListVisible and not(ssAlt in Shift) then

      begin

        CloseUp(Key=VK_RETURN);

        Key:=0;

      end;

  end;

end;

procedure TPropertyInplaceEdit.DropDown;

var
  P:TPoint;

  I,J,Y:Integer;

  CellValueProp:TCellValueProp;

begin

  if not FListVisible and Assigned(FActiveList) then

  begin

    with TPropertyGrid(Grid) do

    begin

      CellValueProp:=PropValues[Row];

      if ShowCheckColumn then

          FActiveList.Width:=ColWidths[2]

      else FActiveList.Width:=ColWidths[1];

      FPickList.Color:=clWindow;

      FPickList.Font:=Font;

      FPickList.Items:=CellValueProp.PickList;

      if FPickList.Items.Count>=Integer(CellValueProp.DropDownRows) then

          FPickList.Height:=Integer(CellValueProp.DropDownRows)*FPickList.ItemHeight+4

      else

          FPickList.Height:=FPickList.Items.Count*FPickList.ItemHeight+4;

      if CellValueProp.PropertyValue='' then

          FPickList.ItemIndex:=-1

      else

          FPickList.ItemIndex:=FPickList.Items.IndexOf(CellValueProp.PropertyValue);

      J:=FPickList.ClientWidth;

      for I:=0 to FPickList.Items.Count-1 do

      begin

        Y:=FPickList.Canvas.TextWidth(FPickList.Items[I]);

        if Y>J then J:=Y;

      end;

      FPickList.ClientWidth:=J;

    end;

  end;

  P:=Parent.ClientToScreen(Point(Left,Top));

  Y:=P.Y+Height;

  if Y+FActiveList.Height>Screen.Height then Y:=P.Y-FActiveList.Height;

  SetWindowPos(FActiveList.Handle,HWND_TOP,P.X,Y,0,0,

    SWP_NOSIZE or SWP_NOACTIVATE or SWP_SHOWWINDOW);

  FListVisible:=True;

  Invalidate;

  Windows.SetFocus(Handle);

end;

procedure TPropertyInplaceEdit.MouseDown(Button:TMouseButton;

  Shift:TShiftState;X,Y:Integer);

begin

  if (Button=mbLeft)and(FEditMode<>emSimple)and

    OverButton(Point(X,Y)) then

  begin

    if FListVisible then

        CloseUp(False)

    else

    begin

      MouseCapture:=True;

      FTracking:=True;

      TrackButton(X,Y);

      if Assigned(FActiveList) then

          DropDown;

    end;

  end;

  inherited MouseDown(Button,Shift,X,Y);

end;

procedure TPropertyInplaceEdit.MouseMove(Shift:TShiftState;X,

  Y:Integer);

var
  ListPos:TPoint;

  MousePos:TSmallPoint;

begin

  if FTracking then

  begin

    TrackButton(X,Y);

    if FListVisible then

    begin

      ListPos:=FActiveList.ScreenToClient(ClientToScreen(Point(X,Y)));

      if PtInRect(FActiveList.ClientRect,ListPos) then

      begin

        StopTracking;

        MousePos:=PointToSmallPoint(ListPos);

        SendMessage(FActiveList.Handle,WM_LBUTTONDOWN,0,Integer(MousePos));

        Exit;

      end;

    end;

  end;

  inherited MouseMove(Shift,X,Y);

end;

procedure TPropertyInplaceEdit.MouseUp(Button:TMouseButton;

  Shift:TShiftState;X,Y:Integer);

var
  WasPressed:Boolean;

begin

  WasPressed:=FPressed;

  StopTracking;

  if (Button=mbLeft)and(FEditMode=emEllipsis)and WasPressed then

      TCustomPrGrid(Grid).EditButtonClick(Grid.MouseCoord(X,Y).Y);

  inherited MouseUp(Button,Shift,X,Y);

end;

procedure TPropertyInplaceEdit.PaintWindow(DC:HDC);

var
  R:TRect;

  Flags,FlatFlag:Integer;

  W,X,Y,OffSet:Integer;

begin

  FlatFlag:=0;

  OffSet:=1;

  FButton.Visible:=FEditMode=emSpinEdit;

  case Grid.EditFrameStyle of

    efFramed:OffSet:=4;

    efThinFramed:OffSet:=2;

    efFlat:FlatFlag:=DFCS_FLAT;

  end;

  if FEditMode<>emSimple then

  begin

    R:=ButtonRect;

    SetRect(R,Width-FButtonWidth-OffSet,1*Ord(Grid.EditFrameStyle=efFlat),Width-OffSet,
      Height-OffSet);

    Flags:=0;

    case FEditMode of

      emPickList:

        begin

          if FActiveList=nil then

              Flags:=DFCS_INACTIVE

          else

            if FPressed then Flags:=DFCS_PUSHED;

          DrawFrameControl(DC,R,DFC_SCROLL,Flags or DFCS_SCROLLCOMBOBOX or FlatFlag);

        end;

      emEllipsis:

        begin

          if FPressed then Flags:=DFCS_PUSHED;

          DrawFrameControl(DC,R,DFC_BUTTON,Flags or DFCS_BUTTONPUSH or FlatFlag);

          X:=R.Left+((R.Right-R.Left) shr 1)-1+Ord(FPressed);

          Y:=R.Top+((R.Bottom-R.Top) shr 1)-1+Ord(FPressed);

          W:=FButtonWidth shr 3;

          if W=0 then W:=1;

          PatBlt(DC,X,Y,W,W,DSTINVERT);

          PatBlt(DC,X-(W*2),Y,W,W,DSTINVERT);

          PatBlt(DC,X+(W*2),Y,W,W,DSTINVERT);

        end;

      emSpinEdit:

        begin

          if Grid.EditFrameStyle=efFlat then FButton.Flat:=True;

          FButton.SetBounds(Width-FButton.Width-OffSet,

            1*Ord(Grid.EditFrameStyle=efFlat),FButton.Width,
            Height-OffSet-1*Ord(Grid.EditFrameStyle=efFlat));

        end;

    end;

    ExcludeClipRect(DC,R.Left,R.Top,R.Right,R.Bottom);

  end;

  ReadOnly:=(FCellReadOnly)or(FEditMode=emNoEdit);

  inherited PaintWindow(DC);

end;

procedure TPropertyInplaceEdit.Change;

begin

  if not FChanging then inherited Change;

end;

procedure TPropertyInplaceEdit.ValidateError;

var
  Str:string;

begin

  MessageBeep(0);

  Str:=EditMask;

  Str:=Format(SMyMaskEditErr,[Str]);

  raise EDBEditError.Create(Str);

end;

destructor TPropertyInplaceEdit.Destroy;

begin

  FButton:=nil;

  inherited Destroy;

end;

procedure TPropertyInplaceEdit.DownClick(Sender:TObject);

var
  OldText:string;

begin

  if ReadOnly then MessageBeep(0)

  else

  begin

    FChanging:=True;

    try

      OldText:=inherited Text;

      Value:=Value-CurProps.Increment;

    finally

        FChanging:=False;

    end;

    if CompareText(inherited Text,OldText)<>0 then

    begin

      Modified:=True;

      Change;

    end;

  end;

end;

procedure TPropertyInplaceEdit.UpClick(Sender:TObject);

var
  OldText:string;

begin

  if ReadOnly then MessageBeep(0)

  else

  begin

    FChanging:=True;

    try

      OldText:=inherited Text;

      Value:=Value+CurProps.Increment;

    finally

        FChanging:=False;

    end;

    if CompareText(inherited Text,OldText)<>0 then

    begin

      Modified:=True;

      Change;

    end;

  end;

end;

function TPropertyInplaceEdit.CheckValue(Value:Extended):Extended;

begin

  Result:=Value;

  if (CurProps.MaxValue<>CurProps.MinValue) then

  begin

    if Value<CurProps.MinValue then

        Result:=CurProps.MinValue

    else if Value>CurProps.MaxValue then

        Result:=CurProps.MaxValue;

  end;

end;

procedure TPropertyInplaceEdit.CMExit(var Message:TCMExit);

begin

  inherited;

  if CheckValue(Value)<>Value then SetValue(Value);

end;

procedure TPropertyInplaceEdit.SetValue(const Value:Extended);

begin

  if CurProps.ValueType=svtFloat then

      Text:=FloatToStrF(CheckValue(Value),ffFixed,15,CurProps.Decimal)

  else if CurProps.ValueType=svtInteger then

      Text:=IntToStr(Round(CheckValue(Value)));

  Grid.SetEditText(Grid.Col,Grid.Row,Text);

end;

procedure TPropertyInplaceEdit.CMEnter(var Message:TCMGotFocus);

begin

  if AutoSelect and not(csLButtonDown in ControlState) then SelectAll;

  inherited;

end;

function TPropertyInplaceEdit.GetValue:Extended;

begin

  try

    if CurProps.ValueType=svtFloat then Result:=StrToFloat(Text)

    else Result:=StrToInt(Text);

  except

    if CurProps.ValueType=svtFloat then Result:=CurProps.MinValue

    else Result:=Trunc(CurProps.MinValue);

  end;

end;

function TPropertyInplaceEdit.IsValueStored:Boolean;

begin

  Result:=(GetValue<>0.0);

end;

{TCustomPrGrid}

constructor TCustomPrGrid.Create(AOwner:TComponent);

const

  GridStyle=[csCaptureMouse,csOpaque,csDoubleClicks];

begin

  inherited Create(AOwner);

  if NewStyleControls then

      ControlStyle:=GridStyle
  else

      ControlStyle:=GridStyle+[csFramed];

  FCanEditModify:=True;

  FNotUpdateSR:=False;

  FSaveCount:=0;

  FColCount:=3;

  FRowCount:=8;

  FFixedCols:=2;

  FGridLineWidth:=1;

  FOptions:=[goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goEditing,goAlwaysShowEditor];

  DesignOptionsBoost:=[goColSizing,goRowSizing];

  FFixedColor:=clBtnFace;

  FScrollBars:=ssBoth;

  FBorderStyle:=bsNone;

  FDefaultNameColWidth:=80;

  FDefaultRowHeight:=22;

  FDefaultDrawing:=True;

  FSaveCellExtents:=True;

  FEditorMode:=False;

  Color:=clWindow;

  ParentColor:=False;

  TabStop:=True;

  FEditFrameStyle:=efFramed;

  FPropGridTitle:=TPropGridTitle.Create(Self);

  FPropValues:=TCellValueProps.Create(Self,TCellValueProp);

  SetBounds(Left,Top,FColCount*FDefaultNameColWidth,

    FRowCount*FDefaultRowHeight);

  Initialize;

end;

destructor TCustomPrGrid.Destroy;

begin

  FInplaceEdit.Free;

  FPropGridTitle.Free;

  inherited Destroy;

  FreeMem(FColWidths);

  FreeMem(FRowHeights);

  FreeMem(FTabStops);

end;

procedure TCustomPrGrid.AdjustSize(Index,Amount:Longint;Rows:Boolean);

var

  NewCur:TGridCoord;

  OldRows,OldCols:Longint;

  MovementX,MovementY:Longint;

  MoveRect:TGridRect;

  ScrollArea:TRect;

  AbsAmount:Longint;

  function DoSizeAdjust(var Count:Longint;var Extents:Pointer;

    DefaultExtent:Integer;var Current:Longint):Longint;

  var

    I:Integer;

    NewCount:Longint;

  begin

    NewCount:=Count+Amount;

    if NewCount<Index then InvalidOp(STooManyDeleted);

    if (Amount<0)and Assigned(Extents) then

    begin

      Result:=0;

      for I:=Index to Index-Amount-1 do

          Inc(Result,PIntArray(Extents)^[I]);

    end

    else

        Result:=Amount*DefaultExtent;

    if Extents<>nil then

        ModifyExtents(Extents,Index,Amount,DefaultExtent);

    Count:=NewCount;

    if Current>=Index then

      if (Amount<0)and(Current<Index-Amount) then Current:=Index

      else Inc(Current,Amount);

  end;

begin

  if Amount=0 then Exit;

  NewCur:=FCurrent;

  OldCols:=ColCount;

  OldRows:=RowCount;

  MoveRect.Left:=FixedCols;

  MoveRect.Right:=ColCount-1;

  MoveRect.Top:=FixedRows;

  MoveRect.Bottom:=RowCount-1;

  MovementX:=0;

  MovementY:=0;

  AbsAmount:=Amount;

  if AbsAmount<0 then AbsAmount:=-AbsAmount;

  if Rows then

  begin

    MovementY:=DoSizeAdjust(FRowCount,FRowHeights,DefaultRowHeight,NewCur.Y);

    MoveRect.Top:=Index;

    if Index+AbsAmount<=TopRow then MoveRect.Bottom:=TopRow-1;

  end

  else

  begin

    MovementX:=DoSizeAdjust(FColCount,FColWidths,DefaultNameColWidth,NewCur.X);

    MoveRect.Left:=Index;

    if Index+AbsAmount<=LeftCol then MoveRect.Right:=LeftCol-1;

  end;

  GridRectToScreenRect(MoveRect,ScrollArea,True);

  if not IsRectEmpty(ScrollArea) then

  begin

    ScrollWindow(Handle,MovementX,MovementY,@ScrollArea,@ScrollArea);

    UpdateWindow(Handle);

  end;

  SizeChanged(OldCols,OldRows);

  if (NewCur.X<>FCurrent.X)or(NewCur.Y<>FCurrent.Y) then

      MoveCurrent(NewCur.X,NewCur.Y,True,True);

end;

function TCustomPrGrid.BoxRect(ALeft,ATop,ARight,ABottom:Longint):TRect;

var

  GridRect:TGridRect;

begin

  GridRect.Left:=ALeft;

  GridRect.Right:=ARight;

  GridRect.Top:=ATop;

  GridRect.Bottom:=ABottom;

  GridRectToScreenRect(GridRect,Result,False);

end;

procedure TCustomPrGrid.DoExit;

begin

  inherited DoExit;

  if not(goAlwaysShowEditor in Options) then HideEditor;

  UpdateText;

end;

function TCustomPrGrid.CellRect(ACol,ARow:Longint):TRect;

begin

  Result:=BoxRect(ACol,ARow,ACol,ARow);

end;

function TCustomPrGrid.CanEditAcceptKey(Key:Char):Boolean;

begin

  Result:=True;

end;

function TCustomPrGrid.CanGridAcceptKey(Key:Word;Shift:TShiftState):Boolean;

begin

  Result:=True;

end;

function TCustomPrGrid.CanEditModify:Boolean;

begin

  Result:=FCanEditModify;

end;

function TCustomPrGrid.CanEditShow:Boolean;

begin

  Result:=([{goRowSelect,}goEditing]*Options=[goEditing])and

    FEditorMode and not(csDesigning in ComponentState)and HandleAllocated and

    ((goAlwaysShowEditor in Options)or IsActiveControl);

end;

function TCustomPrGrid.IsActiveControl:Boolean;

var

  H:HWnd;

  ParentForm:TCustomForm;

begin

  Result:=False;

  ParentForm:=GetParentForm(Self);

  if Assigned(ParentForm) then

  begin

    if (ParentForm.ActiveControl=Self) then

        Result:=True

  end

  else

  begin

    H:=GetFocus;

    while IsWindow(H)and(Result=False) do

    begin

      if H=WindowHandle then

          Result:=True

      else

          H:=GetParent(H);

    end;

  end;

end;

function TCustomPrGrid.GetEditMask(ACol,ARow:Longint):string;

begin

  Result:='';

end;

function TCustomPrGrid.GetEditText(ACol,ARow:Longint):string;

begin

  Result:='';

end;

procedure TCustomPrGrid.SetEditText(ACol,ARow:Longint;const Value:string);

begin

end;

function TCustomPrGrid.GetEditLimit:Integer;

begin

  Result:=0;

end;

procedure TCustomPrGrid.HideEditor;

begin

  FEditorMode:=False;

  HideEdit;

end;

procedure TCustomPrGrid.ShowEditor;

begin

  FEditorMode:=True;

  UpdateEdit;

end;

procedure TCustomPrGrid.ShowEditorChar(Ch:Char);

begin

  ShowEditor;

  if FInplaceEdit<>nil then

      PostMessage(FInplaceEdit.Handle,WM_CHAR,Word(Ch),0);

end;

procedure TCustomPrGrid.InvalidateEditor;

begin

  FInplaceCol:=-1;

  FInplaceRow:=-1;

  UpdateEdit;

end;

procedure TCustomPrGrid.ReadColWidths(Reader:TReader);

var

  I:Integer;

begin

  with Reader do

  begin

    ReadListBegin;

    for I:=0 to ColCount-1 do ColWidths[I]:=ReadInteger;

    ReadListEnd;

  end;

end;

procedure TCustomPrGrid.ReadRowHeights(Reader:TReader);

var

  I:Integer;

begin

  with Reader do

  begin

    ReadListBegin;

    for I:=0 to RowCount-1 do RowHeights[I]:=ReadInteger;

    ReadListEnd;

  end;

end;

procedure TCustomPrGrid.WriteColWidths(Writer:TWriter);

var

  I:Integer;

begin

  with Writer do

  begin

    WriteListBegin;

    for I:=0 to ColCount-1 do WriteInteger(ColWidths[I]);

    WriteListEnd;

  end;

end;

procedure TCustomPrGrid.WriteRowHeights(Writer:TWriter);

var

  I:Integer;

begin

  with Writer do

  begin

    WriteListBegin;

    for I:=0 to RowCount-1 do WriteInteger(RowHeights[I]);

    WriteListEnd;

  end;

end;

procedure TCustomPrGrid.DefineProperties(Filer:TFiler);

  function DoColWidths:Boolean;

  begin

    if Filer.Ancestor<>nil then

        Result:=not CompareExtents(TCustomPrGrid(Filer.Ancestor).FColWidths,FColWidths)

    else

        Result:=FColWidths<>nil;

  end;

  function DoRowHeights:Boolean;

  begin

    if Filer.Ancestor<>nil then

        Result:=not CompareExtents(TCustomPrGrid(Filer.Ancestor).FRowHeights,FRowHeights)

    else

        Result:=FRowHeights<>nil;

  end;

begin

  inherited DefineProperties(Filer);

  if FSaveCellExtents then

    with Filer do

    begin

      DefineProperty('ColWidths',ReadColWidths,WriteColWidths,DoColWidths);

      DefineProperty('RowHeights',ReadRowHeights,WriteRowHeights,DoRowHeights);

    end;

end;

procedure TCustomPrGrid.MoveColumn(FromIndex,ToIndex:Longint);

var

  Rect:TGridRect;

begin

  if FromIndex=ToIndex then Exit;

  if Assigned(FColWidths) then

  begin

    MoveExtent(FColWidths,FromIndex+1,ToIndex+1);

    MoveExtent(FTabStops,FromIndex+1,ToIndex+1);

  end;

  MoveAdjust(FCurrent.X,FromIndex,ToIndex);

  MoveAdjust(FAnchor.X,FromIndex,ToIndex);

  MoveAdjust(FInplaceCol,FromIndex,ToIndex);

  Rect.Top:=0;

  Rect.Bottom:=VisibleRowCount;

  if FromIndex<ToIndex then

  begin

    Rect.Left:=FromIndex;

    Rect.Right:=ToIndex;

  end

  else

  begin

    Rect.Left:=ToIndex;

    Rect.Right:=FromIndex;

  end;

  InvalidateRect(Rect);

  ColumnMoved(FromIndex,ToIndex);

  if Assigned(FColWidths) then

      ColWidthsChanged;

  UpdateEdit;

end;

procedure TCustomPrGrid.ColumnMoved(FromIndex,ToIndex:Longint);

begin

end;

procedure TCustomPrGrid.MoveRow(FromIndex,ToIndex:Longint);

begin

  if Assigned(FRowHeights) then

      MoveExtent(FRowHeights,FromIndex+1,ToIndex+1);

  MoveAdjust(FCurrent.Y,FromIndex,ToIndex);

  MoveAdjust(FAnchor.Y,FromIndex,ToIndex);

  MoveAdjust(FInplaceRow,FromIndex,ToIndex);

  RowMoved(FromIndex,ToIndex);

  if Assigned(FRowHeights) then

      RowHeightsChanged;

  UpdateEdit;

end;

procedure TCustomPrGrid.RowMoved(FromIndex,ToIndex:Longint);

begin

end;

function TCustomPrGrid.MouseCoord(X,Y:Integer):TGridCoord;

var

  DrawInfo:TGridDrawInfo;

begin

  CalcDrawInfo(DrawInfo);

  Result:=CalcCoordFromPoint(X,Y,DrawInfo);

  if Result.X<0 then Result.Y:=-1

  else if Result.Y<0 then Result.X:=-1;

end;

procedure TCustomPrGrid.MoveColRow(ACol,ARow:Longint;MoveAnchor,

  Show:Boolean);

begin

  MoveCurrent(ACol,ARow,MoveAnchor,Show);

end;

function TCustomPrGrid.SelectCell(ACol,ARow:Longint):Boolean;

begin

  Result:=True;

end;

procedure TCustomPrGrid.SizeChanged(OldColCount,OldRowCount:Longint);

begin

end;

function TCustomPrGrid.Sizing(X,Y:Integer):Boolean;

var

  DrawInfo:TGridDrawInfo;

  State:TGridState;

  Index:Longint;

  Pos,Ofs:Integer;

begin

  State:=FGridState;

  if State=gsNormal then

  begin

    CalcDrawInfo(DrawInfo);

    CalcSizingState(X,Y,State,Index,Pos,Ofs,DrawInfo);

  end;

  Result:=State<>gsNormal;

end;

procedure TCustomPrGrid.TopLeftChanged;

begin

  if FEditorMode and(FInplaceEdit<>nil) then FInplaceEdit.UpdateLoc(CellRect(Col,Row));

end;

procedure FillDWord(var Dest;Count,Value:Integer);register;

asm

  XCHG  EDX, ECX

  PUSH  EDI

  MOV   EDI, EAX

  MOV   EAX, EDX

  REP   STOSD

  POP   EDI

end;

{StackAlloc allocates a 'small' block of memory from the stack by

 decrementing SP.  This provides the allocation speed of a local variable,

 but the runtime size flexibility of heap allocated memory.}

function StackAlloc(Size:Integer):Pointer;register;

asm

  POP   ECX          {return address}

  MOV   EDX, ESP

  ADD   EAX, 3

  AND   EAX, not 3   // round up to keep ESP dword aligned

  CMP   EAX, 4092

  JLE   @@2

@@1:

  SUB   ESP, 4092

  PUSH  EAX          {make sure we touch guard page, to grow stack}

  SUB   EAX, 4096

  JNS   @@1

  ADD   EAX, 4096

@@2:

  SUB   ESP, EAX

  MOV   EAX, ESP     {function result = low memory address of block}

  PUSH  EDX          {save original SP, for cleanup}

  MOV   EDX, ESP

  SUB   EDX, 4

  PUSH  EDX          {save current SP, for sanity check  (sp = [sp])}

  PUSH  ECX          {return to caller}

end;

{StackFree pops the memory allocated by StackAlloc off the stack.

 - Calling StackFree is optional - SP will be restored when the calling routine

 exits, but it's a good idea to free the stack allocated memory ASAP anyway.

 - StackFree must be called in the same stack context as StackAlloc - not in

 a subroutine or finally block.

 - Multiple StackFree calls must occur in reverse order of their corresponding

 StackAlloc calls.

 - Built-in sanity checks guarantee that an improper call to StackFree will not

 corrupt the stack. Worst case is that the stack block is not released until

 the calling routine exits.}

procedure StackFree(P:Pointer);register;

asm

  POP   ECX                     {return address}

  MOV   EDX, DWORD PTR [ESP]

  SUB   EAX, 8

  CMP   EDX, ESP                {sanity check #1 (SP = [SP])}

  JNE   @@1

  CMP   EDX, EAX                {sanity check #2 (P = this stack block)}

  JNE   @@1

  MOV   ESP, DWORD PTR [ESP+4]  {restore previous SP}

@@1:

  PUSH  ECX                     {return to caller}

end;

procedure TCustomPrGrid.Paint;

var

  LineColor:TColor;

  DrawInfo:TGridDrawInfo;

  Sel:TGridRect;

  UpdateRect:TRect;

  AFocRect,FocRect:TRect;

  PointsList:PIntArray;

  StrokeList:PIntArray;

  MaxStroke:Integer;

  FrameFlags1,FrameFlags2:DWORD;

  procedure DrawLines(DoHorz,DoVert:Boolean;Col,Row:Longint;

    const CellBounds: array of Integer;OnColor,OffColor:TColor);

  {Cellbounds is 4 integers: StartX, StartY, StopX, StopY

   Horizontal lines:  MajorIndex = 0

   Vertical lines:    MajorIndex = 1}

  const

    FlatPenStyle=PS_Geometric or PS_Solid or PS_EndCap_Flat or PS_Join_Miter;

    procedure DrawAxisLines(const AxisInfo:TGridAxisDrawInfo;

      Cell,MajorIndex:Integer;UseOnColor:Boolean);

    var

      Line:Integer;

      LogBrush:TLOGBRUSH;

      Index:Integer;

      Points:PIntArray;

      StopMajor,StartMinor,StopMinor:Integer;

    begin

      with Canvas,AxisInfo do

      begin

        if EffectiveLineWidth<>0 then

        begin

          Pen.Width:=GridLineWidth;

          if UseOnColor then

              Pen.Color:=OnColor

          else

              Pen.Color:=OffColor;

          if Pen.Width>1 then

          begin

            LogBrush.lbStyle:=BS_Solid;

            LogBrush.lbColor:=Pen.Color;

            LogBrush.lbHatch:=0;

            Pen.Handle:=ExtCreatePen(FlatPenStyle,Pen.Width,LogBrush,0,nil);

          end;

          Points:=PointsList;

          Line:=CellBounds[MajorIndex]+EffectiveLineWidth shr 1+

            GetExtent(Cell);

          // !!! ??? Line needs to be incremented for RightToLeftAlignment ???

          if UseRightToLeftAlignment and(MajorIndex=0) then Inc(Line);

          StartMinor:=CellBounds[MajorIndex xor 1];

          StopMinor:=CellBounds[2+(MajorIndex xor 1)];

          StopMajor:=CellBounds[2+MajorIndex]+EffectiveLineWidth;

          Index:=0;

          repeat

            Points^[Index+MajorIndex]:=Line;{MoveTo}

            Points^[Index+(MajorIndex xor 1)]:=StartMinor;

            Inc(Index,2);

            Points^[Index+MajorIndex]:=Line;{LineTo}

            Points^[Index+(MajorIndex xor 1)]:=StopMinor;

            Inc(Index,2);

            Inc(Cell);

            Inc(Line,GetExtent(Cell)+EffectiveLineWidth);

          until Line>StopMajor;

          {2 integers per point, 2 points per line -> Index div 4}

          PolyPolyLine(Canvas.Handle,Points^,StrokeList^,Index shr 2);

        end;

      end;

    end;

  begin

    if (CellBounds[0]=CellBounds[2])or(CellBounds[1]=CellBounds[3]) then Exit;

    if not DoHorz then

    begin

      DrawAxisLines(DrawInfo.Vert,Row,1,DoHorz);

      DrawAxisLines(DrawInfo.Horz,Col,0,DoVert);

    end

    else

    begin

      DrawAxisLines(DrawInfo.Horz,Col,0,DoVert);

      DrawAxisLines(DrawInfo.Vert,Row,1,DoHorz);

    end;

  end;

  procedure DrawCells(ACol,ARow:Longint;StartX,StartY,StopX,StopY:Integer;

    Color:TColor;IncludeDrawState:TGridDrawState);

  var

    CurCol,CurRow:Longint;

    AWhere,Where,TempRect:TRect;

    DrawState:TGridDrawState;

    Focused:Boolean;

  begin

    CurRow:=ARow;

    Where.Top:=StartY;

    while (Where.Top<StopY)and(CurRow<RowCount) do

    begin

      CurCol:=ACol;

      Where.Left:=StartX;

      Where.Bottom:=Where.Top+RowHeights[CurRow];

      while (Where.Left<StopX)and(CurCol<ColCount) do

      begin

        Where.Right:=Where.Left+ColWidths[CurCol];

        if (Where.Right>Where.Left)and RectVisible(Canvas.Handle,Where) then

        begin

          DrawState:=IncludeDrawState;

          Focused:=IsActiveControl;

          if Focused and(CurRow=Row)and(CurCol=Col) then

              Include(DrawState,gdFocused);

          if PointInGridRect(CurCol,CurRow,Sel) then

              Include(DrawState,gdSelected);

          if not(gdFocused in DrawState)or not(goEditing in Options)or

            not FEditorMode or(csDesigning in ComponentState) then

          begin

            if DefaultDrawing or(csDesigning in ComponentState) then

              with Canvas do

              begin

                Font:=Self.Font;

                if (gdSelected in DrawState)and

                  (not(gdFocused in DrawState)or

                  ([goDrawFocusSelected{, goRowSelect}]*Options<>[])) then

                begin

                  Brush.Color:=clHighlight;

                  Font.Color:=clHighlightText;

                end

                else

                    Brush.Color:=Color;

                FillRect(Where);

              end;

            DrawCell(CurCol,CurRow,Where,DrawState);

            if DefaultDrawing and(gdFixed in DrawState)and Ctl3D and

              ((FrameFlags1 or FrameFlags2)<>0) then

            begin

              TempRect:=Where;

              if (FrameFlags1 and BF_RIGHT)=0 then

                  Inc(TempRect.Right,DrawInfo.Horz.EffectiveLineWidth)

              else if (FrameFlags1 and BF_BOTTOM)=0 then

                  Inc(TempRect.Bottom,DrawInfo.Vert.EffectiveLineWidth);

              DrawEdge(Canvas.Handle,TempRect,BDR_RAISEDINNER,FrameFlags1);// my

              DrawEdge(Canvas.Handle,TempRect,BDR_RAISEDINNER,FrameFlags2);// change

            end;

            if DefaultDrawing and not(csDesigning in ComponentState)and

              (gdFocused in DrawState)and

              ([goEditing,goAlwaysShowEditor]*Options<>

              [goEditing,goAlwaysShowEditor])and(PropValues[CurRow].EditMode<>emNoEdit)

            {and not (goRowSelect in Options)} then

            begin

              if not UseRightToLeftAlignment then

                  DrawFocusRect(Canvas.Handle,Where)

              else

              begin

                AWhere:=Where;

                AWhere.Left:=Where.Right;

                AWhere.Right:=Where.Left;

                DrawFocusRect(Canvas.Handle,AWhere);

              end;

            end;

          end;

        end;

        Where.Left:=Where.Right+DrawInfo.Horz.EffectiveLineWidth;

        Inc(CurCol);

      end;

      Where.Top:=Where.Bottom+DrawInfo.Vert.EffectiveLineWidth;

      Inc(CurRow);

    end;

  end;

begin

  if UseRightToLeftAlignment then ChangeGridOrientation(True);

  UpdateRect:=Canvas.ClipRect;

  CalcDrawInfo(DrawInfo);

  with DrawInfo do

  begin

    if (Horz.EffectiveLineWidth>0)or(Vert.EffectiveLineWidth>0) then

    begin

      {Draw the grid line in the four areas (fixed, fixed), (variable, fixed),

       (fixed, variable) and (variable, variable)}

      LineColor:=clSilver;

      MaxStroke:=Max(Horz.LastFullVisibleCell-LeftCol+FixedCols,

        Vert.LastFullVisibleCell-TopRow+FixedRows)+3;

      PointsList:=StackAlloc(MaxStroke*SizeOf(TPoint)*2);

      StrokeList:=StackAlloc(MaxStroke*SizeOf(Integer));

      FillDWord(StrokeList^,MaxStroke,2);

      if ColorToRGB(Color)=clSilver then LineColor:=clGray;

      DrawLines(goFixedHorzLine in Options,goFixedVertLine in Options,

        0,0,[0,0,Horz.FixedBoundary,Vert.FixedBoundary],clBtnFace,FixedColor);

      DrawLines(goFixedHorzLine in Options,goFixedVertLine in Options,

        LeftCol,0,[Horz.FixedBoundary,0,Horz.GridBoundary,

        Vert.FixedBoundary],clBtnFace,FixedColor);

      DrawLines(goFixedHorzLine in Options,goFixedVertLine in Options,

        0,TopRow,[0,Vert.FixedBoundary,Horz.FixedBoundary,

        Vert.GridBoundary],clBtnFace,FixedColor);

      DrawLines(goHorzLine in Options,goVertLine in Options,LeftCol,

        TopRow,[Horz.FixedBoundary,Vert.FixedBoundary,Horz.GridBoundary,

        Vert.GridBoundary],LineColor,Color);

      StackFree(StrokeList);

      StackFree(PointsList);

    end;

    {Draw the cells in the four areas}

    Sel:=Selection;

    FrameFlags1:=0;

    FrameFlags2:=0;

    if goFixedVertLine in Options then

    begin

      FrameFlags1:=BF_RIGHT;

      FrameFlags2:=BF_LEFT;

    end;

    if goFixedHorzLine in Options then

    begin

      FrameFlags1:=FrameFlags1 or BF_BOTTOM;

      FrameFlags2:=FrameFlags2 or BF_TOP;

    end;

    DrawCells(0,0,0,0,Horz.FixedBoundary,Vert.FixedBoundary,FixedColor,

      [gdFixed]);

    DrawCells(LeftCol,0,Horz.FixedBoundary-FColOffset,0,Horz.GridBoundary,// !! clip

      Vert.FixedBoundary,FixedColor,[gdFixed]);

    DrawCells(0,TopRow,0,Vert.FixedBoundary,Horz.FixedBoundary,

      Vert.GridBoundary,FixedColor,[gdFixed]);

    DrawCells(LeftCol,TopRow,Horz.FixedBoundary-FColOffset,// !! clip

      Vert.FixedBoundary,Horz.GridBoundary,Vert.GridBoundary,Color,[]);

    if not(csDesigning in ComponentState)and

    {(goRowSelect in Options) and}DefaultDrawing and Focused then

    begin

      GridRectToScreenRect(GetSelection,FocRect,False);

      if not UseRightToLeftAlignment then

          Canvas.DrawFocusRect(FocRect)

      else

      begin

        AFocRect:=FocRect;

        AFocRect.Left:=FocRect.Right;

        AFocRect.Right:=FocRect.Left;

        DrawFocusRect(Canvas.Handle,AFocRect);

      end;

    end;

    {Fill in area not occupied by cells}

    if Horz.GridBoundary<Horz.GridExtent then

    begin

      Canvas.Brush.Color:=Color;

      Canvas.FillRect(Rect(Horz.GridBoundary,0,Horz.GridExtent,Vert.GridBoundary));

    end;

    if Vert.GridBoundary<Vert.GridExtent then

    begin

      Canvas.Brush.Color:=Color;

      Canvas.FillRect(Rect(0,Vert.GridBoundary,Horz.GridExtent,Vert.GridExtent));

    end;

  end;

  if UseRightToLeftAlignment then ChangeGridOrientation(False);

end;

function TCustomPrGrid.CalcCoordFromPoint(X,Y:Integer;

  const DrawInfo:TGridDrawInfo):TGridCoord;

  function DoCalc(const AxisInfo:TGridAxisDrawInfo;N:Integer):Integer;

  var

    I,Start,Stop:Longint;

    Line:Integer;

  begin

    with AxisInfo do

    begin

      if N<FixedBoundary then

      begin

        Start:=0;

        Stop:=FixedCellCount-1;

        Line:=0;

      end

      else

      begin

        Start:=FirstGridCell;

        Stop:=GridCellCount-1;

        Line:=FixedBoundary;

      end;

      Result:=-1;

      for I:=Start to Stop do

      begin

        Inc(Line,GetExtent(I)+EffectiveLineWidth);

        if N<Line then

        begin

          Result:=I;

          Exit;

        end;

      end;

    end;

  end;

  function DoCalcRightToLeft(const AxisInfo:TGridAxisDrawInfo;N:Integer):Integer;

  var

    I,Start,Stop:Longint;

    Line:Integer;

  begin

    N:=ClientWidth-N;

    with AxisInfo do

    begin

      if N<FixedBoundary then

      begin

        Start:=0;

        Stop:=FixedCellCount-1;

        Line:=ClientWidth;

      end

      else

      begin

        Start:=FirstGridCell;

        Stop:=GridCellCount-1;

        Line:=FixedBoundary;

      end;

      Result:=-1;

      for I:=Start to Stop do

      begin

        Inc(Line,GetExtent(I)+EffectiveLineWidth);

        if N<Line then

        begin

          Result:=I;

          Exit;

        end;

      end;

    end;

  end;

begin

  if not UseRightToLeftAlignment then

      Result.X:=DoCalc(DrawInfo.Horz,X)

  else

      Result.X:=DoCalcRightToLeft(DrawInfo.Horz,X);

  Result.Y:=DoCalc(DrawInfo.Vert,Y);

end;

procedure TCustomPrGrid.CalcDrawInfo(var DrawInfo:TGridDrawInfo);

begin

  CalcDrawInfoXY(DrawInfo,ClientWidth,ClientHeight);

end;

procedure TCustomPrGrid.CalcDrawInfoXY(var DrawInfo:TGridDrawInfo;

  UseWidth,UseHeight:Integer);

  procedure CalcAxis(var AxisInfo:TGridAxisDrawInfo;UseExtent:Integer);

  var

    I:Integer;

  begin

    with AxisInfo do

    begin

      GridExtent:=UseExtent;

      GridBoundary:=FixedBoundary;

      FullVisBoundary:=FixedBoundary;

      LastFullVisibleCell:=FirstGridCell;

      for I:=FirstGridCell to GridCellCount-1 do

      begin

        Inc(GridBoundary,GetExtent(I)+EffectiveLineWidth);

        if GridBoundary>GridExtent+EffectiveLineWidth then

        begin

          GridBoundary:=GridExtent;

          Break;

        end;

        LastFullVisibleCell:=I;

        FullVisBoundary:=GridBoundary;

      end;

    end;

  end;

begin

  CalcFixedInfo(DrawInfo);

  CalcAxis(DrawInfo.Horz,UseWidth);

  CalcAxis(DrawInfo.Vert,UseHeight);

end;

procedure TCustomPrGrid.CalcFixedInfo(var DrawInfo:TGridDrawInfo);

  procedure CalcFixedAxis(var Axis:TGridAxisDrawInfo;LineOptions:TGridOptions;

    FixedCount,FirstCell,CellCount:Integer;GetExtentFunc:TGetExtentsFunc);

  var

    I:Integer;

  begin

    with Axis do

    begin

      if LineOptions*Options=[] then

          EffectiveLineWidth:=0

      else

          EffectiveLineWidth:=GridLineWidth;

      FixedBoundary:=0;

      for I:=0 to FixedCount-1 do

          Inc(FixedBoundary,GetExtentFunc(I)+EffectiveLineWidth);

      FixedCellCount:=FixedCount;

      FirstGridCell:=FirstCell;

      GridCellCount:=CellCount;

      GetExtent:=GetExtentFunc;

    end;

  end;

begin

  CalcFixedAxis(DrawInfo.Horz,[goFixedVertLine,goVertLine],FixedCols,

    LeftCol,ColCount,GetColWidths);

  CalcFixedAxis(DrawInfo.Vert,[goFixedHorzLine,goHorzLine],FixedRows,

    TopRow,RowCount,GetRowHeights);

end;

{Calculates the TopLeft that will put the given Coord in view}

function TCustomPrGrid.CalcMaxTopLeft(const Coord:TGridCoord;

  const DrawInfo:TGridDrawInfo):TGridCoord;

  function CalcMaxCell(const Axis:TGridAxisDrawInfo;Start:Integer):Integer;

  var

    Line:Integer;

    I,Extent:Longint;

  begin

    Result:=Start;

    with Axis do

    begin

      Line:=GridExtent+EffectiveLineWidth;

      for I:=Start downto FixedCellCount do

      begin

        Extent:=GetExtent(I);

        if Extent>0 then

        begin

          Dec(Line,Extent);

          Dec(Line,EffectiveLineWidth);

          if Line<FixedBoundary then

          begin

            if (Result=Start)and(GetExtent(Start)<=0) then

                Result:=I;

            Break;

          end;

          Result:=I;

        end;

      end;

    end;

  end;

begin

  Result.X:=CalcMaxCell(DrawInfo.Horz,Coord.X);

  Result.Y:=CalcMaxCell(DrawInfo.Vert,Coord.Y);

end;

procedure TCustomPrGrid.CalcSizingState(X,Y:Integer;var State:TGridState;

  var Index:Longint;var SizingPos,SizingOfs:Integer;

  var FixedInfo:TGridDrawInfo);

  procedure CalcAxisState(const AxisInfo:TGridAxisDrawInfo;Pos:Integer;

    NewState:TGridState);

  var

    I,Line,Back,Range:Integer;

  begin

    if UseRightToLeftAlignment then

        Pos:=ClientWidth-Pos;

    with AxisInfo do

    begin

      Line:=FixedBoundary;

      Range:=EffectiveLineWidth;

      Back:=0;

      if Range<7 then

      begin

        Range:=7;

        Back:=(Range-EffectiveLineWidth) shr 1;

      end;

      for I:=FirstGridCell to GridCellCount-1 do

      begin

        Inc(Line,GetExtent(I));

        if Line>GridBoundary then Break;

        if (Pos>=Line-Back)and(Pos<=Line-Back+Range) then

        begin

          State:=NewState;

          SizingPos:=Line;

          SizingOfs:=Line-Pos;

          Index:=I;

          Exit;

        end;

        Inc(Line,EffectiveLineWidth);

      end;

      if (GridBoundary=GridExtent)and(Pos>=GridExtent-Back)

        and(Pos<=GridExtent) then

      begin

        State:=NewState;

        SizingPos:=GridExtent;

        SizingOfs:=GridExtent-Pos;

        Index:=LastFullVisibleCell+1;

      end;

    end;

  end;

  function XOutsideHorzFixedBoundary:Boolean;

  begin

    with FixedInfo do

      if not UseRightToLeftAlignment then

          Result:=X>Horz.FixedBoundary

      else

          Result:=X<ClientWidth-Horz.FixedBoundary;

  end;

  function XOutsideOrEqualHorzFixedBoundary:Boolean;

  begin

    with FixedInfo do

      if not UseRightToLeftAlignment then

          Result:=X>=Horz.FixedBoundary

      else

          Result:=X<=ClientWidth-Horz.FixedBoundary;

  end;

var

  EffectiveOptions:TGridOptions;

begin

  State:=gsNormal;

  Index:=-1;

  EffectiveOptions:=Options;

  if csDesigning in ComponentState then

      EffectiveOptions:=EffectiveOptions+DesignOptionsBoost;

  if [goColSizing,goRowSizing]*EffectiveOptions<>[] then

    with FixedInfo do

    begin

      Vert.GridExtent:=ClientHeight;

      Horz.GridExtent:=ClientWidth;

      if (XOutsideHorzFixedBoundary)and(goColSizing in EffectiveOptions) then

      begin

        if Y>=Vert.FixedBoundary then Exit;

        CalcAxisState(Horz,X,gsColSizing);

      end

      else if (Y>Vert.FixedBoundary)and(goRowSizing in EffectiveOptions) then

      begin

        if XOutsideOrEqualHorzFixedBoundary then Exit;

        CalcAxisState(Vert,Y,gsRowSizing);

      end;

    end;

end;

procedure TCustomPrGrid.ChangeGridOrientation(RightToLeftOrientation:Boolean);

var

  Org:TPoint;

  Ext:TPoint;

begin

  if RightToLeftOrientation then

  begin

    Org:=Point(ClientWidth,0);

    Ext:=Point(-1,1);

    SetMapMode(Canvas.Handle,mm_Anisotropic);

    SetWindowOrgEx(Canvas.Handle,Org.X,Org.Y,nil);

    SetViewportExtEx(Canvas.Handle,ClientWidth,ClientHeight,nil);

    SetWindowExtEx(Canvas.Handle,Ext.X*ClientWidth,Ext.Y*ClientHeight,nil);

  end

  else

  begin

    Org:=Point(0,0);

    Ext:=Point(1,1);

    SetMapMode(Canvas.Handle,mm_Anisotropic);

    SetWindowOrgEx(Canvas.Handle,Org.X,Org.Y,nil);

    SetViewportExtEx(Canvas.Handle,ClientWidth,ClientHeight,nil);

    SetWindowExtEx(Canvas.Handle,Ext.X*ClientWidth,Ext.Y*ClientHeight,nil);

  end;

end;

procedure TCustomPrGrid.ChangeSize(NewColCount,NewRowCount:Longint);

var

  OldColCount,OldRowCount:Longint;

  OldDrawInfo:TGridDrawInfo;

  procedure MinRedraw(const OldInfo,NewInfo:TGridAxisDrawInfo;Axis:Integer);

  var

    R:TRect;

    First:Integer;

  begin

    First:=Min(OldInfo.LastFullVisibleCell,NewInfo.LastFullVisibleCell);

    // Get the rectangle around the leftmost or topmost cell in the target range.

    R:=CellRect(First and not Axis,First and Axis);

    R.Bottom:=Height;

    R.Right:=Width;

    Windows.InvalidateRect(Handle,@R,False);

  end;

  procedure DoChange;

  var

    Coord:TGridCoord;

    NewDrawInfo:TGridDrawInfo;

  begin

    if FColWidths<>nil then

    begin

      UpdateExtents(FColWidths,ColCount,DefaultNameColWidth);

      UpdateExtents(FTabStops,ColCount,Integer(True));

    end;

    if FRowHeights<>nil then

        UpdateExtents(FRowHeights,RowCount,DefaultRowHeight);

    Coord:=FCurrent;

    if Row>=RowCount then Coord.Y:=RowCount-1;

    if Col>=ColCount then Coord.X:=ColCount-1;

    if (FCurrent.X<>Coord.X)or(FCurrent.Y<>Coord.Y) then

        MoveCurrent(Coord.X,Coord.Y,True,True);

    if (FAnchor.X<>Coord.X)or(FAnchor.Y<>Coord.Y) then

        MoveAnchor(Coord);

    if VirtualView or

      (LeftCol<>OldDrawInfo.Horz.FirstGridCell)or

      (TopRow<>OldDrawInfo.Vert.FirstGridCell) then

        InvalidateGrid

    else if HandleAllocated then

    begin

      CalcDrawInfo(NewDrawInfo);

      MinRedraw(OldDrawInfo.Horz,NewDrawInfo.Horz,0);

      MinRedraw(OldDrawInfo.Vert,NewDrawInfo.Vert,-1);

    end;

    SizeChanged(OldColCount,OldRowCount);

  end;

begin

  if HandleAllocated then

      CalcDrawInfo(OldDrawInfo);

  OldColCount:=FColCount;

  OldRowCount:=FRowCount;

  FColCount:=NewColCount;

  FRowCount:=NewRowCount;

  if FixedCols>NewColCount then FFixedCols:=NewColCount-1;

  if FixedRows>NewRowCount then FFixedRows:=NewRowCount-1;

  try

      DoChange;

  except

    {Could not change size so try to clean up by setting the size back}

    FColCount:=OldColCount;

    FRowCount:=OldRowCount;

    DoChange;

    InvalidateGrid;

    raise;

  end;

end;

{Will move TopLeft so that Coord is in view}

procedure TCustomPrGrid.ClampInView(const Coord:TGridCoord);

var

  DrawInfo:TGridDrawInfo;

  MaxTopLeft:TGridCoord;

  OldTopLeft:TGridCoord;

begin

  if not HandleAllocated then Exit;

  CalcDrawInfo(DrawInfo);

  with DrawInfo,Coord do

  begin

    if (X>Horz.LastFullVisibleCell)or

      (Y>Vert.LastFullVisibleCell)or(X<LeftCol)or(Y<TopRow) then

    begin

      OldTopLeft:=FTopLeft;

      MaxTopLeft:=CalcMaxTopLeft(Coord,DrawInfo);

      Update;

      if X<LeftCol then FTopLeft.X:=X

      else if X>Horz.LastFullVisibleCell then FTopLeft.X:=MaxTopLeft.X;

      if Y<TopRow then FTopLeft.Y:=Y

      else if Y>Vert.LastFullVisibleCell then FTopLeft.Y:=MaxTopLeft.Y;

      TopLeftMoved(OldTopLeft);

    end;

  end;

end;

procedure TCustomPrGrid.DrawSizingLine(const DrawInfo:TGridDrawInfo);

var

  OldPen:TPen;

begin

  OldPen:=TPen.Create;

  try

    with Canvas,DrawInfo do

    begin

      OldPen.Assign(Pen);

      Pen.Style:=psDot;

      Pen.Mode:=pmXor;

      Pen.Width:=1;

      try

        if FGridState=gsRowSizing then

        begin

          MoveTo(0,FSizingPos);

          LineTo(Horz.GridBoundary,FSizingPos);

        end

        else

        begin

          MoveTo(FSizingPos,0);

          LineTo(FSizingPos,Vert.GridBoundary);

        end;

      finally

          Pen:=OldPen;

      end;

    end;

  finally

      OldPen.Free;

  end;

end;

procedure TCustomPrGrid.DrawMove;

var

  OldPen:TPen;

  Pos:Integer;

  R:TRect;

begin

  OldPen:=TPen.Create;

  try

    with Canvas do

    begin

      OldPen.Assign(Pen);

      try

        Pen.Style:=psDot;

        Pen.Mode:=pmXor;

        Pen.Width:=5;

        if FGridState=gsRowMoving then

        begin

          R:=CellRect(0,FMovePos);

          if FMovePos>FMoveIndex then

              Pos:=R.Bottom
          else

              Pos:=R.Top;

          MoveTo(0,Pos);

          LineTo(ClientWidth,Pos);

        end

        else

        begin

          R:=CellRect(FMovePos,0);

          if FMovePos>FMoveIndex then

            if not UseRightToLeftAlignment then

                Pos:=R.Right

            else

                Pos:=R.Left

          else

            if not UseRightToLeftAlignment then

              Pos:=R.Left

          else

              Pos:=R.Right;

          MoveTo(Pos,0);

          LineTo(Pos,ClientHeight);

        end;

      finally

          Canvas.Pen:=OldPen;

      end;

    end;

  finally

      OldPen.Free;

  end;

end;

procedure TCustomPrGrid.FocusCell(ACol,ARow:Longint;MoveAnchor:Boolean);

begin

  MoveCurrent(ACol,ARow,MoveAnchor,True);

  UpdateEdit;

  Click;

end;

procedure TCustomPrGrid.GridRectToScreenRect(GridRect:TGridRect;

  var ScreenRect:TRect;IncludeLine:Boolean);

  function LinePos(const AxisInfo:TGridAxisDrawInfo;Line:Integer):Integer;

  var

    Start,I:Longint;

  begin

    with AxisInfo do

    begin

      Result:=0;

      if Line<FixedCellCount then

          Start:=0

      else

      begin

        if Line>=FirstGridCell then

            Result:=FixedBoundary;

        Start:=FirstGridCell;

      end;

      for I:=Start to Line-1 do

      begin

        Inc(Result,GetExtent(I)+EffectiveLineWidth);

        if Result>GridExtent then

        begin

          Result:=0;

          Exit;

        end;

      end;

    end;

  end;

  function CalcAxis(const AxisInfo:TGridAxisDrawInfo;

    GridRectMin,GridRectMax:Integer;

    var ScreenRectMin,ScreenRectMax:Integer):Boolean;

  begin

    Result:=False;

    with AxisInfo do

    begin

      if (GridRectMin>=FixedCellCount)and(GridRectMin<FirstGridCell) then

        if GridRectMax<FirstGridCell then

        begin

          FillChar(ScreenRect,SizeOf(ScreenRect),0);{erase partial results}

          Exit;

        end

        else

            GridRectMin:=FirstGridCell;

      if GridRectMax>LastFullVisibleCell then

      begin

        GridRectMax:=LastFullVisibleCell;

        if GridRectMax<GridCellCount-1 then Inc(GridRectMax);

        if LinePos(AxisInfo,GridRectMax)=0 then

            Dec(GridRectMax);

      end;

      ScreenRectMin:=LinePos(AxisInfo,GridRectMin);

      ScreenRectMax:=LinePos(AxisInfo,GridRectMax);

      if ScreenRectMax=0 then

          ScreenRectMax:=ScreenRectMin+GetExtent(GridRectMin)

      else

          Inc(ScreenRectMax,GetExtent(GridRectMax));

      if ScreenRectMax>GridExtent then

          ScreenRectMax:=GridExtent;

      if IncludeLine then Inc(ScreenRectMax,EffectiveLineWidth);

    end;

    Result:=True;

  end;

var

  DrawInfo:TGridDrawInfo;

  Hold:Integer;

begin

  FillChar(ScreenRect,SizeOf(ScreenRect),0);

  if (GridRect.Left>GridRect.Right)or(GridRect.Top>GridRect.Bottom) then

      Exit;

  CalcDrawInfo(DrawInfo);

  with DrawInfo do

  begin

    if GridRect.Left>Horz.LastFullVisibleCell+1 then Exit;

    if GridRect.Top>Vert.LastFullVisibleCell+1 then Exit;

    if CalcAxis(Horz,GridRect.Left,GridRect.Right,ScreenRect.Left,

      ScreenRect.Right) then

    begin

      CalcAxis(Vert,GridRect.Top,GridRect.Bottom,ScreenRect.Top,

        ScreenRect.Bottom);

    end;

  end;

  if UseRightToLeftAlignment and(Canvas.CanvasOrientation=coLeftToRight) then

  begin

    Hold:=ScreenRect.Left;

    ScreenRect.Left:=ClientWidth-ScreenRect.Right;

    ScreenRect.Right:=ClientWidth-Hold;

  end;

end;

procedure TCustomPrGrid.Initialize;

begin

  FTopLeft.X:=FixedCols;

  FTopLeft.Y:=FixedRows;

  FCurrent:=FTopLeft;

  FAnchor:=FCurrent;

  // if goRowSelect in Options then FAnchor.X := ColCount - 1;

  if goAlwaysShowEditor in Options then ShowEditor;

end;

procedure TCustomPrGrid.InvalidateCell(ACol,ARow:Longint);

var

  Rect:TGridRect;

begin

  Rect.Top:=ARow;

  Rect.Left:=ACol;

  Rect.Bottom:=ARow;

  Rect.Right:=ACol;

  InvalidateRect(Rect);

end;

procedure TCustomPrGrid.InvalidateCol(ACol:Longint);

var

  Rect:TGridRect;

begin

  if not HandleAllocated then Exit;

  Rect.Top:=0;

  Rect.Left:=ACol;

  Rect.Bottom:=VisibleRowCount+1;

  Rect.Right:=ACol;

  InvalidateRect(Rect);

end;

procedure TCustomPrGrid.InvalidateRow(ARow:Longint);

var

  Rect:TGridRect;

begin

  if not HandleAllocated then Exit;

  Rect.Top:=ARow;

  Rect.Left:=0;

  Rect.Bottom:=ARow;

  Rect.Right:=VisibleColCount+1;

  InvalidateRect(Rect);

end;

procedure TCustomPrGrid.InvalidateGrid;

begin

  Invalidate;

end;

procedure TCustomPrGrid.InvalidateRect(ARect:TGridRect);

var

  InvalidRect:TRect;

begin

  if not HandleAllocated then Exit;

  GridRectToScreenRect(ARect,InvalidRect,True);

  Windows.InvalidateRect(Handle,@InvalidRect,False);

end;

procedure TCustomPrGrid.ModifyScrollBar(ScrollBar,ScrollCode,Pos:Cardinal;

  UseRightToLeft:Boolean);

var

  NewTopLeft,MaxTopLeft:TGridCoord;

  DrawInfo:TGridDrawInfo;

  RTLFactor:Integer;

  function Min:Longint;

  begin

    if ScrollBar=SB_HORZ then Result:=FixedCols

    else Result:=FixedRows;

  end;

  function Max:Longint;

  begin

    if ScrollBar=SB_HORZ then Result:=MaxTopLeft.X

    else Result:=MaxTopLeft.Y;

  end;

  function PageUp:Longint;

  var

    MaxTopLeft:TGridCoord;

  begin

    MaxTopLeft:=CalcMaxTopLeft(FTopLeft,DrawInfo);

    if ScrollBar=SB_HORZ then

        Result:=FTopLeft.X-MaxTopLeft.X
    else

        Result:=FTopLeft.Y-MaxTopLeft.Y;

    if Result<1 then Result:=1;

  end;

  function PageDown:Longint;

  var

    DrawInfo:TGridDrawInfo;

  begin

    CalcDrawInfo(DrawInfo);

    with DrawInfo do

      if ScrollBar=SB_HORZ then

          Result:=Horz.LastFullVisibleCell-FTopLeft.X
      else

          Result:=Vert.LastFullVisibleCell-FTopLeft.Y;

    if Result<1 then Result:=1;

  end;

  function CalcScrollBar(Value,ARTLFactor:Longint):Longint;

  begin

    Result:=Value;

    case ScrollCode of

      SB_LINEUP:

        Dec(Result,ARTLFactor);

      SB_LINEDOWN:

        Inc(Result,ARTLFactor);

      SB_PAGEUP:

        Dec(Result,PageUp*ARTLFactor);

      SB_PAGEDOWN:

        Inc(Result,PageDown*ARTLFactor);

      SB_THUMBPOSITION,SB_THUMBTRACK:

        if (goThumbTracking in Options)or(ScrollCode=SB_THUMBPOSITION) then

        begin

          if (not UseRightToLeftAlignment)or(ARTLFactor=1) then

              Result:=Min+LongMulDiv(Pos,Max-Min,MaxShortInt)

          else

              Result:=Max-LongMulDiv(Pos,Max-Min,MaxShortInt);

        end;

      SB_BOTTOM:

        Result:=Max;

      SB_TOP:

        Result:=Min;

    end;

  end;

  procedure ModifyPixelScrollBar(Code,Pos:Cardinal);

  var

    NewOffset:Integer;

    OldOffset:Integer;

    R:TGridRect;

    GridSpace,ColWidth:Integer;

  begin

    NewOffset:=FColOffset;

    ColWidth:=ColWidths[DrawInfo.Horz.FirstGridCell];

    GridSpace:=ClientWidth-DrawInfo.Horz.FixedBoundary;

    case Code of

      SB_LINEUP:Dec(NewOffset,Canvas.TextWidth('0')*RTLFactor);

      SB_LINEDOWN:Inc(NewOffset,Canvas.TextWidth('0')*RTLFactor);

      SB_PAGEUP:Dec(NewOffset,GridSpace*RTLFactor);

      SB_PAGEDOWN:Inc(NewOffset,GridSpace*RTLFactor);

      SB_THUMBPOSITION,

        SB_THUMBTRACK:

        if (goThumbTracking in Options)or(Code=SB_THUMBPOSITION) then

        begin

          if not UseRightToLeftAlignment then

              NewOffset:=Pos

          else

              NewOffset:=Max-Integer(Pos);

        end;

      SB_BOTTOM:NewOffset:=0;

      SB_TOP:NewOffset:=ColWidth-GridSpace;

    end;

    if NewOffset<0 then

        NewOffset:=0

    else if NewOffset>=ColWidth-GridSpace then

        NewOffset:=ColWidth-GridSpace;

    if NewOffset<>FColOffset then

    begin

      OldOffset:=FColOffset;

      FColOffset:=NewOffset;

      ScrollData(OldOffset-NewOffset,0);

      FillChar(R,SizeOf(R),0);

      R.Bottom:=FixedRows;

      InvalidateRect(R);

      Update;

      UpdateScrollPos;

    end;

  end;

var

  Temp:Longint;

begin

  if (not UseRightToLeftAlignment)or(not UseRightToLeft) then

      RTLFactor:=1

  else

      RTLFactor:=-1;

  if Visible and CanFocus and TabStop and not(csDesigning in ComponentState) then

      SetFocus;

  CalcDrawInfo(DrawInfo);

  if (ScrollBar=SB_HORZ)and(ColCount=1) then

  begin

    ModifyPixelScrollBar(ScrollCode,Pos);

    Exit;

  end;

  MaxTopLeft.X:=ColCount-1;

  MaxTopLeft.Y:=RowCount-1;

  MaxTopLeft:=CalcMaxTopLeft(MaxTopLeft,DrawInfo);

  NewTopLeft:=FTopLeft;

  if ScrollBar=SB_HORZ then

    repeat

      Temp:=NewTopLeft.X;

      NewTopLeft.X:=CalcScrollBar(NewTopLeft.X,RTLFactor);

    until (NewTopLeft.X<=FixedCols)or(NewTopLeft.X>=MaxTopLeft.X)

      or(ColWidths[NewTopLeft.X]>0)or(Temp=NewTopLeft.X)

  else

    repeat

      Temp:=NewTopLeft.Y;

      NewTopLeft.Y:=CalcScrollBar(NewTopLeft.Y,1);

    until (NewTopLeft.Y<=FixedRows)or(NewTopLeft.Y>=MaxTopLeft.Y)

      or(RowHeights[NewTopLeft.Y]>0)or(Temp=NewTopLeft.Y);

  NewTopLeft.X:=Math.Max(FixedCols,Math.Min(MaxTopLeft.X,NewTopLeft.X));

  NewTopLeft.Y:=Math.Max(FixedRows,Math.Min(MaxTopLeft.Y,NewTopLeft.Y));

  if (NewTopLeft.X<>FTopLeft.X)or(NewTopLeft.Y<>FTopLeft.Y) then

      MoveTopLeft(NewTopLeft.X,NewTopLeft.Y);

end;

procedure TCustomPrGrid.MoveAdjust(var CellPos:Longint;FromIndex,ToIndex:Longint);

var

  Min,Max:Longint;

begin

  if CellPos=FromIndex then CellPos:=ToIndex

  else

  begin

    Min:=FromIndex;

    Max:=ToIndex;

    if FromIndex>ToIndex then

    begin

      Min:=ToIndex;

      Max:=FromIndex;

    end;

    if (CellPos>=Min)and(CellPos<=Max) then

      if FromIndex>ToIndex then

          Inc(CellPos)
      else

          Dec(CellPos);

  end;

end;

procedure TCustomPrGrid.MoveAnchor(const NewAnchor:TGridCoord);

var

  OldSel:TGridRect;

begin

  if [goRangeSelect,goEditing]*Options=[goRangeSelect] then

  begin

    OldSel:=Selection;

    FAnchor:=NewAnchor;

    // if goRowSelect in Options then FAnchor.X := ColCount - 1;

    ClampInView(NewAnchor);

    SelectionMoved(OldSel);

  end

  else MoveCurrent(NewAnchor.X,NewAnchor.Y,True,True);

end;

procedure TCustomPrGrid.MoveCurrent(ACol,ARow:Longint;MoveAnchor,

  Show:Boolean);

var

  OldSel:TGridRect;

  OldCurrent:TGridCoord;

begin

  if (ACol<0)or(ARow<0)or(ACol>=ColCount)or(ARow>=RowCount) then

      InvalidOp(SIndexOutOfRange);

  FInplaceEdit.ValidateEdit;

  if SelectCell(ACol,ARow) then

  begin

    OldSel:=Selection;

    OldCurrent:=FCurrent;

    FCurrent.X:=ACol;

    FCurrent.Y:=ARow;

    if not(goAlwaysShowEditor in Options) then HideEditor;

    if MoveAnchor or not(goRangeSelect in Options) then

    begin

      FAnchor:=FCurrent;

      // if goRowSelect in Options then FAnchor.X := ColCount - 1;

    end;

    // if goRowSelect in Options then FCurrent.X := FixedCols;

    if Show then ClampInView(FCurrent);

    SelectionMoved(OldSel);

    with OldCurrent do InvalidateCell(X,Y);

    with FCurrent do InvalidateCell(ACol,ARow);

  end;

end;

procedure TCustomPrGrid.MoveTopLeft(ALeft,ATop:Longint);

var

  OldTopLeft:TGridCoord;

begin

  if (ALeft=FTopLeft.X)and(ATop=FTopLeft.Y) then Exit;

  Update;

  OldTopLeft:=FTopLeft;

  FTopLeft.X:=ALeft;

  FTopLeft.Y:=ATop;

  TopLeftMoved(OldTopLeft);

end;

procedure TCustomPrGrid.ResizeCol(Index:Longint;OldSize,NewSize:Integer);

begin

  InvalidateGrid;

end;

procedure TCustomPrGrid.ResizeRow(Index:Longint;OldSize,NewSize:Integer);

begin

  InvalidateGrid;

end;

procedure TCustomPrGrid.SelectionMoved(const OldSel:TGridRect);

var

  OldRect,NewRect:TRect;

  AXorRects:TXorRects;

  I:Integer;

begin

  if not HandleAllocated then Exit;

  GridRectToScreenRect(OldSel,OldRect,True);

  GridRectToScreenRect(Selection,NewRect,True);

  XorRects(OldRect,NewRect,AXorRects);

  for I:=Low(AXorRects) to High(AXorRects) do

      Windows.InvalidateRect(Handle,@AXorRects[I],False);

end;

procedure TCustomPrGrid.ScrollDataInfo(DX,DY:Integer;

  var DrawInfo:TGridDrawInfo);

var

  ScrollArea:TRect;

  ScrollFlags:Integer;

begin

  with DrawInfo do

  begin

    ScrollFlags:=SW_INVALIDATE;

    if not DefaultDrawing then

        ScrollFlags:=ScrollFlags or SW_ERASE;

    {Scroll the area}

    if DY=0 then

    begin

      {Scroll both the column titles and data area at the same time}

      if not UseRightToLeftAlignment then

          ScrollArea:=Rect(Horz.FixedBoundary,0,Horz.GridExtent,Vert.GridExtent)

      else

      begin

        ScrollArea:=Rect(ClientWidth-Horz.GridExtent,0,ClientWidth-Horz.FixedBoundary,
          Vert.GridExtent);

        DX:=-DX;

      end;

      ScrollWindowEx(Handle,DX,0,@ScrollArea,@ScrollArea,0,nil,ScrollFlags);

    end

    else if DX=0 then

    begin

      {Scroll both the row titles and data area at the same time}

      ScrollArea:=Rect(0,Vert.FixedBoundary,Horz.GridExtent,Vert.GridExtent);

      ScrollWindowEx(Handle,0,DY,@ScrollArea,@ScrollArea,0,nil,ScrollFlags);

    end

    else

    begin

      {Scroll titles and data area separately}

      {Column titles}

      ScrollArea:=Rect(Horz.FixedBoundary,0,Horz.GridExtent,Vert.FixedBoundary);

      ScrollWindowEx(Handle,DX,0,@ScrollArea,@ScrollArea,0,nil,ScrollFlags);

      {Row titles}

      ScrollArea:=Rect(0,Vert.FixedBoundary,Horz.FixedBoundary,Vert.GridExtent);

      ScrollWindowEx(Handle,0,DY,@ScrollArea,@ScrollArea,0,nil,ScrollFlags);

      {Data area}

      ScrollArea:=Rect(Horz.FixedBoundary,Vert.FixedBoundary,Horz.GridExtent,

        Vert.GridExtent);

      ScrollWindowEx(Handle,DX,DY,@ScrollArea,@ScrollArea,0,nil,ScrollFlags);

    end;

  end;

  // if goRowSelect in Options then

  // InvalidateRect(Selection);

end;

procedure TCustomPrGrid.ScrollData(DX,DY:Integer);

var

  DrawInfo:TGridDrawInfo;

begin

  CalcDrawInfo(DrawInfo);

  ScrollDataInfo(DX,DY,DrawInfo);

end;

procedure TCustomPrGrid.TopLeftMoved(const OldTopLeft:TGridCoord);

  function CalcScroll(const AxisInfo:TGridAxisDrawInfo;

    OldPos,CurrentPos:Integer;var Amount:Longint):Boolean;

  var

    Start,Stop:Longint;

    I:Longint;

  begin

    Result:=False;

    with AxisInfo do

    begin

      if OldPos<CurrentPos then

      begin

        Start:=OldPos;

        Stop:=CurrentPos;

      end

      else

      begin

        Start:=CurrentPos;

        Stop:=OldPos;

      end;

      Amount:=0;

      for I:=Start to Stop-1 do

      begin

        Inc(Amount,GetExtent(I)+EffectiveLineWidth);

        if Amount>(GridBoundary-FixedBoundary) then

        begin

          {Scroll amount too big, redraw the whole thing}

          InvalidateGrid;

          Exit;

        end;

      end;

      if OldPos<CurrentPos then Amount:=-Amount;

    end;

    Result:=True;

  end;

var

  DrawInfo:TGridDrawInfo;

  Delta:TGridCoord;

begin

  UpdateScrollPos;

  CalcDrawInfo(DrawInfo);

  if CalcScroll(DrawInfo.Horz,OldTopLeft.X,FTopLeft.X,Delta.X)and

    CalcScroll(DrawInfo.Vert,OldTopLeft.Y,FTopLeft.Y,Delta.Y) then

      ScrollDataInfo(Delta.X,Delta.Y,DrawInfo);

  TopLeftChanged;

end;

procedure TCustomPrGrid.UpdateScrollPos;

var

  DrawInfo:TGridDrawInfo;

  MaxTopLeft:TGridCoord;

  GridSpace,ColWidth:Integer;

  procedure SetScroll(Code:Word;Value:Integer);

  begin

    if UseRightToLeftAlignment and(Code=SB_HORZ) then

      if ColCount<>1 then Value:=MaxShortInt-Value

      else Value:=(ColWidth-GridSpace)-Value;

    if GetScrollPos(Handle,Code)<>Value then

        SetScrollPos(Handle,Code,Value,True);

  end;

begin

  if (not HandleAllocated)or(ScrollBars=ssNone) then Exit;

  CalcDrawInfo(DrawInfo);

  MaxTopLeft.X:=ColCount-1;

  MaxTopLeft.Y:=RowCount-1;

  MaxTopLeft:=CalcMaxTopLeft(MaxTopLeft,DrawInfo);

  if ScrollBars in [ssHorizontal,ssBoth] then

    if ColCount=1 then

    begin

      ColWidth:=ColWidths[DrawInfo.Horz.FirstGridCell];

      GridSpace:=ClientWidth-DrawInfo.Horz.FixedBoundary;

      if (FColOffset>0)and(GridSpace>(ColWidth-FColOffset)) then

          ModifyScrollBar(SB_HORZ,SB_THUMBPOSITION,ColWidth-GridSpace,True)

      else

          SetScroll(SB_HORZ,FColOffset)

    end

    else

        SetScroll(SB_HORZ,LongMulDiv(FTopLeft.X-FixedCols,MaxShortInt,

        MaxTopLeft.X-FixedCols));

  if ScrollBars in [ssVertical,ssBoth] then

      SetScroll(SB_VERT,LongMulDiv(FTopLeft.Y-FixedRows,MaxShortInt,

      MaxTopLeft.Y-FixedRows));

end;

procedure TCustomPrGrid.UpdateScrollRange;

var

  MaxTopLeft,OldTopLeft:TGridCoord;

  DrawInfo:TGridDrawInfo;

  OldScrollBars:TScrollStyle;

  Updated:Boolean;

  procedure DoUpdate;

  begin

    if not Updated then

    begin

      Update;

      Updated:=True;

    end;

  end;

  function ScrollBarVisible(Code:Word):Boolean;

  var

    Min,Max:Integer;

  begin

    Result:=False;

    if (ScrollBars=ssBoth)or

      ((Code=SB_HORZ)and(ScrollBars=ssHorizontal))or

      ((Code=SB_VERT)and(ScrollBars=ssVertical)) then

    begin

      GetScrollRange(Handle,Code,Min,Max);

      Result:=Min<>Max;

    end;

  end;

  procedure CalcSizeInfo;

  begin

    CalcDrawInfoXY(DrawInfo,DrawInfo.Horz.GridExtent,DrawInfo.Vert.GridExtent);

    MaxTopLeft.X:=ColCount-1;

    MaxTopLeft.Y:=RowCount-1;

    MaxTopLeft:=CalcMaxTopLeft(MaxTopLeft,DrawInfo);

  end;

  procedure SetAxisRange(var Max,Old,Current:Longint;Code:Word;

    Fixeds:Integer);

  begin

    CalcSizeInfo;

    if Fixeds<Max then

        SetScrollRange(Handle,Code,0,MaxShortInt,True)

    else

        SetScrollRange(Handle,Code,0,0,True);

    if Old>Max then

    begin

      DoUpdate;

      Current:=Max;

    end;

  end;

  procedure SetHorzRange;

  var

    Range:Integer;

  begin

    if OldScrollBars in [ssHorizontal,ssBoth] then

      if ColCount=1 then

      begin

        Range:=ColWidths[0]-ClientWidth;

        if Range<0 then Range:=0;

        SetScrollRange(Handle,SB_HORZ,0,Range,True);

      end

      else

          SetAxisRange(MaxTopLeft.X,OldTopLeft.X,FTopLeft.X,SB_HORZ,FixedCols);

  end;

  procedure SetVertRange;

  begin

    if OldScrollBars in [ssVertical,ssBoth] then

        SetAxisRange(MaxTopLeft.Y,OldTopLeft.Y,FTopLeft.Y,SB_VERT,FixedRows);

  end;

begin

  if (ScrollBars=ssNone)or not HandleAllocated or not Showing then Exit;

  with DrawInfo do

  begin

    Horz.GridExtent:=ClientWidth;

    Vert.GridExtent:=ClientHeight;

    {Ignore scroll bars for initial calculation}

    if ScrollBarVisible(SB_HORZ) then

        Inc(Vert.GridExtent,GetSystemMetrics(SM_CYHSCROLL));

    if ScrollBarVisible(SB_VERT) then

        Inc(Horz.GridExtent,GetSystemMetrics(SM_CXVSCROLL));

  end;

  OldTopLeft:=FTopLeft;

  {Temporarily mark us as not having scroll bars to avoid recursion}

  OldScrollBars:=FScrollBars;

  FScrollBars:=ssNone;

  Updated:=False;

  try

    {Update scrollbars}

    SetHorzRange;

    DrawInfo.Vert.GridExtent:=ClientHeight;

    SetVertRange;

    if DrawInfo.Horz.GridExtent<>ClientWidth then

    begin

      DrawInfo.Horz.GridExtent:=ClientWidth;

      SetHorzRange;

    end;

  finally

      FScrollBars:=OldScrollBars;

  end;

  UpdateScrollPos;

  if (FTopLeft.X<>OldTopLeft.X)or(FTopLeft.Y<>OldTopLeft.Y) then

      TopLeftMoved(OldTopLeft);

end;

function TCustomPrGrid.CreateEditor:TPropertyInplaceEdit;

begin

  Result:=TPropertyInplaceEdit.Create(Self);

end;

procedure TCustomPrGrid.CreateParams(var Params:TCreateParams);

begin

  inherited CreateParams(Params);

  with Params do

  begin

    Style:=Style or WS_TABSTOP;

    if FScrollBars in [ssVertical,ssBoth] then Style:=Style or WS_VSCROLL;

    if FScrollBars in [ssHorizontal,ssBoth] then Style:=Style or WS_HSCROLL;

    WindowClass.Style:=CS_DBLCLKS;

    if FBorderStyle=bsSingle then

      if NewStyleControls and Ctl3D then

      begin

        Style:=Style and not WS_BORDER;

        ExStyle:=ExStyle or WS_EX_CLIENTEDGE;

      end

      else

          Style:=Style or WS_BORDER;

  end;

end;

procedure TCustomPrGrid.KeyDown(var Key:Word;Shift:TShiftState);

var

  NewTopLeft,NewCurrent,MaxTopLeft:TGridCoord;

  DrawInfo:TGridDrawInfo;

  PageWidth,PageHeight:Integer;

  RTLFactor:Integer;

  NeedsInvalidating:Boolean;

  procedure CalcPageExtents;

  begin

    CalcDrawInfo(DrawInfo);

    PageWidth:=DrawInfo.Horz.LastFullVisibleCell-LeftCol;

    if PageWidth<1 then PageWidth:=1;

    PageHeight:=DrawInfo.Vert.LastFullVisibleCell-TopRow;

    if PageHeight<1 then PageHeight:=1;

  end;

  procedure Restrict(var Coord:TGridCoord;MinX,MinY,MaxX,MaxY:Longint);

  begin

    with Coord do

    begin

      if X>MaxX then X:=MaxX

      else if X<MinX then X:=MinX;

      if Y>MaxY then Y:=MaxY

      else if Y<MinY then Y:=MinY;

    end;

  end;

begin

  inherited KeyDown(Key,Shift);

  NeedsInvalidating:=False;

  if not CanGridAcceptKey(Key,Shift) then Key:=0;

  if not UseRightToLeftAlignment then

      RTLFactor:=1

  else

      RTLFactor:=-1;

  NewCurrent:=FCurrent;

  NewTopLeft:=FTopLeft;

  CalcPageExtents;

  if ssCtrl in Shift then

    case Key of

      VK_UP:Dec(NewTopLeft.Y);

      VK_DOWN:Inc(NewTopLeft.Y);

      VK_LEFT:

        // if not (goRowSelect in Options) then

        begin

          Dec(NewCurrent.X,PageWidth*RTLFactor);

          Dec(NewTopLeft.X,PageWidth*RTLFactor);

        end;

      VK_RIGHT:

        // if not (goRowSelect in Options) then

        begin

          Inc(NewCurrent.X,PageWidth*RTLFactor);

          Inc(NewTopLeft.X,PageWidth*RTLFactor);

        end;

      VK_PRIOR:NewCurrent.Y:=TopRow;

      VK_NEXT:NewCurrent.Y:=DrawInfo.Vert.LastFullVisibleCell;

      VK_HOME:

        begin

          NewCurrent.X:=FixedCols;

          NewCurrent.Y:=FixedRows;

          NeedsInvalidating:=UseRightToLeftAlignment;

        end;

      VK_END:

        begin

          NewCurrent.X:=ColCount-1;

          NewCurrent.Y:=RowCount-1;

          NeedsInvalidating:=UseRightToLeftAlignment;

        end;

    end

  else

    case Key of

      VK_UP:Dec(NewCurrent.Y);

      VK_DOWN:Inc(NewCurrent.Y);

      {VK_LEFT:

       if goRowSelect in Options then

       Dec(NewCurrent.Y, RTLFactor) else

       Dec(NewCurrent.X, RTLFactor);

       VK_RIGHT:

       if goRowSelect in Options then

       Inc(NewCurrent.Y, RTLFactor) else

       Inc(NewCurrent.X, RTLFactor);}

      VK_NEXT:

        begin

          Inc(NewCurrent.Y,PageHeight);

          Inc(NewTopLeft.Y,PageHeight);

        end;

      VK_PRIOR:

        begin

          Dec(NewCurrent.Y,PageHeight);

          Dec(NewTopLeft.Y,PageHeight);

        end;

      VK_HOME:

        // if goRowSelect in Options then

        // NewCurrent.Y := FixedRows else

        NewCurrent.X:=FixedCols;

      VK_END:

        // if goRowSelect in Options then

        // NewCurrent.Y := RowCount - 1 else

        NewCurrent.X:=ColCount-1;

      VK_TAB:

        if not(ssAlt in Shift) then

          repeat

            if ssShift in Shift then

            begin

              Dec(NewCurrent.X);

              if NewCurrent.X<FixedCols then

              begin

                NewCurrent.X:=ColCount-1;

                Dec(NewCurrent.Y);

                if NewCurrent.Y<FixedRows then NewCurrent.Y:=RowCount-1;

              end;

              Shift:=[];

            end

            else

            begin

              Inc(NewCurrent.X);

              if NewCurrent.X>=ColCount then

              begin

                NewCurrent.X:=FixedCols;

                Inc(NewCurrent.Y);

                if NewCurrent.Y>=RowCount then NewCurrent.Y:=FixedRows;

              end;

            end;

          until TabStops[NewCurrent.X] or(NewCurrent.X=FCurrent.X);

      VK_F2:
        EditorMode:=True;

    end;

  MaxTopLeft.X:=ColCount-1;

  MaxTopLeft.Y:=RowCount-1;

  MaxTopLeft:=CalcMaxTopLeft(MaxTopLeft,DrawInfo);

  Restrict(NewTopLeft,FixedCols,FixedRows,MaxTopLeft.X,MaxTopLeft.Y);

  if (NewTopLeft.X<>LeftCol)or(NewTopLeft.Y<>TopRow) then

      MoveTopLeft(NewTopLeft.X,NewTopLeft.Y);

  Restrict(NewCurrent,FixedCols,FixedRows,ColCount-1,RowCount-1);

  if (NewCurrent.X<>Col)or(NewCurrent.Y<>Row) then

      FocusCell(NewCurrent.X,NewCurrent.Y,not(ssShift in Shift));

  if NeedsInvalidating then Invalidate;

end;

procedure TCustomPrGrid.KeyPress(var Key:Char);

begin

  inherited KeyPress(Key);

  if not(goAlwaysShowEditor in Options)and(Key=#13) then

  begin

    if FEditorMode then HideEditor
    else ShowEditor;

    Key:=#0;

  end;

end;

procedure TCustomPrGrid.MouseDown(Button:TMouseButton;Shift:TShiftState;

  X,Y:Integer);

var

  CellHit:TGridCoord;

  DrawInfo:TGridDrawInfo;

  MoveDrawn:Boolean;

begin

  MoveDrawn:=False;

  HideEdit;

  if not(csDesigning in ComponentState)and

    (CanFocus or(GetParentForm(Self)=nil)) then

  begin

    SetFocus;

    if not IsActiveControl then

    begin

      MouseCapture:=False;

      Exit;

    end;

  end;

  if (Button=mbLeft)and(ssDouble in Shift) then

      DblClick

  else if Button=mbLeft then

  begin

    CalcDrawInfo(DrawInfo);

    {Check grid sizing}

    CalcSizingState(X,Y,FGridState,FSizingIndex,FSizingPos,FSizingOfs,

      DrawInfo);

    if FGridState<>gsNormal then

    begin

      if UseRightToLeftAlignment then

          FSizingPos:=ClientWidth-FSizingPos;

      DrawSizingLine(DrawInfo);

      Exit;

    end;

    CellHit:=CalcCoordFromPoint(X,Y,DrawInfo);

    if (CellHit.X>=FixedCols)and(CellHit.Y>=FixedRows) then

    begin

      if goEditing in Options then

      begin

        if (CellHit.X=FCurrent.X)and(CellHit.Y=FCurrent.Y) then

            ShowEditor

        else

        begin

          MoveCurrent(CellHit.X,CellHit.Y,True,True);

          UpdateEdit;

        end;

        Click;

      end

      else

      begin

        FGridState:=gsSelecting;

        SetTimer(Handle,1,60,nil);

        if ssShift in Shift then

            MoveAnchor(CellHit)

        else

            MoveCurrent(CellHit.X,CellHit.Y,True,True);

      end;

    end

    else if (goRowMoving in Options)and(CellHit.X>=0)and

      (CellHit.X<FixedCols)and(CellHit.Y>=FixedRows) then

    begin

      FMoveIndex:=CellHit.Y;

      FMovePos:=FMoveIndex;

      if BeginRowDrag(FMoveIndex,FMovePos,Point(X,Y)) then

      begin

        FGridState:=gsRowMoving;

        Update;

        DrawMove;

        MoveDrawn:=True;

        SetTimer(Handle,1,60,nil);

      end;

    end

    else if (goColMoving in Options)and(CellHit.Y>=0)and

      (CellHit.Y<FixedRows)and(CellHit.X>=FixedCols) then

    begin

      FMoveIndex:=CellHit.X;

      FMovePos:=FMoveIndex;

      if BeginColumnDrag(FMoveIndex,FMovePos,Point(X,Y)) then

      begin

        FGridState:=gsColMoving;

        Update;

        DrawMove;

        MoveDrawn:=True;

        SetTimer(Handle,1,60,nil);

      end;

    end;

  end;

  try

      inherited MouseDown(Button,Shift,X,Y);

  except

    if MoveDrawn then DrawMove;

  end;

end;

procedure TCustomPrGrid.MouseMove(Shift:TShiftState;X,Y:Integer);

var

  DrawInfo:TGridDrawInfo;

  CellHit:TGridCoord;

begin

  CalcDrawInfo(DrawInfo);

  case FGridState of

    gsSelecting,gsColMoving,gsRowMoving:

      begin

        CellHit:=CalcCoordFromPoint(X,Y,DrawInfo);

        if (CellHit.X>=FixedCols)and(CellHit.Y>=FixedRows)and

          (CellHit.X<=DrawInfo.Horz.LastFullVisibleCell+1)and

          (CellHit.Y<=DrawInfo.Vert.LastFullVisibleCell+1) then

          case FGridState of

            gsSelecting:

              if ((CellHit.X<>FAnchor.X)or(CellHit.Y<>FAnchor.Y)) then

                  MoveAnchor(CellHit);

            gsColMoving:

              MoveAndScroll(X,CellHit.X,DrawInfo,DrawInfo.Horz,SB_HORZ,Point(X,Y));

            gsRowMoving:

              MoveAndScroll(Y,CellHit.Y,DrawInfo,DrawInfo.Vert,SB_VERT,Point(X,Y));

          end;

      end;

    gsRowSizing,gsColSizing:

      begin

        DrawSizingLine(DrawInfo);{XOR it out}

        if FGridState=gsRowSizing then

            FSizingPos:=Y+FSizingOfs
        else

            FSizingPos:=X+FSizingOfs;

        DrawSizingLine(DrawInfo);{XOR it back in}

      end;

  end;

  inherited MouseMove(Shift,X,Y);

end;

procedure TCustomPrGrid.MouseUp(Button:TMouseButton;Shift:TShiftState;

  X,Y:Integer);

var

  DrawInfo:TGridDrawInfo;

  NewSize:Integer;

  function ResizeLine(const AxisInfo:TGridAxisDrawInfo):Integer;

  var

    I:Integer;

  begin

    with AxisInfo do

    begin

      Result:=FixedBoundary;

      for I:=FirstGridCell to FSizingIndex-1 do

          Inc(Result,GetExtent(I)+EffectiveLineWidth);

      Result:=FSizingPos-Result;

    end;

  end;

begin

  try

    case FGridState of

      gsSelecting:

        begin

          MouseMove(Shift,X,Y);

          KillTimer(Handle,1);

          UpdateEdit;

          Click;

        end;

      gsRowSizing,gsColSizing:

        begin

          CalcDrawInfo(DrawInfo);

          DrawSizingLine(DrawInfo);

          if UseRightToLeftAlignment then

              FSizingPos:=ClientWidth-FSizingPos;

          if FGridState=gsColSizing then

          begin

            NewSize:=ResizeLine(DrawInfo.Horz);

            if NewSize>1 then

            begin

              ColWidths[FSizingIndex]:=NewSize;

              UpdateDesigner;

            end;

          end

          else

          begin

            NewSize:=ResizeLine(DrawInfo.Vert);

            if NewSize>1 then

            begin

              RowHeights[FSizingIndex]:=NewSize;

              UpdateDesigner;

            end;

          end;

        end;

      gsColMoving:

        begin

          DrawMove;

          KillTimer(Handle,1);

          if EndColumnDrag(FMoveIndex,FMovePos,Point(X,Y))

            and(FMoveIndex<>FMovePos) then

          begin

            MoveColumn(FMoveIndex,FMovePos);

            UpdateDesigner;

          end;

          UpdateEdit;

        end;

      gsRowMoving:

        begin

          DrawMove;

          KillTimer(Handle,1);

          if EndRowDrag(FMoveIndex,FMovePos,Point(X,Y))

            and(FMoveIndex<>FMovePos) then

          begin

            MoveRow(FMoveIndex,FMovePos);

            UpdateDesigner;

          end;

          UpdateEdit;

        end;

    else

      UpdateEdit;

    end;

    inherited MouseUp(Button,Shift,X,Y);

  finally

      FGridState:=gsNormal;

  end;

end;

procedure TCustomPrGrid.MoveAndScroll(Mouse,CellHit:Integer;

  var DrawInfo:TGridDrawInfo;var Axis:TGridAxisDrawInfo;

  ScrollBar:Integer;const MousePt:TPoint);

begin

  if UseRightToLeftAlignment and(ScrollBar=SB_HORZ) then

      Mouse:=ClientWidth-Mouse;

  if (CellHit<>FMovePos)and

    not((FMovePos=Axis.FixedCellCount)and(Mouse<Axis.FixedBoundary))and

    not((FMovePos=Axis.GridCellCount-1)and(Mouse>Axis.GridBoundary)) then

  begin

    DrawMove;// hide the drag line

    if (Mouse<Axis.FixedBoundary) then

    begin

      if (FMovePos>Axis.FixedCellCount) then

      begin

        ModifyScrollBar(ScrollBar,SB_LINEUP,0,False);

        Update;

        CalcDrawInfo(DrawInfo);// this changes contents of Axis var

      end;

      CellHit:=Axis.FirstGridCell;

    end

    else if (Mouse>=Axis.FullVisBoundary) then

    begin

      if (FMovePos=Axis.LastFullVisibleCell)and

        (FMovePos<Axis.GridCellCount-1) then

      begin

        ModifyScrollBar(ScrollBar,SB_LINEDOWN,0,False);

        Update;

        CalcDrawInfo(DrawInfo);// this changes contents of Axis var

      end;

      CellHit:=Axis.LastFullVisibleCell;

    end

    else if CellHit<0 then CellHit:=FMovePos;

    if ((FGridState=gsColMoving)and CheckColumnDrag(FMoveIndex,CellHit,MousePt))

      or((FGridState=gsRowMoving)and CheckRowDrag(FMoveIndex,CellHit,MousePt)) then

        FMovePos:=CellHit;

    DrawMove;

  end;

end;

function TCustomPrGrid.GetColWidths(Index:Longint):Integer;

begin

  if (FColWidths=nil)or(Index>=ColCount) then

      Result:=DefaultNameColWidth

  else

      Result:=PIntArray(FColWidths)^[Index+1];

end;

function TCustomPrGrid.GetRowHeights(Index:Longint):Integer;

begin

  if (FRowHeights=nil)or(Index>=RowCount) then

      Result:=DefaultRowHeight

  else

      Result:=PIntArray(FRowHeights)^[Index+1];

end;

function TCustomPrGrid.GetGridWidth:Integer;

var

  DrawInfo:TGridDrawInfo;

begin

  CalcDrawInfo(DrawInfo);

  Result:=DrawInfo.Horz.GridBoundary;

end;

function TCustomPrGrid.GetGridHeight:Integer;

var

  DrawInfo:TGridDrawInfo;

begin

  CalcDrawInfo(DrawInfo);

  Result:=DrawInfo.Vert.GridBoundary;

end;

function TCustomPrGrid.GetSelection:TGridRect;

begin

  Result:=GridRect(FCurrent,FAnchor);

end;

function TCustomPrGrid.GetTabStops(Index:Longint):Boolean;

begin

  if FTabStops=nil then Result:=True

  else Result:=Boolean(PIntArray(FTabStops)^[Index+1]);

end;

function TCustomPrGrid.GetVisibleColCount:Integer;

var

  DrawInfo:TGridDrawInfo;

begin

  CalcDrawInfo(DrawInfo);

  Result:=DrawInfo.Horz.LastFullVisibleCell-LeftCol+1;

end;

function TCustomPrGrid.GetVisibleRowCount:Integer;

var

  DrawInfo:TGridDrawInfo;

begin

  CalcDrawInfo(DrawInfo);

  Result:=DrawInfo.Vert.LastFullVisibleCell-TopRow+1;

end;

procedure TCustomPrGrid.SetBorderStyle(Value:TBorderStyle);

begin

  if FBorderStyle<>Value then

  begin

    FBorderStyle:=Value;

    RecreateWnd;

  end;

end;

procedure TCustomPrGrid.SetCol(Value:Longint);

begin

  if Col<>Value then FocusCell(Value,Row,True);

end;

procedure TCustomPrGrid.SetColCount(Value:Longint);

begin

  if FColCount<>Value then

  begin

    if Value<1 then Value:=1;

    if Value<=FixedCols then FixedCols:=Value-1;

    ChangeSize(Value,RowCount);

    UpdateScrollRange;

    {if goRowSelect in Options then

     begin

     FAnchor.X := ColCount - 1;

     Invalidate;

     end;}

  end;

end;

procedure TCustomPrGrid.SetColWidths(Index:Longint;Value:Integer);

begin

  if FColWidths=nil then

      UpdateExtents(FColWidths,ColCount,DefaultNameColWidth);

  if Index>=ColCount then InvalidOp(SIndexOutOfRange);

  if Value<>PIntArray(FColWidths)^[Index+1] then

  begin

    ResizeCol(Index,PIntArray(FColWidths)^[Index+1],Value);

    PIntArray(FColWidths)^[Index+1]:=Value;

    ColWidthsChanged;

  end;

end;

procedure TCustomPrGrid.SetDefaultNameColWidth(Value:Integer);

begin

  if FColWidths<>nil then UpdateExtents(FColWidths,0,0);

  FDefaultNameColWidth:=Value;

  ColWidthsChanged;

  InvalidateGrid;

end;

procedure TCustomPrGrid.SetDefaultRowHeight(Value:Integer);

begin

  if FRowHeights<>nil then UpdateExtents(FRowHeights,0,0);

  FDefaultRowHeight:=Value;

  RowHeightsChanged;

  InvalidateGrid;

end;

procedure TCustomPrGrid.SetFixedColor(Value:TColor);

begin

  if FFixedColor<>Value then

  begin

    FFixedColor:=Value;

    InvalidateGrid;

  end;

end;

procedure TCustomPrGrid.SetFixedCols(Value:Integer);

begin

  if FFixedCols<>Value then

  begin

    if Value<0 then InvalidOp(SIndexOutOfRange);

    if Value>=ColCount then InvalidOp(SFixedColTooBig);

    FFixedCols:=Value;

    Initialize;

    InvalidateGrid;

  end;

end;

procedure TCustomPrGrid.SetFixedRows(Value:Integer);

begin

  if FFixedRows<>Value then

  begin

    if Value<0 then InvalidOp(SIndexOutOfRange);

    if Value>=RowCount then InvalidOp(SFixedRowTooBig);

    FFixedRows:=Value;

    Initialize;

    InvalidateGrid;

  end;

end;

procedure TCustomPrGrid.SetEditorMode(Value:Boolean);

begin

  if not Value then

      HideEditor

  else

  begin

    ShowEditor;

    if FInplaceEdit<>nil then FInplaceEdit.Deselect;

  end;

end;

procedure TCustomPrGrid.SetGridLineWidth(Value:Integer);

begin

  if FGridLineWidth<>Value then

  begin

    FGridLineWidth:=Value;

    InvalidateGrid;

  end;

end;

procedure TCustomPrGrid.SetLeftCol(Value:Longint);

begin

  if FTopLeft.X<>Value then MoveTopLeft(Value,TopRow);

end;

procedure TCustomPrGrid.SetOptions(Value:TGridOptions);

begin

  if FOptions<>Value then

  begin

    {if goRowSelect in Value then

     Exclude(Value, goAlwaysShowEditor);}

    FOptions:=Value;

    if goTitle in Value then

    begin

      if FRowCount<2 then SetRowCount(2);

      FixedRows:=1;

    end

    else

        FixedRows:=0;

    if not FEditorMode then

      if goAlwaysShowEditor in Value then

          ShowEditor
      else HideEditor;

    // if goRowSelect in Value then MoveCurrent(Col, Row,  True, False);

    TPropertyGrid(Self).UpdateNames(Self);

    InvalidateGrid;

  end;

end;

procedure TCustomPrGrid.SetRow(Value:Longint);

begin

  if Row<>Value then FocusCell(Col,Value,True);

end;

procedure TCustomPrGrid.SetRowCount(Value:Longint);

begin

  if FRowCount<>Value then

  begin

    if goTitle in FOptions then

      if Value<2 then Value:=2

      else if Value<1 then Value:=1;

    if Value<=FixedRows then FixedRows:=Value-1;

    ChangeSize(ColCount,Value);

    UpdateProps;

    UpdateScrollRange;

    UpdateGrid;

  end;

end;

procedure TCustomPrGrid.SetRowHeights(Index:Longint;Value:Integer);

begin

  if FRowHeights=nil then

      UpdateExtents(FRowHeights,RowCount,DefaultRowHeight);

  if Index>=RowCount then InvalidOp(SIndexOutOfRange);

  if Value<>PIntArray(FRowHeights)^[Index+1] then

  begin

    ResizeRow(Index,PIntArray(FRowHeights)^[Index+1],Value);

    PIntArray(FRowHeights)^[Index+1]:=Value;

    RowHeightsChanged;

  end;

end;

procedure TCustomPrGrid.SetScrollBars(Value:TScrollStyle);

begin

  if FScrollBars<>Value then

  begin

    FScrollBars:=Value;

    RecreateWnd;

  end;

end;

procedure TCustomPrGrid.SetSelection(Value:TGridRect);

var

  OldSel:TGridRect;

begin

  OldSel:=Selection;

  FAnchor:=Value.TopLeft;

  FCurrent:=Value.BottomRight;

  SelectionMoved(OldSel);

end;

procedure TCustomPrGrid.SetTabStops(Index:Longint;Value:Boolean);

begin

  if FTabStops=nil then

      UpdateExtents(FTabStops,ColCount,Integer(True));

  if Index>=ColCount then InvalidOp(SIndexOutOfRange);

  PIntArray(FTabStops)^[Index+1]:=Integer(Value);

end;

procedure TCustomPrGrid.SetTopRow(Value:Longint);

begin

  if FTopLeft.Y<>Value then MoveTopLeft(LeftCol,Value);

end;

procedure TCustomPrGrid.HideEdit;

begin

  if FInplaceEdit<>nil then

    try

        UpdateText;

    finally

      FInplaceCol:=-1;

      FInplaceRow:=-1;

      FInplaceEdit.Hide;

    end;

end;

procedure TCustomPrGrid.UpdateEdit;

  procedure UpdateEditor;

  begin

    FInplaceCol:=Col;

    FInplaceRow:=Row;

    FInplaceEdit.UpdateContents;

    if FInplaceEdit.MaxLength=-1 then FCanEditModify:=False

    else FCanEditModify:=True;

    FInplaceEdit.SelectAll;

  end;

begin

  if CanEditShow then

  begin

    if FInplaceEdit=nil then

    begin

      FInplaceEdit:=CreateEditor;

      FInplaceEdit.SetGrid(Self);

      FInplaceEdit.Parent:=Self;

      UpdateEditor;

    end

    else

    begin

      if (Col<>FInplaceCol)or(Row<>FInplaceRow) then

      begin

        HideEdit;

        UpdateEditor;

      end;

    end;

    if CanEditShow then FInplaceEdit.Move(CellRect(Col,Row));

  end;

end;

procedure TCustomPrGrid.UpdateText;

begin

  if (FInplaceCol<>-1)and(FInplaceRow<>-1) then

      SetEditText(FInplaceCol,FInplaceRow,FInplaceEdit.Text);

  if not(FInplaceEdit=nil) then FInplaceEdit.Change;

end;

procedure TCustomPrGrid.WMChar(var Msg:TWMChar);

begin

  if (goEditing in Options)and(Char(Msg.CharCode) in [^H,#32..#255]) then

      ShowEditorChar(Char(Msg.CharCode))

  else

      inherited;

end;

procedure TCustomPrGrid.WMCommand(var Message:TWMCommand);

begin

  with Message do

  begin

    if (FInplaceEdit<>nil)and(Ctl=FInplaceEdit.Handle) then

      case NotifyCode of

        EN_CHANGE:UpdateText;

      end;

  end;

end;

procedure TCustomPrGrid.WMGetDlgCode(var Msg:TWMGetDlgCode);

begin

  Msg.Result:=DLGC_WANTARROWS;

  // if goRowSelect in Options then Exit;

  if goTabs in Options then Msg.Result:=Msg.Result or DLGC_WANTTAB;

  if goEditing in Options then Msg.Result:=Msg.Result or DLGC_WANTCHARS;

end;

procedure TCustomPrGrid.WMKillFocus(var Msg:TWMKillFocus);

begin

  inherited;

  InvalidateRect(Selection);

  if (FInplaceEdit<>nil)and(Msg.FocusedWnd<>FInplaceEdit.Handle) then

      HideEdit;

end;

procedure TCustomPrGrid.WMLButtonDown(var Message:TMessage);

begin

  inherited;

  if FInplaceEdit<>nil then FInplaceEdit.FClickTime:=GetMessageTime;

end;

procedure TCustomPrGrid.WMNCHitTest(var Msg:TWMNCHitTest);

begin

  DefaultHandler(Msg);

  FHitTest:=ScreenToClient(SmallPointToPoint(Msg.Pos));

end;

procedure TCustomPrGrid.WMSetCursor(var Msg:TWMSetCursor);

var

  DrawInfo:TGridDrawInfo;

  State:TGridState;

  Index:Longint;

  Pos,Ofs:Integer;

  Cur:HCURSOR;

begin

  Cur:=0;

  with Msg do

  begin

    if HitTest=HTCLIENT then

    begin

      if FGridState=gsNormal then

      begin

        CalcDrawInfo(DrawInfo);

        CalcSizingState(FHitTest.X,FHitTest.Y,State,Index,Pos,Ofs,

          DrawInfo);

      end
      else State:=FGridState;

      if State=gsRowSizing then

          Cur:=Screen.Cursors[crVSplit]

      else if State=gsColSizing then

          Cur:=Screen.Cursors[crHSplit]

    end;

  end;

  if Cur<>0 then SetCursor(Cur)

  else inherited;

end;

procedure TCustomPrGrid.WMSetFocus(var Msg:TWMSetFocus);

begin

  inherited;

  if (FInplaceEdit=nil)or(Msg.FocusedWnd<>FInplaceEdit.Handle) then

  begin

    InvalidateRect(Selection);

    UpdateEdit;

  end;

end;

procedure TCustomPrGrid.WMSize(var Msg:TWMSize);

begin

  inherited;

  UpdateScrollRange;

  if UseRightToLeftAlignment then Invalidate;

end;

procedure TCustomPrGrid.WMVScroll(var Msg:TWMVScroll);

begin

  ModifyScrollBar(SB_VERT,Msg.ScrollCode,Msg.Pos,True);

end;

procedure TCustomPrGrid.WMHScroll(var Msg:TWMHScroll);

begin

  ModifyScrollBar(SB_HORZ,Msg.ScrollCode,Msg.Pos,True);

end;

procedure TCustomPrGrid.CancelMode;

var

  DrawInfo:TGridDrawInfo;

begin

  try

    case FGridState of

      gsSelecting:

        KillTimer(Handle,1);

      gsRowSizing,gsColSizing:

        begin

          CalcDrawInfo(DrawInfo);

          DrawSizingLine(DrawInfo);

        end;

      gsColMoving,gsRowMoving:

        begin

          DrawMove;

          KillTimer(Handle,1);

        end;

    end;

  finally

      FGridState:=gsNormal;

  end;

end;

procedure TCustomPrGrid.WMCancelMode(var Msg:TWMCancelMode);

begin

  inherited;

  CancelMode;

end;

procedure TCustomPrGrid.CMCancelMode(var Msg:TMessage);

begin

  if Assigned(FInplaceEdit) then FInplaceEdit.WndProc(Msg);

  inherited;

  CancelMode;

end;

procedure TCustomPrGrid.CMFontChanged(var Message:TMessage);

begin

  if FInplaceEdit<>nil then FInplaceEdit.Font:=Font;

  inherited;

end;

procedure TCustomPrGrid.CMCtl3DChanged(var Message:TMessage);

begin

  inherited;

  RecreateWnd;

end;

procedure TCustomPrGrid.CMDesignHitTest(var Msg:TCMDesignHitTest);

begin

  Msg.Result:=Longint(Bool(Sizing(Msg.Pos.X,Msg.Pos.Y)));

end;

procedure TCustomPrGrid.CMWantSpecialKey(var Msg:TCMWantSpecialKey);

begin

  inherited;

  if (goEditing in Options)and(Char(Msg.CharCode)=#13) then Msg.Result:=1;

end;

procedure TCustomPrGrid.TimedScroll(Direction:TGridScrollDirection);

var

  MaxAnchor,NewAnchor:TGridCoord;

begin

  NewAnchor:=FAnchor;

  MaxAnchor.X:=ColCount-1;

  MaxAnchor.Y:=RowCount-1;

  if (sdLeft in Direction)and(FAnchor.X>FixedCols) then Dec(NewAnchor.X);

  if (sdRight in Direction)and(FAnchor.X<MaxAnchor.X) then Inc(NewAnchor.X);

  if (sdUp in Direction)and(FAnchor.Y>FixedRows) then Dec(NewAnchor.Y);

  if (sdDown in Direction)and(FAnchor.Y<MaxAnchor.Y) then Inc(NewAnchor.Y);

  if (FAnchor.X<>NewAnchor.X)or(FAnchor.Y<>NewAnchor.Y) then

      MoveAnchor(NewAnchor);

end;

procedure TCustomPrGrid.WMTimer(var Msg:TWMTimer);

var

  Point:TPoint;

  DrawInfo:TGridDrawInfo;

  ScrollDirection:TGridScrollDirection;

  CellHit:TGridCoord;

  LeftSide:Integer;

  RightSide:Integer;

begin

  if not(FGridState in [gsSelecting,gsRowMoving,gsColMoving]) then Exit;

  GetCursorPos(Point);

  Point:=ScreenToClient(Point);

  CalcDrawInfo(DrawInfo);

  ScrollDirection:=[];

  with DrawInfo do

  begin

    CellHit:=CalcCoordFromPoint(Point.X,Point.Y,DrawInfo);

    case FGridState of

      gsColMoving:

        MoveAndScroll(Point.X,CellHit.X,DrawInfo,Horz,SB_HORZ,Point);

      gsRowMoving:

        MoveAndScroll(Point.Y,CellHit.Y,DrawInfo,Vert,SB_VERT,Point);

      gsSelecting:

        begin

          if not UseRightToLeftAlignment then

          begin

            if Point.X<Horz.FixedBoundary then Include(ScrollDirection,sdLeft)

            else if Point.X>Horz.FullVisBoundary then Include(ScrollDirection,sdRight);

          end

          else

          begin

            LeftSide:=ClientWidth-Horz.FullVisBoundary;

            RightSide:=ClientWidth-Horz.FixedBoundary;

            if Point.X<LeftSide then Include(ScrollDirection,sdRight)

            else if Point.X>RightSide then Include(ScrollDirection,sdLeft);

          end;

          if Point.Y<Vert.FixedBoundary then Include(ScrollDirection,sdUp)

          else if Point.Y>Vert.FullVisBoundary then Include(ScrollDirection,sdDown);

          if ScrollDirection<>[] then TimedScroll(ScrollDirection);

        end;

    end;

  end;

end;

procedure TCustomPrGrid.ColWidthsChanged;

begin

  CorrectWidths;

  UpdateScrollRange;

  UpdateEdit;

end;

procedure TCustomPrGrid.RowHeightsChanged;

begin

  UpdateScrollRange;

  UpdateEdit;

end;

procedure TCustomPrGrid.DeleteColumn(ACol:Longint);

begin

  MoveColumn(ACol,ColCount-1);

  ColCount:=ColCount-1;

end;

procedure TCustomPrGrid.DeleteRow(ARow:Longint);

begin

  MoveRow(ARow,RowCount-1);

  RowCount:=RowCount-1;

end;

procedure TCustomPrGrid.UpdateDesigner;

var

  ParentForm:TCustomForm;

begin

  if (csDesigning in ComponentState)and HandleAllocated and

    not(csUpdating in ComponentState) then

  begin

    ParentForm:=GetParentForm(Self);

    if Assigned(ParentForm)and Assigned(ParentForm.Designer) then

        ParentForm.Designer.Modified;

  end;

end;

function TCustomPrGrid.DoMouseWheelDown(Shift:TShiftState;MousePos:TPoint):Boolean;

begin

  Result:=inherited DoMouseWheelDown(Shift,MousePos);

  if not Result then

  begin

    if Row<RowCount-1 then Row:=Row+1;

    Result:=True;

  end;

end;

function TCustomPrGrid.DoMouseWheelUp(Shift:TShiftState;MousePos:TPoint):Boolean;

begin

  Result:=inherited DoMouseWheelUp(Shift,MousePos);

  if not Result then

  begin

    if Row>FixedRows then Row:=Row-1;

    Result:=True;

  end;

end;

function TCustomPrGrid.CheckColumnDrag(var Origin,

  Destination:Integer;const MousePt:TPoint):Boolean;

begin

  Result:=True;

end;

function TCustomPrGrid.CheckRowDrag(var Origin,

  Destination:Integer;const MousePt:TPoint):Boolean;

begin

  Result:=True;

end;

function TCustomPrGrid.BeginColumnDrag(var Origin,Destination:Integer;const MousePt:TPoint):Boolean;

begin

  Result:=True;

end;

function TCustomPrGrid.BeginRowDrag(var Origin,Destination:Integer;const MousePt:TPoint):Boolean;

begin

  Result:=True;

end;

function TCustomPrGrid.EndColumnDrag(var Origin,Destination:Integer;const MousePt:TPoint):Boolean;

begin

  Result:=True;

end;

function TCustomPrGrid.EndRowDrag(var Origin,Destination:Integer;const MousePt:TPoint):Boolean;

begin

  Result:=True;

end;

procedure TCustomPrGrid.CMShowingChanged(var Message:TMessage);

begin

  inherited;

  if Showing then UpdateScrollRange;

end;

procedure TCustomPrGrid.SetPropValues(const Value:TCellValueProps);

begin

  FPropValues.Assign(Value);

  UpdateGrid;

end;

procedure TCustomPrGrid.EditButtonClick;

begin

  if Assigned(FOnEditButtonClick) then

      FOnEditButtonClick(Self,Row);

end;

procedure TCustomPrGrid.UpdateProps;

begin

  if PropValues.Count>RowCount then

      PropValues.DeleteLastSpareItems(PropValues.Count-RowCount);

  if PropValues.Count<RowCount then

      PropValues.AddLastNeedItems(RowCount-PropValues.Count);

end;

procedure TCustomPrGrid.UpdateGrid;

begin

  if FPropValues<>nil then

      SetRowCount(FPropValues.Count);

  if Assigned(FCustUpdateEvent) then

      FCustUpdateEvent(Self);

  Invalidate;

end;

procedure TCustomPrGrid.SetEditFrameStyle(const Value:TEditFrameStyle);

begin

  HideEditor;

  FEditFrameStyle:=Value;

  FDefaultRowHeight:=Abs(Font.Height)+7+Ord(EditFrameStyle)*2;

  FInplaceEdit:=nil;

  ShowEditor;

  InvalidateEditor;

end;

procedure TCustomPrGrid.SetPropGridTitle(const Value:TPropGridTitle);

begin

  FPropGridTitle.Assign(Value);

end;

{TPropertyGrid}

function TPropertyGrid.CellRect(ACol,ARow:Longint):TRect;

begin

  Result:=inherited CellRect(ACol,ARow);

end;

procedure TPropertyGrid.MouseToCell(X,Y:Integer;var ACol,ARow:Longint);

var

  Coord:TGridCoord;

begin

  Coord:=MouseCoord(X,Y);

  ACol:=Coord.X;

  ARow:=Coord.Y;

end;

function TPropertyGrid.GetEditMask(ACol,ARow:Longint):string;

begin

  Result:=PropValues[ARow].EditMask;

  if Assigned(FOnGetEditMask) then FOnGetEditMask(Self,ACol,ARow,Result);

end;

function TPropertyGrid.GetEditText(ACol,ARow:Longint):string;

begin

  Result:=Cells[ACol,ARow];

  if Assigned(FOnGetEditText) then FOnGetEditText(Self,ACol,ARow,Result);

end;

function TPropertyGrid.SelectCell(ACol,ARow:Longint):Boolean;

begin

  Result:=True;

  if (PropValues[ARow].EditMode=emNoEdit)and not(goRangeSelect in Options) then Result:=False;

  if (ARow<Pred(RowCount))and(ARow>0)and(not Result) then

  begin

    if ARow<Row then Row:=Pred(ARow)

    else Row:=Succ(ARow);

  end;

  if Assigned(FOnSelectCell) then FOnSelectCell(Self,ACol,ARow,Result);

end;

procedure TPropertyGrid.SetEditText(ACol,ARow:Longint;const Value:string);

begin

  DisableEditUpdate;

  try

    if Value<>Cells[ACol,ARow] then Cells[ACol,ARow]:=Value;

    if (ACol=2)and FShowCheckColumn then

        PropValues[ARow].PropertyValue:=Value;

    if (ACol=1)and not FShowCheckColumn then

        PropValues[ARow].PropertyValue:=Value;

  finally

      EnableEditUpdate;

  end;

  if Assigned(FOnSetEditText) then FOnSetEditText(Self,ACol,ARow,Value);

end;

procedure TPropertyGrid.DrawCell(ACol,ARow:Longint;ARect:TRect;

  AState:TGridDrawState);

var
  Hold,X,Y,OffSet:Integer;

  Flags:DWORD;

  SaveColor:TColor;

  SaveFont:TFont;

  CellStr:string;

begin

  Flags:=DFCS_BUTTONCHECK;

  if DefaultDrawing then

  begin

    X:=ARect.Left+2;

    if (ACol=0) then

      case FAlignment of

        taRightJustify:X:=ARect.Right-Canvas.TextWidth(Cells[ACol,ARow])-3;

        taCenter:X:=ARect.Left+(ARect.Right-ARect.Left) shr 1

            -(Canvas.TextWidth(Cells[ACol,ARow]) shr 1);

      end;

    if (ARow=0)and(goTitle in Options) then

    begin

      SaveColor:=Canvas.Brush.Color;

      Canvas.Brush.Color:=PropGridTitle.Color;

      SaveFont:=Canvas.Font;

      Canvas.Font:=PropGridTitle.Font;

      case PropGridTitle.Alignment of

        taRightJustify:X:=ARect.Right-Canvas.TextWidth(Cells[ACol,ARow])-3;

        taCenter:X:=ARect.Left+(ARect.Right-ARect.Left) shr 1

            -(Canvas.TextWidth(Cells[ACol,ARow]) shr 1);

      end;

    end;

    Y:=ARect.Top+(ARect.Bottom-ARect.Top) shr 1-(Canvas.TextHeight(Cells[ACol,ARow]) shr 1)-1;

    CellStr:=Cells[ACol,ARow];

    if ACol=(1+Ord(FShowCheckColumn)) then

      if Canvas.TextWidth(CellStr)>ColWidths[ACol] then

      begin

        while Canvas.TextWidth(CellStr+'... ')>ColWidths[ACol] do

            CellStr:=Copy(CellStr,1,Length(CellStr)-1);

        CellStr:=CellStr+'... ';

      end;

    Canvas.TextRect(ARect,X,Y,CellStr);

    if (ARow=0)and(goTitle in Options) then

    begin

      Canvas.Brush.Color:=SaveColor;

      Canvas.Font:=SaveFont;

    end;

    if (ACol=1)and FShowCheckColumn then

    begin

      if PropValues[ARow].Checked and PropValues[ARow].Enabled then

          Flags:=Flags or DFCS_CHECKED

      else

        if not PropValues[ARow].Enabled then Flags:=Flags or DFCS_INACTIVE;

      if EditFrameStyle=efFlat then Flags:=Flags or DFCS_FLAT;

      Y:=ARect.Top+(ARect.Bottom-ARect.Top) shr 1-(13 shr 1);

      SetRect(ARect,ARect.Left+1,Y,ARect.Right-1,Y+13);

      if ((goTitle in FOptions)and(ARow<>0))or(not(goTitle in FOptions)) then

          DrawFrameControl(Canvas.Handle,ARect,DFC_BUTTON,Flags);

    end;

  end;

  if Assigned(FOnDrawCell) then

  begin

    if UseRightToLeftAlignment then

    begin

      ARect.Left:=ClientWidth-ARect.Left;

      ARect.Right:=ClientWidth-ARect.Right;

      Hold:=ARect.Left;

      ARect.Left:=ARect.Right;

      ARect.Right:=Hold;

      ChangeGridOrientation(False);

    end;

    FOnDrawCell(Self,ACol,ARow,ARect,AState);

    if UseRightToLeftAlignment then ChangeGridOrientation(True);

  end;

end;

procedure TPropertyGrid.TopLeftChanged;

begin

  inherited TopLeftChanged;

  if Assigned(FOnTopLeftChanged) then FOnTopLeftChanged(Self);

end;

{StrItem management for TStringSparseList}

type

  PStrItem=^TStrItem;

  TStrItem=record

    FObject:TObject;

    FString:string;

  end;

function NewStrItem(const AString:string;AObject:TObject):PStrItem;

begin

  New(Result);

  Result^.FObject:=AObject;

  Result^.FString:=AString;

end;

procedure DisposeStrItem(P:PStrItem);

begin

  Dispose(P);

end;

{Sparse array classes for TStringPrGrid}

type

  PPointer=^Pointer;

  {Exception classes}

  EStringSparseListError=class(Exception);

  {TSparsePointerArray class}

  {Used by TSparseList.  Based on Sparse1Array, but has Pointer elements

   and Integer index, just like TPointerList/TList, and less indirection}

  {Apply function for the applicator:

   TheIndex        Index of item in array

   TheItem         Value of item (i.e pointer element) in section

   Returns: 0 if success, else error code.}

  TSPAApply=function(TheIndex:Integer;TheItem:Pointer):Integer;

  TSecDir=array [0..4095] of Pointer;{Enough for up to 12 bits of sec}

  PSecDir=^TSecDir;

  TSPAQuantum=(SPASmall,SPALarge);{Section size}

  TSparsePointerArray=class(TObject)

  private

    secDir:PSecDir;

    slotsInDir:Word;

    indexMask,secShift:Word;

    FHighBound:Integer;

    FSectionSize:Word;

    cachedIndex:Integer;

    cachedPointer:Pointer;

    {Return item[i], nil if slot outside defined section.}

    function GetAt(Index:Integer):Pointer;

    {Return address of item[i], creating slot if necessary.}

    function MakeAt(Index:Integer):PPointer;

    {Store item at item[i], creating slot if necessary.}

    procedure PutAt(Index:Integer;Item:Pointer);

  public

    constructor Create(Quantum:TSPAQuantum);

    destructor Destroy;override;

    {Traverse SPA, calling apply function for each defined non-nil

     item.  The traversal terminates if the apply function returns

     a value other than 0.}

    {NOTE: must be static method so that we can take its address in

     TSparseList.ForAll}

    function ForAll(ApplyFunction:Pointer{TSPAApply}):Integer;

    {Ratchet down HighBound after a deletion}

    procedure ResetHighBound;

    property HighBound:Integer read FHighBound;

    property SectionSize:Word read FSectionSize;

    property Items[Index:Integer]:Pointer read GetAt write PutAt;default;

  end;

  {TSparseList class}

  TSparseList=class(TObject)

  private

    FList:TSparsePointerArray;

    FCount:Integer;{1 + HighBound, adjusted for Insert/Delete}

    FQuantum:TSPAQuantum;

    procedure NewList(Quantum:TSPAQuantum);

  protected

    procedure Error;virtual;

    function Get(Index:Integer):Pointer;

    procedure Put(Index:Integer;Item:Pointer);

  public

    constructor Create(Quantum:TSPAQuantum);

    destructor Destroy;override;

    procedure Clear;

    procedure Delete(Index:Integer);

    procedure Exchange(Index1,Index2:Integer);

    function ForAll(ApplyFunction:Pointer{TSPAApply}):Integer;

    procedure Insert(Index:Integer;Item:Pointer);

    procedure Move(CurIndex,NewIndex:Integer);

    property Count:Integer read FCount;

    property Items[Index:Integer]:Pointer read Get write Put;default;

  end;

  {TStringSparseList class}

  TStringSparseList=class(TStrings)

  private

    FList:TSparseList;{of StrItems}

    FOnChange:TNotifyEvent;

  protected

    function Get(Index:Integer):String;override;

    function GetCount:Integer;override;

    function GetObject(Index:Integer):TObject;override;

    procedure Put(Index:Integer;const S:String);override;

    procedure PutObject(Index:Integer;AObject:TObject);override;

    procedure Changed;virtual;

    procedure Error;virtual;

  public

    constructor Create(Quantum:TSPAQuantum);

    destructor Destroy;override;

    procedure ReadData(Reader:TReader);

    procedure WriteData(Writer:TWriter);

    procedure DefineProperties(Filer:TFiler);override;

    procedure Delete(Index:Integer);override;

    procedure Exchange(Index1,Index2:Integer);override;

    procedure Insert(Index:Integer;const S:String);override;

    procedure Clear;override;

    property List:TSparseList read FList;

    property OnChange:TNotifyEvent read FOnChange write FOnChange;

  end;

constructor TPropertyGrid.Create(AOwner:TComponent);

begin

  inherited Create(AOwner);

  FValueColAutoSize:=False;

  FAlignment:=taLeftJustify;

  FShowCheckColumn:=True;

  CorrectWidths;

  ParentColor:=False;

  TabStop:=True;

  CustUpdateEvent:=UpdateNames;

  SetBounds(Left,Top,ColCount*DefaultNameColWidth,

    RowCount*DefaultRowHeight);

  Initialize;

end;

function TPropertyGrid.EnsureColRow(Index:Integer;

  IsCol:Boolean):TStringPrGridStrings;

var

  RCIndex:Integer;

  PList:^TSparseList;

begin

  if IsCol then PList:=@FCols
  else PList:=@FRows;

  Result:=TStringPrGridStrings(PList^[Index]);

  if Result=nil then

  begin

    if IsCol then RCIndex:=-Index-1
    else RCIndex:=Index+1;

    Result:=TStringPrGridStrings.Create(Self,RCIndex);

    PList^[Index]:=Result;

  end;

end;

procedure TPropertyGrid.Update(ACol,ARow:Integer);

begin

  if not FUpdating then InvalidateCell(ACol,ARow)

  else FNeedsUpdating:=True;

  if (ACol=Col)and(ARow=Row)and(FEditUpdate=0) then InvalidateEditor;

end;

procedure TPropertyGrid.SetUpdateState(Updating:Boolean);

begin

  FUpdating:=Updating;

  if not Updating and FNeedsUpdating then

  begin

    InvalidateGrid;

    FNeedsUpdating:=False;

  end;

end;

function TPropertyGrid.EnsureDataRow(ARow:Integer):Pointer;

var

  Quantum:TSPAQuantum;

begin

  Result:=TStringSparseList(TSparseList(FData)[ARow]);

  if Result=nil then

  begin

    if ColCount>512 then Quantum:=SPALarge
    else Quantum:=SPASmall;

    Result:=TStringSparseList.Create(Quantum);

    TSparseList(FData)[ARow]:=Result;

  end;

end;

procedure TPropertyGrid.Initialize;

var
  Quantum:TSPAQuantum;

begin

  if FCols=nil then

  begin

    if ColCount>512 then Quantum:=SPALarge
    else Quantum:=SPASmall;

    FCols:=TSparseList.Create(Quantum);

  end;

  if RowCount>256 then Quantum:=SPALarge
  else Quantum:=SPASmall;

  if FRows=nil then FRows:=TSparseList.Create(Quantum);

  if FData=nil then FData:=TSparseList.Create(Quantum);

end;

destructor TPropertyGrid.Destroy;

  function FreeItem(TheIndex:Integer;TheItem:Pointer):Integer;far;

  begin

    TObject(TheItem).Free;

    Result:=0;

  end;

begin

  if FRows<>nil then

  begin

    TSparseList(FRows).ForAll(@FreeItem);

    TSparseList(FRows).Free;

  end;

  if FCols<>nil then

  begin

    TSparseList(FCols).ForAll(@FreeItem);

    TSparseList(FCols).Free;

  end;

  if FData<>nil then

  begin

    TSparseList(FData).ForAll(@FreeItem);

    TSparseList(FData).Free;

  end;

  inherited Destroy;

end;

procedure TPropertyGrid.SetValueColAutoSize(const Value:Boolean);

begin

  FValueColAutoSize:=Value;

  InvalidateGrid;

end;

procedure TPropertyGrid.Paint;

begin

  CorrectWidths;

  inherited Paint;

end;

procedure TPropertyGrid.DisableEditUpdate;

begin

  Inc(FEditUpdate);

end;

procedure TPropertyGrid.EnableEditUpdate;

begin

  Dec(FEditUpdate);

end;

procedure TPropertyGrid.Resize;

begin

  inherited Resize;

  Paint;

end;

procedure TPropertyGrid.AddPropertyRow(pName,pValue:string;

  pEditMode:TPropEditMode);

begin

  PropValues.Add;

  ChangePropertyRow(RowCount-1,pName,pValue,pEditMode);

  UpdateProps;

end;

procedure TPropertyGrid.ChangePropertyRow(Index:Integer;pName,pValue:string;

  pEditMode:TPropEditMode);

begin

  PropValues[Index].PropertyLabel:=pName;

  PropValues[Index].EditMode:=pEditMode;

  PropValues[Index].PropertyValue:=pValue;

  InvalidateEditor;

end;

function TPropertyGrid.GetCells(ACol,ARow:Integer):string;

var
  ssl:TStringSparseList;

begin

  ssl:=TStringSparseList(TSparseList(FData)[ARow]);

  if ssl=nil then Result:=''
  else Result:=ssl[ACol];

end;

function TPropertyGrid.GetObjects(ACol,ARow:Integer):TObject;

var
  ssl:TStringSparseList;

begin

  ssl:=TStringSparseList(TSparseList(FData)[ARow]);

  if ssl=nil then Result:=nil
  else Result:=ssl.Objects[ACol];

end;

procedure TPropertyGrid.SetCells(ACol,ARow:Integer;const Value:string);

begin

  TStringPrGridStrings(EnsureDataRow(ARow))[ACol]:=Value;

  EnsureColRow(ACol,True);

  EnsureColRow(ARow,False);

  Update(ACol,ARow);

end;

procedure TPropertyGrid.SetObjects(ACol,ARow:Integer;

  const Value:TObject);

begin

  TStringPrGridStrings(EnsureDataRow(ARow)).Objects[ACol]:=Value;

  EnsureColRow(ACol,True);

  EnsureColRow(ARow,False);

  Update(ACol,ARow);

end;

procedure TPropertyGrid.DeletePropertyRow(Index:Integer);

begin

  if (Index<>0)and(RowCount>1) then

  begin

    HideEditor;

    PropValues.Delete(Index);

    UpdateNames(Self);

    if not(Index=RowCount) then ShowEditor;

  end;

end;

procedure TPropertyGrid.UpdateNames(Sender:TObject);

var
  I:Integer;

begin

  for I:=0 to Pred(PropValues.Count) do Cells[0,I]:=PropValues[I].PropertyLabel;

  UpdateValues;

end;

procedure TPropertyGrid.UpdateValues;

var
  I:Integer;

begin

  if FShowCheckColumn then

    for I:=0 to Pred(PropValues.Count) do

    begin

      Cells[2,I]:=PropValues[I].PropertyValue;

      Cells[1,I]:='';

    end

  else

    for I:=0 to Pred(PropValues.Count) do

        Cells[1,I]:=PropValues[I].PropertyValue;

  UpdateTitle;

end;

procedure TPropertyGrid.SetAlignment(const Value:TAlignment);

begin

  FAlignment:=Value;

  Repaint;

end;

procedure TPropertyGrid.SetShowCheckColumn(const Value:Boolean);

var
  SaveWidth:Integer;

begin

  FShowCheckColumn:=Value;

  if FShowCheckColumn then

  begin

    ColCount:=3;

    FixedCols:=2;

  end

  else

  begin

    SaveWidth:=ColWidths[2];

    FixedCols:=1;

    ColCount:=2;

    ColWidths[1]:=SaveWidth;

  end;

  CorrectWidths;

  UpdateNames(Self);

  Invalidate;

end;

procedure TPropertyGrid.MouseDown(Button:TMouseButton;Shift:TShiftState;

  X,Y:Integer);

var
  Coord:TGridCoord;

begin

  inherited MouseDown(Button,Shift,X,Y);

  Coord:=MouseCoord(X,Y);

  if (Coord.X=1)and FShowCheckColumn and(Button=mbLeft) then

    if PropValues[Coord.Y].Enabled then

    begin

      PropValues[Coord.Y].Checked:=not PropValues[Coord.Y].Checked;

      if Assigned(FOnCheckBoxClick) then FOnCheckBoxClick(Self,Coord.Y);

    end;

end;

procedure TPropertyGrid.CorrectWidths;

begin

  ColWidths[0]:=DefaultNameColWidth;

  if FValueColAutoSize then

  begin

    if FShowCheckColumn then

    begin

      ColWidths[1]:=17;

      ColWidths[2]:=ClientWidth-20-DefaultNameColWidth;

    end

    else

        ColWidths[1]:=ClientWidth-DefaultNameColWidth-2;

  end

  else

    if FShowCheckColumn then ColWidths[1]:=17;

end;

procedure TPropertyGrid.UpdateTitle;

begin

  if goTitle in Options then

  begin

    Cells[0,0]:=PropGridTitle.TitleNameText;

    if FShowCheckColumn then

    begin

      Cells[1,0]:='';

      Cells[2,0]:=PropGridTitle.TitleValueText;

    end

    else Cells[1,0]:=PropGridTitle.TitleValueText;

  end;

end;

{TSparsePointerArray}

const

  SPAIndexMask: array [TSPAQuantum] of Byte=(15,255);

  SPASecShift: array [TSPAQuantum] of Byte=(4,8);

  {Expand Section Directory to cover at least `newSlots' slots. Returns: Possibly

   updated pointer to the Section Directory.}

function ExpandDir(secDir:PSecDir;var slotsInDir:Word;

  newSlots:Word):PSecDir;

begin

  Result:=secDir;

  ReallocMem(Result,newSlots*SizeOf(Pointer));

  FillChar(Result^[slotsInDir],(newSlots-slotsInDir)*SizeOf(Pointer),0);

  slotsInDir:=newSlots;

end;

{Allocate a section and set all its items to nil. Returns: Pointer to start of

 section.}

function MakeSec(SecIndex:Integer;SectionSize:Word):Pointer;

var

  SecP:Pointer;

  Size:Word;

begin

  Size:=SectionSize*SizeOf(Pointer);

  GetMem(SecP,Size);

  FillChar(SecP^,Size,0);

  MakeSec:=SecP

end;

constructor TSparsePointerArray.Create(Quantum:TSPAQuantum);

begin

  secDir:=nil;

  slotsInDir:=0;

  FHighBound:=-1;

  FSectionSize:=Word(SPAIndexMask[Quantum])+1;

  indexMask:=Word(SPAIndexMask[Quantum]);

  secShift:=Word(SPASecShift[Quantum]);

  cachedIndex:=-1

end;

destructor TSparsePointerArray.Destroy;

var

  I:Integer;

  Size:Word;

begin

  {Scan section directory and free each section that exists.}

  I:=0;

  Size:=FSectionSize*SizeOf(Pointer);

  while I<slotsInDir do begin

    if secDir^[I]<>nil then

        FreeMem(secDir^[I],Size);

    Inc(I)

  end;

  {Free section directory.}

  if secDir<>nil then

      FreeMem(secDir,slotsInDir*SizeOf(Pointer));

end;

function TSparsePointerArray.GetAt(Index:Integer):Pointer;

var

  byteP:PChar;

  SecIndex:Cardinal;

begin

  {Index into Section Directory using high order part of

   index.  Get pointer to Section. If not null, index into

   Section using low order part of index.}

  if Index=cachedIndex then

      Result:=cachedPointer

  else begin

    SecIndex:=Index shr secShift;

    if SecIndex>=slotsInDir then

        byteP:=nil

    else begin

      byteP:=secDir^[SecIndex];

      if byteP<>nil then begin

        Inc(byteP,(Index and indexMask)*SizeOf(Pointer));

      end

    end;

    if byteP=nil then Result:=nil
    else Result:=PPointer(byteP)^;

    cachedIndex:=Index;

    cachedPointer:=Result

  end

end;

function TSparsePointerArray.MakeAt(Index:Integer):PPointer;

var

  dirP:PSecDir;

  P:Pointer;

  byteP:PChar;

  SecIndex:Word;

begin

  {Expand Section Directory if necessary.}

  SecIndex:=Index shr secShift;{Unsigned shift}

  if SecIndex>=slotsInDir then

      dirP:=ExpandDir(secDir,slotsInDir,SecIndex+1)

  else

      dirP:=secDir;

  {Index into Section Directory using high order part of

   index.  Get pointer to Section. If null, create new

   Section.  Index into Section using low order part of index.}

  secDir:=dirP;

  P:=dirP^[SecIndex];

  if P=nil then begin

    P:=MakeSec(SecIndex,FSectionSize);

    dirP^[SecIndex]:=P

  end;

  byteP:=P;

  Inc(byteP,(Index and indexMask)*SizeOf(Pointer));

  if Index>FHighBound then

      FHighBound:=Index;

  Result:=PPointer(byteP);

  cachedIndex:=-1

end;

procedure TSparsePointerArray.PutAt(Index:Integer;Item:Pointer);

begin

  if (Item<>nil)or(GetAt(Index)<>nil) then

  begin

    MakeAt(Index)^:=Item;

    if Item=nil then

        ResetHighBound

  end

end;

function TSparsePointerArray.ForAll(ApplyFunction:Pointer{TSPAApply}):

  Integer;

var

  itemP:PChar;{Pointer to item in section}

  Item:Pointer;

  I,callerBP:Cardinal;

  J,Index:Integer;

begin

  {Scan section directory and scan each section that exists,

   calling the apply function for each non-nil item.

   The apply function must be a far local function in the scope of

   the procedure P calling ForAll.  The trick of setting up the stack

   frame (taken from TurboVision's TCollection.ForEach) allows the

   apply function access to P's arguments and local variables and,

   if P is a method, the instance variables and methods of P's class}

  Result:=0;

  I:=0;

  asm

    mov   eax,[ebp]                     {Set up stack frame for local}

    mov   callerBP,eax

  end;

  while (I<slotsInDir)and(Result=0) do begin

    itemP:=secDir^[I];

    if itemP<>nil then begin

      J:=0;

      index:=I shl secShift;

      while (J<FSectionSize)and(Result=0) do begin

        Item:=PPointer(itemP)^;

        if Item<>nil then

          {ret := ApplyFunction(index, item.Ptr);}

          asm

            mov   eax,index

            mov   edx,item

            push  callerBP

            call  ApplyFunction

            pop   ecx

            mov   @Result,eax

          end;

        Inc(itemP,SizeOf(Pointer));

        Inc(J);

        Inc(index)

      end

    end;

    Inc(I)

  end;

end;

procedure TSparsePointerArray.ResetHighBound;

var

  NewHighBound:Integer;

  function Detector(TheIndex:Integer;TheItem:Pointer):Integer;far;

  begin

    if TheIndex>FHighBound then

        Result:=1

    else

    begin

      Result:=0;

      if TheItem<>nil then NewHighBound:=TheIndex

    end

  end;

begin

  NewHighBound:=-1;

  ForAll(@Detector);

  FHighBound:=NewHighBound

end;

{TSparseList}

constructor TSparseList.Create(Quantum:TSPAQuantum);

begin

  NewList(Quantum)

end;

destructor TSparseList.Destroy;

begin

  if FList<>nil then FList.Destroy

end;

procedure TSparseList.Clear;

begin

  FList.Destroy;

  NewList(FQuantum);

  FCount:=0

end;

procedure TSparseList.Delete(Index:Integer);

var

  I:Integer;

begin

  if (Index<0)or(Index>=FCount) then Exit;

  for I:=Index to FCount-1 do

      FList[I]:=FList[I+1];

  FList[FCount]:=nil;

  Dec(FCount);

end;

procedure TSparseList.Error;

begin

  raise EListError.Create(SListBoxMustBeVirtual);

end;

procedure TSparseList.Exchange(Index1,Index2:Integer);

var

  Temp:Pointer;

begin

  Temp:=Get(Index1);

  Put(Index1,Get(Index2));

  Put(Index2,Temp);

end;

{Jump to TSparsePointerArray.ForAll so that it looks like it was called

 from our caller, so that the BP trick works.}

function TSparseList.ForAll(ApplyFunction:Pointer{TSPAApply}):Integer;assembler;

asm

  MOV     EAX,[EAX].TSparseList.FList

  JMP     TSparsePointerArray.ForAll

end;

function TSparseList.Get(Index:Integer):Pointer;

begin

  if Index<0 then Error;

  Result:=FList[Index]

end;

procedure TSparseList.Insert(Index:Integer;Item:Pointer);

var

  I:Integer;

begin

  if Index<0 then Error;

  I:=FCount;

  while I>Index do

  begin

    FList[I]:=FList[I-1];

    Dec(I)

  end;

  FList[Index]:=Item;

  if Index>FCount then FCount:=Index;

  Inc(FCount)

end;

procedure TSparseList.Move(CurIndex,NewIndex:Integer);

var

  Item:Pointer;

begin

  if CurIndex<>NewIndex then

  begin

    Item:=Get(CurIndex);

    Delete(CurIndex);

    Insert(NewIndex,Item);

  end;

end;

procedure TSparseList.NewList(Quantum:TSPAQuantum);

begin

  FQuantum:=Quantum;

  FList:=TSparsePointerArray.Create(Quantum)

end;

procedure TSparseList.Put(Index:Integer;Item:Pointer);

begin

  if Index<0 then Error;

  FList[Index]:=Item;

  FCount:=FList.HighBound+1

end;

{TStringSparseList}

constructor TStringSparseList.Create(Quantum:TSPAQuantum);

begin

  FList:=TSparseList.Create(Quantum)

end;

destructor TStringSparseList.Destroy;

begin

  if FList<>nil then begin

    Clear;

    FList.Destroy

  end

end;

procedure TStringSparseList.ReadData(Reader:TReader);

var

  I:Integer;

begin

  with Reader do begin

    I:=Integer(ReadInteger);

    while I>0 do begin

      InsertObject(Integer(ReadInteger),ReadString,nil);

      Dec(I)

    end

  end

end;

procedure TStringSparseList.WriteData(Writer:TWriter);

var

  itemCount:Integer;

  function CountItem(TheIndex:Integer;TheItem:Pointer):Integer;far;

  begin

    Inc(itemCount);

    Result:=0

  end;

  function StoreItem(TheIndex:Integer;TheItem:Pointer):Integer;far;

  begin

    with Writer do

    begin

      WriteInteger(TheIndex);{Item index}

      WriteString(PStrItem(TheItem)^.FString);

    end;

    Result:=0

  end;

begin

  with Writer do

  begin

    itemCount:=0;

    FList.ForAll(@CountItem);

    WriteInteger(itemCount);

    FList.ForAll(@StoreItem);

  end

end;

procedure TStringSparseList.DefineProperties(Filer:TFiler);

begin

  Filer.DefineProperty('List',ReadData,WriteData,True);

end;

function TStringSparseList.Get(Index:Integer):String;

var

  P:PStrItem;

begin

  P:=PStrItem(FList[Index]);

  if P=nil then Result:=''
  else Result:=P^.FString

end;

function TStringSparseList.GetCount:Integer;

begin

  Result:=FList.Count

end;

function TStringSparseList.GetObject(Index:Integer):TObject;

var

  P:PStrItem;

begin

  P:=PStrItem(FList[Index]);

  if P=nil then Result:=nil
  else Result:=P^.FObject

end;

procedure TStringSparseList.Put(Index:Integer;const S:String);

var

  P:PStrItem;

  obj:TObject;

begin

  P:=PStrItem(FList[Index]);

  if P=nil then obj:=nil
  else obj:=P^.FObject;

  if (S='')and(obj=nil) then {Nothing left to store}

      FList[Index]:=nil

  else

      FList[Index]:=NewStrItem(S,obj);

  if P<>nil then DisposeStrItem(P);

  Changed

end;

procedure TStringSparseList.PutObject(Index:Integer;AObject:TObject);

var

  P:PStrItem;

begin

  P:=PStrItem(FList[Index]);

  if P<>nil then

      P^.FObject:=AObject

  else if AObject<>nil then

      FList[Index]:=NewStrItem('',AObject);

  Changed

end;

procedure TStringSparseList.Changed;

begin

  if Assigned(FOnChange) then FOnChange(Self)

end;

procedure TStringSparseList.Error;

begin

  raise EStringSparseListError.Create(SPutObjectError);

end;

procedure TStringSparseList.Delete(Index:Integer);

var

  P:PStrItem;

begin

  P:=PStrItem(FList[Index]);

  if P<>nil then DisposeStrItem(P);

  FList.Delete(Index);

  Changed

end;

procedure TStringSparseList.Exchange(Index1,Index2:Integer);

begin

  FList.Exchange(Index1,Index2);

end;

procedure TStringSparseList.Insert(Index:Integer;const S:String);

begin

  FList.Insert(Index,NewStrItem(S,nil));

  Changed

end;

procedure TStringSparseList.Clear;

  function ClearItem(TheIndex:Integer;TheItem:Pointer):Integer;far;

  begin

    DisposeStrItem(PStrItem(TheItem));{Item guaranteed non-nil}

    Result:=0

  end;

begin

  FList.ForAll(@ClearItem);

  FList.Clear;

  Changed

end;

{TStringPrGridStrings}

{AIndex < 0 is a column (for column -AIndex - 1)

 AIndex > 0 is a row (for row AIndex - 1)

 AIndex = 0 denotes an empty row or column}

constructor TStringPrGridStrings.Create(AGrid:TPropertyGrid;AIndex:Longint);

begin

  inherited Create;

  FGrid:=AGrid;

  FIndex:=AIndex;

end;

procedure TStringPrGridStrings.Assign(Source:TPersistent);

var

  I,Max:Integer;

begin

  if Source is TStrings then

  begin

    BeginUpdate;

    Max:=TStrings(Source).Count-1;

    if Max>=Count then Max:=Count-1;

    try

      for I:=0 to Max do

      begin

        Put(I,TStrings(Source).Strings[I]);

        PutObject(I,TStrings(Source).Objects[I]);

      end;

    finally

        EndUpdate;

    end;

    Exit;

  end;

  inherited Assign(Source);

end;

procedure TStringPrGridStrings.CalcXY(Index:Integer;var X,Y:Integer);

begin

  if FIndex=0 then

  begin

    X:=-1;
    Y:=-1;

  end
  else if FIndex>0 then

  begin

    X:=Index;

    Y:=FIndex-1;

  end
  else

  begin

    X:=-FIndex-1;

    Y:=Index;

  end;

end;

{Changes the meaning of Add to mean copy to the first empty string}

function TStringPrGridStrings.Add(const S:string):Integer;

var

  I:Integer;

begin

  for I:=0 to Count-1 do

    if Strings[I]='' then

    begin

      Strings[I]:=S;

      Result:=I;

      Exit;

    end;

  Result:=-1;

end;

procedure TStringPrGridStrings.Clear;

var

  SSList:TStringSparseList;

  I:Integer;

  function BlankStr(TheIndex:Integer;TheItem:Pointer):Integer;far;

  begin

    Objects[TheIndex]:=nil;

    Strings[TheIndex]:='';

    Result:=0;

  end;

begin

  if FIndex>0 then

  begin

    SSList:=TStringSparseList(TSparseList(FGrid.FData)[FIndex-1]);

    if SSList<>nil then SSList.List.ForAll(@BlankStr);

  end

  else if FIndex<0 then

    for I:=Count-1 downto 0 do

    begin

      Objects[I]:=nil;

      Strings[I]:='';

    end;

end;

procedure TStringPrGridStrings.Delete(Index:Integer);

begin

  InvalidOp(sInvalidStringGridOp);

end;

function TStringPrGridStrings.Get(Index:Integer):string;

var

  X,Y:Integer;

begin

  CalcXY(Index,X,Y);

  if X<0 then Result:=''
  else Result:=FGrid.Cells[X,Y];

end;

function TStringPrGridStrings.GetCount:Integer;

begin

  {Count of a row is the column count, and vice versa}

  if FIndex=0 then Result:=0

  else if FIndex>0 then Result:=Integer(FGrid.ColCount)

  else Result:=Integer(FGrid.RowCount);

end;

function TStringPrGridStrings.GetObject(Index:Integer):TObject;

var

  X,Y:Integer;

begin

  CalcXY(Index,X,Y);

  if X<0 then Result:=nil
  else Result:=FGrid.Objects[X,Y];

end;

procedure TStringPrGridStrings.Insert(Index:Integer;const S:string);

begin

  InvalidOp(sInvalidStringGridOp);

end;

procedure TStringPrGridStrings.Put(Index:Integer;const S:string);

var

  X,Y:Integer;

begin

  CalcXY(Index,X,Y);

  FGrid.Cells[X,Y]:=S;

end;

procedure TStringPrGridStrings.PutObject(Index:Integer;AObject:TObject);

var

  X,Y:Integer;

begin

  CalcXY(Index,X,Y);

  FGrid.Objects[X,Y]:=AObject;

end;

procedure TStringPrGridStrings.SetUpdateState(Updating:Boolean);

begin

  FGrid.SetUpdateState(Updating);

end;

procedure TPropertyGrid.ColumnMoved(FromIndex,ToIndex:Longint);

  function MoveColData(Index:Integer;ARow:TStringSparseList):Integer;far;

  begin

    ARow.Move(FromIndex,ToIndex);

    Result:=0;

  end;

begin

  TSparseList(FData).ForAll(@MoveColData);

  Invalidate;

  if Assigned(FOnColumnMoved) then FOnColumnMoved(Self,FromIndex,ToIndex);

end;

procedure TPropertyGrid.RowMoved(FromIndex,ToIndex:Longint);

begin

  TSparseList(FData).Move(FromIndex,ToIndex);

  Invalidate;

  if Assigned(FOnRowMoved) then FOnRowMoved(Self,FromIndex,ToIndex);

end;

{TPopupListbox}

procedure TPopupListBox.CreateParams(var Params:TCreateParams);

begin

  inherited CreateParams(Params);

  with Params do

  begin

    Style:=Style or WS_BORDER;

    ExStyle:=WS_EX_TOOLWINDOW or WS_EX_TOPMOST;

    AddBiDiModeExStyle(ExStyle);

    WindowClass.Style:=CS_SAVEBITS;

  end;

end;

procedure TPopupListBox.CreateWnd;

begin

  inherited CreateWnd;

  Windows.SetParent(Handle,0);

  CallWindowProc(DefWndProc,Handle,WM_SETFOCUS,0,0);

end;

procedure TPopupListBox.KeyPress(var Key:Char);

var

  TickCount:Integer;

begin

  case Key of

    #8,#27:FSearchText:='';

    #32..#255:

      begin

        TickCount:=GetTickCount;

        if TickCount-FSearchTickCount>2000 then FSearchText:='';

        FSearchTickCount:=TickCount;

        if Length(FSearchText)<32 then FSearchText:=FSearchText+Key;

        SendMessage(Handle,LB_SelectString,Word(-1),Longint(PChar(FSearchText)));

        Key:=#0;

      end;

  end;

  inherited KeyPress(Key);

end;

procedure TPopupListBox.MouseUp(Button:TMouseButton;Shift:TShiftState;

  X,Y:Integer);

begin

  inherited MouseUp(Button,Shift,X,Y);

  TPropertyInplaceEdit(Owner).CloseUp((X>=0)and(Y>=0)and

    (X<Width)and(Y<Height));

end;

{TCellValueProp}

constructor TCellValueProp.Create(Collection:TCollection);

begin

  inherited Create(Collection);

  FSpinProps:=TSpinProps.Create(Self);

  FCollection:=Collection;

  FChecked:=False;

  FReadOnly:=False;

  FEnabled:=True;

  FDropDownRows:=7;

  FEditMode:=emSimple;

end;

destructor TCellValueProp.Destroy;

begin

  FCollection:=nil;

  FSpinProps:=nil;

  inherited Destroy;

end;

function TCellValueProp.GetPickList:TStrings;

begin

  if FPickList=nil then

      FPickList:=TStringList.Create;

  Result:=FPickList;

end;

function TCellValueProp.GetPropertyValue:string;

begin

  Result:=FPropertyValue;

end;

function TCellValueProp.GetReadOnly:Boolean;

begin

  Result:=FReadOnly

end;

function TCellValueProp.GetText:string;

begin

  Result:=FText;

end;

procedure TCellValueProp.SetChecked(const Value:Boolean);

begin

  FCollection.BeginUpdate;

  FChecked:=Value;

  FCollection.EndUpdate;

end;

procedure TCellValueProp.SetDropDownRows(const Value:Cardinal);

begin

  FDropDownRows:=Value;

end;

procedure TCellValueProp.SetEditMask(const Value:string);

begin

  FEditMask:=Value;

end;

procedure TCellValueProp.SetEditMode(const Value:TPropEditMode);

begin

  FEditMode:=Value;

end;

procedure TCellValueProp.SetEnabled(const Value:Boolean);

begin

  FCollection.BeginUpdate;

  FEnabled:=Value;

  FCollection.EndUpdate;

end;

procedure TCellValueProp.SetSpinProps(const Value:TSpinProps);

begin

  if Value=nil then

  begin

    FSpinProps.Free;

    Exit;

  end;

  FSpinProps.Assign(Value);

end;

procedure TCellValueProp.SetPickList(const Value:TStrings);

begin

  if Value=nil then

  begin

    FPickList.Free;

    FPickList:=nil;

    Exit;

  end;

  PickList.Assign(Value);

end;

procedure TCellValueProp.SetPropertyLabel(const Value:string);

begin

  FCollection.BeginUpdate;

  FPropertyLabel:=Value;

  FCollection.EndUpdate;

end;

procedure TCellValueProp.SetPropertyValue(const Value:string);

begin

  FCollection.BeginUpdate;

  if (EditMode=emSpinEdit)and(Value<>'') then

    case SpinProps.ValueType of

      svtFloat:FPropertyValue:=FloatToStrF(StrToFloat(Value),ffFixed,15,SpinProps.Decimal);

      svtInteger:FPropertyValue:=IntToStr(Round(StrToFloat(Value)));

    end

  else FPropertyValue:=Value;

  FCollection.EndUpdate;

end;

procedure TCellValueProp.SetReadOnly(const Value:Boolean);

begin

  FReadOnly:=Value;

  Changed(False);

end;

procedure TCellValueProp.SetText(const Value:string);

begin

  FText:=Value;

end;

{TCellValueProps}

function TCellValueProps.Add:TCellValueProp;

begin

  Result:=TCellValueProp(inherited Add);

end;

procedure TCellValueProps.AddCellInfo;

var
  I:Integer;

begin

  Clear;

  for I:=0 to Pred(FGrid.RowCount) do Add;

end;

function TCellValueProps.AddInfo(ddRows:Cardinal;iTag:Integer;

  iEditMode:TPropEditMode;iPickList:TStrings):TCellValueProp;

begin

  Result:=TCellValueProp(inherited Add);

  with Result do

  begin

    DropDownRows:=ddRows;

    Tag:=iTag;

    EditMode:=iEditMode;

    if (iPickList<>nil) then PickList.Assign(iPickList);

  end;

end;

procedure TCellValueProps.AddLastNeedItems(iAdded:Integer);

var
  I:Integer;

begin

  for I:=0 to Pred(iAdded) do inherited Add;

end;

procedure TCellValueProps.Clear;

begin

  if Count>0 then

  begin

    BeginUpdate;

    try

      if Grid.FInplaceEdit.Visible then Grid.HideEdit;

      if (Items[0].EditMode=emNoEdit)and not(goTitle in Grid.Options) then

          Items[0].EditMode:=emSimple;

      while Count>(2-Ord(not(goTitle in Grid.Options))) do TCollectionItem(Last).Free;

    finally

        EndUpdate;

    end;

  end;

end;

constructor TCellValueProps.Create(Grid:TCustomPrGrid;

  CellValuePropClass:TCellValuePropClass);

begin

  inherited Create(CellValuePropClass);

  FGrid:=Grid;

  AddCellInfo;

end;

procedure TCellValueProps.Delete(Index:Integer);

begin

  inherited Items[Index].Destroy;

end;

procedure TCellValueProps.DeleteLastSpareItems(iDeleted:Integer);

var
  I:Integer;

begin

  for I:=Pred(Count) downto (Count-iDeleted) do

      Items[I].Destroy;

end;

function TCellValueProps.GetCellValueProp(Index:Integer):TCellValueProp;

begin

  Result:=TCellValueProp(inherited Items[Index]);

end;

function TCellValueProps.GetOwner:TPersistent;

begin

  Result:=FGrid;

end;

function TCellValueProps.Last:TCellValueProp;

begin

  Result:=Items[Pred(Count)];

end;

procedure TCellValueProps.SetCellValueProp(Index:Integer;

  const Value:TCellValueProp);

begin

  Items[Index].Assign(Value);

end;

procedure TCellValueProps.Update(Item:TCollectionItem);

begin

  FGrid.UpdateGrid;

end;

{TPropGridTitle}

procedure TPropGridTitle.Assign(Source:TPersistent);

begin

  if Source is TPropGridTitle then

  begin

    Alignment:=TPropGridTitle(Source).Alignment;

    Color:=TPropGridTitle(Source).Color;

    TitleNameText:=TPropGridTitle(Source).TitleNameText;

    TitleValueText:=TPropGridTitle(Source).TitleValueText;

  end

  else

      inherited Assign(Source);

end;

constructor TPropGridTitle.Create(Grid:TCustomPrGrid);

begin

  inherited Create;

  FGrid:=Grid;

  FFont:=TFont.Create;

  FFont.Assign(DefaultFont);

  FFont.OnChange:=FontChanged;

end;

function TPropGridTitle.DefaultAlignment:TAlignment;

begin

  Result:=taLeftJustify;

end;

function TPropGridTitle.DefaultColor:TColor;

begin

  Result:=FGrid.FixedColor

end;

function TPropGridTitle.DefaultFont:TFont;

begin

  Result:=FGrid.Font

end;

procedure TPropGridTitle.FontChanged(Sender:TObject);

begin

  Include(FAssignedValues,pvTitleFont);

end;

function TPropGridTitle.GetAlignment:TAlignment;

begin

  Result:=FAlignment;

end;

function TPropGridTitle.GetColor:TColor;

begin

  if pvTitleColor in FAssignedValues then

      Result:=FColor

  else

      Result:=DefaultColor;

end;

function TPropGridTitle.GetFont:TFont;

var
  Save:TNotifyEvent;

  Def:TFont;

begin

  if not(pvTitleFont in FAssignedValues) then

  begin

    Def:=DefaultFont;

    if (FFont.Handle<>Def.Handle)or(FFont.Color<>Def.Color) then

    begin

      Save:=FFont.OnChange;

      FFont.OnChange:=nil;

      FFont.Assign(DefaultFont);

      FFont.OnChange:=Save;

    end;

  end;

  Result:=FFont;

end;

function TPropGridTitle.GetTitleNameText:string;

begin

  Result:=FTitleNameText

end;

function TPropGridTitle.GetTitleValueText:string;

begin

  Result:=FTitleValueText

end;

function TPropGridTitle.IsColorStored:Boolean;

begin

  Result:=(pvTitleColor in FAssignedValues)and

    (FColor<>DefaultColor);

end;

function TPropGridTitle.IsFontStored:Boolean;

begin

  Result:=(pvTitleFont in FAssignedValues);

end;

procedure TPropGridTitle.SetAlignment(Value:TAlignment);

begin

  if FAlignment<>Value then

  begin

    FAlignment:=Value;

    FGrid.InvalidateGrid;

  end;

end;

procedure TPropGridTitle.SetColor(Value:TColor);

begin

  if (pvTitleColor in FAssignedValues)and(Value=FColor) then Exit;

  FColor:=Value;

  Include(FAssignedValues,pvTitleColor);

  FGrid.InvalidateGrid;

end;

procedure TPropGridTitle.SetFont(const Value:TFont);

begin

  FFont.Assign(Value);

  FGrid.InvalidateGrid;

end;

procedure TPropGridTitle.SetTitleNameText(const Value:string);

begin

  if FTitleNameText<>Value then

  begin

    FTitleNameText:=Value;

    if goTitle in FGrid.Options then

        TPropertyGrid(FGrid).Cells[0,0]:=Value;

    FGrid.InvalidateGrid;

  end;

end;

procedure TPropGridTitle.SetTitleValueText(const Value:string);

begin

  if FTitleValueText<>Value then

  begin

    FTitleValueText:=Value;

    if goTitle in FGrid.Options then

    begin

      if TPropertyGrid(FGrid).ShowCheckColumn then

          TPropertyGrid(FGrid).Cells[2,0]:=Value

      else TPropertyGrid(FGrid).Cells[1,0]:=Value;

    end;

    FGrid.InvalidateGrid;

  end;

end;

{TPropSpinButton}

constructor TPropSpinButton.Create(AOwner:TComponent);

begin

  inherited Create(AOwner);

  ControlStyle:=ControlStyle-[csAcceptsControls,csSetCaption]+

    [csFramed,csOpaque];

  FUpButton:=CreateButton;

  FDownButton:=CreateButton;

  UpGlyph:=nil;

  DownGlyph:=nil;

  Width:=20;

  Height:=25;

  FFocusedButton:=FUpButton;

end;

function TPropSpinButton.CreateButton:TTimerSpeedButton;

begin

  Result:=TTimerSpeedButton.Create(Self);

  Result.OnClick:=BtnClick;

  Result.OnMouseDown:=BtnMouseDown;

  Result.Flat:=FFlat;

  Result.Visible:=True;

  Result.Enabled:=True;

  Result.TimeBtnState:=[tbAllowTimer];

  Result.Parent:=Self;

end;

procedure TPropSpinButton.Notification(AComponent:TComponent;

  Operation:TOperation);

begin

  inherited Notification(AComponent,Operation);

  if (Operation=opRemove)and(AComponent=FFocusControl) then

      FFocusControl:=nil;

end;

procedure TPropSpinButton.AdjustSize(var W,H:Integer);

begin

  if (FUpButton=nil)or(csLoading in ComponentState) then Exit;

  if W<15 then W:=15;

  FUpButton.Flat:=FFlat;

  FDownButton.Flat:=FFlat;

  FUpButton.Transparent:=False;

  FDownButton.Transparent:=False;

  if FFlat then

  begin

    FUpButton.SetBounds(0,0,W,(H div 2)+1);

    FDownButton.SetBounds(0,FUpButton.Height-1,W,H-FUpButton.Height+1);

  end

  else

  begin

    FUpButton.SetBounds(0,0,W,(H div 2){+ 1*Ord(not FFramed)});

    FDownButton.SetBounds(0,FUpButton.Height,W,H-FUpButton.Height);

  end;

end;

procedure TPropSpinButton.SetBounds(ALeft,ATop,AWidth,AHeight:Integer);

var

  W,H:Integer;

begin

  W:=AWidth;

  H:=AHeight;

  AdjustSize(W,H);

  inherited SetBounds(ALeft,ATop,W,H);

end;

procedure TPropSpinButton.WMSize(var Message:TWMSize);

var

  W,H:Integer;

begin

  inherited;

  {check for minimum size}

  W:=Width;

  H:=Height;

  AdjustSize(W,H);

  if (W<>Width)or(H<>Height) then

      inherited SetBounds(Left,Top,W,H);

  Message.Result:=0;

end;

procedure TPropSpinButton.WMSetFocus(var Message:TWMSetFocus);

begin

  FFocusedButton.TimeBtnState:=FFocusedButton.TimeBtnState+[tbFocusRect];

  FFocusedButton.Invalidate;

end;

procedure TPropSpinButton.WMKillFocus(var Message:TWMKillFocus);

begin

  FFocusedButton.TimeBtnState:=FFocusedButton.TimeBtnState-[tbFocusRect];

  FFocusedButton.Invalidate;

end;

procedure TPropSpinButton.KeyDown(var Key:Word;Shift:TShiftState);

begin

  case Key of

    VK_UP:

      begin

        SetFocusBtn(FUpButton);

        FUpButton.Click;

      end;

    VK_DOWN:

      begin

        SetFocusBtn(FDownButton);

        FDownButton.Click;

      end;

    VK_SPACE:

      FFocusedButton.Click;

  end;

end;

procedure TPropSpinButton.BtnMouseDown(Sender:TObject;Button:TMouseButton;

  Shift:TShiftState;X,Y:Integer);

begin

  if Button=mbLeft then

  begin

    SetFocusBtn(TTimerSpeedButton(Sender));

    if (FFocusControl<>nil)and FFocusControl.TabStop and

      FFocusControl.CanFocus and(GetFocus<>FFocusControl.Handle) then

        FFocusControl.SetFocus

    else if TabStop and(GetFocus<>Handle)and CanFocus then

        SetFocus;

  end;

end;

procedure TPropSpinButton.BtnClick(Sender:TObject);

begin

  if Sender=FUpButton then

  begin

    if Assigned(FOnUpClick) then FOnUpClick(Self);

  end

  else

    if Assigned(FOnDownClick) then FOnDownClick(Self);

end;

procedure TPropSpinButton.SetFocusBtn(Btn:TTimerSpeedButton);

begin

  if TabStop and CanFocus and(Btn<>FFocusedButton) then

  begin

    FFocusedButton.TimeBtnState:=FFocusedButton.TimeBtnState-[tbFocusRect];

    FFocusedButton:=Btn;

    if (GetFocus=Handle) then

    begin

      FFocusedButton.TimeBtnState:=FFocusedButton.TimeBtnState+[tbFocusRect];

      Invalidate;

    end;

  end;

end;

procedure TPropSpinButton.WMGetDlgCode(var Message:TWMGetDlgCode);

begin

  Message.Result:=DLGC_WANTARROWS;

end;

procedure TPropSpinButton.Loaded;

var

  W,H:Integer;

begin

  inherited Loaded;

  W:=Width;

  H:=Height;

  AdjustSize(W,H);

  if (W<>Width)or(H<>Height) then

      inherited SetBounds(Left,Top,W,H);

end;

function TPropSpinButton.GetUpGlyph:TBitmap;

begin

  Result:=FUpButton.Glyph;

end;

procedure TPropSpinButton.SetUpGlyph(Value:TBitmap);

begin

  if Value<>nil then

      FUpButton.Glyph:=Value

  else

  begin

    FUpButton.Glyph.Handle:=LoadBitmap(HInstance,'SpinUp');

    FUpButton.NumGlyphs:=1;

    FUpButton.Invalidate;

  end;

end;

function TPropSpinButton.GetUpNumGlyphs:TNumGlyphs;

begin

  Result:=FUpButton.NumGlyphs;

end;

procedure TPropSpinButton.SetUpNumGlyphs(Value:TNumGlyphs);

begin

  FUpButton.NumGlyphs:=Value;

end;

function TPropSpinButton.GetDownGlyph:TBitmap;

begin

  Result:=FDownButton.Glyph;

end;

procedure TPropSpinButton.SetDownGlyph(Value:TBitmap);

begin

  if Value<>nil then

      FDownButton.Glyph:=Value

  else

  begin

    FDownButton.Glyph.Handle:=LoadBitmap(HInstance,'SpinDown');

    FUpButton.NumGlyphs:=1;

    FDownButton.Invalidate;

  end;

end;

function TPropSpinButton.GetDownNumGlyphs:TNumGlyphs;

begin

  Result:=FDownButton.NumGlyphs;

end;

procedure TPropSpinButton.SetDownNumGlyphs(Value:TNumGlyphs);

begin

  FDownButton.NumGlyphs:=Value;

end;

procedure TPropSpinButton.SetFlat(const Value:Boolean);

begin

  if Value<>FFlat then

  begin

    FFlat:=Value;

    Invalidate;

  end;

end;

{TSpinProps}

procedure TSpinProps.Assign(Source:TPersistent);

begin

  if Source is TSpinProps then

  begin

    Decimal:=TSpinProps(Source).Decimal;

    EditorEnabled:=TSpinProps(Source).EditorEnabled;

    Increment:=TSpinProps(Source).Increment;

    MaxValue:=TSpinProps(Source).MaxValue;

    MinValue:=TSpinProps(Source).MinValue;

    ValueType:=TSpinProps(Source).ValueType;

  end

  else

      inherited Assign(Source);

end;

constructor TSpinProps.Create(AOwner:TObject);

begin

  inherited Create;

  FOwner:=TCellValueProp(AOwner);

  FIncrement:=1.0;

  FDecimal:=2;

  FEditorEnabled:=True;

end;

destructor TSpinProps.Destroy;

begin

  FOwner:=nil;

  if Assigned(FEditor) then FEditor:=nil;

  inherited Destroy;

end;

function TSpinProps.IsIncrementStored:Boolean;

begin

  Result:=FIncrement<>1.0;

end;

function TSpinProps.IsMaxStored:Boolean;

begin

  Result:=(MinValue<>0.0);

end;

function TSpinProps.IsMinStored:Boolean;

begin

  Result:=(MinValue<>0.0);

end;

procedure TSpinProps.SetDecimal(const Value:Byte);

begin

  if FDecimal<>Value then

  begin

    FDecimal:=Value;

    FOwner.SetPropertyValue(FOwner.PropertyValue);

    if Assigned(FEditor) then

        FEditor.Value:=FEditor.GetValue;

  end;

end;

procedure TSpinProps.SetValueType(const Value:TSpinValueType);

begin

  if FValueType<>Value then

  begin

    FValueType:=Value;

    FOwner.SetPropertyValue(FOwner.PropertyValue);

    if Assigned(FEditor) then

        FEditor.Value:=FEditor.GetValue;

    if FValueType=svtInteger then

    begin

      FIncrement:=Round(FIncrement);

      if FIncrement=0 then FIncrement:=1;

    end;

  end;

end;

end.
