unit amdfun1;

interface

uses
	WinAPI.WindowsStore,
	WinAPI.Windows,
	WinAPI.Messages,
	System.Sysutils,
	System.Classes,
	Vcl.Graphics,
	Vcl.Controls,
	Vcl.Forms,
	Vcl.Mask,
	Vcl.Dialogs,
	Vcl.Comctrls,
	Vcl.Stdctrls,
	System.Strutils,
	Vcl.Imglist,
	// Winapi.ShLwApi,
	Vcl.Menus,
	System.Inifiles,
	System.Types,
	Vcl.Extctrls,
	System.Dateutils,
	WinAPI.Commctrl,
	WinAPI.Commdlg,
	WinAPI.Shellapi,
	Vcl.Taskbar,
	System.Win.Comobj,
	Rzcmbobx,
	Stgs,
	Rzprgres,
	Vcl.Winxctrls,
	Soap.EncdDecd,
	Idhashsha,
	System.Variants,
	Idhashmessagedigest,
	System.Netencoding,
	WinAPI.Mmsystem,
	System.Math,
	System.Win.Registry,
	WinAPI.Shlobj,
	WinAPI.ActiveX,
	Vcl.Themes,
	System.Generics.Collections,
	Vcl.Buttons,
	Vcl.Printers,
	Vcl.TrayIco,
	AMD.Dragdrop,
	AMD.Dropsource,
	AMD.Droptarget,
	AMD.Dragdropfile,
	AMD.DropCombo,
	AMD.ChromeTabs,
	AMD.Chrometabsclasses,
	AMD.Chrometabstypes,
	WinAPI.Gdipobj,
	WinAPI.Gdipapi,
	WinAPI.msxml,
	WinAPI.MSXMLIntf,
	WinAPI.Imagehlp,
	// AMD.CategoryButtons,
	System.Sqlite,
	AMD.Phys.SQLiteCli,
	AMD.Phys.SQLiteVDataSet,
	AMD.Phys.Sqlitewrapper,
	AMD.Phys.Sqlite,
	AMD.Phys.SQLiteDef,
	AMD.Comp.Client,
	AMD.Stan.Def,
	// AMD.Vclui.Wait,
	AMD.Phys,
	AMD.Stan.Async,
	AMD.Stan.Intf,
	Data.Db,
	AMD.Stan.Option,
	AMD.Stan.Param,
	AMD.Stan.Error,
	AMD.Dats,
	AMD.Phys.Intf,
	AMD.Dapt.Intf,
	AMD.Dapt,
	AMD.Comp.Dataset,
	AMD.Stan.Exprfuncs,
	AMD.Ui.Intf,
	AMD.Comp.Script,
	AMD.Stan.Pool;

{$SCOPEDENUMS ON}

type

	HRD6=array [0..5] of Byte;
	HRD32=array [0..31] of Byte;

	TFileHeader=record
		FHeader: array [0..5] of Byte;
		FExt: array [0..5] of Byte;
		FPass: array [0..31] of Byte;
		FVersion:Byte;
		thumb:Cardinal;
		Prop:Cardinal;
		FCount:Cardinal;
		FContentSPos:UInt64;
		FContentSize:UInt64;
		FContentEPos:UInt64;
		FTumbSPos:UInt64;
		FTumbSize:UInt64;
		FTumbEPos:UInt64;
		FPropSPos:UInt64;
		FPropSize:UInt64;
		FPropEPos:UInt64;
		FFooterPos:UInt64;
	end;

	TDocHeader=record
		FMagic: array [0..5] of Byte;
		FExt: array [0..5] of Byte;
		FNUM:Integer;
		FPass: array [0..31] of Byte;
		FUser:Integer;
		FST:Integer;
		FVersion:Word;
		FDictionaryOffset:Cardinal;
		FContent:UInt64;
		FStartPos:UInt64;
		FEndPos:UInt64;
		FInfoSize:UInt64;
	end;

	TFileFooter=record
		FFooter: array [0..5] of Byte;
		FExt: array [0..5] of Byte;
		FPass: array [0..31] of Byte;
		FVersion:Byte;
		thumb:Cardinal;
		Prop:Cardinal;
		FCount:Cardinal;
		FContentSPos:UInt64;
		FContentSize:UInt64;
		FContentEPos:UInt64;
		FTumbSPos:UInt64;
		FTumbSize:UInt64;
		FTumbEPos:UInt64;
		FPropSPos:UInt64;
		FPropSize:UInt64;
		FPropEPos:UInt64;
	end;

	PSQLH=^TSQLH;

	TSQLH=record
		HEAD: array [0..15] of AnsiChar;
		PageSize:Word;
		FileFormatWrite:Byte;
		FileFormatRead:Byte;
		EndOfEachPage:Byte;
		MXpayload:Byte;
		MNpayload:Byte;
		LeafPayload:Byte;
		FileChangeCounter:Integer;
		DBSizePages:Integer;
		PN:Integer;
		TPN:Integer;
		SchemaCookie:Integer;
		SchemaFormatN:Integer;
		DCacheSize:Integer;
		Root:Integer;
		Encodig:Integer;
		UserVersion:Integer;
		INVacuum:Integer;
		APPID:Integer;
		RESERVED: array [0..19] of AnsiChar;
		VVN:Integer;
		SQLITEV:Integer;
	end;

	PPRS=^TPRS;

	TPRS=packed record
		PLen,PLev:Word;
		PDatn,PDatv: array [0..1024] of Char;
	end;

	PDat=^TDat;

	TDat=record
		PLength:Word;
		PData: array [0..0] of Char;
	end;

	Mousellhookstruct=record
		Pt:TPoint;
		MouseData:Cardinal;
		Flags:Cardinal;
		Time:Cardinal;
		DWExtraInfo:Cardinal;
	end;

	TTSG=record
		UButtonModal:Integer;
		URadioId:Integer;
		UChecked:Boolean;
		UHyperResult:Boolean;
		UURL:string;
	end;

	PuDatas=^TuDatas;

	TuDatas=record
		UData:Pointer;
		UDz:UInt64;
		Uh:Thandle;
		Uhk:Integer;
	end;

	PRis=^TRis;

	TRis=record
		Umoudle:HModule;
		Ulist:string;
		Ulang:Cardinal;
		Udatas:TuDatas;
		procedure Udis;
	end;

	TCBH=class helper for TWinControl
		procedure SBO(Icon:Cardinal;Title1,Text1:string;Rect1:TRect;SoundN:Integer=0);
		procedure BO(Icon:Cardinal;Title1,Text1:string;Rect1:TRect;SoundN:Integer=0);
		procedure SO(Icon:Cardinal;Title1,Text1:string;Rect1:TRect;SoundN:Integer=0);
	end;

	TFrm=class(TForm)
	private
		FTab:TChromeTab;
	published
		property ATab:TChromeTab read FTab write FTab default nil;
	end;

	TmyDragControlObject=class(TDragControlObjectEX)
	private
		FPrevAccepted:Boolean;
	protected
		function GetDragCursor(Accepted:Boolean;X,Y:Integer):TCursor;Override;
		function GetDragImages:TDragImageList;Override;
	public
		destructor Destroy;Override;
	end;

	TTransparentForm=class(TForm)
	protected
		procedure CreateParams(var Params:TCreateParams);Override;
	end;

	TmyDragDockObject=class(TDragDockObjectEX)
	private
		FPrevAccepted:Boolean;
	protected
		function GetEraseWhenMoving:Boolean;Override;
		procedure DrawDragDockImage;Override;
		procedure EraseDragDockImage;Override;
		function GetDragCursor(Accepted:Boolean;X,Y:Integer):TCursor;Override;
		function GetDragImages:TDragImageList;Override;
	public
		constructor Create(AControl:TControl;CLR:TColor=ClHighlight);overload;
		destructor Destroy;Override;
	end;

	THW=class(THintWindow)
	private
		AHint1,AHint2,AHint3,AHint4,AHint5,AHint6,AHint7:string;
		procedure CMTextChanged(var Message:TMessage);message CM_TextChanged;
	protected
		procedure Paint;Override;
	public
		Da:Timage;
		constructor Create(AOwner:TComponent);Override;
		procedure ActivateHint(Rect:TRect;const AHint:string);Override;
	published
		property Hint1:string read AHint1 write AHint1;
		property Hint2:string read AHint2 write AHint2;
		property Hint3:string read AHint3 write AHint3;
		property Hint4:string read AHint4 write AHint4;
		property Hint5:string read AHint5 write AHint5;
		property Hint6:string read AHint6 write AHint6;
		property Hint7:string read AHint7 write AHint7;
	end;

	TEnumString=class(TInterfacedObject,IEnumString)
	private
		FStrings:TStrings;
		FCurrIndex:Integer;
	public
		function Next(Celt:Longint;out Elt;PCeltfetched:PLongint):HResult;stdcall;
		function Skip(Celt:Longint):HResult;stdcall;
		function Reset:HResult;stdcall;
		function Clone(out Enm:IEnumString):HResult;stdcall;
		constructor Create(AStrings:TStrings;AIndex:Integer=0);
	end;

	TFileIsInUseImpl=class(TInterfacedObject,IUnknown,IFileIsInUse)
	protected
		function GetAppName(var ppszName:LPWSTR):HResult;stdcall;
		function GetUsage(var pfut:Integer):HResult;stdcall;
		function GetCapabilities(var pdwCapFlags:DWORD):HResult;stdcall;
		function GetSwitchToHWND(var phwnd:HWND):HResult;stdcall;
		function CloseFile:HResult;stdcall;
	private
		fFileName:string;
	public
		constructor Create(const AFileName:string);
	end;

const

	AMD_HD:HRD6=(Ord('A'),Ord('M'),Ord('D'),Ord('Z'),Ord('1'),Ord('9'));
	AMD_BLNK:HRD6=(Ord('A'),Ord('M'),Ord('D'),Ord('0'),Ord('0'),Ord('0'));
	AMD_INV:HRD6=(Ord('A'),Ord('M'),Ord('D'),Ord('A'),Ord('3'),Ord('N'));
	AMD_PUR:HRD6=(Ord('A'),Ord('M'),Ord('D'),Ord('B'),Ord('3'),Ord('N'));
	AMD_RINV:HRD6=(Ord('A'),Ord('M'),Ord('D'),Ord('C'),Ord('3'),Ord('N'));
	AMD_RPUR:HRD6=(Ord('A'),Ord('M'),Ord('D'),Ord('D'),Ord('3'),Ord('N'));
	AMD_OINV:HRD6=(Ord('A'),Ord('M'),Ord('D'),Ord('S'),Ord('3'),Ord('N'));
	AMD_OPUR:HRD6=(Ord('A'),Ord('M'),Ord('D'),Ord('P'),Ord('3'),Ord('N'));
	AMD_KD:HRD6=(Ord('A'),Ord('M'),Ord('D'),Ord('Q'),Ord('3'),Ord('N'));
	AMD_FO:HRD6=(Ord('A'),Ord('M'),Ord('D'),Ord('Z'),Ord('9'),Ord('9'));
	C_Magic:HRD6=(Ord('A'),Ord('M'),Ord('D'),Ord('7'),Ord('7'),Ord('7'));

	WM_FILEINUSE_CLOSEFILE=WM_USER+1;
	APPID='{02403678-A964-44CD-BA61-8B8E2D1F4DD4}';
	Amz_logo='logo\Amz_s321.dll';
	IMG_logo='logo\imageres.dll';
	Cns='Sources\RegExs.exe';

	//
	Ct1='CREATE TABLE IF NOT EXISTS ';
	Idn1='id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT';
	Tn1=' TEXT DEFAULT ""';
	Nn1=' NUMERIC NULL';
	Rn1=' REAL NULL';
	Bn1=' BLOB NULL';
	BBN1=' BOOL NULL';
	Idn2=Idn1+',US'+Nn1+',ST'+Nn1;
	Etstr=',INX'+Nn1+',CIT'+Tn1+',ADR'+Tn1+',PHO1'+Tn1+',PHO2'+Tn1+',MOB1'+Tn1+',MOB2'+Tn1+',MOB3'+Tn1+',FAX'+Tn1+',EML'+
		Tn1+',COMM'+Tn1;

	I_n=9000001;
	I_w=9000002;
	I_e=9000003;
	I_i=9000004;
	I_s=9000005;

	Restypenames: array [1..24] of string=('RT_CURSOR', // = MakeIntResource(1);
		'RT_BITMAP', // = MakeIntResource(2);
		'RT_ICON', // = MakeIntResource(3);
		'RT_MENU', // = MakeIntResource(4);
		'RT_DIALOG', // = MakeIntResource(5);
		'RT_STRING', // = MakeIntResource(6);
		'RT_FONTDIR', // = MakeIntResource(7);
		'RT_FONT', // = MakeIntResource(8);
		'RT_ACCELERATOR', // = MakeIntResource(9);
		'RT_RCDATA', // = MakeIntResource(10);
		'RT_MESSAGETABLE', // = MakeIntResource(11);
		// DIFFERENCE = 11;
		'RT_GROUP_CURSOR', // = MakeIntResource(DWORD(RT_CURSOR +DIFFERENCE));  12
		'UNKNOWN', // 13 not used
		'RT_GROUP_ICON', // = MakeIntResource(DWORD(RT_ICON +DIFFERENCE)); 14
		'UNKNOWN', // 15 not used
		'RT_VERSION', // = MakeIntResource(16);
		'RT_DLGINCLUDE', // = MakeIntResource(17);
		'UNKNOWN', // 18 not used
		'RT_PLUGPLAY', // = MakeIntResource(19);
		'RT_VXD', // = MakeIntResource(20);
		'RT_ANICURSOR', // = MakeIntResource(21);
		'RT_ANIICON', // = MakeIntResource(22);
		'RT_HTML', // = MakeIntResource(23);
		'RT_MANIFEST' // = MakeIntResource(24);
		);

	ASSOCSTR_COMMAND=1;
	ASSOCSTR_EXECUTABLE=2;
	ASSOCSTR_FRIENDLYDOCNAME=3;
	ASSOCSTR_FRIENDLYAPPNAME=4;
	ASSOCSTR_NOOPEN=5;
	ASSOCSTR_SHELLNEWVALUE=6;
	ASSOCSTR_DDECOMMAND=7;
	ASSOCSTR_DDEIFEXEC=8;
	ASSOCSTR_DDEAPPLICATION=9;
	ASSOCSTR_DDETOPIC=10;
	ASSOCSTR_INFOTIP=11;
	ASSOCSTR_QUICKTIP=12;
	ASSOCSTR_TILEINFO=13;
	ASSOCSTR_CONTENTTYPE=14;
	ASSOCSTR_DEFAULTICON=15;
	ASSOCSTR_SHELLEXTENSION=16;
	ASSOCSTR_DROPTARGET=17;
	ASSOCSTR_DELEGATEEXECUTE=18;
	ASSOCSTR_SUPPORTED_URI_PROTOCOLS=19;
	ASSOCSTR_PROGID=20;
	ASSOCSTR_APPID=21;
	ASSOCSTR_APPPUBLISHER=22;
	ASSOCSTR_APPICONREFERENCE=23;
	ASSOCSTR_MAX=24;

function FOT(Extn:string):HRD6;
function Extn(FOT:HRD6):string;

procedure SBO1;
procedure LandOtChrome(ACrom:TChromeTabs);
function AddTab(ChromeTabs:TChromeTabs;const Text:string;HCol:TWinControl;ImageIndex:Integer=-1):TChromeTab;
procedure StartAtAll;
procedure CreatTStart(N:Integer);
function IntToBin(I:Integer):string;
function ATO(HN:HWND;LS:TStrings;RTL:Boolean=False;Search:Boolean=False):IAutoCompleteDropDown;
function PR0(Sub:string;Vstr:string):Integer;
function AMDS(O:Integer;CMH,Cl:string;var LUG:TFDStringArray):Integer;
function GR0(Value:string;Delimiter:string):Integer;
function GR1(Value:string;Delimiter:string):Integer;
function GR2(Value:string;Delimiter:string):Integer;
function GR3(Value:string;Delimiter:string):Integer;
function GR4(Value:string;Delimiter:string):Integer;
function GR5(Value:string;Delimiter:string):Integer;

procedure PSN1(Rn:Integer);
function StyleToStr(Style:TFontStyles):string;
function StrToStyle(Strs:string):TFontStyles;
function GetColor(Input:string):TColor;
function GetRGB(Input1:TColor):string;
function Get_Date(Nex:Integer):string;
function Get_Time:string;
function GDT(Nex:Integer):string;
function NToDt0(D:string):string;
function NToDt(D:string;var Dt,TMR:Extended):string;
function DTtoN(D:string=''):UInt64;
function DtToN1(D:string=''):UInt64;
function DtToN2(D:string=''):UInt64;
function BTB64(Path:string):string;
function B64BT(const Base64:string):TBitmap;
function MDFive(Mf:string):string;
function SHAONE(SO:string):string;
function ENC1(EC:string):string;
function DEC1(DC:string):string;
function DTD1(RFC:string):string;
function DTM1(RFC:string):string;
function DTN1(RFC:string):Integer;
function DTL1(RFC:string):string;
function DTK1(RFC:string):string;
function DTEX1(RFC:string):string;
function SCOD1(Lang:string):string;
function SLG1(COD:string):string;
function SBG1(COD:string):string;
function Send1(COD:string):string;
function SKI1(COD:string):string;
function SAC1(COD:string):string;
function SAM1(COD,ST1:string):string;
function SAM2(COD,ST1:string):string;
function RTC1(RFC,ST1:string):UInt64;
function NOL1(NU:string):Extended;
function NUK(NU:string):string;
function NE(NU:string):Extended;
function NA(NU:string):UInt64;
function NL(NU:string):UInt64;
function BL1(NU: array of UInt64):Boolean;
function SR0(S:string):string;
function TxToHY(UText1,ULink:string):string;
function SIC1(ID:Integer;BG:Integer=0;LIB:Integer=0):HIcon;
function SIC2(UCur:HIcon;UText:string):Ticon;
function SFF1(CCl,MH,CCL1,TX1:string;CCL2:string='';TX2:string='';CCL3:string='';Tx3:string=''):string;
function DPTmpDROP(TBL,ERR:string):Boolean;
procedure DTmpDech(O:Integer);
function DTmpT:Boolean;
function DTmpC(RFC:string;var TBL,ERR:string;ISNEW:Boolean=True):Boolean;
function SFD1(CN1:Integer;RFC:string):string;
function SFD2(IX:Integer;RFC:string):Integer;
function SFD4(CN1:Integer;RFC:string):Integer;
function SFD5(CN1:Integer;RFC:string):string;
function SFD61(IX:Integer;RFC:string):string;
function SFD62(IX:Integer;RFC:string):string;
function SFD7(CN1:Integer;RFC:string):string;
function SFD8(IX:Integer;RFC:string):Integer;
function SCCE1(ID:string):string;
function SCCE2(Lang:string):string;
function ITD3(IX:Integer;Lang,RFC:string):Boolean;
function SL1(ID:Integer):string;
function SFL1(ID:Integer):string;
function ITL1(ID:Integer;CUl,TX:string):Boolean;
function SFR1(ID:Integer):string;
function ITR1(ID:Integer;RTF:string):Boolean;
function SFU1(ID:Integer;CUl:string):string;
function ITU1(ID:Integer;CUl,TX:string):Boolean;
function SFJ1(ID:Integer;CUl:string):string;
function ITJ1(ID:Integer;CUl,TX:string):Boolean;
function SFM1(ID:Integer):string;
function SFM2(ID:Integer):Integer;
function ITM1(ID,RTF:Integer):Boolean;
function SFQ1(IT,SN,INV,RFC:string):Extended;
function SFQ2(IT,RFC,ST1,CC1,IC:string):Extended;
function SFPR1(IT,RFC,ST1,CC1:string;IC:Integer;PR,QY:Extended;SN:string='';N:string=''):string;
function SEI1(COD:string):string;
function SEC1(COD:string):string;
function SCl(CCl:string):string;
function SFIT0(IT:string):Integer;
function SFIT1(IT,CCl:string):string;
function SFIT2(Lang,CCl:string):string;
function SFIT3(IT,CCl:string):string;
function SFIT4(IT:string;CC:string=''):string;
function SFIT5(IT:string;QY:string='0'):string;
function SFIT6(CC,IT,ST1,RFC:string;NU:Integer):string;
function SFIT7(IT,QY:string):string;
function SFIT8(IT:string):string;
function SFCE1(COD:string):string;
function SFCE2(Lang:string):string;
function SFCC1(COD:string):string;
function SFCC2(Lang:string):string;
function SFCC3(COD:string):string;
function SFCC4(COD:string):string;
function SFST1(ID:string):string;
function SFST2(Lang:string):string;
function SFSN1(ID:string):string;
function SFSN2(Lang:string):string;
function SFCR1(ID:Integer):string;
function SFCR2(ID:Integer):string;
function FLSH(HWIN:HWND;HDWFlags,HuCount:Cardinal):Boolean;
function TLL1(UCol:TStrings):Extended;
function TLL2(UCol:TStrings):Extended;
function Examine(FileName:AnsiString;Members:Tstringlist):Boolean;
procedure LoadFromXML(FDQuery:TFDQuery;Fil:string;Index:Integer=0);
procedure SaveToXML(FDQuery:TFDQuery;Fil:string);
function CPROP(EXT:string):string;
function APROP:string;
procedure PROBMP(BMP:TBitmap;NewWidth,NewHeight:Integer;MG:Integer=0);
function Base64FromBitmap(BMP:TBitmap):string;
procedure BitmapFromBase64(Info:string;VAR BMP:TBitmap);
function AllFiles(Fold:string):string;
function bmp2emf(Bitmap:TBitmap):TMetaFile;
procedure RegisterFileIsInUse(const AFileName:string);
procedure UNRegisterFileIsInUse(const AFileName:string);
function RegisterThisAppRunAsInteractiveUser(pszCLSID:string):HResult;
function GetFileInUseInfo(const FileName:string):IFileIsInUse;
function NewItem(const aSrcItem:string):HResult;
function PRPolicy(RFC:string):Integer;
function Drophint(Uimage:Integer;Dataobject:IDataobject;Udescriptin:string;Umsg:string=''):Integer;
function Def(D1,D2:UInt64):string;
function TNOW:UInt64;
procedure SetDragHint(Dataobject:IDataobject;const Value:string;Effect:Integer);
FUNCTION PrepareConnection(conn:TFDConnection;FD:TFDQuery;DBFile:string):Boolean;

function LIWSDown(Hinst:Hinst;pszName:LPCWSTR;cx:Integer;cy:Integer;var phico:HIcon):HResult;stdcall;
	external 'Comctl32.dll' name 'LoadIconWithScaleDown';
function PathFindFileName(pszPath:LPCWSTR):LPWSTR;stdcall;external 'shlwapi.dll' name 'PathFindFileNameW';

var
	HMMBWindow:HWND;
	Mutex:Thandle;
	HIP1,HIP2,HIP3:Thandle;
	TF1,TF2,TF3:TToolInfo;
	POIN1:Pointer;
	BU:Boolean;
	TextInput: array [1..100] of string;
	TextOutput:string;
	NumInput: array [1..100] of Integer;
	NumOutput:Integer;
	S0,S1,S2,S3,S4,S5,Md: array [1..2000] of string;
	Lng1,Lng2:TFDStringArray;
	TMR: array [1..15] of TTimer;
	PU: array [1..15] of TPopUpMenu;
	// FBo: array[1..1500] of TRzFontComboBox;
	Il: array [0..15] of TImageList;
	DI,DI1:TDragImageList;
	// SG: array [1..1500] of TSG;
	TB: array [1..15] of TToolBar;
	ST,ST0: array [1..15] of TPanel;
	Lan,Dir,Pa:string;
	CN: array [0..12] of TFDConnection;
	FQ: array [0..12] of TFDQuery;
	HT:THW;
	CRT1:TChromeTabs;
	AMDT:TDropComboTarget;
	AMDC:TDropComboSource;
	TransparentForm:TTransparentForm;
	ResNme:Pchar=nil;
	ResTyp:Pchar=nil;
	ResLng:Cardinal=0;
	UFl:Word=0;
	Taskbar1:TTaskbar;
	TaskBTN:Boolean=True;
	TrayIcon1:TTryIcon;
	Cookie:Longint;
	OutFiles:Tstringlist;
	OutFiles1:Tstringlist;
  FILTR:string;
implementation

{$WARN SYMBOL_PLATFORM OFF}

uses
	Vcl.Graphutil,
	Amdmain,
	Vcl.AxCtrls,
	Amdfun2;

// Lets get start **

function Extn(FOT:HRD6):string;
begin
	Result:='';
	if CompareMem(@FOT[0],@AMD_INV[0],6) then Result:='.ainv';
	if CompareMem(@FOT[0],@AMD_PUR[0],6) then Result:='.apur';
	if CompareMem(@FOT[0],@AMD_RINV[0],6) then Result:='.arnv';
	if CompareMem(@FOT[0],@AMD_RPUR[0],6) then Result:='.arpr';
	if CompareMem(@FOT[0],@AMD_OINV[0],6) then Result:='.aonv';
	if CompareMem(@FOT[0],@AMD_OPUR[0],6) then Result:='.aopr';
	if CompareMem(@FOT[0],@AMD_KD[0],6) then Result:='.akyd';
	if Result='' then Result:='.amd';

end;

function FOT(Extn:string):HRD6;
begin
	Extn:=LowerCase(Extn);
	Move(AMD_BLNK,Result,6);
	if (Extn='.ainv') then Move(AMD_INV,Result,6);
	if (Extn='.apur') then Move(AMD_PUR,Result,6);
	if (Extn='.arnv') then Move(AMD_RINV,Result,6);
	if (Extn='.arpr') then Move(AMD_RPUR,Result,6);
	if (Extn='.aonv') then Move(AMD_OINV,Result,6);
	if (Extn='.aopr') then Move(AMD_OPUR,Result,6);
	if (Extn='.akyd') then Move(AMD_KD,Result,6);
end;

function TNOW:UInt64;
var
	SystemTime:TSystemTime;
begin
	GetLocalTime(SystemTime);
	Result:=(SystemTime.wHour*60*60*1000)+(SystemTime.wMinute*60*1000)+(SystemTime.wSecond*1000)+SystemTime.wMilliseconds;
end;

function Def(D1,D2:UInt64):string;
var
	H,M,S,SS,MS:Int64;
begin
	Result:='';
	try
		MS:=D2-D1;
		H:=MS div 3600000;
		M:=(MS mod 3600000)div 60000;
		S:=((MS mod 3600000)mod 60000)div 1000;
		SS:=((MS mod 3600000)mod 60000)mod 1000;
		Result:=Formatdatetime('HH:mm:ss.ZZZ',EncodeTime(H,M,S,SS));
	except
		on E:Exception do SHOWMESSAGE('DEF'+#13+E.Message);
	end;
end;

procedure SetDragHint(Dataobject:IDataobject;const Value:string;Effect:Integer);
var
	FormatEtc:TFormatEtc;
	Medium:TStgMedium;
	Data:Pointer;
	Descr:DROPDESCRIPTION;
	S:WideString;
begin
	ZeroMemory(@Descr,SizeOf(DROPDESCRIPTION));
	{ Do not set Descr.&type to DROPIMAGE_INVALID - this value ignore any custom hint }
	{ use same image as dropeffect type }
	Descr.&type:=DROPIMAGE_LABEL;
	case Effect of
		DROPEFFECT_NONE:Descr.&type:=DROPIMAGE_NONE;
		DROPEFFECT_COPY:Descr.&type:=DROPIMAGE_COPY;
		DROPEFFECT_MOVE:Descr.&type:=DROPIMAGE_MOVE;
		DROPEFFECT_LINK:Descr.&type:=DROPIMAGE_LINK;
	end;
	{ format message for system }
	if Length(Value)<=MAX_PATH then begin
		Move(Value[1],Descr.szMessage[0],Length(Value)*SizeOf(WideChar));
		Descr.szInsert:='';
	end else begin
		S:=Copy(Value,1,MAX_PATH-2)+'%1';
		Move(S[1],Descr.szMessage[0],Length(S)*SizeOf(WideChar));

		S:=Copy(Value,MAX_PATH-1,MAX_PATH);
		Move(S[1],Descr.szInsert[0],Length(S)*SizeOf(WideChar));
	end;
	{ prepare structures to set DROPDESCRIPTION data }
	FormatEtc.cfFormat:=FDragDescriptionFormat; { registered clipboard format }
	FormatEtc.ptd:=nil;
	FormatEtc.dwAspect:=DVASPECT_CONTENT;
	FormatEtc.lindex:=-1;
	FormatEtc.tymed:=TYMED_HGLOBAL;

	ZeroMemory(@Medium,SizeOf(TStgMedium));
	Medium.tymed:=TYMED_HGLOBAL;
	Medium.HGlobal:=GlobalAlloc(GHND or GMEM_SHARE,SizeOf(DROPDESCRIPTION));
	Data:=GlobalLock(Medium.HGlobal);
	Move(Descr,Data^,SizeOf(DROPDESCRIPTION));
	GlobalUnlock(Medium.HGlobal);

	Dataobject.SetData(FormatEtc,Medium,True);
end;

function Drophint(Uimage:Integer;Dataobject:IDataobject;Udescriptin:string;Umsg:string=''):Integer;
var
	Fmtetc:TFormatEtc; // specifies required data format
	Medium:TStgMedium; // storage medium containing file list
	Dr:Pdropdescription;
begin
	ZeroMemory(@Fmtetc,SizeOf(Fmtetc));
	ZeroMemory(@Medium,SizeOf(Medium));
	ZeroMemory(@Dr,SizeOf(Dr));
	Fmtetc.cfFormat:=Registerclipboardformat(Cfstr_dropdescription);
	Fmtetc.ptd:=nil;
	Fmtetc.dwAspect:=DVASPECT_CONTENT;
	Fmtetc.lindex:=-1;
	Fmtetc.tymed:=TYMED_HGLOBAL;
	Medium.tymed:=TYMED_HGLOBAL;
	Medium.HGlobal:=GlobalAlloc(GHND,SizeOf(DROPDESCRIPTION));
	Dr:=GlobalLock(Medium.HGlobal);
	Dr.&type:=Uimage;
	if (Umsg='') then begin
		case Uimage of
			Dropimage_invalid:Umsg:='%1';
			DROPIMAGE_NONE:Umsg:='%1';
			DROPIMAGE_COPY:Umsg:=' '+SFL1(150)+'%1';
			DROPIMAGE_MOVE:Umsg:=' '+SFL1(151)+'%1';
			DROPIMAGE_LINK:Umsg:=' '+SFL1(152)+'%1';
			DROPIMAGE_LABEL:Umsg:=' '+SFL1(153)+'%1';
			Dropimage_warning:Umsg:='%1';
			Dropimage_noimage:Umsg:='%1';
		end;
	end
	else Umsg:=' '+Umsg+'%1';
	Strlcopy(Dr.szMessage,Pchar(Umsg),MAX_PATH);
	Strlcopy(Dr.szInsert,Pchar(Udescriptin),MAX_PATH);
	GlobalUnlock(Medium.HGlobal);
	Dataobject.SetData(Fmtetc,Medium,True);
	Releasestgmedium(Medium);
	case Uimage of
		Dropimage_invalid:Result:=DROPEFFECT_NONE;
		DROPIMAGE_NONE:Result:=DROPEFFECT_NONE;
		DROPIMAGE_COPY:Result:=DROPEFFECT_COPY;
		DROPIMAGE_MOVE:Result:=DROPEFFECT_MOVE;
		DROPIMAGE_LINK:Result:=DROPEFFECT_LINK;
		DROPIMAGE_LABEL:Result:=DROPEFFECT_COPY;
		Dropimage_warning:Result:=DROPEFFECT_NONE;
		Dropimage_noimage:Result:=Dropeffect_scroll;
	end;
end;

function PRPolicy(RFC:string):Integer;
begin
	Result:=0;
	if CharInSet(RFC[1],['2','6']) then Result:=StrToInt64Def(SFR1(7),0)
	else if CharInSet(RFC[1],['1','5']) then Result:=StrToInt64Def(SFR1(8),0)
	else if CharInSet(RFC[1],['3','4']) then Result:=StrToInt64Def(SFR1(9),0);
end;

function NewItem(const aSrcItem:string):HResult;
var
	lFileOperation:IFileOperation;
	psiTo:IShellItem;
begin
	Result:=CoInitializeEx(nil,COINIT_APARTMENTTHREADED or COINIT_DISABLE_OLE1DDE);
	if Succeeded(Result) then begin
		Result:=CoCreateInstance(CLSID_FileOperation,nil,CLSCTX_ALL,IFileOperation,lFileOperation);
		if Succeeded(Result) then begin
			Result:=lFileOperation.SetOperationFlags(FOF_NO_UI);
			if Succeeded(Result) then begin
				Result:=SHCreateItemFromParsingName(Pchar(aSrcItem),nil,IShellItem,psiTo);
				if Succeeded(Result) then Result:=lFileOperation.NewItem(psiTo,0,'DAS00.arpr','DAS0.arpr',nil);
				if Succeeded(Result) then Result:=lFileOperation.PerformOperations;
			end;
			lFileOperation:=nil;
		end;
		CoUninitialize;
		SetFileAttributes('C:\Users\MICLE\Desktop\DAS1.arpr',FILE_ATTRIBUTE_HIDDEN or FILE_ATTRIBUTE_READONLY);
	end;
end;

function GetFileInUseInfo(const FileName:string):IFileIsInUse;
var
	ROT:IRunningObjectTable;
	mFile,enumIndex,Prefix:IMoniker;
	enumMoniker:IEnumMoniker;
	MonikerType:Longint;
	unkInt:IInterface;
begin
	Result:=nil;
	OleCheck(GetRunningObjectTable(0,ROT));
	OleCheck(CreateFileMoniker(PWideChar(FileName),mFile));
	OleCheck(ROT.EnumRunning(enumMoniker));
	while (enumMoniker.Next(1,enumIndex,nil)=S_OK) do begin
		OleCheck(enumIndex.IsSystemMoniker(MonikerType));
		if MonikerType=MKSYS_FILEMONIKER then
			if Succeeded(mFile.CommonPrefixWith(enumIndex,Prefix))and(mFile.IsEqual(Prefix)=S_OK) then
				if Succeeded(ROT.GetObject(enumIndex,unkInt)) then
					if Succeeded(unkInt.QueryInterface(IID_IFileIsInUse,Result)) then begin
						Result:=unkInt as IFileIsInUse;
						SHOWMESSAGE('IFileIsInUse');
						EXIT;
					end;
	end;
end;

function RegisterThisAppRunAsInteractiveUser(pszCLSID:string):HResult;
var
	szModule: array [0..MAX_PATH-1] of Char;
	szKey:string;
	hk:HKEY;
	LS:Integer;
begin
	Result:=E_INVALIDARG;
	if (GetModuleFileName(HINSTANCE,szModule,Length(szModule))>0) then begin
		szKey:='Software\Classes\AppID';
		LS:=RegCreateKeyEx(HKEY_LOCAL_MACHINE,Pchar(szKey+'\AMD.EXE'),0,nil,0,KEY_ALL_ACCESS,0,&hk,nil);
		Result:=HRESULTFROMWIN32(LS);
		if (Succeeded(Result)) then begin
			RegSetValueEx(hk,'APPID',0,REG_SZ,Pchar(pszCLSID),(Length(pszCLSID)+1)*SizeOf(Char));
			RegCloseKey(hk);
		end;

		LS:=RegCreateKeyEx(HKEY_LOCAL_MACHINE,Pchar(szKey+'\'+pszCLSID),0,nil,0,KEY_ALL_ACCESS,0,&hk,nil);
		Result:=HRESULTFROMWIN32(LS);
		if Succeeded(Result) then begin
			RegSetValueEx(hk,'RunAs',0,REG_SZ,Pchar('Interactive User'),(Length('Interactive User')+1)*SizeOf(Char));
			RegCloseKey(hk);
		end;

		LS:=RegCreateKeyEx(HKEY_CLASSES_ROOT,Pchar('CLSID\'+pszCLSID+'\InProcServer32'),0,nil,0,KEY_ALL_ACCESS,0,&hk,nil);
		Result:=HRESULTFROMWIN32(LS);
		if Succeeded(Result) then begin
			RegSetValueEx(hk,'',0,REG_SZ,@szModule,(Length(szModule)+1)*SizeOf(Char));
			RegSetValueEx(hk,'ThreadingModel',0,REG_SZ,Pchar('Both'),(Length('Both')+1)*SizeOf(Char));
			RegCloseKey(hk);
		end;
	end
	else Result:=HRESULTFROMWIN32(GetLastError());
end;

procedure RegisterFileIsInUse(const AFileName:string);
var
	ROT:IRunningObjectTable;
	hr:HResult;
	mk:IMoniker;
	FileIsInUse:IFileIsInUse;
begin
	CoInitializeEx(nil,COINIT_MULTITHREADED);
	hr:=GetRunningObjectTable(0,ROT);
	if Succeeded(hr) then begin
		hr:=CreateFileMoniker(Pchar(AFileName),mk);
		if Succeeded(hr) then begin
			FileIsInUse:=TFileIsInUseImpl.Create(AFileName);
			hr:=ROT.Register(ROTFLAGS_REGISTRATIONKEEPSALIVE or ROTFLAGS_ALLOWANYCLIENT,FileIsInUse,mk,Cookie);
			if hr=CO_E_WRONG_SERVER_IDENTITY then hr:=ROT.Register(ROTFLAGS_REGISTRATIONKEEPSALIVE,FileIsInUse,mk,Cookie);
			// if SUCCEEDED(hr) then
			// FRegisteredFiles.Add(AFileName,TRegisteredFile.Create(Cookie,FileIsInUse));
		end;
	end;
	CoUninitialize;
end;

procedure UNRegisterFileIsInUse(const AFileName:string);
var
	ROT:IRunningObjectTable;
begin
	if Succeeded(GetRunningObjectTable(0,ROT)) then ROT.Revoke(Cookie);
end;

constructor TFileIsInUseImpl.Create(const AFileName:string);
begin
	fFileName:=AFileName;
end;

function TFileIsInUseImpl.GetAppName(var ppszName:LPWSTR):HResult;
begin
	SHOWMESSAGE('GetAppName');
	Result:=S_OK;
	ppszName:='AMD.EXE';
end;

function TFileIsInUseImpl.GetUsage(var pfut:Integer):HResult;
begin
	SHOWMESSAGE('GetUsage');
	pfut:=FUT_EDITING;
	Result:=S_OK;
end;

function TFileIsInUseImpl.GetCapabilities(var pdwCapFlags:DWORD):HResult;
begin
	SHOWMESSAGE('GetCapabilities');
	pdwCapFlags:=OF_CAP_CANSWITCHTO or OF_CAP_CANCLOSE;
	Result:=S_OK;
end;

function TFileIsInUseImpl.GetSwitchToHWND(var phwnd:HWND):HResult;
begin
	SHOWMESSAGE('GetSwitchToHWND');
	phwnd:=Application.Handle;
	Result:=S_OK;
end;

function TFileIsInUseImpl.CloseFile:HResult;
begin
	SHOWMESSAGE('Close'+#13+fFileName);
	SendMessage(Application.Handle,WM_FILEINUSE_CLOSEFILE,0,0);
	Result:=S_OK;
end;

function AllFiles(Fold:string):string;
var
	SR:TSearchRec;
	DirList:TStrings;
begin
	Result:='';
	if (Fold<>'') then begin
		DirList:=Tstringlist.Create;
		try
			if FindFirst(Fold+'*.*',faArchive,SR)=0 then begin
				repeat DirList.Add(SR.Name);
				until FindNext(SR)<>0;
				FindClose(SR);
			end;
			Result:=DirList.Text;
		finally DirList.Free;
		end;
	end;
end;

function bmp2emf(Bitmap:TBitmap):TMetaFile;
// Converts a Bitmap to a Enhanced Metafile (*.emf)
var
	MetaCanvas:TMetafileCanvas;
begin
	Result:=TMetaFile.Create;
	Bitmap:=TBitmap.Create;
	Result.Height:=Bitmap.Height;
	Result.Width:=Bitmap.Width;
	MetaCanvas:=TMetafileCanvas.Create(Result,0);
	MetaCanvas.Draw(0,0,Bitmap);
	MetaCanvas.Free;
end;

procedure LoadFromXML(FDQuery:TFDQuery;Fil:string;Index:Integer);
var
	SS,SS1:TStringStream;
	SF:TFileStream;
	XmlDoc:IXmlDOMDocument;
	Node:IXmlDomNode;
	Element:IXmlDomElement;
	stm:IStream;
	kl:HResult;
	StaStg:TStatStg;
	DD:Pointer;
	SZ,f:Integer;
	SD:string;
begin
	if FDQuery.Active then FDQuery.Close;
	// kl:=SHCreateStreamOnFileEx(Pchar(Fil),STGM_READWRITE or STGM_SHARE_EXCLUSIVE,0,False,nil,stm);
	XmlDoc:=CoDomDocument.Create;
	// XmlDoc.Async:=False;
	// if XmlDoc.load(stm) then ShowMessage('DONE');  or fmShareExclusive
	SF:=TFileStream.Create(Fil,fmOpenRead);
	SS1:=TStringStream.Create;
	SS1.CopyFrom(SF,SF.Size);
	SD:=DEC1(SS1.DataString);
	try
		XmlDoc.loadXML(SD);
		// XmlDoc.load('file://'+Fil);
		Node:=XmlDoc.documentElement.childNodes[Index];
		SS:=TStringStream.Create;
		SS.Clear;
		SS.WriteString(Node.xml);
		FDQuery.LoadFromStream(SS,sfXML);
	finally
		SS.Free;
		SS1.Free;
		SF.Free;
	end;
end;

procedure SaveToXML(FDQuery:TFDQuery;Fil:string);
var
	SS:TStringStream;
	XmlDoc1,XMlDoc2:IXMLDOMDocument2;
	nDestination:IXmlDomNode;
	el:IXmlDomElement;
begin
	SS:=TStringStream.Create;
	XmlDoc1:=CoDomDocument.Create;
	try
		FDQuery.SaveToStream(SS,sfXML);
		XmlDoc1.loadXML(SS.DataString);
		XMlDoc2:=CoDomDocument.Create;
		if FileExists(Fil) then XMlDoc2.load(Fil)
		else XMlDoc2.loadXML('<?xml version="1.0" encoding="utf-8"?><Data/>');
		// .cloneNode(True) childNodes[0]
		nDestination:=XmlDoc1.documentElement.childNodes[0];
		nDestination:=XMlDoc2.documentElement.appendChild(nDestination);
		XMlDoc2.save(Fil);
	finally SS.Free;
	end;
end;

procedure PROBMP(BMP:TBitmap;NewWidth,NewHeight:Integer;MG:Integer);
var
	MR:Integer;
	buffer:TBitmap;
begin
	if MG=0 then MR:=Round(NewWidth*(15/885))
	ELSE MR:=MG;
	buffer:=TBitmap.Create;
	try
		buffer.SetSize(NewWidth,NewHeight);
		buffer.Canvas.Brush.Color:=clBlack;
		buffer.Canvas.FillRect(Rect(0,0,MR,buffer.Height));
		buffer.Canvas.FillRect(Rect(0,0,buffer.Width,MR));
		buffer.Canvas.FillRect(Rect(buffer.Width-MR,0,buffer.Width,buffer.Height));
		buffer.Canvas.FillRect(Rect(0,buffer.Height-MR,buffer.Width,buffer.Height));
		buffer.Canvas.StretchDraw(Rect(MR,MR,NewWidth-MR,NewHeight-MR),BMP);
		BMP.SetSize(NewWidth,NewHeight);
		BMP.Canvas.Draw(0,0,buffer);
	except

	end;
end;

function APROP:string;
var
	XmlDoc1:IXMLDOMDocument2;
	PDL,PD,el,kl,OL:IXmlDomElement;
begin
	Result:='';
	XmlDoc1:=CoDomDocument.Create;
	XmlDoc1.documentElement:=XmlDoc1.createElement('schema');
	XmlDoc1.documentElement.setAttribute('xmlns','http://schemas.microsoft.com/windows/2006/propertydescription');
	XmlDoc1.documentElement.setAttribute('schemaVersion','1.0');
	PDL:=XmlDoc1.createElement('propertyDescriptionList');
	PDL.setAttribute('publisher','AMDZ');
	PDL.setAttribute('product','AMD');
	XmlDoc1.documentElement.appendChild(PDL as IXmlDomNode);

	PD:=XmlDoc1.createElement('propertyDescription');
	PD.setAttribute('name','AMD.PropGroup.Details');
	PD.setAttribute('formatID','{26EF0FE7-6ECD-413E-82CA-9AA31F038841}');
	PD.setAttribute('propID','2');
	PDL.appendChild(PD as IXmlDomNode);

	el:=XmlDoc1.createElement('searchInfo');
	el.setAttribute('inInvertedIndex','false');
	el.setAttribute('isColumn','false');
	PD.appendChild(el as IXmlDomNode);

	el:=XmlDoc1.createElement('typeInfo');
	el.setAttribute('type','Null');
	el.setAttribute('isGroup','true');
	PD.appendChild(el as IXmlDomNode);

	el:=XmlDoc1.createElement('labelInfo');
	el.setAttribute('label','ÍÇáÉ ÇáãÓÊäÏ');
	PD.appendChild(el as IXmlDomNode);

	PD:=XmlDoc1.createElement('propertyDescription');
	PD.setAttribute('name','AMD.Delivered');
	PD.setAttribute('formatID','{26EF0FE7-6ECD-413E-82CA-9AA31F038841}');
	PD.setAttribute('propID','3');
	PDL.appendChild(PD as IXmlDomNode);

	el:=XmlDoc1.createElement('searchInfo');
	el.setAttribute('inInvertedIndex','true');
	el.setAttribute('isColumn','true');
	el.setAttribute('isColumnSparse','true');
	el.setAttribute('columnIndexType','OnDiskAll');
	el.setAttribute('groupingRange','Alphanumeric');
	el.setAttribute('mnemonics','AMD|AMSZ|AMDZ');
	PD.appendChild(el as IXmlDomNode);

	el:=XmlDoc1.createElement('typeInfo');
	el.setAttribute('type','UInt32');
	el.setAttribute('multipleValues','false');
	el.setAttribute('isGroup','false');
	el.setAttribute('isViewable','true');
	el.setAttribute('conditionType','Number');
	el.setAttribute('defaultOperation','Contains');
	el.setAttribute('searchRawValue','true');
	PD.appendChild(el as IXmlDomNode);

	el:=XmlDoc1.createElement('labelInfo');
	el.setAttribute('label','ÍÇáÉ ÇáÊæÕíá');
	el.setAttribute('invitationText','ÊÍÏíÏ ÍÇáÉ ÇáÊæÕíá');
	el.setAttribute('sortDescription','SmallestLargest');
	PD.appendChild(el as IXmlDomNode);

	el:=XmlDoc1.createElement('displayInfo');
	el.setAttribute('displayType','Enumerated');
	el.setAttribute('alignment','Center');
	el.setAttribute('relativeDescriptionType','Count');
	PD.appendChild(el as IXmlDomNode);

	kl:=XmlDoc1.createElement('editControl');
	kl.setAttribute('control','DropList');
	el.appendChild(kl as IXmlDomNode);

	kl:=XmlDoc1.createElement('enumeratedList');
	kl.setAttribute('useValueForDefault','true');
	el.appendChild(kl as IXmlDomNode);

	OL:=XmlDoc1.createElement('enum');
	OL.setAttribute('value','0');
	OL.setAttribute('text','Êã ÇáÊÓáíã');
	kl.appendChild(OL as IXmlDomNode);

	OL:=XmlDoc1.createElement('enum');
	OL.setAttribute('value','1');
	OL.setAttribute('text','Ýí ÇáÇäÊÙÇÑ');
	kl.appendChild(OL as IXmlDomNode);

	OL:=XmlDoc1.createElement('enum');
	OL.setAttribute('value','2');
	OL.setAttribute('text','ÊÓáã ÌÒÁ');
	kl.appendChild(OL as IXmlDomNode);

	OL:=XmlDoc1.createElement('enum');
	OL.setAttribute('value','3');
	OL.setAttribute('text','ÇáÛÇÁ');
	kl.appendChild(OL as IXmlDomNode);

	Result:=XmlDoc1.xml;
	XmlDoc1.save('C:\Users\MICLE\Desktop\AMD.propdesc');
	XmlDoc1.save('C:\Users\MICLE\Desktop\AMD.xml');
end;

function CPROP(EXT:string):string;
	procedure AElm(XL:IXMLDOMDocument2;V0,V1:string;V2:Word;V3:string;V4:string='');
	var
		EM:IXmlDomElement;
	begin
		EM:=XL.createElement(V0);
		EM.setAttribute('ISW',V1);
		EM.setAttribute('KN',IntToStr(V2));
		EM.setAttribute('TX',V3);
		EM.setAttribute('TX1',V4);
		XL.documentElement.appendChild(EM as IXmlDomNode);
	end;
	function RegToStr(Subkey,Value:string;KEY:HKEY=HKEY_CLASSES_ROOT):string;
	var
		Xbuffer_size,rslt:Longword;
		Xbuffer: array [Word] of Char;
		Key1:HKEY;
	begin
		Result:='';
		Xbuffer:='';
		if not(RegOpenKeyEx(KEY,Pchar(Subkey),0,1,Key1)=0) then begin
			EXIT;
		end else begin
			Xbuffer_size:=MAXWORD+2;
		end;
		rslt:=RegQueryValueEx(Key1,Pchar(Value),0,nil,@Xbuffer,@Xbuffer_size);
		case rslt of
			ERROR_FILE_NOT_FOUND:Result:='';
			ERROR_MORE_DATA: while (rslt=ERROR_MORE_DATA) do begin
					Xbuffer_size:=Xbuffer_size+2;
					rslt:=RegQueryValueEx(Key1,Pchar(Value),0,nil,@Xbuffer,@Xbuffer_size);
				end;
			0:Result:=Xbuffer;
		end;
		RegCloseKey(KEY);
	end;

var
	XmlDoc1:IXMLDOMDocument2;
	eDestination,el:IXmlDomElement;
	SM:FILETIME;
	H,L:string;
begin
	Result:='';
	GetSystemTimeAsFileTime(SM);
	L:=IntToStr(SM.dwLowDateTime);
	H:=IntToStr(SM.dwHighDateTime);
	XmlDoc1:=CoDomDocument.Create;
	XmlDoc1.documentElement:=XmlDoc1.createElement('PROP');

	AElm(XmlDoc1,'System.Title','0',VT_LPWSTR,'AMD_Title');
	AElm(XmlDoc1,'System.Subject','0',VT_LPWSTR,'AMD_SUBJECT');
	AElm(XmlDoc1,'System.Project','0',VT_LPWSTR,'AMD_PROJECT');
	AElm(XmlDoc1,'System.Rating','0',VT_UI4,'99');
	AElm(XmlDoc1,'System.RatingText','0',VT_LPWSTR,'');
	AElm(XmlDoc1,'System.Keywords','0',VT_VECTOR or VT_LPWSTR,'000;AHG_K2;K3;GG;777;');
	AElm(XmlDoc1,'System.Category','0',VT_VECTOR or VT_LPWSTR,'AMD_CATEGORY;DF;999;');
	AElm(XmlDoc1,'System.Comment','0',VT_LPWSTR,Tts('E:\Eula.txt'));

	AElm(XmlDoc1,'System.Author','0',VT_VECTOR or VT_LPWSTR,'AMD ATH;AHG_YOU;POI');
	AElm(XmlDoc1,'System.Document.LastAuthor','0',VT_LPWSTR,'AMD_LAST');
	AElm(XmlDoc1,'System.SourceItem','0',VT_LPWSTR,'AMD_SOURCE');
	AElm(XmlDoc1,'System.Document.Version','0',VT_LPWSTR,'1.9.9.5');
	AElm(XmlDoc1,'System.Trademarks','0',VT_LPWSTR,'AMD_AMDZ');
	AElm(XmlDoc1,'System.DRM.Description','0',VT_LPWSTR,'AMDZ COMPANY FOR PROGRAMS');
	AElm(XmlDoc1,'System.Copyright','0',VT_LPWSTR,'AMD_COPYRIGHT');
	AElm(XmlDoc1,'System.ApplicationName','0',VT_LPWSTR,'AMD_APP');
	AElm(XmlDoc1,'System.SoftwareUsed','0',VT_LPWSTR,'AMD_APP');
	AElm(XmlDoc1,'System.Company','0',VT_LPWSTR,'AMD_AMDZ');
	AElm(XmlDoc1,'System.Document.Manager','0',VT_LPWSTR,'AMD_Manager');
	AElm(XmlDoc1,'System.Language','0',VT_LPWSTR,'AMD_LAN');

	AElm(XmlDoc1,'System.ContentStatus','0',VT_LPWSTR,'AMD_CS');
	AElm(XmlDoc1,'System.ContentType','0',VT_LPWSTR,RegToStr(EXT,'Content Type'));
	AElm(XmlDoc1,'System.Kind','0',VT_LPWSTR,RegToStr(EXT,'PerceivedType'));
	AElm(XmlDoc1,'System.Document.Template','0',VT_LPWSTR,'AMD_DOC');

	AElm(XmlDoc1,'System.DRM.IsProtected','0',VT_BOOL,'1');
	AElm(XmlDoc1,'System.IsEncrypted','0',VT_BOOL,'0');
	AElm(XmlDoc1,'System.IsIncomplete','0',VT_BOOL,'0');
	AElm(XmlDoc1,'System.Priority','0',VT_UI2,'2');

	AElm(XmlDoc1,'System.Message.SenderName','0',VT_LPWSTR,'AMD_SENDER');
	AElm(XmlDoc1,'System.Message.SenderAddress','0',VT_LPWSTR,'AMD_SENDER_ADDRESS');
	AElm(XmlDoc1,'System.Message.ToDoTitle','0',VT_LPWSTR,'AMD_ToDoTitle');
	AElm(XmlDoc1,'System.Message.ToName','0',VT_VECTOR or VT_LPWSTR,'N1;N2;N3');
	AElm(XmlDoc1,'System.Message.Store','0',VT_LPWSTR,'AMD_CS');
	AElm(XmlDoc1,'System.Document.RevisionNumber','0',VT_LPWSTR,'144.2.0');
	AElm(XmlDoc1,'System.Document.ClientID','0',VT_LPWSTR,'AMD_ClientID');
	AElm(XmlDoc1,'System.Document.Division','0',VT_LPWSTR,'AMD_Division');
	AElm(XmlDoc1,'System.Document.DocumentID','0',VT_LPWSTR,'AMD_DocumentID');
	AElm(XmlDoc1,'System.Document.SlideCount','0',VT_I4,'10');

	AElm(XmlDoc1,'System.Document.DateCreated','0',VT_FILETIME,L,H);
	AElm(XmlDoc1,'System.Document.DateSaved','0',VT_FILETIME,L,H);
	AElm(XmlDoc1,'System.Document.DatePrinted','0',VT_FILETIME,L,H);
	AElm(XmlDoc1,'System.DeviceInterface.PrinterName','0',VT_LPWSTR,'AMD_PrinterName');
	AElm(XmlDoc1,'System.Document.TotalEditingTime','0',VT_UI8,'108000000000'); // SEC * 10 000 000
	AElm(XmlDoc1,'System.Media.Year','0',VT_UI4,'1995');
	AElm(XmlDoc1,'System.StartDate','0',VT_FILETIME,L,H);
	AElm(XmlDoc1,'System.EndDate','0',VT_FILETIME,L,H);

	AElm(XmlDoc1,'System.ShareUserRating','0',VT_UI4,'99');
	AElm(XmlDoc1,'System.SharingStatus','0',VT_UI4,'1');

	AElm(XmlDoc1,'PASS','0',VT_LPWSTR,'D41D8CD98F00B204E9800998ECF8427E');
	// AMDF.Image1.Picture.LoadFromFile('C:\Users\MICLE\Desktop\DAA.bmp');

	// AElm(XmlDoc1,'Thumbnail','0',VT_STREAM,Base64FromBitmap(PROBMP(AMDF.Image1.Picture.Bitmap)));

	// XmlDoc1.save('C:\Users\MICLE\Desktop\XXX.amdz');
	// Base64FromBitmap(AMDF.Image1.Picture)
	Result:=XmlDoc1.xml;
end;

function Base64FromBitmap(BMP:TBitmap):string;
var
	Stream:TBytesStream;
	SS:TStringStream;
	Encoding:TBase64Encoding;
begin
	Stream:=TBytesStream.Create;
	try
		BMP.SaveToStream(Stream);
		Encoding:=TBase64Encoding.Create(0);
		try Result:=Encoding.EncodeBytesToString(Stream.Bytes);
		finally Encoding.Free;
		end;
	finally Stream.Free;
	end;
end;

procedure BitmapFromBase64(Info:string;VAR BMP:TBitmap);
var
	Stream:TBytesStream;
	Bytes:TBytes;
	Encoding:TBase64Encoding;
begin
	Stream:=TBytesStream.Create;
	try
		Encoding:=TBase64Encoding.Create(0);
		try
			Bytes:=Encoding.DecodeStringToBytes(Info);
			Stream.WriteData(Bytes,Length(Bytes));
			Stream.Position:=0;
			BMP.LoadFromStream(Stream);
		finally Encoding.Free;
		end;
	finally Stream.Free;
	end;
end;

function IntToBin(I:Integer):string;
begin
	Result:='';
	while I>0 do begin
		Result:=Chr(Ord('0')+(I and 1))+Result;
		I:=I shr 1;
	end;
	while Length(Result)<8 do Result:='0'+Result;
end;

function ATO(HN:HWND;LS:TStrings;RTL:Boolean=False;Search:Boolean=False):IAutoCompleteDropDown;
var
	LStrings:IUnknown;
	Lac2:IAutoComplete2;
	FAutoComplete:IAutoComplete;
	OM:IObjMgr;
	Fflug:Cardinal;
begin
	Result:=nil;
	Fflug:=(ACO_AUTOAPPEND or ACO_UPDOWNKEYDROPSLIST or ACO_AUTOSUGGEST or ACO_USETAB or ACO_NOPREFIXFILTERING or
		ACO_WORD_FILTER);
	if RTL then Fflug:=Fflug or ACO_RTLREADING;
	if Search then Fflug:=Fflug or ACO_SEARCH;
	FAutoComplete:=CreateComObject(CLSID_AutoComplete) as IAutoComplete;
	OM:=CreateComObject(CLSID_ACLMulti) as IObjMgr;
	LStrings:=TEnumString.Create(LS);
	OM.Append(LStrings);
	OM.Append(LStrings);
	OleCheck(FAutoComplete.Init(HN,OM,nil,nil));
	if Supports(FAutoComplete,IAutoComplete2,Lac2) then OleCheck(Lac2.SetOptions(Fflug));
	Supports(FAutoComplete,IAutoCompleteDropDown,Result);

end;

function AMDS(O:Integer;CMH,Cl:string;var LUG:TFDStringArray):Integer;
var
	Mx,I:Integer;
begin
	Result:=0;
	try
		if (O>-1)and(CMH<>'')and(Cl<>'') then begin
			FQ[O].Open('SELECT '+Cl+' FROM '+CMH);
			Mx:=FQ[O].RowsAffected;
			if (Mx<>0) then begin
				SetLength(LUG,Mx+1);
				for I:=1 to Mx do begin
					LUG[I]:=FQ[O].Fields[0].Asstring;
					FQ[O].Next;
				end;
			end;
			Result:=Mx;
		end;
	except
		on E:Exception do SHOWMESSAGE(Mx.Tostring+#13+E.Tostring);
	end;
end;

function TLL1(UCol:TStrings):Extended;
var
	I:Integer;
begin
	Result:=0;
	try
		for I:=1 to UCol.Count-1 do begin
			Result:=Result+StrToUInt64def(Trim(UCol.Strings[I]),0);
		end;
	except
		on E:Exception do
	end;
end;

function TLL2(UCol:TStrings):Extended;
var
	S,S1:string;
begin
	Result:=0;
	try
		if (UCol.Count>1) then begin
			S:=UCol.Commatext;
			S:=Copy(S,Pos(',',S)+1,Maxint);
			CN[2].Execsql('DROP TABLE IF EXISTS TLO');
			CN[2].Execsql(Ct1+'TLO ('+Idn1+',CODE'+Tn1+')');
			S:=Stringreplace(S,',,',',',[Rfreplaceall]);
			if (Copy(S,Length(S),1)=',') then begin
				S:=Copy(S,1,Length(S)-1);
			end;
			if (Copy(S,1,1)=',') then begin
				S:=Copy(S,2,Maxint);
			end;
			S1:='INSERT INTO TLO (CODE) VALUES ("'+Stringreplace(S,',','"),("',[Rfreplaceall])+'")';
			CN[2].Execsql(S1);
			FQ[2].Open('SELECT avg(AM3) from (SELECT TLO.CODE AS AM2, NIT.VAT AS AM3 FROM TLO '+
				'INNER JOIN NIT ON TLO.CODE = NIT.CODE)');
			Result:=NE(FQ[2].Fields[0].Asstring);
			CN[2].Execsql('DROP TABLE IF EXISTS TLO');
		end;
	except
		on E:Exception do
	end;
end;

function FLSH(HWIN:HWND;HDWFlags,HuCount:Cardinal):Boolean;
var
	Fwinfo:Tflashwinfo;
begin
	Result:=False;
	with Fwinfo do begin
		Cbsize:=SizeOf(Fwinfo); // Size of structure in bytes
		HWND:=HWIN; // Main's form handle
		Dwflags:=HDWFlags; // Flash both caption & task bar
		Ucount:=HuCount; // Flash 10 times
		Dwtimeout:=75; // Timeout is 1/10 second apart
	end;
	Result:=Flashwindowex(Fwinfo);
end;

function SR0(S:string):string;
begin
	Result:=Stringreplace(S,'[FireDAC][Phys][SQLite] ERROR:','',[Rfreplaceall]);
	Result:=Copy(Result,0,Pos(':',Result));
	if (Result=' UNIQUE constraint failed:') then begin
		Result:='W';
	end;
end;

function TxToHY(UText1,ULink:string):string;
begin
	Result:='';
	try Result:='<a href="'+ULink+'">'+UText1+'</a>';
	except
		on E:Exception do Result:='';
	end;
end;

function SIC1(ID:Integer;BG:Integer=0;LIB:Integer=0):HIcon;
var
	Hmod:HModule;
	LB:Pchar;
begin
	try
		case BG of
			0:BG:=32;
			1:BG:=16;
		end;
		case LIB of
			0:LB:=Pchar(Amz_logo);
			1:LB:=Pchar(IMG_logo);
		end;
		Hmod:=Loadlibraryex(LB,0,Load_library_as_datafile);
		LIWSDown(Hmod,Makeintresource(ID),BG,BG,Result);
		Freelibrary(Hmod);
	except
		on E:Exception do SHOWMESSAGE('SIC1'+#13+E.Tostring);
	end;
end;

function SIC2(UCur:HIcon;UText:string):Ticon;
var
	BMP,Bmp1,T1,Ma:TBitmap;
	Im:TImageList;
	Da:Timage;
begin
	BMP:=TBitmap.Create;
	Bmp1:=TBitmap.Create;
	Ma:=TBitmap.Create;
	Ma.Pixelformat:=Pf24bit;
	T1:=TBitmap.Create;
	Im:=TImageList.Create(AMDF);
	Result:=Ticon.Create;
	Da:=Timage.Create(AMDF);
	try
		Result.Transparent:=True;
		BMP.Pixelformat:=Pf24bit;
		Bmp1.Pixelformat:=Pf32bit;
		T1.Pixelformat:=Pf32bit;
		{ Bmp.Transparent:=True;
			Bmp1.Transparent:=True;
			T1.Transparent:=True;
			Bmp.TransparentColor:=clRed;
			Bmp1.TransparentColor:=clRed;
			T1.TransparentColor:=clRed; }
		Im.Colordepth:=Cd32bit;
		Da.Autosize:=True;
		Da.Transparent:=True;
		Da.Picture.Icon.Handle:=UCur;
		T1:=TBitmap.Create;
		T1.Pixelformat:=Pf32bit;
		T1.SetSize(Da.Width,Da.Height);
		T1.Canvas.Brush.Color:=Clblue;
		T1.Canvas.FillRect(Rect(0,0,T1.Width,T1.Height));
		T1.Canvas.Draw(0,0,Da.Picture.Graphic);
		Bmp1.SetSize(Bmp1.Canvas.Textwidth(UText)+6,Bmp1.Canvas.Textheight(UText)+4);
		BMP.SetSize(T1.Width,T1.Height);
		BMP.Canvas.Brush.Color:=Clblue;
		BMP.Canvas.FillRect(Rect(0,0,BMP.Width,BMP.Height));
		Bmp1.Canvas.Font.Charset:=178;
		Bmp1.Canvas.Font.Style:=[Fsbold];
		Bmp1.Canvas.Font.Name:=AMDF.Font.Name;
		Bmp1.Canvas.Font.Color:=ClHighlight;
		Bmp1.Canvas.Brush.Color:=Clred;
		Bmp1.Canvas.FillRect(Rect(0,0,Bmp1.Width,Bmp1.Height));
		Bmp1.Canvas.Textout(2,2,UText);
		// Bmp.Canvas.Draw(T1.Width+2,2,Bmp1);
		// Bmp.Canvas.Draw(2,2,T1);
		BMP.Canvas.Font.Color:=ClHighlight;
		{ Bmp.Canvas.CopyRect(Rect(2,T1.Height+2,Bmp1.Width,Bmp1.Height),Bmp1.Canvas,
			Rect(0,0,Bmp1.Width,Bmp1.Height)); }
		BMP.Canvas.Copyrect(Rect(0,0,T1.Width,T1.Height),T1.Canvas,Rect(0,0,T1.Width,T1.Height));
		BMP.Canvas.Textout(0,T1.Height-Bmp1.Height,UText);
		Ma.Assign(T1);
		Ma.Canvas.Brush.Color:=Clblue;
		Ma.Monochrome:=True;
		Im.Width:=BMP.Width;
		Im.Height:=BMP.Height;
		Im.Add(T1,nil);
		Im.Add(T1,Ma);
		Im.Add(T1,Ma);
		Im.Add(T1,Ma);
		Im.Geticon(2,Result);
		// ShowMessage(Result.Height.ToString+' , '+Result.Width.ToString);
		BMP.Free;
		T1.Free;
		Da.Free;
		Bmp1.Free;
		Im.Free;
	except
		on E:Exception do SHOWMESSAGE(E.Tostring);
	end;
end;

function DTD1(RFC:string):string;
begin
	Result:='';
	if (RFC<>'') then begin
		try
			FQ[2].Open('SELECT DES FROM DOCM WHERE RFC = "'+RFC+'"');
			Result:=FQ[2].Fields[0].Asstring;
		except
			on E:Exception do
		end;
	end;
end;

function DTM1(RFC:string):string;
begin
	Result:='';
	if (RFC<>'') then begin
		try
			FQ[2].Open('SELECT MH FROM DOCM WHERE RFC = "'+RFC+'"');
			Result:=FQ[2].Fields[0].Asstring;
		except
			on E:Exception do
		end;
	end;
end;

function DTN1(RFC:string):Integer;
begin
	Result:=0;
	if (RFC<>'') then begin
		try
			FQ[2].Open('SELECT NU FROM DOCM WHERE RFC = "'+RFC+'"');
			Result:=FQ[2].Fields[0].Asinteger;
		except
			on E:Exception do
		end;
	end;
end;

function DTL1(RFC:string):string;
begin
	Result:='';
	if (RFC<>'') then begin
		try
			FQ[2].Open('SELECT '+Lan+' FROM DOCM WHERE RFC = "'+RFC+'"');
			Result:=FQ[2].Fields[0].Asstring;
		except
			on E:Exception do
		end;
	end;
end;

function DTK1(RFC:string):string;
begin
	Result:='';
	if (RFC<>'') then begin
		try
			FQ[2].Open('SELECT KI FROM DOCM WHERE RFC = "'+RFC+'"');
			Result:=FQ[2].Fields[0].Asstring;
		except
			on E:Exception do
		end;
	end;
end;

function DTEX1(RFC:string):string;
begin
	Result:='';
	if (RFC<>'') then begin
		try
			FQ[2].Open('SELECT EXT FROM DOCM WHERE RFC = "'+RFC+'"');
			Result:=FQ[2].Fields[0].Asstring;
		except
			on E:Exception do
		end;
	end;
end;

function RTC1(RFC,ST1:string):UInt64;
var
	O:Integer;
begin
	Result:=0;
	O:=DTN1(RFC);
	if (ST1<>'') then begin
		try
			FQ[O].Open('SELECT MAX(ICODE) FROM '+DTM1(RFC)+' WHERE ST = "'+ST1+'" ORDER BY ICODE DESC LIMIT 1');
			Result:=FQ[O].Fields[0].Aslargeint;
		except
			on E:Exception do
		end;
	end;
end;

function SCOD1(Lang:string):string;
begin
	Result:='';
	if (Lang<>'') then begin
		try
			FQ[2].Open('SELECT CODE FROM NACC WHERE '+Lan+' = "'+Lang+'"');
			Result:=FQ[2].Fields[0].Asstring;
		except
			on E:Exception do
		end;
	end;
end;

function SLG1(COD:string):string;
begin
	Result:='';
	if (COD<>'') then begin
		try
			FQ[2].Open('SELECT '+Lan+' FROM NACC WHERE CODE = "'+COD+'"');
			Result:=FQ[2].Fields[0].Asstring;
		except
			on E:Exception do
		end;
	end;
end;

function SBG1(COD:string):string;
begin
	Result:='';
	if (COD<>'') then begin
		try
			FQ[2].Open('SELECT BG FROM NACC WHERE CODE = "'+COD+'"');
			Result:=FQ[2].Fields[0].Asstring;
		except
			on E:Exception do
		end;
	end;
end;

function Send1(COD:string):string;
begin
	Result:='';
	if (COD<>'') then begin
		try
			FQ[2].Open('SELECT END FROM NACC WHERE CODE = "'+COD+'"');
			Result:=FQ[2].Fields[0].Asstring;
		except
			on E:Exception do
		end;
	end;
end;

function SKI1(COD:string):string;
begin
	Result:='';
	if (COD<>'') then begin
		try
			FQ[2].Open('SELECT KI FROM NACC WHERE CODE = "'+COD+'"');
			Result:=FQ[2].Fields[0].Asstring;
		except
			on E:Exception do
		end;
	end;
end;

function SAC1(COD:string):string;
begin
	Result:='';
	if (COD<>'') then begin
		try
			FQ[2].Open('SELECT MH FROM NACC WHERE CODE = "'+COD+'"');
			Result:=FQ[2].Fields[0].Asstring;
		except
			on E:Exception do
		end;
	end;
end;

function SAM1(COD,ST1:string):string;
begin
	Result:='';
	if (COD<>'') then begin
		try
			FQ[5].Open('SELECT SUM(AM1) FROM '+SAC1(COD)+' WHERE ST = "'+ST1+'"');
			Result:=FQ[5].Fields[0].Asstring;
		except
			on E:Exception do
		end;
	end;
end;

function SAM2(COD,ST1:string):string;
begin
	Result:='';
	if (COD<>'') then begin
		try
			FQ[5].Open('SELECT SUM(AM2) FROM '+SAC1(COD)+' WHERE ST = "'+ST1+'"');
			Result:=FQ[5].Fields[0].Asstring;
		except
			on E:Exception do
		end;
	end;
end;

function SCCE1(ID:string):string;
begin
	Result:='';
	if (ID<>'') then begin
		try
			FQ[2].Open('SELECT '+Lan+' FROM NCCE WHERE id = "'+ID+'" AND REF="1"');
			Result:=FQ[2].Fields[0].Asstring;
		except
			on E:Exception do
		end;
	end;
end;

function SCCE2(Lang:string):string;
begin
	Result:='0';
	if (Lang<>'') then begin
		try
			FQ[2].Open('SELECT id FROM NCCE WHERE '+Lan+' = "'+Lang+'" AND REF="1"');
			Result:=FQ[2].Fields[0].Asstring;
		except
			on E:Exception do
		end;
	end;
end;

function NOL1(NU:string):Extended;
var
	G,K1:Integer;
begin
	Result:=0;
	K1:=0;
	try
		if (NU='') then begin
			Result:=0;
			EXIT;
		end;
		if not CharInSet(NU[1],['0'..'9','-']) then begin
			Result:=0;
			EXIT;
		end;
		for G:=2 to Length(NU) do begin
			if CharInSet(NU[G],['0'..'9','.']) then begin
				K1:=K1+0;
				if (NU[G]='.') then begin
					K1:=K1+1;
				end;
			end else begin
				Result:=0;
				EXIT;
			end;
		end;
		if (K1<2) then begin
			Result:=NU.Toextended;
		end;
	except
		on E:Exception do Result:=0;
	end;
end;

function NE(NU:string):Extended;
begin
	try
		Result:=NOL1(NU);
		if (Result<0) then Result:=-Result;
	except
		on E:Exception do Result:=0;
	end;
end;

function NA(NU:string):UInt64;
begin
	try Result:=Trunc(NE(NU));
	except
		on E:Exception do Result:=0;
	end;
end;

function NL(NU:string):UInt64;
begin
	try Result:=Strtouintdef(NU,0);
	except
		on E:Exception do Result:=0;
	end;
end;

function NUK(NU:string):string;
var
	Nr:string;
	Nu1:Extended;
begin
	try
		Nr:=SFR1(37);
		Result:='0';
		Nu1:=NE(NU);
		if (Nr='0') then begin
			Result:=Nu1.Tostring;
		end;
		if (Nr='1') then begin
			Result:=Trunc(Nu1).Tostring;
		end;
		if (Nr='2') then begin
			Result:=Round(Nu1).Tostring;
		end;
	except
		on E:Exception do Result:='0';
	end;
end;

function BL1(NU: array of UInt64):Boolean;
var
	I:Integer;
begin
	Result:=True;
	try
		for I:=low(NU) to high(NU) do begin
			if (NU[I]=0) then begin
				Result:=False;
				EXIT;
			end;
		end;
	except
		on E:Exception do Result:=True;
	end;
end;

function SFF1(CCl,MH,CCL1,TX1:string;CCL2:string='';TX2:string='';CCL3:string='';Tx3:string=''):string;
begin
	try
		Result:='';
		if (CCL2='') then begin
			CCL2:='0';
			TX2:='0';
		end else begin
			TX2:='"'+TX2+'"';
		end;
		if (CCL3='') then begin
			CCL3:='0';
			Tx3:='0';
		end else begin
			Tx3:='"'+Tx3+'"';
		end;
		if (MH<>'')and(CCl<>'')and(CCL1<>'')and(TX1<>'') then begin
			FQ[2].Open('SELECT '+CCl+' FROM '+MH+' WHERE '+CCL1+' = "'+TX1+'" AND '+CCL2+' = '+TX2+' AND '+CCL3+' = '+Tx3);
			Result:=FQ[2].Fields[0].Asstring;
		end;
	except
		on E:Exception do Result:='';
	end;
end;

function SFD1(CN1:Integer;RFC:string):string;
begin
	try
		Result:='';
		if CharInSet(RFC[1],['1'..'7'])and(CN1>0) then begin
			FQ[9].Open('SELECT CCL FROM '+DTD1(RFC)+' WHERE CN = "'+CN1.Tostring+'"');
			if (FQ[9].Fields[0].Asstring='LAN') then begin
				Result:=Lan;
			end else begin
				Result:=FQ[9].Fields[0].Asstring;
			end;
		end;
	except
		on E:Exception do Result:='';
	end;
end;

function SFD2(IX:Integer;RFC:string):Integer;
begin
	try
		Result:=0;
		if CharInSet(RFC[1],['1'..'7'])and(IX>0) then begin
			FQ[9].Open('SELECT CN FROM '+DTD1(RFC)+' WHERE IX = "'+IX.Tostring+'"');
			Result:=FQ[9].Fields[0].Aslargeint;
		end;
	except
		on E:Exception do Result:=0;
	end;
end;

function SFD4(CN1:Integer;RFC:string):Integer;
begin
	try
		Result:=0;
		if CharInSet(RFC[1],['1'..'7'])and(CN1>0) then begin
			FQ[9].Open('SELECT KN FROM '+DTD1(RFC)+' WHERE CN = "'+CN1.Tostring+'"');
			Result:=FQ[9].Fields[0].Aslargeint;
		end;
	except
		on E:Exception do Result:=0;
	end;
end;

function SFD5(CN1:Integer;RFC:string):string;
begin
	try
		Result:='';
		if CharInSet(RFC[1],['1'..'7'])and(CN1>0) then begin
			FQ[9].Open('SELECT REF FROM '+DTD1(RFC)+' WHERE CN = "'+CN1.Tostring+'"');
			Result:=FQ[9].Fields[0].Asstring;
		end;
	except
		on E:Exception do Result:='';
	end;
end;

function SFD61(IX:Integer;RFC:string):string;
begin
	try
		Result:='';
		if CharInSet(RFC[1],['1'..'7'])and(IX>0) then begin
			FQ[9].Open('SELECT REF FROM '+DTD1(RFC)+' WHERE IX = "'+IX.Tostring+'"');
			Result:=FQ[9].Fields[0].Asstring;
		end;
	except
		on E:Exception do Result:='';
	end;
end;

function SFD62(IX:Integer;RFC:string):string;
begin
	try
		Result:='';
		if CharInSet(RFC[1],['1'..'7'])and(IX>0) then begin
			FQ[9].Open('SELECT CMH FROM '+DTD1(RFC)+' WHERE IX = "'+IX.Tostring+'"');
			Result:=FQ[9].Fields[0].Asstring;
		end;
	except
		on E:Exception do Result:='';
	end;
end;

function SFD7(CN1:Integer;RFC:string):string;
begin
	try
		Result:='';
		if CharInSet(RFC[1],['1'..'7'])and(CN1>0) then begin
			FQ[9].Open('SELECT '+Lan+' FROM '+DTD1(RFC)+' WHERE CN = "'+CN1.Tostring+'"');
			Result:=FQ[9].Fields[0].Asstring;
		end;
	except
		on E:Exception do Result:='';
	end;
end;

function SFD8(IX:Integer;RFC:string):Integer;
begin
	try
		Result:=0;
		if CharInSet(RFC[1],['1'..'7'])and(IX>0) then begin
			FQ[9].Open('SELECT NU FROM '+DTD1(RFC)+' WHERE IX = "'+IX.Tostring+'"');
			Result:=FQ[9].Fields[0].Asinteger;
		end;
	except
		on E:Exception do
	end;
end;

function ITD3(IX:Integer;Lang,RFC:string):Boolean;
begin
	try
		Result:=False;
		if CharInSet(RFC[1],['1'..'7'])and(IX>0) then begin
			case CN[9].Execsql('UPDATE '+DTD1(RFC)+' SET IX = "'+IX.Tostring+'" WHERE '+Lan+' = "'+Lang+'"') of
				0:Result:=False;
				1:Result:=True;
			end;
		end;
	except
		on E:Exception do Result:=False;
	end;
end;

{ function SL1(ID:Integer):string;
	begin
	try
	Result:='';
	if (ID>0) then begin
	FQ[0].Open('SELECT '+lan+' FROM LG WHERE id = "'+ID.ToString+'"');
	Result:=FQ[0].Fields[0].AsString;
	end;
	except
	on E:Exception do Result:='';
	end;
	end;

	function SFL1(ID:Integer):string;
	begin
	try
	Result:='';
	if (ID>0) then begin
	FQ[1].Open('SELECT '+lan+' FROM LANG WHERE id = "'+ID.ToString+'"');
	Result:=FQ[1].Fields[0].AsString;
	end;
	except
	on E:Exception do Result:='';
	end;
	end; }

function SL1(ID:Integer):string;
begin
	Result:=Lng1[ID];
end;

function SFL1(ID:Integer):string;
begin
	Result:=Lng2[ID];
end;

function ITL1(ID:Integer;CUl,TX:string):Boolean;
begin
	try
		Result:=False;
		if (ID>0) then begin
			case CN[1].Execsql('UPDATE LANG SET '+CUl+' = "'+TX+'" WHERE id = "'+ID.Tostring+'"') of
				0:Result:=False;
				1:Result:=True;
			end;
		end;
	except
		on E:Exception do Result:=False;
	end;
end;

function SFR1(ID:Integer):string;
begin
	try
		Result:='';
		if (ID>0) then begin
			FQ[1].Open('SELECT rec FROM REF WHERE id = "'+ID.Tostring+'"');
			Result:=FQ[1].Fields[0].Asstring;
		end;
	except
		on E:Exception do Result:='';
	end;
end;

function ITR1(ID:Integer;RTF:string):Boolean;
begin
	try
		Result:=False;
		if (ID>0) then begin
			case CN[1].Execsql('UPDATE REF SET rec = "'+RTF+'" WHERE id = "'+ID.Tostring+'"') of
				0:Result:=False;
				1:Result:=True;
			end;
		end;
	except
		on E:Exception do Result:=False;
	end;
end;

function SFU1(ID:Integer;CUl:string):string;
begin
	try
		Result:='';
		if (ID>0)and(CUl<>'') then begin
			FQ[1].Open('SELECT '+CUl+' FROM USERS WHERE id = "'+ID.Tostring+'"');
			Result:=FQ[1].Fields[0].Asstring;
		end;
	except
		on E:Exception do Result:='';
	end;
end;

function ITU1(ID:Integer;CUl,TX:string):Boolean;
begin
	try
		Result:=False;
		if (ID>0)and(CUl<>'') then begin
			case CN[1].Execsql('UPDATE USERS SET '+CUl+' = "'+TX+'" WHERE id = "'+ID.Tostring+'"') of
				0:Result:=False;
				1:Result:=True;
			end;
		end;
	except
		on E:Exception do Result:=False;
	end;
end;

function SFJ1(ID:Integer;CUl:string):string;
begin
	try
		Result:='';
		if (ID>0)and(CUl<>'') then begin
			FQ[1].Open('SELECT '+CUl+' FROM JT WHERE id = "'+ID.Tostring+'"');
			Result:=FQ[1].Fields[0].Asstring;
		end;
	except
		on E:Exception do Result:='';
	end;
end;

function ITJ1(ID:Integer;CUl,TX:string):Boolean;
begin
	try
		Result:=False;
		if (ID>-1)and(CUl<>'') then begin
			case CN[1].Execsql('UPDATE JT SET '+CUl+' = "'+TX+'" WHERE id = "'+ID.Tostring+'"') of
				0:Result:=False;
				1:Result:=True;
			end;
		end;
	except
		on E:Exception do Result:=False;
	end;
end;

function SFM1(ID:Integer):string;
begin
	try
		Result:='';
		if (ID>0) then begin
			FQ[1].Open('SELECT '+Lan+' FROM MSJ WHERE id = "'+ID.Tostring+'"');
			Result:=FQ[1].Fields[0].Asstring;
		end;
	except
		on E:Exception do Result:='';
	end;
end;

function SFM2(ID:Integer):Integer;
begin
	try
		Result:=0;
		if (ID>0) then begin
			FQ[1].Open('SELECT REF FROM MSJ WHERE id = "'+ID.Tostring+'"');
			Result:=FQ[1].Fields[0].Aslargeint;
		end;
	except
		on E:Exception do Result:=0;
	end;
end;

function ITM1(ID,RTF:Integer):Boolean;
begin
	try
		Result:=False;
		if (ID>0) then begin
			case CN[1].Execsql('UPDATE MSJ SET REF = "'+RTF.Tostring+'" WHERE id = "'+ID.Tostring+'"') of
				0:Result:=False;
				1:Result:=True;
			end;
		end;
	except
		on E:Exception do Result:=False;
	end;
end;

function SFQ1(IT,SN,INV,RFC:string):Extended;
var
	D1:Extended;
	Ic0:string;
begin
	try
		Result:=0;
		Ic0:='';
		if CharInSet(RFC[1],['1','4','5']) then begin
			Ic0:='" AND NOT ICODE = "'+INV;
		end;
		if (SFIT0(IT)>0)and(SN<>'')and(INV<>'')and(RFC<>'') then begin
			FQ[8].Open('SELECT SUM(QTY) FROM SN'+SN+' WHERE CODE = "'+IT+
				'" AND (RIF = "2" OR RIF = "3" OR RIF = "6" OR RIF = "0")');
			D1:=NE(FQ[8].Fields[0].Asstring);
			FQ[8].Open('SELECT SUM(QTY) FROM SN'+SN+' WHERE CODE = "'+IT+Ic0+'" AND (RIF = "1" OR RIF = "4" OR RIF = "5")');
			D1:=D1-NE(FQ[8].Fields[0].Asstring);

			Result:=D1;
		end;
	except
		on E:Exception do Result:=0;
	end;
end;

function SFQ2(IT,RFC,ST1,CC1,IC:string):Extended;
begin
	try
		Result:=0;
		if (SFIT0(IT)>0)and(ST1<>'')and CharInSet(RFC[1],['3','4'])and(CC1<>'') then begin
			case NA(RFC) of
				3:RFC:='1';
				4:RFC:='2';
			end;
			if (NE(IC)>0)and(NE(IC)<RTC1(RFC,ST1)) then begin
				FQ[8].Open('SELECT SUM(QTY) FROM T'+IT+' WHERE ST = "'+ST1+'" AND IFRM = "'+IC+'" AND RIF = "'+RFC+
					'" AND FRM = "'+CC1+'"');
				Result:=NE(FQ[8].Fields[0].Asstring);
			end;
		end;
	except
		on E:Exception do Result:=0;
	end;
end;

function SFPR1(IT,RFC,ST1,CC1:string;IC:Integer;PR,QY:Extended;SN:string='';N:string=''):string;
var
	Q,Q1:Extended;
	Rfc1,MH:string;
begin
	try
		Result:='I';
		if (IT<>'')and(ST1<>'')and CharInSet(RFC[1],['3','4'])and(CC1<>'') then begin
			MH:='T'+IT;
			case NA(RFC) of
				3:Rfc1:='1';
				4:Rfc1:='2';
			end;
			FQ[8].Open('SELECT id FROM '+MH+' WHERE ST = "'+ST1+'" AND RIF = "'+Rfc1+'" AND FRM = "'+CC1+'"');
			if (FQ[8].Fields[0].Asinteger=0) then begin
				Result:='A'; // IT error
				EXIT;
			end;
			if (IC>0) then begin
				FQ[8].Open('SELECT id FROM '+MH+' WHERE ST = "'+ST1+'" AND IFRM = "'+IC.Tostring+'" AND RIF = "'+Rfc1+
					'" AND FRM = "'+CC1+'"');
				if (FQ[8].Fields[0].Asinteger=0) then begin
					Result:='B'; // Voucher error
					EXIT;
				end;
				if (QY>0) then begin
					if (RFC='4')and(SN<>'')and(SFR1(12)='1') then begin
						FQ[8].Open('SELECT SUM(QTY) FROM SN'+SN+' WHERE CODE = "'+IT+
							'" AND (RIF = "2" OR RIF = "3" OR RIF = "6" OR RIF = "0")');
						Q:=NE(FQ[8].Fields[0].Asstring);
						FQ[8].Open('SELECT SUM(QTY) FROM SN'+SN+' WHERE CODE = "'+IT+'" AND NOT ICODE ="'+N+
							'" AND (RIF = "1" OR RIF = "4" OR RIF = "5")');
						Q:=Q-NE(FQ[8].Fields[0].Asstring);
						if (QY>Q) then begin
							Result:='S'+Q.Tostring; // SN QTY
							EXIT;
						end;
					end;
					FQ[8].Open('SELECT SUM(QTY) FROM '+MH+' WHERE ST = "'+ST1+'" AND ICODE = "'+IC.Tostring+'" AND RIF = "'+Rfc1+
						'" AND FRM = "'+CC1+'"');
					Q:=NE(FQ[8].Fields[0].Asstring);
					FQ[8].Open('SELECT SUM(QTY) FROM '+MH+' WHERE ST = "'+ST1+'" AND IFRM = "'+IC.Tostring+'" AND RIF = "'+RFC+
						'" AND FRM = "'+CC1+'" AND NOT ICODE = "'+N+'"');
					Q:=Q-NE(FQ[8].Fields[0].Asstring);
					if (QY>Q) then begin
						Result:='F'+Q.Tostring; // QTY BIGGER
						EXIT;
					end else begin
						FQ[8].Open('SELECT DISTINCT PR FROM '+MH+' WHERE ST = "'+ST1+'" AND ICODE = "'+IC.Tostring+'" AND RIF = "'+
							Rfc1+'" AND FRM = "'+CC1+'"');
						if (FQ[8].RowsAffected=1) then begin
							Result:='G'+FQ[8].Fields[0].Asstring;
							PR:=NE(Result); // ONE PRICE
						end;
					end;
					if (PR>0) then begin
						FQ[8].Open('SELECT SUM(QTY) FROM '+MH+' WHERE ST = "'+ST1+'" AND ICODE = "'+IC.Tostring+'" AND RIF = "'+Rfc1
							+'" AND FRM = "'+CC1+'" AND PR = "'+PR.Tostring+'"');
						Q:=NE(FQ[8].Fields[0].Asstring);
						FQ[8].Open('SELECT SUM(QTY) FROM '+MH+' WHERE ST = "'+ST1+'" AND IFRM = "'+IC.Tostring+'" AND RIF = "'+RFC+
							'" AND FRM = "'+CC1+'" AND PR = "'+PR.Tostring+'" AND NOT ICODE = "'+N+'"');
						Q1:=NE(FQ[8].Fields[0].Asstring);
						if (Q=0) then begin
							Result:='C'; // PR error
							EXIT;
						end else begin
							if (QY>Q-Q1) then begin
								Result:='D'+(Q-Q1).Tostring; // QTY BIGGER
								EXIT;
							end else begin
								Result:='Q';
							end;
						end;
					end;
				end;
			end;
		end;
	except
		on E:Exception do Result:='E';
	end;
end;

procedure DTmpDech(O:Integer);
var
	Mx,I:Integer;
	CMH:string;
begin
	try
		FQ[O].Open('PRAGMA database_list');
		Mx:=FQ[O].RowsAffected;
		if (Mx>0) then begin
			for I:=1 to Mx do begin
				CMH:=FQ[O].Fields[1].Asstring;
				if (CMH<>'main')and(CMH<>'temp') then CN[O].Execsql('DETACH "'+CMH+'"');
				FQ[O].Next;
			end;
		end;
	except
		on E:Exception do
	end;
end;

function DPTmpDROP(TBL,ERR:string):Boolean;
begin
	Result:=False;
	try
		if (TBL<>'')or(ERR<>'') then begin
			CN[2].Execsql('DROP TABLE IF EXISTS '+TBL+';DROP TABLE IF EXISTS '+ERR+
				';UPDATE TMPS SET TBL="",ERR="" WHERE TBL="'+TBL+'";');
		end;
		Result:=True;
	except
		on E:Exception do SHOWMESSAGE('DTmpD : ERROR');
	end;
end;

function DTmpT:Boolean;
var
	Tmp,TBL,ERR:string;
	I,Mx:Integer;
begin
	Mx:=0;
	I:=0;
	Result:=False;
	Tmp:='';
	try
		FQ[2].Open('SELECT TBL,ERR FROM TMPS');
		Mx:=FQ[2].RowsAffected;
		if (Mx<>0) then begin
			for I:=0 to Mx-1 do begin
				TBL:=FQ[2].Fields[0].Asstring;
				ERR:=FQ[2].Fields[1].Asstring;
				if (TBL<>'') then Tmp:=Tmp+'DROP TABLE IF EXISTS '+TBL+';';
				if (ERR<>'') then Tmp:=Tmp+'DROP TABLE IF EXISTS '+ERR+';';
				FQ[2].Next;
			end;
			Tmp:=Tmp+'DELETE FROM TMPS;DELETE FROM sqlite_sequence WHERE name ="TMPS";';
			CN[2].Execsql(Tmp);
			Result:=True;
		end;
	except
		on E:Exception do SHOWMESSAGE('DTmpT : ERROR');
	end;
end;

function DTmpC(RFC:string;var TBL,ERR:string;ISNEW:Boolean):Boolean;
const
	Ct='CREATE TEMPORARY TABLE IF NOT EXISTS ';
var
	Tmp,COLS:string;
	I:Integer;
begin
	Result:=False;
	I:=0;
	Tmp:='';
	try
		if ISNEW then begin
			TBL:='';
			ERR:='';
			FQ[2].Open('SELECT ROWID FROM TMPS');
			TBL:='TPL'+(FQ[2].RowsAffected+1).Tostring;
			ERR:='ERL'+(FQ[2].RowsAffected+1).Tostring;
			Tmp:=Tmp+'INSERT INTO TMPS (TBL,ERR) VALUES ("'+TBL+'","'+ERR+'");';
		end;
		COLS:='SELECT " (id INTEGER,"||group_concat(printf("%s %s %s",CUL,TY,DF))||");" FROM '+DTD1(RFC)+
			' WHERE ACT="1" ORDER BY IX ASC';
		COLS:=string(CN[9].ExecSQLScalar(COLS));
		Tmp:=Tmp+'DROP TABLE IF EXISTS '+TBL+';DROP TABLE IF EXISTS '+ERR+';';
		Tmp:=Tmp+Ct+TBL+COLS+Ct+ERR+' (CEL TEXT,CL INTEGER,RO INTEGER,WRG TEXT);';
		Tmp:=Tmp+'INSERT INTO '+TBL+' (id)VALUES("1");';
		CN[2].Execsql(Tmp);
		Result:=True;
	except
		on E:Exception do SHOWMESSAGE('DTmpC : ERROR'+#13+E.Tostring);
	end;
end;

function SEI1(COD:string):string;
begin
	try
		Result:='';
		if (COD<>'') then begin
			FQ[2].Open('SELECT END FROM NIT WHERE CODE = "'+COD+'"');
			Result:=FQ[2].Fields[0].Asstring;
		end;
	except
		on E:Exception do Result:='';
	end;
end;

function SEC1(COD:string):string;
begin
	try
		Result:='';
		if (COD<>'') then begin
			FQ[2].Open('SELECT END FROM NCLIENTS WHERE CODE = "'+COD+'"');
			Result:=FQ[2].Fields[0].Asstring;
		end;
	except
		on E:Exception do Result:='';
	end;
end;

function SCl(CCl:string):string;
begin
	if (CCl='LAN') then Result:=Lan
	else Result:=CCl;
end;

function SFIT0(IT:string):Integer;
begin
	try
		Result:=0;
		if (IT<>'') then begin
			FQ[2].Open('SELECT id FROM NIT WHERE CODE="'+IT+'"');
			Result:=FQ[2].Fields[0].Asinteger;
			if (FQ[2].Fields[0].Asinteger=0) then begin
				Result:=-1;
			end;
		end;
	except
		on E:Exception do Result:=0;
	end;
end;

function SFIT1(IT,CCl:string):string;
begin
	try
		Result:='';
		if (SFIT0(IT)>0)and(CCl<>'') then begin
			FQ[2].Open('SELECT '+CCl+' FROM NIT WHERE CODE = "'+IT+'"');
			Result:=FQ[2].Fields[0].Asstring;
		end;
	except
		on E:Exception do Result:='';
	end;
end;

function SFIT2(Lang,CCl:string):string;
begin
	try
		Result:='';
		if (Lang<>'') then begin
			FQ[2].Open('SELECT CODE FROM NIT WHERE '+CCl+' = "'+Lang+'"');
			Result:=FQ[2].Fields[0].Asstring;
		end;
	except
		on E:Exception do Result:='';
	end;
end;

function SFIT3(IT,CCl:string):string;
begin
	try
		Result:='';
		if (SFIT0(IT)>0)and(CCl<>'') then begin
			FQ[2].Open('SELECT '+CCl+' FROM NIT WHERE CODE="'+IT+'"');
			Result:=FQ[2].Fields[0].Asstring;
		end;
	except
		on E:Exception do SHOWMESSAGE(SR0(E.Tostring));
	end;
end;

function SFIT4(IT:string;CC:string=''):string;
var
	Cp1:string;
begin
	try
		Cp1:=SFR1(7);
		Result:='0';
		if (SFIT0(IT)>0) then begin
			if (Cp1='1') then begin
				FQ[2].Open('SELECT CO FROM NIT WHERE CODE = "'+IT+'"');
				Result:=FQ[2].Fields[0].Asstring;
			end;
			if (Cp1='2')and(CC<>'') then begin
				FQ[8].Open('SELECT PR FROM T'+IT+' WHERE FRM = "'+CC+
					'" AND (RIF = "2" OR RIF = "0") ORDER BY ICODE DESC LIMIT 1');
				Result:=FQ[8].Fields[0].Asstring;
			end;
		end;
	except
		on E:Exception do SHOWMESSAGE(SR0(E.Tostring));
	end;
end;

function SFIT5(IT:string;QY:string='0'):string;
var
	Cp1:string;
	CC,t:Integer;
begin
	try
		Cp1:=SFR1(8);
		Result:='0';
		if (SFIT0(IT)>0) then begin
			if (Cp1='1') then begin
				FQ[2].Open('SELECT PR FROM NIT WHERE CODE = "'+IT+'"');
				Result:=FQ[2].Fields[0].Asstring;
			end;
			if (Cp1='2') then begin
				FQ[2].Open('SELECT PC,CO FROM NIT WHERE CODE = "'+IT+'"');
				Result:=(((NE(FQ[2].Fields[0].Asstring)/100)+1)*NE(FQ[2].Fields[1].Asstring)).Tostring;
			end;
			if (Cp1='3') then begin
				if (QY<>'') then begin
					FQ[2].Open('SELECT PR FROM NIT WHERE CODE = "'+IT+'"');
					Result:=FQ[2].Fields[0].Asstring;
					FQ[2].Open('SELECT PQ FROM NIT WHERE CODE = "'+IT+'"');
					CC:=GR1(FQ[2].Fields[0].Asstring,'|');
					if (CC>0) then begin
						for t:=1 to CC do begin
							GR2(S0[t],',');
							if (NE(QY)>=NE(S1[1])) then begin
								Result:=S1[2];
							end;
						end;
					end;
				end;
			end;
		end;
	except
		on E:Exception do SHOWMESSAGE(E.Tostring);
	end;
end;

function SFIT6(CC,IT,ST1,RFC:string;NU:Integer):string;
begin
	try

	except
		on E:Exception do Result:='';
	end;
end;

function SFIT7(IT,QY:string):string;
var
	Cp,Ty:string;
	Pr1: array [1..10000] of string;
	t,I:Integer;
	Q,Q1,Q2,Q3,Q4,Q5,Co:Extended;
begin
	try
		Cp:=SFR1(19);
		Result:='0';
		Q:=0;
		Q1:=0;
		Q3:=0;
		Co:=0;
		if (SFIT0(IT)>0) then begin
			if (Cp='0') then begin
				if (NE(QY)>0) then begin
					Q:=NE(QY);
				end;
				FQ[2].Open('SELECT CO FROM NIT WHERE CODE = "'+IT+'"');
				Result:=(NE(FQ[2].Fields[0].Asstring)*Q).Tostring;
			end;
			if (Cp='1') then begin
				if (NE(QY)>0) then begin
					Q:=NE(QY);
				end;
				FQ[8].Open('SELECT SUM(QTY * PR),SUM(QTY) FROM T'+IT+' WHERE RIF = "2" OR RIF = "0"');
				Co:=NE(FQ[8].Fields[0].Asstring);
				Q1:=NE(FQ[8].Fields[1].Asstring);
				FQ[8].Open('SELECT SUM(QTY * PR),SUM(QTY) FROM T'+IT+' WHERE RIF = "4"');
				Co:=Co-NE(FQ[8].Fields[0].Asstring);
				Q1:=Q1-NE(FQ[8].Fields[1].Asstring);
				Result:=((Co/Q1)*Q).Tostring;
			end;
			if (Cp='2')or(Cp='3') then begin
				case NA(Cp) of
					2:Ty:='ASC';
					3:Ty:='DESC';
				end;
				Q5:=NE(QY);
				FQ[8].Open('SELECT SUM(QTY) FROM T'+IT+' WHERE RIF = "1"');
				Q:=NE(FQ[8].Fields[0].Asstring);
				FQ[8].Open('SELECT SUM(QTY) FROM T'+IT+' WHERE RIF = "3"');
				Q:=Q-NE(FQ[8].Fields[0].Asstring);
				FQ[8].Open('SELECT DISTINCT PR FROM T'+IT+' WHERE RIF = "2" OR RIF = "0" ORDER BY DAT '+Ty);
				t:=FQ[8].RowsAffected;
				if (t<>0) then begin
					for I:=1 to t do begin
						Pr1[I]:=FQ[8].Fields[0].Asstring;
						FQ[8].Next;
					end;
					for I:=1 to t do begin
						FQ[8].Open('SELECT SUM(QTY) FROM T'+IT+' WHERE (RIF = "2" OR RIF = "0") AND PR = "'+Pr1[I]+'"');
						Q2:=NE(FQ[8].Fields[0].Asstring);
						FQ[8].Open('SELECT SUM(QTY) FROM T'+IT+' WHERE RIF = "4" AND PR = "'+Pr1[I]+'"');
						Q2:=Q2-NE(FQ[8].Fields[0].Asstring);
						Q1:=Q1+Q2;
						if (Q1>=Q) then begin
							Q4:=(Q1-Q)-Q3;
							if (Q5>Q4) then begin
								Co:=Co+(NE(Pr1[I])*Q4);
								Q5:=Q5-Q4;
								Q3:=Q3+Q4;
							end else begin
								Co:=Co+(NE(Pr1[I])*Q5);
								Result:=Co.Tostring;
								EXIT;
							end;
						end;
					end;
				end;
			end;
		end;
	except
		on E:Exception do Result:='0';
	end;
end;

function SFIT8(IT:string):string;
var
	Cp,Ty:string;
	IC: array [1..100000] of string;
	t,I,P:Integer;
	Q,Q1,Q2,Q3,Q4,Co,Qty,PR:Extended;
begin
	try
		Cp:=SFR1(19);
		Result:='0';
		Q1:=0;
		Q3:=0;
		Co:=0;
		if (SFIT0(IT)>0) then begin
			if (Cp='0') then begin
				FQ[8].Open('SELECT SUM(QTY) FROM T'+IT+' WHERE RIF = "1"');
				Q:=NE(FQ[8].Fields[0].Asstring);
				FQ[8].Open('SELECT SUM(QTY) FROM T'+IT+' WHERE RIF = "3"');
				Q:=Q-NE(FQ[8].Fields[0].Asstring);
				FQ[2].Open('SELECT CO FROM NIT WHERE CODE = "'+IT+'"');
				Result:=(NE(FQ[2].Fields[0].Asstring)*Q).Tostring;
			end;
			if (Cp='1') then begin
				FQ[8].Open('SELECT SUM(QTY) FROM T'+IT+' WHERE RIF = "1"');
				Q:=NE(FQ[8].Fields[0].Asstring);
				FQ[8].Open('SELECT SUM(QTY) FROM T'+IT+' WHERE RIF = "3"');
				Q:=Q-NE(FQ[8].Fields[0].Asstring);
				FQ[8].Open('SELECT SUM(QTY * PR),SUM(QTY) FROM T'+IT+' WHERE RIF = "2" OR RIF = "0"');
				Co:=NE(FQ[8].Fields[0].Asstring);
				Q1:=NE(FQ[8].Fields[1].Asstring);
				FQ[8].Open('SELECT SUM(QTY * PR),SUM(QTY) FROM T'+IT+' WHERE RIF = "4"');
				Co:=Co-NE(FQ[8].Fields[0].Asstring);
				Q1:=Q1-NE(FQ[8].Fields[1].Asstring);
				Result:=((Co/Q1)*Q).Tostring;
			end;
			if (Cp='2')or(Cp='3') then begin
				case NA(Cp) of
					2:Ty:='ASC';
					3:Ty:='DESC';
				end;
				FQ[8].Open('SELECT SUM(QTY) FROM T'+IT+' WHERE RIF = "1"');
				Q:=NE(FQ[8].Fields[0].Asstring);
				FQ[8].Open('SELECT SUM(QTY) FROM T'+IT+' WHERE RIF = "3"');
				Q:=Q-NE(FQ[8].Fields[0].Asstring);
				FQ[8].Open('SELECT DISTINCT ICODE FROM T'+IT+' WHERE RIF = "2" OR RIF = "0" ORDER BY ICODE '+Ty);
				t:=FQ[8].RowsAffected;
				if (t<>0) then begin
					for I:=1 to t do begin
						IC[I]:=FQ[8].Fields[0].Asstring;
						FQ[8].Next;
					end;
					for I:=1 to t do begin
						FQ[8].Open('SELECT SUM(QTY),SUM(QTY * PR) FROM T'+IT+' WHERE RIF = "4" AND IFRM = "'+IC[I]+'"');
						Q1:=Q1-NE(FQ[8].Fields[0].Asstring);
						Co:=Co-NE(FQ[8].Fields[1].Asstring);
						FQ[8].Open('SELECT SUM(QTY),SUM(QTY * PR) FROM T'+IT+' WHERE (RIF = "2" OR RIF = "0") AND ICODE = "'+
							IC[I]+'"');
						Q1:=Q1+NE(FQ[8].Fields[0].Asstring);
						Q2:=Q1-NE(FQ[8].Fields[0].Asstring);
						Co:=Co+NE(FQ[8].Fields[1].Asstring);
						Q4:=Q-Q2;
						if (Q1=Q) then begin
							Result:=Co.Tostring;
							EXIT;
						end;
						if (Q1>Q) then begin
							Co:=Co-NE(FQ[8].Fields[1].Asstring);
							FQ[8].Open('SELECT QTY,PR FROM T'+IT+' WHERE (RIF = "2" OR RIF = "0") AND ICODE = "'+IC[I]+'"');
							for P:=1 to FQ[8].RowsAffected do begin
								Qty:=NE(FQ[8].Fields[0].Asstring);
								PR:=NE(FQ[8].Fields[1].Asstring);
								Q3:=Q3+Qty;
								Co:=Co+(Qty*PR);
								if (Q3>=Q4) then begin
									Result:=(Co-((Q3-Q4)*PR)).Tostring;
									EXIT;
								end;
								FQ[8].Next;
							end;
						end;
					end;
				end;
			end;
		end;
	except
		on E:Exception do Result:='0';
	end;
end;

function SFCE1(COD:string):string;
begin
	try
		Result:='';
		if (COD<>'') then begin
			FQ[2].Open('SELECT '+Lan+' FROM NCCE WHERE CODE = "'+COD+'"');
			Result:=FQ[2].Fields[0].Asstring;
		end;
	except
		on E:Exception do Result:='';
	end;
end;

function SFCE2(Lang:string):string;
begin
	try
		Result:='';
		if (Lang<>'') then begin
			FQ[2].Open('SELECT id FROM NCCE WHERE '+Lan+' = "'+Lang+'"');
			Result:=FQ[2].Fields[0].Asstring;
		end;
	except
		on E:Exception do Result:='';
	end;
end;

function SFCC1(COD:string):string;
begin
	try
		Result:='';
		if (COD<>'') then begin
			FQ[2].Open('SELECT '+Lan+' FROM NCLIENTS WHERE CODE = "'+COD+'"');
			Result:=FQ[2].Fields[0].Asstring;
		end;
	except
		on E:Exception do Result:='';
	end;
end;

function SFCC2(Lang:string):string;
begin
	try
		Result:='';
		if (Lang<>'') then begin
			FQ[2].Open('SELECT CODE FROM NCLIENTS WHERE '+Lan+' = "'+Lang+'"');
			Result:=FQ[2].Fields[0].Asstring;
		end;
	except
		on E:Exception do Result:='';
	end;
end;

function SFCC3(COD:string):string;
begin
	try
		Result:='';
		if (COD<>'') then begin
			FQ[2].Open('SELECT REF FROM NCLIENTS WHERE CODE = "'+COD+'"');
			Result:=FQ[2].Fields[0].Asstring;
		end;
	except
		on E:Exception do Result:='';
	end;
end;

function SFCC4(COD:string):string;
begin
	try
		Result:='';
		if (COD<>'') then begin
			FQ[2].Open('SELECT REF FROM NCLIENTS WHERE CODE = "'+COD+'"');
			Result:=FQ[2].Fields[0].Asstring+COD;
		end;
	except
		on E:Exception do Result:='';
	end;
end;

function SFST1(ID:string):string;
begin
	try
		Result:='';
		if (ID<>'') then begin
			FQ[2].Open('SELECT '+Lan+' FROM NST WHERE id = "'+ID+'" AND REF="1"');
			Result:=FQ[2].Fields[0].Asstring;
		end;
	except
		on E:Exception do Result:='';
	end;
end;

function SFST2(Lang:string):string;
begin
	try
		Result:='';
		if (Lang<>'') then begin
			FQ[2].Open('SELECT id FROM NST WHERE '+Lan+' = "'+Lang+'" AND REF="1"');
			Result:=FQ[2].Fields[0].Asstring;
		end;
	except
		on E:Exception do Result:='';
	end;
end;

function SFSN1(ID:string):string;
begin
	try
		Result:='';
		if (ID<>'') then begin
			FQ[2].Open('SELECT '+Lan+' FROM NSN WHERE id = "'+ID+'" AND REF="1"');
			Result:=FQ[2].Fields[0].Asstring;
		end;
	except
		on E:Exception do Result:='';
	end;
end;

function SFSN2(Lang:string):string;
begin
	try
		Result:='';
		if (Lang<>'') then begin
			FQ[2].Open('SELECT id FROM NSN WHERE '+Lan+' = "'+Lang+'" AND REF="1"');
			Result:=FQ[2].Fields[0].Asstring;
		end;
	except
		on E:Exception do SHOWMESSAGE('SFSN2'+#13+E.Tostring);
	end;
end;

function SFCR1(ID:Integer):string;
begin
	try
		Result:='';
		if (ID>0) then begin
			FQ[2].Open('SELECT '+Lan+' FROM NCR1 WHERE id = "'+ID.Tostring+'"');
			Result:=FQ[2].Fields[0].Asstring;
		end;
	except
		on E:Exception do Result:='';
	end;
end;

function SFCR2(ID:Integer):string;
begin
	try
		Result:='';
		if (ID>0) then begin
			FQ[2].Open('SELECT '+Lan+' FROM NCR2 WHERE id = "'+ID.Tostring+'"');
			Result:=FQ[2].Fields[0].Asstring;
		end;
	except
		on E:Exception do Result:='';
	end;
end;

function MDFive(Mf:string):string;
begin
	with TidHashMessageDigest5.Create do
		try Result:=HashStringAsHex(Mf);
		finally Free;
		end;
end;

function SHAONE(SO:string):string;
begin
	with TIdHashSHA1.Create do
		try Result:=HashStringAsHex(SO);
		finally Free;
		end;
end;

function ENC1(EC:string):string;
begin
	Result:=TNetEncoding.Base64.Encode(EC);
end;

function DEC1(DC:string):string;
begin
	Result:=TNetEncoding.Base64.Decode(DC);
end;

procedure PSN1(Rn:Integer);
var
	Ch,Wi:string;
begin
	try
		if (SFR1(38)='1')and(Rn>-2) then begin
			SetLength(Wi,MAX_PATH);
			SetLength(Wi,Getwindowsdirectory(@Wi[1],MAX_PATH));
			case Rn of
				-1:Ch:=Wi+'\media\chimes.wav';
				0:Ch:='';
				1:Ch:='SYSTEMEXCLAMATION';
				2:Ch:='SYSTEMHAND';
				3:Ch:='SYSTEMASTERISK';
				4:Ch:='SYSTEMQUESTION';
			end;
			if (Rn>4) then begin
				Ch:='MAILBEEP';
			end;
			Playsound(Pchar(Ch),0,Snd_async);
		end;
	except
		on E:Exception do
	end;
end;

FUNCTION PrepareConnection(conn:TFDConnection;FD:TFDQuery;DBFile:string):Boolean;
begin
	conn.Params.Driverid:='SQLite';
	conn.Params.Values['Encrypt']:='aes-256';
	// TSQLiteDatabase(CN[I].ConnectionIntf.CliObj).Limits[SQLITE_LIMIT_VARIABLE_NUMBER]:=10;
	with TFDPhysSQLiteConnectionDefParams(conn.Params) do begin
		LockingMode:=lmNormal;
		JournalMode:=jmWAL;
		CacheSize:=-1000;
		Synchronous:=snFull;
		BusyTimeout:=30000;
		SharedCache:=False;
		SQLiteAdvanced:='temp_store=FILE;autovacuum=FULL;page_size=65536;user_version=99;'+
			'secure_delete=ON;automatic_index=1;wal_autocheckpoint=1000;';
	end;
	conn.UpdateOptions.LockWait:=True;
	conn.Fetchoptions.Mode:=Fmall;
	conn.Formatoptions.Maxstringsize:=Maxint;
	conn.Txoptions.Isolation:=Xiserializible;
	FD.Connection:=conn;
	FD.Fetchoptions.Rowsetsize:=1000;
	conn.Params.Database:=DBFile;
	conn.Connected:=True;
end;

procedure StartAtAll;
var
	I:Integer;
	Wn:TChromeTab;
	Hcl1:TPanel;
	Az: array of string;
	Tmp:string;
begin
	try
		// APP DIR.
		Dir:=Extractfilepath(Application.Exename);
		// date-time functions
		Formatsettings.Dateseparator:='/';
		Formatsettings.Timeseparator:=':';
		Formatsettings.Shortdateformat:='yyyy/MM/dd';
		Formatsettings.Shorttimeformat:='HH:mm:ss.ZZZ';
		{ Setlocaleinfo(Getsystemdefaultlcid,Locale_sdate,'/');
			Setlocaleinfo(Getsystemdefaultlcid,Locale_stime,':');
			Setlocaleinfo(Getsystemdefaultlcid,Locale_sshortdate,'dd/MM/yyyy');
			Setlocaleinfo(Getsystemdefaultlcid,Locale_stimeformat,'hh:mm:ss tt'); }
		// sqlite.
		Pa:='aes-256:Amd03061989';
		Fdmanager.Silentmode:=True;
		Az:=['LGS','PD1','PD2','PD3','PD4','PD5','PD6','PD7','PD8','PD9','PD10','PD11','PD12'];
		for I:=0 to 12 do begin
			Md[I]:=Dir+'\MDfc\Amz'+Az[I]+'.amd';
			CN[I]:=TFDConnection.Create(AMDF);
			FQ[I]:=TFDQuery.Create(AMDF);
			CN[I].Params.Driverid:='SQLite';
			CN[I].Params.Values['Encrypt']:='aes-256';
			// TSQLiteDatabase(CN[I].ConnectionIntf.CliObj).Limits[SQLITE_LIMIT_VARIABLE_NUMBER]:=10;
			with TFDPhysSQLiteConnectionDefParams(CN[I].Params) do begin
				LockingMode:=lmNormal;
				JournalMode:=jmWAL;
				CacheSize:=-1000;
				Synchronous:=snFull;
				BusyTimeout:=30000;
				SharedCache:=False;
				SQLiteAdvanced:='temp_store=FILE;autovacuum=FULL;page_size=65536;user_version=99;'+
					'secure_delete=ON;automatic_index=1;wal_autocheckpoint=1000;';
			end;
			CN[I].UpdateOptions.LockWait:=True;
			CN[I].Fetchoptions.Mode:=Fmall;
			CN[I].Formatoptions.Maxstringsize:=Maxint;
			CN[I].Txoptions.Isolation:=Xiserializible;
			FQ[I].Connection:=CN[I];
			FQ[I].Fetchoptions.Rowsetsize:=1000;
			if not Directoryexists(Dir+'\MDfc',True) then Forcedirectories(Dir+'\MDfc');
			if not FileExists(Md[I]) then begin
				CN[I].Params.Database:=Md[I];
				CreatTStart(I);
			end;
			CN[I].Params.Database:=Md[I];
			CN[I].Connected:=True;
		end;
		// LANG

		FQ[1].Open('SELECT * FROM LANG where id=1');
		GR0(FQ[1].Fieldlist.Commatext,',');
		Lan:=S0[NA(SFR1(5))+1];
		AMDS(0,'LG',Lan,Lng1);
		AMDS(1,'LANG',Lan,Lng2);
		Application.Bidimode:=Tbidimode(NA(SFL1(2)));
		// CHROME TABS.
		if not(SFR1(21)='0') then begin
			AMDF.Glassframe.Enabled:=True;
			AMDF.Glassframe.Top:=NA(SFR1(26));
			CRT1:=TChromeTabs.Create(AMDF);
			with CRT1 do begin
				Parent:=AMDF;
				Align:=Altop;
				Height:=NA(SFR1(26));
			end;
			if AMDF.ClassNameIs('Tformtype') then Tformtype(AMDF).ChromeTabs:=CRT1;
			LandOtChrome(CRT1);
			Hcl1:=TPanel.Create(AMDF);
			Hcl1.Parent:=AMDF;
			Hcl1.Caption:='';
			Hcl1.Align:=Alclient;
			{ for I:=0 to AMDF.componentcount-1 do
				if AMDF.components[I] is TWinControl then
				if not(AMDF.components[I]=Hcl1) then TWinControl(AMDF.components[I]).Parent:=Hcl1; }

			AMDF.Label1.Parent:=Hcl1;
			AMDF.RichEdit.Parent:=Hcl1;
			AMDF.Statusbar.Parent:=Hcl1;
			AMDF.Button1.Parent:=Hcl1;
			AMDF.Button2.Parent:=Hcl1;
			AMDF.Button3.Parent:=Hcl1;
			AMDF.Button4.Parent:=Hcl1;
			AMDF.Button5.Parent:=Hcl1;
			AMDF.Button6.Parent:=Hcl1;
			AMDF.Button7.Parent:=Hcl1;
			AMDF.Button8.Parent:=Hcl1;
			AMDF.Button9.Parent:=Hcl1;
			AMDF.Button10.Parent:=Hcl1;
			AMDF.Button11.Parent:=Hcl1;
			AMDF.Button12.Parent:=Hcl1;
			AMDF.Button13.Parent:=Hcl1;
			AMDF.Button14.Parent:=Hcl1;
			AMDF.Button15.Parent:=Hcl1;
			AMDF.Button16.Parent:=Hcl1;
			AMDF.Button17.Parent:=Hcl1;
			AMDF.Button18.Parent:=Hcl1;
			AMDF.Button19.Parent:=Hcl1;
			AMDF.Button20.Parent:=Hcl1;
			AMDF.Button21.Parent:=Hcl1;
			AMDF.Button22.Parent:=Hcl1;
			AMDF.Button23.Parent:=Hcl1;
			AMDF.Button24.Parent:=Hcl1;
			AMDF.Button25.Parent:=Hcl1;
			AMDF.Button26.Parent:=Hcl1;
			AMDF.Button27.Parent:=Hcl1;
			AMDF.Button28.Parent:=Hcl1;
			AMDF.Button29.Parent:=Hcl1;
			AMDF.Button30.Parent:=Hcl1;
			AMDF.Button31.Parent:=Hcl1;
			AMDF.Button32.Parent:=Hcl1;
			AMDF.Button33.Parent:=Hcl1;
			AMDF.Button34.Parent:=Hcl1;
			AMDF.Button35.Parent:=Hcl1;
			AMDF.Button36.Parent:=Hcl1;
			AMDF.Button37.Parent:=Hcl1;
			AMDF.Button38.Parent:=Hcl1;
			AMDF.Button39.Parent:=Hcl1;
			AMDF.Button40.Parent:=Hcl1;
			AMDF.Button41.Parent:=Hcl1;
			AMDF.Button42.Parent:=Hcl1;
			AMDF.Button43.Parent:=Hcl1;
			AMDF.Button46.Parent:=Hcl1;
			AMDF.Button47.Parent:=Hcl1;
			AMDF.Button48.Parent:=Hcl1;
			AMDF.Button49.Parent:=Hcl1;
			AMDF.Edit2.Parent:=Hcl1;
			AMDF.ProgressBar1.Parent:=Hcl1;
			AMDF.ProgressBar3.Parent:=Hcl1;
			AMDF.Image1.Parent:=Hcl1;
			AMDF.ListView1.Parent:=Hcl1;
			AMDF.NumberBox1.Parent:=Hcl1;
			Wn:=AddTab(CRT1,SFL1(130),Hcl1,129);
			Wn.Hideclosebutton:=True;
			Wn.Pinned:=True;
			CRT1.Activetab:=Wn;
		end;
	except
		on E:Exception do begin
			SHOWMESSAGE('StartAtAll : '+I.Tostring+#13+E.Tostring);
			Application.Terminate;
		end;
	end;
end;

function AddTab(ChromeTabs:TChromeTabs;const Text:string;HCol:TWinControl;ImageIndex:Integer=-1):TChromeTab;
begin
	Result:=ChromeTabs.Tabs.Add;
	Result.Caption:=Text;
	Result.ImageIndex:=ImageIndex;
	Result.Modified:=True;
	Result.Hcontrol:=HCol;
	if (HCol is TFrm) then begin
		TFrm(HCol).ATab:=Result;
	end;
 //	ChromeTabs.Resize;
 //	ChromeTabs.Invalidateallcontrols;
end;

procedure LandOtChrome(ACrom:TChromeTabs);
begin
	with ACrom do begin
		Bidimode:=Tbidimode(NA(SFR1(27)));
		Images:=AMDF.AMD;
		Tabstop:=False;
		// ShowHint:=true;
		Onbeforedrawitem:=AMDF.ChromeBeforeDrawItem;
		Ongetcontrolpolygons:=AMDF.ChromeGetControlPolygons;
		Ontabdragstart:=AMDF.ChromeTabDragStart;
		Ontabdragover:=AMDF.ChromeTabDragOver;
		Ontabdragdrop:=AMDF.ChromeTabDragDrop;
		Ontabdragend:=AMDF.ChromeTabDragEnd;
		Ondragover:=AMDF.ChromeDragOver;
		OnbuttonBeforclosetabclick:=AMDF.ChromeTabBeforClose;
		OnbuttonAfterclosetabclick:=AMDF.ChromeTabAfterClose;
		Ontabclick:=AMDF.ChromeTabClick;
		Onmousemove:=AMDF.ChromeMouseMove;
		OnNeedDragImageControl:=AMDF.OnNeedDragImageControl;
		// OnCreateDragForm:=AMDF.ChromeTabs1CreateDragForm;
		Tag:=NA(SFR1(25));
		Imagesspinnerupload:=AMDF.Imagelist5;
		Imagesspinnerdownload:=AMDF.Imagelist4;
		Options.Display.Tabs.Seethroughtabs:=True; //
		Options.Display.Tabs.Taboverlap:=15;
		Options.Display.Tabs.Contentoffsetleft:=18;
		Options.Display.Tabs.Contentoffsetright:=16;
		Options.Display.Tabs.Offsetleft:=0;
		Options.Display.Tabs.Offsettop:=160;
		Options.Display.Tabs.Offsetright:=0;
		Options.Display.Tabs.Offsetbottom:=0;
		Options.Display.Tabs.Minwidth:=25;
		Options.Display.Tabs.Maxwidth:=NA(SFR1(30));
		Options.Display.Tabs.Tabwidthfromcontent:=Boolean(NA(SFR1(24))); // tab auto width.
		Options.Display.Tabs.Pinnedwidth:=39;
		Options.Display.Tabs.Imageoffsetleft:=13;
		Options.Display.Tabs.Texttrimtype:=Tttfade;
		Options.Display.Tabs.Orientation:=Ttaborientation(NA(SFR1(28)));
		Options.Display.Tabs.Baselinetabregiononly:=False;
		Options.Display.Tabs.Wordwrap:=False;
		Options.Display.Tabs.Textalignmenthorizontal:=Talignment(NA(SFL1(27)));
		Options.Display.Tabs.Textalignmentvertical:=Taverticalcenter;
		Options.Display.Tabs.Showimages:=True;
		Options.Display.Tabs.Showpinnedtabtext:=True;
		Options.Display.Tabs.Canvassmoothingmode:=Tsmoothingmode(2);
		Options.Display.TabModifiedGlow.Style:=Tchrometabmodifiedstyle(NA(SFL1(2))+1);
		Options.Display.TabModifiedGlow.Verticaloffset:=-6;
		Options.Display.TabModifiedGlow.Height:=NA(SFR1(26));
		Options.Display.TabModifiedGlow.Width:=Options.Display.Tabs.Maxwidth;
		Options.Display.TabModifiedGlow.Animationperiodms:=2000;
		Options.Display.TabModifiedGlow.Easetype:=Tteaseinoutquad;
		Options.Display.TabModifiedGlow.Animationupdatems:=30;
		Options.Display.Tabcontainer.Transparentbackground:=False; // True;
		Options.Display.Tabcontainer.Overlaybuttons:=False;
		///
		Options.Display.Tabcontainer.Paddingleft:=0;
		Options.Display.Tabcontainer.Paddingright:=0;
		Options.Display.Tabmouseglow.Offsets.Vertical:=0;
		Options.Display.Tabmouseglow.Offsets.Horizontal:=0;
		Options.Display.Tabmouseglow.Height:=200;
		Options.Display.Tabmouseglow.Width:=200;
		Options.Display.Tabmouseglow.Visible:=True;
		Options.Display.Tabspinners.Upload.Reversedirection:=True;
		Options.Display.Tabspinners.Upload.Renderedanimationstep:=4;
		Options.Display.Tabspinners.Upload.Position.Offsets.Vertical:=0;
		Options.Display.Tabspinners.Upload.Position.Offsets.Horizontal:=0;
		Options.Display.Tabspinners.Upload.Position.Height:=16;
		Options.Display.Tabspinners.Upload.Position.Width:=16;
		Options.Display.Tabspinners.Upload.Sweepangle:=135;
		Options.Display.Tabspinners.Download.Reversedirection:=False;
		Options.Display.Tabspinners.Download.Renderedanimationstep:=15;
		Options.Display.Tabspinners.Download.Position.Offsets.Vertical:=0;
		Options.Display.Tabspinners.Download.Position.Offsets.Horizontal:=0;
		Options.Display.Tabspinners.Download.Position.Height:=16;
		Options.Display.Tabspinners.Download.Position.Width:=16;
		Options.Display.Tabspinners.Download.Sweepangle:=135;
		Options.Display.Tabspinners.Animationupdatems:=50;
		Options.Display.Tabspinners.Hideimageswhenspinnervisible:=True;
		Options.Display.Closebutton.Height:=15;
		Options.Display.Closebutton.Width:=15;
		Options.Display.Closebutton.Offsets.Vertical:=(35-13)div 2; // NA(SFR1(26))
		Options.Display.Closebutton.Offsets.Horizontal:=2;
		Options.Display.Closebutton.Autohide:=False;
		Options.Display.Closebutton.Visibility:=Bvall;
		Options.Display.Closebutton.Autohidewidth:=20;
		Options.Display.Closebutton.Crossradialoffset:=4;
		Options.Display.Addbutton.Offsets.Vertical:=8;
		Options.Display.Addbutton.Offsets.Horizontal:=2;
		Options.Display.Addbutton.Height:=14;
		Options.Display.Addbutton.Width:=31;
		Options.Display.Addbutton.Showplussign:=False;
		Options.Display.Addbutton.Visibility:=Avnone;
		Options.Display.Addbutton.Horizontaloffsetfloating:=-3;
		Options.Display.Scrollbuttonleft.Offsets.Vertical:=NA(SFR1(26))-40;
		Options.Display.Scrollbuttonleft.Offsets.Horizontal:=1;
		Options.Display.Scrollbuttonleft.Height:=17;
		Options.Display.Scrollbuttonleft.Width:=30;
		Options.Display.Scrollbuttonright.Offsets.Vertical:=NA(SFR1(26))-40;
		Options.Display.Scrollbuttonright.Offsets.Horizontal:=1;
		Options.Display.Scrollbuttonright.Height:=17;
		Options.Display.Scrollbuttonright.Width:=30;
		Options.Dragdrop.Dragtype:=Dtbetweencontainers;
		Options.Dragdrop.Dragoutsideimagealpha:=220;
		Options.Dragdrop.Dragoutsidedistancepixels:=30;
		Options.Dragdrop.Dragstartpixels:=2;
		Options.Dragdrop.Dragcontrolimageresizefactor:=0.5;
		Options.Dragdrop.Dragcursor:=Crdefault;
		Options.Dragdrop.Dragdisplay:=Ddtabandcontrol;
		Options.Dragdrop.Dragformborderwidth:=2;
		Options.Dragdrop.Dragformbordercolor:=8421504;
		Options.Dragdrop.Contraindraggedtabwithincontainer:=True;
		Options.Animation.Defaultmovementanimationtimems:=100;
		Options.Animation.Defaultstyleanimationtimems:=300;
		Options.Animation.Animationtimerinterval:=15;
		Options.Animation.Minimumtabanimationwidth:=40;
		Options.Animation.Defaultmovementeasetype:=Ttlineartween;
		Options.Animation.Defaultstyleeasetype:=Ttlineartween;
		Options.Animation.Movementanimations.Tabadd.Usedefaulteasetype:=False;
		Options.Animation.Movementanimations.Tabadd.Usedefaultanimationtime:=False;
		Options.Animation.Movementanimations.Tabadd.Easetype:=Tteaseoutexpo;
		Options.Animation.Movementanimations.Tabadd.Animationtimems:=500;
		Options.Animation.Movementanimations.Tabdelete.Usedefaulteasetype:=False;
		Options.Animation.Movementanimations.Tabdelete.Usedefaultanimationtime:=False;
		Options.Animation.Movementanimations.Tabdelete.Easetype:=Tteaseoutexpo;
		Options.Animation.Movementanimations.Tabdelete.Animationtimems:=500;
		Options.Animation.Movementanimations.Tabmove.Usedefaulteasetype:=False;
		Options.Animation.Movementanimations.Tabmove.Usedefaultanimationtime:=False;
		Options.Animation.Movementanimations.Tabmove.Easetype:=Tteaseoutexpo;
		Options.Animation.Movementanimations.Tabmove.Animationtimems:=500;
		Options.Behaviour.Backgrounddblclickmaximiserestoreform:=True;
		Options.Behaviour.Backgrounddragmovesform:=True;
		Options.Behaviour.Tabsmartdeleteresizing:=True;
		Options.Behaviour.Tabsmartdeleteresizecanceldelay:=700;
		Options.Behaviour.Usebuiltinpopupmenu:=True;
		Options.Behaviour.CloseOnWheel:=False;
		Options.Behaviour.Activatenewtab:=Boolean(NA(SFR1(23))); // active new tab.
		Options.Behaviour.Debugmode:=False;
		Options.Behaviour.Ignoredoubleclickswhileanimatingmovement:=True;
		Options.Behaviour.TabRightClickSelect:=True;
		Options.Scrolling.Enabled:=True;
		Options.Scrolling.Scrollbuttons:=Csbright;
		Options.Scrolling.Scrollstep:=20;
		Options.Scrolling.Scrollrepeatdelay:=20;
		Options.Scrolling.Autohidebuttons:=False; // SCROLL BUTTON
		Options.Scrolling.Dragscroll:=True;
		Options.Scrolling.Dragscrolloffset:=50;
		Options.Scrolling.Mousewheelscroll:=True;

		Lookandfeel.Tabscontainer.Startcolor:=CLWHITE; // 14586466;
		Lookandfeel.Tabscontainer.Stopcolor:=CLWHITE; // 13201730;
		Lookandfeel.Tabscontainer.Startalpha:=255;
		Lookandfeel.Tabscontainer.Stopalpha:=255;
		Lookandfeel.Tabscontainer.Outlinecolor:=14520930;
		Lookandfeel.Tabscontainer.Outlinealpha:=0;
		Lookandfeel.Tabs.Baseline.Color:=11110509;
		Lookandfeel.Tabs.Baseline.Thickness:=1;
		Lookandfeel.Tabs.Baseline.Alpha:=255;
		Lookandfeel.Tabs.Modified.Centrecolor:=CLWHITE;
		Lookandfeel.Tabs.Modified.Outsidecolor:=CLWHITE;
		Lookandfeel.Tabs.Modified.Centrealpha:=130;
		Lookandfeel.Tabs.Modified.Outsidealpha:=0;
		Lookandfeel.Tabs.Defaultfont.Name:=AMDF.Font.Name;
		Lookandfeel.Tabs.Defaultfont.Color:=Clblue; // clBlack
		Lookandfeel.Tabs.Defaultfont.Size:=AMDF.Font.Size+1;
		Lookandfeel.Tabs.Defaultfont.Alpha:=255;
		Lookandfeel.Tabs.Defaultfont.Textrenderingmode:=Textrenderinghintcleartypegridfit;
		Lookandfeel.Tabs.Mouseglow.Centrecolor:=CLWHITE;
		Lookandfeel.Tabs.Mouseglow.Outsidecolor:=CLWHITE;
		Lookandfeel.Tabs.Mouseglow.Centrealpha:=120;
		Lookandfeel.Tabs.Mouseglow.Outsidealpha:=0;
		Lookandfeel.Tabs.Spinners.Upload.Color:=12759975;
		Lookandfeel.Tabs.Spinners.Upload.Thickness:=2.5;
		Lookandfeel.Tabs.Spinners.Upload.Alpha:=255;
		Lookandfeel.Tabs.Spinners.Download.Color:=14388040;
		Lookandfeel.Tabs.Spinners.Download.Thickness:=2.5;
		Lookandfeel.Tabs.Spinners.Download.Alpha:=255;
		Lookandfeel.Tabs.Active.Font.Name:='Segoe UI';
		Lookandfeel.Tabs.Active.Font.Color:=Clolive;
		Lookandfeel.Tabs.Active.Font.Size:=AMDF.Font.Size;
		Lookandfeel.Tabs.Active.Font.Alpha:=100;
		Lookandfeel.Tabs.Active.Font.Textrenderingmode:=Textrenderinghintcleartypegridfit;
		Lookandfeel.Tabs.Active.Font.Usedefaultfont:=True;
		Lookandfeel.Tabs.Active.Style.Startcolor:=GetColor(SFR1(15)); // clwhite
		Lookandfeel.Tabs.Active.Style.Stopcolor:=GetColor(SFR1(16)); // 16316920
		Lookandfeel.Tabs.Active.Style.Startalpha:=210;
		Lookandfeel.Tabs.Active.Style.Stopalpha:=210;
		Lookandfeel.Tabs.Active.Style.Outlinecolor:=10189918; // 10189918
		Lookandfeel.Tabs.Active.Style.Outlinesize:=1; // 1.
		Lookandfeel.Tabs.Active.Style.Outlinealpha:=255;
		Lookandfeel.Tabs.Notactive.Font.Name:=AMDF.Font.Name;
		Lookandfeel.Tabs.Notactive.Font.Color:=4603477;
		Lookandfeel.Tabs.Notactive.Font.Size:=AMDF.Font.Size;
		Lookandfeel.Tabs.Notactive.Font.Alpha:=150;
		Lookandfeel.Tabs.Notactive.Font.Textrenderingmode:=Textrenderinghintcleartypegridfit;
		Lookandfeel.Tabs.Notactive.Font.Usedefaultfont:=False;
		Lookandfeel.Tabs.Notactive.Style.Startcolor:=15194573;
		Lookandfeel.Tabs.Notactive.Style.Stopcolor:=15194573;
		Lookandfeel.Tabs.Notactive.Style.Startalpha:=120;
		Lookandfeel.Tabs.Notactive.Style.Stopalpha:=170;
		Lookandfeel.Tabs.Notactive.Style.Outlinecolor:=13546390;
		Lookandfeel.Tabs.Notactive.Style.Outlinesize:=1;
		Lookandfeel.Tabs.Notactive.Style.Outlinealpha:=215;
		Lookandfeel.Tabs.Hot.Font.Name:=AMDF.Font.Name;
		Lookandfeel.Tabs.Hot.Font.Color:=4210752;
		Lookandfeel.Tabs.Hot.Font.Size:=9;
		Lookandfeel.Tabs.Hot.Font.Alpha:=190;
		Lookandfeel.Tabs.Hot.Font.Textrenderingmode:=Textrenderinghintcleartypegridfit;
		Lookandfeel.Tabs.Hot.Font.Usedefaultfont:=False;
		Lookandfeel.Tabs.Hot.Style.Startcolor:=15721176;
		Lookandfeel.Tabs.Hot.Style.Stopcolor:=15589847;
		Lookandfeel.Tabs.Hot.Style.Startalpha:=140;
		Lookandfeel.Tabs.Hot.Style.Stopalpha:=190;
		Lookandfeel.Tabs.Hot.Style.Outlinecolor:=12423799;
		Lookandfeel.Tabs.Hot.Style.Outlinesize:=1;
		Lookandfeel.Tabs.Hot.Style.Outlinealpha:=235;
		Lookandfeel.Closebutton.Cross.Normal.Color:=6643031;
		Lookandfeel.Closebutton.Cross.Normal.Thickness:=2;
		Lookandfeel.Closebutton.Cross.Normal.Alpha:=255;
		Lookandfeel.Closebutton.Cross.Down.Color:=15461369;
		Lookandfeel.Closebutton.Cross.Down.Thickness:=2;
		Lookandfeel.Closebutton.Cross.Down.Alpha:=220;
		Lookandfeel.Closebutton.Cross.Hot.Color:=6643031;
		Lookandfeel.Closebutton.Cross.Hot.Thickness:=2;
		Lookandfeel.Closebutton.Cross.Hot.Alpha:=220;
		Lookandfeel.Closebutton.Circle.Normal.Startcolor:=Clnone;
		Lookandfeel.Closebutton.Circle.Normal.Stopcolor:=Clnone;
		Lookandfeel.Closebutton.Circle.Normal.Startalpha:=0;
		Lookandfeel.Closebutton.Circle.Normal.Stopalpha:=0;
		Lookandfeel.Closebutton.Circle.Normal.Outlinecolor:=Clgray;
		Lookandfeel.Closebutton.Circle.Normal.Outlinesize:=1;
		Lookandfeel.Closebutton.Circle.Normal.Outlinealpha:=0;
		Lookandfeel.Closebutton.Circle.Down.Startcolor:=$00808080; // 3487169
		Lookandfeel.Closebutton.Circle.Down.Stopcolor:=$00808080; // 3487169
		Lookandfeel.Closebutton.Circle.Down.Startalpha:=255;
		Lookandfeel.Closebutton.Circle.Down.Stopalpha:=255;
		Lookandfeel.Closebutton.Circle.Down.Outlinecolor:=Clgray;
		Lookandfeel.Closebutton.Circle.Down.Outlinesize:=1;
		Lookandfeel.Closebutton.Circle.Down.Outlinealpha:=0; // 255
		Lookandfeel.Closebutton.Circle.Hot.Startcolor:=$00C0C0C0; // 9408475
		Lookandfeel.Closebutton.Circle.Hot.Stopcolor:=$00C0C0C0; // 9803748
		Lookandfeel.Closebutton.Circle.Hot.Startalpha:=255;
		Lookandfeel.Closebutton.Circle.Hot.Stopalpha:=255;
		Lookandfeel.Closebutton.Circle.Hot.Outlinecolor:=6054595;
		Lookandfeel.Closebutton.Circle.Hot.Outlinesize:=1;
		Lookandfeel.Closebutton.Circle.Hot.Outlinealpha:=0; // 255
		Lookandfeel.Addbutton.Button.Normal.Startcolor:=14340292;
		Lookandfeel.Addbutton.Button.Normal.Stopcolor:=14340035;
		Lookandfeel.Addbutton.Button.Normal.Startalpha:=255;
		Lookandfeel.Addbutton.Button.Normal.Stopalpha:=255;
		Lookandfeel.Addbutton.Button.Normal.Outlinecolor:=13088421;
		Lookandfeel.Addbutton.Button.Normal.Outlinesize:=1;
		Lookandfeel.Addbutton.Button.Normal.Outlinealpha:=255;
		Lookandfeel.Addbutton.Button.Down.Startcolor:=13417645;
		Lookandfeel.Addbutton.Button.Down.Stopcolor:=13417644;
		Lookandfeel.Addbutton.Button.Down.Startalpha:=255;
		Lookandfeel.Addbutton.Button.Down.Stopalpha:=255;
		Lookandfeel.Addbutton.Button.Down.Outlinecolor:=10852748;
		Lookandfeel.Addbutton.Button.Down.Outlinesize:=1;
		Lookandfeel.Addbutton.Button.Down.Outlinealpha:=255;
		Lookandfeel.Addbutton.Button.Hot.Startcolor:=15524314;
		Lookandfeel.Addbutton.Button.Hot.Stopcolor:=15524314;
		Lookandfeel.Addbutton.Button.Hot.Startalpha:=255;
		Lookandfeel.Addbutton.Button.Hot.Stopalpha:=255;
		Lookandfeel.Addbutton.Button.Hot.Outlinecolor:=14927787;
		Lookandfeel.Addbutton.Button.Hot.Outlinesize:=1;
		Lookandfeel.Addbutton.Button.Hot.Outlinealpha:=255;
		Lookandfeel.Addbutton.Plussign.Normal.Startcolor:=CLWHITE;
		Lookandfeel.Addbutton.Plussign.Normal.Stopcolor:=CLWHITE;
		Lookandfeel.Addbutton.Plussign.Normal.Startalpha:=255;
		Lookandfeel.Addbutton.Plussign.Normal.Stopalpha:=255;
		Lookandfeel.Addbutton.Plussign.Normal.Outlinecolor:=Clgray;
		Lookandfeel.Addbutton.Plussign.Normal.Outlinesize:=1;
		Lookandfeel.Addbutton.Plussign.Normal.Outlinealpha:=255;
		Lookandfeel.Addbutton.Plussign.Down.Startcolor:=CLWHITE;
		Lookandfeel.Addbutton.Plussign.Down.Stopcolor:=CLWHITE;
		Lookandfeel.Addbutton.Plussign.Down.Startalpha:=255;
		Lookandfeel.Addbutton.Plussign.Down.Stopalpha:=255;
		Lookandfeel.Addbutton.Plussign.Down.Outlinecolor:=Clgray;
		Lookandfeel.Addbutton.Plussign.Down.Outlinesize:=1;
		Lookandfeel.Addbutton.Plussign.Down.Outlinealpha:=255;
		Lookandfeel.Addbutton.Plussign.Hot.Startcolor:=CLWHITE;
		Lookandfeel.Addbutton.Plussign.Hot.Stopcolor:=CLWHITE;
		Lookandfeel.Addbutton.Plussign.Hot.Startalpha:=255;
		Lookandfeel.Addbutton.Plussign.Hot.Stopalpha:=255;
		Lookandfeel.Addbutton.Plussign.Hot.Outlinecolor:=Clgray;
		Lookandfeel.Addbutton.Plussign.Hot.Outlinesize:=1;
		Lookandfeel.Addbutton.Plussign.Hot.Outlinealpha:=255;
		Lookandfeel.Scrollbuttons.Button.Normal.Startcolor:=14735310;
		Lookandfeel.Scrollbuttons.Button.Normal.Stopcolor:=14274499;
		Lookandfeel.Scrollbuttons.Button.Normal.Startalpha:=0;
		Lookandfeel.Scrollbuttons.Button.Normal.Stopalpha:=0;
		Lookandfeel.Scrollbuttons.Button.Normal.Outlinecolor:=11507842;
		Lookandfeel.Scrollbuttons.Button.Normal.Outlinesize:=0;
		Lookandfeel.Scrollbuttons.Button.Normal.Outlinealpha:=0;
		Lookandfeel.Scrollbuttons.Button.Down.Startcolor:=13417645;
		Lookandfeel.Scrollbuttons.Button.Down.Stopcolor:=13417644;
		Lookandfeel.Scrollbuttons.Button.Down.Startalpha:=0;
		Lookandfeel.Scrollbuttons.Button.Down.Stopalpha:=0;
		Lookandfeel.Scrollbuttons.Button.Down.Outlinecolor:=10852748;
		Lookandfeel.Scrollbuttons.Button.Down.Outlinesize:=0;
		Lookandfeel.Scrollbuttons.Button.Down.Outlinealpha:=0;
		Lookandfeel.Scrollbuttons.Button.Hot.Startcolor:=15524314;
		Lookandfeel.Scrollbuttons.Button.Hot.Stopcolor:=15524313;
		Lookandfeel.Scrollbuttons.Button.Hot.Startalpha:=0;
		Lookandfeel.Scrollbuttons.Button.Hot.Stopalpha:=0;
		Lookandfeel.Scrollbuttons.Button.Hot.Outlinecolor:=14927788;
		Lookandfeel.Scrollbuttons.Button.Hot.Outlinesize:=0;
		Lookandfeel.Scrollbuttons.Button.Hot.Outlinealpha:=0;
		Lookandfeel.Scrollbuttons.Button.Disabled.Startcolor:=14340036;
		Lookandfeel.Scrollbuttons.Button.Disabled.Stopcolor:=14274499;
		Lookandfeel.Scrollbuttons.Button.Disabled.Startalpha:=0;
		Lookandfeel.Scrollbuttons.Button.Disabled.Stopalpha:=0;
		Lookandfeel.Scrollbuttons.Button.Disabled.Outlinecolor:=11113341;
		Lookandfeel.Scrollbuttons.Button.Disabled.Outlinesize:=0;
		Lookandfeel.Scrollbuttons.Button.Disabled.Outlinealpha:=0;
		Lookandfeel.Scrollbuttons.Arrow.Normal.Startcolor:=ClHighlight;
		Lookandfeel.Scrollbuttons.Arrow.Normal.Stopcolor:=CLWHITE;
		Lookandfeel.Scrollbuttons.Arrow.Normal.Startalpha:=255;
		Lookandfeel.Scrollbuttons.Arrow.Normal.Stopalpha:=255;
		Lookandfeel.Scrollbuttons.Arrow.Normal.Outlinecolor:=Clgray;
		Lookandfeel.Scrollbuttons.Arrow.Normal.Outlinesize:=1;
		Lookandfeel.Scrollbuttons.Arrow.Normal.Outlinealpha:=200;
		Lookandfeel.Scrollbuttons.Arrow.Down.Startcolor:=CLWHITE;
		Lookandfeel.Scrollbuttons.Arrow.Down.Stopcolor:=CLWHITE;
		Lookandfeel.Scrollbuttons.Arrow.Down.Startalpha:=255;
		Lookandfeel.Scrollbuttons.Arrow.Down.Stopalpha:=255;
		Lookandfeel.Scrollbuttons.Arrow.Down.Outlinecolor:=Clgray;
		Lookandfeel.Scrollbuttons.Arrow.Down.Outlinesize:=1;
		Lookandfeel.Scrollbuttons.Arrow.Down.Outlinealpha:=200;
		Lookandfeel.Scrollbuttons.Arrow.Hot.Startcolor:=CLWHITE;
		Lookandfeel.Scrollbuttons.Arrow.Hot.Stopcolor:=CLWHITE;
		Lookandfeel.Scrollbuttons.Arrow.Hot.Startalpha:=255;
		Lookandfeel.Scrollbuttons.Arrow.Hot.Stopalpha:=255;
		Lookandfeel.Scrollbuttons.Arrow.Hot.Outlinecolor:=Clgray;
		Lookandfeel.Scrollbuttons.Arrow.Hot.Outlinesize:=1;
		Lookandfeel.Scrollbuttons.Arrow.Hot.Outlinealpha:=200;
		Lookandfeel.Scrollbuttons.Arrow.Disabled.Startcolor:=Clsilver;
		Lookandfeel.Scrollbuttons.Arrow.Disabled.Stopcolor:=Clsilver;
		Lookandfeel.Scrollbuttons.Arrow.Disabled.Startalpha:=150;
		Lookandfeel.Scrollbuttons.Arrow.Disabled.Stopalpha:=150;
		Lookandfeel.Scrollbuttons.Arrow.Disabled.Outlinecolor:=Clgray;
		Lookandfeel.Scrollbuttons.Arrow.Disabled.Outlinesize:=1;
		Lookandfeel.Scrollbuttons.Arrow.Disabled.Outlinealpha:=200;
	end;
end;

procedure CreatTStart(N:Integer);
var
	t,I:Integer;
	S11,MH:string;
begin
	CN[N].Execsql('PRAGMA page_size = 65536');
	CN[N].Execsql('PRAGMA max_page_count = 2147483646');
	if (N=1) then begin
		try
			CN[1].Execsql(Ct1+'LANG ('+Idn1+',English'+Tn1+',Arabic'+Tn1+')');
			CN[1].Execsql(Ct1+'REF('+Idn1+',rec'+Tn1+')');
			CN[1].Execsql(Ct1+'USERS('+Idn1+',ST'+Nn1+',UserN'+Tn1+',PassN'+Tn1+',INX'+Nn1+',HintN'+Tn1+',ReN'+Tn1+
				',UserT'+Nn1+')');
			CN[1].Execsql(Ct1+'JT ('+Idn1+',INX'+Nn1+',English'+Tn1+',Arabic'+Tn1+')');
			CN[1].Execsql(Ct1+'MSJ ('+Idn1+',REF'+Nn1+',English'+Tn1+',Arabic'+Tn1+')');
			CN[1].Execsql('INSERT INTO USERS (ST,UserN,PassN,INX,HintN,ReN,UserT)'+'VALUES("1","The GM","'+MDFive('')+
				'", "-1"'+',"The GM","1","1")');
			CN[1].Execsql('INSERT INTO JT (INX,English)VALUES'+'("-1","General Manager")');
			SHOWMESSAGE('AMD : Some Files is Missing'#13#10'Try To Reinstall Them');
		except
			on E:Exception do SHOWMESSAGE(N.Tostring+#13#10+E.Tostring);
		end;
	end;
	if (N=2) then begin
		try
			// DOCM.
			CN[2].Execsql(Ct1+'DOCM ('+Idn1+',KI'+Tn1+',MH'+Tn1+',NU'+Nn1+',DES'+Tn1+',INX'+Nn1+')');
			// ITEMS.
			CN[2].Execsql(Ct1+'NIT ('+Idn2+',CODE'+Tn1+' UNIQUE,REF'+Tn1+',KI'+Nn1+',END'+Nn1+',PR'+Tn1+',CO'+Tn1+',PC'+Tn1+
				',DIS'+Tn1+',ADS'+Tn1+',VAT'+Tn1+',NSN'+Tn1+',NCCE'+Tn1+',INX'+Nn1+')');
			// CLIENTS.
			CN[2].Execsql(Ct1+'NCLIENTS ('+Idn2+',CODE'+Tn1+',REF'+Tn1+',KI'+Nn1+',END'+Nn1+Etstr+')');
			// ACCOUNTS.
			CN[2].Execsql(Ct1+'NACC ('+Idn2+',CODE'+Nn1+' UNIQUE,MH'+Tn1+',REF'+Nn1+',KI'+Nn1+',BG'+Nn1+',END'+Nn1+
				',INX'+Nn1+')');
			// COST CENTERS.
			CN[2].Execsql(Ct1+'NCCE ('+Idn2+',REF'+Nn1+',KL'+Nn1+',INX'+Nn1+')');
			// SECTION TYPE.
			CN[2].Execsql(Ct1+'NST ('+Idn2+',REF'+Nn1+',KL'+Nn1+Etstr+')');
			// STORE NAME.
			CN[2].Execsql(Ct1+'NSN ('+Idn2+',REF'+Nn1+',KL'+Nn1+Etstr+')');
			// CURRENCY NAME.
			CN[2].Execsql(Ct1+'NCR1 ('+Idn2+',REF'+Nn1+',KL'+Nn1+',INX'+Nn1+')');
			// CURRENCY CHILD NAME.
			CN[2].Execsql(Ct1+'NCR2 ('+Idn2+',REF'+Nn1+',KL'+Nn1+',INX'+Nn1+')');
			// TEMLATE.
			CN[2].Execsql(Ct1+'TMPS ('+Idn1+',TBL'+Tn1+')');
			// PRICE BY QTY.
			CN[2].Execsql(Ct1+'NITQY ('+Idn1+',CODE'+Tn1+',QY1'+Rn1+',QY2'+Rn1+',PR'+Tn1+')');
			// PRICE BY CUSTOMER.
			CN[2].Execsql(Ct1+'NITCU ('+Idn1+',CODE'+Tn1+',FRM'+Tn1+',PR'+Tn1+')');
			// PRICE BY QTY AND CUSTOMER.
			CN[2].Execsql(Ct1+'NITCUQY ('+Idn1+',CODE'+Tn1+',FRM'+Tn1+',QY1'+Rn1+',QY2'+Rn1+',PR'+Tn1+')');
			// ADD LANGUAGE COLUMENS
			FQ[2].Open('SELECT DISTINCT tbl_name FROM "main".sqlite_master WHERE tbl_name NOT IN'+
				' ("sqlite_sequence","NITCUQY","NITCU","NITQY","TMPS") AND tbl_name NOT IN'+
				' (SELECT TBL FROM TMPS WHERE TBL<>"")');
			// FQ[1].Open('SELECT name FROM pragma_table_info("LANG") WHERE cid>0');
			FQ[1].Open('pragma table_info("LANG")');
			for I:=1 to FQ[2].RowsAffected do begin
				for t:=1 to FQ[1].RowsAffected-1 do begin
					FQ[1].Next;
					S11:=FQ[1].Fields[1].Asstring;
					CN[2].Execsql('ALTER TABLE '+FQ[2].Fields[0].Asstring+' ADD COLUMN '+S11+Tn1);
				end;
				FQ[2].Next;
			end;
			// INSERT IN ACCONTS
			CN[2].Execsql('INSERT INTO NACCONTS (US,ST,CODE,REF,KI,KE,END,INX,English)'+
				'VALUES("0","0","1","BUD","0","0","0","1","Statement of Financial Position ( The Budget )")');
			CN[2].Execsql('INSERT INTO NACCONTS (US,ST,CODE,REF,KI,KE,END,INX,English)'+
				'VALUES("0","0","2","CFL","0","0","0","2","Cash Flow statement")');
			CN[2].Execsql('INSERT INTO NACCONTS (US,ST,CODE,REF,KI,KE,END,INX,English)'+
				'VALUES("0","0","3","POL","1","0","1","3","List of Profits and Losses")');
			CN[2].Execsql('INSERT INTO NACCONTS (US,ST,CODE,REF,KI,KE,END,INX,English)'+
				'VALUES("0","0","4","TRD","1","0","3","4","Trading List")');
			CN[2].Execsql('INSERT INTO NACCONTS (US,ST,CODE,REF,KI,KE,END,INX,English)'+
				'VALUES("0","0","5","COS","1","0","4","5","List of cost of sales")');
			CN[2].Execsql('INSERT INTO NACCONTS (US,ST,CODE,REF,KI,KE,END,INX,English)'+
				'VALUES("0","0","6","COP","1","0","5","6","List of cost of production")');
			CN[2].Execsql('INSERT INTO NACCONTS (US,ST,CODE,REF,KI,KE,END,INX,English)'+
				'VALUES("0","0","7","NSN","0","0","0","7","Cost of Inventory")');
			// INSERT
			CN[2].Execsql('INSERT INTO DOCM (MH,NU,KI,English)VALUES("SINV","3","A","Sales Voucher")');
			CN[2].Execsql('INSERT INTO DOCM (MH,NU,KI,English)VALUES("PINV","4","B","Purchases Voucher")');
			CN[2].Execsql('INSERT INTO DOCM (MH,NU,KI,English)VALUES("CINV","3","C","Sales Return")');
			CN[2].Execsql('INSERT INTO DOCM (MH,NU,KI,English)VALUES("DINV","4","D","Purchases Return")');
			CN[2].Execsql('INSERT INTO DOCM (MH,NU,KI,English)VALUES("SOINV","3","S","Sales Order")');
			CN[2].Execsql('INSERT INTO DOCM (MH,NU,KI,English)VALUES("POINV","6","P","Purchases Order")');
			CN[2].Execsql('INSERT INTO DOCM (MH,NU,KI,English)VALUES("QINV","7","Q","Journal Entry")');
			CN[2].Execsql('INSERT INTO NST (US,ST,REF,INX,English)VALUES("1", "1","S1/01-5","-1","Main")');
			CN[2].Execsql('INSERT INTO NSN (US,ST,REF,INX,English)VALUES("1", "1","N1/01-1","-1","Main")');
		except
			on E:Exception do SHOWMESSAGE(N.Tostring+#13#10+E.Tostring);
		end;
	end;
	if (N=3) then begin
		try
			// SALES+RETURNS
			CN[3].Execsql(Ct1+'SINV ('+Idn2+',SN'+Nn1+',ICODE'+Nn1+',IFRM'+Nn1+',FRM'+Tn1+',REF'+Tn1+',SA'+Tn1+',DS'+Tn1+',AD'
				+Tn1+',VT'+Tn1+',CE'+Nn1+',DAT'+Tn1+',DAT1'+Tn1+',COMM'+Tn1+',PRC'+Nn1+',SEC'+Tn1+')');
			CN[3].Execsql(Ct1+'CINV ('+Idn2+',SN'+Nn1+',ICODE'+Nn1+',IFRM'+Nn1+',FRM'+Tn1+',REF'+Tn1+',SA'+Tn1+',DS'+Tn1+',AD'
				+Tn1+',VT'+Tn1+',CE'+Nn1+',DAT'+Tn1+',DAT1'+Tn1+',COMM'+Tn1+',PRC'+Nn1+',SEC'+Tn1+')');
			CN[3].Execsql(Ct1+'SOINV ('+Idn2+',SN'+Nn1+',ICODE'+Nn1+',IFRM'+Nn1+',FRM'+Tn1+',REF'+Tn1+',SA'+Tn1+',DS'+Tn1+
				',AD'+Tn1+',VT'+Tn1+',CE'+Nn1+',DAT'+Tn1+',DAT1'+Tn1+',COMM'+Tn1+',PRC'+Nn1+',SEC'+Tn1+')');
		except
			on E:Exception do SHOWMESSAGE(N.Tostring+#13#10+E.Tostring);
		end;
	end;
	if (N=4) then begin
		try
			// PURCHASES+RETURNS
			CN[4].Execsql(Ct1+'PINV ('+Idn2+',SN'+Nn1+',ICODE'+Nn1+',IFRM'+Nn1+',FRM'+Tn1+',REF'+Tn1+',SA'+Tn1+',DS'+Tn1+',AD'
				+Tn1+',VT'+Tn1+',CE'+Nn1+',DAT'+Tn1+',DAT1'+Tn1+',COMM'+Tn1+',PRC'+Nn1+',SEC'+Tn1+')');
			CN[4].Execsql(Ct1+'DINV ('+Idn2+',SN'+Nn1+',ICODE'+Nn1+',IFRM'+Nn1+',FRM'+Tn1+',REF'+Tn1+',SA'+Tn1+',DS'+Tn1+',AD'
				+Tn1+',VT'+Tn1+',CE'+Nn1+',DAT'+Tn1+',DAT1'+Tn1+',COMM'+Tn1+',PRC'+Nn1+',SEC'+Tn1+')');
			CN[4].Execsql(Ct1+'POINV ('+Idn2+',SN'+Nn1+',ICODE'+Nn1+',IFRM'+Nn1+',FRM'+Tn1+',REF'+Tn1+',SA'+Tn1+',DS'+Tn1+
				',AD'+Tn1+',VT'+Tn1+',CE'+Nn1+',DAT'+Tn1+',DAT1'+Tn1+',COMM'+Tn1+',PRC'+Nn1+',SEC'+Tn1+')');
		except
			on E:Exception do SHOWMESSAGE(N.Tostring+#13#10+E.Tostring);
		end;
	end;
	if (N=5) then begin
		try
			CN[5].Execsql(Ct1+'BALANCES ('+Idn2+',KI'+Nn1+',BG'+Tn1+',ACC'+Tn1+',AM1'+Tn1+',AM2'+Tn1+')');
			FQ[2].Open('SELECT CODE FROM NCLIENTS ORDER BY id ASC');
			if (FQ[2].RowsAffected>0) then begin
				for t:=0 to FQ[2].RowsAffected-1 do begin
					S11:=FQ[2].Fields[0].Asstring;
					CN[5].Execsql(Ct1+'C'+S11+' ('+Idn2+',ICODE'+Nn1+',RIF'+Nn1+',AM1'+Tn1+',AM2'+Tn1+',DAT'+Tn1+',COMM'+Tn1+')');
					FQ[2].Next;
				end;
			end;
			FQ[2].Open('SELECT MH FROM NACC ORDER BY id ASC');
			if (FQ[2].RowsAffected>0) then begin
				for t:=0 to FQ[2].RowsAffected-1 do begin
					MH:=FQ[2].Fields[0].Asstring;
					CN[5].Execsql(Ct1+MH+' ('+Idn2+',ICODE'+Nn1+',RIF'+Tn1+',AM1'+Tn1+',AM2'+Tn1+',DAT'+Tn1+',COMM'+Tn1+')');
					FQ[2].Next;
				end;
			end;
			FQ[2].Open('SELECT id FROM NCCE WHERE REF="1" ORDER BY id ASC');
			if (FQ[2].RowsAffected>0) then begin
				for t:=0 to FQ[2].RowsAffected-1 do begin
					MH:=FQ[2].Fields[0].Asstring;
					CN[5].Execsql(Ct1+'CCE'+MH+' ('+Idn2+',ICODE'+Nn1+',RIF'+Tn1+',AM1'+Tn1+',AM2'+Tn1+',DAT'+Tn1+
						',COMM'+Tn1+')');
					FQ[2].Next;
				end;
			end;
		except
			on E:Exception do SHOWMESSAGE(N.Tostring+#13#10+E.Tostring);
		end;
	end;
	if (N=6) then begin
		try CN[6].Execsql(Ct1+'QINV ('+Idn2+',ICODE'+Nn1+',ICODE1'+Nn1+',RIF'+Nn1+',DAT'+Tn1+',COMM'+Tn1+',SEC'+Tn1+')');
		except
			on E:Exception do SHOWMESSAGE(N.Tostring+#13#10+E.Tostring);
		end;
	end;
	if (N=7) then begin
		try CN[7].Execsql(Ct1+'EDT ('+Idn1+',US'+Tn1+',US1'+Tn1+',ST'+Tn1+',ST1'+Tn1+',SN'+Tn1+',ICODE'+Nn1+',RIF'+Nn1+
				',IFRM'+Nn1+',FRM'+Tn1+',REF'+Tn1+',CONT'+Nn1+',STAT'+Nn1+',PRC'+Nn1+',SA'+Tn1+',DS'+Tn1+',AD'+Tn1+',VT'+Tn1+
				',CE'+Nn1+',DATA'+Tn1+',DATE'+Tn1+',DAT1'+Tn1+',COMM'+Tn1+')');
		except
			on E:Exception do SHOWMESSAGE(N.Tostring+#13#10+E.Tostring);
		end;
	end;
	if (N=8) then begin
		try
			FQ[2].Open('SELECT id FROM NSN ORDER BY id ASC');
			if (FQ[2].RowsAffected>0) then begin
				for t:=0 to FQ[2].RowsAffected-1 do begin
					CN[8].Execsql(Ct1+'SN'+FQ[2].Fields[0].Asstring+' ('+Idn2+',CODE'+Tn1+',ICODE'+Nn1+',RIF'+Nn1+',FRM'+Tn1+
						',REF'+Tn1+',QTY'+Tn1+',DAT'+Tn1+')');
					FQ[2].Next;
				end;
			end;
			FQ[2].Open('SELECT CODE FROM NIT ORDER BY id ASC');
			if (FQ[2].RowsAffected>0) then begin
				for t:=0 to FQ[2].RowsAffected-1 do begin
					CN[8].Execsql(Ct1+'T'+FQ[2].Fields[0].Asstring+' ('+Idn2+',SN'+Nn1+',ICODE'+Nn1+',RIF'+Nn1+',IFRM'+Nn1+',FRM'+
						Tn1+',REF'+Tn1+',QTY'+Tn1+',PR'+Tn1+',COMM'+Tn1+',DAT'+Tn1+')');
					FQ[2].Next;
				end;
			end;
		except
			on E:Exception do SHOWMESSAGE(N.Tostring+#13#10+E.Tostring);
		end;
	end;
	if (N=9) then begin
		try

		except
			on E:Exception do SHOWMESSAGE(N.Tostring+#13#10+E.Tostring);
		end;
	end;
end;

function PR0(Sub:string;Vstr:string):Integer;
var
	Ns,Txt:string;
	Delta,Con,Dx:Integer;
begin
	Con:=0;
	Result:=0;
	if (Sub<>'')and(Vstr<>'') then begin
		Delta:=Length(',');
		Txt:=Trim(Vstr)+',';
		try
			while Length(Txt)>Delta do begin
				Con:=Con+1;
				Dx:=Pos(',',Txt);
				Ns:=Copy(Txt,0,Dx-1);
				if (Sub=Ns) then begin
					Result:=Con;
					EXIT;
				end;
				Txt:=Copy(Txt,Dx+Delta,Maxint);
			end;
		except
			on E:Exception do Result:=0;
		end;
	end;
end;

function GR0(Value:string;Delimiter:string):Integer;
var
	Ns,Txt:string;
	Delta,Con,Dx,I0:Integer;
begin
	Con:=0;
	Result:=0;
	if (Value<>'')and(Delimiter<>'') then begin
		for I0:=1 to 1000 do begin
			S0[I0]:='';
		end;
		Delta:=Length(Delimiter);
		Txt:=Trim(Value)+Delimiter;
		try
			while Length(Txt)>Delta do begin
				Con:=Con+1;
				Dx:=Pos(Delimiter,Txt);
				Ns:=Copy(Txt,0,Dx-1);
				S0[Con]:=Ns;
				Txt:=Copy(Txt,Dx+Delta,Maxint);
			end;
		finally Result:=Con;
		end;
	end;
end;

function GR1(Value:string;Delimiter:string):Integer;
var
	Ns1,Txt1:string;
	Delta1,Con1,Dx1,I1:Integer;
begin
	Con1:=0;
	Result:=0;
	if (Value<>'')and(Delimiter<>'') then begin
		for I1:=1 to 1000 do begin
			S1[I1]:='';
		end;
		Delta1:=Length(Delimiter);
		Txt1:=Trim(Value)+Delimiter;
		try
			while Length(Txt1)>Delta1 do begin
				Con1:=Con1+1;
				Dx1:=Pos(Delimiter,Txt1);
				Ns1:=Copy(Txt1,0,Dx1-1);
				S1[Con1]:=Ns1;
				Txt1:=Copy(Txt1,Dx1+Delta1,Maxint);
			end;
		finally Result:=Con1;
		end;
	end;
end;

function GR2(Value:string;Delimiter:string):Integer;
var
	Ns2,Txt2:string;
	Delta2,Con2,Dx2,I2:Integer;
begin
	Con2:=0;
	Result:=0;
	if (Value<>'')and(Delimiter<>'') then begin
		for I2:=1 to 1000 do begin
			S2[I2]:='';
		end;
		Delta2:=Length(Delimiter);
		Txt2:=Trim(Value)+Delimiter;
		try
			while Length(Txt2)>Delta2 do begin
				Con2:=Con2+1;
				Dx2:=Pos(Delimiter,Txt2);
				Ns2:=Copy(Txt2,0,Dx2-1);
				S2[Con2]:=Ns2;
				Txt2:=Copy(Txt2,Dx2+Delta2,Maxint);
			end;
		finally Result:=Con2;
		end;
	end;
end;

function GR3(Value:string;Delimiter:string):Integer;
var
	Ns3,Txt3:string;
	Delta3,Con3,Dx3,I3:Integer;
begin
	Con3:=0;
	Result:=0;
	if (Value<>'')and(Delimiter<>'') then begin
		for I3:=1 to 1000 do begin
			S3[I3]:='';
		end;
		Delta3:=Length(Delimiter);
		Txt3:=Trim(Value)+Delimiter;
		try
			while Length(Txt3)>Delta3 do begin
				Con3:=Con3+1;
				Dx3:=Pos(Delimiter,Txt3);
				Ns3:=Copy(Txt3,0,Dx3-1);
				S3[Con3]:=Ns3;
				Txt3:=Copy(Txt3,Dx3+Delta3,Maxint);
			end;
		finally Result:=Con3;
		end;
	end;
end;

function GR4(Value:string;Delimiter:string):Integer;
var
	Ns2,Txt2:string;
	Delta2,Con2,Dx2,I2:Integer;
begin
	Con2:=0;
	Result:=0;
	if (Value<>'')and(Delimiter<>'') then begin
		for I2:=1 to 1000 do begin
			S4[I2]:='';
		end;
		Delta2:=Length(Delimiter);
		Txt2:=Trim(Value)+Delimiter;
		try
			while Length(Txt2)>Delta2 do begin
				Con2:=Con2+1;
				Dx2:=Pos(Delimiter,Txt2);
				Ns2:=Copy(Txt2,0,Dx2-1);
				S4[Con2]:=Ns2;
				Txt2:=Copy(Txt2,Dx2+Delta2,Maxint);
			end;
		finally Result:=Con2;
		end;
	end;
end;

function GR5(Value:string;Delimiter:string):Integer;
var
	Ns3,Txt3:string;
	Delta3,Con3,Dx3,I3:Integer;
begin
	Con3:=0;
	Result:=0;
	if (Value<>'')and(Delimiter<>'') then begin
		for I3:=1 to 1000 do begin
			S5[I3]:='';
		end;
		Delta3:=Length(Delimiter);
		Txt3:=Trim(Value)+Delimiter;
		try
			while Length(Txt3)>Delta3 do begin
				Con3:=Con3+1;
				Dx3:=Pos(Delimiter,Txt3);
				Ns3:=Copy(Txt3,0,Dx3-1);
				S5[Con3]:=Ns3;
				Txt3:=Copy(Txt3,Dx3+Delta3,Maxint);
			end;
		finally Result:=Con3;
		end;
	end;
end;

function B64BT(const Base64:string):TBitmap;
var
	Input:TStringStream;
	Output:Tmemorystream;
begin
	Input:=TStringStream.Create(Base64);
	try
		Output:=Tmemorystream.Create;
		try
			Decodestream(Input,Output);
			Output.Position:=0;
			Result:=TBitmap.Create;
			try Result.LoadFromStream(Output);
			except
				on E:Exception do begin
					Result.Free;
					raise;
				end;
			end;
		finally Output.Free;
		end;
	finally Input.Free;
	end;
end;

function BTB64(Path:string):string;
var
	Input:Tmemorystream;
	Output:TStringStream;
	Bitmap:TBitmap;
	Imgsq:Timage;
begin
	Imgsq:=Timage.Create(AMDF);
	Imgsq.Parent:=AMDF;
	Imgsq.Visible:=False;
	Imgsq.Autosize:=True;
	Imgsq.Picture.LoadFromFile(Path);
	Bitmap:=TBitmap.Create;
	Bitmap.Pixelformat:=Pf32bit;
	Bitmap.Assign(Imgsq.Picture.Graphic);
	Input:=Tmemorystream.Create;
	try
		Bitmap.SaveToStream(Input);
		Input.Position:=0;
		Output:=TStringStream.Create('');
		try
			Encodestream(Input,Output);
			Result:=Output.DataString;
		finally Output.Free;
		end;
	finally
		Bitmap.Free;
		Imgsq.Free;
		Input.Free;
	end;
end;

function StyleToStr(Style:TFontStyles):string;
begin
	SetLength(Result,4);
	Result[1]:=Char(Integer(Fsbold in Style)+83);
	Result[2]:=Char(Integer(Fsitalic in Style)+83);
	Result[3]:=Char(Integer(Fsunderline in Style)+83);
	Result[4]:=Char(Integer(Fsstrikeout in Style)+83);
	Result:=Stringreplace(Result,'S','F',[Rfreplaceall]);
end;

function StrToStyle(Strs:string):TFontStyles;
begin
	Result:=[];
	if Strs[1]='T' then Include(Result,Fsbold);
	if Strs[2]='T' then Include(Result,Fsitalic);
	if Strs[3]='T' then Include(Result,Fsunderline);
	if Strs[4]='T' then Include(Result,Fsstrikeout);
end;

function GetColor(Input:string):TColor;
var
	R,G,B:Integer;
begin
	try
		R:=Strtoint(Copy(Input,1,Pos(',',Input)-1));
		Delete(Input,1,Pos(',',Input));
		G:=Strtoint(Copy(Input,1,Pos(',',Input)-1));
		Delete(Input,1,Pos(',',Input));
		B:=Strtoint(Copy(Input,1,Length(Input)));
	except
		R:=0;
		G:=0;
		B:=0;
	end;
	Result:=Rgb(R,G,B);
end;

function GetRGB(Input1:TColor):string;
var
	R,G,B:Byte;
begin
	Input1:=Colortorgb(Input1);
	R:=Getrvalue(Input1);
	G:=Getgvalue(Input1);
	B:=Getbvalue(Input1);
	Result:=IntToStr(R)+','+IntToStr(G)+','+IntToStr(B);
end;

function Get_Date(Nex:Integer):string;
var
	DD:Extended;
	N: array [1..8] of string;
begin
	DD:=Date+Nex;
	N[1]:=Formatdatetime('yyyy',DD);
	N[2]:=Formatdatetime('MM',DD);
	N[3]:=Formatdatetime('dd',DD);
	Result:=N[1]+N[2]+N[3];
end;

function Get_Time:string;
var
	N: array [1..8] of string;
begin
	N[1]:=Formatdatetime('HH',Time);
	N[2]:=Formatdatetime('nn',Time);
	N[3]:=Formatdatetime('ss',Time);
	N[4]:=Formatdatetime('ZZZ',Time);
	Result:=N[1]+N[2]+N[3]+N[4];
end;

function GDT(Nex:Integer):string;
var
	DD:Extended;
	N: array [1..8] of string;
begin
	DD:=Incday(Date,Nex);
	N[1]:=Formatdatetime('yyyy',DD);
	N[2]:=Formatdatetime('MM',DD);
	N[3]:=Formatdatetime('dd',DD);
	N[4]:=Formatdatetime('HH',Time);
	N[5]:=Formatdatetime('nn',Time);
	N[6]:=Formatdatetime('ss',Time);
	N[7]:=Formatdatetime('ZZZ',Time);
	Result:=N[1]+N[2]+N[3]+N[4]+N[5]+N[6]+N[7];
end;

function DTtoN(D:string=''):UInt64;
var
	D3:Extended;
	N: array [1..7] of string;
begin
	Result:=0;
	try
		if (D='') then begin
			D:=Datetostr(Date)+' '+Timetostr(Time);
		end;
		D3:=Strtodatetime(D);
		N[1]:=Formatdatetime('yyyy',D3);
		N[2]:=Formatdatetime('MM',D3);
		N[3]:=Formatdatetime('dd',D3);
		N[4]:=Formatdatetime('HH',D3);
		N[5]:=Formatdatetime('nn',D3);
		N[6]:=Formatdatetime('ss',D3);
		N[7]:=Formatdatetime('ZZZ',Time);
		Result:=Strtoint64(N[1]+N[2]+N[3]+N[4]+N[5]+N[6]+N[7]);
	except
		on E:Exception do Result:=0;
	end;
end;

function DtToN1(D:string=''):UInt64;
var
	D3:Extended;
	N: array [1..3] of string;
begin
	Result:=0;
	try
		if (D='') then begin
			D:=Datetostr(Date);
		end;
		D3:=Strtodatetime(D);
		N[1]:=Formatdatetime('yyyy',D3);
		N[2]:=Formatdatetime('MM',D3);
		N[3]:=Formatdatetime('dd',D3);
		Result:=Strtoint64(N[1]+N[2]+N[3]);
	except
		on E:Exception do Result:=0;
	end;
end;

function DtToN2(D:string=''):UInt64;
var
	D3:Extended;
	N: array [1..4] of string;
begin
	Result:=0;
	try
		if (D='') then begin
			D:=Datetostr(Date);
		end;
		D3:=Strtodatetime(D);
		N[1]:=Formatdatetime('HH',D3);
		N[2]:=Formatdatetime('nn',D3);
		N[3]:=Formatdatetime('ss',D3);
		N[4]:=Formatdatetime('ZZZ',Time);
		Result:=Strtoint64(N[1]+N[2]+N[3]+N[4]);
	except
		on E:Exception do Result:=0;
	end;
end;

function NToDt0(D:string):string;
var
	Dt1:Extended;
	NL: array [1..3] of Integer;
begin
	Result:='';
	try
		NL[1]:=Strtoint(Copy(D,1,4));
		NL[2]:=Strtoint(Copy(D,5,2));
		NL[3]:=Strtoint(Copy(D,7,2));
		Dt1:=Encodedate(NL[1],NL[2],NL[3]);
		Result:=Formatdatetime(Formatsettings.Shortdateformat,Dt1);
	except
	end;
end;

function NToDt(D:string;var Dt,TMR:Extended):string;
var
	Dt1:Extended;
	NL: array [1..8] of Integer;
begin
	Result:='';
	Dt:=0;
	TMR:=0;
	try
		NL[1]:=Strtoint(Copy(D,0,4));
		NL[2]:=Strtoint(Copy(D,5,2));
		NL[3]:=Strtoint(Copy(D,7,2));
		NL[4]:=Strtoint(Copy(D,9,2));
		NL[5]:=Strtoint(Copy(D,11,2));
		NL[6]:=Strtoint(Copy(D,13,2));
		NL[7]:=Strtoint(Copy(D,15,3));
		Dt1:=Encodedatetime(NL[1],NL[2],NL[3],NL[4],NL[5],NL[6],NL[7]);
		Dt:=Encodedate(NL[1],NL[2],NL[3]);
		TMR:=EncodeTime(NL[4],NL[5],NL[6],NL[7]);
		Result:=Formatdatetime(Formatsettings.Shortdateformat+'|'+Formatsettings.Shorttimeformat,Dt1);
	except
		on E:Exception do begin
			Result:='';
			Dt:=0;
			TMR:=0;
		end;
	end;
end;

/// ///////////////////////////// DRAG IMAGE ///////////////////////////////////////////
function TmyDragControlObject.GetDragCursor(Accepted:Boolean;X,Y:Integer):TCursor;
begin
	if FPrevAccepted<>Accepted then begin
		with DI do begin
			Enddrag;
			Setdragimage(Ord(Accepted),-20,5);
			Begindrag(Getdesktopwindow,X,Y);
		end;
	end;
	FPrevAccepted:=Accepted;
	Result:=inherited GetDragCursor(Accepted,X,Y);
end;

function TmyDragControlObject.GetDragImages:TDragImageList;
begin
	Result:=DI;
end;

destructor TmyDragControlObject.Destroy;
begin
	DI.Free;
	DI:=nil;
	inherited Destroy;
end;

/// ///////////////////////////// DOCK OBJECT ///////////////////////////////////////////
constructor TmyDragDockObject.Create(AControl:TControl;CLR:TColor=ClHighlight);
begin
	inherited Create(AControl);
	if TransparentForm=nil then begin
		TransparentForm:=TTransparentForm.Createnew(Application);
		with TransparentForm do begin
			Alphablend:=True;
			Alphablendvalue:=128;
			Borderstyle:=Bsnone;
			Color:=CLR;
			Formstyle:=Fsstayontop;
		end;
	end;
end;

destructor TmyDragDockObject.Destroy;
begin
	DI1.Enddrag;
	DI1.Free;
	DI1:=nil;
	TransparentForm.Free;
	TransparentForm:=nil;
	inherited Destroy;
end;

function TmyDragDockObject.GetDragCursor(Accepted:Boolean;X,Y:Integer):TCursor;
begin
	if FPrevAccepted<>Accepted then begin
		with DI1 do begin
			Enddrag;
			Setdragimage(Ord(Accepted),-20,5);
			Begindrag(Getdesktopwindow,X,Y);
		end;
	end;
	FPrevAccepted:=Accepted;
	Result:=inherited GetDragCursor(Accepted,X,Y);
end;

function TmyDragDockObject.GetDragImages:TDragImageList;
begin
	Result:=DI1;
end;

procedure TmyDragDockObject.EraseDragDockImage;
begin
	TransparentForm.Hide;
end;

procedure TmyDragDockObject.DrawDragDockImage;
begin
	if TransparentForm<>nil then begin
		TransparentForm.Boundsrect:=Dockrect;
		if not TransparentForm.Visible then TransparentForm.Show;
	end;
end;

function TmyDragDockObject.GetEraseWhenMoving:Boolean;
begin
	Result:=False;
end;

procedure TTransparentForm.CreateParams(var Params:TCreateParams);
begin
	inherited CreateParams(Params);
	Params.Exstyle:=Params.Exstyle or Ws_ex_transparent;
end;

procedure TRis.Udis;
begin
	Freelibrary(Umoudle);
	Ulang:=0;
	Ulist:='';
	Udatas.UDz:=0;
	Udatas.UData:=nil;
	case Udatas.Uhk of
		0:Deleteobject(Udatas.Uh);
		1:Destroyicon(Udatas.Uh);
		2:Destroycursor(Udatas.Uh);
	end;
end;

/// /////////////////////////// TOOLTIPS///////////////////////////////////////////
procedure TCBH.SBO(Icon:Cardinal;Title1,Text1:string;Rect1:TRect;SoundN:Integer=0);
var
	Dwsty:Cardinal;
	MS:Tagmsg;
begin
	if (HIP1<>0) then begin
		Destroywindow(HIP1);
		HIP1:=0;
	end;
	if (SFL1(2)='1') then Dwsty:=Ws_ex_layoutrtl
	else Dwsty:=Ws_ex_left;
	HIP1:=Createwindowex(Ws_ex_toolwindow or Dwsty,Tooltips_class,nil,Tts_close or Ws_popup or Tts_noprefix or
		Tts_balloon or Tts_alwaystip,0,0,0,0,Handle,0,HINSTANCE,nil);
	PSN1(SoundN);
	try
		TF1.Cbsize:=SizeOf(TF1);
		TF1.Uflags:=Ttf_centertip or Ttf_transparent or Ttf_subclass;
		TF1.HWND:=Handle;
		TF1.Hinst:=HINSTANCE;
		TF1.Lpsztext:=Pchar(Text1);
		Setwindowpos(HIP1,Hwnd_notopmost,0,0,0,0,Swp_nomove or Swp_noactivate or Swp_nosize);
		TF1.Rect:=Rect1;
		SendMessage(HIP1,Ttm_setmaxtipwidth,0,Screen.Workareawidth);
		SendMessage(HIP1,Wm_setfont,Font.Handle,0);
		SendMessage(HIP1,Ttm_addtool,0,Integer(@TF1));
		SendMessage(HIP1,Ttm_settitle,Integer(Icon),Integer(Pchar(Title1)));
		SendMessage(HIP1,Ttm_trackactivate,1,Integer(@TF1));
	except
		on E:Exception do
	end;
end;

procedure TCBH.BO(Icon:Cardinal;Title1,Text1:string;Rect1:TRect;SoundN:Integer=0);
var
	Dwsty:Cardinal;
begin
	if (HIP2<>0) then begin
		Destroywindow(HIP2);
		HIP2:=0;
	end;
	if (HIP2=0) then begin
		if (SFL1(2)='1') then begin
			Dwsty:=Ws_ex_layoutrtl;
		end else begin
			Dwsty:=Ws_ex_left;
		end;
		HIP2:=Createwindowex(Ws_ex_toolwindow or Dwsty,Tooltips_class,nil,Ws_popup or Tts_noprefix or Tts_balloon or
			Tts_alwaystip,0,0,0,0,Handle,0,HINSTANCE,nil);
		PSN1(SoundN);
	end;
	try
		TF2.Cbsize:=SizeOf(TF2);
		TF2.Uflags:=Ttf_centertip or Ttf_transparent or Ttf_subclass;
		TF2.HWND:=Handle;
		TF2.Hinst:=HINSTANCE;
		TF2.Lpsztext:=Pchar(Text1);
		Setwindowpos(HIP2,Hwnd_notopmost,0,0,0,0,Swp_nomove or Swp_noactivate or Swp_nosize);
		TF2.Rect:=Rect1;
		SendMessage(HIP2,Ttm_setmaxtipwidth,0,Screen.Workareawidth);
		SendMessage(HIP2,Wm_setfont,Font.Handle,0);
		SendMessage(HIP2,Ttm_setdelaytime,Ttdt_autopop,90000);
		SendMessage(HIP2,Ttm_addtool,1,Integer(@TF2));
		SendMessage(HIP2,Ttm_settitle,Integer(Icon),Integer(Pchar(Title1)));
	except
		on E:Exception do
	end;
end;

procedure TCBH.SO(Icon:Cardinal;Title1,Text1:string;Rect1:TRect;SoundN:Integer=0);
var
	Dwsty:Cardinal;
begin
	if Text1.Isempty then Text1:=' ';
	if Rect1.Isempty then Rect1:=Clientrect;
	if (HIP3<>0)and(Rect1<>TF3.Rect) then begin
		SendMessage(HIP3,Ttm_deltool,1,Integer(@TF3));
		try
			PSN1(SoundN);
			TF3.Cbsize:=SizeOf(TF3);
			TF3.Uflags:=Ttf_centertip or Ttf_transparent or Ttf_subclass;
			TF3.HWND:=Handle;
			TF3.Hinst:=HINSTANCE;
			TF3.Lpsztext:=Pchar(Text1);
			Setwindowpos(HIP3,Hwnd_notopmost,0,0,0,0,Swp_nomove or Swp_noactivate or Swp_nosize);
			TF3.Rect:=Rect1;
			SendMessage(HIP3,Ttm_setmaxtipwidth,0,Screen.Workareawidth);
			SendMessage(HIP3,Wm_setfont,Font.Handle,0);
			SendMessage(HIP3,Ttm_setdelaytime,Ttdt_autopop,90000);
			SendMessage(HIP3,Ttm_addtool,1,Integer(@TF3));
			SendMessage(HIP3,Ttm_settitle,Integer(Icon),Integer(Pchar(Title1)));
		except
			on E:Exception do
		end;
		EXIT;
	end;
	if (HIP3=0) then begin
		if (SFL1(2)='1') then begin
			Dwsty:=Ws_ex_layoutrtl;
		end else begin
			Dwsty:=Ws_ex_left;
		end;
		HIP3:=Createwindowex(Ws_ex_toolwindow or Dwsty,Tooltips_class,nil,Ws_popup or Tts_noprefix or Tts_balloon or
			Tts_alwaystip,0,0,0,0,Handle,0,HINSTANCE,nil);
		try
			PSN1(SoundN);
			TF3.Cbsize:=SizeOf(TF3);
			TF3.Uflags:=Ttf_centertip or Ttf_transparent or Ttf_subclass;
			TF3.HWND:=Handle;
			TF3.Hinst:=HINSTANCE;
			TF3.Lpsztext:=Pchar(Text1);
			Setwindowpos(HIP3,Hwnd_notopmost,0,0,0,0,Swp_nomove or Swp_noactivate or Swp_nosize);
			TF3.Rect:=Rect1;
			SendMessage(HIP3,Wm_setfont,Font.Handle,0);
			SendMessage(HIP3,Ttm_setdelaytime,Ttdt_autopop,90000);
			SendMessage(HIP3,Ttm_addtool,1,Integer(@TF3));
			SendMessage(HIP3,Ttm_settitle,Integer(Icon),Integer(Pchar(Title1)));
		except
			on E:Exception do
		end;
	end;
end;

procedure SBO1;
begin
	if (HIP1<>0) then begin
		Destroywindow(HIP1);
		HIP1:=0;
	end;
end;

/// ////////////////////////////////// HINT WINDOW /////////////////////////////////////////
constructor THW.Create(AOwner:TComponent);
begin
	inherited Create(AOwner);
	Da:=Timage.Create(AOwner);
	Da.Autosize:=True;
	Da.Transparent:=True;
	Hint1:=SFL1(117);
	Hint2:=SFL1(118);
	Hint3:=SFL1(119);
	Hint4:=SFL1(120);
	Hint5:=SFL1(121);
	Hint6:=SFL1(122);
	Hint7:=SFL1(137);
end;

procedure THW.ActivateHint(Rect:TRect;const AHint:string);
begin
	Font.Name:='Tahoma';
	Font.Size:=19;
	Font.Charset:=178;
	Font.Style:=[Fsbold];
	Caption:=AHint;
	Hint:=AHint;
	Rect.Width:=Canvas.Textwidth(Caption)+26;
	Rect.Height:=Canvas.Textheight(Caption)+2;

	inherited ActivateHint(Rect,AHint);
end;

procedure THW.CMTextChanged(var Message:TMessage);
begin
	inherited;
	Width:=Canvas.Textwidth(Caption)+30;
	Height:=Canvas.Textheight(Caption)+6;
	if (Caption=Hint1) then Da.Picture.Icon.Handle:=SIC1(13,1) // copy.
	else if (Caption=Hint2) then Da.Picture.Icon.Handle:=SIC1(14,1) // move.
	else if (Caption=Hint3) then Da.Picture.Icon.Handle:=SIC1(15,1) // shortcut.
	else if (Caption=Hint4) then Da.Picture.Icon.Handle:=SIC1(16,1) // past.
	else if (Caption=Hint5) then Da.Picture.Icon.Handle:=SIC1(17,1) // not allow.
	else if (Caption=Hint6) then Da.Picture.Icon.Handle:=SIC1(18,1); // select.
end;

procedure THW.Paint;
var
	R,Cliprect:TRect;
	Lcolor:TColor;
	Lstyle:Tcustomstyleservices;
	Ldetails:Tthemedelementdetails;
	Lgradientstart,Lgradientend,Ltextcolor:TColor;
begin
	try
		R:=Clientrect;
		Lstyle:=Styleservices;
		Ltextcolor:=Clblue; // Screen.HintFont.Color;
		if Lstyle.Enabled then begin
			Cliprect:=R;
			Inflaterect(R,4,4);
			if Tosversion.Check(6)and Lstyle.Issystemstyle then begin
				// Paint Windows gradient background
				Lstyle.Drawelement(Canvas.Handle,Lstyle.Getelementdetails(Tttstandardnormal),R,Cliprect);
			end else begin
				Ldetails:=Lstyle.Getelementdetails(Thhintnormal);
				if Lstyle.Getelementcolor(Ldetails,Ecgradientcolor1,Lcolor)and(Lcolor<>Clnone) then Lgradientstart:=Lcolor
				else Lgradientstart:=Clinfobk;
				if Lstyle.Getelementcolor(Ldetails,Ecgradientcolor2,Lcolor)and(Lcolor<>Clnone) then Lgradientend:=Lcolor
				else Lgradientend:=Clinfobk;
				if Lstyle.Getelementcolor(Ldetails,Ectextcolor,Lcolor)and(Lcolor<>Clnone) then Ltextcolor:=Lcolor
				else Ltextcolor:=Screen.Hintfont.Color;
				Gradientfillcanvas(Canvas,Lgradientstart,Lgradientend,R,Gdvertical);
			end;
			R:=Cliprect;
		end;

		Canvas.Font.Color:=Ltextcolor;
		if (Bidimode<>Bdlefttoright) then begin
			Inc(R.Left,2);
			Dec(R.Right,4);
			Dec(R.Bottom,2);
			Canvas.Draw(2,2,Da.Picture.Graphic);
			Drawtext(Canvas.Handle,Caption,-1,R,Dt_noprefix or Dt_wordbreak or Dt_right);
		end else begin
			Inc(R.Left,2);
			Inc(R.Top,2);
			Canvas.Draw(Canvas.Textwidth(Caption)+10,2,Da.Picture.Graphic);
			Drawtext(Canvas.Handle,Caption,-1,R,Dt_noprefix or Dt_wordbreak or Dt_left);
		end;
	except
		on E:Exception do
	end;
end;

var
	Oldhintclass:Thintwindowclass;

function Setnewhintclass(Aclass:Thintwindowclass):Thintwindowclass;
var
	Doshowhint:Boolean;
begin
	Result:=Hintwindowclass; // return value is old hint
	Doshowhint:=Application.Showhint;
	if Doshowhint then Application.Showhint:=False; // destroy old hint window
	Hintwindowclass:=Aclass; // assign new hint window
	if Doshowhint then Application.Showhint:=True; // create new hint window
end;

/// /////////////////////////////// DLL FUNC ///////////////////////////////

function Examine(FileName:AnsiString;Members:Tstringlist):Boolean;
type
	Tdwordarray=array [0..1048575] of DWORD;
var
	Libinfo:LoadedImage;
	Libdirectory:PImageExportDirectory;
	Sizeoflist:Cardinal;
	Pdummy:PImageSectionHeader;
	I:Cardinal;
	Namervas:^Tdwordarray;
	Name,S:string;
begin
	Result:=False;
	if Mapandload(PAnsichar(FileName),PAnsichar(FileName),@Libinfo,True,True) then begin
		try
			// Get the directory
			Libdirectory:=ImageDirectoryEntryToData(Libinfo.MappedAddress,False,Image_directory_entry_export,Sizeoflist);
			// Get ptr to first node for the image directory
			Namervas:=ImageRvaToVa(Libinfo.Fileheader,Libinfo.MappedAddress,DWORD(Libdirectory^.Addressofnames),Pdummy);
			Members.Clear;
			try
				for I:=0 to Libdirectory^.Numberofnames-1 do begin
					name:=string(PAnsichar(ImageRvaToVa(Libinfo.Fileheader,Libinfo.MappedAddress,Namervas^[I],Pdummy)));
					name:=name.Trim;
					if name.Length>0 then S:=S+#13+name;
				end;
				Members.Text:=S;
			except
				on E:Exception do begin
					EXIT;
				end;
			end;
			Members.SaveToFile('C:\Users\MICLE\Desktop\propsys.txt');
			Result:=True;
		finally UnMapAndLoad(@Libinfo);
		end;
	end;
end;

/// ///////////////////////                TEnumString          //////////////////////////////////

constructor TEnumString.Create(AStrings:TStrings;AIndex:Integer=0);
begin
	inherited Create;
	FStrings:=AStrings;
	FCurrIndex:=AIndex;
end;

function TEnumString.Clone(out Enm:IEnumString):HResult;
begin
	Enm:=TEnumString.Create(FStrings,FCurrIndex);
	Result:=S_OK;
end;

function TEnumString.Next(Celt:Integer;out Elt;PCeltfetched:PLongint):HResult;
type
	TPointerList=array [0..0] of Pointer;
var
	I:Integer;
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

function TEnumString.Skip(Celt:Integer):HResult;
begin
	if (FCurrIndex+Celt)<=FStrings.Count then begin
		Inc(FCurrIndex,Celt);
		Result:=S_OK;
	end else begin
		FCurrIndex:=FStrings.Count;
		Result:=S_FALSE;
	end;
end;

initialization

RegisterThisAppRunAsInteractiveUser(APPID);
OutFiles:=Tstringlist.Create;
OutFiles1:=Tstringlist.Create;

end.
