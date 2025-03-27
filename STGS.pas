{ ******************************************************* }
{ }
{ Delphi Visual Component Library }
{ }
{ Copyright(c) 1995-2017 Embarcadero Technologies, Inc. }
{ All rights reserved }
{ }
{ ******************************************************* }

unit STGS;

{$R-,T-,H+,X+}
{$IFDEF CPUX64}
{$DEFINE PUREPASCAL}
{$ENDIF CPUX64}

interface

uses
{$IFNDEF MSWINDOWS}
	Winutils,
{$ENDIF}
	Winapi.Messages,
	Winapi.Windows,
	System.Sysutils,
	System.Classes,
	System.Variants,
	System.Types,
	Vcl.Graphics,
	Vcl.Menus,
	Vcl.Controls,
	Vcl.Forms,
	Vcl.Stdctrls,
	Vcl.Mask,
	System.Uitypes,
	Vcl.Buttons,
	Winapi.Uxtheme,
	Winapi.ShlObj,
	Winapi.ActiveX,
	Winapi.CommCtrl,
	System.Strutils;

const
	Maxgridsize=Maxint div 16;
	Maxshortint=high(Shortint);
{$IFNDEF CLR}
	MaxCustomExtents=Maxgridsize;
{$ENDIF}

type
	EInvalidGridOperation=class(Exception);

	{ Internal grid types }
	TGetExtentsFunc=function(Index:Longint):integer of object;

	TGridAxisDrawInfo=record
		EffectiveLineWidth:integer;
		FixedBoundary:integer;
		GridBoundary:integer;
		GridExtent:integer;
		LastFullVisibleCell:Longint;
		FullVisBoundary:integer;
		FixedCellCount:integer;
		FirstGridCell:integer;
		GridCellCount:integer;
		GetExtent:TGetExtentsFunc;
	end;

	TGridDrawInfo=record
		Horz,Vert:TGridAxisDrawInfo;
	end;

	TGridState=(GSNormal,GSSelecting,GSRowSizing,GSColSizing,GSRowMoving,GSColMoving);
	TGridMovement=GSRowMoving..GSColMoving;

	{ TInplaceEdit }
	{ The inplace editor is not intended to be used outside the grid }

	TSGCustomGrid1=class;

	TSGInplaceEdit1=class(Tcustommaskedit)
	private
		FGrid:TSGCustomGrid1;
		FClickTime:Longint;
		procedure InternalMove(const Loc:TRect;Redraw:Boolean);
		procedure SetGrid(Value:TSGCustomGrid1);
		procedure CMShowingChanged(var Message:TMessage);message Cm_showingchanged;
		procedure WMGetDlgCode(var Message:Twmgetdlgcode);message Wm_getdlgcode;
		procedure WWPaste(var Message:TMessage);message Wm_paste;
		procedure WMCut(var Message:TMessage);message Wm_cut;
		procedure WMClear(var Message:TMessage);message Wm_clear;
	protected
		procedure CreateParams(var Params:Tcreateparams);Override;
		procedure DblClick;Override;
		function DoMouseWheel(Shift:Tshiftstate;Wheeldelta:integer;Mousepos:TPoint):Boolean;Override;
		function EditCanModify:Boolean;Override;
		procedure KeyDown(var Key:Word;Shift:Tshiftstate);Override;
		procedure Keypress(var Key:Char);Override;
		procedure Keyup(var Key:Word;Shift:Tshiftstate);Override;
		procedure BoundsChanged;virtual;
		procedure UpdateContents;virtual;
		procedure WndProc(var Message:TMessage);Override;
		property Grid:TSGCustomGrid1 read FGrid;
	public
		constructor Create(Aowner:Tcomponent);Override;
		procedure Deselect;
		procedure Hide;
		procedure Invalidate;reintroduce;
		procedure Move(const Loc:TRect);
		function Posequal(const Rect:TRect):Boolean;
		procedure Setfocus;reintroduce;
		procedure Updateloc(const Loc:TRect);
		function Visible:Boolean;
		property NumbersOnly;
	end;

	{ TSGCustomGrid1 }

	{ TSGCustomGrid1 is an abstract base class that can be used to implement
		general purpose grid style controls.  The control will call DrawCell for
		each of the cells allowing the derived class to fill in the contents of
		the cell.  The base class handles scrolling, selection, cursor keys, and
		ScrollBars.
		DrawCell
		Called by Paint. If DefaultDrawing is true the font and brush are
		intialized to the control font and cell color.  The cell is prepainted
		in the cell color and a focus rect is drawn in the focused cell after
		DrawCell returns.  The state passed will reflect whether the cell is
		a fixed cell, the focused cell or in the selection.
		SizeChanged
		Called when the size of the grid has changed.
		BorderStyle
		Allows a single line border to be drawn around the control.
		Col
		The current column of the focused cell (runtime only).
		ColCount
		The number of columns in the grid.
		ColWidths
		The width of each column (up to a maximum MaxCustomExtents, runtime
		only).
		DefaultColWidth
		The default column width.  Changing this value will throw away any
		customization done either visually or through ColWidths.
		DefaultDrawing
		Indicates whether the Paint should do the drawing talked about above in
		DrawCell.
		DefaultRowHeight
		The default row height.  Changing this value will throw away any
		customization done either visually or through RowHeights.
		FixedCols
		The number of non-scrolling columns.  This value must be at least one
		below ColCount.
		FixedRows
		The number of non-scrolling rows.  This value must be at least one
		below RowCount.
		GridLineWidth
		The width of the lines drawn between the cells.
		LeftCol
		The index of the left most displayed column (runtime only).
		Options
		The following options are available:
		GoFixedHorzLine:     Draw horizontal grid lines in the fixed cell area.
		GoFixedVertLine:     Draw veritical grid lines in the fixed cell area.
		GoHorzLine:          Draw horizontal lines between cells.
		GoVertLine:          Draw vertical lines between cells.
		GoRangeSelect:       Allow a range of cells to be selected.
		GoDrawFocusSelected: Draw the focused cell in the selected color.
		GoRowSizing:         Allows rows to be individually resized.
		GoColSizing:         Allows columns to be individually resized.
		GoRowMoving:         Allows rows to be moved with the mouse
		GoColMoving:         Allows columns to be moved with the mouse.
		GoEditing:           Places an edit control over the focused cell.
		GoAlwaysShowEditor:  Always shows the editor in place instead of
		waiting for a keypress or F2 to display it.
		GoTabs:              Enables the tabbing between columns.
		GoRowSelect:         Selection and movement is done a row at a time.
		Row
		The row of the focused cell (runtime only).
		RowCount
		The number of rows in the grid.
		RowHeights
		The hieght of each row (up to a maximum MaxCustomExtents, runtime
		only).
		ScrollBars
		Determines whether the control has ScrollBars.
		Selection
		A TGridRect of the current selection.
		TopLeftChanged
		Called when the TopRow or LeftCol change.
		TopRow
		The index of the top most row displayed (runtime only)
		VisibleColCount
		The number of columns fully displayed.  There could be one more column
		partially displayed.
		VisibleRowCount
		The number of rows fully displayed.  There could be one more row
		partially displayed.

		Protected members, for implementors of TSGCustomGrid1 descendents
		DesignOptionBoost
		Options mixed in only at design time to aid design-time editing.
		Default = [GoColSizing, GoRowSizing], which makes grid cols and rows
		resizeable at design time, regardless of the Options settings.
		VirtualView
		Controls the use of maximum screen clipping optimizations when the
		grid window changes size.  Default = False, which means only the
		area exposed by the size change will be redrawn, for less flicker.
		VirtualView = True means the entire data area of the grid is redrawn
		when the size changes.  This is required when the data displayed in
		the grid is not bound to the number of rows or columns in the grid,
		such as the dbgrid (a few grid rows displaying a view onto a million
		row table).
	}

	TGridOption=(GoFixedVertLine,GoFixedHorzLine,GoVertLine,GoHorzLine,GoRangeSelect,GoDrawFocusSelected,GoRowSizing,
		GoColSizing,GoRowMoving,GoColMoving,GoEditing,GoTabs,GoRowSelect,GoAlwaysShowEditor,GoThumbTracking,GoFixedColClick,
		GoFixedRowClick,GoFixedHotTrack);
	TGridOptions=set of TGridOption;
	TGridDrawState=set of (GDSelected,GDFocused,GDFixed,GDRowSelected,GDHotTrack,GDPressed);
	TGridScrollDirection=set of (SDLeft,SDRight,SDUp,SDDown);

	TGridCoord=record
		X:Longint;
		Y:Longint;
	end;

{$IF DEFINED(CLR)}

	TGridRect=TRect;
{$ELSE}

	TGridRect=record
		case integer of
			0:(Left,Top,Right,Bottom:Longint);
			1:(TopLeft,BottomRight:TGridCoord);
	end;
{$ENDIF}

	THotTrackCellInfo=record
		Pressed:Boolean;
		Button:Tmousebutton;
		case integer of
			0:(Coord:TGridCoord); // deprecated 'Use THotTrackCellInfo.Rect field';
			1:(Rect:TGridRect);
	end;

	TEditStyle=(Essimple,Esellipsis,Espicklist);
	TGetDragImage=procedure(Sender:TObject;var shDragImage:PShDragImage) of object;
	TSelectCellEvent=procedure(Sender:TObject;ACol,ARow:Longint;var Canselect:Boolean) of object;
	TDrawCellEvent=procedure(Sender:TObject;ACol,ARow:Longint;Rect:TRect;State:TGridDrawState) of object;
	TFixedCellClickEvent=procedure(Sender:TObject;ACol,ARow:Longint) of object;
	TRowCountChange=procedure(Sender:TObject;Arowcount,Aoldrowcount:Longint) of object;
	TColCountChange=procedure(Sender:TObject;Acolcount,Aoldcolcount:Longint) of object;
	TSGInplaceEdit1Event=procedure(Sender:TObject;Inplaceedit:TSGInplaceEdit1;ACol,ARow:Longint;var CanShow:Boolean)
		of object;
	TGridDrawingStyle=(GDsClassic,GdsThemed,GdsGradient);

	TSGCustomGrid1=class(TCustomControl)
	private
		FMask:string;
		FDragImagesCount:integer;
		FAnchor:TGridCoord;
		FBorderStyle:TBorderStyle;
		FCanEditModify:Boolean;
		FColCount:Longint;
		FCurrent:TGridCoord;
		FDefaultColWidth:integer;
		FDefaultRowHeight:integer;
		FDrawingStyle:TGridDrawingStyle;
		FFixedCols:integer;
		FFixedRows:integer;
		FFixedColor:TColor;
		FGradientEndColor:TColor;
		FGradientStartColor:TColor;
		FGridLineWidth:integer;
		FOptions:TGridOptions;
		FPanPoint:TPoint;
		FRowCount:Longint;
		FScrollBars:System.Uitypes.TScrollStyle;
		FTopLeft:TGridCoord;
		FSizingIndex:Longint;
		FSizingPos,Fsizingofs:integer;
		FMoveIndex,Fmovepos:Longint;
		FHitTest:TPoint;
		FInplaceCol,FinplaceRow:Longint;
		FColOffset:integer;
		FDefaultDrawing:Boolean;
		FEditorMode:Boolean;
{$IF DEFINED(CLR)}
		FColWidths:TintegerDynArray;
		FRowHeights:TintegerDynArray;
		FTabStops:TintegerDynArray;
{$ELSE}
		FColWidths:Pointer;
		FRowHeights:Pointer;
		FTabStops:Pointer;
{$ENDIF}
		FOnFixedCellClick:TFixedCellClickEvent;
		FOnEditChange:TNotifyEvent;
		FOnGetDragImage:TGetDragImage;
		class constructor Create;
		class destructor Destroy;

		function CalCcoordFromPoint(X,Y:integer;const Drawinfo:TGridDrawInfo):TGridCoord;
		procedure CalCDrawInfoXY(var Drawinfo:TGridDrawInfo;Usewidth,Useheight:integer);
		function CalcMaxTopLeft(const Coord:TGridCoord;const Drawinfo:TGridDrawInfo):TGridCoord;
		procedure CancelMode;
		procedure ChangeSize(Newcolcount,Newrowcount:Longint);
		procedure ClampInView(const Coord:TGridCoord);
		procedure DrawSizingLine(const Drawinfo:TGridDrawInfo);
		procedure DrawMove;
		procedure GridRectToScreenRect(Gridrect:TGridRect;var Screenrect:TRect;Includeline:Boolean);
		procedure Initialize;
		procedure InvalidateRect(Arect:TGridRect);

		procedure MoveAdjust(var Cellpos:Longint;FromIndex,ToIndex:Longint);
		procedure MoveAnchor(const Newanchor:TGridCoord);
		procedure MoveAndScroll(Mouse,Cellhit:integer;var Drawinfo:TGridDrawInfo;var Axis:TGridAxisDrawInfo;
			Scrollbar:integer;const Mousept:TPoint);
		procedure MoveCurrent(ACol,ARow:Longint;MoveAnchor,Show:Boolean);
		function VisibleCol(ACol:integer):Boolean;virtual;
		procedure MoveTopLeft(Aleft,Atop:Longint);
		procedure ReSizeCol(Index:Longint;Oldsize,Newsize:integer);
		procedure ResizeRow(Index:Longint;Oldsize,Newsize:integer);
		procedure ScrollDataInfo(Dx,Dy:integer;var Drawinfo:TGridDrawInfo);
		procedure TopLeftMoved(const Oldtopleft:TGridCoord);
		procedure UpdateScrollPos;
		procedure UpdateScrollRange;
		function GetColWidths(Index:Longint):integer;
		function GetRowHeights(Index:Longint):integer;
		function GetSelection:TGridRect;
		function GetTabStops(Index:Longint):Boolean;
		function GetVisibleColCount:integer;
		function GetVisibleRowCount:integer;
		function IsActiveControl:Boolean;
		function IsGradientEndColorStored:Boolean;
		procedure ReadColWidths(Reader:Treader);
		procedure ReadRowHeights(Reader:Treader);
		procedure SetBorderStyle(Value:TBorderStyle);
		// cols
		procedure SetCol(Value:Longint);
		procedure SetColCount(Value:Longint);virtual;
		procedure SetColWidths(Index:Longint;Value:integer);
		procedure SetDefaultColWidth(Value:integer);
		procedure SetFixedCols(Value:integer);
		// rows
		procedure SetRow(Value:Longint);
		procedure SetRowCount(Value:Longint);virtual;
		procedure SetRowHeights(Index:Longint;Value:integer);
		procedure SetdefaultRowHeight(Value:integer);
		procedure SetFixedRows(Value:integer);

		procedure SetDrawingStyle(const Value:TGridDrawingStyle);
		procedure SetEditorMode(Value:Boolean);
		procedure SetFixedColor(Value:TColor);
		procedure SetGradientEndColor(Value:TColor);
		procedure SetgradientStartColor(Value:TColor);
		procedure SetGridLineWidth(Value:integer);
		procedure SetLeftCol(Value:Longint);
		procedure SetOptions(Value:TGridOptions);
		procedure SetScrollBars(Value:System.Uitypes.TScrollStyle);
		procedure SetSelection(Value:TGridRect);
		procedure SetTabStops(Index:Longint;Value:Boolean);
		procedure SetTopRow(Value:Longint);
		procedure UpdateEdit;
		procedure UpdateText;
		procedure WriteColWidths(Writer:TWriter);
		procedure WriteRowHeights(Writer:TWriter);
		procedure CMCancelMode(var Msg:TCMCancelMode);message CM_CancelMode;
		procedure CMFontChanged(var Message:TMessage);message Cm_fontchanged;
		procedure CMCtl3dChanged(var Message:TMessage);message Cm_ctl3dchanged;
		procedure CmDesignHitTest(var Msg:Tcmdesignhittest);message Cm_designhittest;
		procedure CMMouseLeave(var Message:TMessage);message Cm_mouseleave;
		procedure CMWantSpecialKey(var Msg:Tcmwantspecialkey);message Cm_wantspecialkey;
		procedure CMShowingChanged(var Message:TMessage);message Cm_showingchanged;
		procedure WMChar(var Msg:Twmchar);message Wm_char;
		procedure WMCancelMode(var Msg:Twmcancelmode);message Wm_cancelmode;
		procedure WMCommand(var Message:TWMCommand);message Wm_command;
		procedure WMGetDlgCode(var Msg:Twmgetdlgcode);message Wm_getdlgcode;
		procedure WMHScroll(var Msg:Twmhscroll);message Wm_hscroll;
		procedure WMKillFocus(var Msg:Twmkillfocus);message Wm_killfocus;
		procedure WmLButtonDown(var Message:Twmlbuttondown);message Wm_lbuttondown;
		procedure WMNChitTest(var Msg:Twmnchittest);message Wm_nchittest;
		procedure WMSetCursor(var Msg:Twmsetcursor);message Wm_setcursor;
		procedure WMSetFocus(var Msg:Twmsetfocus);message Wm_setfocus;
		procedure WMSize(var Msg:Twmsize);message Wm_size;
		procedure WMTimer(var Msg:Twmtimer);message Wm_timer;
		procedure WMVScroll(var Msg:Twmvscroll);message Wm_vscroll;
		procedure WMEraseBkgnd(var Message:Twmerasebkgnd);message Wm_erasebkgnd;
		procedure WndProc(var Message:TMessage);Override;
		procedure SetEditChange(Value:TNotifyEvent);
	public
		FInplaceEdit:TSGInplaceEdit1;
		procedure Showeditor;virtual;
	protected

		FGridState:TGridState;
		FSaveCellExtents:Boolean;
		DesignOptionsBoost:TGridOptions;
		VirtualView:Boolean;
		FInternalColor:TColor;
		FInternalDrawingStyle:TGridDrawingStyle;
		function CanObserve(const Id:integer):Boolean;Override;
		procedure ObserverAdded(const Id:integer;const Observer:Iobserver);Override;
		procedure ObserverToggle(const Aobserver:Iobserver;const Value:Boolean);
		// procedure ObserverPosChanged;
		function ObserverCurrent:Tvarrec;
		procedure CalcDrawInfo(var Drawinfo:TGridDrawInfo);
		procedure CalcFixedInfo(var Drawinfo:TGridDrawInfo);
		procedure CalcSizingState(X,Y:integer;var State:TGridState;var Index:Longint;var SizingPos,SizingOfs:integer;
			var FixedInfo:TGridDrawInfo);virtual;
		procedure ChangeGridOrientation(RightToLeftOrientation:Boolean);
		function CreateEditor:TSGInplaceEdit1;virtual;
		procedure CreateParams(var Params:Tcreateparams);Override;
		procedure CreateWND;Override;
		procedure Dogesture(const Eventinfo:TGestureEventInfo;var Handled:Boolean);Override;
		procedure KeyDown(var Key:Word;Shift:Tshiftstate);Override;
		procedure Keypress(var Key:Char);Override;
		procedure MouseDown(Button:Tmousebutton;Shift:Tshiftstate;X,Y:integer);Override;
		procedure MouseMove(Shift:Tshiftstate;X,Y:integer);Override;
		procedure MouseUp(Button:Tmousebutton;Shift:Tshiftstate;X,Y:integer);Override;
		procedure Adjustsize(Index,Amount:Longint;Rows:Boolean);reintroduce;dynamic;
		function Boxrect(Aleft,Atop,Aright,Abottom:Longint):TRect;
		procedure Doexit;Override;
		function Calcexpandedcellrect(const Coord:TGridCoord):TGridRect;virtual;
		function Cellrect(ACol,ARow:Longint):TRect;
		function Caneditacceptkey(Key:Char):Boolean;dynamic;
		function Cangridacceptkey(Key:Word;Shift:Tshiftstate):Boolean;dynamic;
		function Caneditmodify:Boolean;dynamic;
		function Caneditshow:Boolean;virtual;
		procedure Changescale(M,D:integer;Isdpichange:Boolean);Override;
		function Domousewheeldown(Shift:Tshiftstate;Mousepos:TPoint):Boolean;Override;
		function Domousewheelup(Shift:Tshiftstate;Mousepos:TPoint):Boolean;Override;
		procedure Fixedcellclick(ACol,ARow:Longint);dynamic;
		procedure Focuscell(ACol,ARow:Longint;MoveAnchor:Boolean);
		function GetEditText(ACol,ARow:Longint):string;dynamic;
		procedure SetEditText(ACol,ARow:Longint;const Value:string);dynamic;
		function Geteditlimit:integer;dynamic;
		function GetEditStyle(ACol,ARow:Longint):TEditStyle;dynamic;
		function Getgridwidth:integer;
		function Getgridheight:integer;
		procedure Hideedit;
		procedure Hideeditor;
		procedure Showeditorchar(Ch:Char);
		procedure Invalidateeditor;
		procedure Invalidategrid;inline;

		procedure Selectionmoved(const Oldsel:TGridRect);virtual;
		procedure Drawcell(ACol,ARow:Longint;Arect:TRect;AState:TGridDrawState);virtual;abstract;
		procedure Drawcellbackground(const Arect:TRect;Acolor:TColor;AState:TGridDrawState;ACol,ARow:integer);virtual;
		procedure Drawcellhighlight(const Arect:TRect;AState:TGridDrawState;ACol,ARow:integer);virtual;
		procedure DefineProperties(Filer:Tfiler);Override;
		procedure Movecolrow(ACol,ARow:Longint;MoveAnchor,Show:Boolean);
		function Selectcell(ACol,ARow:Longint):Boolean;virtual;
		procedure Sizechanged(Oldcolcount,Oldrowcount:Longint);dynamic;
		function Sizing(X,Y:integer):Boolean;
		procedure Scrolldata(Dx,Dy:integer);
		procedure Setstyleelements(const Value:Tstyleelements);Override;
		procedure Invalidatecell(ACol,ARow:Longint);
		procedure Invalidatecol(ACol:Longint);
		procedure Invalidaterow(ARow:Longint);
		function Istouchpropertystored(Aproperty:Ttouchproperty):Boolean;Override;
		procedure Topleftchanged;dynamic;
		procedure Timedscroll(Direction:TGridScrollDirection);dynamic;
		procedure Paint;Override;
		procedure Colwidthschanged;dynamic;
		procedure Rowheightschanged;dynamic;

		procedure Updatedesigner;
		function Begincolumndrag(var Origin,Destination:integer;const Mousept:TPoint):Boolean;dynamic;
		function Beginrowdrag(var Origin,Destination:integer;const Mousept:TPoint):Boolean;dynamic;
		function Checkcolumndrag(var Origin,Destination:integer;const Mousept:TPoint):Boolean;dynamic;
		function Checkrowdrag(var Origin,Destination:integer;const Mousept:TPoint):Boolean;dynamic;
		function Endcolumndrag(var Origin,Destination:integer;const Mousept:TPoint):Boolean;dynamic;
		function Endrowdrag(var Origin,Destination:integer;const Mousept:TPoint):Boolean;dynamic;
		property Borderstyle:TBorderStyle read FBorderStyle write SetBorderStyle default Bssingle;
		property Col:Longint read FCurrent.X write SetCol;
		property Color default Clwindow;
		property Colcount:Longint read FColCount write SetColCount default 5;
		property Colwidths[index:Longint]:integer read GetColWidths write SetColWidths;
		property DefaultColWidth:integer read FDefaultColWidth write SetDefaultColWidth default 64;
		property Defaultdrawing:Boolean read FDefaultDrawing write FDefaultDrawing default True;
		property DefaultRowHeight:integer read FDefaultRowHeight write SetdefaultRowHeight default 24;
		property DrawingStyle:TGridDrawingStyle read FDrawingStyle write SetDrawingStyle default GdsThemed;
		property EditorMode:Boolean read FEditorMode write SetEditorMode;
		property FixedColor:TColor read FFixedColor write SetFixedColor default Clbtnface;
		property Fixedcols:integer read FFixedCols write SetFixedCols default 1;
		property Fixedrows:integer read FFixedRows write SetFixedRows default 1;
		property GradientEndColor:TColor read FGradientEndColor write SetGradientEndColor stored IsGradientEndColorStored;
		property GradientStartColor:TColor read FGradientStartColor write SetgradientStartColor default Clwhite;
		property Gridheight:integer read Getgridheight;
		property GridLineWidth:integer read FGridLineWidth write SetGridLineWidth default 1;
		property Gridwidth:integer read Getgridwidth;
		property Hittest:TPoint read FHitTest;
		property InplaceEditor:TSGInplaceEdit1 read FInplaceEdit;
		property LeftCol:Longint read FTopLeft.X write SetLeftCol;
		property Options:TGridOptions read FOptions write SetOptions default [GoFixedVertLine,GoFixedHorzLine,GoVertLine,
			GoHorzLine,GoRangeSelect];
		property ParentColor default False;
		property Row:Longint read FCurrent.Y write SetRow;
		property RowCount:Longint read FRowCount write SetRowCount default 5;
		property Rowheights[index:Longint]:integer read GetRowHeights write SetRowHeights;
		property ScrollBars:System.Uitypes.TScrollStyle read FScrollBars write SetScrollBars default ssBoth;
		property Selection:TGridRect read GetSelection write SetSelection;
		property TabStops[index:Longint]:Boolean read GetTabStops write SetTabStops;
		property TopRow:Longint read FTopLeft.Y write SetTopRow;
		property VisibleColCount:integer read GetVisibleColCount;
		property VisibleRowCount:integer read GetVisibleRowCount;
		property OnFixedCellClick:TFixedCellClickEvent read FOnFixedCellClick write FOnFixedCellClick;
		property Mask:string read FMask write FMask;
	public
		Fhottrackcell:THotTrackCellInfo;

		constructor Create(Aowner:Tcomponent);Override;
		destructor Destroy;Override;
		procedure DrawFixedCells;
		function MouseCoord(X,Y:integer):TGridCoord;
		procedure Modifyscrollbar(Scrollbar,Scrollcode,Pos:Cardinal;Userighttoleft:Boolean);
		procedure MoveColumn(FromIndex,ToIndex:Longint);
		procedure ColumnMoved(FromIndex,ToIndex:Longint);dynamic;
		procedure MoveRow(FromIndex,ToIndex:Longint);
		procedure RowMoved(FromIndex,ToIndex:Longint);dynamic;
		procedure DeleteColumn(ACol:Longint);virtual;
		procedure DeleteRow(ARow:Longint);virtual;
	published
		property OnEditChange:TNotifyEvent read FOnEditChange write SetEditChange;
		property DragImagesCount:integer read FDragImagesCount write FDragImagesCount;
		property OnGetDragImage:TGetDragImage read FOnGetDragImage write FOnGetDragImage;
		property TabsTop default True;
	end;

	{ TCustomDrawGrid }

	{ A grid relies on the OnDrawCell event to display the cells.
		CellRect
		This method returns control relative screen coordinates of the cell or
		an empty rectangle if the cell is not visible.
		EditorMode
		Setting to true shows the editor, as if the F2 key was pressed, when
		GoEditing is turned on and GoAlwaysShowEditor is turned off.
		MouseToCell
		Takes control relative screen X, Y location and fills in the column and
		row that contain that point.
		OnColumnMoved
		Called when the user request to move a column with the mouse when
		the GoColMoving option is on.
		OnDrawCell
		This event is passed the same information as the DrawCell method
		discussed above.
		OnGetEditMask
		Called to retrieve edit mask in the inplace editor when GoEditing is
		turned on.
		OnGetEditText
		Called to retrieve text to edit when GoEditing is turned on.
		OnRowMoved
		Called when the user request to move a row with the mouse when
		the GoRowMoving option is on.
		OnSetEditText
		Called when GoEditing is turned on to reflect changes to the text
		made by the editor.
		OnTopLeftChanged
		Invoked when TopRow or LeftCol change. }

	TGetEditEvent=procedure(Sender:TObject;ACol,ARow:Longint;var Value:string) of object;
	TSetEditEvent=procedure(Sender:TObject;ACol,ARow:Longint;const Value:string) of object;
	TMovedEvent=procedure(Sender:TObject;FromIndex,ToIndex:Longint) of object;

	TSGCustomDrawGrid1=class(TSGCustomGrid1)
	private
		Foncolumnmoved:TMovedEvent;
		Fondrawcell:TDrawCellEvent;
		Fongetedittext:TGetEditEvent;
		Fonrowmoved:TMovedEvent;
		Fonselectcell:TSelectCellEvent;
		Fonsetedittext:TSetEditEvent;
		Fontopleftchanged:TNotifyEvent;
		class constructor Create;
		class destructor Destroy;
	protected
		procedure ColumnMoved(FromIndex,ToIndex:Longint);Override;
		procedure Drawcell(ACol,ARow:Longint;Arect:TRect;AState:TGridDrawState);Override;
		function GetEditText(ACol,ARow:Longint):string;Override;
		procedure RowMoved(FromIndex,ToIndex:Longint);Override;
		function Selectcell(ACol,ARow:Longint):Boolean;Override;
		procedure SetEditText(ACol,ARow:Longint;const Value:string);Override;
		procedure Topleftchanged;Override;
		property OnColumnMoved:TMovedEvent read Foncolumnmoved write Foncolumnmoved;
		property OnDrawCell:TDrawCellEvent read Fondrawcell write Fondrawcell;
		property OnGetEditText:TGetEditEvent read Fongetedittext write Fongetedittext;
		property OnRowMoved:TMovedEvent read Fonrowmoved write Fonrowmoved;
		property OnSelectCell:TSelectCellEvent read Fonselectcell write Fonselectcell;
		property OnSetEditText:TSetEditEvent read Fonsetedittext write Fonsetedittext;
		property OnTopLeftChanged:TNotifyEvent read Fontopleftchanged write Fontopleftchanged;
	public
		function Cellrect(ACol,ARow:Longint):TRect;
		procedure Mousetocell(X,Y:integer;var ACol,ARow:Longint);
		property Canvas;
		property Col;
		property Colwidths;
		property DrawingStyle;
		property EditorMode;
		property Gridheight;
		property Gridwidth;
		property LeftCol;
		property Selection;
		property Row;
		property Rowheights;
		property TabStops;
		property TopRow;
	end;

	{ TDrawGrid }

	TSGDrawGrid1=class(TSGCustomDrawGrid1)
	public
		ColButton:TSpeedButton;
	strict private
		class constructor Create;
		class destructor Destroy;
	published
		property Align;
		property Anchors;
		property Beveledges;
		property Bevelinner;
		property Bevelkind;
		property Bevelouter;
		property Bevelwidth;
		property Bidimode;
		property Borderstyle;
		property Color;
		property Colcount;
		property Constraints;
		property Ctl3d;
		property DefaultColWidth;
		property DefaultRowHeight;
		property Defaultdrawing;
		property DoubleBuffered;
		property DragCursor;
		property DragKind;
		property DragMode;
		property DrawingStyle;
		property Enabled;
		property FixedColor;
		property Fixedcols;
		property RowCount;
		property Fixedrows;
		property Font;
		property GradientEndColor;
		property GradientStartColor;
		property GridLineWidth;
		property Options;
		property ParentBidimode;
		property ParentColor;
		property ParentCtl3d;
		property ParentDoubleBuffered;
		property ParentFont;
		property ParentShowHint;
		property PopupMenu;
		property ScrollBars;
		property ShowHint;
		property TabOrder;
		property Touch;
		property Visible;
		property StyleElements;
		property VisibleColCount;
		property VisibleRowCount;
		property Mask;
		property Onclick;
		property OnColumnMoved;
		property OnContextPopup;
		property OnDblclick;
		property OnDragDrop;
		property OnDragOver;
		property OnDrawCell;
		property OnEndDock;
		property OnEndDrag;
		property OnEnter;
		property OnExit;
		property OnFixedCellClick;
		property OnGesture;
		property OnGetEditText;
		property OnKeyDown;
		property OnKeyPress;
		property OnKeyUp;
		property OnMouseActivate;
		property OnMouseDown;
		property OnMouseEnter;
		property OnMouseLeave;
		property OnMouseMove;
		property OnMouseUp;
		property OnMouseWheelDown;
		property OnMouseWheelUp;
		property OnRowMoved;
		property OnSelectCell;
		property OnSetEditText;
		property OnStartDock;
		property OnStartDrag;
		property OnTopLeftChanged;
	end;

	{ TStringGrid }

	{ TStringGrid adds to TDrawGrid the ability to save a string and associated
		object (much like TListBox).  It also adds to the DefaultDrawing the drawing
		of the string associated with the current cell.
		Cells
		A ColCount by RowCount array of strings which are associated with each
		cell.  By default, the string is drawn into the cell before OnDrawCell
		is called.  This can be turned off (along with all the other default
		drawing) by setting DefaultDrawing to false.
		Cols
		A TStrings object that contains the strings and objects in the column
		indicated by Index.  The TStrings will always have a count of RowCount.
		If a another TStrings is assigned to it, the strings and objects beyond
		RowCount are ignored.
		Objects
		A ColCount by Rowcount array of TObject's associated with each cell.
		Object put into this array will *not* be destroyed automatically when
		the grid is destroyed.
		Rows
		A TStrings object that contains the strings and objects in the row
		indicated by Index.  The TStrings will always have a count of ColCount.
		If a another TStrings is assigned to it, the strings and objects beyond
		ColCount are ignored. }

	TSJ=class;
	TSG=class;

	{ Exception classes }

{$IF DEFINED(CLR)}

	TStrItem=class
		FObject:TObject;
		FString:string;
	end;

	TStrItemType=TStrItem;
{$ELSE}
	PStrItem=^TStrItem;

	TStrItem=record
		FObject:TObject;
		FString:string;
	end;

	TStrItemType=PStrItem;

	PQr=^TQR;

	TQR=record
		FColor:TColor;
		FObj:TObject;
		FArr:set of Byte;

		Cinfo: record
			CUL,CMH,CCL,REF,TY,KL,TRM,TRMC,LG,EQ,DFT:string;
			NU,WCH,WCH1,AUT,VIS,ENB:Boolean;
			KI,KN,KA,CN,CCB,SCB,CW:integer;
		end;
	end;

{$ENDIF}

	Estringsparselisterror=class(Exception);

	{ TSparsePointeAarray class }

{$IF DEFINED(CLR)}
	{ Used by TSparseList.  Based on Sparse1Array, but has Object elements
		and Integer index, and less indirection }

	{ Apply function for the applicator:
		TheIndex        Index of item in array
		TheItem         Value of item (i.e object) in section
		Returns: 0 if success, else error code. }
	Tspaapply=function(Theindex:integer;Theitem:TObject):integer;

	Tsectdata=array of TObject;
	Tsecdir=array of Tsectdata;
	TSecDirType=Tsecdir;
{$ELSE}
	{ Used by TSparseList.  Based on Sparse1Array, but has Pointer elements
		and Integer index, just like TPointerList/TList, and less indirection }

	{ Apply function for the applicator:
		TheIndex        Index of item in array
		TheItem         Value of item (i.e pointer element) in section
		Returns: 0 if success, else error code. }
	Tspaapply=Tfunc<integer,Pointer,integer>;

	Tsecdir=array [0..4095] of Pointer; { Enough for up to 12 bits of sec }
	Psecdir=^Tsecdir;
	TSecDirType=Psecdir;
{$ENDIF}
	TSpaQuantum=(Spasmall,Spalarge); { Section size }

	TGRAMD=class(TObject)
	private
		FGrid:TSJ;
		FIndex:integer;
		FTag:integer;
		FQr:PQr;
	public
		constructor Create(Agrid:TSJ;Aindex:Longint);overload;
		destructor Destroy;Override;
		property Tag:integer read FTag write FTag;
		property Outr:PQr read FQr write FQr;
	end;

	TStringGridStrings=class(TStrings)
	private
		FGrid:TSG;
		FIndex:integer;
		FTag:Byte;
		FRFC:Byte;
		FST:Byte;
		FNUM:integer;
		procedure Calcxy(Index:integer;var X,Y:integer);
{$IF DEFINED(CLR)}
		function Blankstr(Theindex:integer;Theitem:TObject):integer;
{$ENDIF}
	protected
		function Get(Index:integer):string;Override;
		function GetCount:integer;Override;
		function GetObject(Index:integer):TObject;Override;
		procedure Put(Index:integer;const S:string);Override;
		procedure PutObject(Index:integer;Aobject:TObject);Override;
		procedure SetUpdateState(Updating:Boolean);Override;
	public
		constructor Create(Agrid:TSG;Aindex:Longint);
		destructor Destroy;Override;
		function Add(const S:string):integer;Override;
		procedure Assign(Source:Tpersistent);Override;
		procedure Clear;Override;
		procedure Delete(Index:integer);Override;
		procedure Insert(Index:integer;const S:string);Override;
		property Tag:Byte read FTag write FTag default 0;
		property RFC:Byte read FRFC write FRFC default 0;
		property ST:Byte read FST write FST default 0;
		property NUM:integer read FNUM write FNUM default 0;
	end;

	TSparsePointeAarray=class(TObject)
	private
		Secdir:TSecDirType;
		Slotsindir:Cardinal;
		Indexmask,SecShift:Word;
		Fhighbound:integer;
		Fsectionsize:Word;
		Cachedindex:integer;
		Cachedvalue:TCustomData;
{$IF DEFINED(CLR)}
		FTemp:integer; { temporary value storage }
{$ENDIF}
		{ Return item[i], nil if slot outside defined section. }
		function GetAt(Index:integer):TCustomData;
		{ Store item at item[i], creating slot if necessary. }
		procedure PutAt(Index:integer;Item:TCustomData);
{$IF DEFINED(CLR)}
		{ callback that is passed to ForAll }
		function Detector(Theindex:integer;Theitem:TObject):integer;
{$ELSE}
		{ Return address of item[i], creating slot if necessary. }
		function MakeAt(Index:integer):Ppointer;
{$ENDIF}
	public
		constructor Create(Quantum:TSpaQuantum);
		destructor Destroy;Override;

		{ Traverse SPA, calling apply function for each defined non-nil
			item.  The traversal terminates if the apply function returns
			a value other than 0. }

{$IF DEFINED(CLR)}
		// .NET: Must be a class member to have access to other class members
		function ForAll(Applyfunction:Tspaapply):integer;
{$ELSE}
		// WIN32: Must be static method so that we can take its address in TSparseList.ForAll
		function ForAll(Applyfunction:Tspaapply):integer;
{$ENDIF}
		{ Ratchet down HighBound after a deletion }
		procedure Resethighbound;

		property HighBound:integer read Fhighbound;
		property SectionSize:Word read Fsectionsize;
		property Items[index:integer]:TCustomData read GetAt write PutAt;default;
	end;

	{ TSparseList class }

	TSparseList=class(TObject)
	private
		Flist:TSparsePointeAarray;
		Fcount:integer; { 1 + HighBound, adjusted for Insert/Delete }
		Fquantum:TSpaQuantum;
		procedure Newlist(Quantum:TSpaQuantum);
	protected
		function Get(Index:integer):TCustomData;
		procedure Put(Index:integer;Item:TCustomData);
	public
		constructor Create(Quantum:TSpaQuantum);
		destructor Destroy;Override;
		procedure Clear;
		procedure Delete(Index:integer);
		procedure Exchange(Index1,Index2:integer);
		procedure Insert(Index:integer;Item:TCustomData);
		procedure Move(Curindex,Newindex:integer);
{$IF DEFINED(CLR)}
		function ForAll(Applyfunction:Tspaapply):integer;
{$ELSE}
		function ForAll(Applyfunction:Tspaapply):integer;
{$ENDIF}
		property Count:integer read Fcount;
		property Items[index:integer]:TCustomData read Get write Put;default;
	end;

	{ TStringSparseList class }

	TStringSparseList=class(TStrings)
	private
		Flist:TSparseList; // of StrItems
		Fonchange:TNotifyEvent;
{$IF DEFINED(CLR)}
		Ftempint:integer; // used during callbacks
		Ftempobject:TObject; // used during callbacks
{$ENDIF}
	protected
		// TStrings overrides
		function Get(Index:integer):string;Override;
		function GetCount:integer;Override;
		function GetObject(Index:integer):TObject;Override;
		procedure Put(Index:integer;const S:string);Override;
		procedure PutObject(Index:integer;Aobject:TObject);Override;
		procedure Changed;
{$IF DEFINED(CLR)}
		// callbacks to pass to ForAll
		function CountItem(Theindex:integer;Theitem:TObject):integer;
		function StoreItem(Theindex:integer;Theitem:TObject):integer;
{$ENDIF}
	public
		constructor Create(Quantum:TSpaQuantum);
		destructor Destroy;Override;
		procedure ReadData(Reader:Treader);
		procedure WriteData(Writer:TWriter);
		procedure DefineProperties(Filer:Tfiler);Override;
		procedure Delete(Index:integer);Override;
		procedure Exchange(Index1,Index2:integer);Override;
		procedure Insert(Index:integer;const S:string);Override;
		procedure Clear;Override;
		property List:TSparseList read Flist;
		property OnChange:TNotifyEvent read Fonchange write Fonchange;
	end;

	TEnumString=class(TInterfacedObject,IEnumString)
	private
		FStrings:TStrings;
		FCurrIndex:integer;
	public
		function Next(Celt:Longint;out Elt;PCeltfetched:PLongint):HResult;stdcall;
		function Skip(Celt:Longint):HResult;stdcall;
		function Reset:HResult;stdcall;
		function Clone(out Enm:IEnumString):HResult;stdcall;
		constructor Create(AStrings:TStrings;Aindex:integer=0);
	end;

	TAutoC=class(Tcomponent)
	private
		FAutoComplete:IAutoComplete;
		FAutoComplete2:IAutoComplete2;
		FAutoCompleteDropDown:IAutoCompleteDropDown;
		FObjMgr:IObjMgr;
		FEnum:TEnumString;
		Fflug:Cardinal;
		FHWND:HWND;
		FRTL:Boolean;
		FSearch:Boolean;
		FStrings:TStrings;
		procedure SetRTL(Value:Boolean);
		procedure SetSearch(Value:Boolean);
		procedure SetStrings(Value:TStrings);
	public
		constructor Create(Aowner:Tcomponent);Override;
		destructor Destroy;Override;

		property RTL:Boolean read FRTL write SetRTL;
		property Search:Boolean read FSearch write SetSearch;
		property Strings:TStrings read FStrings write SetStrings;
		property AutoCompleteDropDown:IAutoCompleteDropDown read FAutoCompleteDropDown;
	end;

	TGetEditStyleEvent=procedure(TSender:TObject;ACol,ARow:integer;var EditStyle:TEditStyle) of object;
	TOnGetPicklistItems=procedure(ACol,ARow:integer;Items:TStrings) of object;
	TCellTextSet=procedure(Sender:TObject;ACol,ARow:Longint;Value:string) of object;
	TCellTextGet=procedure(Sender:TObject;ACol,ARow:Longint;var Value:string) of object;
	TDrawCell=procedure(Sender:TObject;ACol,ARow:Longint;Canvas:TCanvas;Arect:TRect;AState:TGridDrawState;
		var Value:string) of object;

	TSJ=class(TSGDrawGrid1)
	strict private
		class constructor Create;
		class destructor Destroy;
	private
		Flist:TList;
		FInplaceEditEvent:TSGInplaceEdit1Event;
		FIsCH:Boolean;
		FIsGT:Boolean;
		FIsDR:Boolean;
		FIsON:Boolean;
		FGrect:TGridRect;
		FChks:Boolean;
		FOnCellTextSet:TCellTextSet;
		FOnCellTextGet:TCellTextGet;
		Fondrawcell:TDrawCell;
		FDropDownRowCount:integer;
		FOnEditButtonClick1:TNotifyEvent;
		FOnGetEditStyle:TGetEditStyleEvent;
		FOnGetPicklistItems:TOnGetPicklistItems;
		FUpdating:Boolean;
		FNeedsUpdating:Boolean;
		FEditUpdate:integer;
		FData:TCustomData;
		FRows:TCustomData;
		FCols:TCustomData;
		FFxalgn:TAlignment;
		FAlgn:TAlignment;
		FOdd:Boolean;
		FOddc:TColor;
		FFxFont:TFont;
		SFxFont:TFont;
{$IF DEFINED(CLR)}
		FTempFrom:integer;
		FTempTo:integer;
{$ENDIF}
		FOnRowCountChange:TRowCountChange;
		FOnColCountChange:TColCountChange;
		procedure DisableEditUpdate;
		procedure EnableEditUpdate;
		procedure SetFXFont(Value:TFont);
		procedure SetSXFont(Value:TFont);
		procedure SetAllOn(Value:Boolean);
		procedure Initialize;
		procedure Update(ACol,ARow:integer);reintroduce;
		procedure SetUpdateState(Updating:Boolean);
		function GetCells(ACol,ARow:integer):string;
		procedure SetCells(ACol,ARow:integer;Value:string);
		function GetCols(Index:integer):TGRAMD;
		procedure SetCols(Index:integer;Value:TGRAMD);
		function Prepare(Index:integer):TGRAMD;
		procedure SetDropDownRowCount(Value:integer);
		procedure SetOnEditButtonClick(Value:TNotifyEvent);

		procedure SetOnGetPicklistItems(Value:TOnGetPicklistItems);
		procedure SetColCount(Value:Longint);Override;
		procedure SetRowCount(Value:Longint);Override;
		function VisibleCol(ACol:integer):Boolean;Override;
	protected
		procedure ColumnMoved(FromIndex,ToIndex:Longint);Override;
		procedure Drawcell(ACol,ARow:Longint;Arect:TRect;AState:TGridDrawState);Override;
		function GetEditText(ACol,ARow:Longint):string;Override;
		procedure SetEditText(ACol,ARow:Longint;const Value:string);Override;
		procedure RowMoved(FromIndex,ToIndex:Longint);Override;
		function CreateEditor:TSGInplaceEdit1;Override;
		function GetEditStyle(ACol,ARow:integer):TEditStyle;Override;
{$IF DEFINED(CLR)}
		function MoveColData(Index:integer;ARow:TObject):integer;
{$ENDIF}
	public
		AutoC:TAutoC;
		constructor Create(Aowner:Tcomponent);Override;
		destructor Destroy;Override;
		procedure Repaint;Override;
		procedure Showeditor;Override;
		property Cells[ACol,ARow:integer]:string read GetCells write SetCells;
		property Cols[index:integer]:TGRAMD read GetCols write SetCols;
		property GRect:TGridRect read FGrect write FGrect;
	published
		property DropDownRowCount:integer read FDropDownRowCount write SetDropDownRowCount default 8;
		property OnEditButtonClick:TNotifyEvent read FOnEditButtonClick1 write SetOnEditButtonClick;

		property OnGetEditStyle:TGetEditStyleEvent read FOnGetEditStyle write FOnGetEditStyle;
		property OnGetPicklistItems:TOnGetPicklistItems read FOnGetPicklistItems write SetOnGetPicklistItems;
		property FixedCellsAlignment:TAlignment read FFxalgn write FFxalgn default Tacenter;
		property CellsAlignment:TAlignment read FAlgn write FAlgn default Tacenter;
		property RankOdd:Boolean read FOdd write FOdd default False;
		property RankColor:TColor read FOddc write FOddc default Clgradientinactivecaption;
		property OnCellTextSet:TCellTextSet read FOnCellTextSet write FOnCellTextSet;
		property OnCellTextGet:TCellTextGet read FOnCellTextGet write FOnCellTextGet;
		property OnDrawCell:TDrawCell read Fondrawcell write Fondrawcell;
		property OnRowCountChange:TRowCountChange read FOnRowCountChange write FOnRowCountChange;
		property OnColCountChange:TColCountChange read FOnColCountChange write FOnColCountChange;
		property OnShowInplaceEdit:TSGInplaceEdit1Event read FInplaceEditEvent write FInplaceEditEvent;
		property FixedCellsFont:TFont read FFxFont write SetFXFont;
		property FixedCellsSelectedFont:TFont read SFxFont write SetSXFont;
		property EditorMode default False;
		property EnableCheckBoxes:Boolean read FChks write FChks default False;
		property EnableOnChanges:Boolean read FIsCH write FIsCH default False;
		property EnableOnGetCell:Boolean read FIsGT write FIsGT default True;
		property EnableOnDrawCell:Boolean read FIsDR write FIsDR default False;
		property EnableAllOn:Boolean read FIsON write SetAllOn default False;
	end;

	{ TSG }
	TCellTextChange=procedure(Sender:TObject;ACol,ARow:Longint;Value:string) of object;

	TSG=class(TSGDrawGrid1)
	public
		ColButton:TSpeedButton;
	strict private
		class constructor Create;
		class destructor Destroy;
	private
		FGrect:TGridRect;
		FChks:Boolean;
		FOnCellTextChange:TCellTextChange;
		FDropDownRowCount:integer;
		FOnEditButtonClick1:TNotifyEvent;
		FOnGetEditStyle:TGetEditStyleEvent;
		FOnGetPicklistItems:TOnGetPicklistItems;
		FUpdating:Boolean;
		FNeedsUpdating:Boolean;
		FEditUpdate:integer;
		FData:TCustomData;
		FRows:TCustomData;
		FCols:TCustomData;
		FFxalgn:TAlignment;
		FAlgn:TAlignment;
		FOdd:Boolean;
		FOddc:TColor;
		FFxFont:TFont;
		FCURSOR:TCursor;
{$IF DEFINED(CLR)}
		FTempFrom:integer;
		FTempTo:integer;
{$ENDIF}
		procedure DisableEditUpdate;
		procedure EnableEditUpdate;
		procedure SetFont(Value:TFont);
		procedure Initialize;
		procedure Update(ACol,ARow:integer);reintroduce;
		procedure SetUpdateState(Updating:Boolean);
		function GetCells(ACol,ARow:integer):string;
		function GetCols(Index:integer):TStringGridStrings;
		function GetObjects(ACol,ARow:integer):TObject;
		function GetRows(Index:integer):TStringGridStrings;
		procedure SetCells(ACol,ARow:integer;Value:string);
		procedure SetCols(Index:integer;Value:TStringGridStrings);
		procedure SetObjects(ACol,ARow:integer;Value:TObject);
		procedure SetRows(Index:integer;Value:TStringGridStrings);
		function EnsureColRow(Index:integer;IsCol:Boolean):TStringGridStrings;
		function EnsureDataRow(ARow:integer):TCustomData;
		procedure SetDropDownRowCount(Value:integer);
		procedure SetOnEditButtonClick(Value:TNotifyEvent);
		procedure SetOnGetPicklistItems(Value:TOnGetPicklistItems);

	protected
		procedure ColumnMoved(FromIndex,ToIndex:Longint);Override;
		procedure Drawcell(ACol,ARow:Longint;Arect:TRect;AState:TGridDrawState);Override;
		function GetEditText(ACol,ARow:Longint):string;Override;
		procedure SetEditText(ACol,ARow:Longint;const Value:string);Override;
		procedure RowMoved(FromIndex,ToIndex:Longint);Override;
		function CreateEditor:TSGInplaceEdit1;Override;
		function GetEditStyle(ACol,ARow:integer):TEditStyle;Override;
{$IF DEFINED(CLR)}
		function MoveColData(Index:integer;ARow:TObject):integer;
{$ENDIF}
	public
		constructor Create(Aowner:Tcomponent);Override;
		constructor CreateedView(Aowner:Tcomponent;AL:integer=0);overload;
		destructor Destroy;Override;
		procedure Repaint;Override;
		property Cells[ACol,ARow:integer]:string read GetCells write SetCells;
		property Cols[index:integer]:TStringGridStrings read GetCols write SetCols;
		property Objects[ACol,ARow:integer]:TObject read GetObjects write SetObjects;
		property Rows[index:integer]:TStringGridStrings read GetRows write SetRows;
		property GRect:TGridRect read FGrect write FGrect;
	published
		property EnableCheckBoxes:Boolean read FChks write FChks default False;
		property DropDownRowCount:integer read FDropDownRowCount write SetDropDownRowCount default 8;
		property OnEditButtonClick:TNotifyEvent read FOnEditButtonClick1 write SetOnEditButtonClick;
		property OnGetEditStyle:TGetEditStyleEvent read FOnGetEditStyle write FOnGetEditStyle;
		property OnGetPicklistItems:TOnGetPicklistItems read FOnGetPicklistItems write SetOnGetPicklistItems;
		property FixedCellsAlignment:TAlignment read FFxalgn write FFxalgn default Tacenter;
		property CellsAlignment:TAlignment read FAlgn write FAlgn default Tacenter;
		property RankOdd:Boolean read FOdd write FOdd default False;
		property RankColor:TColor read FOddc write FOddc default Clgradientinactivecaption;
		property OnCellTextchange:TCellTextChange read FOnCellTextChange write FOnCellTextChange;
		property FixedCellsFont:TFont read FFxFont write SetFont;
		property EditorMode default False;
		property SGCURSOR:TCursor read FCURSOR;
	end;

	{ TSGInplaceEdit1List }

	{ TSGInplaceEdit1List adds to TSGInplaceEdit1 the ability to drop down a pick list
		of possible values or to display an ellipsis button which will invoke
		user code in an event to bring up a modal dialog.  The EditStyle property
		determines which type of button to draw (if any)
		ActiveList
		TWincontrol reference which typically points to the internal
		PickList.  May be set to a different list by descendent inplace
		editors which provide additional functionality.
		ButtonWidth
		The width of the button used to drop down the pick list.
		DropdownRows
		The maximum number of rows to display at a time in the pick list.
		EditStyle
		Indicates what type of list to display (none, custom, or picklist).
		ListVisible
		Indicates if the list is currently dropped down.
		PickList
		Reference to the internal PickList (a TCustomListBox).
		Pressed
		Indicates if the button is currently pressed. }

	TSGInplaceEdit1List1=class(TSGInplaceEdit1)
	private
		Fbuttonwidth:integer;
		Fpicklist:TCustomListBox;
		Factivelist:TWincontrol;
		Feditstyle:TEditStyle;
		Fdropdownrows:integer;
		Flistvisible:Boolean;
		Ftracking:Boolean;
		Fpressed:Boolean;
		Fpicklistloaded:Boolean;
		FOnGetPicklistItems:TOnGetPicklistItems;
		Foneditbuttonclick:TNotifyEvent;
		Fmouseincontrol:Boolean;
		function Getpicklist:TCustomListBox;
		procedure CMCancelMode(var Message:TCMCancelMode);message CM_CancelMode;
		procedure WMCancelMode(var Message:Twmcancelmode);message Wm_cancelmode;
		procedure WMKillFocus(var Message:Twmkillfocus);message Wm_killfocus;
		procedure WMLButtonDblClk(var Message:Twmlbuttondblclk);message Wm_lbuttondblclk;
		procedure WMPaint(var Message:Twmpaint);message Wm_paint;
		procedure WMSetCursor(var Message:Twmsetcursor);message Wm_setcursor;
		procedure CMMouseEnter(var Message:TMessage);message Cm_mouseenter;
		procedure CMMouseLeave(var Message:TMessage);message Cm_mouseleave;
	protected
		procedure BoundsChanged;Override;
		function ButtonRect:TRect;
		procedure Closeup(Accept:Boolean);dynamic;
		procedure DblClick;Override;
		procedure DoDropDownKeys(var Key:Word;Shift:Tshiftstate);virtual;
		procedure DoEditButtonClick;virtual;
		procedure DoGetPicklistItems;dynamic;
		procedure DropDown;dynamic;
		procedure KeyDown(var Key:Word;Shift:Tshiftstate);Override;
		procedure ListMouseUp(Sender:TObject;Button:Tmousebutton;Shift:Tshiftstate;X,Y:integer);
		procedure MouseDown(Button:Tmousebutton;Shift:Tshiftstate;X,Y:integer);Override;
		procedure MouseMove(Shift:Tshiftstate;X,Y:integer);Override;
		procedure MouseUp(Button:Tmousebutton;Shift:Tshiftstate;X,Y:integer);Override;
		function OverButton(const P:TPoint):Boolean;
		procedure PaintWindow(Dc:Hdc);Override;
		procedure StopTracking;
		procedure TrackButton(X,Y:integer);
		procedure UpdateContents;Override;
		procedure WndProc(var Message:TMessage);Override;
	public
		constructor Create(Owner:Tcomponent);Override;
		procedure RestoreContents;
		property ActiveList:TWincontrol read Factivelist write Factivelist;
		property ButtonWidth:integer read Fbuttonwidth write Fbuttonwidth;
		property DropdownRows:integer read Fdropdownrows write Fdropdownrows;
		property EditStyle:TEditStyle read Feditstyle;
		property ListVisible:Boolean read Flistvisible write Flistvisible;
		property Picklist:TCustomListBox read Getpicklist;
		property PicklistLoaded:Boolean read Fpicklistloaded write Fpicklistloaded;
		property Pressed:Boolean read Fpressed;
		property OnEditButtonClick:TNotifyEvent read Foneditbuttonclick write Foneditbuttonclick;
		property OnGetPicklistItems:TOnGetPicklistItems read FOnGetPicklistItems write FOnGetPicklistItems;
	end;

procedure Register;

const
	EmptyThings:set of Byte=[];

implementation

uses
{$IF DEFINED(CLR)}
	System.Runtime.Interopservices,
	System.Security.Permissions,
{$ENDIF}
	System.Math,
	Vcl.Themes,
	System.Rtlconsts,
	System.DateUtils,
	Vcl.Consts,
	Vcl.Dialogs,
	System.Win.ComObj,
	Vcl.Graphutil;

{$IF NOT DEFINED(CLR)}

type
	PintArray=^TintArray;
	TintArray=array [0..MaxCustomExtents] of integer;
{$ENDIF}

const
	Emptyrect:TGridRect=(Left:-1;Top:-1;Right:-1;Bottom:-1);

procedure Register;
begin
	RegisterComponents('AMD SG',[TSG,TSJ,TSGDrawGrid1]);
end;

procedure Invalidop(const Id:string);
begin
	raise EInvalidGridOperation.Create(Id);
end;

function Gridrect(Coord1,Coord2:TGridCoord):TGridRect;
begin
	with Result do begin
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

function Pointingridrect(Col,Row:Longint;const Rect:TGridRect):Boolean;
begin
	Result:=(Col>=Rect.Left)and(Col<=Rect.Right)and(Row>=Rect.Top)and(Row<=Rect.Bottom);
end;

type
	Txorrects=array [0..3] of TRect;

procedure XorRects(const R1,R2:TRect;var XorRects:Txorrects);
var
	Intersect,Union:TRect;

	function PTinRect(X,Y:integer;const Rect:TRect):Boolean;
	begin
		with Rect do Result:=(X>=Left)and(X<=Right)and(Y>=Top)and(Y<=Bottom);
	end;

{$IF DEFINED(CLR)}
	function Includes(const P1:TPoint;P2:TPoint):Boolean;
	begin
		with P1 do Result:=PTinRect(X,Y,R1)or PTinRect(X,Y,R2);
	end;
{$ELSE}
	function Includes(const P1:TPoint;var P2:TPoint):Boolean;
	begin
		with P1 do begin
			Result:=PTinRect(X,Y,R1)or PTinRect(X,Y,R2);
			if Result then P2:=P1;
		end;
	end;
{$ENDIF}
{$IF DEFINED(CLR)}
	function Build(var R:TRect;const P1,P2,P3:TPoint):Boolean;
	begin
		Build:=True;
		with R do
			if Includes(P1,R.TopLeft) then begin
				Left:=P1.X;
				Top:=P1.Y;
				if Includes(P3,R.BottomRight) then begin
					Right:=P3.X;
					Bottom:=P3.Y;
				end else begin
					Right:=P2.X;
					Bottom:=P2.Y;
				end
			end else if Includes(P2,R.TopLeft) then begin
				Left:=P2.X;
				Top:=P2.Y;
				Bottom:=P3.Y;
				Right:=P3.X;
			end
			else Build:=False;
	end;
{$ELSE}
	function Build(var R:TRect;const P1,P2,P3:TPoint):Boolean;
	begin
		Build:=True;
		with R do
			if Includes(P1,TopLeft) then begin
				if not Includes(P3,BottomRight) then BottomRight:=P2;
			end else if Includes(P2,TopLeft) then BottomRight:=P3
			else Build:=False;
	end;
{$ENDIF}

begin
{$IF NOT DEFINED(CLR)}
	Fillchar(XorRects,Sizeof(XorRects),0);
{$ENDIF}
	if not Intersectrect(Intersect,R1,R2) then begin
		{ Don't intersect so its simple }
		XorRects[0]:=R1;
		XorRects[1]:=R2;
	end else begin
		Unionrect(Union,R1,R2);
		if Build(XorRects[0],Point(Union.Left,Union.Top),Point(Union.Left,Intersect.Top),Point(Union.Left,Intersect.Bottom))
		then XorRects[0].Right:=Intersect.Left;
		if Build(XorRects[1],Point(Intersect.Left,Union.Top),Point(Intersect.Right,Union.Top),Point(Union.Right,Union.Top))
		then XorRects[1].Bottom:=Intersect.Top;
		if Build(XorRects[2],Point(Union.Right,Intersect.Top),Point(Union.Right,Intersect.Bottom),
			Point(Union.Right,Union.Bottom)) then XorRects[2].Left:=Intersect.Right;
		if Build(XorRects[3],Point(Union.Left,Union.Bottom),Point(Intersect.Left,Union.Bottom),
			Point(Intersect.Right,Union.Bottom)) then XorRects[3].Top:=Intersect.Bottom;
	end;
end;

{$IF DEFINED(CLR)}

procedure Modifyextents(var Extents:TintegerDynArray;Index,Amount:Longint;
{$ELSE}
procedure Modifyextents(var Extents:Pointer;Index,Amount:Longint;
{$ENDIF}
	Default:integer);
var
	Longsize,Oldsize:Longint;
	Newsize:integer;
	I:integer;
begin
	if Amount<>0 then begin
{$IF DEFINED(CLR)}
		if Length(Extents)=0 then Oldsize:=0
		else Oldsize:=Extents[0];
{$ELSE}
		if not Assigned(Extents) then Oldsize:=0
		else Oldsize:=PintArray(Extents)^[0];
{$ENDIF}
		if (index<0)or(Oldsize<index) then Invalidop(Sindexoutofrange);
		Longsize:=Oldsize+Amount;
		if Longsize<0 then Invalidop(Stoomanydeleted)
		else if Longsize>=Maxgridsize-1 then Invalidop(Sgridtoolarge);
		Newsize:=Cardinal(Longsize);
		if Newsize>0 then Inc(Newsize);
{$IF DEFINED(CLR)}
		Setlength(Extents,Newsize);
		if Length(Extents)<>0 then
{$ELSE}
		Reallocmem(Extents,Newsize*Sizeof(integer));
		if Assigned(Extents) then
{$ENDIF}
		begin
			I:=index+1;
			while I<Newsize do
{$IF DEFINED(CLR)}
			begin
				Extents[I]:=default;
				Inc(I);
			end;
			Extents[0]:=Newsize-1;
{$ELSE}
			begin
				PintArray(Extents)^[I]:=default;
				Inc(I);
			end;
			PintArray(Extents)^[0]:=Newsize-1;
{$ENDIF}
		end;
	end;
end;

{$IF DEFINED(CLR)}

procedure UpdateExtents(var Extents:TintegerDynArray;Newsize:Longint;Default:integer);
{$ELSE}

procedure UpdateExtents(var Extents:Pointer;Newsize:Longint;Default:integer);
{$ENDIF}
var
	Oldsize:integer;
begin
	Oldsize:=0;
{$IF DEFINED(CLR)}
	if Length(Extents)<>0 then Oldsize:=Extents[0];
{$ELSE}
	if Assigned(Extents) then Oldsize:=PintArray(Extents)^[0];
{$ENDIF}
	Modifyextents(Extents,Oldsize,Newsize-Oldsize,default);
end;

{$IF DEFINED(CLR)}

procedure MoveExtent(var Extents:TintegerDynArray;FromIndex,ToIndex:Longint);
var
	Extent,I:integer;
begin
	if Length(Extents)<>0 then begin
		Extent:=Extents[FromIndex];
		if FromIndex<ToIndex then
			for I:=FromIndex+1 to ToIndex do Extents[I-1]:=Extents[I]
		else if FromIndex>ToIndex then
			for I:=FromIndex-1 downto ToIndex do Extents[I+1]:=Extents[I];
		Extents[ToIndex]:=Extent;
	end;
end;
{$ELSE}

procedure MoveExtent(var Extents:Pointer;FromIndex,ToIndex:Longint);
var
	Extent:integer;
begin
	if Assigned(Extents) then begin
		Extent:=PintArray(Extents)^[FromIndex];
		if FromIndex<ToIndex then
				Move(PintArray(Extents)^[FromIndex+1],PintArray(Extents)^[FromIndex],(ToIndex-FromIndex)*Sizeof(integer))
		else if FromIndex>ToIndex then
				Move(PintArray(Extents)^[ToIndex],PintArray(Extents)^[ToIndex+1],(FromIndex-ToIndex)*Sizeof(integer));
		PintArray(Extents)^[ToIndex]:=Extent;
	end;
end;
{$ENDIF}
{$IF DEFINED(CLR)}

function CompareExtents(E1,E2:TintegerDynArray):Boolean;
var
	I:integer;
begin
	Result:=False;
	if Length(E1)<>0 then begin
		if Length(E2)<>0 then begin
			for I:=0 to E1[0] do
				if E1[I]<>E2[I] then Exit;
			Result:=True;
		end
	end
	else Result:=Length(E2)=0;
end;
{$ELSE}

function CompareExtents(E1,E2:Pointer):Boolean;
var
	I:integer;
begin
	Result:=False;
	if E1<>nil then begin
		if E2<>nil then begin
			for I:=0 to PintArray(E1)^[0] do
				if PintArray(E1)^[I]<>PintArray(E2)^[I] then Exit;
			Result:=True;
		end
	end
	else Result:=E2=nil;
end;
{$ENDIF}
{ Private. LongMulDiv multiplys the first two arguments and then
	divides by the third.  This is used so that real number
	(floating point) arithmetic is not necessary.  This routine saves
	the possible 64-bit value in a temp before doing the divide.  Does
	not do error checking like divide by zero.  Also assumes that the
	result is in the 32-bit range (Actually 31-bit, since this algorithm
	is for unsigned). }

{$IFDEF LINUX}
function Longmuldiv(Mult1,Mult2,Div1:Longint):Longint;stdcall;external 'libwine.borland.so' name 'MulDiv';
{$ENDIF}
{$IFDEF MSWINDOWS}
function Longmuldiv(Mult1,Mult2,Div1:Longint):Longint;stdcall;external 'kernel32.dll' name 'MulDiv';
{$ENDIF}

procedure Killmessage(Wnd:HWND;Msg:integer);
// Delete the requested message from the queue, but throw back
// any WM_QUIT msgs that PeekMessage may also return
var
	M:Tmsg;
begin
	M.Message:=0;
	if Peekmessage(M,Wnd,Msg,Msg,Pm_remove)and(M.Message=Wm_quit) then Postquitmessage(M.Wparam);
end;

constructor TSGInplaceEdit1.Create(Aowner:Tcomponent);
begin
	inherited Create(Aowner);
	ParentCtl3d:=False;
	Ctl3d:=False;
	TabsTop:=False;
	Borderstyle:=Bsnone;
	DoubleBuffered:=False;
end;

procedure TSGInplaceEdit1.CreateParams(var Params:Tcreateparams);
begin
	inherited CreateParams(Params);
	Params.Style:=Params.Style or Es_multiline;
end;

procedure TSGInplaceEdit1.SetGrid(Value:TSGCustomGrid1);
begin
	FGrid:=Value;
end;

procedure TSGInplaceEdit1.CMShowingChanged(var Message:TMessage);
begin
	{ Ignore showing using the Visible property }
end;

procedure TSGInplaceEdit1.WMGetDlgCode(var Message:Twmgetdlgcode);
begin
	inherited;
	if GoTabs in Grid.Options then message.Result:=message.Result or Dlgc_wanttab;
end;

[Uipermission(Securityaction.Linkdemand,Clipboard=Uipermissionclipboard.Allclipboard)]
procedure TSGInplaceEdit1.WWPaste(var Message:TMessage);
begin
	if not EditCanModify then Exit;
	inherited
end;

procedure TSGInplaceEdit1.WMClear(var Message:TMessage);
begin
	if not EditCanModify then Exit;
	inherited;
end;

procedure TSGInplaceEdit1.WMCut(var Message:TMessage);
begin
	if not EditCanModify then Exit;
	inherited;
end;

procedure TSGInplaceEdit1.WndProc(var Message:TMessage);
begin
	case message.Msg of
		Wm_setfocus:begin
				if (Getparentform(Self)=nil)or Getparentform(Self).Setfocusedcontrol(Grid) then Dispatch(message);
				Exit;
			end;
		Wm_lbuttondown:begin
				if Uint(Getmessagetime-FClickTime)<Getdoubleclicktime then message.Msg:=Wm_lbuttondblclk;
				FClickTime:=0;
			end;
		WM_SETTEXT:Change;
		CN_COMMAND: if (message.WParamHi=EN_CHANGE) then Change;
	end;
	inherited WndProc(message);
end;

procedure TSGInplaceEdit1.DblClick;
begin
	Grid.DblClick;
end;

function TSGInplaceEdit1.DoMouseWheel(Shift:Tshiftstate;Wheeldelta:integer;Mousepos:TPoint):Boolean;
begin
	Result:=Grid.DoMouseWheel(Shift,Wheeldelta,Mousepos);
end;

function TSGInplaceEdit1.EditCanModify:Boolean;
begin
	Result:=Grid.Caneditmodify;
end;

procedure TSGInplaceEdit1.KeyDown(var Key:Word;Shift:Tshiftstate);

	procedure Sendtoparent;
	begin
		Grid.KeyDown(Key,Shift);
		Key:=0;
	end;

	procedure Parentevent;
	var
		Gridkeydown:Tkeyevent;
	begin
		Gridkeydown:=Grid.OnKeyDown;
		if Assigned(Gridkeydown) then Gridkeydown(Grid,Key,Shift);
	end;

	function Forwardmovement:Boolean;
	begin
		Result:=GoAlwaysShowEditor in Grid.Options;
	end;

	function Ctrl:Boolean;
	begin
		Result:=Ssctrl in Shift;
	end;

	function Selection:Tselection;
	begin
{$IF DEFINED(CLR)}
		Sendgetsel(Result.Startpos,Result.Endpos);
{$ELSE}
		Sendmessage(Handle,Em_getsel,Wparam(@Result.Startpos),Lparam(@Result.Endpos));
{$ENDIF}
	end;

	function Caretpos:integer;
	var
		P:TPoint;
	begin
		Winapi.Windows.Getcaretpos(P);
		Result:=Sendmessage(Handle,Em_charfrompos,0,Makelong(P.X,P.Y));
	end;

	function Rightside:Boolean;
	begin
		with Selection do Result:=(Caretpos=Gettextlen)and((Startpos=0)or(Endpos=Startpos))and(Endpos=Gettextlen);
	end;

	function Leftside:Boolean;
	begin
		with Selection do Result:=(Caretpos=0)and(Startpos=0)and((Endpos=0)or(Endpos=Gettextlen));
	end;

var
	Ky:Char;
begin
	// showmessage('KeyDown'+#13+chr(Key)+#13+Key.ToString);
	case Key of
		Vk_up,Vk_down,Vk_prior,Vk_next,Vk_escape:Sendtoparent;
		Vk_insert: if Shift=[] then Sendtoparent
			else if (Shift=[Ssshift])and not Grid.Caneditmodify then Key:=0;
		Vk_left: if Forwardmovement and(Ctrl or Leftside) then Sendtoparent;
		Vk_right: if Forwardmovement and(Ctrl or Rightside) then Sendtoparent;
		Vk_home: if Forwardmovement and(Ctrl or Leftside) then Sendtoparent;
		Vk_end: if Forwardmovement and(Ctrl or Rightside) then Sendtoparent;
		Vk_f2:begin
				Parentevent;
				if Key=Vk_f2 then begin
					Deselect;
					Exit;
				end;
			end;
		Vk_tab: if not(Ssalt in Shift) then Sendtoparent;
		Vk_delete: if Ctrl then Sendtoparent
			else if not Grid.Caneditmodify then Key:=0;
	end;
	if Key<>0 then begin
		Parentevent;
		inherited KeyDown(Key,Shift);
	end;
	if (Key=VK_RETURN) then begin
		if Grid is TSJ then
			if Assigned(TSJ(Grid).AutoC) then begin
				Ky:=chr(Key);
				Keypress(Ky);
			end;
	end;
end;

procedure TSGInplaceEdit1.Keypress(var Key:Char);
var
	Selection:Tselection;
begin
	// showmessage('Keypress'+#13+Key+#13+Ord(Key).ToString);
	Grid.Keypress(Key);
	if (Key>=#32)and not Grid.Caneditacceptkey(Key) then begin
		Key:=#0;
		Messagebeep(0);
	end;
	case Key of
		#9,#27:Key:=#0;
		#13:begin
{$IF DEFINED(CLR)}
				Sendgetsel(Selection.Startpos,Selection.Endpos);
{$ELSE}
				Sendmessage(Handle,Em_getsel,Wparam(@Selection.Startpos),Lparam(@Selection.Endpos));
{$ENDIF}
				if (Selection.Startpos=0)and(Selection.Endpos=Gettextlen) then Deselect
				else Selectall;
				Key:=#0;
			end;
		^H,^V,^X,#32.. high(Char): if not Grid.Caneditmodify then Key:=#0;
	end;
	if Key<>#0 then inherited Keypress(Key);
end;

procedure TSGInplaceEdit1.Keyup(var Key:Word;Shift:Tshiftstate);
begin
	Grid.Keyup(Key,Shift);
end;

procedure TSGInplaceEdit1.Deselect;
begin
	Sendmessage(Handle,Em_setsel,$7FFFFFFF,Lparam($FFFFFFFF));
end;

procedure TSGInplaceEdit1.Invalidate;
var
	Cur:TRect;
begin
	Validaterect(Handle,nil);
	InvalidateRect(Handle,nil,True);
	Winapi.Windows.Getclientrect(Handle,Cur);
	Mapwindowpoints(Handle,Grid.Handle,Cur,2);
	Validaterect(Grid.Handle,Cur);
	InvalidateRect(Grid.Handle,Cur,False);
end;

procedure TSGInplaceEdit1.Hide;
begin
	if Handleallocated and Iswindowvisible(Handle) then begin
		Invalidate;
		Setwindowpos(Handle,0,0,0,0,0,Swp_hidewindow or Swp_nozorder or Swp_noredraw);
		if Focused then Winapi.Windows.Setfocus(Grid.Handle);
	end;
end;

function TSGInplaceEdit1.Posequal(const Rect:TRect):Boolean;
var
	Cur:TRect;
begin
	Getwindowrect(Handle,Cur);
	Mapwindowpoints(Hwnd_desktop,Grid.Handle,Cur,2);
	Result:=Equalrect(Rect,Cur);
end;

procedure TSGInplaceEdit1.InternalMove(const Loc:TRect;Redraw:Boolean);
begin
	if Isrectempty(Loc) then Hide
	else begin
		Createhandle;
		Redraw:=Redraw or not Iswindowvisible(Handle);
		Invalidate;
		with Loc do Setwindowpos(Handle,Hwnd_top,Left,Top,Right-Left,Bottom-Top,Swp_showwindow or Swp_noredraw);
		BoundsChanged;
		if Redraw then Invalidate;
		if Grid.Focused then Winapi.Windows.Setfocus(Handle);
	end;
end;

procedure TSGInplaceEdit1.BoundsChanged;
var
	R:TRect;
begin
	R:=Rect(2,2,Width-2,Height);
	Sendstructmessage(Handle,Em_setrectnp,0,R);
	Sendmessage(Handle,Em_scrollcaret,0,0);
end;

procedure TSGInplaceEdit1.Updateloc(const Loc:TRect);
begin
	InternalMove(Loc,False);
end;

function TSGInplaceEdit1.Visible:Boolean;
begin
	Result:=Iswindowvisible(Handle);
end;

procedure TSGInplaceEdit1.Move(const Loc:TRect);
begin
	InternalMove(Loc,True);
end;

[Uipermission(Securityaction.Linkdemand,Window=Uipermissionwindow.Allwindows)]
procedure TSGInplaceEdit1.Setfocus;
begin
	if Iswindowvisible(Handle) then Winapi.Windows.Setfocus(Handle);
end;

procedure TSGInplaceEdit1.UpdateContents;
begin
	TEXT:='';
	Editmask:=Grid.Mask;
	TEXT:=Grid.GetEditText(Grid.Col,Grid.Row);
	Maxlength:=Grid.Geteditlimit;
end;

{ TSGCustomGrid1 }

const
	Gradientendcolorbase=$F0F0F0;

class constructor TSGCustomGrid1.Create;
begin
	Tcustomstyleengine.Registerstylehook(TSGCustomGrid1,Tscrollingstylehook);
end;

constructor TSGCustomGrid1.Create(Aowner:Tcomponent);
const
	Gridstyle=[Cscapturemouse,Csopaque,Csdoubleclicks,Csneedsborderpaint,Cspannable,Csgestures];
begin
	inherited Create(Aowner);
	if Newstylecontrols then Controlstyle:=Gridstyle
	else Controlstyle:=Gridstyle+[Csframed];
	FCanEditModify:=True;
	FMask:='';
	FDragImagesCount:=0;
	FColCount:=5;
	FRowCount:=5;
	FFixedCols:=1;
	FFixedRows:=1;
	FGridLineWidth:=1;
	FOptions:=[GoFixedVertLine,GoFixedHorzLine,GoVertLine,GoHorzLine,GoRangeSelect];
	DesignOptionsBoost:=[GoColSizing,GoRowSizing];
	FFixedColor:=Clbtnface;
	FScrollBars:=ssBoth;
	FBorderStyle:=Bssingle;
	FDefaultColWidth:=64;
	FDefaultRowHeight:=24;
	FDefaultDrawing:=True;
	FDrawingStyle:=GdsThemed;
	FGradientEndColor:=Getshadowcolor(Gradientendcolorbase,-25);
	FGradientStartColor:=Clwhite;
	FSaveCellExtents:=True;
	FEditorMode:=False;
	Color:=Clwindow;
	ParentColor:=False;
	TabsTop:=True;
	Setbounds(Left,Top,FColCount*FDefaultColWidth,FRowCount*FDefaultRowHeight);
	Fhottrackcell.Rect:=Emptyrect;
	Fhottrackcell.Pressed:=False;
	Touch.Interactivegestures:=[Igpan,Igpressandtap];
	Touch.Interactivegestureoptions:=[Igopaninertia,Igopansinglefingerhorizontal,Igopansinglefingervertical,Igopangutter,
		Igoparentpassthrough];
	Initialize;
end;

class destructor TSGCustomGrid1.Destroy;
begin
	Tcustomstyleengine.Unregisterstylehook(TSGCustomGrid1,Tscrollingstylehook);
end;

destructor TSGCustomGrid1.Destroy;
begin
	FInplaceEdit.Free;
	FInplaceEdit:=nil;
	inherited Destroy;
{$IF NOT DEFINED(CLR)}
	Freemem(FColWidths);
	Freemem(FRowHeights);
	Freemem(FTabStops);
{$ENDIF}
end;

procedure TSGCustomGrid1.Adjustsize(Index,Amount:Longint;Rows:Boolean);
var
	Newcur:TGridCoord;
	Oldrows,Oldcols:Longint;
	Movementx,Movementy:Longint;
	Moverect:TGridRect;
	Scrollarea:TRect;
	Absamount:Longint;

{$IF DEFINED(CLR)}
	function Dosizeadjust(var Count:Longint;var Extents:TintegerDynArray;Defaultextent:integer;
		var Current:Longint):Longint;
{$ELSE}
	function Dosizeadjust(var Count:Longint;var Extents:Pointer;Defaultextent:integer;var Current:Longint):Longint;
{$ENDIF}
	var
		I:integer;
		Newcount:Longint;
	begin
		Newcount:=Count+Amount;
		if Newcount<index then Invalidop(Stoomanydeleted);
		if (Amount<0)and Assigned(Extents) then begin
			Result:=0;
			for I:=index to index-Amount-1 do
{$IF DEFINED(CLR)}
					Inc(Result,Extents[I]);
{$ELSE}
					Inc(Result,PintArray(Extents)^[I]);
{$ENDIF}
		end
		else Result:=Amount*Defaultextent;
		if Extents<>nil then Modifyextents(Extents,index,Amount,Defaultextent);
		Count:=Newcount;
		if Current>=index then
			if (Amount<0)and(Current<index-Amount) then Current:=index
			else Inc(Current,Amount);
	end;

begin
	if Amount=0 then Exit;
	Newcur:=FCurrent;
	Oldcols:=Colcount;
	Oldrows:=RowCount;
	Moverect.Left:=Fixedcols;
	Moverect.Right:=Colcount-1;
	Moverect.Top:=Fixedrows;
	Moverect.Bottom:=RowCount-1;
	Movementx:=0;
	Movementy:=0;
	Absamount:=Amount;
	if Absamount<0 then Absamount:=-Absamount;
	if Rows then begin
		Movementy:=Dosizeadjust(FRowCount,FRowHeights,DefaultRowHeight,Newcur.Y);
		Moverect.Top:=index;
		if index+Absamount<=TopRow then Moverect.Bottom:=TopRow-1;
	end else begin
		Movementx:=Dosizeadjust(FColCount,FColWidths,DefaultColWidth,Newcur.X);
		Moverect.Left:=index;
		if index+Absamount<=LeftCol then Moverect.Right:=LeftCol-1;
	end;
	GridRectToScreenRect(Moverect,Scrollarea,True);
	if not Isrectempty(Scrollarea) then begin
		Scrollwindow(Handle,Movementx,Movementy,
{$IFNDEF CLR}@{$ENDIF}Scrollarea,{$IFNDEF CLR}@{$ENDIF}Scrollarea);
		Updatewindow(Handle);
	end;
	Sizechanged(Oldcols,Oldrows);
	if (Newcur.X<>FCurrent.X)or(Newcur.Y<>FCurrent.Y) then MoveCurrent(Newcur.X,Newcur.Y,True,True);
end;

function TSGCustomGrid1.Boxrect(Aleft,Atop,Aright,Abottom:Longint):TRect;
var
	Gridrect:TGridRect;
begin
	Gridrect.Left:=Aleft;
	Gridrect.Right:=Aright;
	Gridrect.Top:=Atop;
	Gridrect.Bottom:=Abottom;
	GridRectToScreenRect(Gridrect,Result,False);
end;

procedure TSGCustomGrid1.Doexit;
begin
	if Observers.Isobserving(Tobservermapping.Editgridlinkid) then
		if Tlinkobservers.Editgridlinkisediting(Observers) then begin
			try Tlinkobservers.Editgridlinkupdate(Observers);
			except
				Tlinkobservers.Editgridlinkreset(Observers);
				Setfocus;
				raise;
			end;
		end;

	inherited Doexit;
	if not(GoAlwaysShowEditor in Options) then Hideeditor;
end;

function TSGCustomGrid1.Cellrect(ACol,ARow:Longint):TRect;
begin
	Result:=Boxrect(ACol,ARow,ACol,ARow);
end;

function TSGCustomGrid1.Caneditacceptkey(Key:Char):Boolean;
begin
	Result:=True;
end;

function TSGCustomGrid1.Cangridacceptkey(Key:Word;Shift:Tshiftstate):Boolean;
begin
	Result:=True;
end;

function TSGCustomGrid1.Caneditmodify:Boolean;
begin
	Result:=FCanEditModify;
end;

function TSGCustomGrid1.Caneditshow:Boolean;
begin
	Result:=([GoRowSelect,GoEditing]*Options=[GoEditing])and FEditorMode and not(Csdesigning in Componentstate)and
		Handleallocated and((GoAlwaysShowEditor in Options)or IsActiveControl);
end;

procedure TSGCustomGrid1.Changescale(M,D:integer;Isdpichange:Boolean);
var
	I:integer;
begin
	FDefaultColWidth:=Muldiv(FDefaultColWidth,M,D);
{$IF DEFINED(CLR)}
	if Length(FColWidths)<>0 then
{$ELSE}
	if FColWidths<>nil then
{$ENDIF}
		for I:=0 to Colcount-1 do Colwidths[I]:=Muldiv(Colwidths[I],M,D);

	FDefaultRowHeight:=Muldiv(FDefaultRowHeight,M,D);
{$IF DEFINED(CLR)}
	if Length(FRowHeights)<>0 then
{$ELSE}
	if FRowHeights<>nil then
{$ENDIF}
		for I:=0 to RowCount-1 do Rowheights[I]:=Muldiv(Rowheights[I],M,D);
	inherited Changescale(M,D,Isdpichange);
end;

function TSGCustomGrid1.IsActiveControl:Boolean;
var
	H:HWND;
	Parentform:Tcustomform;
begin
	Result:=False;
	Parentform:=Getparentform(Self);
	if Assigned(Parentform) then Result:=(Parentform.Activecontrol=Self)and(Parentform=Screen.Activecustomform)
	else begin
		H:=Getfocus;
		while Iswindow(H)and not Result do begin
			if H=Windowhandle then Result:=True
			else H:=Getparent(H);
		end;
	end;
end;

function TSGCustomGrid1.IsGradientEndColorStored:Boolean;
begin
	Result:=FGradientEndColor<>Getshadowcolor(Gradientendcolorbase,-25);
end;

function TSGCustomGrid1.GetEditText(ACol,ARow:Longint):string;
begin
	Result:=FInplaceEdit.Texthint;
end;

procedure TSGCustomGrid1.SetEditText(ACol,ARow:Longint;const Value:string);
begin
	FInplaceEdit.Texthint:=Value;
end;

function TSGCustomGrid1.Geteditlimit:integer;
begin
	Result:=0;
end;

function TSGCustomGrid1.GetEditStyle(ACol,ARow:Longint):TEditStyle;
begin
	Result:=Essimple;
end;

procedure TSGCustomGrid1.Hideeditor;
begin
	FEditorMode:=False;
	Hideedit;
end;

procedure TSGCustomGrid1.Showeditor;
begin
	FEditorMode:=True;
	UpdateEdit;
end;

procedure TSGCustomGrid1.Showeditorchar(Ch:Char);
begin
	Showeditor;
	if FEditorMode then
		if FInplaceEdit<>nil then Postmessage(FInplaceEdit.Handle,Wm_char,Ord(Ch),0);
end;

procedure TSGCustomGrid1.Invalidateeditor;
begin
	FInplaceCol:=-1;
	FinplaceRow:=-1;
	UpdateEdit;
end;

procedure TSGCustomGrid1.ReadColWidths(Reader:Treader);
var
	I:integer;
begin
	with Reader do begin
		Readlistbegin;
		for I:=0 to Colcount-1 do Colwidths[I]:=Readinteger;
		Readlistend;
	end;
end;

procedure TSGCustomGrid1.ReadRowHeights(Reader:Treader);
var
	I:integer;
begin
	with Reader do begin
		Readlistbegin;
		for I:=0 to RowCount-1 do Rowheights[I]:=Readinteger;
		Readlistend;
	end;
end;

procedure TSGCustomGrid1.WriteColWidths(Writer:TWriter);
var
	I:integer;
begin
	with Writer do begin
		Writelistbegin;
		for I:=0 to Colcount-1 do Writeinteger(Colwidths[I]);
		Writelistend;
	end;
end;

procedure TSGCustomGrid1.WriteRowHeights(Writer:TWriter);
var
	I:integer;
begin
	with Writer do begin
		Writelistbegin;
		for I:=0 to RowCount-1 do Writeinteger(Rowheights[I]);
		Writelistend;
	end;
end;

procedure TSGCustomGrid1.DefineProperties(Filer:Tfiler);

	function Docolwidths:Boolean;
	begin
		if Filer.Ancestor<>nil then Result:=not CompareExtents(TSGCustomGrid1(Filer.Ancestor).FColWidths,FColWidths)
		else
{$IF DEFINED(CLR)}
				Result:=Length(FColWidths)<>0;
{$ELSE}
				Result:=FColWidths<>nil;
{$ENDIF}
	end;

	function Dorowheights:Boolean;
	begin
		if Filer.Ancestor<>nil then Result:=not CompareExtents(TSGCustomGrid1(Filer.Ancestor).FRowHeights,FRowHeights)
		else
{$IF DEFINED(CLR)}
				Result:=Length(FRowHeights)<>0;
{$ELSE}
				Result:=FRowHeights<>nil;
{$ENDIF}
	end;

begin
	inherited DefineProperties(Filer);
	if FSaveCellExtents then
		with Filer do begin
			Defineproperty('ColWidths',ReadColWidths,WriteColWidths,Docolwidths);
			Defineproperty('RowHeights',ReadRowHeights,WriteRowHeights,Dorowheights);
		end;
end;

procedure TSGCustomGrid1.MoveColumn(FromIndex,ToIndex:Longint);
var
	Rect:TGridRect;
begin
	if FromIndex=ToIndex then Exit;
{$IF DEFINED(CLR)}
	if Length(FColWidths)>0 then
{$ELSE}
	if Assigned(FColWidths) then
{$ENDIF}
	begin
		MoveExtent(FColWidths,FromIndex+1,ToIndex+1);
		MoveExtent(FTabStops,FromIndex+1,ToIndex+1);
	end;
	MoveAdjust(FCurrent.X,FromIndex,ToIndex);
	MoveAdjust(FAnchor.X,FromIndex,ToIndex);
	MoveAdjust(FInplaceCol,FromIndex,ToIndex);
	Rect.Top:=0;
	Rect.Bottom:=VisibleRowCount;
	if FromIndex<ToIndex then begin
		Rect.Left:=FromIndex;
		Rect.Right:=ToIndex;
	end else begin
		Rect.Left:=ToIndex;
		Rect.Right:=FromIndex;
	end;
	InvalidateRect(Rect);
	ColumnMoved(FromIndex,ToIndex);
{$IF DEFINED(CLR)}
	if Length(FColWidths)<>0 then
{$ELSE}
	if Assigned(FColWidths) then
{$ENDIF}
		Colwidthschanged;
	UpdateEdit;
end;

procedure TSGCustomGrid1.ColumnMoved(FromIndex,ToIndex:Longint);
begin
end;

procedure TSGCustomGrid1.MoveRow(FromIndex,ToIndex:Longint);
begin
{$IF DEFINED(CLR)}
	if Length(FRowHeights)<>0 then
{$ELSE}
	if Assigned(FRowHeights) then
{$ENDIF}
		MoveExtent(FRowHeights,FromIndex+1,ToIndex+1);
	MoveAdjust(FCurrent.Y,FromIndex,ToIndex);
	MoveAdjust(FAnchor.Y,FromIndex,ToIndex);
	MoveAdjust(FinplaceRow,FromIndex,ToIndex);
	RowMoved(FromIndex,ToIndex);
{$IF DEFINED(CLR)}
	if Length(FRowHeights)<>0 then
{$ELSE}
	if Assigned(FRowHeights) then
{$ENDIF}
		Rowheightschanged;
	UpdateEdit;
end;

procedure TSGCustomGrid1.RowMoved(FromIndex,ToIndex:Longint);
begin
end;

function TSGCustomGrid1.MouseCoord(X,Y:integer):TGridCoord;
var
	Drawinfo:TGridDrawInfo;
begin
	CalcDrawInfo(Drawinfo);
	Result:=CalCcoordFromPoint(X,Y,Drawinfo);
	if Result.X<0 then Result.Y:=-1
	else if Result.Y<0 then Result.X:=-1;
end;

procedure TSGCustomGrid1.Movecolrow(ACol,ARow:Longint;MoveAnchor,Show:Boolean);
begin
	MoveCurrent(ACol,ARow,MoveAnchor,Show);
end;

function TSGCustomGrid1.Selectcell(ACol,ARow:Longint):Boolean;
begin
	Result:=True;
end;

procedure TSGCustomGrid1.Sizechanged(Oldcolcount,Oldrowcount:Longint);
begin
end;

function TSGCustomGrid1.Sizing(X,Y:integer):Boolean;
var
	Drawinfo:TGridDrawInfo;
	State:TGridState;
	Index:Longint;
	Pos,Ofs:integer;
begin
	State:=FGridState;
	if State=GSNormal then begin
		CalcDrawInfo(Drawinfo);
		CalcSizingState(X,Y,State,index,Pos,Ofs,Drawinfo);
	end;
	Result:=State<>GSNormal;
end;

procedure TSGCustomGrid1.Topleftchanged;
begin
	if FEditorMode and(FInplaceEdit<>nil) then FInplaceEdit.Updateloc(Cellrect(Col,Row));
end;

{$IF NOT DEFINED(CLR)}

procedure Filldword(var Dest;Count,Value:integer);
{$IFDEF PUREPASCAL}
var
	I:integer;
	P:Pinteger;
begin
	P:=Pinteger(@Dest);
	for I:=0 to Count-1 do begin
		P^:=Value;
		Inc(P);
	end;
end;
{$ELSE !PUREPASCAL}
{$IFDEF CPUX86}
asm
	XCHG  EDX, ECX
	PUSH  EDI
	MOV   EDI, EAX
	MOV   EAX, EDX
	REP   STOSD
	POP   EDI
end;
{$ENDIF CPUX86}
{$ENDIF !PUREPASCAL}
{$ENDIF}
{ StackAlloc allocates a 'small' block of memory from the stack by
	decrementing SP.  This provides the allocation speed of a local variable,
	but the runtime size flexibility of heap allocated memory. }

{$IF NOT DEFINED(CLR)}

function Stackalloc(Size:integer):Pointer; {$IFNDEF PUREPASCAL} Register;
{$ENDIF}
{$IFDEF PUREPASCAL}
begin
	Getmem(Result,Size);
end;
{$ELSE !PUREPASCAL}
{$IFDEF CPUX86}
asm
	POP   ECX          { return address }
	MOV   EDX, ESP
	ADD   EAX, 3
	AND   EAX, not 3   // round up to keep ESP dword aligned
	CMP   EAX, 4092
	JLE   @@2
@@1:
	SUB   ESP, 4092
	PUSH  EAX          { make sure we touch guard page, to grow stack }
	SUB   EAX, 4096
	JNS   @@1
	ADD   EAX, 4096
@@2:
	SUB   ESP, EAX
	MOV   EAX, ESP     { function result = low memory address of block }
	PUSH  EDX          { save original SP, for cleanup }
	MOV   EDX, ESP
	SUB   EDX, 4
	PUSH  EDX          { save current SP, for sanity check  (sp = [sp]) }
	PUSH  ECX          { return to caller }
end;
{$ENDIF CPUX86}
{$ENDIF !PUREPASCAL}
{$ENDIF}
{ StackFree pops the memory allocated by StackAlloc off the stack.
	- Calling StackFree is optional - SP will be restored when the calling routine
	exits, but it's a good idea to free the stack allocated memory ASAP anyway.
	- StackFree must be called in the same stack context as StackAlloc - not in
	a subroutine or finally block.
	- Multiple StackFree calls must occur in reverse order of their corresponding
	StackAlloc calls.
	- Built-in sanity checks guarantee that an improper call to StackFree will not
	corrupt the stack. Worst case is that the stack block is not released until
	the calling routine exits. }

{$IF NOT DEFINED(CLR)}

procedure Stackfree(P:Pointer); {$IFNDEF PUREPASCAL}Register; {$ENDIF}
{$IFDEF PUREPASCAL}
begin
	Freemem(P);
end;
{$ELSE !PUREPASCAL}
{$IFDEF CPUX86}
asm
	POP   ECX                     { return address }
	MOV   EDX, DWORD PTR [ESP]
	SUB   EAX, 8
	CMP   EDX, ESP                { sanity check #1 (SP = [SP]) }
	JNE   @@1
	CMP   EDX, EAX                { sanity check #2 (P = this stack block) }
	JNE   @@1
	MOV   ESP, DWORD PTR [ESP+4]  { restore previous SP }
@@1:
	PUSH  ECX                     { return to caller }
end;
{$ENDIF CPUX86}
{$ENDIF !PUREPASCAL}
{$ENDIF}

procedure TSGCustomGrid1.Paint;
var
	Lstyle:Tcustomstyleservices;
	Lcolor:TColor;
	Linecolor:TColor;
	Lfixedcolor:TColor;
	Lfixedbordercolor:TColor;
	Drawinfo:TGridDrawInfo;
	Sel:TGridRect;
	Updaterect:TRect;
	Afocrect,Focrect:TRect;
{$IF DEFINED(CLR)}
	Pointslist: array of TPoint;
	Strokelist: array of DWORD;
	I:integer;
{$ELSE}
	Pointslist:PintArray;
	Strokelist:PintArray;
{$ENDIF}
	Maxstroke:integer;
	Frameflags1,Frameflags2:DWORD;

	procedure Drawlines(Dohorz,Dovert:Boolean;Col,Row:Longint;const Cellbounds: array of integer;Oncolor,Offcolor:TColor);

	{ Cellbounds is 4 integers: StartX, StartY, StopX, StopY
		Horizontal lines:  MajorIndex = 0
		Vertical lines:    MajorIndex = 1 }

	const
		Flatpenstyle=Ps_geometric or Ps_solid or Ps_endcap_flat or Ps_join_miter;

		procedure Drawaxislines(const Axisinfo:TGridAxisDrawInfo;Cell,Majorindex:integer;Useoncolor:Boolean);
		var
			Line:integer;
			Logbrush:Tlogbrush;
			Index:integer;
{$IF DEFINED(CLR)}
			Points: array of TPoint;
{$ELSE}
			Points:PintArray;
{$ENDIF}
			Stopmajor,Startminor,Stopminor,Stopindex:integer;
			Lineincr:integer;
		begin
			with Canvas,Axisinfo do begin
				if EffectiveLineWidth<>0 then begin
					Pen.Width:=GridLineWidth;
					if Useoncolor then Pen.Color:=Oncolor
					else Pen.Color:=Offcolor;
					if Pen.Width>1 then begin
						Logbrush.Lbstyle:=Bs_solid;
						Logbrush.Lbcolor:=Pen.Color;
						Logbrush.Lbhatch:=0;
						Pen.Handle:=Extcreatepen(Flatpenstyle,Pen.Width,Logbrush,0,nil);
					end;
					Points:=Pointslist;
					Line:=Cellbounds[Majorindex]+(EffectiveLineWidth shr 1)+Axisinfo.GetExtent(Cell);
					// !!! ??? Line needs to be incremented for RightToLeftAlignment ???
					if Userighttoleftalignment and(Majorindex=0) then Inc(Line);
					Startminor:=Cellbounds[Majorindex xor 1];
					Stopminor:=Cellbounds[2+(Majorindex xor 1)];
					if Userighttoleftalignment then Inc(Stopminor);
					Stopmajor:=Cellbounds[2+Majorindex]+EffectiveLineWidth;
{$IF DEFINED(CLR)}
					Stopindex:=Maxstroke*2;
{$ELSE}
					Stopindex:=Maxstroke*4;
{$ENDIF}
					index:=0;
					repeat
{$IF DEFINED(CLR)}
						if Majorindex<>0 then begin
							Points[index].Y:=Line;
							Points[index].X:=Startminor;
						end else begin
							Points[index].X:=Line;
							Points[index].Y:=Startminor;
						end;
						Inc(index);
						if Majorindex<>0 then begin
							Points[index].Y:=Line;
							Points[index].X:=Stopminor;
						end else begin
							Points[index].X:=Line;
							Points[index].Y:=Stopminor;
						end;
						Inc(index);
{$ELSE}
						Points^[index+Majorindex]:=Line; { MoveTo }
						Points^[index+(Majorindex xor 1)]:=Startminor;
						Inc(index,2);
						Points^[index+Majorindex]:=Line; { LineTo }
						Points^[index+(Majorindex xor 1)]:=Stopminor;
						Inc(index,2);
{$ENDIF}
						// Skip hidden columns/rows.  We don't have stroke slots for them
						// A column/row with an extent of -EffectiveLineWidth is hidden
						repeat
							Inc(Cell);
							Lineincr:=Axisinfo.GetExtent(Cell)+EffectiveLineWidth;
						until (Lineincr>0)or(Cell>LastFullVisibleCell);
						Inc(Line,Lineincr);
					until (Line>Stopmajor)or(Cell>LastFullVisibleCell)or(index>Stopindex);
{$IF DEFINED(CLR)}
					{ 2 points per line -> Index div 2 }
					Polypolyline(Canvas.Handle,Points,Strokelist,index shr 1);
{$ELSE}
					{ 2 integers per point, 2 points per line -> Index div 4 }
					Polypolyline(Canvas.Handle,Points^,Strokelist^,index shr 2);
{$ENDIF}
				end;
			end;
		end;

	begin
		if (Cellbounds[0]=Cellbounds[2])or(Cellbounds[1]=Cellbounds[3]) then Exit;
		if not Dohorz then begin
			Drawaxislines(Drawinfo.Vert,Row,1,Dohorz);
			Drawaxislines(Drawinfo.Horz,Col,0,Dovert);
		end else begin
			Drawaxislines(Drawinfo.Horz,Col,0,Dovert);
			Drawaxislines(Drawinfo.Vert,Row,1,Dohorz);
		end;
	end;

	procedure Drawcells(ACol,ARow:Longint;Startx,Starty,Stopx,Stopy:integer;Acolor:TColor;
		Includedrawstate:TGridDrawState);
	var
		Curcol,Currow:Longint;
		Awhere,Where,Temprect:TRect;
		Drawstate:TGridDrawState;
		Focused:Boolean;
	begin
		Currow:=ARow;
		Where.Top:=Starty;
		while (Where.Top<Stopy)and(Currow<RowCount) do begin
			Curcol:=ACol;
			Where.Left:=Startx;
			Where.Bottom:=Where.Top+Rowheights[Currow];
			while (Where.Left<Stopx)and(Curcol<Colcount) do begin
				Where.Right:=Where.Left+Colwidths[Curcol];
				if (Where.Right>Where.Left)and Rectvisible(Canvas.Handle,Where) then begin
					Drawstate:=Includedrawstate;
					if Pointingridrect(Curcol,Currow,Fhottrackcell.Rect) then begin
						if (GoFixedHotTrack in Options) then Include(Drawstate,GDHotTrack);
						if Fhottrackcell.Pressed then Include(Drawstate,GDPressed);
					end;
					Focused:=IsActiveControl;
					if Focused and(Currow=Row)and(Curcol=Col) then begin
						Setcaretpos(Where.Left,Where.Top);
						Include(Drawstate,GDFocused);
					end;
					if Pointingridrect(Curcol,Currow,Sel) then Include(Drawstate,GDSelected);
					if not(GDFocused in Drawstate)or not(GoEditing in Options)or not FEditorMode or(Csdesigning in Componentstate)
					then begin
						if Defaultdrawing or(Csdesigning in Componentstate) then begin
							Canvas.Font:=Self.Font;
							if (GDSelected in Drawstate)and
								(not(GDFocused in Drawstate)or([GoDrawFocusSelected,GoRowSelect]*Options<>[])) then
									Drawcellhighlight(Where,Drawstate,Curcol,Currow)
							else Drawcellbackground(Where,Acolor,Drawstate,Curcol,Currow);
						end;
						Awhere:=Where;
						if (GDPressed in Drawstate) then begin
							Inc(Awhere.Top);
							Inc(Awhere.Left);
						end;
						Drawcell(Curcol,Currow,Awhere,Drawstate);
						if Defaultdrawing and(GDFixed in Drawstate)and Ctl3d and((Frameflags1 or Frameflags2)<>0)and
							(FInternalDrawingStyle=GDsClassic)and not(GDPressed in Drawstate) then begin
							Temprect:=Where;
							if (Frameflags1 and Bf_right)=0 then Inc(Temprect.Right,Drawinfo.Horz.EffectiveLineWidth)
							else if (Frameflags1 and Bf_bottom)=0 then Inc(Temprect.Bottom,Drawinfo.Vert.EffectiveLineWidth);
							if not Tstylemanager.Iscustomstyleactive then begin
								Drawedge(Canvas.Handle,Temprect,Bdr_raisedinner,Frameflags1);
								Drawedge(Canvas.Handle,Temprect,Bdr_raisedinner,Frameflags2);
							end;
						end;

						if Defaultdrawing and not(Csdesigning in Componentstate)and
							not(Tstylemanager.Iscustomstyleactive and(GoDrawFocusSelected in FOptions))and(GDFocused in Drawstate)and
							([GoEditing,GoAlwaysShowEditor]*Options<>[GoEditing,GoAlwaysShowEditor])and not(GoRowSelect in Options)
						then begin
							Temprect:=Where;
							if (FInternalDrawingStyle=GdsThemed)and(Win32majorversion>=6)and not Tstylemanager.Iscustomstyleactive
							then Inflaterect(Temprect,-1,-1);
							Canvas.Brush.Style:=Bssolid;
							if Tstylemanager.Iscustomstyleactive and DoubleBuffered then begin
								if Userighttoleftalignment then Offsetrect(Temprect,1,0);
								Drawstylefocusrect(Canvas.Handle,Temprect)
							end else if not Userighttoleftalignment then Drawfocusrect(Canvas.Handle,Temprect)
							else begin
								Awhere:=Temprect;
								Awhere.Left:=Temprect.Right;
								Awhere.Right:=Temprect.Left;
								Drawfocusrect(Canvas.Handle,Awhere);
							end;
						end;
					end;
				end;
				Where.Left:=Where.Right+Drawinfo.Horz.EffectiveLineWidth;
				Inc(Curcol);
			end;
			Where.Top:=Where.Bottom+Drawinfo.Vert.EffectiveLineWidth;
			Inc(Currow);
		end;
	end;

begin
	if Userighttoleftalignment then ChangeGridOrientation(True);

	FInternalColor:=Color;
	Lstyle:=Styleservices;
	if (FInternalDrawingStyle=GdsThemed) then begin
		Lstyle.Getelementcolor(Lstyle.Getelementdetails(Tgcellnormal),Ecbordercolor,Linecolor);
		if Seclient in StyleElements then
				Lstyle.Getelementcolor(Lstyle.Getelementdetails(Tgcellnormal),Ecfillcolor,FInternalColor);
		Lstyle.Getelementcolor(Lstyle.Getelementdetails(Tgfixedcellnormal),Ecbordercolor,Lfixedbordercolor);
		Lstyle.Getelementcolor(Lstyle.Getelementdetails(Tgfixedcellnormal),Ecfillcolor,Lfixedcolor);
	end else begin
		if (FInternalDrawingStyle=GdsGradient) then begin
			Linecolor:=$F0F0F0;
			Lfixedcolor:=Color;
			if Colortorgb(Linecolor)=Colortorgb(Color) then Linecolor:=Getshadowcolor(Linecolor,-45);
			Lfixedbordercolor:=Getshadowcolor($F0F0F0,-45);

			if Lstyle.Enabled then begin
				if Lstyle.Getelementcolor(Lstyle.Getelementdetails(Tggradientcellnormal),Ecbordercolor,Lcolor)and(Lcolor<>Clnone)
				then Linecolor:=Lcolor;
				if Lstyle.Getelementcolor(Lstyle.Getelementdetails(Tggradientcellnormal),Ecfillcolor,Lcolor)and(Lcolor<>Clnone)
				then FInternalColor:=Lcolor;
				if Lstyle.Getelementcolor(Lstyle.Getelementdetails(Tggradientfixedcellnormal),Ecbordercolor,Lcolor)and
					(Lcolor<>Clnone) then Lfixedbordercolor:=Lcolor;
				if Lstyle.Getelementcolor(Lstyle.Getelementdetails(Tggradientfixedcellnormal),Ecfillcolor,Lcolor)and
					(Lcolor<>Clnone) then Lfixedcolor:=Lcolor;
			end;
		end else begin
			Linecolor:=Clsilver;
			Lfixedcolor:=FixedColor;
			if Colortorgb(Linecolor)=Colortorgb(Color) then Linecolor:=Getshadowcolor(Linecolor,-45);
			Lfixedbordercolor:=Clblack;

			if Lstyle.Enabled then begin
				if Lstyle.Getelementcolor(Lstyle.Getelementdetails(Tgclassiccellnormal),Ecbordercolor,Lcolor)and(Lcolor<>Clnone)
				then Linecolor:=Lcolor;
				if Lstyle.Getelementcolor(Lstyle.Getelementdetails(Tgclassiccellnormal),Ecfillcolor,Lcolor)and(Lcolor<>Clnone)
				then FInternalColor:=Lcolor;
				if Lstyle.Getelementcolor(Lstyle.Getelementdetails(Tgclassicfixedcellnormal),Ecbordercolor,Lcolor)and
					(Lcolor<>Clnone) then Lfixedbordercolor:=Lcolor;
				if Lstyle.Getelementcolor(Lstyle.Getelementdetails(Tgclassicfixedcellnormal),Ecfillcolor,Lcolor)and
					(Lcolor<>Clnone) then Lfixedcolor:=Lcolor;
			end;
		end;
	end;

	Updaterect:=Canvas.Cliprect;
	CalcDrawInfo(Drawinfo);
	with Drawinfo do begin
		if (Horz.EffectiveLineWidth>0)or(Vert.EffectiveLineWidth>0) then begin
			{ Draw the grid line in the four areas (fixed, fixed), (variable, fixed),
				(fixed, variable) and (variable, variable) }
			Maxstroke:=Max(Horz.LastFullVisibleCell-LeftCol+Fixedcols,Vert.LastFullVisibleCell-TopRow+Fixedrows)+3;
{$IF DEFINED(CLR)}
			Setlength(Pointslist,Maxstroke*2); // two points per stroke
			Setlength(Strokelist,Maxstroke);
			for I:=0 to Maxstroke-1 do Strokelist[I]:=2;
{$ELSE}
			Pointslist:=Stackalloc(Maxstroke*Sizeof(TPoint)*2);
			Strokelist:=Stackalloc(Maxstroke*Sizeof(integer));
			Filldword(Strokelist^,Maxstroke,2);
{$ENDIF}
			if Colortorgb(FInternalColor)=Clsilver then Linecolor:=Clgray;
			Drawlines(GoFixedHorzLine in Options,GoFixedVertLine in Options,0,0,[0,0,Horz.FixedBoundary,Vert.FixedBoundary],
				Lfixedbordercolor,Lfixedcolor);
			Drawlines(GoFixedHorzLine in Options,GoFixedVertLine in Options,LeftCol,0,
				[Horz.FixedBoundary,0,Horz.GridBoundary,Vert.FixedBoundary],Lfixedbordercolor,Lfixedcolor);
			Drawlines(GoFixedHorzLine in Options,GoFixedVertLine in Options,0,TopRow,[0,Vert.FixedBoundary,Horz.FixedBoundary,
				Vert.GridBoundary],Lfixedbordercolor,Lfixedcolor);
			Drawlines(GoHorzLine in Options,GoVertLine in Options,LeftCol,TopRow,[Horz.FixedBoundary,Vert.FixedBoundary,
				Horz.GridBoundary,Vert.GridBoundary],Linecolor,FInternalColor);

{$IF DEFINED(CLR)}
			Setlength(Strokelist,0);
			Setlength(Pointslist,0);
{$ELSE}
			Stackfree(Strokelist);
			Stackfree(Pointslist);
{$ENDIF}
		end;

		{ Draw the cells in the four areas }
		Sel:=Selection;
		Frameflags1:=0;
		Frameflags2:=0;
		if GoFixedVertLine in Options then begin
			Frameflags1:=Bf_right;
			Frameflags2:=Bf_left;
		end;
		if GoFixedHorzLine in Options then begin
			Frameflags1:=Frameflags1 or Bf_bottom;
			Frameflags2:=Frameflags2 or Bf_top;
		end;
		Drawcells(0,0,0,0,Horz.FixedBoundary,Vert.FixedBoundary,Lfixedcolor,[GDFixed]);
		Drawcells(LeftCol,0,Horz.FixedBoundary-FColOffset,0,Horz.GridBoundary,
			// !! clip
			Vert.FixedBoundary,Lfixedcolor,[GDFixed]);
		Drawcells(0,TopRow,0,Vert.FixedBoundary,Horz.FixedBoundary,Vert.GridBoundary,Lfixedcolor,[GDFixed]);
		Drawcells(LeftCol,TopRow,Horz.FixedBoundary-FColOffset, // !! clip
			Vert.FixedBoundary,Horz.GridBoundary,Vert.GridBoundary,FInternalColor,[]);

		if not(Csdesigning in Componentstate)and(GoRowSelect in Options)and Defaultdrawing and Focused then begin
			GridRectToScreenRect(GetSelection,Focrect,False);
			Canvas.Brush.Style:=Bssolid;
			if (FInternalDrawingStyle=GdsThemed)and(Win32majorversion>=6)and not Tstylemanager.Iscustomstyleactive then
					Inflaterect(Focrect,-1,-1);
			Afocrect:=Focrect;
			if Tstylemanager.Iscustomstyleactive and DoubleBuffered then Drawstylefocusrect(Canvas.Handle,Afocrect)
			else if not Userighttoleftalignment then Canvas.Drawfocusrect(Afocrect)
			else begin
				Afocrect:=Focrect;
				Afocrect.Left:=Focrect.Right;
				Afocrect.Right:=Focrect.Left;
				Drawfocusrect(Canvas.Handle,Afocrect);
			end;
		end;

		{ Fill in area not occupied by cells }
		if not(Seclient in StyleElements) then FInternalColor:=Color;
		if Horz.GridBoundary<Horz.GridExtent then begin
			Canvas.Brush.Color:=FInternalColor;
			Canvas.Fillrect(Rect(Horz.GridBoundary,0,Horz.GridExtent,Vert.GridBoundary));
		end;
		if Vert.GridBoundary<Vert.GridExtent then begin
			Canvas.Brush.Color:=FInternalColor;
			Canvas.Fillrect(Rect(0,Vert.GridBoundary,Horz.GridExtent,Vert.GridExtent));
		end;
	end;

	if Userighttoleftalignment then ChangeGridOrientation(False);
end;

function TSGCustomGrid1.CalCcoordFromPoint(X,Y:integer;const Drawinfo:TGridDrawInfo):TGridCoord;

	function Docalc(const Axisinfo:TGridAxisDrawInfo;N:integer):integer;
	var
		I,Start,Stop:Longint;
		Line:integer;
	begin
		with Axisinfo do begin
			if N<FixedBoundary then begin
				Start:=0;
				Stop:=FixedCellCount-1;
				Line:=0;
			end else begin
				Start:=FirstGridCell;
				Stop:=GridCellCount-1;
				Line:=FixedBoundary;
			end;
			Result:=-1;
			for I:=Start to Stop do begin
				Inc(Line,Axisinfo.GetExtent(I)+EffectiveLineWidth);
				if N<Line then begin
					Result:=I;
					Exit;
				end;
			end;
		end;
	end;

	function Docalcrighttoleft(const Axisinfo:TGridAxisDrawInfo;N:integer):integer;
	begin
		N:=Clientwidth-N;
		Result:=Docalc(Axisinfo,N);
	end;

begin
	if not Userighttoleftalignment then Result.X:=Docalc(Drawinfo.Horz,X)
	else Result.X:=Docalcrighttoleft(Drawinfo.Horz,X);
	Result.Y:=Docalc(Drawinfo.Vert,Y);
end;

function TSGCustomGrid1.CanObserve(const Id:integer):Boolean;
begin
	Result:=False;
	if Id=Tobservermapping.Editgridlinkid then Result:=True
	else if Id=Tobservermapping.Positionlinkid then Result:=True;
end;

procedure TSGCustomGrid1.ObserverAdded(const Id:integer;const Observer:Iobserver);
var
	Lgridlinkobserver:Ieditgridlinkobserver;
begin
	if Id=Tobservermapping.Editgridlinkid then Observer.Onobservertoggle:=ObserverToggle;
	if Supports(Observer,Ieditgridlinkobserver,Lgridlinkobserver) then
			Lgridlinkobserver.Onobservercurrent:=ObserverCurrent;
end;

function TSGCustomGrid1.ObserverCurrent:Tvarrec;
begin
	Result.Vtype:=Vtinteger;
	// Expects 0 based index
	Result.Vinteger:=Col;
end;

procedure TSGCustomGrid1.ObserverToggle(const Aobserver:Iobserver;const Value:Boolean);
begin
	// Code to use observers removed.  Observers
	// do not affect GoEditing option of a grid.
end;

procedure TSGCustomGrid1.CalcDrawInfo(var Drawinfo:TGridDrawInfo);
begin
	CalCDrawInfoXY(Drawinfo,Clientwidth,Clientheight);
end;

procedure TSGCustomGrid1.CalCDrawInfoXY(var Drawinfo:TGridDrawInfo;Usewidth,Useheight:integer);

	procedure Calcaxis(var Axisinfo:TGridAxisDrawInfo;Useextent:integer);
	var
		I:integer;
	begin
		with Axisinfo do begin
			GridExtent:=Useextent;
			GridBoundary:=FixedBoundary;
			FullVisBoundary:=FixedBoundary;
			LastFullVisibleCell:=FirstGridCell;
			for I:=FirstGridCell to GridCellCount-1 do begin
				Inc(GridBoundary,Axisinfo.GetExtent(I)+EffectiveLineWidth);
				if GridBoundary>GridExtent+EffectiveLineWidth then begin
					GridBoundary:=GridExtent;
					Break;
				end;
				LastFullVisibleCell:=I;
				FullVisBoundary:=GridBoundary;
			end;
		end;
	end;

begin
	CalcFixedInfo(Drawinfo);
	Calcaxis(Drawinfo.Horz,Usewidth);
	Calcaxis(Drawinfo.Vert,Useheight);
end;

procedure TSGCustomGrid1.CalcFixedInfo(var Drawinfo:TGridDrawInfo);

	procedure Calcfixedaxis(var Axis:TGridAxisDrawInfo;Lineoptions:TGridOptions;Fixedcount,Firstcell,Cellcount:integer;
		Getextentfunc:TGetExtentsFunc);
	var
		I:integer;
	begin
		with Axis do begin
			if Lineoptions*Options=[] then EffectiveLineWidth:=0
			else EffectiveLineWidth:=GridLineWidth;

			FixedBoundary:=0;
			for I:=0 to Fixedcount-1 do Inc(FixedBoundary,Getextentfunc(I)+EffectiveLineWidth);

			FixedCellCount:=Fixedcount;
			FirstGridCell:=Firstcell;
			GridCellCount:=Cellcount;
			GetExtent:=Getextentfunc;
		end;
	end;

begin
	Calcfixedaxis(Drawinfo.Horz,[GoFixedVertLine,GoVertLine],Fixedcols,LeftCol,Colcount,GetColWidths);
	Calcfixedaxis(Drawinfo.Vert,[GoFixedHorzLine,GoHorzLine],Fixedrows,TopRow,RowCount,GetRowHeights);
end;

{ Calculates the TopLeft that will put the given Coord in view }
function TSGCustomGrid1.CalcMaxTopLeft(const Coord:TGridCoord;const Drawinfo:TGridDrawInfo):TGridCoord;

	function Calcmaxcell(const Axis:TGridAxisDrawInfo;Start:integer):integer;
	var
		Line:integer;
		I,Extent:Longint;
	begin
		Result:=Start;
		with Axis do begin
			Line:=GridExtent+EffectiveLineWidth;
			for I:=Start downto FixedCellCount do begin
				Extent:=GetExtent(I);
				if Extent>0 then begin
					Dec(Line,Extent);
					Dec(Line,EffectiveLineWidth);
					if Line<FixedBoundary then begin
						if (Result=Start)and(GetExtent(Start)<=0) then Result:=I;
						Break;
					end;
					Result:=I;
				end;
			end;
		end;
	end;

begin
	Result.X:=Calcmaxcell(Drawinfo.Horz,Coord.X);
	Result.Y:=Calcmaxcell(Drawinfo.Vert,Coord.Y);
end;

procedure TSGCustomGrid1.CalcSizingState(X,Y:integer;var State:TGridState;var Index:Longint;
	var SizingPos,SizingOfs:integer;var FixedInfo:TGridDrawInfo);

	procedure Calcaxisstate(const Axisinfo:TGridAxisDrawInfo;Pos:integer;Newstate:TGridState);
	var
		I,Line,Back,Range:integer;
	begin
		if (Newstate=GSColSizing)and Userighttoleftalignment then Pos:=Clientwidth-Pos;
		with Axisinfo do begin
			Line:=FixedBoundary;
			Range:=EffectiveLineWidth;
			Back:=0;
			if Range<7 then begin
				Range:=7;
				Back:=(Range-EffectiveLineWidth) shr 1;
			end;
			for I:=FirstGridCell to GridCellCount-1 do begin
				Inc(Line,Axisinfo.GetExtent(I));
				if Line>GridBoundary then Break;
				if (Pos>=Line-Back)and(Pos<=Line-Back+Range) then begin
					State:=Newstate;
					SizingPos:=Line;
					SizingOfs:=Line-Pos;
					index:=I;
					Exit;
				end;
				Inc(Line,EffectiveLineWidth);
			end;
			if (GridBoundary=GridExtent)and(Pos>=GridExtent-Back)and(Pos<=GridExtent) then begin
				State:=Newstate;
				SizingPos:=GridExtent;
				SizingOfs:=GridExtent-Pos;
				index:=LastFullVisibleCell+1;
			end;
		end;
	end;

	function Xoutsidehorzfixedboundary:Boolean;
	begin
		with FixedInfo do
			if not Userighttoleftalignment then Result:=X>Horz.FixedBoundary
			else Result:=X<Clientwidth-Horz.FixedBoundary;
	end;

	function Xoutsideorequalhorzfixedboundary:Boolean;
	begin
		with FixedInfo do
			if not Userighttoleftalignment then Result:=X>=Horz.FixedBoundary
			else Result:=X<=Clientwidth-Horz.FixedBoundary;
	end;

var
	Effectiveoptions:TGridOptions;
begin
	State:=GSNormal;
	index:=-1;
	Effectiveoptions:=Options;
	if Csdesigning in Componentstate then Effectiveoptions:=Effectiveoptions+DesignOptionsBoost;
	if [GoColSizing,GoRowSizing]*Effectiveoptions<>[] then
		with FixedInfo do begin
			Vert.GridExtent:=Clientheight;
			Horz.GridExtent:=Clientwidth;
			if (Xoutsidehorzfixedboundary)and(GoColSizing in Effectiveoptions) then begin
				if Y>=Vert.FixedBoundary then Exit;
				Calcaxisstate(Horz,X,GSColSizing);
			end else if (Y>Vert.FixedBoundary)and(GoRowSizing in Effectiveoptions) then begin
				if Xoutsideorequalhorzfixedboundary then Exit;
				Calcaxisstate(Vert,Y,GSRowSizing);
			end;
		end;
end;

procedure TSGCustomGrid1.ChangeGridOrientation(RightToLeftOrientation:Boolean);
var
	Org:TPoint;
	Ext:TPoint;
begin
	if RightToLeftOrientation then begin
		Org:=Point(Clientwidth,0);
		Ext:=Point(-1,1);
		Setmapmode(Canvas.Handle,Mm_anisotropic);
		Setwindoworgex(Canvas.Handle,Org.X,Org.Y,nil);
		Setviewportextex(Canvas.Handle,Clientwidth,Clientheight,nil);
		Setwindowextex(Canvas.Handle,Ext.X*Clientwidth,Ext.Y*Clientheight,nil);
	end else begin
		Org:=Point(0,0);
		Ext:=Point(1,1);
		Setmapmode(Canvas.Handle,Mm_anisotropic);
		Setwindoworgex(Canvas.Handle,Org.X,Org.Y,nil);
		Setviewportextex(Canvas.Handle,Clientwidth,Clientheight,nil);
		Setwindowextex(Canvas.Handle,Ext.X*Clientwidth,Ext.Y*Clientheight,nil);
	end;
end;

procedure TSGCustomGrid1.ChangeSize(Newcolcount,Newrowcount:Longint);
var
	Oldcolcount,Oldrowcount:Longint;
	Olddrawinfo:TGridDrawInfo;

	procedure Minredraw(const Oldinfo,Newinfo:TGridAxisDrawInfo;Axis:integer);
	var
		R:TRect;
		First:integer;
	begin
		First:=Min(Oldinfo.LastFullVisibleCell,Newinfo.LastFullVisibleCell);
		// Get the rectangle around the leftmost or topmost cell in the target range.
		R:=Cellrect(First and not Axis,First and Axis);
		R.Bottom:=Height;
		R.Right:=Width;
		Winapi.Windows.InvalidateRect(Handle,R,False);
	end;

	procedure Dochange;
	var
		Coord:TGridCoord;
		Newdrawinfo:TGridDrawInfo;
	begin
{$IF DEFINED(CLR)}
		if Length(FColWidths)<>0 then UpdateExtents(FColWidths,Colcount,DefaultColWidth);
		if Length(FTabStops)<>0 then UpdateExtents(FTabStops,Colcount,integer(True));
		if Length(FRowHeights)<>0 then UpdateExtents(FRowHeights,RowCount,DefaultRowHeight);
{$ELSE}
		if FColWidths<>nil then UpdateExtents(FColWidths,Colcount,DefaultColWidth);
		if FTabStops<>nil then UpdateExtents(FTabStops,Colcount,integer(True));
		if FRowHeights<>nil then UpdateExtents(FRowHeights,RowCount,DefaultRowHeight);
{$ENDIF}
		Coord:=FCurrent;
		if Row>=RowCount then Coord.Y:=RowCount-1;
		if Col>=Colcount then Coord.X:=Colcount-1;
		if (FCurrent.X<>Coord.X)or(FCurrent.Y<>Coord.Y) then MoveCurrent(Coord.X,Coord.Y,True,True);
		if (FAnchor.X<>Coord.X)or(FAnchor.Y<>Coord.Y) then MoveAnchor(Coord);
		if VirtualView or(LeftCol<>Olddrawinfo.Horz.FirstGridCell)or(TopRow<>Olddrawinfo.Vert.FirstGridCell) then
				Invalidategrid
		else if Handleallocated then begin
			CalcDrawInfo(Newdrawinfo);
			Minredraw(Olddrawinfo.Horz,Newdrawinfo.Horz,0);
			Minredraw(Olddrawinfo.Vert,Newdrawinfo.Vert,-1);
		end;
		UpdateScrollRange;
		Sizechanged(Oldcolcount,Oldrowcount);
	end;

begin
	if Handleallocated then CalcDrawInfo(Olddrawinfo);
	Oldcolcount:=FColCount;
	Oldrowcount:=FRowCount;
	FColCount:=Newcolcount;
	FRowCount:=Newrowcount;
	if Fixedcols>Newcolcount then FFixedCols:=Newcolcount-1;
	if Fixedrows>Newrowcount then FFixedRows:=Newrowcount-1;
	try Dochange;
	except
		{ Could not change size so try to clean up by setting the size back }
		FColCount:=Oldcolcount;
		FRowCount:=Oldrowcount;
		Dochange;
		Invalidategrid;
		raise;
	end;
end;

{ Will move TopLeft so that Coord is in view }
procedure TSGCustomGrid1.ClampInView(const Coord:TGridCoord);
var
	Drawinfo:TGridDrawInfo;
	Maxtopleft:TGridCoord;
	Oldtopleft:TGridCoord;
begin
	if not Handleallocated then Exit;
	CalcDrawInfo(Drawinfo);
	with Drawinfo,Coord do begin
		if (X>Horz.LastFullVisibleCell)or(Y>Vert.LastFullVisibleCell)or(X<LeftCol)or(Y<TopRow) then begin
			Oldtopleft:=FTopLeft;
			Maxtopleft:=CalcMaxTopLeft(Coord,Drawinfo);
			Update;
			if X<LeftCol then FTopLeft.X:=X
			else if X>Horz.LastFullVisibleCell then FTopLeft.X:=Maxtopleft.X;
			if Y<TopRow then FTopLeft.Y:=Y
			else if Y>Vert.LastFullVisibleCell then FTopLeft.Y:=Maxtopleft.Y;
			TopLeftMoved(Oldtopleft);
		end;
	end;
end;

procedure TSGCustomGrid1.DrawSizingLine(const Drawinfo:TGridDrawInfo);
var
	Oldpen:Tpen;
begin
	Oldpen:=Tpen.Create;
	try
		with Canvas,Drawinfo do begin
			Oldpen.Assign(Pen);
			Pen.Style:=Psdot;
			Pen.Mode:=Pmxor;
			Pen.Width:=Muldiv(1,Fcurrentppi,96);
			try
				if FGridState=GSRowSizing then begin
					if Userighttoleftalignment then begin
						Moveto(Horz.GridExtent,FSizingPos);
						Lineto(Horz.GridExtent-Horz.GridBoundary,FSizingPos);
					end else begin
						Moveto(0,FSizingPos);
						Lineto(Horz.GridBoundary,FSizingPos);
					end;
				end else begin
					Moveto(FSizingPos,0);
					Lineto(FSizingPos,Vert.GridBoundary);
				end;
			finally Pen:=Oldpen;
			end;
		end;
	finally Oldpen.Free;
	end;
end;

procedure TSGCustomGrid1.Drawcellhighlight(const Arect:TRect;AState:TGridDrawState;ACol,ARow:integer);
const
	Cselected: array [TGridDrawingStyle] of Tthemedgrid=(Tgclassiccellselected,Tgcellselected,Tggradientcellselected);
	Crowselectedleft: array [TGridDrawingStyle] of Tthemedgrid=(Tgclassiccellrowselectedleft,Tgcellrowselectedleft,
		Tggradientcellrowselectedleft);
	Crowselectedcenter: array [TGridDrawingStyle] of Tthemedgrid=(Tgclassiccellrowselectedcenter,Tgcellrowselectedcenter,
		Tggradientcellrowselectedcenter);
	Crowselectedright: array [TGridDrawingStyle] of Tthemedgrid=(Tgclassiccellrowselectedright,Tgcellrowselectedright,
		Tggradientcellrowselectedright);
var
	Lrect:TRect;
	Lgridpart:Tthemedgrid;
	Lstyle:Tcustomstyleservices;
	Lcolor,Lendcolor,Ltextcolor,Lcolorref:TColor;
begin
	Lstyle:=Styleservices;
	if (GoRowSelect in Options) then Include(AState,GDRowSelected);
	Lrect:=Arect;

	Lgridpart:=Cselected[FInternalDrawingStyle];
	if Lstyle.Enabled and(GDRowSelected in AState) then begin
		if (ACol>=Fixedcols+1)and(ACol<Colcount-1) then begin
			Lgridpart:=Crowselectedcenter[FInternalDrawingStyle];
			Inc(Lrect.Right,4);
			Dec(Lrect.Left,4);
		end else if ACol=Fixedcols then begin
			Lgridpart:=Crowselectedleft[FInternalDrawingStyle];
			Inc(Lrect.Right,4);
		end else if ACol=(Colcount-1) then begin
			Lgridpart:=Crowselectedright[FInternalDrawingStyle];
			Dec(Lrect.Left,4);
		end;
	end;

	if (FInternalDrawingStyle=GdsThemed) then begin
		Canvas.Brush.Style:=Bssolid;
		if Tstylemanager.Iscustomstyleactive then begin
			Canvas.Brush.Color:=Lstyle.Getstylecolor(Scgrid);
		end else if not Tosversion.Check(6) then begin
			Canvas.Brush.Color:=Clhighlight;
		end;
		Canvas.Fillrect(Arect);

		if Tstylemanager.Iscustomstyleactive and Userighttoleftalignment then Offsetrect(Lrect,1,0);

		Lstyle.Drawelement(Canvas.Handle,Lstyle.Getelementdetails(Lgridpart),Lrect,Arect);
		if not Lstyle.Getelementcolor(Lstyle.Getelementdetails(Lgridpart),Ectextcolor,Lcolor)or(Lcolor=Clnone) then
				Lcolor:=Clhighlighttext;

		Canvas.Font.Color:=Lcolor;
		Canvas.Brush.Style:=Bsclear;
	end else begin
		if FInternalDrawingStyle=GdsGradient then begin
			Lrect:=Arect;
			Canvas.Brush.Color:=Lstyle.Getsystemcolor(Clhighlight);
			Canvas.Framerect(Lrect);
			if (GDRowSelected in AState) then begin
				Inflaterect(Lrect,0,-1);
				if ACol=Fixedcols then Inc(Lrect.Left)
				else if ACol=(Colcount-1) then Dec(Lrect.Right)
			end
			else Inflaterect(Lrect,-1,-1);

			Lcolor:=Getshadowcolor(Clhighlight,45);
			Lendcolor:=Getshadowcolor(Clhighlight,10);
			Ltextcolor:=Clhighlighttext;

			if Lstyle.Enabled then begin
				if Lstyle.Getelementcolor(Lstyle.Getelementdetails(Lgridpart),Ecgradientcolor1,Lcolorref)and(Lcolorref<>Clnone)
				then Lcolor:=Lcolorref;
				if Lstyle.Getelementcolor(Lstyle.Getelementdetails(Lgridpart),Ecgradientcolor2,Lcolorref)and(Lcolorref<>Clnone)
				then Lendcolor:=Lcolorref;
				if Lstyle.Getelementcolor(Lstyle.Getelementdetails(Lgridpart),Ectextcolor,Lcolorref)and(Lcolorref<>Clnone) then
						Ltextcolor:=Lcolorref;
			end;

			Gradientfillcanvas(Canvas,Lcolor,Lendcolor,Lrect,Gdvertical);
			Canvas.Font.Color:=Ltextcolor;
			Canvas.Brush.Style:=Bsclear;
		end else begin
			Canvas.Brush.Color:=Clhighlight;
			Canvas.Font.Color:=Clhighlighttext;
			if Lstyle.Enabled then begin
				if Lstyle.Getelementcolor(Lstyle.Getelementdetails(Lgridpart),Ecfillcolor,Lcolor)and(Lcolor<>Clnone) then begin
					Canvas.Brush.Color:=Lcolor;
				end;
				if Lstyle.Getelementcolor(Lstyle.Getelementdetails(Lgridpart),Ectextcolor,Lcolor)and(Lcolor<>Clnone) then begin
					Canvas.Font.Color:=Lcolor;
				end;
			end;
			Canvas.Fillrect(Arect);
		end;
	end;
end;

procedure TSGCustomGrid1.Drawcellbackground(const Arect:TRect;Acolor:TColor;AState:TGridDrawState;ACol,ARow:integer);
const
	Cfixedstates: array [Boolean,Boolean] of Tthemedgrid=((Tgfixedcellnormal,Tgfixedcellpressed),
		(Tgfixedcellhot,Tgfixedcellpressed));
	Cfixedgradientstates: array [Boolean,Boolean] of Tthemedgrid=((Tggradientfixedcellnormal,Tggradientfixedcellpressed),
		(Tggradientfixedcellhot,Tggradientfixedcellpressed));
	Cfixedclassicstates: array [Boolean,Boolean] of Tthemedgrid=((Tgclassicfixedcellnormal,Tgclassicfixedcellpressed),
		(Tgclassicfixedcellhot,Tgclassicfixedcellpressed));
	Cnormalstates: array [Boolean] of Tthemedgrid=(Tgcellnormal,Tgcellselected);
	Cnormalgradientstates: array [Boolean] of Tthemedgrid=(Tggradientcellnormal,Tggradientcellselected);
	Cnormalclassicstates: array [Boolean] of Tthemedgrid=(Tgclassiccellnormal,Tgclassiccellselected);
var
	Lstyle:Tcustomstyleservices;
	Lrect,Cliprect:TRect;
	Ldetails:Tthemedelementdetails;
	Lcolor,Lendcolor,Lstartcolor:TColor;
	Saveindex:integer;
begin
	Lrect:=Arect;
	Lstyle:=Styleservices;
	if (FInternalDrawingStyle=GdsThemed)and(GDFixed in AState) then begin
		Cliprect:=Lrect;
		Inc(Lrect.Bottom);
		Inc(Lrect.Right);

		if Tstylemanager.Iscustomstyleactive and Userighttoleftalignment then Offsetrect(Lrect,1,0);

		Ldetails:=Lstyle.Getelementdetails(Cfixedstates[(GDHotTrack in AState),(GDPressed in AState)]);
		Saveindex:=Savedc(Canvas.Handle);
		try Lstyle.Drawelement(Canvas.Handle,Ldetails,Lrect,Cliprect);
		finally Restoredc(Canvas.Handle,Saveindex);
		end;

		Canvas.Brush.Style:=Bsclear;

		if Lstyle.Getelementcolor(Ldetails,Ectextcolor,Lcolor)and(Lcolor<>Clnone) then Canvas.Font.Color:=Lcolor;
	end else begin
		if (FInternalDrawingStyle=GdsGradient)and(GDFixed in AState) then begin
			if not(GoFixedVertLine in Options) then Inc(Lrect.Right);
			if not(GoFixedHorzLine in Options) then Inc(Lrect.Bottom);

			if (GDHotTrack in AState)or(GDPressed in AState) then begin
				if (GDPressed in AState) then begin
					Lstartcolor:=FGradientEndColor;
					Lendcolor:=FGradientStartColor;
				end else begin
					Lstartcolor:=Gethighlightcolor(FGradientStartColor);
					Lendcolor:=Gethighlightcolor(FGradientEndColor);
				end;
			end else begin
				Lstartcolor:=FGradientStartColor;
				Lendcolor:=FGradientEndColor;
			end;

			if Lstyle.Enabled then begin
				Ldetails:=Lstyle.Getelementdetails(Cfixedgradientstates[(GDHotTrack in AState),(GDPressed in AState)]);
				if Lstyle.Getelementcolor(Ldetails,Ecgradientcolor1,Lcolor)and(Lcolor<>Clnone) then Lstartcolor:=Lcolor;
				if Lstyle.Getelementcolor(Ldetails,Ecgradientcolor2,Lcolor)and(Lcolor<>Clnone) then Lendcolor:=Lcolor;
				if Lstyle.Getelementcolor(Ldetails,Ectextcolor,Lcolor)and(Lcolor<>Clnone) then Canvas.Font.Color:=Lcolor;
			end;

			Gradientfillcanvas(Canvas,Lstartcolor,Lendcolor,Lrect,Gdvertical);
			Canvas.Brush.Style:=Bsclear;
		end else begin
			if Lstyle.Enabled then begin
				case FInternalDrawingStyle of
					GDsClassic: if (GDFixed in AState) then
								Ldetails:=Lstyle.Getelementdetails(Cfixedclassicstates[(GDHotTrack in AState),(GDPressed in AState)])
						else Ldetails:=Lstyle.Getelementdetails(Cnormalclassicstates[(GDSelected in AState)and
								(GoDrawFocusSelected in FOptions)]);
					GdsThemed:
						Ldetails:=Lstyle.Getelementdetails
							(Cnormalstates[(GDSelected in AState)and(GoDrawFocusSelected in FOptions)]);
					GdsGradient:
						Ldetails:=Lstyle.Getelementdetails(Cnormalgradientstates[(GDSelected in AState)and
							(GoDrawFocusSelected in FOptions)]);
				end;
				if Seclient in StyleElements then
					if Lstyle.Getelementcolor(Ldetails,Ecfillcolor,Lcolor)and(Lcolor<>Clnone) then Acolor:=Lcolor;
			end;
			Canvas.Brush.Color:=Acolor;
			Canvas.Fillrect(Lrect);
			if (GDPressed in AState) then begin
				if Tstylemanager.Iscustomstyleactive then begin
					Drawstyleedge(Canvas,Lrect,[Eesunkeninner],[Eftopleft]);
					Drawstyleedge(Canvas,Lrect,[Eesunkeninner],[Efbottomright]);
				end else begin
					Dec(Lrect.Right);
					Dec(Lrect.Bottom);
					Drawedge(Canvas.Handle,Lrect,Bdr_sunkeninner,Bf_topleft);
					Drawedge(Canvas.Handle,Lrect,Bdr_sunkeninner,Bf_bottomright);
				end;
				Canvas.Brush.Style:=Bsclear;
			end;
			if Lstyle.Enabled then begin
				if (Sefont in StyleElements)and Lstyle.Getelementcolor(Ldetails,Ectextcolor,Lcolor)and(Lcolor<>Clnone) then
						Canvas.Font.Color:=Lcolor;
			end;
		end;
	end;
end;

procedure TSGCustomGrid1.DrawMove;
var
	Oldpen:Tpen;
	Pos:integer;
	R:TRect;
begin
	Oldpen:=Tpen.Create;
	try
		with Canvas do begin
			Oldpen.Assign(Pen);
			try
				Pen.Style:=Psdot;
				Pen.Mode:=Pmxor;
				Pen.Width:=5;
				if FGridState=GSRowMoving then begin
					R:=Cellrect(0,Fmovepos);
					if Fmovepos>FMoveIndex then Pos:=R.Bottom
					else Pos:=R.Top;
					Moveto(0,Pos);
					Lineto(Clientwidth,Pos);
				end else begin
					R:=Cellrect(Fmovepos,0);
					if Fmovepos>FMoveIndex then
						if not Userighttoleftalignment then Pos:=R.Right
						else Pos:=R.Left
					else if not Userighttoleftalignment then Pos:=R.Left
					else Pos:=R.Right;
					Moveto(Pos,0);
					Lineto(Pos,Clientheight);
				end;
			finally Canvas.Pen:=Oldpen;
			end;
		end;
	finally Oldpen.Free;
	end;
end;

procedure TSGCustomGrid1.Fixedcellclick(ACol,ARow:integer);
begin
	if Assigned(FOnFixedCellClick) then FOnFixedCellClick(Self,ACol,ARow);
end;

procedure TSGCustomGrid1.Focuscell(ACol,ARow:Longint;MoveAnchor:Boolean);
begin
	MoveCurrent(ACol,ARow,MoveAnchor,True);
	UpdateEdit;
	Click;
end;

procedure TSGCustomGrid1.GridRectToScreenRect(Gridrect:TGridRect;var Screenrect:TRect;Includeline:Boolean);

	function Linepos(const Axisinfo:TGridAxisDrawInfo;Line:integer):integer;
	var
		Start,I:Longint;
	begin
		with Axisinfo do begin
			Result:=0;
			if Line<FixedCellCount then Start:=0
			else begin
				if Line>=FirstGridCell then Result:=FixedBoundary;
				Start:=FirstGridCell;
			end;
			for I:=Start to Line-1 do begin
				Inc(Result,Axisinfo.GetExtent(I)+EffectiveLineWidth);
				if Result>GridExtent then begin
					Result:=0;
					Exit;
				end;
			end;
		end;
	end;

	function Calcaxis(const Axisinfo:TGridAxisDrawInfo;Gridrectmin,Gridrectmax:integer;
		var Screenrectmin,Screenrectmax:integer):Boolean;
	begin
		Result:=False;
		with Axisinfo do begin
			if (Gridrectmin>=FixedCellCount)and(Gridrectmin<FirstGridCell) then
				if Gridrectmax<FirstGridCell then begin
					Screenrect:=Rect(0,0,0,0); { erase partial results }
					Exit;
				end
				else Gridrectmin:=FirstGridCell;
			if Gridrectmax>LastFullVisibleCell then begin
				Gridrectmax:=LastFullVisibleCell;
				if Gridrectmax<GridCellCount-1 then Inc(Gridrectmax);
				if Linepos(Axisinfo,Gridrectmax)=0 then Dec(Gridrectmax);
			end;

			Screenrectmin:=Linepos(Axisinfo,Gridrectmin);
			Screenrectmax:=Linepos(Axisinfo,Gridrectmax);
			if Screenrectmax=0 then Screenrectmax:=Screenrectmin;
			Inc(Screenrectmax,Axisinfo.GetExtent(Gridrectmax));
			if Screenrectmax>GridExtent then Screenrectmax:=GridExtent;
			if Includeline then Inc(Screenrectmax,EffectiveLineWidth);
		end;
		Result:=True;
	end;

var
	Drawinfo:TGridDrawInfo;
	Hold:integer;
begin
	Screenrect:=Rect(0,0,0,0);
	if (Gridrect.Left>Gridrect.Right)or(Gridrect.Top>Gridrect.Bottom) then Exit;
	CalcDrawInfo(Drawinfo);
	with Drawinfo do begin
		if Gridrect.Left>Horz.LastFullVisibleCell+1 then Exit;
		if Gridrect.Top>Vert.LastFullVisibleCell+1 then Exit;

		if Calcaxis(Horz,Gridrect.Left,Gridrect.Right,Screenrect.Left,Screenrect.Right) then begin
			Calcaxis(Vert,Gridrect.Top,Gridrect.Bottom,Screenrect.Top,Screenrect.Bottom);
		end;
	end;
	if Userighttoleftalignment and(Canvas.Canvasorientation=Colefttoright) then begin
		Hold:=Screenrect.Left;
		Screenrect.Left:=Clientwidth-Screenrect.Right;
		Screenrect.Right:=Clientwidth-Hold;
	end;
end;

procedure TSGCustomGrid1.Initialize;
begin
	FTopLeft.X:=Fixedcols;
	FTopLeft.Y:=Fixedrows;
	FCurrent:=FTopLeft;
	FAnchor:=FCurrent;
	if GoRowSelect in Options then FAnchor.X:=Colcount-1;
end;

procedure TSGCustomGrid1.Invalidatecell(ACol,ARow:Longint);
var
	Rect:TGridRect;
begin
	Rect.Top:=ARow;
	Rect.Left:=ACol;
	Rect.Bottom:=ARow;
	Rect.Right:=ACol;
	InvalidateRect(Rect);
end;

procedure TSGCustomGrid1.Invalidatecol(ACol:Longint);
var
	Rect:TGridRect;
begin
	if not Handleallocated then Exit;
	Rect.Top:=0;
	Rect.Left:=ACol;
	Rect.Bottom:=VisibleRowCount+1;
	Rect.Right:=ACol;
	InvalidateRect(Rect);
end;

procedure TSGCustomGrid1.Invalidaterow(ARow:Longint);
var
	Rect:TGridRect;
begin
	if not Handleallocated then Exit;
	Rect.Top:=ARow;
	Rect.Left:=0;
	Rect.Bottom:=ARow;
	Rect.Right:=VisibleColCount+1;
	InvalidateRect(Rect);
end;

procedure TSGCustomGrid1.Invalidategrid;
begin
	Invalidate;
end;

procedure TSGCustomGrid1.InvalidateRect(Arect:TGridRect);
var
	Invalidrect:TRect;
begin
	if not Handleallocated then Exit;
	GridRectToScreenRect(Arect,Invalidrect,True);
	Winapi.Windows.InvalidateRect(Handle,Invalidrect,False);
end;

function TSGCustomGrid1.Istouchpropertystored(Aproperty:Ttouchproperty):Boolean;
begin
	Result:=inherited Istouchpropertystored(Aproperty);
	case Aproperty of
		Tpinteractivegestures:Result:=Touch.Interactivegestures<>[Igpan,Igpressandtap];
		Tpinteractivegestureoptions:
			Result:=Touch.Interactivegestureoptions<>[Igopaninertia,Igopansinglefingerhorizontal,Igopansinglefingervertical,
				Igopangutter,Igoparentpassthrough];
	end;
end;

procedure TSGCustomGrid1.Modifyscrollbar(Scrollbar,Scrollcode,Pos:Cardinal;Userighttoleft:Boolean);
var
	Newtopleft,Maxtopleft:TGridCoord;
	Drawinfo:TGridDrawInfo;
	Rtlfactor:integer;

	function Min:Longint;
	begin
		if Scrollbar=Sb_horz then Result:=Fixedcols
		else Result:=Fixedrows;
	end;

	function Max:Longint;
	begin
		if Scrollbar=Sb_horz then Result:=Maxtopleft.X
		else Result:=Maxtopleft.Y;
	end;

	function Pageup:Longint;
	var
		Maxtopleft:TGridCoord;
	begin
		Maxtopleft:=CalcMaxTopLeft(FTopLeft,Drawinfo);
		if Scrollbar=Sb_horz then Result:=FTopLeft.X-Maxtopleft.X
		else Result:=FTopLeft.Y-Maxtopleft.Y;
		if Result<1 then Result:=1;
	end;

	function Pagedown:Longint;
	var
		Drawinfo:TGridDrawInfo;
	begin
		CalcDrawInfo(Drawinfo);
		with Drawinfo do
			if Scrollbar=Sb_horz then Result:=Horz.LastFullVisibleCell-FTopLeft.X
			else Result:=Vert.LastFullVisibleCell-FTopLeft.Y;
		if Result<1 then Result:=1;
	end;

	function Calcscrollbar(Value,Artlfactor:Longint):Longint;
	begin
		Result:=Value;
		case Scrollcode of
			Sb_lineup:Dec(Result,Artlfactor);
			Sb_linedown:Inc(Result,Artlfactor);
			Sb_pageup:Dec(Result,Pageup*Artlfactor);
			Sb_pagedown:Inc(Result,Pagedown*Artlfactor);
			Sb_thumbposition,Sb_thumbtrack: if (GoThumbTracking in Options)or(Scrollcode=Sb_thumbposition) then begin
{$IF DEFINED(CLR)}
					if (not Userighttoleftalignment)or(Artlfactor=1) then Result:=Min+Muldiv(Pos,Max-Min,Maxshortint)
					else Result:=Max-Muldiv(Pos,Max-Min,Maxshortint);
{$ELSE}
					if (not Userighttoleftalignment)or(Artlfactor=1) then Result:=Min+Longmuldiv(Pos,Max-Min,Maxshortint)
					else Result:=Max-Longmuldiv(Pos,Max-Min,Maxshortint);
{$ENDIF}
				end;
			Sb_bottom:Result:=Max;
			Sb_top:Result:=Min;
		end;
	end;

	procedure Modifypixelscrollbar(Code,Pos:Cardinal);
	var
		Newoffset:integer;
		Oldoffset:integer;
		R:TGridRect;
		Gridspace,Colwidth:integer;
	begin
		Newoffset:=FColOffset;
		Colwidth:=Colwidths[Drawinfo.Horz.FirstGridCell];
		Gridspace:=Clientwidth-Drawinfo.Horz.FixedBoundary;
		case Code of
			Sb_lineup:Dec(Newoffset,Canvas.Textwidth('0')*Rtlfactor);
			Sb_linedown:Inc(Newoffset,Canvas.Textwidth('0')*Rtlfactor);
			Sb_pageup:Dec(Newoffset,Gridspace*Rtlfactor);
			Sb_pagedown:Inc(Newoffset,Gridspace*Rtlfactor);
			Sb_thumbposition,Sb_thumbtrack: if (GoThumbTracking in Options)or(Code=Sb_thumbposition) then begin
					if not Userighttoleftalignment then Newoffset:=Pos
					else Newoffset:=Max-integer(Pos);
				end;
			Sb_bottom:Newoffset:=0;
			Sb_top:Newoffset:=Colwidth-Gridspace;
		end;
		if Newoffset<0 then Newoffset:=0
		else if Newoffset>=Colwidth-Gridspace then Newoffset:=Colwidth-Gridspace;
		if Newoffset<>FColOffset then begin
			Oldoffset:=FColOffset;
			FColOffset:=Newoffset;
			Scrolldata(Oldoffset-Newoffset,0);
{$IF DEFINED(CLR)}
			R:=Rect(0,0,0,0);
{$ELSE}
			Fillchar(R,Sizeof(R),0);
{$ENDIF}
			R.Bottom:=Fixedrows;
			InvalidateRect(R);
			Update;
			UpdateScrollPos;
		end;
	end;

var
	Temp:Longint;
begin
	if (not Userighttoleftalignment)or(not Userighttoleft) then Rtlfactor:=1
	else Rtlfactor:=-1;
	if Visible and Canfocus and TabsTop and not(Csdesigning in Componentstate) then Setfocus;
	CalcDrawInfo(Drawinfo);
	if (Scrollbar=Sb_horz)and(Colcount=1) then begin
		Modifypixelscrollbar(Scrollcode,Pos);
		Exit;
	end;
	Maxtopleft.X:=Colcount-1;
	Maxtopleft.Y:=RowCount-1;
	Maxtopleft:=CalcMaxTopLeft(Maxtopleft,Drawinfo);
	Newtopleft:=FTopLeft;
	if Scrollbar=Sb_horz then
		repeat
			Temp:=Newtopleft.X;
			Newtopleft.X:=Calcscrollbar(Newtopleft.X,Rtlfactor);
		until (Newtopleft.X<=Fixedcols)or(Newtopleft.X>=Maxtopleft.X)or(Colwidths[Newtopleft.X]>0)or(Temp=Newtopleft.X)
	else
		repeat
			Temp:=Newtopleft.Y;
			Newtopleft.Y:=Calcscrollbar(Newtopleft.Y,1);
		until (Newtopleft.Y<=Fixedrows)or(Newtopleft.Y>=Maxtopleft.Y)or(Rowheights[Newtopleft.Y]>0)or(Temp=Newtopleft.Y);
	Newtopleft.X:=System.Math.Max(Fixedcols,System.Math.Min(Maxtopleft.X,Newtopleft.X));
	Newtopleft.Y:=System.Math.Max(Fixedrows,System.Math.Min(Maxtopleft.Y,Newtopleft.Y));
	if (Newtopleft.X<>FTopLeft.X)or(Newtopleft.Y<>FTopLeft.Y) then MoveTopLeft(Newtopleft.X,Newtopleft.Y);
end;

procedure TSGCustomGrid1.MoveAdjust(var Cellpos:Longint;FromIndex,ToIndex:Longint);
var
	Min,Max:Longint;
begin
	if Cellpos=FromIndex then Cellpos:=ToIndex
	else begin
		Min:=FromIndex;
		Max:=ToIndex;
		if FromIndex>ToIndex then begin
			Min:=ToIndex;
			Max:=FromIndex;
		end;
		if (Cellpos>=Min)and(Cellpos<=Max) then
			if FromIndex>ToIndex then Inc(Cellpos)
			else Dec(Cellpos);
	end;
end;

procedure TSGCustomGrid1.MoveAnchor(const Newanchor:TGridCoord);
var
	Oldsel:TGridRect;
begin
	if [GoRangeSelect]*Options=[GoRangeSelect] then begin // ,GoEditing
		Oldsel:=Selection;
		FAnchor:=Newanchor;
		if GoRowSelect in Options then FAnchor.X:=Colcount-1;
		ClampInView(Newanchor);
		Selectionmoved(Oldsel);
	end
	else MoveCurrent(Newanchor.X,Newanchor.Y,True,True);
end;

function TSGCustomGrid1.VisibleCol(ACol:integer):Boolean;
begin
	Result:=True;
end;

procedure TSGCustomGrid1.MoveCurrent(ACol,ARow:Longint;MoveAnchor,Show:Boolean);
label
	GG;
var
	Oldsel:TGridRect;
	Oldcurrent:TGridCoord;
	I:integer;
	FD:Boolean;
begin
	if (ACol<0)or(ARow<0)or(ACol>=Colcount)or(ARow>=RowCount) then Invalidop(Sindexoutofrange);
	if (ACol>Fixedcols-1)or(ARow>Fixedrows-1)or(ACol<Colcount)or(ARow<RowCount) then begin
		if (FCurrent.Y=ARow)and(FCurrent.X<ACol) then FD:=True;
		if (FCurrent.Y=ARow)and(FCurrent.X>ACol) then FD:=False;
		if (FCurrent.Y>ARow)and(FCurrent.X=ACol) then FD:=True;
		if (FCurrent.Y<ARow)and(FCurrent.X=ACol) then FD:=False;
		if (FCurrent.Y<ARow)and(FCurrent.X<ACol) then FD:=False;
		if (FCurrent.Y>ARow)and(FCurrent.X>ACol) then FD:=True;
		if (FCurrent.Y>ARow)and(FCurrent.X<ACol) then FD:=False;
		if (FCurrent.Y<ARow)and(FCurrent.X>ACol) then FD:=True;
		if not VisibleCol(ACol) then
			if FD then begin
				for I:=Fixedcols to Colcount-1 do begin
					if (ACol=Colcount-1) then begin
						if (ARow<RowCount-1) then Inc(ARow)
						else ARow:=Fixedrows;
						ACol:=Fixedcols;
					end
					else Inc(ACol);
					if VisibleCol(ACol) then begin
						ACol:=ACol;
						Break;
					end;
					APPLICATION.ProcessMessages;
				end;
			end
			else
				for I:=Colcount-1 downto Fixedcols do begin
					if (ACol=Fixedcols) then begin
						if (ARow>Fixedrows) then Dec(ARow)
						else ARow:=RowCount-1;
						ACol:=Colcount-1;
					end
					else Dec(ACol);
					if VisibleCol(ACol) then begin
						ACol:=ACol;
						Break;
					end;
					APPLICATION.ProcessMessages;
				end;
	end;
	if Selectcell(ACol,ARow) then begin
		Oldsel:=Selection;
		Oldcurrent:=FCurrent;
		FCurrent.X:=ACol;
		FCurrent.Y:=ARow;
		if not(GoAlwaysShowEditor in Options) then Hideeditor;
		if MoveAnchor or not(GoRangeSelect in Options) then begin
			FAnchor:=FCurrent;
			if GoRowSelect in Options then FAnchor.X:=Colcount-1;
		end;
		if GoRowSelect in Options then FCurrent.X:=Fixedcols;
		if Show then ClampInView(FCurrent);
		Selectionmoved(Oldsel);
		with Oldcurrent do Invalidatecell(X,Y);
		with FCurrent do Invalidatecell(ACol,ARow);
	end;
end;

procedure TSGCustomGrid1.MoveTopLeft(Aleft,Atop:Longint);
var
	Oldtopleft:TGridCoord;
begin
	if (Aleft=FTopLeft.X)and(Atop=FTopLeft.Y) then Exit;
	Update;
	Oldtopleft:=FTopLeft;
	FTopLeft.X:=Aleft;
	FTopLeft.Y:=Atop;
	TopLeftMoved(Oldtopleft);
end;

procedure TSGCustomGrid1.ReSizeCol(Index:Longint;Oldsize,Newsize:integer);
begin
	Invalidategrid;
end;

procedure TSGCustomGrid1.ResizeRow(Index:Longint;Oldsize,Newsize:integer);
begin
	Invalidategrid;
end;

procedure TSGCustomGrid1.Selectionmoved(const Oldsel:TGridRect);
var
	Oldrect,Newrect:TRect;
	Axorrects:Txorrects;
	I:integer;
begin
	if not Handleallocated then Exit;
	GridRectToScreenRect(Oldsel,Oldrect,True);
	GridRectToScreenRect(Selection,Newrect,True);
	XorRects(Oldrect,Newrect,Axorrects);
	for I:=low(Axorrects) to high(Axorrects) do Winapi.Windows.InvalidateRect(Handle,Axorrects[I],False);
	for I:=TopRow to TopRow+VisibleRowCount+2 do Invalidatecell(0,I);
	for I:=LeftCol to LeftCol+VisibleColCount+2 do Invalidatecell(I,0);
end;

procedure TSGCustomGrid1.ScrollDataInfo(Dx,Dy:integer;var Drawinfo:TGridDrawInfo);
var
	Scrollarea:TRect;
	Scrollflags:integer;
begin
	with Drawinfo do begin
		Scrollflags:=Sw_invalidate;
		if not Defaultdrawing then Scrollflags:=Scrollflags or Sw_erase;
		{ Scroll the area }
		if Dy=0 then begin
			{ Scroll both the column titles and data area at the same time }
			if not Userighttoleftalignment then Scrollarea:=Rect(Horz.FixedBoundary,0,Horz.GridExtent,Vert.GridExtent)
			else begin
				Scrollarea:=Rect(Clientwidth-Horz.GridExtent,0,Clientwidth-Horz.FixedBoundary,Vert.GridExtent);
				Dx:=-Dx;
			end;
			Scrollwindowex(Handle,Dx,0,Scrollarea,Scrollarea,0,nil,Scrollflags);
		end else if Dx=0 then begin
			{ Scroll both the row titles and data area at the same time }
			Scrollarea:=Rect(0,Vert.FixedBoundary,Horz.GridExtent,Vert.GridExtent);
			Scrollwindowex(Handle,0,Dy,Scrollarea,Scrollarea,0,nil,Scrollflags);
		end else begin
			{ Scroll titles and data area separately }
			{ Column titles }
			Scrollarea:=Rect(Horz.FixedBoundary,0,Horz.GridExtent,Vert.FixedBoundary);
			Scrollwindowex(Handle,Dx,0,Scrollarea,Scrollarea,0,nil,Scrollflags);
			{ Row titles }
			Scrollarea:=Rect(0,Vert.FixedBoundary,Horz.FixedBoundary,Vert.GridExtent);
			Scrollwindowex(Handle,0,Dy,Scrollarea,Scrollarea,0,nil,Scrollflags);
			{ Data area }
			Scrollarea:=Rect(Horz.FixedBoundary,Vert.FixedBoundary,Horz.GridExtent,Vert.GridExtent);
			Scrollwindowex(Handle,Dx,Dy,Scrollarea,Scrollarea,0,nil,Scrollflags);
		end;
	end;
	if GoRowSelect in Options then InvalidateRect(Selection);
end;

procedure TSGCustomGrid1.Scrolldata(Dx,Dy:integer);
var
	Drawinfo:TGridDrawInfo;
begin
	CalcDrawInfo(Drawinfo);
	ScrollDataInfo(Dx,Dy,Drawinfo);
end;

procedure TSGCustomGrid1.TopLeftMoved(const Oldtopleft:TGridCoord);

	function Calcscroll(const Axisinfo:TGridAxisDrawInfo;Oldpos,Currentpos:integer;var Amount:Longint):Boolean;
	var
		Start,Stop:Longint;
		I:Longint;
	begin
		Result:=False;
		with Axisinfo do begin
			if Oldpos<Currentpos then begin
				Start:=Oldpos;
				Stop:=Currentpos;
			end else begin
				Start:=Currentpos;
				Stop:=Oldpos;
			end;
			Amount:=0;
			for I:=Start to Stop-1 do begin
				Inc(Amount,Axisinfo.GetExtent(I)+EffectiveLineWidth);
				if Amount>(GridBoundary-FixedBoundary) then begin
					{ Scroll amount too big, redraw the whole thing }
					Invalidategrid;
					Exit;
				end;
			end;
			if Oldpos<Currentpos then Amount:=-Amount;
		end;
		Result:=True;
	end;

var
	Drawinfo:TGridDrawInfo;
	Delta:TGridCoord;
begin
	UpdateScrollPos;
	CalcDrawInfo(Drawinfo);
	if Calcscroll(Drawinfo.Horz,Oldtopleft.X,FTopLeft.X,Delta.X)and Calcscroll(Drawinfo.Vert,Oldtopleft.Y,FTopLeft.Y,
		Delta.Y) then ScrollDataInfo(Delta.X,Delta.Y,Drawinfo);
	Topleftchanged;
end;

procedure TSGCustomGrid1.UpdateScrollPos;
var
	Drawinfo:TGridDrawInfo;
	Maxtopleft:TGridCoord;
	Gridspace,Colwidth:integer;

	procedure Setscroll(Code:Word;Value:integer);
	begin
		if Userighttoleftalignment and(Code=Sb_horz) then
			if Colcount<>1 then Value:=Maxshortint-Value
			else Value:=(Colwidth-Gridspace)-Value;
		if Getscrollpos(Handle,Code)<>Value then Setscrollpos(Handle,Code,Value,True);
	end;

begin
	if (not Handleallocated)or(ScrollBars=Ssnone) then Exit;
	CalcDrawInfo(Drawinfo);
	Maxtopleft.X:=Colcount-1;
	Maxtopleft.Y:=RowCount-1;
	Maxtopleft:=CalcMaxTopLeft(Maxtopleft,Drawinfo);
	if ScrollBars in [Sshorizontal,ssBoth] then
		if Colcount=1 then begin
			Colwidth:=Colwidths[Drawinfo.Horz.FirstGridCell];
			Gridspace:=Clientwidth-Drawinfo.Horz.FixedBoundary;
			if (FColOffset>0)and(Gridspace>(Colwidth-FColOffset)) then
					Modifyscrollbar(Sb_horz,Sb_thumbposition,Colwidth-Gridspace,True)
			else Setscroll(Sb_horz,FColOffset)
		end
		else
{$IF DEFINED(CLR)}
				Setscroll(Sb_horz,Muldiv(FTopLeft.X-Fixedcols,Maxshortint,Maxtopleft.X-Fixedcols));
	if ScrollBars in [Ssvertical,ssBoth] then
			Setscroll(Sb_vert,Muldiv(FTopLeft.Y-Fixedrows,Maxshortint,Maxtopleft.Y-Fixedrows));
{$ELSE}
				Setscroll(Sb_horz,Longmuldiv(FTopLeft.X-Fixedcols,Maxshortint,Maxtopleft.X-Fixedcols));
	if ScrollBars in [Ssvertical,ssBoth] then
			Setscroll(Sb_vert,Longmuldiv(FTopLeft.Y-Fixedrows,Maxshortint,Maxtopleft.Y-Fixedrows));
{$ENDIF}
end;

procedure TSGCustomGrid1.UpdateScrollRange;
var
	Maxtopleft,Oldtopleft:TGridCoord;
	Drawinfo:TGridDrawInfo;
	Oldscrollbars:System.Uitypes.TScrollStyle;
	Updated:Boolean;

	procedure Doupdate;
	begin
		if not Updated then begin
			Update;
			Updated:=True;
		end;
	end;

	function Scrollbarvisible(Code:Word):Boolean;
	var
		Min,Max:integer;
	begin
		Result:=False;
		if (ScrollBars=ssBoth)or((Code=Sb_horz)and(ScrollBars=Sshorizontal))or((Code=Sb_vert)and(ScrollBars=Ssvertical))
		then begin
			Getscrollrange(Handle,Code,Min,Max);
			Result:=Min<>Max;
		end;
	end;

	procedure Calcsizeinfo;
	begin
		CalCDrawInfoXY(Drawinfo,Drawinfo.Horz.GridExtent,Drawinfo.Vert.GridExtent);
		Maxtopleft.X:=Colcount-1;
		Maxtopleft.Y:=RowCount-1;
		Maxtopleft:=CalcMaxTopLeft(Maxtopleft,Drawinfo);
	end;

	procedure Setaxisrange(var Max,Old,Current:Longint;Code:Word;Fixeds:integer);
	begin
		Calcsizeinfo;
		if Fixeds<Max then Setscrollrange(Handle,Code,0,Maxshortint,True)
		else Setscrollrange(Handle,Code,0,0,True);
		if Old>Max then begin
			Doupdate;
			Current:=Max;
		end;
	end;

	procedure Sethorzrange;
	var
		Range:integer;
	begin
		if Oldscrollbars in [Sshorizontal,ssBoth] then
			if Colcount=1 then begin
				Range:=Colwidths[0]-Clientwidth;
				if Range<0 then Range:=0;
				Setscrollrange(Handle,Sb_horz,0,Range,True);
			end
			else Setaxisrange(Maxtopleft.X,Oldtopleft.X,FTopLeft.X,Sb_horz,Fixedcols);
	end;

	procedure Setvertrange;
	begin
		if Oldscrollbars in [Ssvertical,ssBoth] then Setaxisrange(Maxtopleft.Y,Oldtopleft.Y,FTopLeft.Y,Sb_vert,Fixedrows);
	end;

begin
	if (ScrollBars=Ssnone)or not Handleallocated or not Showing then Exit;
	with Drawinfo do begin
		Horz.GridExtent:=Clientwidth;
		Vert.GridExtent:=Clientheight;
		{ Ignore scroll bars for initial calculation }
		if Scrollbarvisible(Sb_horz) then Inc(Vert.GridExtent,Getsystemmetrics(Sm_cyhscroll));
		if Scrollbarvisible(Sb_vert) then Inc(Horz.GridExtent,Getsystemmetrics(Sm_cxvscroll));
	end;
	Oldtopleft:=FTopLeft;
	{ Temporarily mark us as not having scroll bars to avoid recursion }
	Oldscrollbars:=FScrollBars;
	FScrollBars:=Ssnone;
	Updated:=False;
	try
		{ Update ScrollBars }
		Sethorzrange;
		Drawinfo.Vert.GridExtent:=Clientheight;
		Setvertrange;
		if Drawinfo.Horz.GridExtent<>Clientwidth then begin
			Drawinfo.Horz.GridExtent:=Clientwidth;
			Sethorzrange;
		end;
	finally FScrollBars:=Oldscrollbars;
	end;
	UpdateScrollPos;
	if (FTopLeft.X<>Oldtopleft.X)or(FTopLeft.Y<>Oldtopleft.Y) then TopLeftMoved(Oldtopleft);
end;

function TSGCustomGrid1.CreateEditor:TSGInplaceEdit1;
begin
	Result:=TSGInplaceEdit1.Create(Self);
end;

procedure TSGCustomGrid1.CreateParams(var Params:Tcreateparams);
begin
	inherited CreateParams(Params);
	with Params do begin
		Style:=Style or Ws_tabstop;
		if FScrollBars in [Ssvertical,ssBoth] then Style:=Style or Ws_vscroll;
		if FScrollBars in [Sshorizontal,ssBoth] then Style:=Style or Ws_hscroll;
		Windowclass.Style:=Cs_dblclks;
		if FBorderStyle=Bssingle then
			if Newstylecontrols and Ctl3d then begin
				Style:=Style and not Ws_border;
				Exstyle:=Exstyle or Ws_ex_clientedge;
			end
			else Style:=Style or Ws_border;
	end;
end;

procedure TSGCustomGrid1.CreateWND;
begin
	inherited;
	FInternalDrawingStyle:=FDrawingStyle;
	if (FDrawingStyle=GdsThemed)and not Themecontrol(Self) then FInternalDrawingStyle:=GDsClassic;
end;

procedure TSGCustomGrid1.Dogesture(const Eventinfo:TGestureEventInfo;var Handled:Boolean);
const
	Vertscrollflags: array [Boolean] of integer=(Sb_linedown,Sb_lineup);
	Horizscrollflags: array [Boolean] of integer=(Sb_lineright,Sb_lineleft);
var
	I,Lcolwidth,Lcols,Lrowheight,Lrows,Deltax,Deltay:integer;
begin
	if Eventinfo.Gestureid=Igipan then begin
		Handled:=True;
		if Gfbegin in Eventinfo.Flags then FPanPoint:=Eventinfo.Location
		else if not(Gfend in Eventinfo.Flags) then begin
			// Vertical panning
			Deltay:=Eventinfo.Location.Y-FPanPoint.Y;
			if Abs(Deltay)>1 then begin
				Lrowheight:=Rowheights[TopRow];
				Lrows:=Abs(Deltay)div Lrowheight;
				if (Abs(Deltay)mod Lrowheight=0)or(Lrows>0) then begin
					for I:=0 to Lrows-1 do Modifyscrollbar(Sb_vert,Vertscrollflags[Deltay>0],0,True);
					FPanPoint:=Eventinfo.Location;
					Inc(FPanPoint.Y,Deltay mod Lrowheight);
				end;
			end else begin
				// Horizontal panning
				Deltax:=Eventinfo.Location.X-FPanPoint.X;
				if Abs(Deltax)>1 then begin
					Lcolwidth:=Colwidths[LeftCol];
					Lcols:=Abs(Deltax)div Lcolwidth;
					if (Abs(Deltax)mod Lcolwidth=0)or(Lcols>0) then begin
						for I:=0 to Lcols-1 do Modifyscrollbar(Sb_horz,Horizscrollflags[Deltax>0],0,True);
						FPanPoint:=Eventinfo.Location;
						Inc(FPanPoint.X,Deltax mod Lcolwidth);
					end;
				end;
			end;

		end;
	end;
end;

procedure TSGCustomGrid1.KeyDown(var Key:Word;Shift:Tshiftstate);
var
	Newtopleft,Newcurrent,Maxtopleft:TGridCoord;
	Drawinfo:TGridDrawInfo;
	Pagewidth,Pageheight:integer;
	Rtlfactor:integer;
	Needsinvalidating:Boolean;
	Lposchanged:Boolean;

	procedure Calcpageextents;
	begin
		CalcDrawInfo(Drawinfo);
		Pagewidth:=Drawinfo.Horz.LastFullVisibleCell-LeftCol;
		if Pagewidth<1 then Pagewidth:=1;
		Pageheight:=Drawinfo.Vert.LastFullVisibleCell-TopRow;
		if Pageheight<1 then Pageheight:=1;
	end;

	procedure Restrict(var Coord:TGridCoord;Minx,Miny,Maxx,Maxy:Longint);
	begin
		with Coord do begin
			if X>Maxx then X:=Maxx
			else if X<Minx then X:=Minx;
			if Y>Maxy then Y:=Maxy
			else if Y<Miny then Y:=Miny;
		end;
	end;

begin
	inherited KeyDown(Key,Shift);
	if Observers.Isobserving(Tobservermapping.Editgridlinkid) then
		if (Key=Vk_delete)or((Key=Vk_insert)and(Ssshift in Shift)) then
			if Tlinkobservers.Editgridlinkedit(Observers) then Tlinkobservers.Editgridlinkmodified(Observers);

	Needsinvalidating:=False;
	if not Cangridacceptkey(Key,Shift) then Key:=0;
	if not Userighttoleftalignment then Rtlfactor:=1
	else Rtlfactor:=-1;
	Newcurrent:=FCurrent;
	Newtopleft:=FTopLeft;
	Calcpageextents;
	if Ssctrl in Shift then
		case Key of
			Vk_up:Dec(Newtopleft.Y);
			Vk_down:Inc(Newtopleft.Y);
			Vk_left: if not(GoRowSelect in Options) then begin
					Dec(Newcurrent.X,Pagewidth*Rtlfactor);
					Dec(Newtopleft.X,Pagewidth*Rtlfactor);
				end;
			Vk_right: if not(GoRowSelect in Options) then begin
					Inc(Newcurrent.X,Pagewidth*Rtlfactor);
					Inc(Newtopleft.X,Pagewidth*Rtlfactor);
				end;
			Vk_prior:Newcurrent.Y:=TopRow;
			Vk_next:Newcurrent.Y:=Drawinfo.Vert.LastFullVisibleCell;
			Vk_home:begin
					Newcurrent.X:=Fixedcols;
					Newcurrent.Y:=Fixedrows;
					Needsinvalidating:=Userighttoleftalignment;
				end;
			Vk_end:begin
					Newcurrent.X:=Colcount-1;
					Newcurrent.Y:=RowCount-1;
					Needsinvalidating:=Userighttoleftalignment;
				end;
		end
	else
		case Key of
			Vk_up:Dec(Newcurrent.Y);
			Vk_down:Inc(Newcurrent.Y);
			Vk_left: if GoRowSelect in Options then Dec(Newcurrent.Y,Rtlfactor)
				else Dec(Newcurrent.X,Rtlfactor);
			Vk_right: if GoRowSelect in Options then Inc(Newcurrent.Y,Rtlfactor)
				else Inc(Newcurrent.X,Rtlfactor);
			Vk_next:begin
					Inc(Newcurrent.Y,Pageheight);
					Inc(Newtopleft.Y,Pageheight);
				end;
			Vk_prior:begin
					Dec(Newcurrent.Y,Pageheight);
					Dec(Newtopleft.Y,Pageheight);
				end;
			Vk_home: if GoRowSelect in Options then Newcurrent.Y:=Fixedrows
				else Newcurrent.X:=Fixedcols;
			Vk_end: if GoRowSelect in Options then Newcurrent.Y:=RowCount-1
				else Newcurrent.X:=Colcount-1;
			Vk_tab: if not(Ssalt in Shift) then
					repeat
						if Ssshift in Shift then begin
							Dec(Newcurrent.X);
							if Newcurrent.X<Fixedcols then begin
								Newcurrent.X:=Colcount-1;
								Dec(Newcurrent.Y);
								if Newcurrent.Y<Fixedrows then Newcurrent.Y:=RowCount-1;
							end;
							Shift:=[];
						end else begin
							Inc(Newcurrent.X);
							if Newcurrent.X>=Colcount then begin
								Newcurrent.X:=Fixedcols;
								Inc(Newcurrent.Y);
								if Newcurrent.Y>=RowCount then Newcurrent.Y:=Fixedrows;
							end;
						end;
					until TabStops[Newcurrent.X] or(Newcurrent.X=FCurrent.X);
			Vk_f2:
				EditorMode:=True;
		end;
	Maxtopleft.X:=Colcount-1;
	Maxtopleft.Y:=RowCount-1;
	Maxtopleft:=CalcMaxTopLeft(Maxtopleft,Drawinfo);
	Restrict(Newtopleft,Fixedcols,Fixedrows,Maxtopleft.X,Maxtopleft.Y);
	if (Newtopleft.X<>LeftCol)or(Newtopleft.Y<>TopRow) then MoveTopLeft(Newtopleft.X,Newtopleft.Y);
	Restrict(Newcurrent,Fixedcols,Fixedrows,Colcount-1,RowCount-1);

	if Observers.Isobserving(Tobservermapping.Editgridlinkid) then
		if Tlinkobservers.Editgridlinkisediting(Observers) then begin
			try Tlinkobservers.Editgridlinkupdate(Observers);
			except
				Tlinkobservers.Editgridlinkreset(Observers);
				Setfocus;
				raise;
			end;
		end;

	if (Newcurrent.X<>Col)or(Newcurrent.Y<>Row) then begin
		Lposchanged:=Newcurrent.Y<>Row;
		if Lposchanged then Tlinkobservers.Positionlinkposchanging(Observers);
		Focuscell(Newcurrent.X,Newcurrent.Y,not(Ssshift in Shift));
		if Lposchanged then Tlinkobservers.Positionlinkposchanged(Observers);
	end;
	if Needsinvalidating then Invalidate;
end;

procedure TSGCustomGrid1.Keypress(var Key:Char);
begin
	inherited Keypress(Key);
	if FEditorMode and Observers.Isobserving(Tobservermapping.Editgridlinkid) then begin
		if (Key>=#32)and not Tlinkobservers.Editgridlinkisvalidchar(Observers,Key) then begin
			Messagebeep(0);
			Key:=#0;
		end;
		case Key of
			^H,^V,^X,#32.. high(Char): if not Tlinkobservers.Editgridlinkedit(Observers) then Key:=#0
				else Tlinkobservers.Editgridlinkmodified(Observers);
			#27:begin
					if Tlinkobservers.Editgridlinkisediting(Observers) then begin
						Tlinkobservers.Editgridlinkreset(Observers);
					end;
					Key:=#0;
				end;
			#$D: // vkReturn
				begin
					if Tlinkobservers.Editgridlinkisediting(Observers) then begin
						try Tlinkobservers.Editgridlinkupdate(Observers);
						except
							Tlinkobservers.Editgridlinkreset(Observers);
							Setfocus;
							raise;
						end;
					end;
				end;
		end;
	end;

	if not(GoAlwaysShowEditor in Options)and(Key=#13) then begin
		if FEditorMode then Hideeditor
		else Showeditor;
		Key:=#0;
	end;
end;

procedure TSGCustomGrid1.MouseDown(Button:Tmousebutton;Shift:Tshiftstate;X,Y:integer);
var
	Cellhit:TGridCoord;
	Drawinfo:TGridDrawInfo;
	Movedrawn:Boolean;
	Lposchanged:Boolean;
begin
	Movedrawn:=False;
	Hideedit;
	if not(Csdesigning in Componentstate)and(Canfocus or(Getparentform(Self)=nil)) then begin
		Setfocus;
		if not IsActiveControl then begin
			Mousecapture:=False;
			Exit;
		end;
	end;
	if (Button=Mbleft)and(Ssdouble in Shift) then DblClick
	else if Button=Mbleft then begin
		CalcDrawInfo(Drawinfo);
		{ Check grid sizing }
		CalcSizingState(X,Y,FGridState,FSizingIndex,FSizingPos,Fsizingofs,Drawinfo);
		if FGridState<>GSNormal then begin
			if (FGridState=GSColSizing)and Userighttoleftalignment then FSizingPos:=Clientwidth-FSizingPos;
			DrawSizingLine(Drawinfo);
			Exit;
		end;
		Cellhit:=CalCcoordFromPoint(X,Y,Drawinfo);
		if (Cellhit.X>=Fixedcols)and(Cellhit.Y>=Fixedrows) then begin
			if GoEditing in Options then begin
				FGridState:=GSSelecting; //
				if (Cellhit.X=FCurrent.X)and(Cellhit.Y=FCurrent.Y) then Showeditor
				else begin
					Lposchanged:=Cellhit.Y<>FCurrent.Y;
					if Observers.Isobserving(Tobservermapping.Editgridlinkid) then
						if Tlinkobservers.Editgridlinkisediting(Observers) then
							try Tlinkobservers.Editgridlinkupdate(Observers);
							except
								Tlinkobservers.Editgridlinkreset(Observers);
								raise;
							end;
					if Lposchanged then Tlinkobservers.Positionlinkposchanging(Observers);
					MoveCurrent(Cellhit.X,Cellhit.Y,True,True);
					UpdateEdit;
					if Lposchanged then Tlinkobservers.Positionlinkposchanged(Observers);
				end;
				Click;
			end else begin
				FGridState:=GSSelecting;
				Settimer(Handle,1,60,nil);
				if Ssshift in Shift then MoveAnchor(Cellhit)
				else begin
					if Observers.Isobserving(Tobservermapping.Editgridlinkid) then
						if Tlinkobservers.Editgridlinkisediting(Observers) then
							try Tlinkobservers.Editgridlinkupdate(Observers);
							except
								Tlinkobservers.Editgridlinkreset(Observers);
								raise;
							end;
					Lposchanged:=Cellhit.Y<>FCurrent.Y;
					if Lposchanged then Tlinkobservers.Positionlinkposchanging(Observers);
					MoveCurrent(Cellhit.X,Cellhit.Y,True,True);
					if Lposchanged then Tlinkobservers.Positionlinkposchanged(Observers);
				end;
			end;
		end else begin
			if (Fhottrackcell.Rect.Left<>-1)or(Fhottrackcell.Rect.Top<>-1) then begin
				Fhottrackcell.Pressed:=True;
				Fhottrackcell.Button:=Button;
				InvalidateRect(Fhottrackcell.Rect);
			end;

			if (GoRowMoving in Options)and(Cellhit.X>=0)and(Cellhit.X<Fixedcols)and(Cellhit.Y>=Fixedrows) then begin
				FMoveIndex:=Cellhit.Y;
				Fmovepos:=FMoveIndex;
				if Beginrowdrag(FMoveIndex,Fmovepos,Point(X,Y)) then begin
					FGridState:=GSRowMoving;
					Update;
					DrawMove;
					Movedrawn:=True;
					Settimer(Handle,1,60,nil);
				end;
			end else if (GoColMoving in Options)and(Cellhit.Y>=0)and(Cellhit.Y<Fixedrows)and(Cellhit.X>=Fixedcols) then begin
				FMoveIndex:=Cellhit.X;
				Fmovepos:=FMoveIndex;
				if Begincolumndrag(FMoveIndex,Fmovepos,Point(X,Y)) then begin
					FGridState:=GSColMoving;
					Update;
					DrawMove;
					Movedrawn:=True;
					Settimer(Handle,1,60,nil);
				end;
			end;
		end;
	end;
	try inherited MouseDown(Button,Shift,X,Y);
	except
		if Movedrawn then DrawMove;
	end;
end;

function TSGCustomGrid1.Calcexpandedcellrect(const Coord:TGridCoord):TGridRect;
begin
	Result.TopLeft:=Coord;
	Result.BottomRight:=Coord;
end;

procedure TSGCustomGrid1.MouseMove(Shift:Tshiftstate;X,Y:integer);
var
	Drawinfo:TGridDrawInfo;
	Cellhit:TGridCoord;
begin
	CalcDrawInfo(Drawinfo);
	case FGridState of
		GSSelecting,GSColMoving,GSRowMoving:begin
				Cellhit:=CalCcoordFromPoint(X,Y,Drawinfo);
				if (Cellhit.X>=Fixedcols)and(Cellhit.Y>=Fixedrows)and(Cellhit.X<=Drawinfo.Horz.LastFullVisibleCell+1)and
					(Cellhit.Y<=Drawinfo.Vert.LastFullVisibleCell+1) then
					case FGridState of
						GSSelecting: if ((Cellhit.X<>FAnchor.X)or(Cellhit.Y<>FAnchor.Y)) then MoveAnchor(Cellhit);
						GSColMoving:MoveAndScroll(X,Cellhit.X,Drawinfo,Drawinfo.Horz,Sb_horz,Point(X,Y));
						GSRowMoving:MoveAndScroll(Y,Cellhit.Y,Drawinfo,Drawinfo.Vert,Sb_vert,Point(X,Y));
					end;
			end;
		GSRowSizing,GSColSizing:begin
				DrawSizingLine(Drawinfo); { XOR it out }
				if FGridState=GSRowSizing then FSizingPos:=Y+Fsizingofs
				else FSizingPos:=X+Fsizingofs;
				DrawSizingLine(Drawinfo); { XOR it back in }
			end;
	else begin
			if (Csdesigning in Componentstate) then Exit;
			// Highlight "fixed" cell
			Cellhit:=CalCcoordFromPoint(X,Y,Drawinfo);
			if ((GoFixedRowClick in FOptions)and(Cellhit.Y<Fixedrows))or((GoFixedColClick in FOptions)and(Cellhit.X<Fixedcols))
			then begin
				if (Fhottrackcell.Rect.Left<>-1)or(Fhottrackcell.Rect.Top<>-1) then InvalidateRect(Fhottrackcell.Rect);
				if not Pointingridrect(Cellhit.X,Cellhit.Y,Fhottrackcell.Rect) then begin
					Fhottrackcell.Rect:=Calcexpandedcellrect(Cellhit);
					Fhottrackcell.Pressed:=False;
					InvalidateRect(Fhottrackcell.Rect);
				end;
			end else if (Fhottrackcell.Rect.Left<>-1)or(Fhottrackcell.Rect.Top<>-1) then begin
				InvalidateRect(Fhottrackcell.Rect);
				Fhottrackcell.Rect:=Emptyrect;
				Fhottrackcell.Pressed:=False;
			end;
		end;
	end;
	inherited MouseMove(Shift,X,Y);
end;

procedure TSGCustomGrid1.MouseUp(Button:Tmousebutton;Shift:Tshiftstate;X,Y:integer);
var
	Drawinfo:TGridDrawInfo;
	Newsize:integer;
	Cell:TGridCoord;

	function Resizeline(const Axisinfo:TGridAxisDrawInfo):integer;
	var
		I:integer;
	begin
		with Axisinfo do begin
			Result:=FixedBoundary;
			for I:=FirstGridCell to FSizingIndex-1 do Inc(Result,Axisinfo.GetExtent(I)+EffectiveLineWidth);
			Result:=FSizingPos-Result;
		end;
	end;

begin
	try
		case FGridState of
			GSSelecting:begin
					MouseMove(Shift,X,Y);
					Killtimer(Handle,1);
					UpdateEdit;
					Click;
				end;
			GSRowSizing,GSColSizing:begin
					CalcDrawInfo(Drawinfo);
					DrawSizingLine(Drawinfo);
					if (FGridState=GSColSizing)and Userighttoleftalignment then FSizingPos:=Clientwidth-FSizingPos;
					if FGridState=GSColSizing then begin
						Newsize:=Resizeline(Drawinfo.Horz);
						if Newsize>1 then begin
							Colwidths[FSizingIndex]:=Newsize;
							Updatedesigner;
						end;
					end else begin
						Newsize:=Resizeline(Drawinfo.Vert);
						if Newsize>1 then begin
							Rowheights[FSizingIndex]:=Newsize;
							Updatedesigner;
						end;
					end;
				end;
			GSColMoving:begin
					DrawMove;
					Killtimer(Handle,1);
					if Endcolumndrag(FMoveIndex,Fmovepos,Point(X,Y))and(FMoveIndex<>Fmovepos) then begin
						MoveColumn(FMoveIndex,Fmovepos);
						Updatedesigner;
					end;
					UpdateEdit;
				end;
			GSRowMoving:begin
					DrawMove;
					Killtimer(Handle,1);
					if Endrowdrag(FMoveIndex,Fmovepos,Point(X,Y))and(FMoveIndex<>Fmovepos) then begin
						MoveRow(FMoveIndex,Fmovepos);
						Updatedesigner;
					end;
					UpdateEdit;
				end;
		else UpdateEdit;
			Cell:=MouseCoord(X,Y);
			if (Button=Mbleft)and Fhottrackcell.Pressed and(Fhottrackcell.Rect.Left<>-1)and(Fhottrackcell.Rect.Top<>-1)and
				(((GoFixedColClick in FOptions)and(Cell.X<FFixedCols)and(Cell.X>=0))or
				((GoFixedRowClick in FOptions)and(Cell.Y<FFixedRows)and(Cell.Y>=0))) then Fixedcellclick(Cell.X,Cell.Y);
		end;
		inherited MouseUp(Button,Shift,X,Y);
	finally
		FGridState:=GSNormal;
		Fhottrackcell.Pressed:=False;
		InvalidateRect(Fhottrackcell.Rect);
	end;
end;

procedure TSGCustomGrid1.MoveAndScroll(Mouse,Cellhit:integer;var Drawinfo:TGridDrawInfo;var Axis:TGridAxisDrawInfo;
	Scrollbar:integer;const Mousept:TPoint);
begin
	if Userighttoleftalignment and(Scrollbar=Sb_horz) then Mouse:=Clientwidth-Mouse;
	if (Cellhit<>Fmovepos)and not((Fmovepos=Axis.FixedCellCount)and(Mouse<Axis.FixedBoundary))and
		not((Fmovepos=Axis.GridCellCount-1)and(Mouse>Axis.GridBoundary)) then begin
		DrawMove;
		// hide the drag line
		if (Mouse<Axis.FixedBoundary) then begin
			if (Fmovepos>Axis.FixedCellCount) then begin
				Modifyscrollbar(Scrollbar,Sb_lineup,0,False);
				Update;
				CalcDrawInfo(Drawinfo); // this changes contents of Axis var
			end;
			Cellhit:=Axis.FirstGridCell;
		end else if (Mouse>=Axis.FullVisBoundary) then begin
			if (Fmovepos=Axis.LastFullVisibleCell)and(Fmovepos<Axis.GridCellCount-1) then begin
				Modifyscrollbar(Scrollbar,Sb_linedown,0,False);
				Update;
				CalcDrawInfo(Drawinfo); // this changes contents of Axis var
			end;
			Cellhit:=Axis.LastFullVisibleCell;
		end else if Cellhit<0 then Cellhit:=Fmovepos;
		if ((FGridState=GSColMoving)and Checkcolumndrag(FMoveIndex,Cellhit,Mousept))or
			((FGridState=GSRowMoving)and Checkrowdrag(FMoveIndex,Cellhit,Mousept)) then Fmovepos:=Cellhit;
		DrawMove;
	end;
end;

function TSGCustomGrid1.GetColWidths(Index:Longint):integer;
begin
{$IF DEFINED(CLR)}
	if (Length(FColWidths)=0)or(index>=Colcount) then Result:=DefaultColWidth
	else Result:=FColWidths[index+1];
{$ELSE}
	if (FColWidths=nil)or(index>=Colcount) then Result:=DefaultColWidth
	else Result:=PintArray(FColWidths)^[index+1];
{$ENDIF}
end;

function TSGCustomGrid1.GetRowHeights(Index:Longint):integer;
begin
{$IF DEFINED(CLR)}
	if (Length(FRowHeights)=0)or(index>=RowCount) then Result:=DefaultRowHeight
	else Result:=FRowHeights[index+1];
{$ELSE}
	if (FRowHeights=nil)or(index>=RowCount) then Result:=DefaultRowHeight
	else Result:=PintArray(FRowHeights)^[index+1];
{$ENDIF}
end;

function TSGCustomGrid1.Getgridwidth:integer;
var
	Drawinfo:TGridDrawInfo;
begin
	CalcDrawInfo(Drawinfo);
	Result:=Drawinfo.Horz.GridBoundary;
end;

function TSGCustomGrid1.Getgridheight:integer;
var
	Drawinfo:TGridDrawInfo;
begin
	CalcDrawInfo(Drawinfo);
	Result:=Drawinfo.Vert.GridBoundary;
end;

function TSGCustomGrid1.GetSelection:TGridRect;
begin
	Result:=Gridrect(FCurrent,FAnchor);
end;

function TSGCustomGrid1.GetTabStops(Index:Longint):Boolean;
begin
{$IF DEFINED(CLR)}
	if Length(FTabStops)=0 then Result:=True
	else Result:=FTabStops[index+1]<>0;
{$ELSE}
	if FTabStops=nil then Result:=True
	else Result:=Boolean(PintArray(FTabStops)^[index+1]);
{$ENDIF}
end;

function TSGCustomGrid1.GetVisibleColCount:integer;
var
	Drawinfo:TGridDrawInfo;
begin
	CalcDrawInfo(Drawinfo);
	Result:=Drawinfo.Horz.LastFullVisibleCell-LeftCol+1;
end;

function TSGCustomGrid1.GetVisibleRowCount:integer;
var
	Drawinfo:TGridDrawInfo;
begin
	CalcDrawInfo(Drawinfo);
	Result:=Drawinfo.Vert.LastFullVisibleCell-TopRow+1;
end;

procedure TSGCustomGrid1.SetBorderStyle(Value:TBorderStyle);
begin
	if FBorderStyle<>Value then begin
		FBorderStyle:=Value;
		Recreatewnd;
	end;
end;

procedure TSGCustomGrid1.SetCol(Value:Longint);
begin
	if Col<>Value then Focuscell(Value,Row,True);
end;

procedure TSGCustomGrid1.SetColCount(Value:Longint);
begin
	if FColCount<>Value then begin
		if Value<1 then Value:=1;
		if Value<=Fixedcols then Fixedcols:=Value-1;
		ChangeSize(Value,RowCount);
		if GoRowSelect in Options then begin
			FAnchor.X:=Colcount-1;
			Invalidate;
		end;
	end;
end;

procedure TSGCustomGrid1.SetColWidths(Index:Longint;Value:integer);
begin
{$IF DEFINED(CLR)}
	if Length(FColWidths)=0 then UpdateExtents(FColWidths,Colcount,DefaultColWidth);
	if index>=Colcount then Invalidop(Sindexoutofrange);
	if Value<>FColWidths[index+1] then begin
		ReSizeCol(index,FColWidths[index+1],Value);
		FColWidths[index+1]:=Value;
		Colwidthschanged;
	end;
{$ELSE}
	if FColWidths=nil then UpdateExtents(FColWidths,Colcount,DefaultColWidth);
	if index>=Colcount then Invalidop(Sindexoutofrange);
	if Value<>PintArray(FColWidths)^[index+1] then begin
		ReSizeCol(index,PintArray(FColWidths)^[index+1],Value);
		PintArray(FColWidths)^[index+1]:=Value;
		Colwidthschanged;
	end;
{$ENDIF}
end;

procedure TSGCustomGrid1.SetDefaultColWidth(Value:integer);
begin
{$IF DEFINED(CLR)}
	if Length(FColWidths)<>0 then
{$ELSE}
	if FColWidths<>nil then
{$ENDIF}
		UpdateExtents(FColWidths,0,0);
	FDefaultColWidth:=Value;
	Colwidthschanged;
	Invalidategrid;
end;

procedure TSGCustomGrid1.SetdefaultRowHeight(Value:integer);
begin
{$IF DEFINED(CLR)}
	if Length(FRowHeights)<>0 then
{$ELSE}
	if FRowHeights<>nil then
{$ENDIF}
		UpdateExtents(FRowHeights,0,0);
	FDefaultRowHeight:=Value;
	Rowheightschanged;
	Invalidategrid;
end;

procedure TSGCustomGrid1.SetDrawingStyle(const Value:TGridDrawingStyle);
begin
	if Value<>FDrawingStyle then begin
		FDrawingStyle:=Value;
		FInternalDrawingStyle:=FDrawingStyle;
		if (FDrawingStyle=GdsThemed)and not Themecontrol(Self) then FInternalDrawingStyle:=GDsClassic;
		Repaint;
	end;
end;

procedure TSGCustomGrid1.SetFixedColor(Value:TColor);
begin
	if FFixedColor<>Value then begin
		FFixedColor:=Value;
		Invalidategrid;
	end;
end;

procedure TSGCustomGrid1.SetFixedCols(Value:integer);
begin
	if FFixedCols<>Value then begin
		if Value<0 then Invalidop(Sindexoutofrange);
		if Value>=Colcount then Invalidop(Sfixedcoltoobig);
		FFixedCols:=Value;
		Initialize;
		Invalidategrid;
	end;
end;

procedure TSGCustomGrid1.SetFixedRows(Value:integer);
begin
	if FFixedRows<>Value then begin
		if Value<0 then Invalidop(Sindexoutofrange);
		if Value>=RowCount then Invalidop(Sfixedrowtoobig);
		FFixedRows:=Value;
		Initialize;
		Invalidategrid;
	end;
end;

procedure TSGCustomGrid1.SetEditorMode(Value:Boolean);
begin
	if not Value then Hideeditor
	else begin
		Showeditor;
		if FInplaceEdit<>nil then FInplaceEdit.Deselect;
	end;
end;

procedure TSGCustomGrid1.SetGradientEndColor(Value:TColor);
begin
	if Value<>FGradientEndColor then begin
		FGradientEndColor:=Value;
		if Handleallocated then Repaint;
	end;
end;

procedure TSGCustomGrid1.SetgradientStartColor(Value:TColor);
begin
	if Value<>FGradientStartColor then begin
		FGradientStartColor:=Value;
		if Handleallocated then Repaint;
	end;
end;

procedure TSGCustomGrid1.SetGridLineWidth(Value:integer);
begin
	if FGridLineWidth<>Value then begin
		FGridLineWidth:=Value;
		Invalidategrid;
	end;
end;

procedure TSGCustomGrid1.SetLeftCol(Value:Longint);
begin
	if FTopLeft.X<>Value then MoveTopLeft(Value,TopRow);
end;

procedure TSGCustomGrid1.SetOptions(Value:TGridOptions);
begin
	if FOptions<>Value then begin
		if GoRowSelect in Value then Exclude(Value,GoAlwaysShowEditor);
		FOptions:=Value;
		if not FEditorMode then
			if GoAlwaysShowEditor in Value then Showeditor
			else Hideeditor;
		if GoRowSelect in Value then MoveCurrent(Col,Row,True,False);
		Invalidategrid;
	end;
end;

procedure TSGCustomGrid1.SetRow(Value:Longint);
begin
	if Row<>Value then Focuscell(Col,Value,True);
end;

procedure TSGCustomGrid1.SetRowCount(Value:Longint);
begin
	if FRowCount<>Value then begin
		if Value<1 then Value:=1;
		if Value<=Fixedrows then Fixedrows:=Value-1;
		ChangeSize(Colcount,Value);
	end;
end;

procedure TSGCustomGrid1.SetRowHeights(Index:Longint;Value:integer);
begin
{$IF DEFINED(CLR)}
	if Length(FRowHeights)=0 then UpdateExtents(FRowHeights,RowCount,DefaultRowHeight);
	if index>=RowCount then Invalidop(Sindexoutofrange);
	if Value<>FRowHeights[index+1] then begin
		ResizeRow(index,FRowHeights[index+1],Value);
		FRowHeights[index+1]:=Value;
		Rowheightschanged;
	end;
{$ELSE}
	if FRowHeights=nil then UpdateExtents(FRowHeights,RowCount,DefaultRowHeight);
	if index>=RowCount then Invalidop(Sindexoutofrange);
	if Value<>PintArray(FRowHeights)^[index+1] then begin
		ResizeRow(index,PintArray(FRowHeights)^[index+1],Value);
		PintArray(FRowHeights)^[index+1]:=Value;
		Rowheightschanged;
	end;
{$ENDIF}
end;

procedure TSGCustomGrid1.SetScrollBars(Value:System.Uitypes.TScrollStyle);
begin
	if FScrollBars<>Value then begin
		FScrollBars:=Value;
		Recreatewnd;
	end;
end;

procedure TSGCustomGrid1.DrawFixedCells;
var
	I:integer;
begin
	for I:=Selection.Top to Selection.Bottom do Drawcell(Fixedcols-1,I,Cellrect(Fixedcols-1,I),[GDFixed]);
	for I:=Selection.Left to Selection.Right do Drawcell(I,Fixedrows-1,Cellrect(I,Fixedrows-1),[GDFixed]);
end;

procedure TSGCustomGrid1.SetSelection(Value:TGridRect);
var
	Oldsel:TGridRect;
begin
	Oldsel:=Selection;
	FAnchor.X:=Value.Left;
	FAnchor.Y:=Value.Top;
	FCurrent.X:=Value.Right;
	FCurrent.Y:=Value.Bottom;
	Selectionmoved(Oldsel);
	// Invalidate;
end;

procedure TSGCustomGrid1.SetTabStops(Index:Longint;Value:Boolean);
begin
{$IF DEFINED(CLR)}
	if Length(FTabStops)=0 then UpdateExtents(FTabStops,Colcount,integer(True));
	if index>=Colcount then Invalidop(Sindexoutofrange);
	FTabStops[index+1]:=integer(Value);
{$ELSE}
	if FTabStops=nil then UpdateExtents(FTabStops,Colcount,integer(True));
	if index>=Colcount then Invalidop(Sindexoutofrange);
	PintArray(FTabStops)^[index+1]:=integer(Value);
{$ENDIF}
end;

procedure TSGCustomGrid1.SetTopRow(Value:Longint);
begin
	if FTopLeft.Y<>Value then MoveTopLeft(LeftCol,Value);
end;

procedure TSGCustomGrid1.Setstyleelements(const Value:Tstyleelements);
begin
	if StyleElements<>Value then begin
		inherited;
		if not Tstylemanager.Iscustomstyleactive then Invalidate;
	end;
end;

procedure TSGCustomGrid1.Hideedit;
begin
	if FInplaceEdit<>nil then
		try UpdateText;
		finally
			FInplaceCol:=-1;
			FinplaceRow:=-1;
			FInplaceEdit.NumbersOnly:=False;
			FInplaceEdit.Hide;
		end;
end;

procedure TSGCustomGrid1.UpdateEdit;

	procedure Updateeditor;
	begin
		FInplaceCol:=Col;
		FinplaceRow:=Row;
		FInplaceEdit.UpdateContents;
		if FInplaceEdit.Maxlength=-1 then FCanEditModify:=False
		else FCanEditModify:=True;
		FInplaceEdit.Color:=Self.Color;
		FInplaceEdit.Font:=Self.Font;
		FInplaceEdit.StyleElements:=StyleElements;
		FInplaceEdit.Selectall;
	end;

begin
	if Caneditshow then begin
		if FInplaceEdit=nil then begin
			FInplaceEdit:=CreateEditor;
			FInplaceEdit.SetGrid(Self);
			FInplaceEdit.Parent:=Self;
			Updateeditor;
		end else begin
			if (Col<>FInplaceCol)or(Row<>FinplaceRow) then begin
				Hideedit;
				Updateeditor;
			end;
		end;
		if Caneditshow then FInplaceEdit.Move(Cellrect(Col,Row));
	end;
end;

procedure TSGCustomGrid1.UpdateText;
begin
	if (FInplaceCol<>-1)and(FinplaceRow<>-1) then SetEditText(FInplaceCol,FinplaceRow,FInplaceEdit.TEXT);
end;

procedure TSGCustomGrid1.WMChar(var Msg:Twmchar);
begin
	if (GoEditing in Options)and(Charinset(Char(Msg.Charcode),[^H])or(Char(Msg.Charcode)>=#32)) then
			Showeditorchar(Char(Msg.Charcode))
	else inherited;
end;

procedure TSGCustomGrid1.WMCommand(var Message:TWMCommand);
begin
	with message do
		if (FInplaceEdit<>nil)and(Ctl=FInplaceEdit.Handle) then
			case Notifycode of
				EN_CHANGE:UpdateText;
			end;
	inherited;
end;

procedure TSGCustomGrid1.SetEditChange(Value:TNotifyEvent);
begin
	FOnEditChange:=Value;
	if Assigned(InplaceEditor) then InplaceEditor.OnChange:=Value;
end;

procedure TSGCustomGrid1.WMGetDlgCode(var Msg:Twmgetdlgcode);
begin
	Msg.Result:=Dlgc_wantarrows;
	if GoRowSelect in Options then Exit;
	if GoTabs in Options then Msg.Result:=Msg.Result or Dlgc_wanttab;
	if GoEditing in Options then Msg.Result:=Msg.Result or Dlgc_wantchars;
end;

procedure TSGCustomGrid1.WMKillFocus(var Msg:Twmkillfocus);
begin
	inherited;
	Destroycaret;
	InvalidateRect(Selection);
	if (FInplaceEdit<>nil)and(Msg.Focusedwnd<>FInplaceEdit.Handle) then Hideedit;
end;

procedure TSGCustomGrid1.WmLButtonDown(var Message:Twmlbuttondown);
begin
	inherited;
	if FInplaceEdit<>nil then FInplaceEdit.FClickTime:=Getmessagetime;
end;

procedure TSGCustomGrid1.WMNChitTest(var Msg:Twmnchittest);
begin
	Defaulthandler(Msg);
	FHitTest:=Screentoclient(Smallpointtopoint(Msg.Pos));
end;

procedure TSGCustomGrid1.WMSetCursor(var Msg:Twmsetcursor);
var
	Drawinfo:TGridDrawInfo;
	State:TGridState;
	Index:Longint;
	Pos,Ofs:integer;
	Cur:Hcursor;
begin
	Cur:=0;
	with Msg do begin
		if Hittest=Htclient then begin
			if FGridState=GSNormal then begin
				CalcDrawInfo(Drawinfo);
				CalcSizingState(FHitTest.X,FHitTest.Y,State,index,Pos,Ofs,Drawinfo);
			end
			else State:=FGridState;
			if State=GSRowSizing then Cur:=Screen.Cursors[Crvsplit]
			else if State=GSColSizing then Cur:=Screen.Cursors[Crhsplit]
		end;
	end;
	if Cur<>0 then Setcursor(Cur)
	else inherited;
end;

procedure TSGCustomGrid1.WMSetFocus(var Msg:Twmsetfocus);
begin
	inherited;
	Createcaret(Handle,0,0,0);
	if (FInplaceEdit=nil)or(Msg.Focusedwnd<>FInplaceEdit.Handle) then begin
		InvalidateRect(Selection);
		UpdateEdit;
	end;
end;

procedure TSGCustomGrid1.WMSize(var Msg:Twmsize);
begin
	inherited;
	UpdateScrollRange;
	if Userighttoleftalignment then Invalidate;
end;

procedure TSGCustomGrid1.WMVScroll(var Msg:Twmvscroll);
begin
	Modifyscrollbar(Sb_vert,Msg.Scrollcode,Msg.Pos,True);
end;

procedure TSGCustomGrid1.WMHScroll(var Msg:Twmhscroll);
begin
	Modifyscrollbar(Sb_horz,Msg.Scrollcode,Msg.Pos,True);
end;

procedure TSGCustomGrid1.WMEraseBkgnd(var Message:Twmerasebkgnd);
var
	R:TRect;
	Size:Tsize;
begin
	{ Fill the area between the two scroll bars. }
	Size.Cx:=Getsystemmetrics(Sm_cxvscroll);
	Size.Cy:=Getsystemmetrics(Sm_cyhscroll);
	if Userighttoleftalignment then R:=Bounds(0,Height-Size.Cy,Size.Cx,Size.Cy)
	else R:=Bounds(Width-Size.Cx,Height-Size.Cy,Size.Cx,Size.Cy);
	Fillrect(message.Dc,R,Brush.Handle);
	message.Result:=1;
end;

procedure TSGCustomGrid1.WndProc(var Message:TMessage);
var
	shDragImage:PShDragImage;
begin
	if (Message.Msg=RegisterWindowMessage(DI_GETDRAGIMAGE)) then begin
		shDragImage:=PShDragImage(message.Lparam);
		if Assigned(FOnGetDragImage) then begin
			FOnGetDragImage(Self,shDragImage);
			PShDragImage(message.Lparam):=shDragImage;
		end;
	end;
	inherited WndProc(message);
END;

procedure TSGCustomGrid1.CancelMode;
var
	Drawinfo:TGridDrawInfo;
begin
	try
		case FGridState of
			GSSelecting:Killtimer(Handle,1);
			GSRowSizing,GSColSizing:begin
					CalcDrawInfo(Drawinfo);
					DrawSizingLine(Drawinfo);
				end;
			GSColMoving,GSRowMoving:begin
					DrawMove;
					Killtimer(Handle,1);
				end;
		end;
	finally FGridState:=GSNormal;
	end;
end;

procedure TSGCustomGrid1.WMCancelMode(var Msg:Twmcancelmode);
begin
	inherited;
	CancelMode;
end;

procedure TSGCustomGrid1.CMCancelMode(var Msg:TCMCancelMode);
{$IF DEFINED(CLR)}
var
	Origmsg:TMessage;
{$ENDIF}
begin
	if Assigned(FInplaceEdit) then begin
{$IF DEFINED(CLR)}
		Origmsg:=Msg.Originalmessage;
		FInplaceEdit.WndProc(Origmsg);
{$ELSE}
		FInplaceEdit.WndProc(TMessage(Msg));
{$ENDIF}
	end;
	inherited;
	CancelMode;
end;

procedure TSGCustomGrid1.CMFontChanged(var Message:TMessage);
begin
	if FInplaceEdit<>nil then FInplaceEdit.Font:=Font;
	inherited;
end;

procedure TSGCustomGrid1.CMMouseLeave(var Message:TMessage);
begin
	inherited;
	if (Fhottrackcell.Rect.Left<>-1)or(Fhottrackcell.Rect.Top<>-1) then begin
		InvalidateRect(Fhottrackcell.Rect);
		Fhottrackcell.Rect:=Emptyrect;
	end;
end;

procedure TSGCustomGrid1.CMCtl3dChanged(var Message:TMessage);
begin
	inherited;
	Recreatewnd;
end;

procedure TSGCustomGrid1.CmDesignHitTest(var Msg:Tcmdesignhittest);
begin
	Msg.Result:=Lresult(Bool(Sizing(Msg.Pos.X,Msg.Pos.Y)));
end;

procedure TSGCustomGrid1.CMWantSpecialKey(var Msg:Tcmwantspecialkey);
begin
	inherited;
	if (GoEditing in Options)and(Char(Msg.Charcode)=#13) then Msg.Result:=1;
end;

procedure TSGCustomGrid1.Timedscroll(Direction:TGridScrollDirection);
var
	Maxanchor,Newanchor:TGridCoord;
begin
	Newanchor:=FAnchor;
	Maxanchor.X:=Colcount-1;
	Maxanchor.Y:=RowCount-1;
	if (SDLeft in Direction)and(FAnchor.X>Fixedcols) then Dec(Newanchor.X);
	if (SDRight in Direction)and(FAnchor.X<Maxanchor.X) then Inc(Newanchor.X);
	if (SDUp in Direction)and(FAnchor.Y>Fixedrows) then Dec(Newanchor.Y);
	if (SDDown in Direction)and(FAnchor.Y<Maxanchor.Y) then Inc(Newanchor.Y);
	if (FAnchor.X<>Newanchor.X)or(FAnchor.Y<>Newanchor.Y) then MoveAnchor(Newanchor);
end;

procedure TSGCustomGrid1.WMTimer(var Msg:Twmtimer);
var
	Point:TPoint;
	Drawinfo:TGridDrawInfo;
	Scrolldirection:TGridScrollDirection;
	Cellhit:TGridCoord;
	Leftside:integer;
	Rightside:integer;
begin
	if not(FGridState in [GSSelecting,GSRowMoving,GSColMoving]) then Exit;
	Getcursorpos(Point);
	Point:=Screentoclient(Point);
	CalcDrawInfo(Drawinfo);
	Scrolldirection:=[];
	with Drawinfo do begin
		Cellhit:=CalCcoordFromPoint(Point.X,Point.Y,Drawinfo);
		case FGridState of
			GSColMoving:MoveAndScroll(Point.X,Cellhit.X,Drawinfo,Horz,Sb_horz,Point);
			GSRowMoving:MoveAndScroll(Point.Y,Cellhit.Y,Drawinfo,Vert,Sb_vert,Point);
			GSSelecting:begin
					if not Userighttoleftalignment then begin
						if Point.X<Horz.FixedBoundary then Include(Scrolldirection,SDLeft)
						else if Point.X>Horz.FullVisBoundary then Include(Scrolldirection,SDRight);
					end else begin
						Leftside:=Clientwidth-Horz.FullVisBoundary;
						Rightside:=Clientwidth-Horz.FixedBoundary;
						if Point.X<Leftside then Include(Scrolldirection,SDRight)
						else if Point.X>Rightside then Include(Scrolldirection,SDLeft);
					end;
					if Point.Y<Vert.FixedBoundary then Include(Scrolldirection,SDUp)
					else if Point.Y>Vert.FullVisBoundary then Include(Scrolldirection,SDDown);
					if Scrolldirection<>[] then Timedscroll(Scrolldirection);
				end;
		end;
	end;
end;

procedure TSGCustomGrid1.Colwidthschanged;
begin
	UpdateScrollRange;
	UpdateEdit;
end;

procedure TSGCustomGrid1.Rowheightschanged;
begin
	UpdateScrollRange;
	UpdateEdit;
end;

procedure TSGCustomGrid1.DeleteColumn(ACol:Longint);
begin
	MoveColumn(ACol,Colcount-1);
	Colcount:=Colcount-1;
end;

procedure TSGCustomGrid1.DeleteRow(ARow:Longint);
begin
	MoveRow(ARow,RowCount-1);
	RowCount:=RowCount-1;
end;

procedure TSGCustomGrid1.Updatedesigner;
var
	Parentform:Tcustomform;
begin
	if (Csdesigning in Componentstate)and Handleallocated and not(Csupdating in Componentstate) then begin
		Parentform:=Getparentform(Self);
		if Assigned(Parentform)and Assigned(Parentform.Designer) then Parentform.Designer.Modified;
	end;
end;

function TSGCustomGrid1.Domousewheeldown(Shift:Tshiftstate;Mousepos:TPoint):Boolean;
begin
	Result:=inherited Domousewheeldown(Shift,Mousepos);
	if not Result then begin
		if Row<RowCount-1 then begin
			Row:=Row+1;
			Tlinkobservers.Positionlinkposchanged(Observers);
		end;
		Result:=True;
	end;
end;

function TSGCustomGrid1.Domousewheelup(Shift:Tshiftstate;Mousepos:TPoint):Boolean;
begin
	Result:=inherited Domousewheelup(Shift,Mousepos);
	if not Result then begin
		if Row>Fixedrows then begin
			Row:=Row-1;
			Tlinkobservers.Positionlinkposchanged(Observers);
		end;
		Result:=True;
	end;
end;

function TSGCustomGrid1.Checkcolumndrag(var Origin,Destination:integer;const Mousept:TPoint):Boolean;
begin
	Result:=True;
end;

function TSGCustomGrid1.Checkrowdrag(var Origin,Destination:integer;const Mousept:TPoint):Boolean;
begin
	Result:=True;
end;

function TSGCustomGrid1.Begincolumndrag(var Origin,Destination:integer;const Mousept:TPoint):Boolean;
begin
	Result:=True;
end;

function TSGCustomGrid1.Beginrowdrag(var Origin,Destination:integer;const Mousept:TPoint):Boolean;
begin
	Result:=True;
end;

function TSGCustomGrid1.Endcolumndrag(var Origin,Destination:integer;const Mousept:TPoint):Boolean;
begin
	Result:=True;
end;

function TSGCustomGrid1.Endrowdrag(var Origin,Destination:integer;const Mousept:TPoint):Boolean;
begin
	Result:=True;
end;

procedure TSGCustomGrid1.CMShowingChanged(var Message:TMessage);
begin
	inherited;
	if Showing then UpdateScrollRange;
end;

{ TSGCustomDrawGrid1 }

class constructor TSGCustomDrawGrid1.Create;
begin
	Tcustomstyleengine.Registerstylehook(TSGCustomDrawGrid1,Tscrollingstylehook);
end;

class destructor TSGCustomDrawGrid1.Destroy;
begin
	Tcustomstyleengine.Unregisterstylehook(TSGCustomDrawGrid1,Tscrollingstylehook);
end;

function TSGCustomDrawGrid1.Cellrect(ACol,ARow:Longint):TRect;
begin
	Result:=inherited Cellrect(ACol,ARow);
end;

procedure TSGCustomDrawGrid1.Mousetocell(X,Y:integer;var ACol,ARow:Longint);
var
	Coord:TGridCoord;
begin
	Coord:=MouseCoord(X,Y);
	ACol:=Coord.X;
	ARow:=Coord.Y;
end;

procedure TSGCustomDrawGrid1.ColumnMoved(FromIndex,ToIndex:Longint);
begin
	if Assigned(Foncolumnmoved) then Foncolumnmoved(Self,FromIndex,ToIndex);
end;

function TSGCustomDrawGrid1.GetEditText(ACol,ARow:Longint):string;
begin
	Result:='';
end;

procedure TSGCustomDrawGrid1.RowMoved(FromIndex,ToIndex:Longint);
begin
	if Assigned(Fonrowmoved) then Fonrowmoved(Self,FromIndex,ToIndex);
end;

function TSGCustomDrawGrid1.Selectcell(ACol,ARow:Longint):Boolean;
begin
	Result:=True;
	if Assigned(Fonselectcell) then Fonselectcell(Self,ACol,ARow,Result);
end;

procedure TSGCustomDrawGrid1.SetEditText(ACol,ARow:Longint;const Value:string);
begin
	if Assigned(Fonsetedittext) then Fonsetedittext(Self,ACol,ARow,Value);
end;

procedure TSGCustomDrawGrid1.Drawcell(ACol,ARow:Longint;Arect:TRect;AState:TGridDrawState);
var
	Hold:integer;
begin
	if Assigned(Fondrawcell) then begin
		if Userighttoleftalignment then begin
			Arect.Left:=Clientwidth-Arect.Left;
			Arect.Right:=Clientwidth-Arect.Right;
			Hold:=Arect.Left;
			Arect.Left:=Arect.Right;
			Arect.Right:=Hold;
			ChangeGridOrientation(True);
		end;
		Fondrawcell(Self,ACol,ARow,Arect,AState);
		if Userighttoleftalignment then ChangeGridOrientation(True);
	end;
end;

procedure TSGCustomDrawGrid1.Topleftchanged;
begin
	inherited Topleftchanged;
	if Assigned(Fontopleftchanged) then Fontopleftchanged(Self);
end;

{ StrItem management for TStringSparseList }

function Newstritem(const Astring:string;Aobject:TObject):TStrItemType;
begin
{$IF DEFINED(CLR)}
	Result:=TStrItem.Create;
{$ELSE}
	New(Result);
{$ENDIF}
	Result.FObject:=Aobject;
	Result.FString:=Astring;
end;

{$IF DEFINED(CLR)}

procedure Disposestritem(var P:TStrItem);
begin
	P.Free;
	P:=nil;
end;
{$ELSE}

procedure Disposestritem(P:PStrItem);
begin
	Dispose(P);
end;
{$ENDIF}
{ Sparse array classes for TStringGrid }

{ TSparsePointeAarray }

const
	Spaindexmask: array [TSpaQuantum] of Byte=(15,255);
	Spasecshift: array [TSpaQuantum] of Byte=(4,8);

	{ Expand Section Directory to cover at least `newSlots' slots. Returns: Possibly
		updated pointer to the Section Directory. }
function Expanddir(Secdir:TSecDirType;var Slotsindir:Cardinal;Newslots:Cardinal):TSecDirType;
begin
	Result:=Secdir;
{$IF DEFINED(CLR)}
	Setlength(Result,Newslots);
{$ELSE}
	Reallocmem(Result,Newslots*Sizeof(Pointer));
	Fillchar(Result^[Slotsindir],(Newslots-Slotsindir)*Sizeof(Pointer),0);
{$ENDIF}
	Slotsindir:=Newslots;
end;

{ Allocate a section and set all its items to nil. Returns: Pointer to start of
	section. }
{$IF NOT DEFINED(CLR)}

function Makesec(Secindex:integer;SectionSize:Word):Pointer;
var
	Secp:Pointer;
	Size:Word;
begin
	Size:=SectionSize*Sizeof(Pointer);
	Getmem(Secp,Size);
	Fillchar(Secp^,Size,0);
	Makesec:=Secp
end;
{$ENDIF}

constructor TSparsePointeAarray.Create(Quantum:TSpaQuantum);
begin
{$IF DEFINED(CLR)}
	inherited Create;
	Setlength(Secdir,0);
{$ELSE}
	Secdir:=nil;
{$ENDIF}
	Slotsindir:=0;
	Fhighbound:=-1;
	Fsectionsize:=Word(Spaindexmask[Quantum])+1;
	Indexmask:=Word(Spaindexmask[Quantum]);
	SecShift:=Word(Spasecshift[Quantum]);
	Cachedindex:=-1
end;

destructor TSparsePointeAarray.Destroy;
{$IF DEFINED(CLR)}
var
	I:integer;
begin
	{ Scan section directory and free each section that exists. }
	I:=0;
	while I<Slotsindir do begin
		if Length(Secdir[I])<>0 then Setlength(Secdir[I],0);
		Inc(I)
	end;
	Setlength(Secdir,0);
	Slotsindir:=0;
{$ELSE}
var
	I:Cardinal;
	Size:Word;
begin
	{ Scan section directory and free each section that exists. }
	I:=0;
	Size:=Fsectionsize*Sizeof(Pointer);
	while I<Slotsindir do begin
		if Secdir^[I]<>nil then Freemem(Secdir^[I],Size);
		Inc(I)
	end;

	{ Free section directory. }
	if Secdir<>nil then Freemem(Secdir,Slotsindir*Sizeof(Pointer));
{$ENDIF}
end;

function TSparsePointeAarray.GetAt(Index:integer):TCustomData;
{$IF DEFINED(CLR)}
var
	Secdata:Tsectdata;
	Secindex:Cardinal;
begin
	if index=Cachedindex then Result:=Cachedvalue
	else begin
		{ Index into Section Directory using high order part of
			index.  Get pointer to Section. If not empty, index into
			Section using low order part of index. }
		Result:=nil;
		Secindex:=index shr SecShift;
		if Secindex<Slotsindir then begin
			Secdata:=Secdir[Secindex];
			if Length(Secdata)>0 then Result:=Secdata[(index and Indexmask)];
		end;
		Cachedindex:=index;
		Cachedvalue:=Result
	end
{$ELSE}

var
	Bytep:Pbyte;
	Secindex:Cardinal;
begin
	{ Index into Section Directory using high order part of
		index.  Get pointer to Section. If not null, index into
		Section using low order part of index. }
	if index=Cachedindex then Result:=Cachedvalue
	else begin
		Secindex:=index shr SecShift;
		if Secindex>=Slotsindir then Bytep:=nil
		else begin
			Bytep:=Secdir^[Secindex];
			if Bytep<>nil then begin
				Inc(Bytep,(index and Indexmask)*Sizeof(Pointer));
			end
		end;
		if Bytep=nil then Result:=nil
		else Result:=Ppointer(Bytep)^;
		Cachedindex:=index;
		Cachedvalue:=Result
	end
{$ENDIF}
end;

{$IF NOT DEFINED(CLR)}

function TSparsePointeAarray.MakeAt(Index:integer):Ppointer;
var
	Dirp:Psecdir;
	P:Pointer;
	Bytep:Pbyte;
	Secindex:Cardinal;
begin
	{ Expand Section Directory if necessary. }
	Secindex:=index shr SecShift; { Unsigned shift }
	if Secindex>=Slotsindir then Dirp:=Expanddir(Secdir,Slotsindir,Secindex+1)
	else Dirp:=Secdir;

	{ Index into Section Directory using high order part of
		index.  Get pointer to Section. If null, create new
		Section.  Index into Section using low order part of index. }
	Secdir:=Dirp;
	P:=Dirp^[Secindex];
	if P=nil then begin
		P:=Makesec(Secindex,Fsectionsize);
		Dirp^[Secindex]:=P
	end;
	Bytep:=P;
	Inc(Bytep,(index and Indexmask)*Sizeof(Pointer));
	if index>Fhighbound then Fhighbound:=index;
	Result:=Ppointer(Bytep);
	Cachedindex:=-1
end;
{$ENDIF}

procedure TSparsePointeAarray.PutAt(Index:integer;Item:TCustomData);
{$IF DEFINED(CLR)}
var
	Secindex:Word;
begin
	if (Item<>nil)or(GetAt(index)<>nil) then begin
		{ Expand Section Directory if necessary. }
		Secindex:=index shr SecShift; { Unsigned shift }
		if Secindex>=Slotsindir then Secdir:=Expanddir(Secdir,Slotsindir,Secindex+1);
		{ get the section and make sure it has enough slots }
		if Length(Secdir[Secindex])=0 then Setlength(Secdir[Secindex],Fsectionsize);
		Secdir[Secindex][(index and Indexmask)]:=Item;
		if Item=nil then Resethighbound
		else if index>Fhighbound then Fhighbound:=index;
		Cachedindex:=index;
		Cachedvalue:=Item
	end
{$ELSE}

begin
	if (Item<>nil)or(GetAt(index)<>nil) then begin
		MakeAt(index)^:=Item;
		if Item=nil then Resethighbound
	end
{$ENDIF}
end;

{$IF DEFINED(CLR)}

function TSparsePointeAarray.ForAll(Applyfunction:Tspaapply):integer;
var
	Section:Tsectdata;
	Item:TObject;
	I:Cardinal;
	J,Index:integer;
begin
	Result:=0;
	I:=0;
	while (I<Slotsindir)and(Result=0) do begin
		Section:=Secdir[I];
		if Length(Section)<>0 then begin
			J:=0;
			index:=I shl SecShift;
			while (J<Fsectionsize)and(Result=0) do begin
				Item:=Section[J];
				if Item<>nil then Result:=Applyfunction(index,Item);
				Inc(J);
				Inc(index)
			end
		end;
		Inc(I)
	end;
end;
{$ELSE}

function TSparsePointeAarray.ForAll(Applyfunction:Tspaapply):integer;
var
	Itemp:Pbyte; { Pointer to item in section }
	Item:Pointer;
	I:Cardinal;
	J,Index:integer;
begin
	{ Scan section directory and scan each section that exists,
		calling the apply function for each non-nil item. }
	Result:=0;
	I:=0;
	while (I<Slotsindir)and(Result=0) do begin
		Itemp:=Secdir^[I];
		if Itemp<>nil then begin
			J:=0;
			index:=I shl SecShift;
			while (J<Fsectionsize)and(Result=0) do begin
				Item:=Ppointer(Itemp)^;
				if Item<>nil then begin
					{ ret := ApplyFunction(index, item.Ptr); }
					Result:=Applyfunction(index,Item);
				end;
				Inc(Itemp,Sizeof(Pointer));
				Inc(J);
				Inc(index)
			end
		end;
		Inc(I)
	end;
end;
{$ENDIF}
{$IF DEFINED(CLR)}

function TSparsePointeAarray.Detector(Theindex:integer;Theitem:TObject):integer;
begin
	if Theindex>Fhighbound then Result:=1
	else begin
		Result:=0;
		if Theitem<>nil then FTemp:=Theindex
	end
end;
{$ENDIF}

procedure TSparsePointeAarray.Resethighbound;
{$IF NOT DEFINED(CLR)}
var
	Newhighbound:integer;
begin
	Newhighbound:=-1;
	ForAll(function(Theindex:integer;Theitem:Pointer):integer
		begin
			if Theindex>Fhighbound then Result:=1
			else begin
				Result:=0;
				if Theitem<>nil then Newhighbound:=Theindex
			end
		end);
	Fhighbound:=Newhighbound
end;
{$ELSE}

begin
	FTemp:=-1;
	ForAll(@Detector);
	Fhighbound:=FTemp
end;
{$ENDIF}
{ TSparseList }

constructor TSparseList.Create(Quantum:TSpaQuantum);
begin
	inherited Create;
	Newlist(Quantum)
end;

destructor TSparseList.Destroy;
begin
{$IF DEFINED(CLR)}
	Freeandnil(Flist);
{$ELSE}
	if Flist<>nil then Flist.Destroy
{$ENDIF}
end;

procedure TSparseList.Clear;
begin
	Flist.Destroy;
	Newlist(Fquantum);
	Fcount:=0
end;

procedure TSparseList.Delete(Index:integer);
var
	I:integer;
begin
	if (index<0)or(index>=Fcount) then Exit;
	for I:=index to Fcount-1 do Flist[I]:=Flist[I+1];
	Flist[Fcount]:=nil;
	Dec(Fcount);
end;

procedure TSparseList.Exchange(Index1,Index2:integer);
var
	Temp:TCustomData;
begin
	Temp:=Get(Index1);
	Put(Index1,Get(Index2));
	Put(Index2,Temp);
end;

{$IF DEFINED(CLR)}

function TSparseList.ForAll(Applyfunction:Tspaapply):integer;
begin
	Result:=Flist.ForAll(Applyfunction);
end;
{$ELSE}

function TSparseList.ForAll(Applyfunction:Tspaapply):integer;
begin
	Result:=Flist.ForAll(Applyfunction);
end;
{$ENDIF}

function TSparseList.Get(Index:integer):TCustomData;
begin
	if index<0 then TList.Error(Slistindexerror,index);
	Result:=Flist[index]
end;

procedure TSparseList.Insert(Index:integer;Item:TCustomData);
var
	I:integer;
begin
	if index<0 then TList.Error(Slistindexerror,index);
	I:=Fcount;
	while I>index do begin
		Flist[I]:=Flist[I-1];
		Dec(I)
	end;
	Flist[index]:=Item;
	if index>Fcount then Fcount:=index;
	Inc(Fcount)
end;

procedure TSparseList.Move(Curindex,Newindex:integer);
var
	Item:TCustomData;
begin
	if Curindex<>Newindex then begin
		Item:=Get(Curindex);
		Delete(Curindex);
		Insert(Newindex,Item);
	end;
end;

procedure TSparseList.Newlist(Quantum:TSpaQuantum);
begin
	Fquantum:=Quantum;
	Flist:=TSparsePointeAarray.Create(Quantum)
end;

procedure TSparseList.Put(Index:integer;Item:TCustomData);
begin
	if index<0 then TList.Error(Slistindexerror,index);
	Flist[index]:=Item;
	Fcount:=Flist.HighBound+1
end;

{ TStringSparseList }

constructor TStringSparseList.Create(Quantum:TSpaQuantum);
begin
	inherited Create;
	Flist:=TSparseList.Create(Quantum)
end;

destructor TStringSparseList.Destroy;
begin
	if Flist<>nil then begin
		Clear;
		Flist.Destroy
	end
end;

procedure TStringSparseList.ReadData(Reader:Treader);
var
	I:integer;
begin
	with Reader do begin
		I:=integer(Readinteger);
		while I>0 do begin
			Insertobject(integer(Readinteger),Readstring,nil);
			Dec(I)
		end
	end
end;

{$IF DEFINED(CLR)}

function TStringSparseList.CountItem(Theindex:integer;Theitem:TObject):integer;
begin
	Inc(Ftempint);
	Result:=0
end;
{$ENDIF}
{$IF DEFINED(CLR)}

function TStringSparseList.StoreItem(Theindex:integer;Theitem:TObject):integer;
begin
	with Ftempobject as TWriter do begin
		Writeinteger(Theindex); // Item index
		Writestring(TStrItem(Theitem).FString);
	end;
	Result:=0
end;
{$ENDIF}

procedure TStringSparseList.WriteData(Writer:TWriter);
{$IF NOT DEFINED(CLR)}
var
	Itemcount:integer;
{$ENDIF}
begin
{$IF DEFINED(CLR)}
	Ftempint:=0;
	Ftempobject:=Writer;
	Flist.ForAll(@CountItem);
	Writer.Writeinteger(Ftempint);
	Flist.ForAll(@StoreItem);
{$ELSE}
	with Writer do begin
		Itemcount:=0;
		Flist.ForAll(function(Theindex:integer;Theitem:Pointer):integer
			begin
				Inc(Itemcount);
				Result:=0
			end);
		Writeinteger(Itemcount);
		Flist.ForAll(function(Theindex:integer;Theitem:Pointer):integer
			begin
				with Writer do begin
					Writeinteger(Theindex); // Item index
					Writestring(PStrItem(Theitem)^.FString);
				end;
				Result:=0
			end);
	end
{$ENDIF}
end;

procedure TStringSparseList.DefineProperties(Filer:Tfiler);
begin
	Filer.Defineproperty('List',ReadData,WriteData,True);
end;

function TStringSparseList.Get(Index:integer):string;
var
	P:TStrItemType;
begin
	P:=TStrItemType(Flist[index]);
	if P=nil then Result:=''
	else Result:=P.FString
end;

function TStringSparseList.GetCount:integer;
begin
	Result:=Flist.Count
end;

function TStringSparseList.GetObject(Index:integer):TObject;
var
	P:TStrItemType;
begin
	P:=TStrItemType(Flist[index]);
	if P=nil then Result:=nil
	else Result:=P.FObject
end;

procedure TStringSparseList.Put(Index:integer;const S:string);
var
	P:TStrItemType;
	Obj:TObject;
begin
	P:=TStrItemType(Flist[index]);
	if P=nil then Obj:=nil
	else Obj:=P.FObject;
	if (S='')and(Obj=nil) then // Nothing left to store
			Flist[index]:=nil
	else Flist[index]:=Newstritem(S,Obj);
	if P<>nil then Disposestritem(P);
	Changed
end;

procedure TStringSparseList.PutObject(Index:integer;Aobject:TObject);
var
	P:TStrItemType;
begin
	P:=TStrItemType(Flist[index]);
	if P<>nil then P.FObject:=Aobject
	else if Aobject<>nil then Flist[index]:=Newstritem('',Aobject);
	Changed;
end;

procedure TStringSparseList.Changed;
begin
	if Assigned(Fonchange) then Fonchange(Self)
end;

procedure TStringSparseList.Delete(Index:integer);
var
	P:TStrItemType;
begin
	P:=TStrItemType(Flist[index]);
	if P<>nil then Disposestritem(P);
	Flist.Delete(index);
	Changed
end;

procedure TStringSparseList.Exchange(Index1,Index2:integer);
begin
	Flist.Exchange(Index1,Index2);
end;

procedure TStringSparseList.Insert(Index:integer;const S:string);
begin
	Flist.Insert(index,Newstritem(S,nil));
	Changed
end;

{$IF DEFINED(CLR)}

function Clearitem(Theindex:integer;Theitem:TObject):integer;
begin
	Theitem.Free;
	Result:=0
end;
{$ENDIF}

procedure TStringSparseList.Clear;
begin
{$IF DEFINED(CLR)}
	Flist.ForAll(@Clearitem);
{$ELSE}
	Flist.ForAll(function(Theindex:integer;Theitem:Pointer):integer
		begin
			Disposestritem(PStrItem(Theitem)); // Item guaranteed non-nil
			Result:=0
		end);
{$ENDIF}
	Flist.Clear;
	Changed
end;

constructor TGRAMD.Create(Agrid:TSJ;Aindex:Longint);
begin
	inherited Create;
	FGrid:=Agrid;
	FIndex:=Aindex;
	New(FQr);
	FTag:=0;
	FQr.Cinfo.CUL:='';
	FQr.FColor:=Agrid.Font.Color;
	FQr.FArr:=EmptyThings;
	FQr.FObj:=nil;
	FQr.Cinfo.NU:=False;
	FQr.Cinfo.VIS:=True;
end;

destructor TGRAMD.Destroy;
begin
	Dispose(FQr);
	inherited Destroy;
end;

{ TStringGridStrings }

{ AIndex < 0 is a column (for column -AIndex - 1)
	AIndex > 0 is a row (for row AIndex - 1)
	AIndex = 0 denotes an empty row or column }

constructor TStringGridStrings.Create(Agrid:TSG;Aindex:Longint);
begin
	inherited Create;
	FGrid:=Agrid;
	FIndex:=Aindex;
	FTag:=0;
	FRFC:=0;
	FST:=0;
	FNUM:=0;
end;

destructor TStringGridStrings.Destroy;
begin
	inherited Destroy;
end;

procedure TStringGridStrings.Assign(Source:Tpersistent);
var
	I,Max:integer;
begin
	if Source is TStrings then begin
		Beginupdate;
		Max:=TStrings(Source).Count-1;
		if Max>=Count then Max:=Count-1;
		try
			for I:=0 to Max do begin
				Put(I,TStrings(Source).Strings[I]);
				PutObject(I,TStrings(Source).Objects[I]);
			end;
		finally Endupdate;
		end;
		Exit;
	end;
	inherited Assign(Source);
end;

procedure TStringGridStrings.Calcxy(Index:integer;var X,Y:integer);
begin
	if FIndex=0 then begin
		X:=-1;
		Y:=-1;
	end else if FIndex>0 then begin
		X:=index;
		Y:=FIndex-1;
	end else begin
		X:=-FIndex-1;
		Y:=index;
	end;
end;

// Changes the meaning of Add to mean copy to the first empty string
function TStringGridStrings.Add(const S:string):integer;
var
	I:integer;
begin
	for I:=0 to Count-1 do
		if Strings[I]='' then begin
			if S='' then Strings[I]:=''
			else Strings[I]:=S;
			Result:=I;
			Exit;
		end;
	Result:=-1;
end;

{$IF DEFINED(CLR)}

function TStringGridStrings.Blankstr(Theindex:integer;Theitem:TObject):integer;
begin
	Objects[Theindex]:=nil;
	Strings[Theindex]:='';
	Result:=0;
end;
{$ENDIF}

procedure TStringGridStrings.Clear;
var
	Sslist:TStringSparseList;
	I:integer;
begin
	if FIndex>0 then begin
		Sslist:=TStringSparseList(TSparseList(FGrid.FData)[FIndex-1]);
{$IF DEFINED(CLR)}
		if Sslist<>nil then Sslist.List.ForAll(@Blankstr);
{$ELSE}
		if Sslist<>nil then Sslist.List.ForAll(function(Theindex:integer;Theitem:Pointer):integer
				begin
					Objects[Theindex]:=nil;
					Strings[Theindex]:='';
					Result:=0;
				end);
{$ENDIF}
	end else if FIndex<0 then
		for I:=Count-1 downto 0 do begin
			Objects[I]:=nil;
			Strings[I]:='';
		end;
end;

procedure TStringGridStrings.Delete(Index:integer);
begin
	Invalidop(Sinvalidstringgridop);
end;

function TStringGridStrings.Get(Index:integer):string;
var
	X,Y:integer;
begin
	Calcxy(index,X,Y);
	if X<0 then Result:=''
	else Result:=FGrid.Cells[X,Y];
end;

function TStringGridStrings.GetCount:integer;
begin
	// Count of a row is the column count, and vice versa
	if FIndex=0 then Result:=0
	else if FIndex>0 then Result:=integer(FGrid.Colcount)
	else Result:=integer(FGrid.RowCount);
end;

function TStringGridStrings.GetObject(Index:integer):TObject;
var
	X,Y:integer;
begin
	Calcxy(index,X,Y);
	if X<0 then Result:=nil
	else Result:=FGrid.Objects[X,Y];
end;

procedure TStringGridStrings.Insert(Index:integer;const S:string);
begin
	Invalidop(Sinvalidstringgridop);
end;

procedure TStringGridStrings.Put(Index:integer;const S:string);
var
	X,Y:integer;
begin
	Calcxy(index,X,Y);
	FGrid.Cells[X,Y]:=S;
end;

procedure TStringGridStrings.PutObject(Index:integer;Aobject:TObject);
var
	X,Y:integer;
begin
	Calcxy(index,X,Y);
	FGrid.Objects[X,Y]:=Aobject;
end;

procedure TStringGridStrings.SetUpdateState(Updating:Boolean);
begin
	FGrid.SetUpdateState(Updating);
end;

{ TSG }

constructor TSJ.Create(Aowner:Tcomponent);
begin
	Flist:=TList.Create;
	inherited Create(Aowner);
	Colcount:=10;
	RowCount:=10;
	FDropDownRowCount:=8;
	FIsCH:=True;
	FIsGT:=True;
	FIsDR:=False;
	FFxalgn:=Tacenter;
	FAlgn:=Tacenter;
	FFxFont:=TFont.Create;
	FFxFont.Assign(Font);
	FFxFont.Style:=Font.Style+[FSBOLD];
	SFxFont:=TFont.Create;
	SFxFont.Assign(Font);
	SFxFont.Style:=Font.Style+[FSBOLD];
	SFxFont.Size:=Font.Size+2;
	SFxFont.Color:=clMaroon;
	FOdd:=False;
	FOddc:=Clgradientinactivecaption;
	ColButton:=TSpeedButton.Create(Self);
	with ColButton do begin
		Layout:=Blglyphright;
		Font.Name:='AMD';
		Caption:='r'; // r s - p q
		Font.Size:=6;
		Parent:=Self;
		Font.Color:=Self.Font.Color;
		Cursor:=Crhandpoint;
		Flat:=True;
		Visible:=False;
	end;
	Controlstyle:=Controlstyle+[Csdisplaydragimage,Csreplicatable];
	Controlstate:=Controlstate+[Cspaintcopy];
end;

function TSJ.CreateEditor:TSGInplaceEdit1;
begin
	Result:=TSGInplaceEdit1List1.Create(Self);
	with TSGInplaceEdit1List1(Result) do begin
		DropdownRows:=FDropDownRowCount;
		OnGetPicklistItems:=FOnGetPicklistItems;
		OnEditButtonClick:=FOnEditButtonClick1;
		OnChange:=FOnEditChange;
		ButtonWidth:=10;
	end;
end;

procedure TSJ.SetFXFont(Value:TFont);
begin
	FFxFont.Assign(Value);
end;

procedure TSJ.SetSXFont(Value:TFont);
begin
	SFxFont.Assign(Value);
end;

procedure TSJ.SetAllOn(Value:Boolean);
begin
	FIsON:=Value;
	FIsCH:=Value;
	FIsGT:=Value;
	FIsDR:=Value;
end;

procedure TSJ.Repaint;
begin
	ColButton.Font.Color:=Font.Color;
	inherited Repaint;
end;

procedure TSJ.Showeditor;
var
	CShow:Boolean;
begin
	CShow:=True;
	if Assigned(FInplaceEditEvent) then FInplaceEditEvent(Self,FInplaceEdit,Col,Row,CShow);
	if CShow then inherited Showeditor;
end;

function TSJ.GetEditStyle(ACol,ARow:integer):TEditStyle;
begin
	Result:=Essimple;
	if Assigned(FOnGetEditStyle) then FOnGetEditStyle(Self,ACol,ARow,Result);
end;

procedure TSJ.SetDropDownRowCount(Value:integer);
begin
	FDropDownRowCount:=Value;
	if Assigned(InplaceEditor) then TSGInplaceEdit1List1(InplaceEditor).DropdownRows:=Value;
end;

procedure TSJ.SetOnEditButtonClick(Value:TNotifyEvent);
begin
	FOnEditButtonClick1:=Value;
	if Assigned(InplaceEditor) then TSGInplaceEdit1List1(InplaceEditor).OnEditButtonClick:=Value;
end;

procedure TSJ.SetOnGetPicklistItems(Value:TOnGetPicklistItems);
begin
	FOnGetPicklistItems:=Value;
	if Assigned(InplaceEditor) then TSGInplaceEdit1List1(InplaceEditor).OnGetPicklistItems:=Value;
end;

destructor TSJ.Destroy;
var
	I:integer;
begin
	if (Flist.Count>0) then
		for I:=0 to Flist.Count-1 do
			if (Flist[I]<>nil) then TGRAMD(Flist[I]).Destroy;
	Flist.Free;
	ColButton.Free;
	FFxFont.Free;
	FFxFont:=nil;
	SFxFont.Free;
	SFxFont:=nil;
	inherited Destroy;
end;

function TSJ.GetEditText(ACol,ARow:Longint):string;
begin
	Result:=Cells[ACol,ARow];
	if Assigned(Fongetedittext) then Fongetedittext(Self,ACol,ARow,Result);
end;

procedure TSJ.SetEditText(ACol,ARow:Longint;const Value:string);
begin
	DisableEditUpdate;
	try
		if Value<>Cells[ACol,ARow] then Cells[ACol,ARow]:=Value;
	finally EnableEditUpdate;
	end;
	inherited SetEditText(ACol,ARow,Value);
end;

procedure TSJ.Drawcell(ACol,ARow:Longint;Arect:TRect;AState:TGridDrawState);
const
	Ccellnormal: array [TGridDrawingStyle] of Tthemedgrid=(Tgclassiccellnormal,Tgcellnormal,Tggradientcellnormal);
	Ccellselected: array [TGridDrawingStyle] of Tthemedgrid=(Tgclassiccellselected,Tgcellselected,Tggradientcellselected);
	Cfixednormal: array [TGridDrawingStyle] of Tthemedgrid=(Tgclassicfixedcellnormal,Tgfixedcellnormal,
		Tggradientfixedcellnormal);
	Cfixedhot: array [TGridDrawingStyle] of Tthemedgrid=(Tgclassicfixedcellhot,Tgfixedcellhot,Tggradientfixedcellhot);
	Cfixedpressed: array [TGridDrawingStyle] of Tthemedgrid=(Tgclassicfixedcellpressed,Tgfixedcellpressed,
		Tggradientfixedcellpressed);
	Alignflags: array [TAlignment] of integer=(Dt_left or Dt_vcenter,Dt_right or Dt_vcenter,Dt_center or Dt_vcenter);
	// or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX
	function RNG(A,B,C:integer):Boolean;
	begin
		Result:=(A>B-1)and(A<C+1);
	end;

var
	Ltext:string;
	Ldetails:Tthemedelementdetails;
	Algn1:Cardinal;
	H:Htheme;
	S:Tsize;
	R:TRect;
	Lstyle:Tcustomstyleservices;
	D,T:integer;
begin
	if not Defaultdrawing then Exit;
	D:=0;
	if FChks then D:=1;
	if (GDFixed in AState) then begin
		if (ARow>Fixedrows-1) then begin
			if (ACol=D) then begin
				Ltext:=Cells[ACol,ARow];
				if (Ltext='') then Ltext:=ARow.ToString
			end
			else Ltext:='';
		end
		else Ltext:=Cols[ACol].Outr.Cinfo.LG;
	end
	else Ltext:=Cells[ACol,ARow];
	R:=Cellrect(ACol,ARow);
	Lstyle:=Styleservices;
	if Styleservices.Enabled then begin
		Arect.Left:=Arect.Left+4;
		if (GDFixed in AState) then begin
			if GDHotTrack in AState then Ldetails:=Styleservices.Getelementdetails(Cfixedhot[FInternalDrawingStyle])
			else if GDPressed in AState then Ldetails:=Styleservices.Getelementdetails(Cfixedpressed[FInternalDrawingStyle])
			else Ldetails:=Styleservices.Getelementdetails(Cfixednormal[FInternalDrawingStyle])
		end else begin
			if (GDSelected in AState)or(GDRowSelected in AState) then
					Ldetails:=Styleservices.Getelementdetails(Ccellselected[FInternalDrawingStyle])
			else Ldetails:=Styleservices.Getelementdetails(Ccellnormal[FInternalDrawingStyle]);
		end;
		// LStyle.DrawElement(Canvas.Handle,LDetails,R,@ARect);
		Arect.Top:=Arect.Top+((Arect.Height-Canvas.Textheight(Ltext))div 2);
	end else begin
		Arect.Top:=Arect.Top+2;
	end;
	if (GDFixed in AState) then begin
		Algn1:=Alignflags[FFxalgn];
		if RNG(ARow,Selection.Top,Selection.Bottom)or RNG(ACol,Selection.Left,Selection.Right) then
				Canvas.Font.Assign(SFxFont)
		else Canvas.Font.Assign(FFxFont);
	end else begin
		if FOdd then begin
			if Odd(Fixedrows) then begin
				if not Odd(ARow) then begin
					if ((Canvas.Brush.Color=Color)or(FDrawingStyle=GdsThemed)or Tstylemanager.Iscustomstyleactive)and
						not(GDSelected in AState) then begin
						Canvas.Brush.Color:=FOddc;
						Canvas.Fillrect(R);
					end;
				end;
			end else begin
				if Odd(ARow) then begin
					if ((Canvas.Brush.Color=Color)or(FDrawingStyle=GdsThemed)or Tstylemanager.Iscustomstyleactive)and
						not(GDSelected in AState) then begin
						Canvas.Brush.Color:=FOddc;
						Canvas.Fillrect(R);
					end;
				end;
			end;
		end;
		Canvas.Font.Assign(Font);
		Algn1:=Alignflags[FAlgn];
	end;
	if FIsDR then
		if Assigned(Fondrawcell) then Fondrawcell(Self,ACol,ARow,Canvas,Arect,AState,Ltext);
	{ if(Cols[ACol].Outr.FWrg or(ACol=0))and Rows[ARow].Outr.FWrg then begin
		if(ACol in Rows[ARow].Outr.FArr)or(ACol=0)then begin
		Canvas.Font.Color:=Clred;
		Canvas.Fillrect(Arect);
		if(ACol=0)then begin
		Ltext:=Cells[ACol,ARow]+' >';
		end;
		end;
		end; }
	if (ACol=0)and FChks then begin
		S.Cx:=Getsystemmetrics(Sm_cxmenucheck);
		S.Cy:=Getsystemmetrics(Sm_cymenucheck);
		if Usethemes then begin
			if (ARow=0) then begin
				T:=Cols[0].Outr.Cinfo.SCB;
				case T of
					0:T:=CBS_UNCHECKEDNORMAL;
					1:T:=CBS_CHECKEDNORMAL;
					2:T:=CBS_MIXEDNORMAL;
				else T:=CBS_UNCHECKEDNORMAL;
				end;
			end else begin
				T:=StrToIntDef(Cells[0,ARow],0);
				case T of
					0:T:=CBS_UNCHECKEDNORMAL;
					1:T:=CBS_CHECKEDNORMAL;
				end;
			end;
			H:=Openthemedata(Handle,Pchar('BUTTON'));
			if (H<>0) then begin
				try
					Getthemepartsize(H,Canvas.Handle,BP_CHECKBOX,CBS_CHECKEDNORMAL,nil,Ts_draw,S);
					Drawthemebackground(H,Canvas.Handle,BP_CHECKBOX,T,R,nil);
				finally Closethemedata(H);
				end;
			end;
		end else begin
			if (ARow=0) then begin
				T:=Cols[0].Outr.Cinfo.SCB;
				case T of
					0:T:=DFCS_BUTTONCHECK;
					1:T:=DFCS_CHECKED;
					2:T:=DFCS_MONO;
				else T:=DFCS_BUTTONCHECK;
				end;
			end else begin
				T:=StrToIntDef(Cells[0,ARow],0);
				case T of
					0:T:=DFCS_BUTTONCHECK;
					1:T:=DFCS_CHECKED;
				end;
			end;
			Drawframecontrol(Canvas.Handle,R,Dfc_button,T);
		end;
	end;
	if (ARow>Fixedrows-1)and(ACol>Fixedcols-1)and FChks and(StrToIntDef(Cells[0,ARow],0)=1) then begin
		Canvas.Brush.Color:=clWebCadetBlue;
		Canvas.Fillrect(R);
	END;
	if Userighttoleftalignment then
		with Arect do Canvas.Textrect(Arect,Left+((Width-Canvas.Textwidth(Ltext))div 2),Top,Ltext)
	else Drawtext(Canvas.Handle,Pchar(Ltext),Length(Ltext),Arect,Algn1);
	inherited Drawcell(ACol,ARow,Arect,AState);
end;

procedure TSJ.DisableEditUpdate;
begin
	Inc(FEditUpdate);
end;

procedure TSJ.EnableEditUpdate;
begin
	Dec(FEditUpdate);
end;

procedure TSJ.Initialize;
var
	Quantum:TSpaQuantum;
begin
	if FCols=nil then begin
		if Colcount>512 then Quantum:=Spalarge
		else Quantum:=Spasmall;
		FCols:=TSparseList.Create(Quantum);
	end;
	if RowCount>256 then Quantum:=Spalarge
	else Quantum:=Spasmall;
	if FRows=nil then FRows:=TSparseList.Create(Quantum);
	if FData=nil then FData:=TSparseList.Create(Quantum);
end;

procedure TSJ.SetUpdateState(Updating:Boolean);
begin
	FUpdating:=Updating;
	if not Updating and FNeedsUpdating then begin
		Invalidategrid;
		FNeedsUpdating:=False;
	end;
end;

procedure TSJ.Update(ACol,ARow:integer);
begin
	if not FUpdating then Invalidatecell(ACol,ARow)
	else FNeedsUpdating:=True;
	if (ACol=Col)and(ARow=Row)and(FEditUpdate=0) then Invalidateeditor;
end;

function TSJ.VisibleCol(ACol:integer):Boolean;
begin
	Result:=Cols[ACol].Outr.Cinfo.VIS;
end;

function TSJ.Prepare(Index:integer):TGRAMD;
var
	I,T:integer;
	SS1:TGRAMD;
begin
	Result:=nil;
	try
		if (Flist.Count-1>=index) then
			if (Flist[index]<>nil) then Result:=TGRAMD(Flist[index]);
		if (Flist.Count-1<index)or(Result=nil) then begin
			for I:=1 to Flist.Count-1-index do begin
				SS1:=TGRAMD.Create(Self,Flist.Count);
				Flist.Add(SS1);
			end;
			Result:=TGRAMD(Flist[index]);
		end;
	except
		on E:Exception do showmessage('Prepare'+#13+E.Message);
	end;
end;

function TSJ.GetCols(Index:integer):TGRAMD;
begin
	Result:=Prepare(index);
end;

procedure TSJ.SetCols(Index:integer;Value:TGRAMD);
begin
	// Prepare(Index).Assign(Value);
end;

procedure TSJ.SetColCount(Value:Longint);
var
	Ocol:integer;
	I:integer;
begin
	Ocol:=FColCount;
	inherited SetColCount(Value);
	if (Value>Ocol) then begin
		for I:=1 to Value-Flist.Count do Flist.Add(TGRAMD.Create(Self,Flist.Count+1));
	end else if (Value<Flist.Count) then begin
		for I:=Value to Flist.Count-1 do begin
			if Assigned(TGRAMD(Flist[I]).Outr.FObj) then TGRAMD(Flist[I]).Outr.FObj.Free;
			TGRAMD(Flist[I]).Destroy;
		end;
		Flist.Count:=Value;
	end;
	if Assigned(FOnColCountChange)and FIsCH then FOnColCountChange(Self,Value-Fixedcols,Ocol-Fixedcols);
end;

procedure TSJ.SetRowCount(Value:Longint);
var
	Orow:integer;
begin
	Orow:=FRowCount;
	inherited SetRowCount(Value);
	if Assigned(FOnRowCountChange)and FIsCH then FOnRowCountChange(Self,Value-Fixedrows,Orow-Fixedrows);
end;

function TSJ.GetCells(ACol,ARow:integer):string;
var
	SS2:TGRAMD;
begin
	Result:='';
	if FIsGT then // and(ACol>Fixedcols-1) (ARow>Fixedrows-1)and
		if Assigned(FOnCellTextGet) then FOnCellTextGet(Self,ACol,ARow,Result);
end;

procedure TSJ.SetCells(ACol,ARow:integer;Value:string);
var
	SS2:TGRAMD;
begin
	Update(ACol,ARow);
	if (ACol>Fixedcols-1)and FIsCH then // and(ARow>Fixedrows-1)
		if Assigned(FOnCellTextSet) then FOnCellTextSet(Self,ACol,ARow,Value);
end;

procedure TSJ.ColumnMoved(FromIndex,ToIndex:Longint);
var
	Otu,Otu1:PQr;
	I:integer;
begin
	Otu:=Cols[FromIndex].Outr;
	Otu1:=Cols[ToIndex].Outr;
	Flist.Exchange(FromIndex,ToIndex);
	Cols[ToIndex].Outr:=Otu;
	if (FromIndex<ToIndex) then begin
		for I:=FromIndex to ToIndex-2 do Cols[I].Outr:=Cols[I+1].Outr;
		Cols[ToIndex-1].Outr:=Otu1;
	end;
	if (FromIndex>ToIndex) then begin
		for I:=FromIndex downto ToIndex+1 do Cols[I].Outr:=Cols[I-1].Outr;
		Cols[ToIndex+1].Outr:=Otu1;
	end;
	Invalidate;
	inherited ColumnMoved(FromIndex,ToIndex);
end;

procedure TSJ.RowMoved(FromIndex,ToIndex:Longint);
begin
	Invalidate;
	inherited RowMoved(FromIndex,ToIndex);
end;

{ TSG }

constructor TSG.Create(Aowner:Tcomponent);
begin
	inherited Create(Aowner);
	Initialize;
	FDropDownRowCount:=8;
	FFxalgn:=Tacenter;
	FAlgn:=Tacenter;
	FFxFont:=TFont.Create;
	FFxFont.Assign(Font);
	FFxFont.Name:=Font.Name;
	FFxFont.Size:=Font.Size;
	FFxFont.Charset:=Font.Charset;
	FFxFont.Color:=Font.Color;
	FFxFont.Style:=Font.Style+[FSBOLD];
	FOdd:=False;
	FCURSOR:=Cursor;
	FOddc:=Clgradientinactivecaption;
	ColButton:=TSpeedButton.Create(Self);
	with ColButton do begin
		Layout:=Blglyphright;
		Font.Name:='Wingdings 3';
		Caption:='r'; // r s - p q
		Font.Size:=6;
		Parent:=Self;
		Font.Color:=Self.Font.Color;
		Cursor:=Crhandpoint;
		Flat:=True;
		Visible:=False;
	end;
	Controlstyle:=Controlstyle+[Csdisplaydragimage,Csreplicatable];
	Controlstate:=Controlstate+[Cspaintcopy];
end;

constructor TSG.CreateedView(Aowner:Tcomponent;AL:integer);
begin
	Create(Aowner);
	if (AL=2) then EnableCheckBoxes:=True;
end;

function TSG.CreateEditor:TSGInplaceEdit1;
begin
	Result:=TSGInplaceEdit1List1.Create(Self);
	with TSGInplaceEdit1List1(Result) do begin
		DropdownRows:=FDropDownRowCount;
		OnGetPicklistItems:=FOnGetPicklistItems;
		OnEditButtonClick:=FOnEditButtonClick1;
		ButtonWidth:=10;
	end;
end;

procedure TSG.Repaint;
begin
	ColButton.Font.Color:=Font.Color;
	inherited;
end;

function TSG.GetEditStyle(ACol,ARow:integer):TEditStyle;
begin
	Result:=Essimple;
	if Assigned(FOnGetEditStyle) then begin
		FOnGetEditStyle(Self,ACol,ARow,Result);
	end;
end;

procedure TSG.SetDropDownRowCount(Value:integer);
begin
	FDropDownRowCount:=Value;
	if Assigned(InplaceEditor) then begin
		TSGInplaceEdit1List1(InplaceEditor).DropdownRows:=Value;
	end;
end;

procedure TSG.SetOnEditButtonClick(Value:TNotifyEvent);
begin
	FOnEditButtonClick1:=Value;
	if Assigned(InplaceEditor) then begin
		TSGInplaceEdit1List1(InplaceEditor).OnEditButtonClick:=Value;
	end;
end;

procedure TSG.SetOnGetPicklistItems(Value:TOnGetPicklistItems);
begin
	FOnGetPicklistItems:=Value;
	if Assigned(InplaceEditor) then begin
		TSGInplaceEdit1List1(InplaceEditor).OnGetPicklistItems:=Value;
	end;
end;

{$IF DEFINED(CLR)}

function Freeitem(Theindex:integer;Theitem:TObject):integer;
begin
	Theitem.Free;
	Result:=0;
end;
{$ENDIF}

destructor TSG.Destroy;

{$IF NOT DEFINED(CLR)}
var
	Freecallback:Tspaapply;
{$ENDIF}
begin
{$IF NOT DEFINED(CLR)}
	Freecallback:=function(Theindex:integer;Theitem:Pointer):integer
		begin
			TObject(Theitem).Free;
			Result:=0;
		end;
{$ENDIF}
	if FRows<>nil then begin
{$IF DEFINED(CLR)}
		TSparseList(FRows).ForAll(@Freeitem);
{$ELSE}
		TSparseList(FRows).ForAll(Freecallback);
{$ENDIF}
		TSparseList(FRows).Free;
	end;
	if FCols<>nil then begin
{$IF DEFINED(CLR)}
		TSparseList(FCols).ForAll(@Freeitem);
{$ELSE}
		TSparseList(FCols).ForAll(Freecallback);
{$ENDIF}
		TSparseList(FCols).Free;
	end;
	if FData<>nil then begin
{$IF DEFINED(CLR)}
		TSparseList(FData).ForAll(@Freeitem);
{$ELSE}
		TSparseList(FData).ForAll(Freecallback);
{$ENDIF}
		TSparseList(FData).Free;
	end;
	ColButton.Free;
	FFxFont.Free;
	FFxFont:=nil;
	inherited Destroy;
end;

{$IF DEFINED(CLR)}

function TSG.MoveColData(Index:integer;ARow:TObject):integer;
begin
	TStringSparseList(ARow).Move(FTempFrom,FTempTo);
	Result:=0;
end;
{$ENDIF}

procedure TSG.ColumnMoved(FromIndex,ToIndex:Longint);
begin
{$IF DEFINED(CLR)}
	FTempFrom:=FromIndex;
	FTempTo:=ToIndex;
	TSparseList(FData).ForAll(@MoveColData);
{$ELSE}
	TSparseList(FData).ForAll(function(Index:integer;ARow:Pointer):integer
		begin
			TStringSparseList(ARow).Move(FromIndex,ToIndex);
			Result:=0;
		end);
{$ENDIF}
	Invalidate;
	inherited ColumnMoved(FromIndex,ToIndex);
end;

procedure TSG.RowMoved(FromIndex,ToIndex:Longint);
begin
	TSparseList(FData).Move(FromIndex,ToIndex);
	Invalidate;
	inherited RowMoved(FromIndex,ToIndex);
end;

function TSG.GetEditText(ACol,ARow:Longint):string;
begin
	Result:=Cells[ACol,ARow];
	if Assigned(Fongetedittext) then Fongetedittext(Self,ACol,ARow,Result);
end;

procedure TSG.SetEditText(ACol,ARow:Longint;const Value:string);
begin
	DisableEditUpdate;
	try
		if Value<>Cells[ACol,ARow] then Cells[ACol,ARow]:=Value;
	finally EnableEditUpdate;
	end;
	inherited SetEditText(ACol,ARow,Value);
end;

procedure TSG.Drawcell(ACol,ARow:Longint;Arect:TRect;AState:TGridDrawState);
const
	Ccellnormal: array [TGridDrawingStyle] of Tthemedgrid=(Tgclassiccellnormal,Tgcellnormal,Tggradientcellnormal);
	Ccellselected: array [TGridDrawingStyle] of Tthemedgrid=(Tgclassiccellselected,Tgcellselected,Tggradientcellselected);
	Cfixednormal: array [TGridDrawingStyle] of Tthemedgrid=(Tgclassicfixedcellnormal,Tgfixedcellnormal,
		Tggradientfixedcellnormal);
	Cfixedhot: array [TGridDrawingStyle] of Tthemedgrid=(Tgclassicfixedcellhot,Tgfixedcellhot,Tggradientfixedcellhot);
	Cfixedpressed: array [TGridDrawingStyle] of Tthemedgrid=(Tgclassicfixedcellpressed,Tgfixedcellpressed,
		Tggradientfixedcellpressed);
	Alignflags: array [TAlignment] of integer=(Dt_left or Dt_vcenter,Dt_right or Dt_vcenter,Dt_center or Dt_vcenter);
	// or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX
var
	Ltext:string;
	Ldetails:Tthemedelementdetails;
	Algn1:Cardinal;
	H:Htheme;
	S:Tsize;
	R:TRect;
	Lstyle:Tcustomstyleservices;
	D,T:integer;
begin
	if Defaultdrawing then begin
		Ltext:=Cells[ACol,ARow];
		R:=Cellrect(ACol,ARow);
		Lstyle:=Styleservices;
		if Styleservices.Enabled then begin
			Arect.Left:=Arect.Left+4;
			if (GDFixed in AState) then begin
				if GDHotTrack in AState then Ldetails:=Styleservices.Getelementdetails(Cfixedhot[FInternalDrawingStyle])
				else if GDPressed in AState then Ldetails:=Styleservices.Getelementdetails(Cfixedpressed[FInternalDrawingStyle])
				else Ldetails:=Styleservices.Getelementdetails(Cfixednormal[FInternalDrawingStyle])
			end else begin
				if (GDSelected in AState)or(GDRowSelected in AState) then
						Ldetails:=Styleservices.Getelementdetails(Ccellselected[FInternalDrawingStyle])
				else Ldetails:=Styleservices.Getelementdetails(Ccellnormal[FInternalDrawingStyle]);
			end;
			// LStyle.DrawElement(Canvas.Handle,LDetails,R,@ARect);
			Arect.Top:=Arect.Top+((Arect.Height-Canvas.Textheight(Ltext))div 2);
		end else begin
			Arect.Top:=Arect.Top+2;
		end;
		if (GDFixed in AState) then begin
			Canvas.Font.Assign(FFxFont);
			Algn1:=Alignflags[FFxalgn];
		end else begin
			if FOdd then begin
				if Odd(Fixedrows) then begin
					if not Odd(ARow) then begin
						if ((Canvas.Brush.Color=Color)or(FDrawingStyle=GdsThemed)or Tstylemanager.Iscustomstyleactive)and
							not(GDSelected in AState) then begin
							Canvas.Brush.Color:=FOddc;
							Canvas.Fillrect(R);
						end;
					end;
				end else begin
					if Odd(ARow) then begin
						if ((Canvas.Brush.Color=Color)or(FDrawingStyle=GdsThemed)or Tstylemanager.Iscustomstyleactive)and
							not(GDSelected in AState) then begin
							Canvas.Brush.Color:=FOddc;
							Canvas.Fillrect(R);
						end;
					end;
				end;
			end;
			Canvas.Font.Assign(Font);
			Algn1:=Alignflags[FAlgn];
		end;

		if (ACol=0)and FChks then begin
			S.Cx:=Getsystemmetrics(Sm_cxmenucheck);
			S.Cy:=Getsystemmetrics(Sm_cymenucheck);
			if Usethemes then begin
				if (ARow=0) then begin
					T:=Rows[0].Tag;
					case T of
						0:T:=CBS_UNCHECKEDNORMAL;
						1:T:=CBS_CHECKEDNORMAL;
						2:T:=CBS_MIXEDNORMAL;
					else T:=CBS_UNCHECKEDNORMAL;
					end;
				end else begin
					T:=Rows[ARow].Tag;
					case T of
						0:T:=CBS_UNCHECKEDNORMAL;
						1:T:=CBS_CHECKEDNORMAL;
					end;
				end;
				H:=Openthemedata(Handle,Pchar('BUTTON'));
				if (H<>0) then begin
					try
						Getthemepartsize(H,Canvas.Handle,BP_CHECKBOX,CBS_CHECKEDNORMAL,nil,Ts_draw,S);
						Drawthemebackground(H,Canvas.Handle,BP_CHECKBOX,T,R,nil);
					finally Closethemedata(H);
					end;
				end;
			end else begin
				if (ARow=0) then begin
					T:=Rows[0].Tag;
					case T of
						0:T:=DFCS_BUTTONCHECK;
						1:T:=DFCS_CHECKED;
						2:T:=DFCS_MONO;
					else T:=DFCS_BUTTONCHECK;
					end;
				end else begin
					T:=Rows[ARow].Tag;
					case T of
						0:T:=DFCS_BUTTONCHECK;
						1:T:=DFCS_CHECKED;
					end;
				end;
				Drawframecontrol(Canvas.Handle,R,Dfc_button,T);
			end;
		end;
		if (ARow>Fixedrows-1)and(ACol>Fixedcols-1)and FChks and(Rows[ARow].Tag=1) then begin
			Canvas.Brush.Color:=clWebCadetBlue;
			Canvas.Fillrect(R);
		END;
		if Userighttoleftalignment then begin
			with Arect do Canvas.Textrect(Arect,Left+((Width-Canvas.Textwidth(Ltext))div 2),Top,Ltext);
		end
		else Drawtext(Canvas.Handle,Pchar(Ltext),Length(Ltext),Arect,Algn1);
		inherited Drawcell(ACol,ARow,Arect,AState);
	end;
end;

procedure TSG.DisableEditUpdate;
begin
	Inc(FEditUpdate);
end;

procedure TSG.EnableEditUpdate;
begin
	Dec(FEditUpdate);
end;

procedure TSG.SetFont(Value:TFont);
begin
	FFxFont.Assign(Value);
end;

procedure TSG.Initialize;
var
	Quantum:TSpaQuantum;
begin
	if FCols=nil then begin
		if Colcount>512 then Quantum:=Spalarge
		else Quantum:=Spasmall;
		FCols:=TSparseList.Create(Quantum);
	end;
	if RowCount>256 then Quantum:=Spalarge
	else Quantum:=Spasmall;
	if FRows=nil then FRows:=TSparseList.Create(Quantum);
	if FData=nil then FData:=TSparseList.Create(Quantum);
end;

procedure TSG.SetUpdateState(Updating:Boolean);
begin
	FUpdating:=Updating;
	if not Updating and FNeedsUpdating then begin
		Invalidategrid;
		FNeedsUpdating:=False;
	end;
end;

procedure TSG.Update(ACol,ARow:integer);
begin
	if not FUpdating then Invalidatecell(ACol,ARow)
	else FNeedsUpdating:=True;
	if (ACol=Col)and(ARow=Row)and(FEditUpdate=0) then Invalidateeditor;
end;

function TSG.EnsureColRow(Index:integer;IsCol:Boolean):TStringGridStrings;
{$IF DEFINED(CLR)}
var
	RCIndex:integer;
	List:TSparseList;
begin
	if IsCol then List:=TSparseList(FCols)
	else List:=TSparseList(FRows);
	Result:=TStringGridStrings(List[index]);
	if Result=nil then begin
		if IsCol then RCIndex:=-(index+1)
		else RCIndex:=index+1;
		Result:=TStringGridStrings.Create(Self,RCIndex);
		List[index]:=Result;
	end;
{$ELSE}

var
	RCIndex:integer;
	Plist:^TSparseList;
begin
	if IsCol then Plist:=@FCols
	else Plist:=@FRows;
	Result:=TStringGridStrings(Plist^[index]);
	if Result=nil then begin
		if IsCol then RCIndex:=-(index+1)
		else RCIndex:=index+1;
		Result:=TStringGridStrings.Create(Self,RCIndex);
		Result.Tag:=index;
		Plist^[index]:=Result;
	end;
{$ENDIF}
end;

function TSG.EnsureDataRow(ARow:integer):TCustomData;
var
	Quantum:TSpaQuantum;
begin
{$IF DEFINED(CLR)}
	Result:=TSparseList(FData)[ARow];
{$ELSE}
	Result:=TStringSparseList(TSparseList(FData)[ARow]);
{$ENDIF}
	if Result=nil then begin
		if Colcount>512 then Quantum:=Spalarge
		else Quantum:=Spasmall;
		Result:=TStringSparseList.Create(Quantum);
		TSparseList(FData)[ARow]:=Result;
	end;
end;

function TSG.GetCells(ACol,ARow:integer):string;
var
	Ssl:TStringSparseList;
begin
	Ssl:=TStringSparseList(TSparseList(FData)[ARow]);
	if Ssl=nil then Result:=''
	else Result:=Ssl[ACol];
end;

function TSG.GetCols(Index:integer):TStringGridStrings;
begin
	Result:=EnsureColRow(index,True);
end;

function TSG.GetObjects(ACol,ARow:integer):TObject;
var
	Ssl:TStringSparseList;
begin
	Ssl:=TStringSparseList(TSparseList(FData)[ARow]);
	if Ssl=nil then Result:=nil
	else Result:=Ssl.Objects[ACol];
end;

function TSG.GetRows(Index:integer):TStringGridStrings;
begin
	Result:=EnsureColRow(index,False);
end;

procedure TSG.SetCells(ACol,ARow:integer;Value:string);
begin
{$IF DEFINED(CLR)}
	TStringSparseList(EnsureDataRow(ARow))[ACol]:=Value;
{$ELSE}
	TStringGridStrings(EnsureDataRow(ARow))[ACol]:=Value;
{$ENDIF}
	EnsureColRow(ACol,True);
	EnsureColRow(ARow,False);
	Update(ACol,ARow);
end;

procedure TSG.SetCols(Index:integer;Value:TStringGridStrings);
begin
	EnsureColRow(index,True).Assign(Value);
end;

procedure TSG.SetObjects(ACol,ARow:integer;Value:TObject);
begin
{$IF DEFINED(CLR)}
	TStringSparseList(EnsureDataRow(ARow)).Objects[ACol]:=Value;
{$ELSE}
	TStringGridStrings(EnsureDataRow(ARow)).Objects[ACol]:=Value;
{$ENDIF}
	EnsureColRow(ACol,True);
	EnsureColRow(ARow,False);
	Update(ACol,ARow);
end;

procedure TSG.SetRows(Index:integer;Value:TStringGridStrings);
begin
	EnsureColRow(index,False).Assign(Value);
end;

type

	{ TPopupListbox }

	Tpopuplistbox=class(TCustomListBox)
	private
		Fsearchtext:string;
		Fsearchtickcount:Longint;
	protected
		procedure CreateParams(var Params:Tcreateparams);Override;
		procedure CreateWND;Override;
		procedure Keypress(var Key:Char);Override;
		procedure MouseUp(Button:Tmousebutton;Shift:Tshiftstate;X,Y:integer);Override;
	end;

procedure Tpopuplistbox.CreateParams(var Params:Tcreateparams);
begin
	inherited CreateParams(Params);
	with Params do begin
		Style:=Style or Ws_border;
		Exstyle:=Ws_ex_toolwindow or Ws_ex_topmost;
		Addbidimodeexstyle(Exstyle);
		Windowclass.Style:=Cs_savebits;
	end;
end;

[Uipermission(Securityaction.Linkdemand,Window=Uipermissionwindow.Allwindows)]
procedure Tpopuplistbox.CreateWND;
begin
	inherited CreateWND;
	Winapi.Windows.Setparent(Handle,0);
	Callwindowproc(Defwndproc,Handle,Wm_setfocus,0,0);
end;

procedure Tpopuplistbox.Keypress(var Key:Char);
var
	Tickcount:integer;
begin
	case Key of
		#8,#27:Fsearchtext:='';
		#32.. high(Char):begin
				Tickcount:=Gettickcount;
				if Tickcount-Fsearchtickcount>2000 then Fsearchtext:='';
				Fsearchtickcount:=Tickcount;
				if Length(Fsearchtext)<32 then Fsearchtext:=Fsearchtext+Key;
				Sendtextmessage(Handle,Lb_selectstring,Word(-1),Fsearchtext);
				Key:=#0;
			end;
	end;
	inherited Keypress(Key);
end;

procedure Tpopuplistbox.MouseUp(Button:Tmousebutton;Shift:Tshiftstate;X,Y:integer);
begin
	inherited MouseUp(Button,Shift,X,Y);
	TSGInplaceEdit1List1(Owner).Closeup((X>=0)and(Y>=0)and(X<Width)and(Y<Height));
end;

{ TSGInplaceEdit1List1 }

constructor TSGInplaceEdit1List1.Create(Owner:Tcomponent);
begin
	inherited Create(Owner);
	Fbuttonwidth:=Getsystemmetrics(Sm_cxvscroll);
	Feditstyle:=Essimple;
end;

procedure TSGInplaceEdit1List1.BoundsChanged;
var
	R:TRect;
begin
	Setrect(R,2,2,Width-2,Height);
	if EditStyle<>Essimple then
		if not Grid.Userighttoleftalignment then Dec(R.Right,ButtonWidth+2)
		else Inc(R.Left,ButtonWidth-2);
	Sendstructmessage(Handle,Em_setrectnp,0,R);
	Sendmessage(Handle,Em_scrollcaret,0,0);
	if Syslocale.Fareast then Setimecompositionwindow(Font,R.Left,R.Top);
end;

procedure TSGInplaceEdit1List1.Closeup(Accept:Boolean);
var
	Listvalue:Variant;
begin
	if ListVisible and(ActiveList=Fpicklist) then begin
		if Getcapture<>0 then Sendmessage(Getcapture,Wm_cancelmode,0,0);
		if Picklist.Itemindex<>-1 then
{$IF DEFINED(CLR)}
			Listvalue:=Picklist.Items[Picklist.Itemindex]
		else Listvalue:=Unassigned;
{$ELSE}
			Listvalue:=Picklist.Items[Picklist.Itemindex];
{$ENDIF}
		Setwindowpos(ActiveList.Handle,0,0,0,0,0,Swp_nozorder or Swp_nomove or Swp_nosize or Swp_noactivate or
			Swp_hidewindow);
		Flistvisible:=False;
		Invalidate;
		if Accept then
			if (not Varisempty(Listvalue)or Varisnull(Listvalue))and(Vartostr(Listvalue)<>TEXT) then begin
				{ Here we store the new value directly in the edit control so that
					we bypass the CMTextChanged method on TCustomMaskedEdit.  This
					preserves the old value so that we can restore it later by calling
					the Reset method. }
{$IF DEFINED(CLR)}
				Perform(WM_SETTEXT,0,Vartostr(Listvalue));
{$ELSE}
				Perform(WM_SETTEXT,0,Lparam(string(Listvalue)));
{$ENDIF}
				Modified:=True;
				with Grid do SetEditText(Col,Row,Vartostr(Listvalue));
			end;
	end;
end;

procedure TSGInplaceEdit1List1.DoDropDownKeys(var Key:Word;Shift:Tshiftstate);
begin
	case Key of
		Vk_up,Vk_down: if Ssalt in Shift then begin
				if ListVisible then Closeup(True)
				else DropDown;
				Key:=0;
			end;
		VK_RETURN,Vk_escape: if ListVisible and not(Ssalt in Shift) then begin
				Closeup(Key=VK_RETURN);
				Key:=0;
			end;
	end;
end;

procedure TSGInplaceEdit1List1.DoEditButtonClick;
begin
	if Assigned(Foneditbuttonclick) then Foneditbuttonclick(Grid);
end;

procedure TSGInplaceEdit1List1.DoGetPicklistItems;
begin
	if not PicklistLoaded then begin
		if Assigned(OnGetPicklistItems) then OnGetPicklistItems(Grid.Col,Grid.Row,Picklist.Items);
		PicklistLoaded:=(Picklist.Items.Count>0);
	end;
end;

function TSGInplaceEdit1List1.Getpicklist:TCustomListBox;
var
	Popuplistbox:Tpopuplistbox;
begin
	if not Assigned(Fpicklist) then begin
		Popuplistbox:=Tpopuplistbox.Create(Self);
		Popuplistbox.Visible:=False;
		Popuplistbox.Parent:=Self;
		Popuplistbox.OnMouseUp:=ListMouseUp;
		Popuplistbox.Integralheight:=True;
		Popuplistbox.Itemheight:=11;
		Fpicklist:=Popuplistbox;
	end;
	Result:=Fpicklist;
end;

procedure TSGInplaceEdit1List1.DropDown;
var
	P:TPoint;
	I,J,Y:integer;
begin
	if not ListVisible then begin
		ActiveList.Width:=Width;
		if ActiveList=Fpicklist then begin
			DoGetPicklistItems;
			Tpopuplistbox(Picklist).Color:=Color;
			Tpopuplistbox(Picklist).Font:=Font;
			Tpopuplistbox(Picklist).StyleElements:=StyleElements;
			if (DropdownRows>0)and(Picklist.Items.Count>=DropdownRows) then
					Picklist.Height:=DropdownRows*Tpopuplistbox(Picklist).Itemheight+4
			else Picklist.Height:=Picklist.Items.Count*Tpopuplistbox(Picklist).Itemheight+4;
			if TEXT='' then Picklist.Itemindex:=-1
			else Picklist.Itemindex:=Picklist.Items.Indexof(TEXT);
			J:=Picklist.Clientwidth;
			for I:=0 to Picklist.Items.Count-1 do begin
				Y:=Picklist.Canvas.Textwidth(Picklist.Items[I]);
				if Y>J then J:=Y;
			end;
			Picklist.Clientwidth:=J;
		end;
		P:=Parent.Clienttoscreen(Point(Left,Top));
		Y:=P.Y+Height;
		if Y+ActiveList.Height>Screen.Height then Y:=P.Y-ActiveList.Height;
		Setwindowpos(ActiveList.Handle,Hwnd_top,P.X,Y,0,0,Swp_nosize or Swp_noactivate or Swp_showwindow);
		Flistvisible:=True;
		Invalidate;
		Winapi.Windows.Setfocus(Handle);
	end;
end;

procedure TSGInplaceEdit1List1.KeyDown(var Key:Word;Shift:Tshiftstate);
begin
	if (EditStyle=Esellipsis)and(Key=VK_RETURN)and(Shift=[Ssctrl]) then begin
		DoEditButtonClick;
		Killmessage(Handle,Wm_char);
	end
	else inherited KeyDown(Key,Shift);
end;

procedure TSGInplaceEdit1List1.ListMouseUp(Sender:TObject;Button:Tmousebutton;Shift:Tshiftstate;X,Y:integer);
begin
	if Button=Mbleft then Closeup(ActiveList.Clientrect.Contains(Point(X,Y)));
end;

procedure TSGInplaceEdit1List1.MouseDown(Button:Tmousebutton;Shift:Tshiftstate;X,Y:integer);
begin
	if (Button=Mbleft)and(EditStyle<>Essimple)and OverButton(Point(X,Y)) then begin
		if ListVisible then Closeup(False)
		else begin
			Mousecapture:=True;
			Ftracking:=True;
			TrackButton(X,Y);
			if Assigned(ActiveList) then DropDown;
		end;
	end;
	inherited MouseDown(Button,Shift,X,Y);
end;

procedure TSGInplaceEdit1List1.MouseMove(Shift:Tshiftstate;X,Y:integer);
var
	Listpos:TPoint;
begin
	if Ftracking then begin
		TrackButton(X,Y);
		if ListVisible then begin
			Listpos:=ActiveList.Screentoclient(Clienttoscreen(Point(X,Y)));
			if ActiveList.Clientrect.Contains(Listpos) then begin
				StopTracking;
				Sendmessage(ActiveList.Handle,Wm_lbuttondown,0,Pointtolparam(Listpos));
				Exit;
			end;
		end;
	end;
	inherited MouseMove(Shift,X,Y);
end;

procedure TSGInplaceEdit1List1.MouseUp(Button:Tmousebutton;Shift:Tshiftstate;X,Y:integer);
var
	Waspressed:Boolean;
begin
	Waspressed:=Pressed;
	StopTracking;
	if (Button=Mbleft)and(EditStyle=Esellipsis)and Waspressed then DoEditButtonClick;
	inherited MouseUp(Button,Shift,X,Y);
end;

procedure TSGInplaceEdit1List1.PaintWindow(Dc:Hdc);
var
	R,Updater:TRect;
	Flags,Saveindex:integer;
	w,X,Y:integer;
	Lstyle:Tcustomstyleservices;
	Details:Tthemedelementdetails;
	Fcanvas:TCanvas;
	Lcolor:TColor;
begin
	if EditStyle<>Essimple then begin
		R:=ButtonRect;
		Flags:=0;
		Lstyle:=Styleservices;
		if not(Seclient in StyleElements)or not Tstylemanager.Iscustomstyleactive then begin
			Updater:=Clientrect;
			Fcanvas:=TCanvas.Create;
			try
				Fcanvas.Handle:=Dc;
				Saveindex:=Savedc(Fcanvas.Handle);
				try
					Fcanvas.Brush.Color:=Brush.Color;
					Fcanvas.Fillrect(Updater);
				finally Restoredc(Fcanvas.Handle,Saveindex);
				end;
			finally
				Fcanvas.Handle:=0;
				Fcanvas.Free;
			end;
		end;
		case EditStyle of
			Espicklist:begin
					if Lstyle.Enabled then begin
						if ActiveList=nil then Details:=Lstyle.Getelementdetails(Tgdropdownbuttondisabled)
						else if Pressed then Details:=Lstyle.Getelementdetails(Tgdropdownbuttonpressed)
						else if Fmouseincontrol then Details:=Lstyle.Getelementdetails(Tgdropdownbuttonhot)
						else Details:=Lstyle.Getelementdetails(Tgdropdownbuttonnormal);
						Lstyle.Drawelement(Dc,Details,R);
					end else begin
						if ActiveList=nil then Flags:=Dfcs_inactive
						else if Pressed then Flags:=Dfcs_flat or Dfcs_pushed;
						Drawframecontrol(Dc,R,Dfc_scroll,Flags or Dfcs_scrollcombobox);
					end;
				end;
			Esellipsis:begin
					if Lstyle.Enabled then begin
						if Pressed then Details:=Lstyle.Getelementdetails(Tgellipsisbuttonpressed)
						else if Fmouseincontrol then Details:=Lstyle.Getelementdetails(Tgellipsisbuttonhot)
						else Details:=Lstyle.Getelementdetails(Tgellipsisbuttonnormal);
						Lstyle.Drawelement(Dc,Details,R);
					end else begin
						if Pressed then Flags:=Bf_flat;
						Drawedge(Dc,R,Edge_raised,Bf_rect or Bf_middle or Flags);
					end;

					X:=R.Left+((R.Right-R.Left) shr 1)-1+Ord(Pressed);
					Y:=R.Top+((R.Bottom-R.Top) shr 1)-1+Ord(Pressed);
					w:=ButtonWidth shr 3;
					if w=0 then w:=1;
					if Lstyle.Enabled and Tstylemanager.Iscustomstyleactive then begin
						Fcanvas:=TCanvas.Create;
						try
							Fcanvas.Handle:=Dc;
							if Pressed then Details:=Lstyle.Getelementdetails(Tbpushbuttonpressed)
							else if Fmouseincontrol then Details:=Lstyle.Getelementdetails(Tbpushbuttonhot)
							else Details:=Lstyle.Getelementdetails(Tbpushbuttonnormal);
							if not Lstyle.Getelementcolor(Details,Ectextcolor,Lcolor) then Lcolor:=Lstyle.Getsystemcolor(Clbtntext);
							Fcanvas.Brush.Color:=Lcolor;
							Patblt(Fcanvas.Handle,X,Y,w,w,Patcopy);
							Patblt(Fcanvas.Handle,X-(w*2),Y,w,w,Patcopy);
							Patblt(Fcanvas.Handle,X+(w*2),Y,w,w,Patcopy);
						finally
							Fcanvas.Handle:=0;
							Fcanvas.Free;
						end;
					end else begin
						Patblt(Dc,X,Y,w,w,Blackness);
						Patblt(Dc,X-(w*2),Y,w,w,Blackness);
						Patblt(Dc,X+(w*2),Y,w,w,Blackness);
					end;
				end;
		end;
		Excludecliprect(Dc,R.Left,R.Top,R.Right,R.Bottom);
	end else begin
		if not(Seclient in StyleElements)or not Tstylemanager.Iscustomstyleactive then begin
			Updater:=Clientrect;
			Fcanvas:=TCanvas.Create;
			try
				Fcanvas.Handle:=Dc;
				Fcanvas.Brush.Color:=Brush.Color;
				Saveindex:=Savedc(Fcanvas.Handle);
				try
					Excludecliprect(Fcanvas.Handle,2,2,Width-2,Height-2);
					Fcanvas.Fillrect(Updater);
				finally Restoredc(Dc,Saveindex);
				end;
			finally
				Fcanvas.Handle:=0;
				Fcanvas.Free;
			end;
		end;
	end;
	inherited PaintWindow(Dc);
end;

procedure TSGInplaceEdit1List1.StopTracking;
begin
	if Ftracking then begin
		TrackButton(-1,-1);
		Ftracking:=False;
		Mousecapture:=False;
	end;
end;

procedure TSGInplaceEdit1List1.TrackButton(X,Y:integer);
var
	Newstate:Boolean;
	R:TRect;
begin
	R:=ButtonRect;
	Newstate:=R.Contains(Point(X,Y));
	if Pressed<>Newstate then begin
		Fpressed:=Newstate;
		InvalidateRect(Handle,R,False);
	end;
end;

procedure TSGInplaceEdit1List1.UpdateContents;
begin
	ActiveList:=nil;
	PicklistLoaded:=False;
	Feditstyle:=Grid.GetEditStyle(Grid.Col,Grid.Row);
	if EditStyle=Espicklist then ActiveList:=Picklist;
	inherited UpdateContents;
end;

procedure TSGInplaceEdit1List1.RestoreContents;
begin
	Reset;
	Grid.UpdateText;
end;

procedure TSGInplaceEdit1List1.CMCancelMode(var Message:TCMCancelMode);
begin
	if (message.Sender<>Self)and(message.Sender<>ActiveList) then Closeup(False);
end;

procedure TSGInplaceEdit1List1.WMCancelMode(var Message:Twmcancelmode);
begin
	StopTracking;
	inherited;
end;

procedure TSGInplaceEdit1List1.WMKillFocus(var Message:Twmkillfocus);
begin
	if not Syslocale.Fareast then begin
		inherited;
	end else begin
		Imename:=Screen.Defaultime;
		Imemode:=Imdontcare;
		inherited;
		if HWND(message.Focusedwnd)<>Grid.Handle then Activatekeyboardlayout(Screen.Defaultkblayout,Klf_activate);
	end;
	Closeup(False);
end;

function TSGInplaceEdit1List1.ButtonRect:TRect;
begin
	if not Grid.Userighttoleftalignment then Result:=Rect(Width-ButtonWidth,0,Width,Height)
	else Result:=Rect(0,0,ButtonWidth,Height);
end;

function TSGInplaceEdit1List1.OverButton(const P:TPoint):Boolean;
begin
	Result:=ButtonRect.Contains(P);
end;

procedure TSGInplaceEdit1List1.WMLButtonDblClk(var Message:Twmlbuttondblclk);
begin
	with message do
		if (EditStyle<>Essimple)and OverButton(Point(Xpos,Ypos)) then Exit;
	inherited;
end;

procedure TSGInplaceEdit1List1.WMPaint(var Message:Twmpaint);
begin
	Painthandler(message);
end;

procedure TSGInplaceEdit1List1.WMSetCursor(var Message:Twmsetcursor);
var
	P:TPoint;
begin
	Getcursorpos(P);
	P:=Screentoclient(P);
	if (EditStyle<>Essimple)and OverButton(P) then Winapi.Windows.Setcursor(Loadcursor(0,Idc_arrow))
	else inherited;
end;

procedure TSGInplaceEdit1List1.WndProc(var Message:TMessage);
var
	Thechar:Word;
begin
	case message.Msg of
		Wm_keydown,Wm_syskeydown,Wm_char:begin
				if EditStyle=Espicklist then
					with Twmkey(message) do begin
						Thechar:=Charcode;
						DoDropDownKeys(Thechar,Keydatatoshiftstate(Keydata));
						Charcode:=Thechar;
						if (Charcode<>0)and ListVisible then begin
							with message do Sendmessage(ActiveList.Handle,Msg,Wparam,Lparam);
							Exit;
						end;
					end;
				// APPLICATION.MainForm.Caption:=message.Wparam.ToString;
			end;
	end;
	inherited WndProc(message);
end;

procedure TSGInplaceEdit1List1.DblClick;
var
	Index:integer;
	Listvalue:string;
begin
	if (EditStyle=Essimple)or Assigned(Grid.OnDblclick) then inherited
	else if (EditStyle=Espicklist)and(ActiveList=Picklist) then begin
		DoGetPicklistItems;
		if Picklist.Items.Count>0 then begin
			index:=Picklist.Itemindex+1;
			if index>=Picklist.Items.Count then index:=0;
			Picklist.Itemindex:=index;
			Listvalue:=Picklist.Items[Picklist.Itemindex];
{$IF DEFINED(CLR)}
			Perform(WM_SETTEXT,0,Listvalue);
{$ELSE}
			Perform(WM_SETTEXT,0,Lparam(Listvalue));
{$ENDIF}
			Modified:=True;
			with Grid do SetEditText(Col,Row,Listvalue);
			Selectall;
		end;
	end else if EditStyle=Esellipsis then DoEditButtonClick;
end;

procedure TSGInplaceEdit1List1.CMMouseEnter(var Message:TMessage);
begin
	inherited;
	if Styleservices.Enabled and not Fmouseincontrol then begin
		Fmouseincontrol:=True;
		Invalidate;
	end;
end;

procedure TSGInplaceEdit1List1.CMMouseLeave(var Message:TMessage);
begin
	inherited;
	if Styleservices.Enabled and Fmouseincontrol then begin
		Fmouseincontrol:=False;
		Invalidate;
	end;
end;

/// ///////////////////////            TAutoC          //////////////////////////////////

constructor TAutoC.Create(Aowner:Tcomponent);
begin
	inherited Create(Aowner);
	FHWND:=TWincontrol(Aowner).Handle;
	Fflug:=(ACO_AUTOAPPEND or ACO_AUTOSUGGEST or ACO_USETAB or // ACO_UPDOWNKEYDROPSLIST or
		ACO_FILTERPREFIXES);
	FAutoComplete:=CreateComObject(CLSID_AutoComplete) as IAutoComplete;
	FObjMgr:=CreateComObject(CLSID_ACLMulti) as IObjMgr;
	FAutoComplete.Init(FHWND,FObjMgr,nil,nil);
	if Supports(FAutoComplete,IAutoComplete2,FAutoComplete2) then FAutoComplete2.SetOptions(Fflug);
	Supports(FAutoComplete,IAutoCompleteDropDown,FAutoCompleteDropDown);
end;

destructor TAutoC.Destroy;
begin
	FAutoComplete:=nil;
	FAutoComplete2:=nil;
	FAutoCompleteDropDown:=nil;
	FObjMgr.Remove(FEnum);
	FObjMgr:=nil;
	FEnum:=nil;
	inherited Destroy;
end;

procedure TAutoC.SetRTL(Value:Boolean);
begin
	FRTL:=Value;
	if Value then Fflug:=Fflug or ACO_RTLREADING
	else Fflug:=Fflug-ACO_RTLREADING;
	FAutoComplete2.SetOptions(Fflug)
end;

procedure TAutoC.SetSearch(Value:Boolean);
begin
	FSearch:=Value;
	if Value then Fflug:=Fflug or ACO_SEARCH
	else Fflug:=Fflug-ACO_SEARCH;
	FAutoComplete2.SetOptions(Fflug)
end;

procedure TAutoC.SetStrings(Value:TStrings);
begin
	FStrings:=Value;
	if Assigned(FEnum) then begin
		FObjMgr.Remove(FEnum);
		FEnum._Release;
	end;
	FEnum:=TEnumString.Create(Value);
	FObjMgr.Append(FEnum);
end;

/// ///////////////////////            TEnumString          //////////////////////////////////

constructor TEnumString.Create(AStrings:TStrings;Aindex:integer=0);
begin
	inherited Create;
	FStrings:=AStrings;
	FCurrIndex:=Aindex;
end;

function TEnumString.Clone(out Enm:IEnumString):HResult;
begin
	Enm:=TEnumString.Create(FStrings,FCurrIndex);
	Result:=S_OK;
end;

function TEnumString.Next(Celt:integer;out Elt;PCeltfetched:PLongint):HResult;
type
	TPointerList=array [0..0] of Pointer;
var
	I:integer;
	WStr:WideString;
begin
	I:=0;
	while (I<Celt)and(FCurrIndex<FStrings.Count) do begin
		WStr:=FStrings[FCurrIndex];
		TPointerList(Elt)[I]:=CoTaskMemAlloc(2*(Length(WStr)+1));
		StringToWideChar(WStr,TPointerList(Elt)[I],2*(Length(WStr)+1));
		Inc(I);
		Inc(FCurrIndex);
	end;
	if PCeltfetched<>nil then PCeltfetched^:=I;
	if I=Celt then Result:=S_OK
	else Result:=S_FALSE;
end;

function TEnumString.Reset:HResult;
begin
	FCurrIndex:=0;
	Result:=S_OK;
end;

function TEnumString.Skip(Celt:integer):HResult;
begin
	if (FCurrIndex+Celt)<=FStrings.Count then begin
		Inc(FCurrIndex,Celt);
		Result:=S_OK;
	end else begin
		FCurrIndex:=FStrings.Count;
		Result:=S_FALSE;
	end;
end;

/// ///////////////////////                class          //////////////////////////////////

class constructor TSGDrawGrid1.Create;
begin
	Tcustomstyleengine.Registerstylehook(TSGDrawGrid1,Tscrollingstylehook);
end;

class destructor TSGDrawGrid1.Destroy;
begin
	Tcustomstyleengine.Unregisterstylehook(TSGDrawGrid1,Tscrollingstylehook);
end;

class constructor TSJ.Create;
begin
	Tcustomstyleengine.Registerstylehook(TSJ,Tscrollingstylehook);
end;

class destructor TSJ.Destroy;
begin
	Tcustomstyleengine.Unregisterstylehook(TSJ,Tscrollingstylehook);
end;

class constructor TSG.Create;
begin
	Tcustomstyleengine.Registerstylehook(TSG,Tscrollingstylehook);
end;

class destructor TSG.Destroy;
begin
	Tcustomstyleengine.Unregisterstylehook(TSG,Tscrollingstylehook);
end;

end.
