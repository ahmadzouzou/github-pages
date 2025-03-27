unit amdmain;

interface

{$DEFINE USE_GLASS_FORM}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNSAFE_TYPE OFF}

uses
	Winapi.Windows,
	Winapi.Messages,
	Winapi.PropKey,
	Winapi.Propsys,
	System.Sysutils,
	System.Variants,
	Vcl.Graphics,
	Vcl.Themes,
	Vcl.Menus,
	Winapi.Commctrl,
	Vcl.Controls,
	Vcl.Forms,
	Vcl.Dialogs,
	Vcl.Stdctrls,
	System.Imagelist,
	Vcl.Imglist,
	Vcl.Comctrls,
	Winapi.Shlobj,
	Vcl.Xpman,
	Vcl.Extdlgs,
	System.Strutils,
	System.Classes,
	Winapi.Shellapi,
	System.Dateutils,
	Vcl.Extctrls,
	Winapi.Commdlg,
	System.Uitypes,
	System.Zip,
	Vcl.Winxctrls,
	System.Win.Taskbarcore,
	Vcl.Taskbar,
	Stgs,
	Vcl.Clipbrd,
	Vcl.Jumplist,
	Vcl.Imaging.pngimage,
	Rzprgres,
	System.Win.Taskbar,
	System.Generics.Collections,
	System.Math,
	System.Types,
	Vcl.Buttons,
	Winapi.Uxtheme,
	Vcl.Toolwin,
	Vcl.Styles.Utils.Systemmenu,
	Amd.export,
	Vcl.Imaging.Jpeg,
	Amd.Dragdrop,
	Amd.Dropsource,
	Amd.Droptarget,
	Amd.Dragdropfile,
	Amd.DropCombo,
	Winapi.Activex,
	System.Typinfo,
	Amd.Chrometabs,
	Winapi.Gdipobj,
	Winapi.Gdipapi,
	Amd.Chrometabsglassform,
	Amd.Chrometabstypes,
	Amd.Chrometabsutils,
	Amd.Chrometabscontrols,
	Amd.Chrometabsclasses,
	Vcl.Appevnts,
	FileRegistrationHelper,
	Ufilesummary,
	System.Win.Comobj,
	Amdfun1,
	Vcl.OleCtnrs,
	Vcl.OleServer,
	Winapi.COMAdmin,
	Winapi.Shlwapi,
	Vcl.CmAdmCtl,
	Winapi.msxml,
	Winapi.MSXMLIntf,
	xmldom,
	XMLIntf,
	msxmldom,
	XMLDoc,
	Vcl.AxCtrls,
	Soap.EncdDecd,
	System.NetEncoding,
	Amd.Files,
	// AMD.Stan.StorageBin,
	SHDocVw,
	Vcl.OleCtrls,
	Vcl.Mask,
	Vcl.NumberBox,
	System.IOUtils,
	System.Sqlite,
	Amd.Phys.SQLiteCli,
	Amd.Phys.SQLiteVDataSet,
	Amd.Phys.Sqlitewrapper,
	Amd.Phys.Sqlite,
	Amd.Phys.SQLiteDef,
	Amd.Comp.Client,
	Amd.Stan.Def,
	// AMD.Vclui.Wait,
	Amd.Phys,
	Amd.Stan.Async,
	Amd.Stan.Intf,
	Data.Db,
	Amd.Stan.Option,
	Amd.Stan.Param,
	Amd.Stan.Error,
	Amd.Dats,
	Amd.Phys.Intf,
	Amd.Dapt.Intf,
	Amd.Dapt,
	Amd.Comp.Dataset,
	Amd.Stan.Exprfuncs,
	Amd.Ui.Intf,
	Amd.Comp.Script,
	Amd.Stan.Pool,
	Amd.Phys.Sqlitewrapper.Stat,
	RzPanel,
	RzDlgBtn,
	RzStatus,
	RzEdit,
	RzLaunch,
	RzCommon,
	UIRibbon,
	UIRibbonCommands,
	RichEdit,
	RichEditEx,
	UIRibbonActions,
	ActnList,
	StdActns,
	System.Actions,
	Vcl.ActnMan,
	Vcl.ActnColorMaps,
	Vcl.ButtonGroup,
	Vcl.ControlList,
	RibbonMarkup,
	UIRibbonApi,
	UIRibbonForm,
	UIRibbonUtils,
	WinApiEx,
	Amd.CategoryButtons;

const
	IID_IImageList='{46EB5926-582E-4017-9FDF-E8998DAA0950}';
	IID_IImageList2='{192B9D83-50FC-457B-90A0-2B82A8B5DAE1}';

type

	HIMAGELIST=THandle;

	IMAGELISTDRAWPARAMS=record
		cbSize:DWORD;
		himl:HIMAGELIST;
		i:integer;
		hdcDst:HDC;
		x:integer;
		y:integer;
		cx:integer;
		cy:integer;
		xBitmap:integer;
		yBitmap:integer;
		rgbBk:COLORREF;
		rgbFg:COLORREF;
		fStyle:UINT;
		dwRop:DWORD;
		fState:DWORD;
		Frame:DWORD;
		crEffect:COLORREF;
	end;

	pIMAGELISTDRAWPARAMS=^IMAGELISTDRAWPARAMS;

	IMAGEINFO=record
		hbmImage:HBITMAP;
		hbmMask:HBITMAP;
		Unused1:integer;
		Unused2:integer;
		rcImage:TRECT;
	end;

	pIMAGEINFO=^IMAGEINFO;

	IImageList=interface(IUnknown)
		[IID_IImageList]
		function add(hbmImage:HBITMAP;hbmMask:HBITMAP;var pi:integer):HResult;stdcall;
		function BeginDrag(iTrack,dxHotspot,dyHotspot:integer):HResult;stdcall;
		function Clone(const IID:TGUID;out Obj):HResult;stdcall;
		function Copy(iDst:integer;punkSrc:IUnknown;iSrc:integer;uFlags:UINT):HResult;stdcall;
		function DragEnter(hwndLock:HWND;x,y:integer):HResult;stdcall;
		function DragLeave(hwndLock:HWND):HResult;stdcall;
		function DragMove(x,y:integer):HResult;stdcall;
		function DragShowNolock(fShow:BOOL):HResult;stdcall;
		function Draw(pimldp:pIMAGELISTDRAWPARAMS):HResult;stdcall;
		function EndDrag:HResult;stdcall;
		function GetBkColor(var pclr:COLORREF):HResult;stdcall;
		function GetDragImage(var ppt:PPoint;var pptHotspot:PPoint;var IID:TGUID;out Obj):HResult;stdcall;
		function GetIcon(i:integer;flags:UINT;var picon:HICON):HResult;stdcall;
		function GetIconSize(var cx:integer;var cy:integer):HResult;stdcall;
		function GetImageCount(var pi:integer):HResult;stdcall;
		function GetImageInfo(i:integer;var pIMAGEINFO:pIMAGEINFO):HResult;stdcall;
		function GetImageRect(i:integer;var prc:pRect):HResult;stdcall;
		function GetItemFlags(i:integer;var dwFlags:DWORD):HResult;stdcall;
		function GetOverlayImage(iOverlay:integer;var piIndex:integer):HResult;stdcall;
		function Merge(i1:integer;punk2:IUnknown;i2,dx,dy:integer;var IID:TGUID;out Obj):HResult;stdcall;
		function Remove(i:integer):HResult;stdcall;
		function Replace(pi:integer;hbmImage:HBITMAP;hbmMask:HBITMAP):HResult;stdcall;
		function ReplaceIcon(i:integer;picon:HICON;var pi:integer):HResult;stdcall;
		function SetBkColor(clrBk:COLORREF;var pclr:COLORREF):HResult;stdcall;
		function SetDragCursorImage(punk:IUnknown;iDrag,dxHotspot,dyHotspot:integer):HResult;stdcall;
		function SetIconSize(cx:integer;cy:integer):HResult;stdcall;
		function SetImageCount(uNewCount:UINT):HResult;stdcall;
		function SetOverlayImage(iImage:integer;iOverlay:integer):HResult;stdcall;
	end;

	IImageList2=interface(IImageList)
		[IID_IImageList2]
		function DiscardImages(iFirstImage:integer;iLastImage:integer;dwFlags:DWORD):HResult;stdcall;
		function ForceImagePresent(iImage:integer;dwFlags:DWORD):HResult;stdcall;
		function GetCallback(const IID:TGUID;out Obj):HResult;stdcall;
		function GetOriginalSize(iImage:integer;dwFlags:DWORD;var pcx:integer;var pcY:integer):HResult;stdcall;
		function GetStatistics(var pils:pIMAGELISTDRAWPARAMS):HResult;stdcall;
		function Initialize(cx,cy:integer;dwFlags:DWORD;cInitial:integer;cGrow:integer):HResult;stdcall;
		function PreloadImages(pimldp:pIMAGELISTDRAWPARAMS):HResult;stdcall;
		function Replace2(pi:integer;hbmImage:HBITMAP;hbmMask:HBITMAP;punkSrc:IUnknown;dwFlags:DWORD):HResult;stdcall;
		function ReplaceFromImageList(i:integer;pil:IImageList;iSrc:integer;punk:IUnknown;dwFlags:DWORD):HResult;stdcall;
		function Resize(cxNewIconSize:integer;cyNewIconSize:integer):HResult;stdcall;
		function SetCallback(punk:IUnknown):HResult;stdcall;
		function SetOriginalSize(iImage,cx,cy:integer):HResult;stdcall;
	end;

	TFormType=TChromeTabsGlassForm;

	TAmdF=class(Tform)

		Amd:Timagelist;
		Button8:Tbutton;
		Button7:Tbutton;
		Button19:Tbutton;
		Button12:Tbutton;
		Button14:Tbutton;
		Label1:Tlabel;
		Timer1:Ttimer;
		Button1:Tbutton;
		Button3:Tbutton;
		Button4:Tbutton;
		Button5:Tbutton;
		Button6:Tbutton;
		Button2:Tbutton;
		Button9:Tbutton;
		Button10:Tbutton;
		Jumplist1:Tjumplist;
		Button11:Tbutton;
		Button13:Tbutton;
		Button15:Tbutton;
		StatusBar:TStatusBar;
		Button18:Tbutton;
		Button16:Tbutton;
		Button17:Tbutton;
		Button20:Tbutton;
		Button21:Tbutton;
		Button22:Tbutton;
		Button23:Tbutton;
		Button24:Tbutton;
		Button25:Tbutton;
		Button26:Tbutton;
		Button27:Tbutton;
		Button28:Tbutton;
		Button29:Tbutton;
		Button30:Tbutton;
		Applicationevents1:Tapplicationevents;

		Imagelist1:Timagelist;
		Imagelist2:Timagelist;
		Imagelist3:Timagelist;
		Imagelist4:Timagelist;
		Image1:Timage;
		Button31:Tbutton;
		Button32:Tbutton;
		Button33:Tbutton;
		Xpmanifest1:Txpmanifest;
		Button34:Tbutton;
		Button35:Tbutton;
		Button36:Tbutton;
		Imagelist5:Timagelist;
		Button37:Tbutton;
		Button38:Tbutton;
		Button39:Tbutton;
		Button40:Tbutton;
		Button41:Tbutton;
		Button42:Tbutton;
		Button43:Tbutton;
		Button46:Tbutton;
		ProgressBar1:TProgressBar;
		FileSaveDialog1:TFileSaveDialog;
		FontDialog1:TFontDialog;
		FileOpenDialog1:TFileOpenDialog;
		PopupMenu1:TPopupMenu;
		open1:TMenuItem;
		N1:TMenuItem;
		edit1:TMenuItem;
		view1:TMenuItem;
		amn:Timagelist;
		ListView1:TListView;
		Button47:Tbutton;
		Button48:Tbutton;
		Edit2:TMaskEdit;
		NumberBox1:TNumberBox;
		AZZ:Timagelist;
		Button49:Tbutton;
		ProgressBar3:TProgressBar;

		Ribbon:TUIRibbon;
		Actions:TActionList;
		CmdCut:TEditCut;
		CmdCopy:TEditCopy;
		CmdPaste:TEditPaste;
		CmdIndent:TAction;
		CmdOutdent:TAction;
		CmdList:TRibbonCollectionAction;
		CmdLineSpacing10:TAction;
		CmdLineSpacing115:TAction;
		CmdLineSpacing15:TAction;
		CmdLineSpacing20:TAction;
		CmdLineSpacingAfter:TAction;
		CmdAlignLeft:TAction;
		CmdAlignCenter:TAction;
		CmdAlignRight:TAction;
		CmdAlignJustify:TAction;
		CmdFind:TSearchFind;
		CmdSelectAll:TEditSelectAll;
		CmdUndo:TAction;
		CmdRedo:TAction;
		CmdPrint:TPrintDlg;
		CmdQuickPrint:TAction;
		CmdPrintPreview:TAction;
		CmdClosePrintPreview:TAction;
		CmdExit:TFileExit;
		CmdPasteSpecial:TAction;
		CmdFont:TRibbonFontAction;
		CmdOpen:TFileOpen;
		CmdSave:TAction;
		CmdSaveAs:TFileSaveAs;
		CmdNew:TAction;
		RichEdit:TRichEdit;
		ActivateContextTab:TAction;
		HIDEContextTab:TAction;
		COLOR1:TRibbonColorAction;
		COLORSTANDARD:TRibbonColorAction;
		cmdinvNew:TRibbonCollectionAction;
		cmdinvNext:TRibbonCollectionAction;
		cmdinvPrevious:TRibbonCollectionAction;
		CustomizeAccessToolbar:TAction;
		cmdinvsave:TRibbonCollectionAction;
		cmdinvsaveandprint:TRibbonCollectionAction;
		cmdinvEdit:TRibbonCollectionAction;
		cmdinvCopyFrom:TRibbonCollectionAction;
		cmdinvAddFrom:TRibbonCollectionAction;
		cmdinvPrint:TRibbonCollectionAction;
		cmdinvDelete:TRibbonCollectionAction;
		cmdinvSaveDoc:TRibbonCollectionAction;
		Timer2:Ttimer;
		CmdRecentItems:TRecentItemAction;

		procedure Formdestroy(Sender:TObject);
		procedure FormCreate(Sender:TObject);
		procedure Formclose(Sender:TObject;var Action:TCloseAction);
		procedure Formshow(Sender:TObject);
		procedure FormCanreSize(Sender:TObject;var NewWidth,NewHeight:integer;var Resize:Boolean);
		procedure Copydata(var Msg:TWMCopyData);message WM_COPYDATA;
		procedure chromeEnterOver(Sender,Target:TObject;x,y:integer);
		procedure chromeDragOver(Sender,Source:TObject;x,y:integer;State:TDragState;var Accept:Boolean);
		procedure Pgdkover(Sender:TObject;Source:TDragDockObject;x,y:integer;State:TDragState;var Accept:Boolean);

		procedure Startdock(Sender:TObject;var Dragobject:TDragDockObject);

		procedure CoKeyDown(Sender:TObject;var Key:Word;Shift:TShiftState);

		procedure User2(Sender:TObject);
		procedure User4(Sender:TObject);
		procedure User8(Sender:TObject;var Key:Char);
		procedure User12(var Msg:TMsg;var Handled:Boolean);

		procedure Tt1(Sender:TObject;TickCount:Cardinal;var Reset:Boolean);
		procedure Tt2(Sender:TObject);

		procedure AMDTOndrop(Sender:TObject;Shiftstate:TShiftState;APoint:TPoint;var Effect:integer);
		procedure AMDTOnEnter(Sender:TObject;Shiftstate:TShiftState;APoint:TPoint;var Effect:integer);
		procedure AMDTOnDragOver(Sender:TObject;Shiftstate:TShiftState;APoint:TPoint;var Effect:integer);
		procedure OnEndAsyncTransfer(Sender:TObject);
		procedure AMDCOnGetStream(Sender:TFileContentsStreamOnDemandClipboardFormat;Index:integer;out AStream:IStream);
		procedure Ongetdragimage(Sender:TObject;const Dragsourcehelper:Idragsourcehelper2;var Handled:Boolean);
		procedure AMDCOnSetData(Sender:TObject;const Formatetc:Tagformatetc;out Medium:Tagstgmedium;var Handled:Boolean);
		procedure AMDCOnGetData(Sender:TObject;const Formatetc:Tagformatetc;out Medium:Tagstgmedium;var Handled:Boolean);
		procedure AMDCOnFeedback(Sender:TObject;Effect:integer;var Usedefaultcursors:Boolean);
		procedure AMDCOnDrop(Sender:TObject;DragType:TDragType;var ContinueDrop:Boolean);
		procedure AMDCOnPaste(Sender:TObject;Action:TDragResult;DeleteOnPaste:Boolean);
		procedure AMDCAfterDrop(Sender:TObject;DragResult:TDragResult;Optimized:Boolean);
		procedure OnAcceptFormat(Sender:TObject;const DataFormat:TCustomDataFormat;var Accept:Boolean);

		procedure Button7click(Sender:TObject);
		procedure Button19click(Sender:TObject);
		procedure Button12click(Sender:TObject);
		procedure Button14click(Sender:TObject);
		procedure Timer1timer(Sender:TObject);
		procedure Button8click(Sender:TObject);
		procedure Button1click(Sender:TObject);
		procedure Styleclick(Sender:TObject);
		procedure Button3click(Sender:TObject);
		procedure Button5click(Sender:TObject);
		procedure Button4click(Sender:TObject);
		procedure Button6click(Sender:TObject);
		procedure Button9click(Sender:TObject);
		procedure Button10click(Sender:TObject);
		procedure Button11click(Sender:TObject);
		procedure Button15click(Sender:TObject);
		procedure Button13click(Sender:TObject);
		procedure Button18click(Sender:TObject);
		procedure Button16click(Sender:TObject);
		procedure Trayicon1click(Sender:TObject);
		procedure Button17click(Sender:TObject);
		procedure Button20click(Sender:TObject);
		procedure Button21click(Sender:TObject);
		procedure Button22click(Sender:TObject);
		procedure Button23click(Sender:TObject);
		procedure Button24click(Sender:TObject);
		procedure Button25click(Sender:TObject);
		procedure Button26click(Sender:TObject);
		procedure Button27click(Sender:TObject);
		procedure Button28click(Sender:TObject);
		procedure Button29click(Sender:TObject);
		procedure Button30click(Sender:TObject);

		procedure ChromeTabClick(Sender:TObject;Atab:Tchrometab);
		procedure ChromeBeforeDrawItem(Sender:TObject;TargetCanvas:TGPGraphics;ItemRect:TRECT;ItemType:TChromeTabItemType;
			TabIndex:integer;var Handled:Boolean);
		procedure ChromeGetControlPolygons(Sender,Chrometabscontrol:TObject;ItemRect:TRECT;ItemType:TChromeTabItemType;
			Orientation:Ttaborientation;var Polygons:Ichrometabpolygons);
		procedure ChromeTabDragStart(Sender:TObject;Atab:Tchrometab;var Allow:Boolean);
		procedure ChromeTabDragOver(Sender:TObject;x,y:integer;State:TDragState;Dragtabobject:Idragtabobject;
			var Accept:Boolean);
		procedure ChromeTabBeforClose(Sender:TObject;Atab:Tchrometab;var Close:Boolean);
		procedure ChromeTabAfterClose(Sender:TObject;Atab:Tchrometab;counts:integer);
		procedure ChromeTabDragDrop(Sender:TObject;x,y:integer;Dragtabobject:Idragtabobject;Cancelled:Boolean;
			var Tabdropoptions:Ttabdropoptions);
		procedure ChromeTabDragEnd(Sender:TObject;Mousex,Mousey:integer;Dragtabobject:Idragtabobject;Cancelled:Boolean);
		procedure ChromeMouseMove(Sender:TObject;Shift:TShiftState;x,y:integer);

		procedure ApplicationEvents1Minimize(Sender:TObject);
		procedure ApplicationEvents1Message(var Msg:Tagmsg;var Handled:Boolean);
		procedure ApplicationEvents1Shortcut(var Msg:Twmkey;var Handled:Boolean);
		procedure ApplicationEvents1Modalbegin(Sender:TObject);
		procedure ApplicationEvents1Modalend(Sender:TObject);
		procedure Chrometabs1createdragform(Sender:TObject;Atab:Tchrometab;var Dragform:Tform);
		procedure OnNeedDragImageControl(Sender:TObject;Atab:Tchrometab;var DragControl:TWinControl);
		procedure Trayicon1balloonclick(Sender:TObject);
		procedure Tkbuttonclicked(Sender:TObject;Modalresult:TModalResult;var CanClose:Boolean);
		procedure Tkradioclicked(Sender:TObject);
		procedure Tkvclicked(Sender:TObject);
		procedure Tkhclicked(Sender:TObject);
		procedure Button33click(Sender:TObject);
		procedure Button34click(Sender:TObject);
		procedure Button35click(Sender:TObject);
		procedure Button36click(Sender:TObject);
		procedure Taskdialog1dialogcreated(Sender:TObject);
		procedure Taskdialog1dialogconstructed(Sender:TObject);
		procedure Button31Click(Sender:TObject);
		procedure Button39Click(Sender:TObject);
		procedure Button40Click(Sender:TObject);
		procedure Button41Click(Sender:TObject);
		procedure Button2Click(Sender:TObject);
		procedure Button32Click(Sender:TObject);
		procedure Button42Click(Sender:TObject);
		procedure Button43Click(Sender:TObject);
		procedure zp(Sender:TObject;FileName:string;Header:TZipHeader;Position:Int64);
		procedure zp1(Sender:TObject;FileName:string;Header:TZipHeader;Position:Int64);
		procedure Button38Click(Sender:TObject);
		procedure FileSaveDialog1Execute(Sender:TObject);
		procedure Button46Click(Sender:TObject);
		procedure FileSaveDialog1SelectionChange(Sender:TObject);
		procedure FileSaveDialog1Overwrite(Sender:TObject;var Response:TFileDialogOverwriteResponse);
		procedure Button37Click(Sender:TObject);
		procedure Button47Click(Sender:TObject);
		procedure Button48Click(Sender:TObject);
		procedure Edit2Change(Sender:TObject);

		procedure Button49Click(Sender:TObject);
		procedure RibbonCommandCreate(const Sender:TUIRibbon;const Command:TUICommand);
		// procedure CNPRO(ADB:TSQLiteDatabase;var ACancel:Boolean);

		procedure RichEditSelectionChange(Sender:TObject);
		procedure RichEditChange(Sender:TObject);
		procedure RichEditContextPopup(Sender:TObject;MousePos:TPoint;var Handled:Boolean);
		procedure ActionIndentOutdentExecute(Sender:TObject);
		procedure CmdListExecute(Sender:TObject);
		procedure ActionLineSpacingExecute(Sender:TObject);
		procedure CmdLineSpacingAfterExecute(Sender:TObject);
		procedure CmdAlignExecute(Sender:TObject);
		procedure CmdFindAccept(Sender:TObject);
		procedure CmdUndoExecute(Sender:TObject);
		procedure CmdRedoExecute(Sender:TObject);
		procedure CmdPrintAccept(Sender:TObject);
		procedure CmdQuickPrintExecute(Sender:TObject);
		procedure CmdPrintPreviewExecute(Sender:TObject);
		procedure CmdClosePrintPreviewExecute(Sender:TObject);
		procedure CmdFontChanged(const Args:TUICommandFontEventArgs);
		procedure RibbonLoaded(Sender:TObject);
		procedure CmdOpenAccept(Sender:TObject);
		procedure CmdSaveAsAccept(Sender:TObject);
		procedure CmdNewExecute(Sender:TObject);
		procedure CmdSaveExecute(Sender:TObject);
		procedure ActivateContextTabExecute(Sender:TObject);
		procedure HIDEContextTabExecute(Sender:TObject);
		procedure COLOR1Execute(Sender:TObject);
		procedure cmdinvNewExecute(Sender:TObject);
		procedure cmdinvPreviousExecute(Sender:TObject);
		procedure cmdinvNextExecute(Sender:TObject);
		procedure CustomizeAccessToolbarExecute(Sender:TObject);
		procedure CategoryButtons0ButtonClicked(Sender:TObject;const Button:TButtonItem);
		procedure cmdinvsaveExecute(Sender:TObject);
		procedure cmdinvsaveandprintExecute(Sender:TObject);
		procedure cmdinvEditExecute(Sender:TObject);
		procedure cmdinvDeleteExecute(Sender:TObject);
		procedure cmdinvAddFromExecute(Sender:TObject);
		procedure cmdinvCopyFromExecute(Sender:TObject);
		procedure cmdinvPrintExecute(Sender:TObject);
		procedure UpdateRibbonDOCbtn(Sender:TObject;Atab:Tchrometab);
		procedure DisableRibbonDOCbtn;
		procedure cmdinvSaveDocExecute(Sender:TObject);
		procedure CategoryButtons1MouseDown(Sender:TObject;Button:TMouseButton;Shift:TShiftState;x,y:integer);
		function catg(hfile:string):TButtonCategory;
		procedure Timer2Timer(Sender:TObject);
	private
		FCmdCombo:TUICommandCollection;
		{ Private declarations }
		FRichEditEx:TRichEditEx;
		FPrintPreviewMode:Boolean;
		/// The path of the currently opened file
		FCurrentfilePath:String;
		procedure UpdateRibbonControls;
		procedure PopulateListGallery;
		/// Loads a file into the editor and adds the file path to the recent items.
		/// <param name="pFilePath">The path of the file that should be loaded.</param>
		procedure Load(const pFilePath:string);
		/// Loads the editor contents to a file.
		/// <param name="pFilePath">The path of the file to that the editor content should be saved.</param>
		procedure Save(const pFilePath:string);
		procedure PopulateCOMBOGallery;
		procedure CmdComboSelect(const Args:TUICommandCollectionEventArgs);

		function ZipFile(FileName,ArchiveName:string):Boolean;
		function UnZipFile(ArchiveName,Path:string):Boolean;
		procedure ImagesWindowRgn;

	public
		CategoryButtons0:TCategoryButtons;
		procedure prog(Sender:TObject;Count,MaxCount:integer;COMMENT:string);
		procedure CONC(ADB:TSQLiteDatabase;var ACancel:Boolean);
		function ReadOutFile(FileName:string;TEMPINDEX:integer=0):Boolean;
		procedure OnBeforChangeStyle1(Sender:TObject;StyleName:string);
		procedure OnAfterChangeStyle1(Sender:TObject;StyleName:string);
		constructor Create(Owner:TComponent);override;
		destructor Destroy;override;
		procedure RecentItemOnSelect(const Command:TUICommandRecentItems;const Verb:TUICommandVerb;const ItemIndex:integer;
			const Properties:TUICommandExecutionProperties);

		function MUISave(RecentItems:TUICommandRecentItems):string;
		function MUIOpen(RecentItems:TUICommandRecentItems;xml:string):HResult;
	end;

	TchangeFilterStruct=packed record
		cbSize:DWORD;
		Extstatus:DWORD;
	end;

	Pchangefilterstruct=^TchangeFilterStruct;

	UTF4String=type AnsiString(1995);

	{ const
		FLASHW_STOP=0;
		FLASHW_CAPTION=1;
		FLASHW_TRAY=2;
		FLASHW_ALL=FLASHW_CAPTION or FLASHW_TRAY;
		FLASHW_TIMER=4;
		FLASHW_TIMERNOFG=12; }
const
	Id_msg=619840;
	Id_msg1=619850;
	Ahdl='Sources\AHDL.dll';
	shlwapidll='shlwapi.dll';

function GetFileISTM(CON:TFDConnection;Index:integer;var filesize:UInt64;RFC,ST,INVNUM,exti:string;
	strem:Boolean=False):IStream;

function Llmhp(Ncode,Wparam,Lparam:integer):integer;stdcall;
procedure Wineventproc(Hwineventhook:THandle;Event:DWORD;HWND:HWND;IdObject,Idchild:Longint;
	Ideventthread,Dwmseventtime:DWORD);stdcall;
function ChangeWindowMessageFilterEx(Wnd:HWND;Message:UINT;Action:DWORD;Changefilterstruct:Pchangefilterstruct):BOOL;
	stdcall;external 'User32.dll';
{$EXTERNALSYM SHCreateStreamOnFileEx}
function SHCreateStreamOnFileEx(pszFile:PWideChar;grfMode,dwAttributes:DWORD;fCreate:BOOL;pstmTemplate:IStream;
	out ppstm:IStream):HResult;stdcall;external 'shlwapi.dll' name 'SHCreateStreamOnFileEx';

function SHCreateMemStream(pInit:PWideChar;cbInit:UINT):IStream;stdcall;external 'shlwapi.dll' name 'SHCreateMemStream';
function RegGetValueW(hkey:hkey;lpSubKey:LPCWSTR;lpValue:LPCWSTR;dwFlags:DWORD;pdwType:LPDWORD;pvData:PVOID;
	pcbData:LPDWORD):Longint;stdcall;external 'advapi32.dll';
function SHMessageBoxCheckW(HWND:HWND;pszText:PWideChar;pszCaption:PWideChar;uType:Cardinal;iDefault:integer;
	pszRegVal:PWideChar):integer;stdcall;external 'shlwapi.dll' name 'SHMessageBoxCheckW';

var
	Amdf:TAmdF;
	T2,T3,T4:integer;
	Msmesno,filc:UInt64;
	Sswpm:Cardinal;
	Fevent1:Cardinal;
	Fevent2:Cardinal;
	Mhook:Cardinal;
	List_resources:string;
	ACDD:IAutoCompleteDropDown;
	FDragDescriptionFormat:Cardinal;

implementation

{$R *.dfm}

uses
	Amdfun2,
	Vcl.TrayIco,
	BMP,
	EmptyVC,
	Amdfun3,
	STGAMAIN,
	System.Win.Registry,
	Amd.DragDropInternet,
	Amd.DragDropGraphics,
	Amd.DragDropText,
	Amd.Dragdropformats;

/// /////////// RIBBON //////////////////////////////////////////////////////////////

constructor TAmdF.Create(Owner:TComponent);
begin
	inherited;
	FRichEditEx:=TRichEditEx.Create(RichEdit);
end;

procedure TAmdF.CustomizeAccessToolbarExecute(Sender:TObject);
begin
	ShowMessage('CustomizeAccessToolbar');
end;

destructor TAmdF.Destroy;
begin
	FRichEditEx.Free;
	inherited;
end;

procedure TAmdF.PopulateCOMBOGallery;
const
	RESOURCE_NAMES: array [0..6] of String=('NONE','BULLETS','NUMBERED','LOWERCASE','UPPERCASE','ROMANLOWER',
		'ROMANUPPER');
var
	Item:TUIGalleryCollectionItem;
	i:integer;
	ResourceName:String;
begin
	FCmdCombo.Items.BeginUpdate;
	try
		for i:=0 to 9 do begin
			Item:=TUIGalleryCollectionItem.Create;
			Item.LabelText:='AMD'+i.ToString;
			ResourceName:=Format('LIST_%s_%.3d',[RESOURCE_NAMES[i],96]);
			Item.Image:=TUIImage.Create(HInstance,ResourceName);
			FCmdCombo.Items.add(Item);
		end;
	finally FCmdCombo.Items.EndUpdate;
	end;
	FCmdCombo.SelectedItem:=0;
end;

procedure TAmdF.CmdComboSelect(const Args:TUICommandCollectionEventArgs);
var
	Item:TUIGalleryCollectionItem;
begin
	if (Args.Verb=cvExecute)and(Args.ItemIndex>=0) then begin
		ShowMessage(TUIGalleryCollectionItem(FCmdCombo.Items[Args.ItemIndex]).LabelText);
	end;
end;

procedure TAmdF.CmdAlignExecute(Sender:TObject);
var
	ParaFormat:TParaFormat2;
begin
	ParaFormat:=FRichEditEx.ParaFormat;
	if (Sender=CmdAlignLeft) then ParaFormat.wAlignment:=PFA_LEFT
	else if (Sender=CmdAlignCenter) then ParaFormat.wAlignment:=PFA_CENTER
	else if (Sender=CmdAlignRight) then ParaFormat.wAlignment:=PFA_RIGHT
	else if (Sender=CmdAlignJustify) then ParaFormat.wAlignment:=PFA_JUSTIFY;
	ParaFormat.dwMask:=PFM_ALIGNMENT;
	FRichEditEx.ParaFormat:=ParaFormat;
	UpdateRibbonControls; { Update Checked state of alignment buttons }
end;

procedure TAmdF.RibbonCommandCreate(const Sender:TUIRibbon;const Command:TUICommand);
begin
	if Command=CmdList.UICommand then PopulateListGallery;
	Ribbon.RecentItems.OnSelect:=RecentItemOnSelect;
	DisableRibbonDOCbtn;
	case Command.CommandId of
		// These commands are not implemented in this demo
		CmdParagraph,CmdInsertPicture,CmdChangePicture,CmdResizePicture,CmdInsertObject,CmdZoomIn,CmdZoom100Percent,
			CmdWrapToWindow,CmdWrapToRuler,CmdNoWrap,CmdInches,CmdCentimeters,CmdPicas,CmdPoints,CmdHelp,CmdRichTextDocument,
			CmdOfficeOpenXMLDocument,CmdOpenDocumentText,CmdPlainTextDocument,CmdOtherFormats,CmdPageSetup,CmdEmail,CmdAbout,
			CmdNextPage,CmdPreviousPage,CmdViewOnePage,CmdViewTwoPages,CmdRuler,CmdStatusBar:Command.ActionLink.Action:=NIL;

		cmdcombo1:begin
				FCmdCombo:=Ribbon[cmdcombo1] as TUICommandCollection;
				FCmdCombo.OnSelect:=CmdComboSelect;
				PopulateCOMBOGallery;
			end;
		99:Command.Caption:=SFL1(182); // manage
		100:Command.Caption:=SFL1(181); // documentTools
		101:Command.Caption:=SFL1(183); // document
		103:Command.Caption:=SFL1(56); // new
		104:Command.Caption:=SFL1(58); // next
		105:Command.Caption:=SFL1(57); // previous
		111:Command.Caption:=SFL1(59); // save
		112:Command.Caption:=SFL1(60); // saveandprint
		113:Command.Caption:=SFL1(61); // edit
		114:Command.Caption:=SFL1(64); // copyfrom
		115:Command.Caption:=SFL1(63); // addfrom
		116:Command.Caption:=SFL1(65); // print
		117:Command.Caption:=SFL1(62); // delete
		118:Command.Caption:=SFL1(84); // SAVE DOC
	end;
end;

procedure TAmdF.CmdClosePrintPreviewExecute(Sender:TObject);
begin
	FPrintPreviewMode:=False;
	Ribbon.SetApplicationModes([0]);
	// RichEdit.Enabled:=True;
end;

procedure TAmdF.CmdFindAccept(Sender:TObject);
var
	SearchTypes:TSearchTypes;
	Pos:integer;
begin
	SearchTypes:=[];
	if (frWholeWord in CmdFind.Dialog.Options) then Include(SearchTypes,stWholeWord);
	if (frMatchCase in CmdFind.Dialog.Options) then Include(SearchTypes,stMatchCase);
	Pos:=RichEdit.FindText(CmdFind.Dialog.FindText,RichEdit.SelStart+1,MaxInt-RichEdit.SelStart-1,SearchTypes);
	if (Pos>=0) then begin
		RichEdit.SelStart:=Pos;
		RichEdit.SelLength:=Length(CmdFind.Dialog.FindText);
	end;
end;

procedure TAmdF.ActionIndentOutdentExecute(Sender:TObject);
var
	ParaFormat:TParaFormat2;
begin
	ParaFormat:=FRichEditEx.ParaFormat;
	if (Sender=CmdIndent) then ParaFormat.dxStartIndent:=ParaFormat.dxStartIndent+500
	else if (ParaFormat.dxStartIndent>=500) then ParaFormat.dxStartIndent:=ParaFormat.dxStartIndent-500;
	ParaFormat.dwMask:=PFM_STARTINDENT;
	FRichEditEx.ParaFormat:=ParaFormat;
end;

procedure TAmdF.ActionLineSpacingExecute(Sender:TObject);
var
	ParaFormat:TParaFormat2;
begin
	ParaFormat:=FRichEditEx.ParaFormat;
	if (Sender=CmdLineSpacing10) then ParaFormat.bLineSpacingRule:=0
	else if (Sender=CmdLineSpacing15) then ParaFormat.bLineSpacingRule:=1
	else if (Sender=CmdLineSpacing20) then ParaFormat.bLineSpacingRule:=2
	else begin
		ParaFormat.bLineSpacingRule:=5;
		ParaFormat.dyLineSpacing:=23;
	end;
	ParaFormat.dwMask:=PFM_LINESPACING;
	FRichEditEx.ParaFormat:=ParaFormat;
	UpdateRibbonControls; { Update the "checked" state of the Line Spacing buttons }
end;

procedure TAmdF.COLOR1Execute(Sender:TObject);
var
	Colors:TArray<TColor>;
	i:integer;
begin
	{ if (COLOR1.UICommand.SelectedItem<0) then begin  +COLOR1.UICommand.SelectedItem.ToString

		end; }
	// ShowMessage('TTR');
	// Color:=COLOR1.UICommand.Color;
	SetLength(Colors,4*4);
	for i:=0 to Length(Colors)-1 do Colors[i]:=clBlue;
	Color:=COLORSTANDARD.UICommand.Color;
	COLORSTANDARD.UICommand.StandardColors:=Colors;
	Repaint;
end;

procedure TAmdF.CmdListExecute(Sender:TObject);
var
	ParaFormat:TParaFormat2;
begin
	ParaFormat:=FRichEditEx.ParaFormat;
	if (CmdList.UICommand.SelectedItem<0) then begin // Has the "Button" part of split button been clicked?
		// toggle
		if ParaFormat.wNumbering>0 then ParaFormat.wNumbering:=0
		else ParaFormat.wNumbering:=PFN_BULLET
	end // if < 0
	else ParaFormat.wNumbering:=CmdList.UICommand.SelectedItem;
	ParaFormat.dwMask:=PFM_NUMBERING;
	FRichEditEx.ParaFormat:=ParaFormat;
end;

procedure TAmdF.ActivateContextTabExecute(Sender:TObject);
begin
	Ribbon.ActivateContextTab(CmdTabgroup2);
end;

procedure TAmdF.HIDEContextTabExecute(Sender:TObject);
begin
	Ribbon.HIDEContextTab(CmdTabgroup2);
end;

procedure TAmdF.CmdPrintAccept(Sender:TObject);
begin
	RichEdit.Print('TextPad');
end;

procedure TAmdF.CmdPrintPreviewExecute(Sender:TObject);
begin
	FPrintPreviewMode:=not FPrintPreviewMode;

	{ Switch application modes. Show or Hide "Print preview" tab. }
	if (FPrintPreviewMode) then Ribbon.SetApplicationModes([1])
	else Ribbon.SetApplicationModes([0]);

	// ShowMessage('PrintPreview');
	// RichEdit.Enabled:=(not FPrintPreviewMode);
end;

procedure TAmdF.CmdQuickPrintExecute(Sender:TObject);
begin
	RichEdit.Print('TextPad');
end;

procedure TAmdF.CmdRedoExecute(Sender:TObject);
begin
	FRichEditEx.Redo;
end;

procedure TAmdF.CmdLineSpacingAfterExecute(Sender:TObject);
var
	ParaFormat:TParaFormat2;
begin
	ParaFormat:=FRichEditEx.ParaFormat;
	if (CmdLineSpacingAfter.Checked) then ParaFormat.dySpaceAfter:=0
	else ParaFormat.dySpaceAfter:=200;
	ParaFormat.dwMask:=PFM_SPACEAFTER;
	FRichEditEx.ParaFormat:=ParaFormat;
end;

procedure TAmdF.CmdUndoExecute(Sender:TObject);
begin
	FRichEditEx.Undo;
end;

procedure TAmdF.CmdFontChanged(const Args:TUICommandFontEventArgs);
var
	CharFormat:TCharFormat2;
begin
	Args.Font.AssignTo(CharFormat);
	FRichEditEx.CharFormat:=CharFormat;
end;

procedure TAmdF.PopulateListGallery;
const
	RESOURCE_NAMES: array [0..6] of String=('NONE','BULLETS','NUMBERED','LOWERCASE','UPPERCASE','ROMANLOWER',
		'ROMANUPPER');
	LABELS: array [0..6] of String=('None','Bullet','Numbering','Alphabet - Lower case','Alphabet - Upper case',
		'Roman Numeral - Lower case','Roman Numeral - Upper case');
var
	i,Dpi:integer;
	ResourceName:String;
	Item,Item1:TUIGalleryCollectionItem;
begin
	Dpi:=Screen.PixelsPerInch;
	if (Dpi>120) then Dpi:=144
	else if (Dpi>96) then Dpi:=120
	else Dpi:=96;
	for i:=0 to 6 do begin
		ResourceName:=Format('LIST_%s_%.3d',[RESOURCE_NAMES[i],Dpi]);
		Item:=TUIGalleryCollectionItem.Create;
		Item.LabelText:=LABELS[i];
		Item.Image:=TUIImage.Create(HInstance,ResourceName);
		CmdList.UICommand.Items.add(Item);
	end;
end;

procedure TAmdF.RibbonLoaded;
begin
	inherited;
	Color:=ColorAdjustLuma(Ribbon.BackgroundColor,-25,False);
	CRT1.Lookandfeel.Tabscontainer.Startcolor:=Color;
	CRT1.Lookandfeel.Tabscontainer.Stopcolor:=Color;
	CmdCut.Control:=RichEdit;
	CmdCopy.Control:=RichEdit;
	CmdPaste.Control:=RichEdit;
	CmdSelectAll.Control:=RichEdit;
	// FCmdCombo:=Ribbon[cmdcombo1] as TUICommandCollection;
	// FCmdCombo.OnSelect:=CmdLayoutsSelect;
	// PopulateLayoutsGallery;
	UpdateRibbonControls;
end;

procedure TAmdF.RichEditChange(Sender:TObject);
begin
	UpdateRibbonControls;
end;

procedure TAmdF.RichEditContextPopup(Sender:TObject;MousePos:TPoint;var Handled:Boolean);
begin
	// Ribbon.ShowContextPopup(CmdContextPopupEditText);
	Ribbon.ShowContextPopup(CmdContextPopuptool);
end;

procedure TAmdF.RichEditSelectionChange(Sender:TObject);
begin
	UpdateRibbonControls;
end;

procedure TAmdF.UpdateRibbonControls;
var
	ParaFormat:TParaFormat2;
begin
	ParaFormat:=FRichEditEx.ParaFormat;

	CmdPaste.Enabled:=FRichEditEx.CanPaste;

	CmdPasteSpecial.Enabled:=FRichEditEx.CanPaste;

	CmdCopy.Enabled:=(RichEdit.SelLength>0);
	CmdCut.Enabled:=(RichEdit.SelLength>0);

	if Assigned(CmdFont.UICommand) then CmdFont.UICommand.Font.Assign(FRichEditEx.CharFormat);

	if Assigned(CmdList.UICommand) then CmdList.UICommand.SelectedItem:=ParaFormat.wNumbering;

	CmdLineSpacing10.Checked:=(ParaFormat.bLineSpacingRule=0);
	CmdLineSpacing15.Checked:=(ParaFormat.bLineSpacingRule=1);
	CmdLineSpacing20.Checked:=(ParaFormat.bLineSpacingRule=2);
	CmdLineSpacing115.Checked:=(ParaFormat.bLineSpacingRule>2);

	{ This is not accurate, but good enough for a demo }
	CmdLineSpacingAfter.Checked:=(ParaFormat.dySpaceAfter>0);

	CmdAlignLeft.Checked:=(ParaFormat.wAlignment=PFA_LEFT);
	CmdAlignCenter.Checked:=(ParaFormat.wAlignment=PFA_CENTER);
	CmdAlignRight.Checked:=(ParaFormat.wAlignment=PFA_RIGHT);
	CmdAlignJustify.Checked:=(ParaFormat.wAlignment=PFA_JUSTIFY);

	CmdUndo.Enabled:=FRichEditEx.CanUndo;
	CmdRedo.Enabled:=FRichEditEx.CanRedo;
end;

procedure TAmdF.CmdNewExecute(Sender:TObject);
begin
	// RichEdit.Clear();
	// FCurrentfilePath:='';
end;

procedure TAmdF.RecentItemOnSelect(const Command:TUICommandRecentItems;const Verb:TUICommandVerb;
	const ItemIndex:integer;const Properties:TUICommandExecutionProperties);
var
	RecentItem:TUIRecentItem;
	cf:TUIRibbon;
begin
	RecentItem:=TUIRecentItem(Command.Items[ItemIndex]);
	ReadOutFile(RecentItem.Path,0);
	RecentItem.Pinned:=True;
end;

procedure TAmdF.CmdOpenAccept(Sender:TObject);
var
	i:integer;
	nam,pat,dte:string;
	lItem:IUICollectionItem;
begin
	for i:=0 to CmdOpen.Dialog.Files.Count-1 do begin
		dte:=Formatdatetime('yyyy MM dd tt',now);
		pat:=CmdOpen.Dialog.Files[i];
		nam:=ExtractFileName(pat);
		lItem:=TUIRecentItem.Create(nam+'    '+dte,pat,nam,dte);
		Ribbon.RecentItems.Items.Insert(0,lItem);
	end;
end;

procedure TAmdF.cmdinvNewExecute(Sender:TObject);
begin
	TSGA(CRT1.ActiveTab.HControl).BTN[1].Click;
end;

procedure TAmdF.cmdinvPreviousExecute(Sender:TObject);
begin
	TSGA(CRT1.ActiveTab.HControl).BTN[2].Click;
end;

procedure TAmdF.cmdinvNextExecute(Sender:TObject);
begin
	TSGA(CRT1.ActiveTab.HControl).BTN[3].Click;
end;

procedure TAmdF.cmdinvsaveExecute(Sender:TObject);
begin
	TSGA(CRT1.ActiveTab.HControl).BTN[4].Click;
end;

procedure TAmdF.cmdinvsaveandprintExecute(Sender:TObject);
begin
	TSGA(CRT1.ActiveTab.HControl).BTN[5].Click;
end;

procedure TAmdF.cmdinvSaveDocExecute(Sender:TObject);
var
	stga:TSGA;
	TestFileSize:UInt64;
	O:integer;
	RFC:string;
	RES:IStream;
begin
	IF (CRT1.Tabs.Count=1)OR(CRT1.ActiveTabIndex=0) THEN EXIT;
	IF (CRT1.ActiveTab.HControl=NIL)OR NOT(CRT1.ActiveTab.HControl IS TSGA) THEN EXIT;
	stga:=TSGA(CRT1.ActiveTab.HControl);
	RFC:=stga.TRFC;
	O:=Dtn1(RFC);
	RES:=GetFileISTM(CN[O],0,TestFileSize,stga.TRFC,stga.TST,stga.INUM.Caption,DTEX1(stga.TRFC),True);
	IF (RES<>NIL) THEN RES._Release;
end;

procedure TAmdF.cmdinvEditExecute(Sender:TObject);
begin
	TSGA(CRT1.ActiveTab.HControl).BTN[6].Click;
end;

procedure TAmdF.cmdinvDeleteExecute(Sender:TObject);
begin
	TSGA(CRT1.ActiveTab.HControl).BTN[7].Click;
end;

procedure TAmdF.cmdinvAddFromExecute(Sender:TObject);
begin
	TSGA(CRT1.ActiveTab.HControl).BTN[8].Click;
end;

procedure TAmdF.cmdinvCopyFromExecute(Sender:TObject);
begin
	TSGA(CRT1.ActiveTab.HControl).BTN[9].Click;
end;

procedure TAmdF.cmdinvPrintExecute(Sender:TObject);
begin
	TSGA(CRT1.ActiveTab.HControl).BTN[10].Click;
end;

procedure TAmdF.CmdSaveAsAccept(Sender:TObject);
begin
	// Save(CmdSaveAs.Dialog.FileName);
	cmdinvSaveDoc.Execute;
end;

procedure TAmdF.CmdSaveExecute(Sender:TObject);
begin
	if FCurrentfilePath.IsEmpty then CmdSaveAs.Execute()
	else Save(FCurrentfilePath);
end;

procedure TAmdF.Load(const pFilePath:string);
begin
	RichEdit.Lines.LoadFromFile(pFilePath);
	Ribbon.RecentItems.add(pFilePath);
	FCurrentfilePath:=pFilePath;
end;

procedure TAmdF.Save(const pFilePath:string);
begin
	RichEdit.Lines.SaveToFile(pFilePath);
	FCurrentfilePath:=pFilePath;
end;

function StrToReg(xml,Value,Subkey:string;Key:hkey=HKEY_CURRENT_USER):string;
var
	Xbuffer_size,rslt:Longword;
	Xbuffer: array [Word] of Char;
	Key1:hkey;
	PTYPE:DWORD;
	SM:TStringStream;
	HRES:HResult; // KEY_ALL_ACCESS
begin
	Result:='';
	Xbuffer:='';
	PTYPE:=REG_BINARY;
	if not(RegOpenKeyEx(Key,Pchar(Subkey),0,1,Key1)=0) then
			RegCreateKeyEXW(Key,Pchar(Subkey),0,NIL,0,KEY_ALL_ACCESS,NIL,Key,nil)
	else Xbuffer_size:=MAXWORD+2;
	SM:=TStringStream.Create(xml,TENCODING.UTF8);
	rslt:=RegSetValueExW(Key1,Pchar(Value),0,REG_BINARY,SM.Memory,SM.Size);
	ShowMessage(SM.Size.ToString+#13+rslt.ToString);
	RegCloseKey(Key);
	SM.Free;
end;

function RegToStr(Subkey,Value:string;Key:hkey=HKEY_CURRENT_USER):string;
const
	RRF_RT_REG_BINARY=$00000008;
var
	Xbuffer_size,rslt:Longword;
	Key1:hkey;
	SM:TStringStream;
begin
	Result:='';
	Xbuffer_size:=MAXWORD+2;
	SM:=TStringStream.Create('',TENCODING.UTF8);
	SM.SetSize(Xbuffer_size);
	if not(RegOpenKeyEx(Key,Pchar(Subkey),0,1,Key1)=0) then EXIT;
	rslt:=RegGetValueW(Key,Pchar(Subkey),Pchar(Value),RRF_RT_REG_BINARY,NIL,SM.Memory,@Xbuffer_size);
	case rslt of
		ERROR_FILE_NOT_FOUND:Result:='';
		ERROR_MORE_DATA: while (rslt=ERROR_MORE_DATA) do begin
				Xbuffer_size:=Xbuffer_size+2;
				rslt:=RegGetValueW(Key,Pchar(Subkey),Pchar(Value),RRF_RT_REG_BINARY,NIL,SM.Memory,@Xbuffer_size);
			end;
		// 0:SetString(Result,Pchar(SM.DataString),SM.Size);
	end;
	SM.SetSize(Xbuffer_size);
	SetString(Result,Pchar(SM.DataString),SM.Size);
	ShowMessage(SM.Size.ToString+#13+Xbuffer_size.ToString);
	Amdf.RichEdit.text:=Result;
	SM.SaveToFile('C:\Users\MICLE\Desktop\MUI.xml');
	RegCloseKey(Key);
	SM.Free;
end;

function TAmdF.MUISave(RecentItems:TUICommandRecentItems):string;
var
	i:integer;
	SS,x:string;
begin
	Result:='';
	if RecentItems.Items.Count=0 then EXIT;
	x:='';
	SS:='';
	for i:=0 to RecentItems.Items.Count-1 do
		with (RecentItems.Items[i] as TUIRecentItem) do begin
			case Pinned of
				True:x:='1';
				False:x:='0';
			end;
			SS:=SS+',("'+LabelText+'","'+Path+'","'+Description+'","'+x+'","'+datex+'")';
		end;
	Delete(SS,1,1);
	CN[1].ExecSQL('DELETE FROM MUI;INSERT INTO MUI(Caption,Path,Tooltip,Pinned,Dates) VALUES '+SS);
 RichEdit.Text:=SS;
end;

function TAmdF.MUIOpen(RecentItems:TUICommandRecentItems;xml:string):HResult;
var
	i,CO:integer;
begin
	FQ[1].Open('SELECT Caption,Path,Tooltip,Pinned,Dates FROM MUI ORDER BY Pinned DESC,id ASC;');
	CO:=FQ[1].RowsAffected;
	if (CO>0) then begin
		if RecentItems.Items.Count>0 then RecentItems.Items.Clear;
		for i:=0 to CO-1 do begin
			RecentItems.add(FQ[1].Fields[0].Asstring,FQ[1].Fields[1].Asstring,FQ[1].Fields[2].Asstring,
				FQ[1].Fields[4].Asstring);
			(RecentItems.Items[i] AS TUIRecentItem).Pinned:=StrToBoolDef(FQ[1].Fields[3].Asstring,False);
			FQ[1].Next;
		END;
	END;
	Result:=S_OK;
end;
/// /////////// RIBBON //////////////////////////////////////////////////////////////

procedure TAmdF.OnBeforChangeStyle1(Sender:TObject;StyleName:string);
begin
	// if not Sametext(Tstylemanager.Activestyle.Name,StyleName) then
	Ribbon.Show;
	Ribbon.UseDarkMode:=Always;
end;

procedure TAmdF.OnAfterChangeStyle1(Sender:TObject;StyleName:string);
begin
	// Color:=Ribbon.BackgroundColor;
	CRT1.Lookandfeel.Tabscontainer.Startcolor:=Color;
	CRT1.Lookandfeel.Tabscontainer.Stopcolor:=Color;
	Ribbon.UpdateDarkModeSetting;
	if Sametext('Windows',StyleName) then Ribbon.UseDarkMode:=Never;
	Ribbon.Refresh;
end;

procedure TAmdF.ImagesWindowRgn;
var
	FullRgn,Rgn:THandle;
	ClientX,ClientY,i,k:integer;
	x,y,firstx,cl:integer;
	last:Boolean;
	temprgn:hrgn;
Begin
	k:=0;
	ClientX:=(Width-ClientWidth)div 2;
	ClientY:=Height-ClientHeight-ClientX;
	FullRgn:=CreateRectRgn(0,0,Width,Height);
	Rgn:=CreateRectRgn(ClientX,ClientY,ClientX+ClientWidth,ClientY+ClientHeight);
	CombineRgn(FullRgn,FullRgn,Rgn,RGN_DIFF);

	{ for i:=0 to ControlCount-1 do
		with Controls[i] do Begin
		Rgn:=CreateRectRgn(ClientX+Left,ClientY+Top,ClientX+Left+Width,ClientY+Top+Height);

		CombineRgn(FullRgn,FullRgn,Rgn,RGN_OR);

		// ***************************************************************************************

		if(Timage(Controls[i]).Picture)<>nil then
		with Timage(Controls[i])do Begin
		if Transparent then cl:=Picture.Bitmap.Canvas.Pixels[0,0];
		for Y:=0 to Picture.Bitmap.Height-1 do Begin
		firstx:=0;
		last:=false;
		for X:=0 to Picture.Bitmap.Width-1 do
		if(abs(Picture.Bitmap.Canvas.Pixels[X,Y]-cl)>0)and(X<>pred(Picture.Bitmap.Width))then
		Begin
		if not last then Begin
		last:=true;
		if Transparent then firstx:=X;
		end;
		end else if last then Begin
		last:=false;
		temprgn:=CreateRectRgn(firstx+left,Y+Top,left+X,Top+Y+1);

		temprgn:=createrectrgn(firstx,y,x,y+1);//
		CombineRgn(FullRgn,FullRgn,temprgn,RGN_or);
		deleteobject(temprgn);
		end;
		end;
		end;

		end; }
	SetWindowRgn(Handle,FullRgn,True);
end;

procedure TAmdF.FormCreate(Sender:TObject);
const
	Id_about=319850;
var
	Hsysmenu:Hmenu;
	Reslt:integer;
	CW:TchangeFilterStruct;
var
	ap: array [1..5] of TPoint;
	r:hrgn;
	i:integer;
	ALLL,CP,EEXX:string;
Begin
	// ImagesWindowRgn;
	{ ap[1]:=Point(Width div 2,0);
		ap[2]:=Point(Width div 3*2,Height);
		ap[3]:=Point(0,Height div 3);
		ap[4]:=Point(Width,Height div 3);
		ap[5]:=Point(Width div 3,Height);
		r:=CreatePolygonRgn(ap,5,ALTERNATE);
		try
		SetWindowRgn(Handle,r,true);
		finally
		deleteobject(r);
		end; }
	{ CW.Cbsize:=SizeOf(TchangeFilterStruct);
		CW.Extstatus:=1;
		ChangeWindowMessageFilterEx(Handle,WM_COMMAND,1,@CW);
		ChangeWindowMessageFilterEx(Handle,WM_COPYGLOBALDATA,MSGFLT_ADD,@CW);
		ChangeWindowMessageFilterEx(Handle,WM_DROPFILES,MSGFLT_ADD,@CW);
		ChangeWindowMessageFilterEx(Handle,Wm_copydata,MSGFLT_ADD,@CW); }
	// Ribbon1.Style:=TRibbonStyleActionBars(0);

	FPrintPreviewMode:=False;
	StartAtAll;
	Icon:=Application.Icon;
	if (Paramcount<>0) then Begin
		Label1.Caption:=OutFiles.Count.ToString;
		for i:=0 to OutFiles.Count-1 do Label1.Caption:=Label1.Caption+#13+i.ToString+'-'+OutFiles[i];
		Refresh;
	end;

	with Tvclstylessystemmenu.Create(Self,SFL1(149)) do begin
		OnBeforChangeStyle:=OnBeforChangeStyle1;
		OnAfterChangeStyle:=OnAfterChangeStyle1;
	end;

	Taskbtn:=True;
	Taskbar1:=Ttaskbar.Create(Self);
	with Taskbar1 do Begin
		Progressmaxvalue:=100;
		Overlayicon.Handle:=Sic1(Na(Sfr1(31)),50);
		ToolTip:=SFL1(Na(Sfr1(32)));
	end;
	//
	{ TrayIcon1:=TTryIcon.Create(Self);
		with TrayIcon1 do begin
		Balloonflags:=4;
		Balloonhint:=Dupestring('AMD',4);
		Balloontimeout:=500;
		Balloontitle:='AMZ';
		Icon.Assign(Application.Icon);
		Visible:=true;
		Onclick:=Trayicon1click;
		end; }
	//
	with Tlogbox.Create(Reslt) do Begin
		if (Reslt=1) then Application.Terminate
		else Begin
			if (Sfr1(22)='0') then Formstyle:=fsMDIForm
			else Formstyle:=fsNormal;
			Self.Visible:=True;
		end;
	end;

	CategoryButtons0:=TCategoryButtons.Create(Self);
	CategoryButtons0.Parent:=Button49.Parent;
	CategoryButtons0.AlignWithMargins:=True;
	CategoryButtons0.BorderStyle:=bsNone;
	CategoryButtons0.ButtonFlow:=cbfVertical;
	CategoryButtons0.ButtonOptions:=[boAllowCopyingButtons,boFullSize,boShowCaptions, // boGradientFill,boAllowReorder,
	boVerticalCategoryCaptions,boCaptionOnlyBorder];
	CategoryButtons0.SetBounds(20,362,313,156);
	CategoryButtons0.OnButtonClicked:=CategoryButtons0ButtonClicked;
	CategoryButtons0.OnMouseDown:=CategoryButtons1MouseDown;
	// CategoryButtons0.Enabled:=True;
	// CategoryButtons0.Visible:=FALSE;

	FDragDescriptionFormat:=RegisterClipboardFormat(Pchar(CFSTR_DROPDESCRIPTION));
	AMDT:=TDropComboTarget.Create(Self);
	AMDT.Name:='AMDT';
	AMDT.Allowasynctransfer:=True;
	AMDT.Multitarget:=True;
	AMDT.Autoregister:=True;
	AMDT.Autoscroll:=True;
	AMDT.ActiveDragOver:=True;
	AMDT.OnEnter:=AMDTOnEnter;
	AMDT.Ondrop:=AMDTOndrop;
	AMDT.OnDragOver:=AMDTOnDragOver;
	AMDT.OnEndAsyncTransfer:=OnEndAsyncTransfer;
	AMDT.OnAcceptFormat:=OnAcceptFormat;

	AMDC:=TDropComboSource.Create(Self);
	AMDC.Name:='AMDC';
	// AMDC.Allowasynctransfer:=true;
	AMDC.Showimage:=True;
	AMDC.Ongetdragimage:=Ongetdragimage;
	AMDC.Images:=AZZ;
	AMDC.ImageIndex:=0;
	// AMDC.Ondrop:=AMDCOnDrop;
	// AMDC.OnPaste:=AMDCOnPaste;
	AMDC.OnSetData:=AMDCOnSetData;
	AMDC.OnGetData:=AMDCOnGetData;
	// AMDC.Onfeedback:=AMDCOnFeedback;
	AMDC.FileStream.OnGetStream:=AMDCOnGetStream;
	AMDC.OnAfterDrop:=AMDCAfterDrop;
	AMDC.DragTypes:=[dtCopy,dtMove,dtLink];

	Controlstyle:=Controlstyle+[Csdisplaydragimage,Csdoubleclicks,Csopaque,Cspannable,Csgestures];
	Controlstate:=Controlstate+[Cspaintcopy];
	Hsysmenu:=Getsystemmenu(Handle,False);
	Appendmenu(Hsysmenu,Mf_separator,0,nil);
	Appendmenu(Hsysmenu,Mf_string,Id_about,Pchar('&About...'));
	{ FEvent1:=SetWinEventHook(EVENT_OBJECT_CREATE,EVENT_OBJECT_CREATE,0,@WinEventProc,0,0,
		WINEVENT_OUTOFCONTEXT);
		FEvent2:=SetWinEventHook(EVENT_OBJECT_DESTROY,EVENT_OBJECT_DESTROY,0,@WinEventProc,0,0,
		WINEVENT_OUTOFCONTEXT); }
	// CategoryButtons0.Categories[0];
	FILTR:='';
	FQ[2].Open('SELECT '+LAN+',ext FROM DOCM');
	IF (FQ[2].RowsAffected>0) THEN
		for i:=0 to FQ[2].RowsAffected-1 do begin
			CP:=FQ[2].Fields[0].Asstring;
			EEXX:=FQ[2].Fields[1].Asstring;
			CategoryButtons0.Categories.add;
			CategoryButtons0.Categories[i].Caption:=CP;
			CategoryButtons0.Categories[i].EXTS:='.'+EEXX;
			FILTR:=FILTR+'|'+CP+' (*.'+EEXX+')|*.'+EEXX;
			ALLL:=ALLL+';*.'+EEXX;
			FQ[2].Next;
		end;
	// Delete(FILTR,1,1);
	Delete(ALLL,1,1);
	FILTR:=SFL1(185)+' ('+ALLL+')|'+ALLL+FILTR+'|All Files (*.*)|*.*';
	TFileOpen(CmdOpen).Dialog.FILTER:=FILTR;
	AMDT.Register(CategoryButtons0);
	MUIOpen(Ribbon.RecentItems,'');
	// Ribbon.ActiveEventManager:=True;
	// Ribbon.EventLogger.OnLogEvent:=RibbonOnUIEvent;
end;

procedure TAmdF.Formdestroy(Sender:TObject);
Begin

	// Unhookwinevent(Fevent1);
	// Unhookwinevent(Fevent2);
end;

procedure TAmdF.Formshow(Sender:TObject);
VAR
	i:integer;
Begin
	if Taskbtn then Taskbar1.Applychanges
	else Taskbar1.Taskbar.Deletetab(Handle);
	Ribbon.Hide;
end;

procedure TAmdF.Formclose(Sender:TObject;var Action:TCloseAction);
Begin
	MUISave(Ribbon.RecentItems);
	DtmpT;
	Action:=caFree;
end;

function TAmdF.catg(hfile:string):TButtonCategory;
var
	i:integer;
	ex:string;
begin
	Result:=CategoryButtons0.Categories[0];
	ex:=ExtractFileExt(hfile);
	for i:=0 to CategoryButtons0.Categories.Count-1 do
		if (CategoryButtons0.Categories[i].EXTS=ex) then begin
			Result:=CategoryButtons0.Categories[i];
			EXIT;
		end;
end;

procedure TAmdF.Copydata(var Msg:TWMCopyData);

var
	Data:Pdat;
	L1,se:string;
	i:integer;
	ButtonCategories:TButtonCategories;
Begin
	if (Msg.Copydatastruct.Dwdata=Id_msg) then Begin
		Data:=Pdat(Msg.Copydatastruct.Lpdata);
		SetString(L1,Data.Pdata,Data.PLength);
		if (OutFiles.IndexOf(L1)=-1) then OutFiles.add(L1);
		Label1.Caption:=OutFiles.Count.ToString;
		for i:=0 to OutFiles.Count-1 do Label1.Caption:=Label1.Caption+#13+i.ToString+'-'+OutFiles[i];

		if Visible then Begin
			IF (OutFiles1.Count>0) THEN BEGIN
				for i:=0 to OutFiles.Count-1 do
					if (catg(OutFiles[i]).IndexOf(ExtractFileName(OutFiles[i]))=-1) then
						with catg(OutFiles[i]).Items.add do begin
							Caption:=ExtractFileName(OutFiles[i]);
							hint:=Caption;
							FilePath:=OutFiles[i];
						end;
			END ELSE if (catg(L1).IndexOf(ExtractFileName(L1))=-1) then
				with catg(L1).Items.add do begin
					Caption:=ExtractFileName(L1);
					hint:=Caption;
					FilePath:=L1;
				end;
			OutFiles1.Clear;
			if Isiconic(Application.Handle)or(Application.Mainform.Windowstate=Wsminimized)or not(Application.Active) then
					Application.Restore;
			Flsh(Handle,3,5);
			Application.Bringtofront;
			SetForegroundWindow(Handle);
			Application.Processmessages;
			Refresh;
		end
		ELSE OutFiles1.add(L1);
	end;
end;

procedure TAmdF.CategoryButtons0ButtonClicked(Sender:TObject;const Button:TButtonItem);
begin
	ReadOutFile(Button.FilePath,0);
end;

procedure TAmdF.CategoryButtons1MouseDown(Sender:TObject;Button:TMouseButton;Shift:TShiftState;x,y:integer);
begin
	//
end;

procedure TAmdF.FormCanreSize(Sender:TObject;var NewWidth,NewHeight:integer;var Resize:Boolean);
Begin
	Sbo1;
	Ribbon.Refresh;
end;

procedure TAmdF.ApplicationEvents1Modalbegin(Sender:TObject);
Begin
	Mhook:=Setwindowshookex(Wh_mouse_ll,@Llmhp,HInstance,0);
end;

procedure TAmdF.ApplicationEvents1Modalend(Sender:TObject);
Begin
	Unhookwindowshookex(Mhook);
end;

procedure TAmdF.ApplicationEvents1Shortcut(var Msg:Twmkey;var Handled:Boolean);
var
	Keybstate:Tkeyboardstate;
Begin
	Getkeyboardstate(Keybstate);
	if ((Keybstate[Vk_control] and 128)=128)and((Keybstate[Vk_menu] and 128)=128)and((Keybstate[Vk_shift] and 128)=128)
	// Ord('8')
	then ShowMessage('CTRL+ALT+SHIFT Pressed');

end;

function Llmhp(Ncode,Wparam,Lparam:integer):integer;stdcall;
var
	Info:^Mousellhookstruct absolute Lparam;
	Clsname:string;
	DF:THandle;
	r:TRECT;
	APoint:TPoint;
	Tw:TWinControl;
Begin
	try
		Result:=Callnexthookex(Mhook,Ncode,Wparam,Lparam);
		with Info^ do Begin
			case Wparam of
				Wm_lbuttondown,Wm_mbuttondown,Wm_rbuttondown:Begin
						DF:=Getactivewindow;
						if (DF<>0) then Begin
							Tw:=Findcontrol(DF);
							if (Tw is Tform) then Begin
								if ((Tw as Tform).Tag=0) then EXIT;
							end;
							Getcursorpos(APoint);
							Getwindowrect(DF,r);
							Tw.Screentoclient(APoint);
							if not Ptinrect(r,APoint) then Begin
								Flsh(DF,3,5);
							end;
						end;
					end;
			end;
		end;
	except
		on E:Exception do
	end;
end;

procedure Wineventproc(Hwineventhook:THandle;Event:DWORD;HWND:HWND;IdObject,Idchild:Longint;
	Ideventthread,Dwmseventtime:DWORD);stdcall;
var
	Classname,S:string;
	i:integer;
Begin
	SetLength(Classname,255);
	SetLength(Classname,Getclassname(HWND,Pchar(Classname),255));
	i:=Amdf.RichEdit.Lines.Count+1;
	S:=i.ToString+' : '+Classname;
	if Pchar(Classname)='SysDragImage' then Begin
		if (Event=Event_object_create) then Begin
			Amdf.RichEdit.Lines.add(S+'Drag Start');
		end else Begin
			Amdf.RichEdit.Lines.add(S+'Drag End');
		end;
	end else Begin
		Amdf.RichEdit.Lines.add(S);
	end;
end;

procedure TAmdF.chromeDragOver(Sender,Source:TObject;x,y:integer;State:TDragState;var Accept:Boolean);
var
	pt:TPoint;
	i:integer;
	RFC,Rfc1,S,S1:string;
	Ta,Ca:Tcontrol;
	Crs:Tchrometabs;
	Ct1:Tchrometab;
	Hittestresult:Thittestresult;
Begin
	Crs:=Tchrometabs(Sender);
	i:=-1;
	Ct1:=nil;
	S:=SFL1(130);
	Ca:=(Source as Tmydragcontrolobject).Control;
	case State of
		Dsdragenter:Begin
				if not Ht.Visible then Begin
					Ht.Show;
				end;
			end;
		Dsdragmove:Begin
				Getcursorpos(pt);
				Movewindow(Ht.Handle,pt.x-Ht.Width,pt.y+20,Ht.Width,Ht.Height,True);
				if (Crs.Gettabundermouse<>nil) then Begin
					Ct1:=Crs.Gettabundermouse;
					Caption:=Ct1.Index.ToString;
				end;
				if (Ca is Tsg) then Begin
					Accept:=False;
					Hittestresult:=Crs.Hittest(Point(x,y));
					i:=Hittestresult.TabIndex;
					if (i<>-1) then Begin
						Ct1:=Crs.Tabs[i];;
						i:=Ct1.Index;
						Ta:=Ct1.HControl;
						S1:=Ct1.Caption;
						if (S<>S1) then Begin
							Accept:=True;
							if (Ta is TSGA)and(Ca.Owner is TSGA) then Begin
								RFC:=TSGA(Ca.Owner).TRFC;
								Rfc1:=TSGA(Ta).TRFC;
								if (Charinset(RFC[1],['1'..'6'])and Charinset(Rfc1[1],['1'..'6']))or(RFC=Rfc1) then Begin
									Crs.ActiveTabIndex:=i;
								end;
							end;
						end;
					end;
					if Accept then Begin
						if (Ta is TSGA)and(Ca.Owner is TSGA) then Begin
							if (Ta=Ca.Owner) then Begin
								if (Ht.Caption<>Ht.Hint1) then Begin
									Ht.Caption:=Ht.Hint1;
								end;
							end else Begin
								if (Ht.Caption<>Ht.Hint6) then Begin
									Ht.Caption:=Ht.Hint6;
								end;
							end;
						end;
					end else Begin
						if (Ht.Caption<>Ht.Hint5) then Begin
							Ht.Caption:=Ht.Hint5;
						end;
					end;
				end;
			end;
		Dsdragleave:Begin
				if Ht.Visible then Begin
					Ht.Hide;
				end;
			end;
	end;
	// ImageList_SetDragCursorImage(DI.Handle,Ord(Accept),0,0);
end;

procedure TAmdF.chromeEnterOver(Sender,Target:TObject;x,y:integer);
Begin
	Ht.Releasehandle;
	Ht.Free;
end;

procedure TAmdF.OnNeedDragImageControl(Sender:TObject;Atab:Tchrometab;var DragControl:TWinControl);
Begin
	if Assigned(Atab) then DragControl:=Atab.HControl;
end;

procedure TAmdF.Chrometabs1createdragform(Sender:TObject;Atab:Tchrometab;var Dragform:Tform);
var
	Newform:TChromeTabsGlassForm;
	Cr1:Tchrometab;
	Cht1:Tchrometabs;
Begin
	Newform:=TChromeTabsGlassForm.Createnew(Application);
	with Newform do Begin
		Caption:='';
		Font:=Self.Font;
		Bidimode:=Self.Bidimode;
		BorderStyle:=Bssizeable;
		Position:=Podesigned;
		Width:=Self.Width;
		Height:=Self.Height;
		Glassframe.Enabled:=True;
		Glassframe.Top:=35;
	end;
	Cht1:=Tchrometabs.Create(Newform);
	with Cht1 do Begin
		Parent:=Newform;
		Align:=Altop;
		Height:=35;
	end;
	Newform.Chrometabs:=Cht1;
	Landotchrome(Cht1);
	if (Atab.HControl<>nil) then Begin
		Cr1:=Addtab(Cht1,Atab.Caption,Atab.HControl,Atab.ImageIndex);
		Cht1.ActiveTab:=Cr1;
		Atab.HControl.Parent:=Newform;
		// AMDF.CRT1TClick(CHT1,CR1);
	end;
	Dragform:=Newform;
end;

procedure TAmdF.ChromeMouseMove(Sender:TObject;Shift:TShiftState;x,y:integer);
var
	Atab:Tchrometab;
	Ach:Tchrometabs;
	Sga:TSGA;
	S:string;
Begin
	Ach:=Tchrometabs(Sender);
	if (Ach.Gettabundermouse<>nil) then Begin
		S:='';
		Atab:=Ach.Gettabundermouse;
		if (Atab.HControl is TSGA) then Begin
			Sga:=Atab.HControl as TSGA;
			S:=SFL1(37)+' : '+Sga.INUM.Caption+#13;
			if (Sga.Ccna.ItemIndex>-1) then S:=S+SFL1(38)+' : '+Sga.Ccna.Items[Sga.Ccna.ItemIndex]+#13
			else S:=S+SFL1(38)+' : '+#13;
			if (Sga.Stna.ItemIndex>-1) then S:=S+SFL1(40)+' : '+Sga.Stna.Items[Sga.Stna.ItemIndex]+#13
			else S:=S+SFL1(40)+' : '+#13;
		end;
		TWinControl(Ach).So(Application.Icon.Handle,Atab.Caption,S,Ach.Tabcontrols[Atab.Index].Controlrect);
	end;
end;

procedure TAmdF.ChromeGetControlPolygons(Sender,Chrometabscontrol:TObject;ItemRect:TRECT;ItemType:TChromeTabItemType;
	Orientation:Ttaborientation;var Polygons:Ichrometabpolygons);
var
	Chrometabcontrol:Tbasechrometabscontrol;
	Tabtop:integer;
Begin
	// A very basic demo of how to alter the shape of the tabs
	if (ItemType=Ittab)and(Chrometabscontrol is Tbasechrometabscontrol) then Begin
		Chrometabcontrol:=Chrometabscontrol as Tbasechrometabscontrol;

		Polygons:=Tchrometabpolygons.Create;

		Tabtop:=0;

		if (Chrometabcontrol is Tchrometabcontrol)and(not Tchrometabcontrol(Chrometabcontrol).Chrometab.Getactive) then
				INC(Tabtop,3);
		case Tchrometabs(Sender).Tag of

			0:Polygons.Addpolygon(Chrometabcontrol.Newpolygon(Chrometabcontrol.Bidicontrolrect,[Point(0,Rectheight(ItemRect)),
					Point(0,Tabtop),Point(Rectwidth(ItemRect),Tabtop),Point(Rectwidth(ItemRect),Rectheight(ItemRect))],
					Orientation),nil,nil);

			1:Polygons.Addpolygon(Chrometabcontrol.Newpolygon(Chrometabcontrol.Bidicontrolrect,[Point(0,Rectheight(ItemRect)),
					Point(4,Rectheight(ItemRect)-3),Point(12,3),Point(13,2),Point(14,1),Point(16,0),Point(Rectwidth(ItemRect)-16,
					0),Point(Rectwidth(ItemRect)-14,1),Point(Rectwidth(ItemRect)-13,2),Point(Rectwidth(ItemRect)-12,3),
					Point(Rectwidth(ItemRect)-4,Rectheight(ItemRect)-3),Point(Rectwidth(ItemRect),Rectheight(ItemRect))],
					Orientation),nil,nil);

			2:Polygons.Addpolygon(Chrometabcontrol.Newpolygon(Chrometabcontrol.Bidicontrolrect,[Point(0,Rectheight(ItemRect)),
					Point(0,Rectheight(ItemRect)-1),Point(1,Rectheight(ItemRect)-1),Point(2,Rectheight(ItemRect)-2),
					Point(3,Rectheight(ItemRect)-2),Point(4,Rectheight(ItemRect)-3),Point(6,Rectheight(ItemRect)-4),
					Point(6,Rectheight(ItemRect)-5),Point(7,Rectheight(ItemRect)-6),Point(8,Rectheight(ItemRect)-7),Point(9,6),
					Point(10,5),Point(11,4),Point(12,3),Point(14,2),Point(15,1),Point(18,0),Point(Rectwidth(ItemRect)-18,0),
					Point(Rectwidth(ItemRect)-15,1),Point(Rectwidth(ItemRect)-14,2),Point(Rectwidth(ItemRect)-12,3),
					Point(Rectwidth(ItemRect)-11,4),Point(Rectwidth(ItemRect)-10,5),Point(Rectwidth(ItemRect)-9,6),
					Point(Rectwidth(ItemRect)-8,Rectheight(ItemRect)-7),Point(Rectwidth(ItemRect)-7,Rectheight(ItemRect)-6),
					Point(Rectwidth(ItemRect)-6,Rectheight(ItemRect)-5),Point(Rectwidth(ItemRect)-6,Rectheight(ItemRect)-4),
					Point(Rectwidth(ItemRect)-4,Rectheight(ItemRect)-3),Point(Rectwidth(ItemRect)-3,Rectheight(ItemRect)-2),
					Point(Rectwidth(ItemRect)-2,Rectheight(ItemRect)-2),Point(Rectwidth(ItemRect)-1,Rectheight(ItemRect)-1),
					Point(Rectwidth(ItemRect),Rectheight(ItemRect)-1),Point(Rectwidth(ItemRect),Rectheight(ItemRect))],
					Orientation),nil,nil);
		end;
	end;
end;

procedure TAmdF.DisableRibbonDOCbtn;
begin
	cmdinvNew.Enabled:=False;
	cmdinvNext.Enabled:=False;
	cmdinvPrevious.Enabled:=False;
	cmdinvsave.Enabled:=False;
	cmdinvsaveandprint.Enabled:=False;
	cmdinvEdit.Enabled:=False;
	cmdinvDelete.Enabled:=False;
	cmdinvAddFrom.Enabled:=False;
	cmdinvCopyFrom.Enabled:=False;
	cmdinvPrint.Enabled:=False;
	cmdinvSaveDoc.Enabled:=False;
end;

procedure TAmdF.UpdateRibbonDOCbtn(Sender:TObject;Atab:Tchrometab);
Begin
	IF Atab<>NIL then
		IF Atab.HControl IS TSGA then begin
			cmdinvNew.Enabled:=TSGA(Atab.HControl).BTN[1].Enabled;
			cmdinvNext.Enabled:=TSGA(Atab.HControl).BTN[2].Enabled;
			cmdinvPrevious.Enabled:=TSGA(Atab.HControl).BTN[3].Enabled;
			cmdinvsave.Enabled:=TSGA(Atab.HControl).BTN[4].Enabled;
			cmdinvsaveandprint.Enabled:=TSGA(Atab.HControl).BTN[5].Enabled;
			cmdinvEdit.Enabled:=TSGA(Atab.HControl).BTN[6].Enabled;
			cmdinvDelete.Enabled:=TSGA(Atab.HControl).BTN[7].Enabled;
			cmdinvAddFrom.Enabled:=TSGA(Atab.HControl).BTN[8].Enabled;
			cmdinvCopyFrom.Enabled:=TSGA(Atab.HControl).BTN[9].Enabled;
			cmdinvPrint.Enabled:=TSGA(Atab.HControl).BTN[10].Enabled;
			cmdinvSaveDoc.Enabled:=cmdinvEdit.Enabled;
		end
		else DisableRibbonDOCbtn
end;

procedure TAmdF.ChromeTabClick(Sender:TObject;Atab:Tchrometab);
var
	i:integer;
	Cr:Tchrometabs;
	Parentform:Tcustomform;
Begin
	Cr:=Tchrometabs(Sender);
	if Cr=CRT1 then
		for i:=0 to Cr.Tabs.Count-1 do Cr.Tabs[i].Spinnerstate:=Tchrometabspinnerstate(0);
	Atab.Spinnerstate:=Tchrometabspinnerstate(3);
	if Assigned(Atab.HControl) then begin
		Atab.HControl.Show;
		Atab.HControl.Bringtofront;
		// showmessage(TSGA(Atab.HControl).INUM.Caption);
	end;
	if Cr=CRT1 then UpdateRibbonDOCbtn(Self,Atab);
end;

procedure TAmdF.Pgdkover(Sender:TObject;Source:TDragDockObject;x,y:integer;State:TDragState;var Accept:Boolean);
var
	Arect:TRECT;
	Fr:TWinControl;
Begin
	if (Source.Control is Tform) then Begin
		if Source.Control.Parent=nil then Begin
			Accept:=True;
			Fr:=(Sender as TWinControl);
			if Accept then Begin
				Arect.Topleft:=Fr.Clienttoscreen(Point(0,0));
				Arect.Bottomright:=Fr.Clienttoscreen(Point(Fr.ClientWidth,Fr.ClientHeight));
				Source.Dockrect:=Arect;
			end;
		end else Begin
			Accept:=False;
		end;
	end;
end;

procedure TAmdF.Startdock(Sender:TObject;var Dragobject:TDragDockObject);
var
	B,B1,B2:TBITMAP;
	W,H,X1,Y1,X2,Y2:integer;
	Fr:TWinControl;
	Te,Te1:string;
	Ca:TColor;
Begin
	Fr:=TWinControl(Sender);
	if Di1=nil then Begin
		Di1:=Tdragimagelist.Create(nil);
		B:=TBITMAP.Create;
		B.Pixelformat:=Vcl.Graphics.Pf32bit;
		B1:=TBITMAP.Create;
		B1.Pixelformat:=Vcl.Graphics.Pf32bit;
		B2:=TBITMAP.Create;
		B2.Pixelformat:=Vcl.Graphics.Pf32bit;
		try
			Ht:=Thw.Create(Application);
			Ht.Parentwindow:=Application.Handle;
			Te:=Ht.Hint5;
			Te1:=Ht.Hint7;
			Ht.hint:=Te1;
			Ht.Activatehint(Rect(0,0,0,0),Te1);
			Ht.Hide;
			Ca:=Styleservices.Getstylecolor(Scpanel);
			X1:=0;
			Y1:=0;
			X2:=200;
			Y2:=200;
			B.Height:=Fr.Height;
			B.Width:=Fr.Width;
			B.Canvas.Lock;
			Fr.Paintto(B.Canvas.Handle,0,0);
			B.Canvas.Unlock;
			B1.Canvas.Font:=Vcl.Graphics.TFont(Getobjectprop(Fr,'font',Vcl.Graphics.TFont));
			B1.Height:=Y2-Y1+B1.Canvas.Textwidth(Te)+6;
			B1.Width:=Max(X2-X1+4,B1.Canvas.Textwidth(Te)+8);
			B1.Canvas.Brush.Color:=Ca;
			B1.Canvas.Fillrect(Rect(0,0,B1.Width,B1.Height));
			B1.Canvas.Textout(6,2,Te);
			B2.Canvas.Font:=Vcl.Graphics.TFont(Getobjectprop(Fr,'font',Vcl.Graphics.TFont));
			W:=B2.Canvas.Textwidth(Te1)+2;
			H:=B2.Canvas.Textheight(Te1)+2;
			B2.Height:=Y2-Y1+H+4;
			B2.Width:=Max(X2-X1+4,W);
			B2.Canvas.Brush.Color:=Ca;
			B2.Canvas.Fillrect(Rect(0,0,B2.Width,B2.Height));
			Stretchblt(B2.Canvas.Handle,2,H+2,X2-X1,Y2-Y1,B.Canvas.Handle,0,0,B.Width,B.Height,Srccopy);
			B2.Canvas.Textout(2,2,Te1);
			Di1.Width:=B2.Width;
			Di1.Height:=B2.Height;
			Di1.Masked:=True;
			Di1.Addmasked(B1,Ca);
			Di1.add(B2,nil);
			Di1.Setdragimage(0,-15,5);
		finally
			B.Free;
			B1.Free;
			B2.Free;
		end;
	end;
	if (Fr is Tform) then Begin
		Dragobject:=Tmydragdockobject.Create(Fr,Rgb(255,128,0));
	end else Begin
		Dragobject:=Tmydragdockobject.Create(Fr);
	end;
	Dragobject.Alwaysshowdragimages:=True;
end;

procedure TAmdF.ApplicationEvents1Message(var Msg:Tagmsg;var Handled:Boolean);
var
	Dh:Hdrop;
	Dfc,Fnl,i:integer;
	Fname,Ac1,RFC:string;
	Dp:TPoint;
	APoint:TPoint;
	Arect,r:TRECT;
	Crf:Tchrometabs;
	T:Cardinal;
	DF:THandle;
Begin
	inherited;
	case Msg.Message of
		WM_DROPFILES:Begin
				Dh:=Msg.Wparam;
				Ac1:='';
				try
					Dfc:=Dragqueryfile(Dh,$FFFFFFFF,nil,0);
					for i:=0 to pred(Dfc) do Begin
						Fnl:=Dragqueryfile(Dh,i,nil,0);
						SetLength(Fname,Fnl);
						Dragqueryfile(Dh,i,Pchar(Fname),Fnl+1);
						Ac1:=Ac1+ExtractFileName(Fname)+#13;
					end;
					Dragquerypoint(Dh,Dp);
				finally
					Dragfinish(Dh);
					Handled:=True;
				end;
				Ac1:=Getsyswindowclassname(Msg.HWND)+#13+Getsyswindowtext(Msg.HWND)+#13+Stringofchar('-',Length(Ac1))+#13+Ac1;
				ShowMessage(Ac1+#13+Stringofchar('-',Length(Ac1))+#13+Dp.x.ToString+','+Dp.y.ToString+#13+Msg.pt.x.ToString+','+
					Msg.pt.y.ToString+#13+Dfc.ToString+#13+integer(Msg.Time).ToString);
			end;
		Wm_syscommand:Begin
				if ((Msg.Wparam=Sc_screensave)or(Msg.Wparam=Sc_monitorpower)) then Handled:=True;
			end;

		Wm_mousemove:Begin

				{ DF:=Msg.HWND;
					if (FindControl(DF)=nil) then Exit;
					Caption:=FindControl(DF).ClassName;
					if DRG then begin
					if (FindControl(DF).ClassName='TChromeTabs') then begin
					CRF:=TChromeTabs(FindControl(DF));
					if (CRF.Tabs.Count>1)and(CRF.Tabs.ActiveTab.HControl.FindComponent('LB0')<>nil) then
					begin
					RFC:=TLabel(CRF.Tabs.ActiveTab.HControl.FindComponent('LB0')).Caption;
					if CharInSet(RFC[1],['1'..'7']) then begin
					GetCursorPos(APoint);
					Winapi.Windows.ScreenToClient(CRF.Handle,APoint);
					R:=CRF.TabContainerRect;
					if PtInRect(Rect(R.Left,R.Top,R.Width-1,CRF.Height-1),APoint) then begin
					if (CRF.GetTabUnderMouse<>nil) then begin
					I:=CRF.GetTabUnderMouse.Index;
					if (I<>0) then begin
					CRF.Tabs[I].Active:=true;
					end;
					end;
					end;
					end;
					end;
					end;
					end; }
				{ if (GetParent(Msg.HWND)=0) then Exit;
					if ((Msg.Wparam and MK_RBUTTON)>0) then begin
					FindControl(Msg.HWND).BringTofront;
					GetWindowRect(Msg.HWND,ARect);
					APoint.X:=LOWORD(Msg.lParam);
					APoint.Y:=HIWORD(Msg.lParam);
					Winapi.Windows.ClientToScreen(Msg.HWND,APoint);
					Winapi.Windows.ScreenToClient(GetParent(Msg.HWND),APoint);
					APoint.X:=APoint.X+Round((ARect.Left-ARect.Right)/2);
					APoint.Y:=APoint.Y+Round((ARect.Top-ARect.Bottom)/2);
					SetWindowPos(Msg.HWND,0,APoint.X,APoint.Y,0,0,SWP_NOZORDER or SWP_NOSIZE);
					end; }
			end;
	end;
end;

procedure TAmdF.ApplicationEvents1Minimize(Sender:TObject);
Begin
	if Assigned(TrayIcon1) then Begin
		TrayIcon1.Showballoonhint;

	end;
end;

procedure TAmdF.User2(Sender:TObject);
var
	Hw1:HWND;
Begin
	if (TComponent(Sender) is Tsavetextfiledialog) then Begin
		Hw1:=Getparent(Tsavetextfiledialog(Sender).Handle);
	end;
	if (TComponent(Sender) is Topentextfiledialog) then Begin
		Hw1:=Getparent(Topentextfiledialog(Sender).Handle);
		Sendmessage(Hw1,Cdm_setcontroltext,Idok,Nativeuint(Pchar('OKKK')));
		Sendmessage(Hw1,Cdm_setcontroltext,Idcancel,Nativeuint(Pchar('CANS')));
		Sendmessage(Hw1,Cdm_setcontroltext,1089,Nativeuint(Pchar('F TYPE')));
		Sendmessage(Hw1,Cdm_setcontroltext,1090,Nativeuint(Pchar('F NAME')));
		Sendmessage(Hw1,Cdm_setcontroltext,1091,Nativeuint(Pchar('IN DIR')));
	end;
	if (TComponent(Sender) is TFontDialog) then Begin
		Hw1:=Getparent(TFontDialog(Sender).Handle);
		Sendmessage(Hw1,Cdm_setcontroltext,Idok,Lparam(Pchar('OKKK')));
		Sendmessage(Hw1,Cdm_setcontroltext,Idcancel,Nativeuint(Pchar('CANS')));
		Sendmessage(Hw1,Cdm_setcontroltext,1025,Nativeuint(Pchar('SRCT'))); // LogFont
		Sendmessage(Hw1,Cdm_setcontroltext,1026,Nativeuint(Pchar('APP'))); // apply
		Sendmessage(Hw1,Cdm_setcontroltext,1038,Nativeuint(Pchar('HLP'))); // help
		Sendmessage(Hw1,Cdm_setcontroltext,1089,Nativeuint(Pchar('FNT'))); // font
		Sendmessage(Hw1,Cdm_setcontroltext,1090,Nativeuint(Pchar('FY'))); // font style
		Sendmessage(Hw1,Cdm_setcontroltext,1091,Nativeuint(Pchar('SZ'))); // size
		Sendmessage(Hw1,Cdm_setcontroltext,1072,Nativeuint(Pchar('EFF'))); // effect
		Sendmessage(Hw1,Cdm_setcontroltext,1073,Nativeuint(Pchar('SA'))); // sample
		Sendmessage(Hw1,Cdm_setcontroltext,1094,Nativeuint(Pchar('SRCT'))); // SCRIPT
		Sendmessage(Hw1,Cdm_setcontroltext,1139,Nativeuint(Pchar('COLOR'))); // COLOR

	end;
end;

procedure TAmdF.User4(Sender:TObject);
var
	Pl1:Tpanel;
	Rt1:TRichEdit;
	Br:Tbutton;
	Chb:Tcheckbox;
	Fr:Tform;
Begin
	Fr:=Tform(Sender);
	if (Fr.Name='MSG1') then Begin
		Pl1:=Tpanel(Fr.Findcomponent('PL1'));
		Rt1:=TRichEdit(Fr.Findcomponent('RT1'));
		Chb:=Tcheckbox(Fr.Findcomponent('CHB'));
		if (Fr.ClientWidth>(Pl1.Width-6)) then Begin
			Pl1.Width:=Fr.ClientWidth-6;
		end;
		if (Fr.ClientWidth>(Rt1.Width-6)) then Begin
			Rt1.Width:=Fr.ClientWidth-6;
			Chb.Width:=Rt1.Width-6;
		end;
	end;
	if (Fr.Findcomponent('BR')<>nil) then Begin
		Br:=Tbutton(Fr.Findcomponent('BR'));
		Setcursorpos(Br.Clientorigin.x+Br.Clientrect.Centerpoint.x,Br.Clientorigin.y+Br.Clientrect.Centerpoint.y);
	end;
end;

procedure TAmdF.User8(Sender:TObject;var Key:Char);
Begin
	if (Ord(Key)=Vk_escape) then Begin
		Key:=#0;
		if (Sender is Tform) then Begin
			Tform(Sender).Close;
		end else Begin
			Tform(Tcontrol(Sender).Owner).Close;
		end;
	end;
end;

procedure TAmdF.User12(var Msg:TMsg;var Handled:Boolean);
var
	Dh:Hdrop;
	Dfc,Fnl,i:integer;
	Fname,Ac1,RFC:string;
	Dp:TPoint;
	APoint:TPoint;
	Arect,r:TRECT;
	Crf:Tchrometabs;
	T:Cardinal;
Begin
	inherited;
	case Msg.Message of
		WM_DROPFILES:Begin
				Dh:=Msg.Wparam;
				Ac1:='';
				try
					Dfc:=Dragqueryfile(Dh,$FFFFFFFF,nil,0);
					for i:=0 to pred(Dfc) do Begin
						Fnl:=Dragqueryfile(Dh,i,nil,0);
						SetLength(Fname,Fnl);
						Dragqueryfile(Dh,i,Pchar(Fname),Fnl+1);
						Ac1:=Ac1+ExtractFileName(Fname)+#13;
					end;
					Dragquerypoint(Dh,Dp);
				finally
					Dragfinish(Dh);
					Handled:=True;
				end;
				Ac1:=Getsyswindowclassname(Msg.HWND)+#13+Getsyswindowtext(Msg.HWND)+#13+Stringofchar('-',Length(Ac1))+#13+Ac1;
				ShowMessage(Ac1+#13+Stringofchar('-',Length(Ac1))+#13+Dp.x.ToString+','+Dp.y.ToString+#13+Msg.pt.x.ToString+','+
					Msg.pt.y.ToString+#13+Dfc.ToString+#13+integer(Msg.Time).ToString);
			end;
		Wm_syscommand:Begin
				if ((Msg.Wparam=Sc_screensave)or(Msg.Wparam=Sc_monitorpower)) then Handled:=True;
			end;
		Wm_mousemove:Begin
				Caption:=Mouse.Cursorpos.x.ToString+' , '+Mouse.Cursorpos.y.ToString;
				{ if (FindControl(Msg.HWND)=nil) then Exit;
					Caption:=FindControl(Msg.HWND).ClassName;

					if DRG then begin
					if (FindControl(Msg.HWND).ClassName='TChromeTabs') then begin
					CRF:=TChromeTabs(FindControl(Msg.HWND));
					if (CRF.Tabs.Count>1)and(CRF.Tabs.ActiveTab.HControl.FindComponent('LB0')<>nil) then
					begin
					RFC:=TLabel(CRF.Tabs.ActiveTab.HControl.FindComponent('LB0')).Caption;
					if CharInSet(RFC[1],['1'..'7']) then begin
					GetCursorPos(APoint);
					Winapi.Windows.ScreenToClient(CRF.Handle,APoint);
					R:=CRF.TabContainerRect;
					if PtInRect(Rect(R.Left,R.Top,R.Width-1,CRF.Height-1),APoint) then begin
					if (CRF.GetTabUnderMouse<>nil) then begin
					I:=CRF.GetTabUnderMouse.Index;
					if (I<>0) then begin
					CRF.Tabs[I].Active:=true;
					end;
					end;
					end;
					end;
					end;
					end;
					end; }
				{ if (GetParent(Msg.HWND)=0) then Exit;
					if ((Msg.Wparam and MK_RBUTTON)>0) then begin
					FindControl(Msg.HWND).BringTofront;
					GetWindowRect(Msg.HWND,ARect);
					APoint.X:=LOWORD(Msg.lParam);
					APoint.Y:=HIWORD(Msg.lParam);
					Winapi.Windows.ClientToScreen(Msg.HWND,APoint);
					Winapi.Windows.ScreenToClient(GetParent(Msg.HWND),APoint);
					APoint.X:=APoint.X+Round((ARect.Left-ARect.Right)/2);
					APoint.Y:=APoint.Y+Round((ARect.Top-ARect.Bottom)/2);
					SetWindowPos(Msg.HWND,0,APoint.X,APoint.Y,0,0,SWP_NOZORDER or SWP_NOSIZE);
					end; }
			end;
	end;
end;

procedure TAmdF.CoKeyDown(Sender:TObject;var Key:Word;Shift:TShiftState);
Begin
	if (Ord(Key)=Vk_down) then Begin
		Tcomboboxex(Sender).Droppeddown:=True;
	end;
end;

/// /////////////////////// TIMERS /////////////////////////////////////////////
/// ////////////////////////////////////////////////////////////////////////////
procedure TAmdF.Tkbuttonclicked(Sender:TObject;Modalresult:TModalResult;var CanClose:Boolean);
Begin
	CanClose:=True;
	if (Modalresult<100) then CanClose:=True;
	if (Modalresult>99)and(Ttaskdialog(Sender).Button<>nil) then Begin
		// ShowMessage(TTaskDialog(Sender).Button.ID.ToString);
	end;
end;

procedure TAmdF.Tkradioclicked(Sender:TObject);
Begin
	if (Ttaskdialog(Sender).Radiobutton<>nil) then
		// ShowMessage(TTaskDialog(Sender).RadioButton.Caption);
end;

procedure TAmdF.Tkvclicked(Sender:TObject);
Begin
	if Tfverificationflagchecked in Ttaskdialog(Sender).flags then Begin
		// ShowMessage('1');
	end else Begin
		// ShowMessage('0');
	end;
end;

procedure TAmdF.Tkhclicked(Sender:TObject);
Begin
	// ShowMessage(TTaskDialog(Sender).URL);
end;

procedure TAmdF.Taskdialog1dialogconstructed(Sender:TObject);
Begin
	// ShowMessage('Construct');
end;

procedure TAmdF.Taskdialog1dialogcreated(Sender:TObject);
Begin
	// ShowMessage('Create');
end;

procedure TAmdF.Timer1timer(Sender:TObject);
var
	HWND:THandle;
	Mousepnt:TPoint;
	Wndname,Clsname:string;
	Wndid:integer;
	Wndc:Tagwndclassexw;
	Styles:DWORD;
	Style:Longint;
	WindowPos:PWindowPos;
Begin
	Getcursorpos(Mousepnt);
	HWND:=WindowFromPoint(Mousepnt);
	SetLength(Wndname,255);
	Getwindowtext(HWND,Pchar(Wndname),255);
	Wndname:=Pchar(Wndname);
	SetLength(Clsname,255);
	Getclassname(HWND,Pchar(Clsname),255);
	// GetClassInfoExW(HInstance,pchar(ClsName),wndc);
	Clsname:=Pchar(Clsname);
	Wndid:=Getwindowlong(HWND,Gwl_id);
	Caption:=Clsname;
	// Caption:=GetDlgCtrlID(HWND).ToString;
end;

procedure TAmdF.Timer2Timer(Sender:TObject);
var
	pt:TPoint;
	wc:TWinControl;
	ventana1: array [0..255] of Char;
	nombre1:string;
begin
	Getwindowtext(GetForegroundWindow,ventana1,sizeof(ventana1));
	Caption:=ventana1;
end;

procedure TAmdF.Trayicon1balloonclick(Sender:TObject);
Begin
	TtrayIcon(Sender).Showballoonhint;
end;

procedure TAmdF.Trayicon1click(Sender:TObject);
Begin
	Application.Mainform.Windowstate:=Wsnormal;
	Showwindow(Findwindow('TAMDF',nil),Sw_restore);
end;

procedure TAmdF.Tt1(Sender:TObject;TickCount:Cardinal;var Reset:Boolean);
var
	Wn:Ttaskdialog;
Begin
	Wn:=Ttaskdialog(Sender);
	Application.Processmessages;
	if (Wn.Tag>0) then Begin
		Wn.Tag:=Wn.Tag-1;
		Setwindowtext(Wn.Handle,' '+SFL1(24)+' '+integer(Wn.Tag).ToString);
		if (Wn.Tag=0) then Begin
			Sendmessage(Wn.Handle,Wm_syscommand,Sc_close,0);
		end;
	end;
	Reset:=True;
end;

procedure TAmdF.Tt2(Sender:TObject);
var
	Lb0:Tlabel;
Begin
	{ if not(TTimer(Sender) = nil) then begin
		Application.ProcessMessages;
		t2 := t2 + 1;
		LB[8].Caption := LB[8].Caption + ' .';
		if (t2 = 5) then begin
		t2 := 0;
		LB[8].Caption := S6[1];
		end;
		end; }
end;

procedure TAmdF.AMDCOnFeedback(Sender:TObject;Effect:integer;var Usedefaultcursors:Boolean);
Begin
	Usedefaultcursors:=True;
	ShowMessage('AMDCOnfeedback');
end;

procedure TAmdF.AMDCOnGetData(Sender:TObject;const Formatetc:Tagformatetc;out Medium:Tagstgmedium;var Handled:Boolean);
var
	Dr:dropdescription;
	Udescriptin,Umsg,S:string;
	Data:Pointer;
Begin
	// if (Formatetc.cfFormat=FDragDescriptionFormat)and(Formatetc.tymed=TYMED_HGLOBAL) then begin
	{ Zeromemory(@Medium,SizeOf(Tagstgmedium));
		Zeromemory(@Dr,SizeOf(Dr));
		Medium.tymed:=TYMED_HGLOBAL;
		Medium.Hglobal:=Globalalloc(Ghnd or GMEM_SHARE,SizeOf(dropdescription));
		Dr.&type:=Dropimage_copy;
		Umsg:='sttep'; // +'%1';
		Udescriptin:='awmd';
		if Length(Umsg)<=MAX_PATH then begin
		Move(Umsg[1],Dr.szMessage[0],Length(Umsg)*SizeOf(WideChar));
		Move(Udescriptin[1],Dr.szInsert[0],Length(Udescriptin)*SizeOf(WideChar));
		end else begin
		S:=Copy(Umsg,1,MAX_PATH-2)+'%1';
		Move(S[1],Dr.szMessage[0],Length(S)*SizeOf(WideChar));

		S:=Copy(Udescriptin,MAX_PATH-1,MAX_PATH);
		Move(S[1],Dr.szInsert[0],Length(S)*SizeOf(WideChar));
		end;
		// Strlcopy(Dr.Szmessage,PChar(Umsg),Max_path);
		// Strlcopy(Dr.Szinsert,PChar(Udescriptin),Max_path);
		Data:=Globallock(Medium.Hglobal);
		Move(Dr,Data^,SizeOf(dropdescription));
		Globalunlock(Medium.Hglobal); }
	// end;
	T2:=T2+1;
	Label1.Caption:='get'+'  :  '+T2.ToString;
	Handled:=False;
	// SetFocus;
end;

procedure TAmdF.AMDCOnSetData(Sender:TObject;const Formatetc:Tagformatetc;out Medium:Tagstgmedium;var Handled:Boolean);
Begin
	T2:=T2+1;
	Caption:='set';
	Handled:=False;
end;

procedure TAmdF.AMDCAfterDrop(Sender:TObject;DragResult:TDragResult;Optimized:Boolean);
var
	i:integer;
begin
	// if Optimized then
	for i:=0 to AMDC.FdFiles.Count-1 do DeleteFile('C:\Users\MICLE\Desktop\'+AMDC.FdFiles[i]+'.tmp');
end;

procedure TAmdF.AMDCOnDrop(Sender:TObject;DragType:TDragType;var ContinueDrop:Boolean);
begin
	ShowMessage('Drop');
	ContinueDrop:=True;
end;

procedure TAmdF.AMDCOnPaste(Sender:TObject;Action:TDragResult;DeleteOnPaste:Boolean);
begin
	ShowMessage('OnPaste');
end;

procedure TAmdF.Ongetdragimage(Sender:TObject;const Dragsourcehelper:Idragsourcehelper2;var Handled:Boolean);
var
	pt:TPoint;
	Amc:TDropComboSource;
	GG:Cardinal;
Begin
	Amc:=TDropComboSource(Sender);
	Getcursorpos(pt);
	Dragsourcehelper.Setflags(DSH_ALLOWDROPDESCRIPTIONTEXT);
	Handled:=Succeeded(Dragsourcehelper.Initializefromwindow(Amc.Sourcehandle.Handle,pt,Amc));
	SHDoDragDrop(Amc.Sourcehandle.Handle,Amc,nil,DROPIMAGE_LINK or DROPIMAGE_LABEL or DROPIMAGE_MOVE or
		DROPIMAGE_COPY,GG);
end;

procedure TAmdF.AMDCOnGetStream(Sender:TFileContentsStreamOnDemandClipboardFormat;Index:integer;out AStream:IStream);
VAR
	TestFileSize:UInt64;
	EXT:string;
	O,ct:integer;
	SG:Tsg;
begin
	SG:=Tsg(AMDC.Sourcehandle);
	EXT:=ExtractFileExt(AMDC.FileStream.FileNames[Index]);
	ct:=AMDC.FdFiles[Index].ToInteger;
	O:=Dtn1(SG.Rows[ct].RFC.ToString);
	AStream:=GetFileISTM(CN[O],Index,TestFileSize,SG.Rows[ct].RFC.ToString,SG.Rows[ct].ST.ToString,
		SG.Rows[ct].NUM.ToString,EXT);
	with PFileDescriptor(AMDC.FileStream.FileDescriptors[Index])^ do begin
		GetSystemTimeAsFileTime(ftLastWriteTime);
		// nFileSizeLow:=TestFileSize and $00000000FFFFFFFF;
		// nFileSizeHigh:=(TestFileSize and $FFFFFFFF00000000) shr 32;
		// dwFlags:=FD_WRITESTIME or FD_FILESIZE; // or FD_PROGRESSUI;
	end;
	// SHOWMESSAGE(Amdc.FdFiles.Text+#13+'---------------'+#13+Amdc.FileStream.FileNames.Text);
end;

procedure TAmdF.AMDTOnEnter(Sender:TObject;Shiftstate:TShiftState;APoint:TPoint;var Effect:integer);
Begin
	Effect:=Drophint(DROPIMAGE_COPY,Tdropfiletarget(Sender).DataObject,SFL1(1));
end;

procedure TAmdF.AMDTOnDragOver(Sender:TObject;Shiftstate:TShiftState;APoint:TPoint;var Effect:integer);
Begin
	if Ssctrl in Shiftstate then Begin
		if Ssshift in Shiftstate then Effect:=Drophint(Dropeffect_link,Tdropfiletarget(Sender).DataObject,SFL1(1))
		else Effect:=Drophint(Dropeffect_copy,Tdropfiletarget(Sender).DataObject,SFL1(1));
	end else Begin
		if Ssshift in Shiftstate then Effect:=Drophint(Dropeffect_move,Tdropfiletarget(Sender).DataObject,SFL1(1))
		else if Ssalt in Shiftstate then Effect:=Drophint(Dropeffect_link,Tdropfiletarget(Sender).DataObject,SFL1(1))
		else Effect:=Drophint(Dropeffect_copy,Tdropfiletarget(Sender).DataObject,SFL1(1));
	end;
end;

procedure TAmdF.Edit2Change(Sender:TObject);
var
	TR:Cardinal;
	DF:Pchar;
Begin
	{ ACDD.GetDropDownStatus(TR,DF);
		if (TR=ACDD_VISIBLE) then Begin
		Button48.Caption:=DF;
		CoTaskMemFree(DF);
		end;
		Caption:=Edit2.TEXT; }
end;

procedure TAmdF.AMDTOndrop(Sender:TObject;Shiftstate:TShiftState;APoint:TPoint;var Effect:integer);
var
	Amt:TDropComboTarget;
	i,x:integer;
	S,C:string;
	statstg,statstg1:TStatStg;
	Cntrol:TWinControl;
Begin
	Amt:=TDropComboTarget(Sender);
	Cntrol:=Amt.FindNearestTarget(APoint);
	// Cntrol:=FindVCLWindow(APoint);
	if (Cntrol=CategoryButtons0) then
		if (Amt.Files.Count>0) then
			for i:=0 to Amt.Files.Count-1 do
				with catg(Amt.Files[i]).Items.add do begin
					Caption:=ExtractFileName(Amt.Files[i]);
					hint:=Caption;
					FilePath:=Amt.Files[i];
				end;

	EXIT;
	Amt.FdFiles.Clear;
	Amt.FdFiles.text:=Amt.Files.text;
	if (Amt.Bitmap.Handle<>0)and not(Amt.Bitmap=nil) then Image1.Picture.Bitmap.Assign(Amt.Bitmap);
	if (Amt.MetaFile.Handle<>0)and not(Amt.MetaFile=nil) then Image1.Picture.MetaFile.Assign(Amt.MetaFile);
	C:=Amt.DataFormats.Count.ToString+#13;
	S:='';
	for i:=0 to Amt.DataFormats.Count-1 do begin
		C:=C+(i+1).ToString+' : '+Amt.DataFormats[i].Classname+#13+'---------------'+#13;
		for x:=0 to Amt.DataFormats.Formats[i].CompatibleFormats.Count-1 do
				C:=C+Amt.DataFormats.Formats[i].CompatibleFormats[x].ClipboardFormat.ToString+' = '+Amt.DataFormats.Formats[i]
				.CompatibleFormats[x].ClipboardFormatName+#13;
		C:=C+'****************************************'+#13;
	END;
	if (Amt.Files.Count>0) then S:=S+#13+'mfFile'+#13+Amt.Files.Count.ToString;
	if (Amt.URL<>'') then S:=S+#13+'mfURL : '+#13+Amt.URL;
	if (not Amt.Bitmap.Empty)and not(Amt.Bitmap=nil) then S:=S+#13+'mfBitmap';
	if (Amt.MetaFile.Handle<>0)and not(Amt.MetaFile=nil) then S:=S+#13+'mfMetaFile';
	if (Amt.FileStorage.Storages.Count<>0) then begin
		Amt.FileStorage.Storages[0].Stat(statstg,STATFLAG_NONAME);
		S:=S+#13+'mfStorage : '+#13+'count : '+Amt.FileStorage.Storages.Count.ToString+#13+'name : '+
			Amt.FileStorage.Storages.Names[0]+#13+'type : '+statstg.dwType.ToString+#13+'guid : '+statstg.clsid.ToString+#13+
			'mode : '+statstg.grfMode.ToString+#13+'statbites : '+statstg.grfStateBits.ToString+#13+'messages count : '+
			Amt.FileStorage.Messages.Count.ToString;
	end;
	if (Amt.FileStream.FileContentsClipboardFormat.GetStream(0)<>nil) then begin
		Amt.FileStream.FileContentsClipboardFormat.GetStream(0).Stat(statstg1,STATFLAG_NONAME);
		S:=S+#13+'mfStream : '+#13+'count : '+Amt.FileStream.FileNames.Count.ToString+#13+'name : '+Amt.FileStream.FileNames
			[0]+#13+'type : '+statstg1.dwType.ToString+#13+'size : '+statstg1.cbSize.ToString+#13+'mode : '+
			statstg1.grfMode.ToString+#13+'LocksSupported : '+statstg.grfLocksSupported.ToString;
	end;
	if (Amt.text<>'') then S:=S+#13+'mfText : '+#13+'"'+Amt.text+'"';
	ShowMessage(C);
	ShowMessage(S);
end;

procedure TAmdF.OnEndAsyncTransfer(Sender:TObject);
var
	i:integer;
	S:string;
	Amt:TDropComboTarget;
Begin
	Amt:=TDropComboTarget(Sender);
	EXIT;
	S:='';
	if Amt.FdFiles.Count>0 then
		for i:=0 to Amt.FdFiles.Count-1 do Begin
			if GetFileAttributes(Pchar(Amt.FdFiles.Strings[i]))=faDirectory then
					Amt.FdFiles.Strings[i]:='FOLDER - '+Amt.FdFiles.Strings[i];
			S:=S+i.ToString+' - '+Amt.FdFiles.Strings[i]+#13;
		end;
	// ShowMessage(S);
end;

procedure TAmdF.OnAcceptFormat(Sender:TObject;const DataFormat:TCustomDataFormat;var Accept:Boolean);

begin
	Accept:=True;
end;

procedure TAmdF.ChromeBeforeDrawItem(Sender:TObject;TargetCanvas:TGPGraphics;ItemRect:TRECT;ItemType:TChromeTabItemType;
	TabIndex:integer;var Handled:Boolean);
Begin
	// Handled := (not (ItemType in [itTabText, itTabMouseGlow, itTabOutline, itTabCloseButton])) and (TabIndex <> 2);
end;

procedure TAmdF.ChromeTabBeforClose(Sender:TObject;Atab:Tchrometab;var Close:Boolean);
var
	Wr:Tform;
	Ct1:Tchrometabs;
Begin
	try
		Close:=True;
		Ct1:=Tchrometabs(Sender);
		Wr:=Tform(Ct1.Owner);
		if (Atab.HControl<>nil) then FreeAndNil(Atab.HControl);
		// Ct1.Tabs.BeginUpdate;
		// Ct1.Tabs.EndUpdate;
	except
		on E:Exception do ShowMessage('TabBeforClose'+#13+E.ToString);
	end;
end;

procedure TAmdF.ChromeTabAfterClose(Sender:TObject;Atab:Tchrometab;counts:integer);
var
	Wr:Tform;
	Ct1:Tchrometabs;
Begin
	try
		Ct1:=Tchrometabs(Sender);
		Wr:=Tform(Ct1.Owner);
		if (Atab.HControl<>nil) then FreeAndNil(Atab.HControl);
		Ct1.Tabs.BeginUpdate;
		Ct1.Tabs.EndUpdate;
		if (Wr<>Self) then
			if (Ct1.Tabs.Count=1) then Wr.Close;
		if (CRT1.Tabs.Count=2) then Ribbon.HIDEContextTab(CmdTabgroup2);
		DisableRibbonDOCbtn;
	except
		on E:Exception do ShowMessage('TabAfterClose'+#13+E.ToString);
	end;
end;

procedure TAmdF.ChromeTabDragStart(Sender:TObject;Atab:Tchrometab;var Allow:Boolean);
Begin
	Allow:=True;
end;

procedure TAmdF.ChromeTabDragOver(Sender:TObject;x,y:integer;State:TDragState;Dragtabobject:Idragtabobject;
	var Accept:Boolean);
var
	Tabs,Tabs0:Tchrometabs;
	Cr1:Tchrometab;
	Wn:TWinControl;
	i,C:integer;
	Winx,Winy:integer;
Begin
	Tabs:=Tchrometabs(Sender);
	Tabs0:=Tchrometabs(Dragtabobject.Sourcecontrol.Getcontrol);
	Caption:=Tabs0.ToString;
	{ if (TChromeTabs(Sender).GetTabUnderMouse<>nil) then begin
		end; }
	if (Dragtabobject.Dragtab.Caption=SFL1(130)) then Begin
		if (Tabs=CRT1) then Accept:=True
		else Accept:=False;

	end else Begin
		Accept:=True;
		{ case State of
			dsDragEnter,dsDragMove:begin
			if (DragTabObject.DockControl<>nil) then begin
			CR1:=DragTabObject.DragTab;
			I:=CR1.Index;
			WN:=CR1.HControl;
			if (WN<>nil) then begin
			WN.Parent:=DragTabObject.DockControl.GetControl.Parent;
			end;
			end;
			end;
			dsDragLeave:begin
			C:=Tabs0.Tabs.Count;
			if (C>1) then begin
			I:=DragTabObject.DragTab.Index;
			if (I=C-1) then Tabs0.Tabs[I-1].HControl.Show
			else Tabs0.Tabs[I+1].HControl.Show;
			end;
			end;
			end; }
	end;
end;

procedure TAmdF.ChromeTabDragDrop(Sender:TObject;x,y:integer;Dragtabobject:Idragtabobject;Cancelled:Boolean;
	var Tabdropoptions:Ttabdropoptions);
var
	Winx,Winy:integer;
	Newform:Tform;
	Wn:TWinControl;
	Cht1:Tchrometabs;
	Cr1:Tchrometab;
	TR,Su:string;
Begin
	try
		Su:=Dragtabobject.Dragtab.Caption;
		TR:=SFL1(130);
		Wn:=Dragtabobject.Dragtab.HControl;
		if Cancelled then Begin
			Tabdropoptions:=[];
			EXIT;
		end;
		if (not Cancelled)and(Dragtabobject.Sourcecontrol<>Dragtabobject.Dockcontrol) then Begin
			if (Su=TR) then Begin
				Tabdropoptions:=[];
				EXIT;
			end;
			Wn:=Dragtabobject.Dragtab.HControl;
			if (Dragtabobject.Dockcontrol=nil) then Begin
				Winx:=Mouse.Cursorpos.x-Dragtabobject.Dragcursoroffset.x-((Width-ClientWidth)div 2);
				Winy:=Mouse.Cursorpos.y-Dragtabobject.Dragcursoroffset.y-(Height-ClientHeight)+((Width-ClientWidth)div 2);
				Newform:=Tform.Createnew(Application); // TChromeTabsGlassForm
				with Newform do Begin
					Caption:='';
					Font:=Self.Font;
					Bidimode:=Self.Bidimode;
					BorderStyle:=Bssizeable;
					Position:=Podesigned;
					SetBounds(Winx,Winy,Self.Width,Self.Height);
					Glassframe.Enabled:=True;
					Glassframe.Top:=Na(Sfr1(26));
				end;
				Cht1:=Tchrometabs.Create(Newform);
				with Cht1 do Begin
					Parent:=Newform;
					Align:=Altop;
					Height:=Na(Sfr1(26));
				end;
				TFormType(Newform).Chrometabs:=Cht1;
				Landotchrome(Cht1);
				if (Wn<>nil) then Begin
					Cr1:=Addtab(Cht1,Dragtabobject.Dragtab.Caption,Wn,Dragtabobject.Dragtab.ImageIndex);
					// Dragtabobject.Dragtab.HControl:=nil;
					Cr1.Data:=Dragtabobject.Dragtab.Data;
					Cr1.Caption:=Dragtabobject.Dragtab.Caption;
					Cr1.ImageIndex:=Dragtabobject.Dragtab.ImageIndex;
					Cr1.ImageIndexOverlay:=Dragtabobject.Dragtab.ImageIndexOverlay;
					Cr1.Pinned:=Dragtabobject.Dragtab.Pinned;
					Cr1.HideCloseButton:=Dragtabobject.Dragtab.HideCloseButton;
					Cr1.Spinnerstate:=Dragtabobject.Dragtab.Spinnerstate;
					Cr1.Tag:=Dragtabobject.Dragtab.Tag;
					Cr1.Visible:=Dragtabobject.Dragtab.Visible;
					Cr1.Modified:=Dragtabobject.Dragtab.Modified;
					Cr1.HControl:=Dragtabobject.Dragtab.HControl;
					Cht1.ActiveTab:=Cr1;
					Cr1.HControl.Parent:=Newform;
					// Wn.Parent:=Newform;
					ChromeTabClick(Cht1,Cr1);
				end;
				Newform.Show;
				Tabdropoptions:=[Tddeletedraggedtab];
			end else Begin
				if (Wn<>nil) then Begin
					Wn.Parent:=Dragtabobject.Dockcontrol.Getcontrol.Parent;
					if (Wn=nil) then ShowMessage('Wn=nil');
				end;
			end;
		end;
	except
		on E:Exception do ShowMessage('Chrome DragDrop'+#13+E.ToString);
	end;

end;

procedure TAmdF.ChromeTabDragEnd(Sender:TObject;Mousex,Mousey:integer;Dragtabobject:Idragtabobject;Cancelled:Boolean);
var
	Wn:Tform;
	Ct1:Tchrometabs;
Begin
	try
		if (not Cancelled)and(Dragtabobject.Sourcecontrol<>Dragtabobject.Dockcontrol) then Begin
			Ct1:=Tchrometabs(Sender);
			Wn:=Tform(Ct1.Owner);
			Ct1.Tabs.BeginUpdate;
			Ct1.Tabs.EndUpdate;
			if (Wn<>Self) then
				if (Ct1.Tabs.Count=1) then Wn.Close;
		end;
	except
		on E:Exception do ShowMessage('Chrome DropEND'+#13+E.ToString);
	end;
end;
/// ///////////////////////////////// another/////////////////////////////////////
/// //////////////////////////////////////////////////////////////////////////////

procedure TAmdF.Button10click(Sender:TObject);
Begin
	// ShellExecute(0,'runas',Cns,Pchar(Paramstr(0)+' APPEXT'),nil,SW_SHOWNORMAL);
	ShellExecute(0,'runas',Cns,Pchar(Paramstr(0)+' ALL E:\PRO\AMD-Bold.ttf AMD-AMDZ'),nil,SW_SHOWNORMAL);
end;

procedure TAmdF.Button33click(Sender:TObject);
Begin
	Taskbar1.Taskbar.Deletetab(Handle);
	Taskbtn:=False;
end;

procedure TAmdF.Button34click(Sender:TObject);
Begin
	Taskbar1.Taskbar.Addtab(Handle);
	Taskbar1.Applychanges;
	// Taskbar1.OverlayIcon.Handle:=SIC1(NA(SFR1(31)));
	// Taskbar1.Taskbar.SetOverlayIcon(SIC1(8),'SDSD');
	Taskbtn:=True;
end;

procedure TAmdF.Button35click(Sender:TObject);
var
	Fvi:Tfileversioninfo;
	r,O,Tmp:string;
	Apro:Trew;
	f:IStream;
	Buffer:AnsiString;
	statstg:TStatStg;
	Total:Longint;
	Size:FixedUInt;
	KY,ky1:TPropertyKey;
	BUF: array [0..999] of Char;
	CB:DWORD;
	hh:hkey;
Begin
	SetLength(Tmp,MAX_PATH);
	GetTempPath(MAX_PATH,Pchar(Tmp));
	GetTempFileName(Pchar(Tmp),'AMD',0,Pchar(Tmp));
	SetLength(Tmp,Length(Pchar(Tmp)));
	ShowMessage(Tmp);
	EXIT;
	CB:=1002;
	if Failed(Hresultfromwin32(RegOpenKey(HKEY_CLASSES_ROOT,'SystemFileAssociations\.ainvx',hh))) then
			ShowMessage('fail');

	if Failed(Hresultfromwin32(SHGetValue(HKEY_CLASSES_ROOT,'',Pchar('StatusIcons'),nil,@BUF,CB))) then EXIT;
	r:=BUF;
	ShowMessage(Length(r).ToString+#13+r);
	EXIT;
	r:='C:\Users\MICLE\Desktop\SSS.amdz';
	// ShowMessage(GetExtendedFileProperties(R));

	{ with TOpenDialog.Create(nil) do begin
		if Execute then R:=FileName;
		Free;
		end; }
	{ Setfilesummaryinfo(R,[RichEdit.Text,'Subject1','Author1','Keywords1','Comments1','Temp1','LAuth1',
		'REVNUMBER1','EDITTIME1','LASTPRINTED1','CREATE DTM1','LASTSAVE DTM1','PAGECOUNT1','WORDCOUNT1',
		'CHARCOUNT1','THUMBNAIL1','Appn1','SECURITY1','A','S','D','F','C','V','E','G','T','TG','L','I',
		'LJ','J','K']); }
	Setfilesummaryinfo(r,[RichEdit.text,'Subject1','Author1','555']);
	// Setfilesummaryinfo(R,['ahmdf'],3);
	O:=Getfilesummaryinfo(r,Apro);
	// ShowMessage(O);
	{ OleCheck(SHCreateStreamOnFileEx(Pchar(R),STGM_READWRITE or STGM_SHARE_EXCLUSIVE,
		FILE_ATTRIBUTE_NORMAL,False,nil,f));
		f.Stat(StatStg,STATFLAG_NONAME);
		Total:=StatStg.Cbsize;
		f.Seek(0,STREAM_SEEK_SET,PUINT64(nil)^);
		Setlength(Buffer,Total);
		f.Read(Pchar(Buffer),Total,@Total);
		RichEdit.Text:=Buffer; }
	{ SetDocInfo('C:\Users\MICLE\Desktop\mkt.docx','tltlt00','sbsbsb00');
		ShowMessage(GetDocInfo('C:\Users\MICLE\Desktop\mkt.docx')); }
	{ SetExlInfo('C:\Users\AHMAD\Desktop\Book2.xlsx','tltlt00','sbsbsb00');
		ShowMessage(GetExlInfo('C:\Users\AHMAD\Desktop\Book2.xlsx')); }
end;

procedure TAmdF.Button36click(Sender:TObject);
var
	Sse,Aw:string;
Begin
	Sse:=Stringofchar('i',150450);
	Aw:=Dupestring('CANCEL|ALL|',100);
	// Msg2(Self,'AMDZQWE','hfgghgf','dgdfgdfgdfgd'+#13+'fggd gdfgdf'+#13+Tts('I:\amd.txt'),I_w,
	// Aw+Aw+Aw+'NONE',4);
	Msg2(Self,'AMDZQWE','hhjkhjkh',Sse+'jjhjhghjggghhhghghhgghghggghggfhghjughgh',I_i,
		'OK|CANCEL|ALL|OK|CANCEL|ALL|OK|CANCEL|ALL|OK|CANCEL|ALL|OK|CANCEL|ALL|OK|CANCEL|ALL|OK|CANCEL|ALL|NONE',2);
	Msg2(Self,'AMDZQWE',Sse+Sse,Tts('I:\a1.txt'),I_e,'OK|CANCEL|ALL|NONE',2,SFL1(136));
	Msg2(Self,'AMDZQWE',
		'hfgKJHKKHJHJKHJKHJHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKKHKHJKHKHJKHJghgf',
		'dgdfgdfgdfFGDFgdfggdgdfgdf',I_s,'OK|CANCEL',2);
	Msg2(Self,'AMDZQWE','hhjkhjkh','JJGHGHJGJHG',6,'OK|CANCEL',2);
	Msg2(Self,'AMDZQWE','JJGHGGHJHGHJGHJGHJGHJGHJGHJHGJGHJHJGHJHGJGHHGHJGJHG','hhjkhjkh',I_i,'',2,'',True,10);
	// Msg1('AMDZQWE', 'MMMMMMMMhjgh ghjghjghjghjg hjghjghjghgf', TTS('K:\amd.txt'),
	// 'OK', 11, 1);
end;

procedure TAmdF.Button37Click(Sender:TObject);
	function GetPropertyKeyCanonicalName(const AKey:TPropertyKey):UnicodeString;
	var
		PropertySystem:IPropertySystem;
		PropertyDescription:IPropertyDescription;
		N:PWideChar;
	Begin
		Result:='';
		if Succeeded(CoCreateInstance(CLSID_IPropertySystem,nil,CLSCTX_INPROC_SERVER,IPropertySystem,PropertySystem)) then
			try
				if Succeeded(PropertySystem.GetPropertyDescription(AKey,IPropertyDescription,PropertyDescription)) then
					try
						if Succeeded(PropertyDescription.GetDisplayName(N)) then
							// .GetCanonicalName(N)
							try Result:=N
							finally CoTaskMemFree(N);
							end;
					finally PropertyDescription:=nil;
					end;
			finally PropertySystem:=nil;
			end;
	end;

var
	IPROP:IPropertyStore;
	RES:HResult;
	PV:TPROPVARIANT;
	LInitializeWithStream:IInitializeWithStream;
	LIStream:IStream;
	INH:IInterface;
	i:integer;
	BUF: array [Word] of Char;
	CB:DWORD;
	PL:Winapi.Propsys.IPropertyDescriptionList;
	pd:IPropertyDescription;
	N,m:Pchar;
	S,O,r:string;
	mx:Cardinal;
	p:Pointer;
	PS:IPropertySystem;
	fl:PROPDESC_TYPE_FLAGS;
	Result:HResult;
	fileShellItem:IShellItem;
	Key:TPropertyKey;
	dd: array [0..1000] of Char;
Begin
	{ dd:='E:\PRO\Win32\Release\logo\Amz_s321.dll,-12';
		ShowMessage(PathParseIconLocation(dd).ToString+#13+dd);
		Exit; }
	{ CB:=MAXWORD+2;
		Result:=AssocQueryString(ASSOCF_VERIFY or ASSOCF_REMAPRUNDLL,6,Pchar('.arnv'),nil,@BUF,@CB);
		ShowMessage(BUF);
		// KIND_DOCUMENT
		Exit; }
	// PSGetPropertyDescriptionListFromString
	RES:=CoInitialize(nil);
	if Succeeded(RES) then Begin
		RES:=SHCreateItemFromParsingName(PWideChar('C:\Users\MICLE\Desktop\DAS1.arnv'),nil,IID_IShellItem,fileShellItem);
		if Succeeded(RES) then Begin
			RES:=fileShellItem.BindToHandler(nil,BHID_PropertyStore,IID_IPropertyStore,IPROP);
		end;
	end;
	CB:=MAXWORD+2;
	Result:=AssocQueryString(ASSOCF_VERIFY or ASSOCF_REMAPRUNDLL,ASSOCSTR_QUICKTIP,Pchar('.arnv'),nil,@BUF,@CB);
	if Succeeded(Result) then Begin
		SetString(S,BUF,CB);
		Result:=CoCreateInstance(CLSID_IPropertySystem,nil,CLSCTX_INPROC_SERVER,IPropertySystem,PS);
		if Succeeded(Result) then Begin
			Result:=PS.GetPropertyDescriptionListFromString(Pchar(S),IID_IPropertyDescriptionList,PL);
			if Succeeded(Result) then Begin
				Result:=PL.GetCount(mx);
				if Succeeded(Result)and(mx>0) then Begin
					O:='';
					for i:=0 to mx-1 do Begin
						Result:=PL.GetAt(i,IID_IPropertyDescription,pd);
						if Succeeded(Result) then Begin
							pd.GetPropertyKey(Key);
							pd.GetDisplayName(N);
							PropVariantInit(PV);
							IPROP.GetValue(Key,PV);
							PS.FormatForDisplayAlloc(Key,PV,PDFF_DEFAULT,m);
							O:=O+widechartostring(N)+' : '+widechartostring(m)+#13;
							CoTaskMemFree(N);
							CoTaskMemFree(m);
						end;
					end;
				end;
			end;
		end;
	end;
	CoUninitialize;
	ShowMessage(O);
	fileShellItem:=nil;
	IPROP:=nil;
	PS:=nil;
	PL:=nil;
	pd:=nil;
	EXIT;
	with TOpenDialog.Create(nil) do Begin
		Options:=Options+[ofAllowMultiSelect];
		Execute;
		for i:=0 to Files.Count-1 do Begin
			CB:=MAXWORD+2;
			AssocQueryString(ASSOCF_VERIFY or ASSOCF_REMAPRUNDLL,ASSOCSTR_SHELLEXTENSION,Pchar(ExtractFileExt(Files[i])),
				Pchar('PropertyHandler'),@BUF,@CB);
			INH:=CreateComObject(StringToGUID(BUF));
			OleCheck(INH.QueryInterface(IInitializeWithStream,LInitializeWithStream));
			OleCheck(INH.QueryInterface(IPropertyStore,IPROP));
			// LInitializeWithStream:=INH AS IInitializeWithStream;
			// IPROP:=INH AS IPropertyStore;
			if Assigned(IPROP)and Assigned(LInitializeWithStream) then Begin
				RES:=SHCreateStreamOnFileEx(Pchar(Files[i]),18,0,False,nil,LIStream);
				RES:=LInitializeWithStream.Initialize(LIStream,18);
			end;
			if Succeeded(RES) then Begin
				RES:=IPROP.GetValue(PKEY_DRM_IsProtected,PV);
				RES:=InitPropVariantFromBoolean(False,PV);
				RES:=IPROP.SetValue(PKEY_DRM_IsProtected,PV);
				RES:=IPROP.Commit;
			end
			else ShowMessage('SetValue');
			LIStream._Release;
			IPROP._Release;
			LInitializeWithStream._Release;
			INH._Release;
		end;
		Free;
	end;
end;

function GetImageListSH(SHIL_FLAG:Cardinal):HIMAGELIST;
type
	_SHGetImageList=function(IImageList:integer;const riid:TGUID;var ppv:Pointer):HResult;stdcall;
var
	Handle:THandle;
	SHGetImageList:_SHGetImageList;
begin
	Result:=0;
	Handle:=LoadLibrary('Shell32.dll');
	if Handle<>S_OK then
		try
			SHGetImageList:=GetProcAddress(Handle,Pchar(727));
			if Assigned(SHGetImageList)and(Win32Platform=VER_PLATFORM_WIN32_NT) then
					SHGetImageList(SHIL_FLAG,StringToGUID(IID_IImageList),Pointer(Result));
		finally FreeLibrary(Handle);
		end;
end;

VAR
	DDD:integer;

procedure TAmdF.Button38Click(Sender:TObject);
var
	x,i:integer;
	uico:HICON;
	ico:Vcl.Graphics.TIcon;
	IMG:HIMAGELIST;
	RecentItem:TUIRecentItem;
	SS:string;
Begin
	DDD:=SHMessageBoxCheckW(Handle,'Do you want to EXIT without saving ?','Warning',MB_YESNO OR MB_ICONINFORMATION,DDD,
		'AMD2'); // '{d9108ba3-9a61-4398-bfbc-b02102c77e8a }'
	ShowMessage(DDD.ToString);
	EXIT;
	(Ribbon.RecentItems.Items[0] as TUIRecentItem).Pinned:=True;
	SS:='';
	for i:=0 to Ribbon.RecentItems.Items.Count-1 do
			SS:=SS+(Ribbon.RecentItems.Items[i] as TUIRecentItem).Pinned.ToInteger.ToString+#13;
	RichEdit.text:=SS;
	// ShowMessage((Ribbon.RecentItems.Items[0] as TUIRecentItem).Path);
	EXIT;
	x:=0;
	IMG:=GetImageListSH(4);
	amn.Clear;
	ListView1.Items.Clear;
	for i:=0 to ImageList_GetImageCount(IMG)-1 do Begin
		Application.Processmessages;
		ico:=Vcl.Graphics.TIcon.Create;
		// if Succeeded((LIWSDown(0,Makeintresource(i),48,48,uico))) then Begin
		ico.Handle:=ImageList_GetIcon(IMG,i,0);
		amn.AddIcon(ico);
		ProgressBar1.Position:=Trunc(i);
		with ListView1.Items.add do Begin
			Caption:=i.ToString;
			ImageIndex:=i;
		end;
		INC(x,1);
		// end;
		ico.Free;
	end;
	ShowMessage(amn.Count.ToString);
end;

procedure TAmdF.Button39Click(Sender:TObject);
var
	Obj:ICOMAdminCatalog;
	CatCol:ICatalogCollection;
	Item:ICatalogObject;
	i:integer;
	D1:UInt64;
Begin
	ShowMessage(Formatdatetime('dddd MMMM d',now));
	EXIT;
	D1:=TNow;
	SSTGA.Show;
	Amdf.Caption:=Def(D1,TNow)+' MILLISECONDS ';
	EXIT;
	NewItem('C:\Users\MICLE\Desktop');
	// Exit;
	ShowMessage(sizeof(Extended).ToString);
	Obj:=CoCOMAdminCatalog.Create;
	try
		CatCol:=Obj.GetCollection('Applications') as ICatalogCollection;
		CatCol.Populate;
		for i:=0 to CatCol.Count-1 do Begin
			Item:=CatCol.Item[i] as ICatalogObject;
			ShowMessage(Item.Name);
		end;
	finally Obj:=nil;
	end;
end;

procedure TAmdF.Button11click(Sender:TObject);
var
	i,COT:integer;
	r:string;
Begin
	// SGQ(0,'0',SFR1(2));
	r:='';
	COT:=CN[6].ExecSQLScalar('SELECT COUNT(ID) FROM QINV WHERE ID NOT NULL');
	for i:=1 to COT do r:=r+'UPDATE QINV SET SA=(SELECT SUM(AM2) FROM Q3N'+i.ToString+') WHERE ICODE='+i.ToString+';';
	CN[6].ExecSQL(r);
end;

procedure TAmdF.Button12click(Sender:TObject);
var
	mx,i:integer;
	Rt: array of string;
	S:string;
	p:PWideChar;
	BMP:TBITMAP;
Begin
	FontDialog1.Execute;
	EXIT;
	FQ[2].Open('DROP TABLE IF EXISTS table_info;'+
		'CREATE TEMPORARY TABLE table_info AS SELECT * FROM pragma_table_info("DOCM");SELECT name FROM table_info');
	ShowMessage(FQ[2].Fields[0].Asstring);
	// Showmessage(Clipboard.Astext);
	// user2(FontDialog1);
	// FontDialog1.Execute;
	// ShowMessage(IsLeapYear(2016).ToString);
	// FontDialog1.Execute(Handle);
	// OpenTextFileDialog1.Execute(Handle);
	{ FQ[8].Open('SELECT tbl_name FROM "main".sqlite_master');
		if(FQ[8].RowsAffected>0)then begin
		for I:=1 to FQ[8].RowsAffected do begin
		S:=FQ[8].Fields[0].AsString;
		if(IndexStr(S,['sqlite_sequence','SN1','SN2','SN3','SN4','T00000'])=-1)then begin
		Cn[8].Execsql('INSERT INTO "T00000" (US,ST,SN,ICODE,RIF,IFRM,FRM,REF,QTY,PR,COMM,DAT,CODE) '
		+'SELECT US,ST,SN,ICODE,RIF,IFRM,FRM,REF,QTY,PR,COMM,DAT,"'+Copy(S,2,10)+'" FROM '+S);
		end;
		FQ[8].Next;
		end;
		end; }
	{ FQ[8].Open('SELECT tbl_name FROM "main".sqlite_master');
		if (FQ[8].RowsAffected>0) then begin
		for I := 1 to FQ[8].RowsAffected do begin
		S:=FQ[8].Fields[0].AsString;
		if (IndexStr(S,['sqlite_sequence','SN1','SN2','SN3','SN4'])=-1) then begin
		CN[8].ExecSQL('ALTER TABLE "'+FQ[8].Fields[0].AsString+'" RENAME TO "'+SFIT(s)+'"');
		end;
		FQ[8].Next;
		end;
		end; }
	{ OleContainer1.OleObjectInterface.GetUserType(USERCLASSTYPE_FULL, P);
		ShowMessage(P);
		CoTaskMemFree(P); }
end;

procedure TAmdF.Button13click(Sender:TObject);
// type
// res= set of restypenames;
var
	Rgn:hrgn;
	Tx0:string;
	S:AnsiString;
	SM:Tstream;
	Bm:Tjpegimage;
	Ri:Pris;
	i:integer;
	Bitmap:TBITMAP;
Begin

	{ FQ[8].Open('SELECT SUM(QTY * PR) FROM IT10101 WHERE RIF = "2"');
		ShowMessage(FQ[8].Fields[0].AsString);
		ShowMessage(SFIT8('10101'));
		// ShowMessage(SFIT7('10101','150')); }
	// amd_st.res 'VCLSTYLE'  AHDL.dll  ,'130',PChar(2)
	// ShowMessage(FloatToStrF(FloatToStrF(1000000000,ffFixed,200,2).ToExtended,ffGeneral,200,2));
	{ keybd_event(VK_CAPITAL,45,KEYEVENTF_EXTENDEDKEY,0);
		keybd_event(VK_CAPITAL,45,KEYEVENTF_EXTENDEDKEY+KEYEVENTF_KEYUP,0); }
	{ GetWindowRgn(Button13.Handle,rgn);
		DeleteObject(rgn);                  //H:\printer\AADELPHI\NEW\PRO\Win32\Release\
		rgn:=CreateRoundRectRgn(0,0,Button13.Width,Button13.Height,1200,1200);
		SetWindowRgn(Button13.Handle,rgn,true); }
	// 'logo\ASS.dll',RT_HTML,'WEBSERVICEERROR.HTM'
	// messagedlg('Confirmation',mtError,mbOKCancel,0);
	{ tx0:=TxToHy('AMD0','youtube')+#13+TxToHy('AMD1','facebook')+ExtractFilePath(ParamStr(0));
		Msg2(self,'CART','TITLE0',tx0,10,'O|K|L|P',2,'C|V|d|F'); }
	// RunAsAdmin(Application.MainFormHandle,ParamStr(0),'');
	// exit;
	// ASaveResorce('logo\ASS.dll','RT_GROUP_ICON','#1555',SM); // RT_GROUP_CURSOR
	Updateresstring('logo\ASS.dll','سوري',34576,Getuserdefaultlcid); // GetUserDefaultLCID
	Updateresstring('logo\ASS.dll','SYRIAN',34576,1033); // GetUserDefaultLCID
	Updateresstring('logo\ASS.dll','SORI',34576,0);
	// ,'RT_BITMAP','#1984'
	// RI:=ALoadResorce('logo\ASS.dll','RT_GROUP_ICON','#1555');
	Ri:=Aloadresorce('logo\ASS.dll','RT_STRING');
	// ,'RT_STRING','258','4112'
	RichEdit.Lines.text:=Ri.Ulist;
	// ShowMessage(string(RI.uDatas.uData)); //STRING
	// Screen.Cursors[crDefault]:=I; // cursor.
	// Button13.Cursor:=I;
	// CRT1.Tabs[0].HControl.Cursor:=I;
	// Image1.Picture.Icon.Handle:=RI.uDatas.uH; // cursor ,bitmap,icon.
	// RI.uDis;
	Dispose(Ri);
	{ if (RI.uSM<>nil) then begin
		BM:=TJPEGImage.Create;
		BM.LoadFromStream(RI.uSM);
		Image1.Picture.Graphic.LoadFromStream(RI.uSM);
		end; }
end;

procedure TAmdF.Button23click(Sender:TObject);
Begin
	// Exceltsg(Tsga(Owner).Sj,'AHMA','D:\AHMD.xlsx');
	// Ribbon.ActiveEventManager:=True;
	Ribbon.Minimized:=True;
end;

procedure TAmdF.Button24click(Sender:TObject);
Begin
	// Sgtexcel(Tsga(Owner).Sj,'AHM','D:\AHMD.xlsx');
	Ribbon.Minimized:=False;
	{ Ribbon.Load;
		Ribbon.Refresh; }
end;

procedure TAmdF.Button25click(Sender:TObject);
Begin
	// Sgtword(Tsga(Owner).Sj,'D:\AHMD.doc');
	Ribbon.SetApplicationModes([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]);
end;

procedure TAmdF.Button26click(Sender:TObject);
Begin
	Wrdtexl('D:\AHMD.doc','D:\AHMex.xlsx');
end;

procedure TAmdF.Button27click(Sender:TObject);
Begin
	// Wordtsg(Tsga(Owner).Sj,'D:\AHMD.doc');
	Ribbon.SetApplicationModes(4294967295);
end;

procedure TAmdF.Button28click(Sender:TObject);
Begin
	Exltwrd('D:\AHMD.xlsx','AHMA','D:\AHMex.doc');
end;

procedure TAmdF.Button29click(Sender:TObject);
Begin
	// Sgtcsv(Tsga(Owner).Sj,'D:\ASMD.csv');
	Ribbon.SetApplicationModes([0]);
end;

procedure TAmdF.Button2Click(Sender:TObject);
	function GetShortcutTarget(ShortcutFilename:string):string;
	var
		Psl:IShellLink;
		Ppf:IPersistFile;
		WideName: array [0..MAX_PATH] of Char;
		pResult: array [0..MAX_PATH-1] of ANSIChar;
		Data:TWin32FindData;
	const
		IID_IPersistFile:TGUID='{0000010B-0000-0000-C000-000000000046}';
	Begin
		CoCreateInstance(CLSID_ShellLink,nil,CLSCTX_INPROC_SERVER,IID_IShellLinkA,Psl);
		Psl.QueryInterface(IPersistFile,Ppf);
		MultiByteToWideChar(CP_ACP,0,pansichar(ShortcutFilename),-1,WideName,MAX_PATH);
		Ppf.Load(WideName,STGM_READ);
		Psl.Resolve(0,SLR_ANY_MATCH);
		Psl.GetPath(@pResult,MAX_PATH,Data,SLGP_UNCPRIORITY);
		Result:=StrPas(pResult);
	end;

var
	S:HResult;
	pCache:IPropertyStoreCache;
	r:Cardinal;
Begin
	ShowMessage(GetShortcutTarget('C:\Users\MAHER\Desktop\AMD A EXTENSIONS.lnk'));
end;

procedure TAmdF.Button30click(Sender:TObject);
Begin
	// Csvtsg(Tsga(Owner).Sj,'D:\ASMD.csv');
	Ribbon.SetApplicationModes([1]);
end;

function GetSystrayHandle:THandle;
var
	hTray,hNotify,hSysPager:THandle;
Begin
	hTray:=Findwindow('Shell_TrayWnd','');
	if hTray=0 then Begin
		Result:=hTray;
		EXIT;
	end;

	hNotify:=FindWindowEx(hTray,0,'TrayNotifyWnd','');
	if hNotify=0 then Begin
		Result:=hNotify;
		EXIT;
	end;

	hSysPager:=FindWindowEx(hNotify,0,'SysPager','');
	if hSysPager=0 then Begin
		Result:=hSysPager;
		EXIT;
	end;

	Result:=FindWindowEx(hSysPager,0,'ToolbarWindow32','Notification Area');
end;

procedure Refresh1;
var
	hSysTray:THandle;
Begin
	hSysTray:=GetSystrayHandle;
	Sendmessage(hSysTray,WM_PAINT,0,0);
end;

procedure TAmdF.Button31Click(Sender:TObject);
	function OpenPropertyPage(AFileOrFolder:string):Boolean;
	var
		ShExecInfo:TShellExecuteInfo;
	Begin
		Result:=False;
		Zeromemory(@ShExecInfo,sizeof(ShExecInfo));
		ShExecInfo.cbSize:=sizeof(ShExecInfo);
		ShExecInfo.fMask:=SEE_MASK_INVOKEIDLIST;
		ShExecInfo.lpVerb:='properties';
		ShExecInfo.lpFile:=Pchar(AFileOrFolder);
		ShExecInfo.lpParameters:='';
		ShExecInfo.lpDirectory:='';
		ShExecInfo.nShow:=SW_SHOW;
		ShExecInfo.hInstApp:=0;
		Result:=ShellExecuteEx(@ShExecInfo);
	end;

	function GetPropertyKeyCanonicalName(const AKey:TPropertyKey):UnicodeString;
	var
		PropertySystem:IPropertySystem;
		PropertyDescription:IPropertyDescription;
		N:PWideChar;
	Begin
		Result:='';
		if Succeeded(CoCreateInstance(CLSID_IPropertySystem,nil,CLSCTX_INPROC_SERVER,IPropertySystem,PropertySystem)) then
			try
				if Succeeded(PropertySystem.GetPropertyDescription(AKey,IPropertyDescription,PropertyDescription)) then
					try
						if Succeeded(PropertyDescription.GetDisplayName(N)) then
							// .GetCanonicalName(N)
							try Result:=N
							finally CoTaskMemFree(N);
							end;
					finally PropertyDescription:=nil;
					end;
			finally PropertySystem:=nil;
			end;
	end;

var
	S,m,W:string;
	i,x:integer;
	tf:TFileStream;
	D:TGUID;
	k:TPropertyKey;
Begin
	Refresh1;
	ShowMessage(GetPropertyKeyCanonicalName(PKEY_Title));
	EXIT;
	W:=LoadFromDirC(Paramstr(0),2)+'PropDesc\Win32\Release\PropDesc.exe';
	RichEdit.text:=W;
	if Isuseranadmin then ShowMessage('ADMIN');
	// ShellExecute(0,'runas',PChar(w),nil,nil,SW_SHOWNORMAL);

	CLSIDFromProgID('AMD.amdz',D);
	ShowMessage(GUIDToString(D));

	// OpenPropertyPage('C:\Users\MAHER\Desktop\Desert.bmp');
	// OpenPropertyPage('C:\Windows');
end;

type
	PShellLinkInfoStruct=^TShellLinkInfoStruct;

	TShellLinkInfoStruct=record
		LinkFile: array [0..MAX_PATH] of Char;
		ToExecute: array [0..MAX_PATH] of Char;
		ParamString: array [0..MAX_PATH] of Char;
		WorkingDirectroy: array [0..MAX_PATH] of Char;
		Description: array [0..MAX_PATH] of Char;
		FileIcon: array [0..MAX_PATH] of Char;
		Iconindex:integer;
		HotKey:Word;
		ShowCommand:integer;
		FindData:TWin32FindData;
	end;

procedure TAmdF.Button32Click(Sender:TObject);
	procedure GetLinkInfo(lpShellLinkInfoStruct:PShellLinkInfoStruct);
	var
		ShellLink:IShellLink;
		PersistFile:IPersistFile;
		AnObj:IUnknown;
	Begin
		// access to the two interfaces of the object
		AnObj:=CreateComObject(CLSID_ShellLink);
		ShellLink:=AnObj as IShellLink;
		PersistFile:=AnObj as IPersistFile;

		// Opens the specified file and initializes an object from the file contents.
		PersistFile.Load(Pchar(WideString(lpShellLinkInfoStruct^.LinkFile)),0);
		with ShellLink do Begin
			// Retrieves the path and file name of a Shell link object.
			GetPath(lpShellLinkInfoStruct^.ToExecute,sizeof(lpShellLinkInfoStruct^.LinkFile),lpShellLinkInfoStruct^.FindData,
				SLGP_UNCPRIORITY);

			// Retrieves the description string for a Shell link object.
			GetDescription(lpShellLinkInfoStruct^.Description,sizeof(lpShellLinkInfoStruct^.Description));

			// Retrieves the command-line arguments associated with a Shell link object.
			GetArguments(lpShellLinkInfoStruct^.ParamString,sizeof(lpShellLinkInfoStruct^.ParamString));

			// Retrieves the name of the working directory for a Shell link object.
			GetWorkingDirectory(lpShellLinkInfoStruct^.WorkingDirectroy,sizeof(lpShellLinkInfoStruct^.WorkingDirectroy));

			// Retrieves the location (path and index) of the icon for a Shell link object.
			GetIconLocation(lpShellLinkInfoStruct^.FileIcon,sizeof(lpShellLinkInfoStruct^.FileIcon),
				lpShellLinkInfoStruct^.Iconindex);

			// Retrieves the hot key for a Shell link object.
			GetHotKey(lpShellLinkInfoStruct^.HotKey);

			// Retrieves the show (SW_) command for a Shell link object.
			GetShowCmd(lpShellLinkInfoStruct^.ShowCommand);
		end;
	end;

const
	Br=#13#10+'-';
var
	LinkInfo:TShellLinkInfoStruct;
	S:string;
	searchResult:TSearchRec;
var
	Shk:IShellLink;
	PF:IPersistFile;
	Aj:IUnknown;
Begin
	if FindFirst('N:\VIDEO\*.lnk',faAnyFile-faDirectory,searchResult)=0 then Begin
		Aj:=CreateComObject(CLSID_ShellLink);
		Shk:=Aj as IShellLink;
		PF:=Aj as IPersistFile;
		repeat S:=S+searchResult.Name+#13;
			{ try
				FillChar(LinkInfo,SizeOf(LinkInfo),#0);
				Strlcopy(LinkInfo.LinkFile,Pchar('N:\VIDEO\'+searchResult.Name),Max_path);
				OleCheck(PF.Load(Pchar('N:\VIDEO\'+searchResult.Name),18));
				OleCheck(Shk.GetPath(LinkInfo.ToExecute,SizeOf(LinkInfo.LinkFile),LinkInfo.FindData,
				SLGP_UNCPRIORITY));
				LinkInfo.ToExecute[0]:='N';
				OleCheck(Shk.SetPath(LinkInfo.ToExecute));
				OleCheck(Shk.GetWorkingDirectory(LinkInfo.WorkingDirectroy,
				SizeOf(LinkInfo.WorkingDirectroy)));
				LinkInfo.WorkingDirectroy[0]:='N';
				OleCheck(Shk.SetWorkingDirectory(LinkInfo.WorkingDirectroy));
				OleCheck(PF.Save(Pchar('N:\VIDEO\'+searchResult.Name),True));
				OleCheck(PF.Save(Pchar('N:\VIDEO\'+searchResult.Name),True));
				OleCheck(PF.SaveCompleted(Pchar('N:\VIDEO\'+searchResult.Name)));
				except
				on E:Exception do Showmessage(searchResult.Name);
				end; }
		until FindNext(searchResult)<>0;
		FindClose(searchResult);
		ShowMessage(S);
	end;
	EXIT;
	FillChar(LinkInfo,sizeof(LinkInfo),#0);
	LinkInfo.LinkFile:='N:\VIDEO\[EgyBest].Antiviral.2012.720p.x264.mp4 - رمز اختصار.lnk';
	GetLinkInfo(@LinkInfo);
	with LinkInfo do
			S:=LinkFile+Br+ToExecute+Br+ParamString+Br+WorkingDirectroy+Br+Description+Br+FileIcon+Br+IntToStr(Iconindex)+Br+
			IntToStr(LoByte(HotKey))+Br+IntToStr(HiByte(HotKey))+Br+IntToStr(ShowCommand)+Br+FindData.cFileName+Br+
			FindData.cAlternateFileName;
	ShowMessage(S);
end;

procedure TAmdF.Button16click(Sender:TObject);
var
	Rf:Tstringlist;
	dd: array [0..255] of ANSIChar;
	bb:Pchar;
	poainfo:TOpenAsInfo;
	ppEnumHandler:IEnumAssocHandlers;
	css:Cardinal;
	rgelt:IAssocHandler;
Begin
	SHAssocEnumHandlers('.arnv',ASSOC_FILTER_NONE,ppEnumHandler);
	ppEnumHandler.Next(1,rgelt,css);
	rgelt.GetUIName(bb);
	ShowMessage(bb);
	Rf:=Tstringlist.Create;
	with TOpenDialog.Create(Self) do Begin
		Execute;
		StrPLCopy(dd,AnsiString(Files[0]),256);
		if Files.Count>0 then Examine(dd,Rf);
	END;
	// 'C:\Users\MICLE\Desktop\propsys.dll'
	RichEdit.Lines.text:=Rf.text;
	Rf.Free;
end;

procedure TAmdF.Button17click(Sender:TObject);
Begin
	Tile;
end;

function SSChainCpyW(pszDest:Pchar;pszSrc:Pchar):Pchar;
asm
	// The auto-generated pushing of edi and esi onto the stack means that
	// our esp is offset by 8 bytes

	xor         eax,eax
	mov         esi,[esp+$10] // pszSrc
	mov         edi,esi
	or          ecx,-1
	repnz scasw
	not         ecx
	mov         edi,[esp+$0C] // pszDest
	rep movsw
	dec         edi
	dec         edi
	xchg        eax,edi

end;

procedure TAmdF.Button18click(Sender:TObject);
var
	f:THandle;
	Buffer: array [0..MAX_PATH] of Char;
	i,Numfiles:integer;
	S,fn:string;
Begin
	ShowMessage(OutFiles.text);
	ShowMessage(TSQLiteDatabase(CN[7].ConnectionIntf.CliObj).Lib.DLLName);
	ShowMessage(CN[7].ExecSQLScalar('SELECT sqlite_version()'));
	EXIT;
	fn:='E:\PRO\Win32\Release\Sources\AMD.ttf';
	// RemoveFontResource(PCHAR(R));
	// PostMessage(HWND_BROADCAST,WM_FONTCHANGE,0,0);
	// EXIT;
	S:=Paramstr(0)+' "FONT" "'+fn+'" "AMD (TrueType)"';
	ShellExecute(0,'runas',Cns,Pchar(S),nil,SW_SHOWNORMAL);
	EXIT;
	CN[2].ExecSQL('ATTACH "'+Md[8]+'" AS "A8"');
	CN[2].ExecSQL('ATTACH "'+Md[6]+'" AS "A6"');
	// FQ[2].Open('select CASE when name="A8" THEN 0 ELSE 1 END AS DD FROM (SELECT * FROM PRAGMA_database_list)');
	FQ[2].Open('PRAGMA database_list');
	for i:=1 to FQ[2].RowsAffected do Begin
		ShowMessage(FQ[2].Fields[0].Asstring+','+FQ[2].Fields[1].Asstring);
		FQ[2].Next;
	end;
	Shchangenotify(Shcne_assocchanged,Shcnf_dword or Shcnf_flush,nil,nil);
	EXIT;
	FQ[6].Open('SELECT "A3N" || '+CHR(39)+CHR(39)+' || ICODE FROM QINV WHERE ID=1');

	ShowMessage(CN[7].ExecSQLScalar('SELECT CASE WHEN CT IS NULL THEN 1 ELSE CT+1 END AS COT FROM'+
		'(SELECT MAX(CONT) AS CT FROM EDT WHERE ICODE = "21" AND ST = "3" AND RIF = "7" '+'ORDER BY id DESC LIMIT 1)'));
	EXIT;
	Clipboard.Open;
	try
		f:=Clipboard.Getashandle(Cf_hdrop);
		if f<>0 then Begin
			Numfiles:=Dragqueryfile(f,$FFFFFFFF,nil,0);
			RichEdit.Clear;
			for i:=0 to Numfiles-1 do Begin
				Buffer[0]:=#0;
				Dragqueryfile(f,i,Buffer,sizeof(Buffer));
				RichEdit.Lines.add(Buffer);
			end;
		end;
	finally Clipboard.Close;
	end;
	Shchangenotify(Shcne_assocchanged,Shcnf_dword or Shcnf_flush,nil,nil);
end;

procedure TAmdF.Button19click(Sender:TObject);
var
	Sse,Aw:string;
Begin
	Sse:=Stringofchar('i',15);
	Aw:=Dupestring('CANCEL|ALL|',100);
	// Msg1(self,'AMDZQWE','hfgghgf','dgdfgdfgdfgd'+#13+'fggd gdfgdf'+#13+TTS('F:\amd3.txt'),29,
	// AW+AW+AW+AW+AW+AW+AW+AW+AW+AW+AW+AW+AW+AW+AW+AW+AW+AW+AW+AW+AW+'NONE',4,SFL1(136),bu);
	Msg1(Self,'AMDZQWE','hhjkhjkh',Sse+'jjhjhghjggghhhghghhgghghggghggfhghjughgh',2,
		'OK|CANCEL|ALL|OK|CANCEL|ALL|OK|CANCEL|ALL|OK|CANCEL|ALL|OK|CANCEL|ALL|OK|CANCEL|ALL|OK|CANCEL|ALL|NONE',2,
		'',bu,1,100);
	Msg1(Self,'AMDZQWE',Sse+Sse,Tts('I:\a1.txt'),3,'OK|CANCEL|ALL|NONE',2,SFL1(136),bu);
	Msg1(Self,'AMDZQWE',
		'hfgKJHKKHJHJKHJKHJHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKKHKHJKHKHJKHJghgf',
		'dgdfgdfgdfFGDFgdfggdgdfgdf',4,'OK|CANCEL',2,SFL1(136),bu);
	Msg1(Self,'AMDZQWE','hhjkhjkh','JJGHGHJGJHG',6,'OK|CANCEL',2,SFL1(136),bu);
	Msg1(Self,'AMDZQWE','JJGHGGHJHGHJGHJGHJGHJGHJGHJHGJGHJHJGHJHGJGHHGHJGJHG','hhjkhjkh',7,'',2,SFL1(136),bu,1,6);
	// Msg1('AMDZQWE', 'MMMMMMMMhjgh ghjghjghjghjg hjghjghjghgf', TTS('F:\amd.txt'),
	// 'OK', 11, 1);}
	// ShowMessage(TTS('F:\amd3.txt'));

end;

procedure TAmdF.Button1click(Sender:TObject);
var
	Style:string;
	Item,Item1:TMenuItem;
	Stylemenu:Tmainmenu;
	Lstylenames:TArray<string>;
Begin
	Lstylenames:=Tstylemanager.Stylenames;
	TArray.Sort<string>(Lstylenames);
	Stylemenu:=Tmainmenu.Create(CRT1.Tabs[1].HControl);
	Item1:=TMenuItem.Create(Stylemenu);
	Item1.Caption:='&Styles';
	Item1.Autolinereduction:=Maparent;
	Stylemenu.Items.add(Item1);
	for Style in Lstylenames do Begin
		if Sametext('Windows',Style) then Begin
			Item:=TMenuItem.Create(Item1);
			Item.Caption:='-';
			Item1.add(Item);
		end;
		Item:=TMenuItem.Create(Item1);
		Item.Caption:=Style;
		Item.Onclick:=Styleclick;
		Item.Autocheck:=True;
		Item1.add(Item);
		if Tstylemanager.Activestyle.Name=Style then Begin
			Item.Checked:=True;
		end;
	end;
	Menu:=Stylemenu;
end;

procedure TAmdF.Styleclick(Sender:TObject);
var
	StyleName:string;
	i:integer;
	Item2:TMenuItem;
Begin
	Item2:=TMenuItem(TMenuItem(Sender).Parent);
	StyleName:=Stringreplace(TMenuItem(Sender).Caption,'&','',[Rfreplaceall,Rfignorecase]);
	Tstylemanager.Setstyle(StyleName);
	(Sender as TMenuItem).Checked:=True;
	for i:=0 to Item2.Count-1 do Begin
		if not(Item2.Items[i].Equals(Sender))and not Item2.Items[i].Isline then Item2.Items[i].Checked:=False;
	end;
end;

function SwapEndian32(Value:integer):integer;register;
asm
	bswap eax
end;

function SwapEndian16(Value:smallint):smallint;register;
asm
	rol   ax, 8
end;

procedure TAmdF.Button7click(Sender:TObject);
var
	Cr:string[15];
	dd:string[16];
	O,E,Tmp,SHM,O9:string;
	STM:IStream;
	PP:TSQLH;
	f:UInt64;
	hc:HICON;
Begin
	// cn[4].Execsql('UPDATE PINV SET SEC = "'+Mdfive('')+'" WHERE ICODE IN (3,4,5,6,7,8,9,14,16) AND ST = "3"');
	CN[3].ExecSQL('UPDATE SINV SET SEC = "'+Mdfive('0000')+'" WHERE ICODE IN (3,4,5,6,7,8,9,14,16) AND ST = "3"');
	{ TMP:='';
		TMP:=TMP+'ATTACH "'+Md[3]+'" AS "A3";';
		TMP:=TMP+'INSERT INTO ERR (CEL,CL,RO,WRG) SELECT "CODD",1,RD+1,printf('''+Sfl1(113)+''',CD) '+
		'FROM (SELECT ROWID AS RD,CODE AS CD FROM AAA WHERE CODE NOT IN '+
		'(SELECT CODE FROM NIT WHERE NIT.CODE=AAA.CODE) AND AAA.CODE <> "");';
		TMP:=TMP+'SELECT group_concat(CD) FROM(SELECT RO-1 AS CD FROM ERR'+
		' UNION ALL SELECT ROWID AS CD FROM AAA WHERE CODE="" ORDER BY ROWID ASC) LIMIT 1;';
		ShowMessage(string(Cn[2].ExecSQLScalar(TMP)));
		Cn[2].Execsql('DETACH "A3"');
		Exit;
		// if not StrToBoolDef('0',False) then SHOWMESSAGE('GG');
		FQ[2].Open('SELECT * FROM DOCM');
		ShowMessage(FQ[2].Table.Columns[0].Name);
		Exit;
		FQ[2].Open('DROP TABLE IF EXISTS AAA;'+'CREATE TEMPORARY TABLE AAA AS SELECT FILE FROM PRAGMA_DATABASE_LIST();'+
		'SELECT FILE FROM AAA WHERE ROWID=2;');
		ShowMessage(FQ[2].Fields[0].AsString);
		// ShowMessage(CN[1].Params.Text);
		// Cn[4].Execsql('UPDATE PINV SET SEC = "'+Mdfive('0000')+'" WHERE ICODE = "16" AND ST = "3"');
		Exit;
		ShowMessage(Cn[1].ExecSQLScalar('select sqlite_version()'));
		// exit;
		// for F := 0 to 9 do  Cn[F].Execsql('VACUUM "MAIN"');

		ShowMessage('Locking_Mode='+Cn[2].ExecSQLScalar('PRAGMA Locking_Mode')+#13+'JournalMode='+
		Cn[2].ExecSQLScalar('PRAGMA journal_mode')+#13+'page_size='+string(Cn[2].ExecSQLScalar('PRAGMA page_size'))+#13+
		'cache_size='+string(Cn[2].ExecSQLScalar('PRAGMA cache_size'))+#13+'synchronous='+
		string(Cn[2].ExecSQLScalar('PRAGMA synchronous'))+#13+'auto_vacuum='+
		string(Cn[2].ExecSQLScalar('PRAGMA auto_vacuum'))+#13+'max_page_count='+
		string(Cn[2].ExecSQLScalar('PRAGMA max_page_count'))+#13+'secure_delete='+
		string(Cn[2].ExecSQLScalar('PRAGMA secure_delete'))+#13+'automatic_index='+
		string(Cn[2].ExecSQLScalar('PRAGMA automatic_index'))+#13+'temp_store='+
		string(Cn[2].ExecSQLScalar('PRAGMA temp_store'))+#13+'user_version='+
		string(Cn[2].ExecSQLScalar('PRAGMA user_version'))); }
	// ShowMessage(Cn[1].Execsql('VACUUM "temp"').Tostring);

	// RichEdit.Text:=IntToBin(StrToUInt64(RichEdit.Text));
	{ ShowMessage(Format('single : %d',[SizeOf(single)])+#13+Format('char : %d',[SizeOf(Char)])+#13+
		Format('AnsiChar : %d',[SizeOf(ANSIChar)])+#13+Format('string : %d',[SizeOf(string)])+#13+
		Format('PChar : %d',[SizeOf(Pchar)])+#13+Format('PAnsiChar : %d',[SizeOf(PAnsiChar)])+#13+
		Format('Integer : %d',[SizeOf(Integer)])+#13+Format('Int32 : %d',[SizeOf(int32)])+#13+
		Format('Int64 : %d',[SizeOf(Int64)])+#13+Format('Uint : %d',[SizeOf(Uint)])+#13+
		Format('Uint32 : %d',[SizeOf(uint32)])+#13+Format('Uint64 : %d',[SizeOf(Uint64)])+#13+
		Format('Byte : %d',[SizeOf(byte)])+#13+Format('WORD : %d',[SizeOf(Word)])+#13+
		Format('DWORD : %d',[SizeOf(DWord)])+#13+Format('CARDINAL : %d',[SizeOf(Cardinal)])+#13+
		Format('Boolean : %d',[SizeOf(Boolean)])+#13+Format('extended : %d',[SizeOf(Extended)])+#13+
		Format('OBJECT : %d',[SizeOf(TObject)])); } // or STGM_SHARE_EXCLUSIVE

	O9:='E:\PRO\Win32\Release\MDfc\AmzPD3.amd';
	SHCreateStreamOnFileEx(Pchar(O9),STGM_READWRITE,0,False,nil,STM);
	STM.Seek(0,STREAM_SEEK_SET,PUINT64(nil)^);
	f:=sizeof(TSQLH);
	STM.Read(@PP,f,@f);
	SetString(E,Pchar(@PP.RESERVED[0]),20);
	dd:=PP.HEAD;
	ShowMessage(Format('HEAD : %s',[dd])+#13+Format('PageSize : %d',[PP.PageSize*256])+#13+Format('FileFormatWrite : %d',
		[PP.FileFormatWrite])+#13+Format('FileFormatRead : %d',[PP.FileFormatRead])+#13+Format('EndOfEachPage : %d',
		[PP.EndOfEachPage])+#13+Format('MXpayload : %d',[PP.MXpayload])+#13+Format('MNpayload : %d',[PP.MNpayload])+#13+
		Format('LeafPayload : %d',[PP.LeafPayload])+#13+Format('FileChangeCounter : %d',[SwapEndian32(PP.FileChangeCounter)]
		)+#13+Format('DBSizePages : %d',[SwapEndian32(PP.DBSizePages)])+#13+Format('PN : %d',[SwapEndian32(PP.PN)])+#13+
		Format('TPN : %d',[SwapEndian32(PP.TPN)])+#13+Format('SchemaCookie : %d',[SwapEndian32(PP.SchemaCookie)])+#13+
		Format('SchemaFormatN : %d',[SwapEndian32(PP.SchemaFormatN)])+#13+Format('DCacheSize : %d',
		[SwapEndian32(PP.DCacheSize)])+#13+Format('Root : %d',[SwapEndian32(PP.Root)])+#13+Format('Encodig : %d',
		[SwapEndian32(PP.Encodig)])+#13+Format('UserVersion : %d',[SwapEndian32(PP.UserVersion)])+#13+
		Format('INVacuum : %d',[SwapEndian32(PP.INVacuum)])+#13+Format('APPID : %d',[SwapEndian32(PP.APPID)])+#13+
		Format('RESERVED : %s',[PP.RESERVED])+#13+Format('VVN : %d',[SwapEndian32(PP.VVN)])+#13+
		Format('SQLITE VERSION : %d',[SwapEndian32(PP.SQLITEV)]));
	STM._Release;
	O:='C:\Users\MICLE\Desktop\AAA.arnv';
	CN[12].Params.Database:=O;
	SHM:='ATTACH "'+O+'" AS "AD10";CREATE TABLE IF NOT EXISTS AD10.AZZ AS SELECT * FROM A3N29;DETACH "AD10";';
	CN[3].ExecSQL(SHM);
end;

procedure TAmdF.Button3click(Sender:TObject);

Begin
	Application.Terminate;
	ShellExecute(Handle,'open',Pchar(Application.Exename),nil,nil,SW_SHOWNORMAL);
end;

type
	TMyFileDialogEvents=class(TInterfacedObject,IFileDialogControlEvents) // IFileDialogEvents,
	public
		{ IFileDialogControlEvents }
		function OnItemSelected(const pfdc:IFileDialogCustomize;dwIDCtl:DWORD;dwIDItem:DWORD):HResult;stdcall;
		function OnButtonClicked(const pfdc:IFileDialogCustomize;dwIDCtl:DWORD):HResult;stdcall;
		function OnCheckButtonToggled(const pfdc:IFileDialogCustomize;dwIDCtl:DWORD;bChecked:BOOL):HResult;stdcall;
		function OnControlActivating(const pfdc:IFileDialogCustomize;dwIDCtl:DWORD):HResult;stdcall;
	end;

function TMyFileDialogEvents.OnItemSelected(const pfdc:IFileDialogCustomize;dwIDCtl:DWORD;dwIDItem:DWORD):HResult;
Begin
	Result:=S_OK;
	ShowMessage(dwIDCtl.ToString+#13+dwIDItem.ToString);
end;

function TMyFileDialogEvents.OnButtonClicked(const pfdc:IFileDialogCustomize;dwIDCtl:DWORD):HResult;
Begin
	if dwIDCtl>=1900 then Begin
		Result:=S_OK;
	end else Begin
		Result:=E_NOTIMPL;
	end;
	ShowMessage(dwIDCtl.ToString);
end;

function TMyFileDialogEvents.OnCheckButtonToggled(const pfdc:IFileDialogCustomize;dwIDCtl:DWORD;bChecked:BOOL):HResult;
Begin
	if (dwIDCtl>=1900) then Begin
		Result:=S_OK;
	end else Begin
		Result:=E_NOTIMPL;
	end;
	ShowMessage(dwIDCtl.ToString+#13+booltostr(bChecked));
end;

function TMyFileDialogEvents.OnControlActivating(const pfdc:IFileDialogCustomize;dwIDCtl:DWORD):HResult;
Begin
	ShowMessage(dwIDCtl.ToString);
	Result:=S_OK;
end;

var
	FileDialog:IFileDialog=nil;
	MyEvents:IFileDialogEvents=nil;
	MyEventsCookie:DWORD=0;
	C:IFileDialogCustomize;

procedure TAmdF.FileSaveDialog1Execute(Sender:TObject);
var
	FileDialog2:IFileDialog2;
	FileSaveDialog:IFileSaveDialog;
	ShellItem2:IShellItem2;
	PropertyStore:Winapi.Propsys.IPropertyStore;
	PDList:Winapi.Propsys.IPropertyDescriptionList;
Begin
	if Supports(TCustomFileDialog(Sender).Dialog,IFileDialogCustomize,C) then Begin
		// Add a Advanced Button
		C.AddMenu(1900,'A MENU');
		C.MakeProminent(1900);
		C.AddControlItem(1900,19001,'A11');
		C.AddControlItem(1900,19002,'A22');
		C.AddControlItem(1900,19003,'A33');
		C.MakeProminent(19001);
		C.MakeProminent(19002);
		C.MakeProminent(19003);
		C.SetSelectedControlItem(1900,19002);

		C.AddCheckButton(1901,'MY CHK',True);
		C.MakeProminent(1901);

		C.AddPushButton(1902,'Advanced');
		C.MakeProminent(1902);

		C.EnableOpenDropDown(1908);
		C.MakeProminent(1908);
		C.AddControlItem(1908,19081,'D1');
		C.AddControlItem(1908,19082,'D2');
		C.AddControlItem(1908,19083,'D3');
		C.MakeProminent(19081);
		C.MakeProminent(19082);
		C.MakeProminent(19083);
		C.SetSelectedControlItem(1908,19083);

		C.StartVisualGroup(1917,'GROP');

		C.AddRadioButtonList(1903);
		C.MakeProminent(1903);
		C.AddControlItem(1903,19031,'R1');
		C.AddControlItem(1903,19032,'R2');
		C.AddControlItem(1903,19033,'R3');
		C.MakeProminent(19031);
		C.MakeProminent(19032);
		C.MakeProminent(19033);
		C.SetSelectedControlItem(1903,19032);

		C.AddComboBox(1904);
		C.AddEditBox(1905,'EDTXT');
		C.AddSeparator(1906);
		C.AddText(1907,'MY TXT');
		C.MakeProminent(1904);
		C.MakeProminent(1905);
		C.MakeProminent(1906);
		C.MakeProminent(1907);

		C.AddControlItem(1904,19041,'A1');
		C.AddControlItem(1904,19042,'A2');
		C.AddControlItem(1904,19043,'A3');
		C.MakeProminent(19041);
		C.MakeProminent(19042);
		C.MakeProminent(19043);
		C.SetSelectedControlItem(1904,19043);

		C.EndVisualGroup;
		C.MakeProminent(1917);
	end;
	if Supports(TCustomFileDialog(Sender).Dialog,IFileDialog2,FileDialog2) then Begin
		FileDialog2.SetCancelButtonLabel('NO');
		{ SHCreateItemFromParsingName(PWideChar('C:\Users\MICLE\Desktop\DAS0.ainv'),nil,IShellItem2,ShellItem2);
			FileDialog2.SetNavigationRoot(ShellItem2);
			if Supports(TCustomFileDialog(Sender).Dialog,IFileSaveDialog,FileSaveDialog) then Begin
			FileSaveDialog.SetSaveAsItem(ShellItem2);
			ShellItem2.GetPropertyStore(GPS_READWRITE,IPropertyStore,PropertyStore);
			FileSaveDialog.SetProperties(PropertyStore);
			ShellItem2.GetPropertyDescriptionList(PKEY_PropList_PreviewTitle,IPropertyDescriptionList,PDList);
			FileSaveDialog.SetCollectedProperties(PDList,true);
			end; }
	end;
end;

procedure TAmdF.FileSaveDialog1Overwrite(Sender:TObject;var Response:TFileDialogOverwriteResponse);
Begin
	Response:=TFileDialogOverwriteResponse(1);
end;

procedure TAmdF.FileSaveDialog1SelectionChange(Sender:TObject);
var
	FileDialog2:IFileDialog2;
	FileSaveDialog:IFileSaveDialog;
	ShellItem2:IShellItem2;
	ShellItem1:IShellItem;
	PropertyStore,PO:Winapi.Propsys.IPropertyStore;
	PDList:Winapi.Propsys.IPropertyDescriptionList;
Begin
	if Supports(TCustomFileDialog(Sender).Dialog,IFileDialog2,FileDialog2) then Begin
		FileDialog2.GetCurrentSelection(ShellItem1);
		ShellItem1.QueryInterface(IShellItem2,ShellItem2);
		if Supports(TCustomFileDialog(Sender).Dialog,IFileSaveDialog,FileSaveDialog) then Begin
			ShellItem2.GetPropertyStore(GPS_READWRITE,IPropertyStore,PropertyStore);
			FileSaveDialog.SetProperties(PropertyStore);
			ShellItem2.GetPropertyDescriptionList(PKEY_PropList_PreviewTitle,IPropertyDescriptionList,PDList);
			FileSaveDialog.SetCollectedProperties(PDList,True);
			OleCheck(FileSaveDialog.ApplyProperties(ShellItem2,PropertyStore,FileSaveDialog1.Handle,nil));
			OleCheck(FileSaveDialog.GetProperties(PO));
		end;
	end;
end;

procedure TAmdF.Button40Click(Sender:TObject);
var
	Ok:Boolean;
	dwIDCtl,dwIDItem:DWORD;
Begin
	// FileDialog:=nil;
	MyEvents:=nil;
	// MyEventsCookie:=0;
	try Ok:=FileSaveDialog1.Execute(Button40.Handle);
	finally
		if (FileDialog<>nil)and(MyEventsCookie<>0) then FileDialog.Unadvise(MyEventsCookie);
		C.GetSelectedControlItem(1908,dwIDItem);
		ShowMessage(dwIDItem.ToString);
		FileDialog:=nil;
		MyEvents:=nil;
		MyEventsCookie:=0;
	end;
	// if Ok then
end;

procedure TAmdF.Button41Click(Sender:TObject);
var
	r,SS,OO,O:string;
	STM:IStream;
	statstg:TStatStg;
	Total,f,i:integer;
	AA:TFileHeader;
	PP,dd:Pchar;
	SZ,PH:UInt64;
	ST:TStringStream;
	XmlDoc1:IXMLDOMDocument2;
	eDestination,el:IXmlDomElement;
	nDestination:IXmlDomNode;
	QS:AnsiString;
Begin
	with TOpenDialog.Create(nil) do Begin
		Options:=Options+[ofAllowMultiSelect];
		Execute;
		for i:=0 to Files.Count-1 do Begin
			SHCreateStreamOnFileEx(Pchar(Files[i]),STGM_READWRITE or STGM_SHARE_EXCLUSIVE,0,False,nil,STM);

			STM.Stat(statstg,STATFLAG_NONAME);
			Total:=statstg.cbSize;
			STM.Seek(0,STREAM_SEEK_SET,PUINT64(nil)^);

			f:=sizeof(TFileHeader);
			STM.Read(@AA,f,@f);
			SZ:=AA.FContentSize;

			STM.Seek(0,STREAM_SEEK_SET,PUINT64(nil)^);
			STM.SetSize(SZ);
			STM.Commit(STGC_DEFAULT);

			STM.Seek(0,STREAM_SEEK_SET,PUINT64(nil)^);
			f:=0;
			SetLength(QS,16);
			QS:='SQLite format 3';
			STM.Write(pansichar('SQLite format 3'+#0),16,@f);
			STM.Commit(STGC_DEFAULT);
			STM._Release;
		end;
		Free;
	end;
end;

procedure TAmdF.zp(Sender:TObject;FileName:string;Header:TZipHeader;Position:Int64);
	function bts(ar:TBytes;SZ:integer):AnsiString;
	Begin
		Result:=TENCODING.UTF8.GetString(ar, Low(ar), High(ar)+1);
	end;

var
	Zip:TZipFile;
	S:string;
Begin
	Application.Processmessages;
	Zip:=TZipFile(Sender);
	S:=bts(Header.FileName,Header.FileNameLength);
	ProgressBar1.Position:=Trunc(Zip.FileCount/(filc*0.01));
	Taskbar1.ProgressValue:=ProgressBar1.Position;
	ProgressBar1.Position:=Trunc(Position/(Header.UncompressedSize*0.01));
	RichEdit.Lines[0]:=Format('MadeByVersion = %d',[Header.MadeByVersion]);
	RichEdit.Lines[1]:=Format('RequiredVersion = %d',[Header.RequiredVersion]);
	RichEdit.Lines[2]:=Format('Flag = %d',[Header.Flag]);
	RichEdit.Lines[3]:=Format('CompressionMethod = %d',[Header.CompressionMethod]);
	RichEdit.Lines[4]:=Format('ModifiedDateTime = %d',[Header.ModifiedDateTime]);
	RichEdit.Lines[5]:=Format('CRC32 = %d',[Header.CRC32]);
	RichEdit.Lines[6]:=Format('CompressedSize = %d',[Header.CompressedSize]);
	RichEdit.Lines[7]:=Format('UncompressedSize = %d',[Header.UncompressedSize]);
	RichEdit.Lines[8]:=Format('FileNameLength = %d',[Header.FileNameLength]);
	RichEdit.Lines[9]:=Format('ExtraFieldLength = %d',[Header.ExtraFieldLength]);
	RichEdit.Lines[10]:=Format('FileCommentLength = %d',[Header.FileCommentLength]);
	RichEdit.Lines[11]:=Format('DiskNumberStart = %d',[Header.DiskNumberStart]);
	RichEdit.Lines[12]:=Format('InternalAttributes = %d',[Header.InternalAttributes]);
	RichEdit.Lines[13]:=Format('ExternalAttributes = %d',[Header.ExternalAttributes]);
	RichEdit.Lines[14]:=Format('LocalHeaderOffset = %d',[Header.LocalHeaderOffset]);
	RichEdit.Lines[15]:=Format('FileName = %s',[S]);
	RichEdit.Lines[16]:=Format('ExtraField = %s',[bts(Header.ExtraField,Header.ExtraFieldLength)]);
	RichEdit.Lines[17]:=Format('FileComment = %s',[bts(Header.FileComment,Header.FileCommentLength)]);
	RichEdit.Lines[18]:=Format('CompressionMethod = %d',[(Header.UTF8Support).ToInteger]);
	RichEdit.Lines[19]:=Format('Position1 = %d',[ProgressBar1.Position]);
	RichEdit.Lines[20]:=Format('Position2 = %d',[ProgressBar1.Position]);
end;

function TAmdF.ZipFile(FileName,ArchiveName:string):Boolean;
var
	Zip:TZipFile;
	LFiles:TStringDynArray;

Begin
	Zip:=TZipFile.Create;
	try
		if FileExists(ArchiveName) then DeleteFile(ArchiveName);
		ProgressBar1.Position:=0;
		ProgressBar1.Position:=0;
		Taskbar1.ProgressValue:=0;
		Taskbar1.Progressstate:=Ttaskbarprogressstate(2);
		if (GetFileAttributes(Pchar(FileName))and FILE_ATTRIBUTE_DIRECTORY<>0) then Begin
			LFiles:=TDirectory.GetFiles(FileName,'*',TSearchOption.soAllDirectories);
			filc:=High(LFiles);
			Zip.ZipDirectoryContents(ArchiveName,FileName,zcDeflate,zp); // ,zcDeflate,zp
		end else Begin
			Zip.Open(ArchiveName,zmWrite);
			Zip.add(FileName);
			Zip.Close;
		end;
		Result:=True;
	except Result:=False;
	end;
	FreeAndNil(Zip);
end;

procedure TAmdF.zp1(Sender:TObject;FileName:string;Header:TZipHeader;Position:Int64);
	function bts(ar:TBytes;SZ:integer):AnsiString;
	Begin
		Result:=TENCODING.UTF8.GetString(ar, Low(ar), High(ar)+1);
	end;

var
	Zip:TZipFile;
	S:string;
Begin
	Application.Processmessages;
	Zip:=TZipFile(Sender);
	S:=bts(Header.FileName,Header.FileNameLength);
	ProgressBar1.Position:=Trunc(Zip.IndexOf(S)/(Zip.FileCount*0.01));
	Taskbar1.ProgressValue:=ProgressBar1.Position;
	ProgressBar1.Position:=Trunc(Position/(Header.UncompressedSize*0.01));
	RichEdit.Lines[0]:=Format('MadeByVersion = %d',[Header.MadeByVersion]);
	RichEdit.Lines[1]:=Format('RequiredVersion = %d',[Header.RequiredVersion]);
	RichEdit.Lines[2]:=Format('Flag = %d',[Header.Flag]);
	RichEdit.Lines[3]:=Format('CompressionMethod = %d',[Header.CompressionMethod]);
	RichEdit.Lines[4]:=Format('ModifiedDateTime = %d',[Header.ModifiedDateTime]);
	RichEdit.Lines[5]:=Format('CRC32 = %d',[Header.CRC32]);
	RichEdit.Lines[6]:=Format('CompressedSize = %d',[Header.CompressedSize]);
	RichEdit.Lines[7]:=Format('UncompressedSize = %d',[Header.UncompressedSize]);
	RichEdit.Lines[8]:=Format('FileNameLength = %d',[Header.FileNameLength]);
	RichEdit.Lines[9]:=Format('ExtraFieldLength = %d',[Header.ExtraFieldLength]);
	RichEdit.Lines[10]:=Format('FileCommentLength = %d',[Header.FileCommentLength]);
	RichEdit.Lines[11]:=Format('DiskNumberStart = %d',[Header.DiskNumberStart]);
	RichEdit.Lines[12]:=Format('InternalAttributes = %d',[Header.InternalAttributes]);
	RichEdit.Lines[13]:=Format('ExternalAttributes = %d',[Header.ExternalAttributes]);
	RichEdit.Lines[14]:=Format('LocalHeaderOffset = %d',[Header.LocalHeaderOffset]);
	RichEdit.Lines[15]:=Format('FileName = %s',[S]);
	RichEdit.Lines[16]:=Format('ExtraField = %s',[bts(Header.ExtraField,Header.ExtraFieldLength)]);
	RichEdit.Lines[17]:=Format('FileComment = %s',[bts(Header.FileComment,Header.FileCommentLength)]);
	RichEdit.Lines[18]:=Format('CompressionMethod = %d',[(Header.UTF8Support).ToInteger]);
	RichEdit.Lines[19]:=Format('Position1 = %d',[ProgressBar1.Position]);
	RichEdit.Lines[20]:=Format('Position2 = %d',[ProgressBar1.Position]);
end;

function TAmdF.UnZipFile(ArchiveName,Path:string):Boolean;
var
	Zip:TZipFile;
Begin
	Zip:=TZipFile.Create;
	ProgressBar1.Position:=0;
	ProgressBar1.Position:=0;
	Taskbar1.ProgressValue:=0;
	Taskbar1.Progressstate:=Ttaskbarprogressstate(2);
	try
		Zip.OnProgress:=zp1;
		Zip.Open(ArchiveName,zmRead);
		Zip.ExtractAll(Path);
		// Zip.Extract('pp/dd.bmp','C:\Users\MICLE\Desktop',False);
		Zip.Close;
		Result:=True;
	except Result:=False;
	end;
	Zip.Free;
end;

procedure TAmdF.Button42Click(Sender:TObject);
var
	ER:Pchar;
	SD,CD:string;
	FS:IFileIsInUse;
	Usage:integer;
	Ca:Cardinal;
	RES:HResult;
Begin

	{ RegisterFileIsInUse('C:\Users\MICLE\Desktop\DAS1.arnv');
		Exit;
		FQ[3].Open('SELECT * FROM A3n12');
		FQ[3].RecNo:=6;
		FQ[3].Edit;
		FQ[3].Fields[1].AsString:='dfdg';
		ShowMessage(FQ[3].Fields[1].AsString); }
	FS:=GetFileInUseInfo('C:\Users\MICLE\Desktop\DAS1.arnv');
	if Assigned(FS) then begin
		FS.GetAppName(ER);
		FS.GetUsage(Usage);
		FS.GetCapabilities(Ca);
		RES:=FS.CloseFile;
		case Usage of
			0:SD:='FUT_PLAYING';
			1:SD:='FUT_EDITING';
			2:SD:='FUT_GENERIC';
		end;
		case Usage of
			1:CD:='OF_CAP_CANSWITCHTO';
			2:CD:='OF_CAP_CANCLOSE';
			3:CD:='OF_CAP_CANSWITCHTO AND OF_CAP_CANCLOSE';
		end;
		ShowMessage(ER+#13+SD+#13+CD+#13+integer(RES).ToString);
	end
	else RegisterFileIsInUse('C:\Users\MICLE\Desktop\DAS1.arnv');
	/// ZipFile('C:\Users\MICLE\Desktop\AMDZ','C:\Users\MICLE\Desktop\aa.zip');
end;

procedure TAmdF.Button43Click(Sender:TObject);
var
	ER:Pchar;
	SD,CD:string;
	FS:IFileIsInUse;
	Usage:integer;
	Ca:Cardinal;
	RES:HResult;
	CW:ICurrentWorkingDirectory;
	rr:Pchar;
	dd:TMemoryStream;
Begin
	// FQ[3].LoadFromFile('C:\Users\MICLE\Desktop\aa.aams',sfBinary);
	dd:=TMemoryStream.Create;
	FQ[3].Open('SELECT * FROM A3N29');
	FQ[3].SaveToStream(dd,sfBinary);
	FQ[3].SaveToStream(dd,sfBinary);
	ShowMessage('1');
	dd.SaveToFile('C:\Users\MICLE\Desktop\aa.aams');
	ShowMessage('2');
	dd.Free;
	// FQ[3].SaveToFile('C:\Users\MICLE\Desktop\aa.aams',sfBinary);
	// FQ[3].SaveToFile('C:\Users\MICLE\Desktop\aa.aams',sfBinary);
	// FQ[3].SaveToFile('C:\Users\MICLE\Desktop\aa.aams',sfBinary);
	{ FS:=GetFileInUseInfo('C:\Users\MICLE\Desktop\aa.zip');
		if Assigned(FS) then begin
		FS.GetAppName(ER);
		FS.GetUsage(Usage);
		FS.GetCapabilities(Ca);
		RES:=FS.CloseFile;
		case Usage of
		0:SD:='FUT_PLAYING';
		1:SD:='FUT_EDITING';
		2:SD:='FUT_GENERIC';
		end;
		case Usage of
		1:CD:='OF_CAP_CANSWITCHTO';
		2:CD:='OF_CAP_CANCLOSE';
		3:CD:='OF_CAP_CANSWITCHTO AND OF_CAP_CANCLOSE';
		end;
		ShowMessage(ER+#13+SD+#13+CD+#13+Integer(RES).Tostring);
		end;
		// UNRegisterFileIsInUse('C:\Users\MICLE\Desktop\aa.zip'); }
	UnZipFile('C:\Users\MICLE\Desktop\AQW.docx','C:\Users\MICLE\Desktop\bb');
end;

function TAmdF.ReadOutFile(FileName:string;TEMPINDEX:integer):Boolean;
var
	SS,TST1,TRFC1,TmpFile:string;
	STM,SMCNT:IStream;
	statstg:TStatStg;
	Total,f,Count,INV:integer;
	QQ:TFileHeader;
	AF:TFileFooter;
	AC:TDocmHeader;
	PP,dd:Pointer;
	SZ,PH,PZ:UInt64;
	RD,Wr:UInt64;
	SQL: array [0..15] of byte;
	CNN:TFDConnection;
	FDD:TFDQuery;
Begin
	IF NOT FileExists(FileName) THEN EXIT;
	SHCreateStreamOnFileEx(Pchar(FileName),STGM_READWRITE,0,False,nil,STM);
	STM.Stat(statstg,STATFLAG_NONAME);
	Total:=statstg.cbSize;
	STM.Seek(0,STREAM_SEEK_SET,PUINT64(nil)^);
	// READ HEADER
	f:=sizeof(TFileHeader);
	STM.Read(@QQ,f,@f);
	STM.Seek(QQ.FContentSPos+sizeof(UInt64),STREAM_SEEK_SET,PUINT64(nil)^);
	f:=sizeof(TDocmHeader);
	STM.Read(@AC,f,@f);
	STM.Seek(sizeof(UInt64),STREAM_SEEK_CUR,PUINT64(nil)^);
	SZ:=AC.FContentSize;
	// COPY TEMP FILE   or STGM_SHARE_EXCLUSIVE
	TmpFile:='C:\Users\MICLE\Desktop\'+ExtractFileName(FileName)+'.content';
	SHCreateStreamOnFileEx(Pchar(TmpFile),STGM_CREATE or STGM_READWRITE,0,True,nil,SMCNT);
	STM.CopyTo(SMCNT,SZ,RD,Wr);
	SMCNT.Seek(0,STREAM_SEEK_SET,PUINT64(nil)^);
	f:=0;
	SMCNT.Write(pansichar('SQLite format 3'),16,@f);
	SMCNT.Commit(STGC_DEFAULT);
	// SMCNT._Release;
	// STM._Release;
	CNN:=TFDConnection.Create(Amdf);
	FDD:=TFDQuery.Create(Amdf);
	PrepareConnection(CNN,FDD,TmpFile);

	TST1:=IntToStr(CNN.ExecSQLScalar('SELECT ST FROM ATT LIMIT 1'));
	TRFC1:=IntToStr(CNN.ExecSQLScalar('SELECT RFC FROM ATT LIMIT 1'));
	INV:=CNN.ExecSQLScalar('SELECT NUM FROM ATT LIMIT 1');
	TSGA.Create(Self,INV,TRFC1,TST1,Sfr1(21),4,0,CNN,FDD,TmpFile);
	Result:=True;
end;

procedure TAmdF.prog(Sender:TObject;Count,MaxCount:integer;COMMENT:string);
begin
	T2:=T2+1;
	// caption:=Count.ToString+','+MaxCount.ToString;
	Caption:=COMMENT+' , '+ProgressBar3.Position.ToString+','+MaxCount.ToString;
	ProgressBar3.Max:=MaxCount;
	ProgressBar3.Min:=Count;
	ProgressBar3.Position:=ProgressBar3.Position+Count;
	Application.Processmessages;
end;

procedure TAmdF.CONC(ADB:TSQLiteDatabase;var ACancel:Boolean);
VAR
	Cr,WT,RS:integer;
begin
	T3:=T3+1;
	Caption:='PREPARING  '+T3.ToString;
	Application.Processmessages;
end;

function GetFileISTM(CON:TFDConnection;Index:integer;var filesize:UInt64;RFC,ST,INVNUM,exti:string;
	strem:Boolean=False):IStream;
	procedure reserv(var strm:IStream;code:UInt64);
	var
		f:UInt64;
	begin
		f:=0;
		strm.Write(@f,sizeof(UInt64),@f);
		f:=0;
		strm.Write(@code,sizeof(UInt64),@f);
		f:=0;
		strm.Write(@f,sizeof(UInt64),@f);
	end;

var
	Table,Moth1,r,O,SHM,pass:string;
	SM:IStream;
	i,J:integer;
	f,RD,WT:UInt64;
	CZ,TZ,PZ,SRV,Total,nr,nw:UInt64;
	AA:TFileHeader;
	AF:TFileFooter;
	AC:TDocmHeader;
	MK:TMemoryStream;
	statstg:TStatStg;
	STT:TStringStream;
	BMP:TBITMAP;
	DE:HRD6;
	FS:TFileStream;
	FDataSet:TFDDataSet;
	FField:TField;
	oRow:TFDDatSRow;
	Pdata:Pointer;
	iLen:Longword;
	iColIndex:integer;
	ER:PCWSTR;
Begin
	// Application.Minimize;
	Result:=nil;
	Moth1:=Dtm1(RFC);
	Table:=Dtk1(RFC)+ST+'N'+INVNUM;
	iColIndex:=CON.ExecSQLScalar('SELECT COUNT(name) FROM sqlite_master WHERE type="table" AND name="'+Table+'"');
	// ShowMessage(iColIndex.ToString);
	IF (iColIndex=0) THEN EXIT;
	O:='C:\Users\MICLE\Desktop\AAA.ram'; // ':memory:';
	if strem then
		with TSaveDialog.Create(Application) do begin
			FileName:=Dtl1(RFC)+INVNUM;
			FILTER:=Dtl1(RFC)+' (*.'+exti+')|*.'+exti;
			DefaultExt:='.'+exti;
			IF not Execute THEN begin
				Free;
				EXIT;
			END;
			r:=FileName;
			Free;
		end
	else r:='C:\Users\MICLE\Desktop\'+INVNUM+'.tmp';
	CN[10].Params.Database:=O;
	CN[10].Connected:=True;
	TSQLiteDatabase(CON.ConnectionIntf.CliObj).ProgressNOpers:=1000;
	TSQLiteDatabase(CON.ConnectionIntf.CliObj).OnProgress:=Amdf.CONC;
	SHM:='ATTACH "'+O+'" AS "AD10";'+
		'CREATE TABLE IF NOT EXISTS AD10.ATT(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT ,TNM TEXT DEFAULT "",'+
		'CPY  NUMERIC NULL,ST  NUMERIC NULL,RFC  NUMERIC NULL,MH  TEXT DEFAULT "",EXT  TEXT DEFAULT "",NUM  NUMERIC NULL,PSS  TEXT DEFAULT "");'
		+'INSERT INTO AD10.ATT (TNM,CPY,ST,RFC,MH,EXT,NUM,PSS)VALUES("'+Table+'","1","'+ST+'","'+RFC+'","'+Moth1+'","'+exti+
		'","'+INVNUM+'","MMMM");'+'CREATE TABLE IF NOT EXISTS AD10.'+Moth1+' AS SELECT * FROM '+Moth1+' WHERE ST = "'+ST+
		'" AND ICODE="'+INVNUM+'";'+'CREATE TABLE IF NOT EXISTS AD10.'+Table+' AS SELECT * FROM '+Table+';DETACH "AD10";';
	CON.ExecSQL(SHM);
	CN[10].Close;
	pass:=CON.ExecSQLScalar('SELECT SEC FROM '+Moth1+' WHERE ST = "'+ST+'" AND ICODE="'+INVNUM+'";');
	// pass:='D41D8CD98F00B204E9800998ECF8427E';
	{ Amdf.FDSQLiteBackup1.Database:=O;
		Amdf.FDSQLiteBackup1.DestDatabase:='C:\Users\MICLE\Desktop\AAA00.arnv';
		Amdf.FDSQLiteBackup1.Backup; }
	SHCreateStreamOnFileEx(Pchar(O),STGM_READWRITE,0,False,nil,SM);
	SM.Seek(0,STREAM_SEEK_SET,PUINT64(nil)^);
	f:=0;
	SM.Write(pansichar('000000000000000'),16,@f);
	SM.Commit(STGC_DEFAULT);
	FS:=TFileStream.Create(r,Fmcreate);
	Result:=TFixedStreamAdapter.Create(FS,soOwned);
	TFixedStreamAdapter(Result).OnProgress:=Amdf.prog;
	TFixedStreamAdapter(Result).FileName:=r;
	// SHCreateStreamOnFileEx(Pchar(r),STGM_CREATE or STGM_READWRITE or STGM_SHARE_EXCLUSIVE,0,true,nil,Result);
	// START
	Result.Seek(0,STREAM_SEEK_SET,PUINT64(nil)^);
	// WRITE EMPTY FILEHEADER
	FillChar(AA,sizeof(TFileHeader),0);
	f:=0;
	Result.Write(@AA,sizeof(TFileHeader),@f);
	// RESERVED
	reserv(Result,361984);
	// WRITE CONTENT
	Result.Seek(0,STREAM_SEEK_CUR,AA.FContentSPos);
	f:=0;
	Result.Write(@f,sizeof(UInt64),@f);
	// WRITE EMPTY DOCHEADER
	FillChar(AC,sizeof(TDocmHeader),0);
	Result.Seek(0,STREAM_SEEK_CUR,AC.FStartPos);
	f:=0;
	Result.Write(@AC,sizeof(TDocmHeader),@f);
	Result.Seek(0,STREAM_SEEK_CUR,AC.FEndPos);
	f:=0;
	Result.Write(@f,sizeof(UInt64),@f);
	Result.Seek(0,STREAM_SEEK_CUR,AC.FContentSPos);
	SM.Stat(statstg,STATFLAG_NONAME);
	AC.FContentSize:=statstg.cbSize;
	SM.Seek(0,STREAM_SEEK_SET,PUINT64(nil)^);
	TFixedStreamAdapter(Result).WriteMAX:=AC.FContentSize;
	SM.CopyTo(Result,AC.FContentSize,RD,WT);
	TFixedStreamAdapter(Result).WriteMAX:=0;
	Result.Seek(0,STREAM_SEEK_CUR,AC.FContentEPos);
	f:=0;
	Result.Write(@f,sizeof(UInt64),@f);
	Result.Seek(0,STREAM_SEEK_CUR,AA.FContentEPos);
	// WRITE DOCHEADER
	Move(C_Magic[0],AC.FMagic[0],6);
	Move(DE[0],AC.FExt[0],6);
	Move(TENCODING.UTF8.GetBytes(pass)[0],AC.FPass[0],32);
	AC.FVersion:=15;
	AC.FCOU:=1;
	AC.FNUM:=0; //
	AC.FCPY:=3; //
	AC.FUser:=3; //
	AC.FNextPos:=0; //
	Result.Seek(AC.FStartPos,STREAM_SEEK_SET,PUINT64(nil)^);
	f:=0;
	Result.Write(@AC,sizeof(TDocmHeader),@f);
	Result.Seek(AA.FContentEPos,STREAM_SEEK_SET,PUINT64(nil)^);
	// RESERVED
	reserv(Result,361985);
	// WRITE THUMB
	FQ[11].Open('SELECT THU FROM STHUM WHERE ICODE='+INVNUM+' AND RFC='+RFC+' LIMIT 1');
	MK:=FQ[11].CreateBlobStream(FQ[11].FieldByName('THU'),bmRead) as TMemoryStream;
	{ FField:=FQ[11].FieldByName('THU');
		FDataSet:=FField.Dataset as TFDDataSet;
		oRow:=FDataSet.GetRow(0,true);
		oRow.GetData(iColIndex,rvDefault,Pdata,0,iLen,false);
		TZ:=iLen;
		f:=0;
		Result.Write(@TZ,SizeOf(UInt64),@f);
		Result.Seek(0,STREAM_SEEK_CUR,AA.FTumbsPos);
		AA.FTumbSize:=iLen;
		f:=0;
		Result.Write(Pdata,iLen,@f);
		Result.Seek(0,STREAM_SEEK_CUR,AA.FTumbEPos);
		Pdata:=nil; }
	// MK.SaveToFile('C:\Users\MICLE\Desktop\'+INVNUM+'.bmp');
	TZ:=MK.Size;
	f:=0;
	Result.Write(@TZ,sizeof(UInt64),@f);
	Result.Seek(0,STREAM_SEEK_CUR,AA.FTumbsPos);
	AA.FTumbSize:=MK.Size;
	f:=0;
	MK.Position:=0;
	Result.Write(TFDBlobStream(MK).Memory,MK.Size,@f);
	Result.Seek(0,STREAM_SEEK_CUR,AA.FTumbEPos);
	MK.Free;
	// RESERVED
	reserv(Result,361986);
	// WRITE PROPERTIES
	STT:=TStringStream.Create(CPROP(exti),TENCODING.UTF8);
	PZ:=STT.Size;
	DE:=FOT(exti);
	f:=0;
	Result.Write(@PZ,sizeof(UInt64),@f);
	Result.Seek(0,STREAM_SEEK_CUR,AA.FPropSPos);
	AA.FPropSize:=STT.Size;
	f:=0;
	STT.Position:=0;
	Result.Write(STT.Memory,PZ,@f);
	Result.Seek(0,STREAM_SEEK_CUR,AA.FPropEPos);
	STT.Free;
	// RESERVED
	reserv(Result,361987);
	Result.Seek(0,STREAM_SEEK_CUR,AA.FFooterPos);
	// WRITE HEADER
	Move(AMD_HD[0],AA.FHeader[0],6);
	Move(DE[0],AA.FExt[0],6);
	Move(TENCODING.UTF8.GetBytes(pass)[0],AA.FPass[0],32);
	AA.FVersion:=15;
	AA.FCount:=1;
	AA.thumb:=1;
	AA.Prop:=1;
	AA.FContentSize:=AA.FContentEPos-AA.FContentSPos;
	FillChar(AF,sizeof(TFileFooter),0);
	Move(AMD_FO[0],AF.FFooter[0],6);
	Move(TENCODING.UTF8.GetBytes(pass)[0],AF.FPass[0],32);
	Move(DE[0],AF.FExt[0],6);
	AF.FVersion:=15;
	AF.FCount:=1;
	AF.thumb:=1;
	AF.Prop:=1;
	AF.FContentSPos:=AA.FContentSPos;
	AF.FContentSize:=AA.FContentSize;
	AF.FContentEPos:=AA.FContentEPos;
	AF.FTumbsPos:=AA.FTumbsPos;
	AF.FTumbSize:=AA.FTumbSize;
	AF.FTumbEPos:=AA.FTumbEPos;
	AF.FPropSPos:=AA.FPropSPos;
	AF.FPropSize:=AA.FPropSize;
	AF.FPropEPos:=AA.FPropEPos;
	Result.Seek(0,STREAM_SEEK_CUR,AA.FFooterPos);
	// WRITE FOOTER
	f:=0;
	Result.Write(@AF,sizeof(TFileFooter),@f);
	Result.Seek(0,STREAM_SEEK_SET,PUINT64(nil)^);
	f:=0;
	Result.Write(@AA,sizeof(TFileFooter),@f);
	Result.Seek(0,STREAM_SEEK_END,filesize);

	Result.Commit(STGC_DEFAULT);
	Result.Seek(0,STREAM_SEEK_SET,PUINT64(nil)^);
	SM._Release;
	SM:=NIL;
	DeleteFile(O);
end;

procedure TAmdF.Button46Click(Sender:TObject);
const
	FF=$53505331;
	sss=$1011;
var
	pNodeParent,ND:IXmlDomNode;
	el:IXmlDomElement;
	PV,pk:TPROPVARIANT;
	pkey:TPropertyKey;
	CO,i,KN,ns,vs:integer;
	KY,TX,TX1:string;
	RES:HResult;
	pstm,sst:IStream;
	psps:IPersistSerializedPropStorage;
	pPersistStream:IPersistStream;
	StaStg:TStatStg;
	PP:Pchar;
	f:FixedUInt;
	HG:Hglobal;
	dd:TSerializedPropStorage;
	rr:TGUID;
	x:DWORD;
	PS:IPropertyStoreCache;
	S,L:string;
	ww:byte;
	fg:tagPROPSPEC;
	ST:TStringStream;
	EE:UInt64;
	W:Word;
Begin
	if FileExists('C:\Users\MICLE\Desktop\AZZ.amd') then Begin
		SHCreateStreamOnFileEx(Pchar('C:\Users\MICLE\Desktop\AZZ.amd'),STGM_READWRITE,0,False,nil,pstm);
	end;

	pstm.Seek(0,STREAM_SEEK_SET,PUINT64(nil)^);
	pstm.Stat(StaStg,STATFLAG_NONAME);

	S:='';
	f:=4;
	pstm.Read(@CO,f,@f);
	S:=S+CO.ToString+#13;

	f:=4;
	pstm.Read(@CO,f,@f);
	S:=S+CO.ToString+#13;

	f:=16;
	pstm.Read(@rr,f,@f);
	S:=S+rr.ToString+#13;

	f:=4;
	pstm.Read(@vs,f,@f);
	S:=S+vs.ToString+#13;

	f:=4;
	pstm.Read(@ns,f,@f);
	S:=S+ns.ToString+#13;

	f:=1;
	pstm.Read(@ww,f,@f);
	S:=S+ww.ToString+#13;

	f:=2;
	pstm.Read(@W,f,@f);
	S:=S+W.ToString+#13;
	f:=2;
	pstm.Read(@W,f,@f);
	S:=S+W.ToString+#13;

	f:=2;
	pstm.Read(@W,f,@f);
	S:=S+W.ToString+#13;
	f:=2;
	pstm.Read(@W,f,@f);
	S:=S+W.ToString+#13;

	f:=vs;
	PP:=CoTaskMemAlloc(f);
	pstm.Read(PP,f,@f);
	S:=S+widechartostring(PP)+#13;
	CoTaskMemFree(PP);

	f:=4;
	pstm.Read(@CO,f,@f);
	S:=S+CO.ToString+#13;

	f:=4;
	pstm.Read(@CO,f,@f);
	S:=S+CO.ToString+#13;

	f:=4;
	pstm.Read(@vs,f,@f);
	S:=S+vs.ToString+#13;

	f:=16;
	pstm.Read(@rr,f,@f);
	S:=S+rr.ToString+#13;

	f:=4;
	pstm.Read(@vs,f,@f);
	S:=S+vs.ToString+#13;

	f:=4;
	pstm.Read(@ns,f,@f);
	S:=S+ns.ToString+#13;

	f:=1;
	pstm.Read(@ww,f,@f);
	S:=S+ww.ToString+#13;

	f:=2;
	pstm.Read(@W,f,@f);
	S:=S+W.ToString+#13;
	f:=2;
	pstm.Read(@W,f,@f);
	S:=S+W.ToString+#13;

	f:=4;
	pstm.Read(@CO,f,@f);
	S:=S+CO.ToString+#13;

	f:=4;
	pstm.Read(@CO,f,@f);
	S:=S+CO.ToString+#13;

	f:=4;
	pstm.Read(@CO,f,@f);
	S:=S+CO.ToString+#13;

	f:=4;
	pstm.Read(@CO,f,@f);
	S:=S+CO.ToString+#13;

	f:=16;
	pstm.Read(@rr,f,@f);
	S:=S+rr.ToString+#13;

	f:=4;
	pstm.Read(@CO,f,@f);
	S:=S+CO.ToString+#13;

	f:=4;
	pstm.Read(@CO,f,@f);
	S:=S+CO.ToString+#13;

	f:=1;
	pstm.Read(@ww,f,@f);
	S:=S+ww.ToString+#13;

	f:=2;
	pstm.Read(@W,f,@f);
	S:=S+W.ToString+#13;
	f:=2;
	pstm.Read(@W,f,@f);
	S:=S+W.ToString+#13;

	f:=2;
	pstm.Read(@W,f,@f);
	S:=S+W.ToString+#13;
	f:=2;
	pstm.Read(@W,f,@f);
	S:=S+W.ToString+#13;

	f:=4;
	pstm.Read(@CO,f,@f);
	S:=S+CO.ToString+#13;

	f:=4;
	pstm.Read(@CO,f,@f);
	S:=S+CO.ToString+#13;

	f:=16;
	pstm.Read(@rr,f,@f);
	S:=S+rr.ToString+#13;

	f:=4;
	pstm.Read(@CO,f,@f);
	S:=S+CO.ToString+#13;

	f:=4;
	pstm.Read(@CO,f,@f);
	S:=S+CO.ToString+#13;

	f:=1;
	pstm.Read(@ww,f,@f);
	S:=S+ww.ToString+#13;

	f:=2;
	pstm.Read(@W,f,@f);
	S:=S+W.ToString+#13;
	f:=2;
	pstm.Read(@W,f,@f);
	S:=S+W.ToString+#13;

	f:=2;
	pstm.Read(@W,f,@f);
	S:=S+W.ToString+#13;
	f:=2;
	pstm.Read(@W,f,@f);
	S:=S+W.ToString+#13;

	f:=168;
	PP:=CoTaskMemAlloc(f);
	pstm.Read(PP,f,@f);
	S:=S+widechartostring(PP)+#13;
	CoTaskMemFree(PP);
	//
	f:=4;
	pstm.Read(@CO,f,@f);
	S:=S+CO.ToString+#13;

	f:=4;
	pstm.Read(@CO,f,@f);
	S:=S+CO.ToString+#13;

	f:=1;
	pstm.Read(@ww,f,@f);
	S:=S+ww.ToString+#13;

	f:=4;
	pstm.Read(@CO,f,@f);
	S:=S+CO.ToString+#13;

	f:=4;
	pstm.Read(@CO,f,@f);
	S:=S+CO.ToString+#13;

	f:=4;
	pstm.Read(@CO,f,@f);
	S:=S+CO.ToString+#13;

	f:=4;
	PP:=CoTaskMemAlloc(f);
	pstm.Read(PP,f,@f);
	S:=S+widechartostring(PP)+#13;
	CoTaskMemFree(PP);
	//
	f:=4;
	pstm.Read(@CO,f,@f);
	S:=S+CO.ToString+#13;

	f:=4;
	pstm.Read(@CO,f,@f);
	S:=S+CO.ToString+#13;

	f:=1;
	pstm.Read(@ww,f,@f);
	S:=S+ww.ToString+#13;

	f:=4;
	pstm.Read(@CO,f,@f);
	S:=S+CO.ToString+#13;

	f:=4;
	pstm.Read(@CO,f,@f);
	S:=S+CO.ToString+#13;

	f:=4;
	pstm.Read(@CO,f,@f);
	S:=S+CO.ToString+#13;

	f:=12;
	PP:=CoTaskMemAlloc(f);
	pstm.Read(PP,f,@f);
	S:=S+widechartostring(PP)+#13;
	CoTaskMemFree(PP);

	f:=4;
	pstm.Read(@CO,f,@f);
	S:=S+CO.ToString+#13;

	f:=4;
	pstm.Read(@CO,f,@f);
	S:=S+CO.ToString+#13;

	f:=1;
	pstm.Read(@ww,f,@f);
	S:=S+ww.ToString+#13;
	/// /////////

	f:=4;
	pstm.Read(@CO,f,@f);
	S:=S+CO.ToString+#13;

	f:=4;
	pstm.Read(@CO,f,@f);
	S:=S+CO.ToString+#13;

	f:=4;
	pstm.Read(@CO,f,@f);
	S:=S+CO.ToString+#13;

	// pstm.Seek(0,1,EE);


	// pstm.Seek(-204,2,EE);
	// ShowMessage(EE.ToString);

	f:=188;
	PP:=CoTaskMemAlloc(f);
	pstm.Read(PP,f,@f);
	S:=S+widechartostring(PP)+#13;
	CoTaskMemFree(PP);

	f:=4;
	pstm.Read(@CO,f,@f);
	S:=S+CO.ToString+#13;

	f:=4;
	pstm.Read(@CO,f,@f);
	S:=S+CO.ToString+#13;

	RichEdit.Lines.text:=S;

	{ SHCreateStreamOnFileEx(Pchar('C:\Users\MICLE\Desktop\sss.amd'),STGM_CREATE or STGM_READWRITE,0,
		True,nil,sst);

		ST:=TStringStream.Create(S,TEncoding.UTF8);
		ST.Position:=0;
		f:=0;
		sst.Write(ST.Memory,ST.Size,@f);
		sst.Commit(0); }

end;

type
	TThumbnailCleanerCallBack=class(TInterfacedObject,IEmptyVolumeCacheCallBack)
	private
		function ScanProgress(dwlSpaceUsed:Int64;dwFlags:DWORD;pcwszStatus:LPCWSTR):HResult;stdcall;
		function PurgeProgress(dwlSpaceFreed,dwlSpaceToFree:Int64;dwFlags:DWORD;pcwszStatus:LPCWSTR):HResult;stdcall;
	end;

function TThumbnailCleanerCallBack.ScanProgress(dwlSpaceUsed:Int64;dwFlags:DWORD;pcwszStatus:LPCWSTR):HResult;
Begin
	Result:=S_OK;
end;

function TThumbnailCleanerCallBack.PurgeProgress(dwlSpaceFreed,dwlSpaceToFree:Int64;dwFlags:DWORD;
	pcwszStatus:LPCWSTR):HResult;
Begin
	Result:=S_OK;
end;

procedure TAmdF.Button47Click(Sender:TObject);
const
	ThumbnailCleanerCLSID:TGUID='{889900c3-59f3-4c2f-ae21-a409ea01e605}';
var
	Drives:DWORD;
	Drive:DWORD;
	Letter:Char;
	ThumbnailCleaner:IEmptyVolumeCache;
	Key:hkey;
	DisplayName:PWideChar;
	Description:PWideChar;
	flags:DWORD;
	ThumbnailCleanerCallBack:TThumbnailCleanerCallBack;
Begin
	Drives:=GetLogicalDrives;
	Drive:=1;
	for Letter:='A' to 'Z' do Begin
		if Drives and Drive<>0 then Begin
			OleCheck(CoCreateInstance(ThumbnailCleanerCLSID,nil,CLSCTX_INPROC_SERVER or CLSCTX_LOCAL_SERVER,IUnknown,
				ThumbnailCleaner));
			try
				RegOpenKeyEx(HKEY_LOCAL_MACHINE,
					PWideChar('SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache'),0,KEY_READ,Key);
				try
					DisplayName:=nil;
					Description:=nil;
					flags:=EVCF_SETTINGSMODE;
					OleCheck(ThumbnailCleaner.Initialize(Key,PWideChar(Letter+':\'),DisplayName,Description,flags));
					try
						if Assigned(DisplayName) then CoTaskMemFree(DisplayName);
						if Assigned(Description) then CoTaskMemFree(Description);
						ThumbnailCleanerCallBack:=TThumbnailCleanerCallBack.Create;
						OleCheck(ThumbnailCleaner.Purge(-1,ThumbnailCleanerCallBack));
					finally
						flags:=0;
						OleCheck(ThumbnailCleaner.Deactivate(flags));
					end;
				finally RegCloseKey(Key);
				end;
			finally ThumbnailCleaner:=nil;
			end;

		end;
		Drive:=Drive shl 1;
	end;
end;

function STRFromBase64(Info:string):string;
var
	Stream:TBytesStream;
	Bytes:TBytes;
	Encoding:TBase64Encoding;
begin
	// Stream:=TBytesStream.Create;
	try
		Encoding:=TBase64Encoding.Create(0);
		try
			// Bytes:=Encoding.DecodeStringToBytes(Info);
				Result:=Encoding.Decode(Info);
			// Stream.WriteData(Bytes,Length(Bytes));
			// Stream.Position:=0;
			// .LoadFromStream(Stream);
		finally Encoding.Free;
		end;
	finally
		// Stream.Free;
	end;
end;

procedure TAmdF.Button48Click(Sender:TObject);
var
	Q1,Q2,iLen:UInt64;
	AutoC:TAutoC;
	mud,sr,lr:Nativeuint;
	CC: array OF Char;
	XX:Pointer;
	Resdata,Tempdata:Tbytedynarray;
	i:integer;
	SS:AnsiString;
Begin
	// AssocGetDetailsOfPropKey();
	// Messagebeep(MB_ICONERROR);
	SS:=STRFromBase64(RichEdit.text);
	RichEdit.Clear;
	for i:=1 to Length(SS) do RichEdit.Lines.add(Ord(SS[i]).ToString+' : '+SS[i]);
	RichEdit.Lines.add(SS);
	EXIT;
	mud:=Loadlibraryex('E:\PRO\Win32\Release\logo\00\ASS.dll',0,Load_library_as_datafile);
	if mud=0 then EXIT;
	// ShowMessage(mud.ToString);
	sr:=FindResourceEx(mud,Rt_string,MakeIntResource(2162),1033);
	iLen:=Sizeofresource(mud,sr);
	lr:=LoadResource(mud,sr);
	XX:=lockresource(lr);
	SetLength(CC,iLen);
	Copymemory(CC,XX,iLen);

	for i:=0 to iLen do RichEdit.Lines.add(Ord(CC[i]).ToString+' : '+CC[i]);
	// ShowMessage(WideCharToString(PChar(SS)));
	unlockresource(lr);
	FreeLibrary(mud);

	// ShowMessage(GetLocaleOverride('AMD'));
	// ShowMessage(GetUILanguages(GetUserDefaultUILanguage));

	{ AutoC:=TAutoC.Create(Edit2);
		AutoC.Strings:=RichEdit.Lines;
		ACDD:=AutoC.AutoCompleteDropDown; }
end;

procedure TAmdF.Button49Click(Sender:TObject);
begin
	TSTSA.Create(Self,'1',Sfr1(2));
end;

procedure TAmdF.Button4click(Sender:TObject);
Begin
	TSGA.Create(Self,0,'4',Sfr1(2),Sfr1(21));
end;

procedure TAmdF.Button5click(Sender:TObject);
Begin
	TSGA.Create(Self,0,'3',Sfr1(2),Sfr1(21));
end;

procedure TAmdF.Button6click(Sender:TObject);
Begin
	TSGA.Create(Self,0,'5',Sfr1(2),Sfr1(21));
end;

procedure TAmdF.Button8click(Sender:TObject);
var
	i:integer;
Begin
	{ for i:=0 to 9-1 do Begin
		Tsga.Create(Self,i,'1',Sfr1(2),Sfr1(21));
		End; }
	TSGA.Create(Self,0,'1',Sfr1(2),Sfr1(21));
end;

procedure TAmdF.Button14click(Sender:TObject);
Begin
	TSGA.Create(Self,0,'2',Sfr1(2),Sfr1(21));
end;

procedure TAmdF.Button15click(Sender:TObject);
Begin
	TSGA.Create(Self,0,'6',Sfr1(2),Sfr1(21));
end;

procedure TAmdF.Button20click(Sender:TObject);
Begin
	Cascade;
end;

procedure TAmdF.Button21click(Sender:TObject);
Begin
	Arrangeicons;
end;

procedure TAmdF.Button22click(Sender:TObject);
var
	i:integer;
Begin
	for i:=0 to Mdichildcount-1 do Begin
		Mdichildren[i].Windowstate:=Wsnormal;
	end;
end;

procedure TAmdF.Button9click(Sender:TObject);
var
	ld,i:Cardinal;
	dar,kj: array [0..MAX_PATH] of Char;
	S:string;
	K1:hkey;
	mx,jj,kk,OO,uu,FF,bb,vv:integer;
	GG:DWORD;
	CC:tFileTime;
	re:integer;
	Value:TRegKeyInfo;
	pcSubKeys,pcchMaxSubKeyLen,pcValues,pcchMaxValueNameLen,pdwType:DWORD;
Begin
	RegOpenKeyEx(HKEY_CLASSES_ROOT,'Applications\AMD.exe\SupportedTypes',0,KEY_READ,K1);
	SHQueryInfoKey(K1,@pcSubKeys,@pcchMaxSubKeyLen,@pcValues,@pcchMaxValueNameLen);
	S:='';
	for i:=1 to pcValues-1 do begin
		GG:=Length(dar);
		SHEnumValue(K1,i,dar,GG,@pdwType,nil,nil);
		S:=S+widechartostring(dar)+#13;
	end;
	ld:=MAXWORD+2;
	kk:=ld;
	jj:=1;
	{ SHGetValue(HKEY_LOCAL_MACHINE,'Software\Microsoft\Windows\CurrentVersion\App Paths\AMD.exe',
		'Path',nil,@dar,ld);
		Showmessage(dar+'MDfc\AmzPD1.amd'); }
	ShowMessage(pcValues.ToString+#13+pcchMaxValueNameLen.ToString+#13+pdwType.ToString+#13+S);
	// SHGetValue(HKEY_CLASSES_ROOT,'Applications\AMD.exe\SupportedTypes','',nil,@dar,ld);
	// SHEnumValue
	// RichEdit.Clear;
	{ with TRegistry.Create do begin
		RootKey:=HKEY_CLASSES_ROOT;
		OpenKey('SystemFileAssociations\.amdz',False);
		GetKeyInfo(Value);
		ShowMessage(Value.NumValues.ToString);
		GetValueNames(RichEdit.Lines);
		CloseKey;
		end; }

	{ RegOpenKeyEx(HKEY_CLASSES_ROOT,Pchar('SystemFileAssociations\.amdz'),0,KEY_ALL_ACCESS,K1);
		RegQueryInfoKey(K1,nil,nil,nil,@jj,@kk,nil,@Mx,@uu,@ff,nil,@cc);
		Setstring(S,nil,uu+1);
		while (RegEnumValue(K1,I,@dar,ld,nil,nil,nil,nil)=0) do begin
		ld:=MAXWORD+2;
		RichEdit.Lines.Add(dar);
		Inc(I,1);
		end; }
end;

// S6[1] wait form label caption
// S6[2] PARAMS
end.
