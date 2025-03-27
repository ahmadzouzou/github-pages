unit AMD.Files;

interface

uses
	System.Classes,
	Winapi.Windows,
	Vcl.Dialogs,
	Winapi.ActiveX,
	amdfun1,
	System.SysUtils,
	System.TypInfo,
	System.Types,
	Data.FMTBcd,
	Data.SQLTimSt,
	Data.DB,
	AMD.Stan.Intf,
	AMD.Stan.Util,
	AMD.DatS,
	// AMD.Stan.Storage,
	AMD.Stan.SQLTimeInt,
	AMD.Stan.Factory,
	AMD.Stan.Error,
	AMD.Stan.Consts,
	System.Generics.Collections,
	AMD.Stan.Option;

type

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

	TDocHeader=record
		FMagic: array [0..5] of Byte;
		FExt: array [0..5] of Byte;
		FPass: array [0..31] of Byte;
		FNUM:Integer;
		FUser:Integer;
		FST:Integer;
		FVersion:Word;
		FStartPos:UInt64;
		FEndPos:UInt64;
		FInfoSize:UInt64;
		FInfoSPos:UInt64;
		FInfoEPos:UInt64;
		FDictionaryOffset:UInt64;
		FContentSPos:UInt64;
		FContentEPos:UInt64;
		FContent:UInt64;
	end;

	TDocmHeader=record
		FMagic: array [0..5] of Byte;
		FExt: array [0..5] of Byte;
		FPass: array [0..31] of Byte;
		FCOU:Integer;
		FNUM:Integer;
		FCPY:Integer;
		FUser:Integer;
		FVersion:Word;
		FStartPos:UInt64;
		FEndPos:UInt64;
		FContentSPos:UInt64;
		FContentEPos:UInt64;
		FContentSize:UInt64;
		FNextPos:UInt64;
	end;

type
	TStreamProgressEvent=procedure(Sender:TObject;Count,MaxCount:Integer) of object;

	// TFakeStream is a read-only stream which produces its contents on-the-run.
	// It is used for this demo so we can simulate transfer of very large and
	// arbitrary amounts of data without using any memory.
	TFakeStream=class(TStream)
	private
		FSize,FPosition,FMaxCount:Longint;
		FProgress:TStreamProgressEvent;
		FAborted:boolean;
	protected
		property Aborted:boolean read FAborted;
	public
		constructor Create(ASize,AMaxCount:Longint);
		destructor Destroy;override;
		function Read(var Buffer;Count:Longint):Longint;override;
		function Seek(Offset:Longint;Origin:Word):Longint;override;
		procedure SetSize(NewSize:Longint);override;
		function Write(const Buffer;Count:Longint):Longint;override;
		procedure Abort;
		property OnProgress:TStreamProgressEvent read FProgress write FProgress;
	end;

	TAMDStM=class(TStream,IStream)
	private
		FInfo:string;
		FNUM:Integer;
		FUser:Integer;
		FST:Integer;
		FPass:string;
		FExt:string;
		FSTM:IStream;
		FFile:string;
		FHGlob:HGLOBAL;
		function GetPosition:Int64;overload;
		procedure SetPosition(const Pos:Int64);overload;
		procedure SetSize64(const NewSize:Int64);overload;
		function Skip(Amount:Int64):Int64;overload;
	protected
		function GetSize:Int64;overload;
		procedure SetSize(NewSize:Longint);overload;
		procedure SetSize(const NewSize:Int64);overload;
	public
		constructor Create(const HGlob:HGLOBAL);overload;
		constructor Create(const AFile:string;MODE:Word=0);overload;
		destructor Destroy;override;
		function Read(var Buffer;Count:Longint):Longint;overload;
		function Write(const Buffer;Count:Longint):Longint;overload;
		function Read(Buffer:TBytes;Offset,Count:Longint):Longint;overload;
		function Write(const Buffer:TBytes;Offset,Count:Longint):Longint;overload;

		function Read(var Buffer:TBytes;Count:Longint):Longint;overload;
		function Write(const Buffer:TBytes;Count:Longint):Longint;overload;

		function Read64(Buffer:TBytes;Offset,Count:Int64):Int64;overload;
		function Write64(const Buffer:TBytes;Offset,Count:Int64):Int64;overload;

		function ReadData(Buffer:Pointer;Count:NativeInt):NativeInt;overload;
		function ReadData(const Buffer:TBytes;Count:NativeInt):NativeInt;overload;

		function ReadData(var Buffer:boolean):NativeInt;overload;
		function ReadData(var Buffer:boolean;Count:NativeInt):NativeInt;overload;

		function ReadData(var Buffer:AnsiChar):NativeInt;overload;
		function ReadData(var Buffer:AnsiChar;Count:NativeInt):NativeInt;overload;

		function ReadData(var Buffer:Char):NativeInt;overload;
		function ReadData(var Buffer:Char;Count:NativeInt):NativeInt;overload;
		function ReadData(var Buffer:Int8):NativeInt;overload;
		function ReadData(var Buffer:Int8;Count:NativeInt):NativeInt;overload;
		function ReadData(var Buffer:UInt8):NativeInt;overload;
		function ReadData(var Buffer:UInt8;Count:NativeInt):NativeInt;overload;
		function ReadData(var Buffer:Int16):NativeInt;overload;
		function ReadData(var Buffer:Int16;Count:NativeInt):NativeInt;overload;
		function ReadData(var Buffer:UInt16):NativeInt;overload;
		function ReadData(var Buffer:UInt16;Count:NativeInt):NativeInt;overload;
		function ReadData(var Buffer:Int32):NativeInt;overload;
		function ReadData(var Buffer:Int32;Count:NativeInt):NativeInt;overload;
		function ReadData(var Buffer:UInt32):NativeInt;overload;
		function ReadData(var Buffer:UInt32;Count:NativeInt):NativeInt;overload;
		function ReadData(var Buffer:Int64):NativeInt;overload;
		function ReadData(var Buffer:Int64;Count:NativeInt):NativeInt;overload;
		function ReadData(var Buffer:UInt64):NativeInt;overload;
		function ReadData(var Buffer:UInt64;Count:NativeInt):NativeInt;overload;
		function ReadData(var Buffer:Single):NativeInt;overload;
		function ReadData(var Buffer:Single;Count:NativeInt):NativeInt;overload;
		function ReadData(var Buffer:Double):NativeInt;overload;
		function ReadData(var Buffer:Double;Count:NativeInt):NativeInt;overload;
		function ReadData(var Buffer:Extended):NativeInt;overload;
		function ReadData(var Buffer:Extended;Count:NativeInt):NativeInt;overload;
		function ReadData(var Buffer:TExtended80Rec):NativeInt;overload;
		function ReadData(var Buffer:TExtended80Rec;Count:NativeInt):NativeInt;overload;

		function ReadData<T>(var Buffer:T):NativeInt;overload;
		function ReadData<T>(var Buffer:T;Count:NativeInt):NativeInt;overload;

		function WriteData(const Buffer:TBytes;Count:NativeInt):NativeInt;overload;
		function WriteData(const Buffer:Pointer;Count:NativeInt):NativeInt;overload;

		function WriteData(const Buffer:boolean):NativeInt;overload;
		function WriteData(const Buffer:boolean;Count:NativeInt):NativeInt;overload;

		function WriteData(const Buffer:AnsiChar):NativeInt;overload;
		function WriteData(const Buffer:AnsiChar;Count:NativeInt):NativeInt;overload;

		function WriteData(const Buffer:Char):NativeInt;overload;
		function WriteData(const Buffer:Char;Count:NativeInt):NativeInt;overload;
		function WriteData(const Buffer:Int8):NativeInt;overload;
		function WriteData(const Buffer:Int8;Count:NativeInt):NativeInt;overload;
		function WriteData(const Buffer:UInt8):NativeInt;overload;
		function WriteData(const Buffer:UInt8;Count:NativeInt):NativeInt;overload;
		function WriteData(const Buffer:Int16):NativeInt;overload;
		function WriteData(const Buffer:Int16;Count:NativeInt):NativeInt;overload;
		function WriteData(const Buffer:UInt16):NativeInt;overload;
		function WriteData(const Buffer:UInt16;Count:NativeInt):NativeInt;overload;
		function WriteData(const Buffer:Int32):NativeInt;overload;
		function WriteData(const Buffer:Int32;Count:NativeInt):NativeInt;overload;
		function WriteData(const Buffer:UInt32):NativeInt;overload;
		function WriteData(const Buffer:UInt32;Count:NativeInt):NativeInt;overload;
		function WriteData(const Buffer:Int64):NativeInt;overload;
		function WriteData(const Buffer:Int64;Count:NativeInt):NativeInt;overload;
		function WriteData(const Buffer:UInt64):NativeInt;overload;
		function WriteData(const Buffer:UInt64;Count:NativeInt):NativeInt;overload;
		function WriteData(const Buffer:Single):NativeInt;overload;
		function WriteData(const Buffer:Single;Count:NativeInt):NativeInt;overload;
		function WriteData(const Buffer:Double):NativeInt;overload;
		function WriteData(const Buffer:Double;Count:NativeInt):NativeInt;overload;
		function WriteData(const Buffer:Extended):NativeInt;overload;
		function WriteData(const Buffer:Extended;Count:NativeInt):NativeInt;overload;
		function WriteData(const Buffer:TExtended80Rec):NativeInt;overload;
		function WriteData(const Buffer:TExtended80Rec;Count:NativeInt):NativeInt;overload;

		function WriteData<T>(const Buffer:T):NativeInt;overload;
		function WriteData<T>(const Buffer:T;Count:NativeInt):NativeInt;overload;

		function Seek32(const Offset:Integer;Origin:TSeekOrigin):Int64;overload;
		function Seek(Offset:Longint;Origin:Word):Longint;overload;
		function Seek(const Offset:Int64;Origin:TSeekOrigin):Int64;overload;
		function Seek(const Offset:Int64;Origin:Word):Int64;overload;

		procedure ReadBuffer(var Buffer;Count:NativeInt);overload;
		procedure ReadBuffer(var Buffer:TBytes;Count:NativeInt);overload;
		procedure ReadBuffer(var Buffer:TBytes;Offset,Count:NativeInt);overload;

		procedure ReadBufferData(var Buffer:boolean);overload;
		procedure ReadBufferData(var Buffer:boolean;Count:NativeInt);overload;

		procedure ReadBufferData(var Buffer:AnsiChar);overload;
		procedure ReadBufferData(var Buffer:AnsiChar;Count:NativeInt);overload;

		procedure ReadBufferData(var Buffer:Char);overload;
		procedure ReadBufferData(var Buffer:Char;Count:NativeInt);overload;
		procedure ReadBufferData(var Buffer:Int8);overload;
		procedure ReadBufferData(var Buffer:Int8;Count:NativeInt);overload;
		procedure ReadBufferData(var Buffer:UInt8);overload;
		procedure ReadBufferData(var Buffer:UInt8;Count:NativeInt);overload;
		procedure ReadBufferData(var Buffer:Int16);overload;
		procedure ReadBufferData(var Buffer:Int16;Count:NativeInt);overload;
		procedure ReadBufferData(var Buffer:UInt16);overload;
		procedure ReadBufferData(var Buffer:UInt16;Count:NativeInt);overload;
		procedure ReadBufferData(var Buffer:Int32);overload;
		procedure ReadBufferData(var Buffer:Int32;Count:NativeInt);overload;
		procedure ReadBufferData(var Buffer:UInt32);overload;
		procedure ReadBufferData(var Buffer:UInt32;Count:NativeInt);overload;
		procedure ReadBufferData(var Buffer:Int64);overload;
		procedure ReadBufferData(var Buffer:Int64;Count:NativeInt);overload;
		procedure ReadBufferData(var Buffer:UInt64);overload;
		procedure ReadBufferData(var Buffer:UInt64;Count:NativeInt);overload;
		procedure ReadBufferData(var Buffer:Single);overload;
		procedure ReadBufferData(var Buffer:Single;Count:NativeInt);overload;
		procedure ReadBufferData(var Buffer:Double);overload;
		procedure ReadBufferData(var Buffer:Double;Count:NativeInt);overload;
		procedure ReadBufferData(var Buffer:Extended);overload;
		procedure ReadBufferData(var Buffer:Extended;Count:NativeInt);overload;
		procedure ReadBufferData(var Buffer:TExtended80Rec);overload;
		procedure ReadBufferData(var Buffer:TExtended80Rec;Count:NativeInt);overload;

		procedure WriteBuffer(const Buffer;Count:NativeInt);overload;
		procedure WriteBuffer(const Buffer:TBytes;Count:NativeInt);overload;
		procedure WriteBuffer(const Buffer:TBytes;Offset,Count:NativeInt);overload;

		procedure WriteBufferData(var Buffer:Integer;Count:NativeInt);overload;

		function CopyFrom(const Source:TStream;Count:Int64=0;BufferSize:Integer=$100000):Int64;overload;

		function ReadComponent(const Instance:TComponent):TComponent;overload;
		function ReadComponentRes(const Instance:TComponent):TComponent;overload;
		procedure WriteComponent(const Instance:TComponent);overload;
		procedure WriteComponentRes(const ResName:string;const Instance:TComponent);overload;
		procedure WriteDescendent(const Instance,Ancestor:TComponent);overload;
		procedure WriteDescendentRes(const ResName:string;const Instance,Ancestor:TComponent);overload;
		procedure WriteResourceHeader(const ResName:string;out FixupInfo:Integer);overload;
		procedure FixupResourceHeader(FixupInfo:Integer);overload;
		procedure ReadResHeader;overload;

		property nFile:string read FFile write FFile;
		property STM:IStream read FSTM write FSTM implements IStream;
		property TInfo:string read FInfo write FInfo;
		property TNUM:Integer read FNUM write FNUM;
		property TUser:Integer read FUser write FUser;
		property TST:Integer read FST write FST;
		property TPass:string read FPass write FPass;
		property TExt:string read FExt write FExt;
	end;

	TFDStorage=class(TFDObject)
	private
		FActions:TFDObjList;
		FLevel:Integer;
		FOwnStream:boolean;
		FBuff:TMemoryStream;
		FResOpts:TFDBottomResourceOptions;
		FWorkFileName:String;
		FOriginalFileExt:String;
		FFilterObjs:TDictionary<TObject,TObject>;
		FLastEnumTypeInfo:PTypeInfo;
		FLastEnumValue:Integer;
		FLastEnumName:String;
		procedure ClearDeferredActions;
		procedure PerformDeferredActions;
	protected
		FStreamVersion:Integer;
		FMode:TFDStorageMode;
		FStream:TAMDStM;
		FEncoder:TFDEncoder;
		FFormat:boolean;
		// introduced
		function CheckBuffer(ASize:Cardinal):TMemoryStream;
		procedure Hex2BinStream(const AHex:String;AStream:TMemoryStream);
		function GetCachedEnumName(ATypeInfo:PTypeInfo;const AValue:Integer):String;
		// IFDStanStorage
		function GetMode:TFDStorageMode;
		function GetStreamVersion:Integer;
		function GetOwnStream:boolean;
		procedure SetOwnStream(AValue:boolean);
		procedure Open(AResOpts:TObject;AEncoder:TObject;const AFileName:String;AStream:TStream;
			AMode:TFDStorageMode);virtual;
		procedure Close;virtual;
		function IsOpen:boolean;virtual;
		procedure LockDeferring;
		procedure UnLockDeferring;
		procedure DeferAction(const APropName,AValue:String;AAction:TFDStorageDeferredAction);
		function IsStored(AItem:TFDStoreItem):boolean;
		function ReadObjectBegin(const AObjectName:String;AStyle:TFDStorageObjectStyle):String;virtual;abstract;
		procedure ReadObjectEnd(const AObjectName:String;AStyle:TFDStorageObjectStyle);virtual;abstract;
		function LoadObject:TObject;
		procedure SaveObject(AObject:TObject);
		procedure AddFilterObj(AKey,AFilter:TObject);
		procedure RemoveFilterObj(AKey:TObject);
		function GetFilterObj(AKey:TObject):TObject;
		function BeginGrowthEstimation:Int64;
		procedure EndGrowthEstimation(ABase:Int64;ATimes:Cardinal);
	public
		constructor Create;override;
		destructor Destroy;override;
	end;

	TFDBinStorage=class(TFDStorage,IFDStanStorage)
	private
		FDictionary:TFDStringList;
		FDictionaryIndex:Integer;
		FContentSPos:UInt64;
		FStarPos:UInt64;
		FEOFPos:UInt64;
		FInfoSize:UInt64;
		FInfoSPos:UInt64;
		FInfoEPos:UInt64;
		procedure InternalReadProperty(var AName:string);
		procedure InternalWriteProperty(const APropName:string;ApValue:Pointer;ALen:Cardinal);
		function InternalReadObject(var AName:string):boolean;
		function InternalReadObjectEnd:boolean;
		function LookupName(const AName:string):Word;
	public
		constructor Create;override;
		destructor Destroy;override;
		procedure Close;override;
		function IsObjectEnd(const AObjectName:string):boolean;
		procedure Open(AResOpts:TObject;AEncoder:TObject;const AFileName:string;AStream:TStream;
			AMode:TFDStorageMode);override;
		function ReadBoolean(const APropName:string;ADefValue:boolean):boolean;
		function ReadDate(const APropName:string;ADefValue:TDateTime):TDateTime;
		function ReadFloat(const APropName:string;ADefValue:Double):Double;
		function ReadInteger(const APropName:string;ADefValue:Integer):Integer;
		function ReadLongWord(const APropName:string;ADefValue:Cardinal):Cardinal;
		function ReadInt64(const APropName:string;ADefValue:Int64):Int64;
		function ReadObjectBegin(const AObjectName:string;AStyle:TFDStorageObjectStyle):string;override;
		procedure ReadObjectEnd(const AObjectName:string;AStyle:TFDStorageObjectStyle);override;
		function ReadAnsiString(const APropName:string;const ADefValue:TFDAnsiString):TFDAnsiString;
		function ReadString(const APropName:string;const ADefValue:UnicodeString):UnicodeString;
		function ReadValue(const APropName:string;APropIndex:Word;ADataType:TFDDataType;out ABuff:Pointer;
			out ALen:Cardinal):boolean;
		function ReadEnum(const APropName:string;ATypeInfo:PTypeInfo;ADefValue:Integer):Integer;
		function TestObject(const AObjectName:string):boolean;
		function TestAndReadObjectBegin(const AObjectName:string;AStyle:TFDStorageObjectStyle):boolean;
		function TestProperty(const APropName:string):boolean;
		function TestAndReadProperty(const APropName:string):boolean;
		procedure WriteBoolean(const APropName:string;const AValue,ADefValue:boolean);
		procedure WriteDate(const APropName:string;const AValue,ADefValue:TDateTime);
		procedure WriteFloat(const APropName:string;const AValue,ADefValue:Double);
		procedure WriteInteger(const APropName:string;const AValue,ADefValue:Integer);
		procedure WriteLongWord(const APropName:string;const AValue,ADefValue:Cardinal);
		procedure WriteInt64(const APropName:string;const AValue,ADefValue:Int64);
		procedure WriteObjectBegin(const AObjectName:string;AStyle:TFDStorageObjectStyle);
		procedure WriteObjectEnd(const AObjectName:string;AStyle:TFDStorageObjectStyle);
		procedure WriteAnsiString(const APropName:string;const AValue,ADefValue:TFDAnsiString);
		procedure WriteString(const APropName:string;const AValue,ADefValue:UnicodeString);
		procedure WriteValue(const APropName:string;APropIndex:Word;ADataType:TFDDataType;ABuff:Pointer;ALen:Cardinal);
		procedure WriteEnum(const APropName:string;ATypeInfo:PTypeInfo;const AValue,ADefValue:Integer);
		function GetBookmark:TObject;
		procedure SetBookmark(const AValue:TObject);
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
	C_ObjBegin=255;
	C_ObjEnd=254;

{$EXTERNALSYM SHCreateStreamOnFileEx}
function SHCreateStreamOnFileEx(pszFile:PWideChar;grfMode,dwAttributes:DWORD;fCreate:BOOL;pstmTemplate:IStream;
	out ppstm:IStream):HResult;stdcall;external 'shlwapi.dll' name 'SHCreateStreamOnFileEx';
function _SHStrDupW(psz:PWideChar;out ppwsz:PWideChar):HResult;stdcall;external 'shlwapi.dll' name 'SHStrDupW';
function _SHStrDupA(psz:PAnsiChar;out ppwsz:PAnsiChar):HResult;stdcall;external 'shlwapi.dll' name 'SHStrDupA';
function FOT(Extn:string):HRD6;
function Extn(FOT:HRD6):string;

implementation

uses
	amdmain;

{ ------------------------------------------------------------------------------- }
{ TFakeStream }
{ ------------------------------------------------------------------------------- }
procedure TFakeStream.Abort;
begin
	FAborted:=True;
end;

constructor TFakeStream.Create(ASize,AMaxCount:Longint);
begin
	inherited Create;
	FSize:=ASize;
	FMaxCount:=AMaxCount;
end;

destructor TFakeStream.Destroy;
begin
	// Status := dsDoneStream;
	inherited Destroy;
end;

function TFakeStream.Read(var Buffer;Count:Integer):Longint;
begin
	Result:=0;
	if (Aborted) then exit;
	if (FPosition>=0)and(Count>=0) then begin
		Result:=FSize-FPosition;
		if Result>0 then begin
			if Result>Count then Result:=Count;
			if Result>FMaxCount then Result:=FMaxCount;
			FillChar(Buffer,Result,Ord('X'));
			Inc(FPosition,Result);
			if Assigned(FProgress) then FProgress(Self,FPosition,FSize);
		end;
	end;
end;

function TFakeStream.Seek(Offset:Integer;Origin:Word):Longint;
begin
	case Origin of
		soFromBeginning:FPosition:=Offset;
		soFromCurrent:Inc(FPosition,Offset);
		soFromEnd:FPosition:=FSize+Offset;
	end;
	if Assigned(FProgress) then FProgress(Self,FPosition,FMaxCount);
	Result:=FPosition;
end;

procedure TFakeStream.SetSize(NewSize:Integer);
begin
end;

function TFakeStream.Write(const Buffer;Count:Integer):Longint;
begin
	Result:=0;
end;

{ ------------------------------------------------------------------------------- }
{ TFDStorage }
{ ------------------------------------------------------------------------------- }
constructor TFDStorage.Create;
begin
	inherited Create;
	// FStreamVersion:=C_FD_StorageVer112;
	// FActions:=TFDObjList.Create;
	FFilterObjs:=TDictionary<TObject,TObject>.Create;
end;

{ ------------------------------------------------------------------------------- }
destructor TFDStorage.Destroy;
begin
{$IFNDEF AUTOREFCOUNT}
	FDHighRefCounter(FRefCount);
{$ENDIF}
	Close;
	FDFreeAndNil(FActions);
	FDFreeAndNil(FBuff);
	FDFreeAndNil(FFilterObjs);
	FResOpts:=nil;
	FEncoder:=nil;
	inherited Destroy;
end;

{ ------------------------------------------------------------------------------- }
function TFDStorage.GetMode:TFDStorageMode;
begin
	Result:=FMode;
end;

{ ------------------------------------------------------------------------------- }
function TFDStorage.GetStreamVersion:Integer;
begin
	Result:=FStreamVersion;
end;

{ ------------------------------------------------------------------------------- }
function TFDStorage.GetOwnStream:boolean;
begin
	Result:=FOwnStream;
end;

{ ------------------------------------------------------------------------------- }
procedure TFDStorage.SetOwnStream(AValue:boolean);
begin
	FOwnStream:=AValue;
end;

{ ------------------------------------------------------------------------------- }
procedure TFDStorage.Open(AResOpts:TObject;AEncoder:TObject;const AFileName:String;AStream:TStream;
	AMode:TFDStorageMode);
begin
	FResOpts:=AResOpts as TFDBottomResourceOptions;
	FEncoder:=AEncoder as TFDEncoder;
	ASSERT((AStream<>nil)or(AFileName<>'')or(FResOpts<>nil)and(FResOpts.PersistentFileName<>''));
	FMode:=AMode;
	if (FResOpts=nil)or(FResOpts.StoreVersion=-1) then FStreamVersion:=3 // C_FD_StorageVer112
	else FStreamVersion:=FResOpts.StoreVersion;
	if FResOpts<>nil then FFormat:=FResOpts.StorePrettyPrint
	else FFormat:=False;
	if AStream=nil then begin
		if FResOpts<>nil then FWorkFileName:=FResOpts.ResolveFileName(AFileName)
		else FWorkFileName:=AFileName;
		if AMode=smWrite then begin
			if (FResOpts<>nil)and FResOpts.Backup then begin
				FOriginalFileExt:=ExtractFileExt(FWorkFileName);
				FWorkFileName:=ChangeFileExt(FWorkFileName,'.~~~');
			end;
			// FStream:=TBufferedFileStream.Create(FWorkFileName,fmCreate or fmShareExclusive);
		end
		else
			// FStream:=TBufferedFileStream.Create(FWorkFileName,fmOpenRead or fmShareDenyWrite);
				FOwnStream:=True;
	end else begin
		FWorkFileName:='';
		FStream:=TAMDStM(AStream);
		FOwnStream:=False;
	end;
end;

{ ------------------------------------------------------------------------------- }
procedure TFDStorage.Close;
var
	sTargetFileName:String;
	sBackupFileName:String;
	lStreamed:boolean;
begin
	ClearDeferredActions;
	lStreamed:=FStream<>nil;
	if FOwnStream then FDFreeAndNil(FStream)
	else FStream:=nil;
	if lStreamed and(FResOpts<>nil)and FResOpts.Backup and(FMode=smWrite)and(FWorkFileName<>'') then begin
		sTargetFileName:=ChangeFileExt(FWorkFileName,FOriginalFileExt);
		if FileExists(sTargetFileName) then begin
			sBackupFileName:=FWorkFileName;
			if FResOpts.BackupFolder<>'' then
					sBackupFileName:=FDNormPath(FDExpandStr(FResOpts.BackupFolder))+ExtractFileName(sBackupFileName);
			if FResOpts.BackupExt<>'' then sBackupFileName:=ChangeFileExt(sBackupFileName,FResOpts.BackupExt)
			else sBackupFileName:=ChangeFileExt(sBackupFileName,'.bak');
			if (sBackupFileName<>'')and(AnsiCompareText(ExpandFileName(sTargetFileName),ExpandFileName(sBackupFileName))<>0)
			then FDFileMove(sTargetFileName,sBackupFileName);
		end;
		if FileExists(FWorkFileName) then FDFileMove(FWorkFileName,sTargetFileName);
	end;
end;

{ ------------------------------------------------------------------------------- }
function TFDStorage.IsOpen:boolean;
begin
	Result:=FStream<>nil;
end;

{ ------------------------------------------------------------------------------- }
function TFDStorage.LoadObject:TObject;
begin
	Result:=FDStorageManager().LoadObject(Self as IFDStanStorage);
end;

{ ------------------------------------------------------------------------------- }
procedure TFDStorage.SaveObject(AObject:TObject);
begin
	FDStorageManager().SaveObject(AObject,Self as IFDStanStorage);
end;

{ ------------------------------------------------------------------------------- }
procedure TFDStorage.AddFilterObj(AKey,AFilter:TObject);
begin
	FFilterObjs.Add(AKey,AFilter);
end;

{ ------------------------------------------------------------------------------- }
procedure TFDStorage.RemoveFilterObj(AKey:TObject);
begin
	FFilterObjs.Remove(AKey);
end;

{ ------------------------------------------------------------------------------- }
function TFDStorage.GetFilterObj(AKey:TObject):TObject;
begin
	FFilterObjs.TryGetValue(AKey,Result);
end;

{ ------------------------------------------------------------------------------- }
type
	TDeferredAction=class(TObject)
	private
		FPropName:String;
		FValue:String;
		FAction:TFDStorageDeferredAction;
	end;

procedure TFDStorage.DeferAction(const APropName,AValue:String;AAction:TFDStorageDeferredAction);
var
	oAct:TDeferredAction;
begin
	if (APropName='')or(AValue='')or not Assigned(AAction) then exit;
	oAct:=TDeferredAction.Create;
	oAct.FPropName:=APropName;
	oAct.FValue:=AValue;
	oAct.FAction:=AAction;
	FActions.Add(oAct);
end;

{ ------------------------------------------------------------------------------- }
procedure TFDStorage.PerformDeferredActions;
var
	i:Integer;
	oAct:TDeferredAction;
begin
	try
		for i:=0 to FActions.Count-1 do begin
			oAct:=TDeferredAction(FActions.Items[i]);
			oAct.FAction(oAct.FPropName,oAct.FValue);
		end;
	finally ClearDeferredActions;
	end;
end;

{ ------------------------------------------------------------------------------- }
procedure TFDStorage.ClearDeferredActions;
var
	i:Integer;
begin
	for i:=0 to FActions.Count-1 do FDFree(TDeferredAction(FActions.Items[i]));
	FActions.Clear;
end;

{ ------------------------------------------------------------------------------- }
procedure TFDStorage.LockDeferring;
begin
	Inc(FLevel);
	if FLevel=1 then ClearDeferredActions;
end;

{ ------------------------------------------------------------------------------- }
procedure TFDStorage.UnLockDeferring;
begin
	Dec(FLevel);
	if FLevel=0 then PerformDeferredActions;
end;

{ ------------------------------------------------------------------------------- }
function TFDStorage.CheckBuffer(ASize:Cardinal):TMemoryStream;
begin
	if FBuff=nil then FBuff:=TMemoryStream.Create;
	if Cardinal(FBuff.Size)<ASize then FBuff.Size:=ASize;
	Result:=FBuff;
end;

{ ------------------------------------------------------------------------------- }
procedure TFDStorage.Hex2BinStream(const AHex:String;AStream:TMemoryStream);

begin
	AStream.Size:=Length(AHex)div 2;
	AStream.Position:=0;
	HexToBin(Pchar(AHex),PAnsiChar(AStream.Memory),AStream.Size);
end;

{ ------------------------------------------------------------------------------- }
function TFDStorage.GetCachedEnumName(ATypeInfo:PTypeInfo;const AValue:Integer):String;
begin
	if (FLastEnumTypeInfo<>ATypeInfo)or(FLastEnumValue<>AValue) then begin
		FLastEnumTypeInfo:=ATypeInfo;
		FLastEnumValue:=AValue;
		FLastEnumName:=GetEnumName(ATypeInfo,AValue);
	end;
	Result:=FLastEnumName;
end;

{ ------------------------------------------------------------------------------- }
function TFDStorage.IsStored(AItem:TFDStoreItem):boolean;
begin
	Result:=(FResOpts=nil)or(AItem in FResOpts.StoreItems);
end;

{ ------------------------------------------------------------------------------- }
function TFDStorage.BeginGrowthEstimation:Int64;
var
	statstg:TStatStg;
begin
	FStream.FSTM.Stat(statstg,STATFLAG_NONAME);
	Result:=statstg.cbSize;
end;

{ ------------------------------------------------------------------------------- }
type
	__TMemoryStream=class(TMemoryStream);

procedure TFDStorage.EndGrowthEstimation(ABase:Int64;ATimes:Cardinal);
begin
	{ if (FStream is TMemoryStream)and((FStream.Size-ABase)*ATimes>$2000*5) then
		__TMemoryStream(FStream).Capacity:=ABase+(FStream.Size-ABase)*ATimes; }
end;

{ ------------------------------------------------------------------------------- }
{ EXTENTIONS }
{ ------------------------------------------------------------------------------- }

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

{ ------------------------------------------------------------------------------- }
{ TFDBinStorage }
{ ------------------------------------------------------------------------------- }

constructor TFDBinStorage.Create;
begin
	inherited Create;
	FDictionary:=TFDStringList.Create(dupIgnore,False,True);
	FDictionary.UseLocale:=False;
end;

{ ------------------------------------------------------------------------------- }
destructor TFDBinStorage.Destroy;
begin
	inherited Destroy;
	FDFreeAndNil(FDictionary);
end;

{ ------------------------------------------------------------------------------- }
procedure TFDBinStorage.Open(AResOpts:TObject;AEncoder:TObject;const AFileName:string;AStream:TStream;
	AMode:TFDStorageMode);
var
	rHdr:TDocHeader;
	F,SRV,iPos,R:UInt64;
	ST:TStringStream;
	PP,PA:Pchar;
	iLen:Word;
	S:string;
begin
	inherited Open(AResOpts,AEncoder,AFileName,AStream,AMode);
	Amdf.RichEdit.Clear;
	if FMode=smWrite then begin
		FStream.FSTM.Seek(0,STREAM_SEEK_CUR,FStarPos);
		FillChar(rHdr,SizeOf(rHdr),0);
		ST:=TStringStream.Create(FStream.TInfo,TEncoding.UTF8);
		ST.Position:=0;
		FInfoSize:=ST.Size;
		F:=0;
		FStream.FSTM.Write(@rHdr,SizeOf(rHdr),@F);
		// RESERVED
		F:=0;
		FStream.FSTM.Write(@F,SizeOf(UInt64),@F);
		F:=0;
		SRV:=361995;
		FStream.FSTM.Write(@SRV,SizeOf(UInt64),@F);
		F:=0;
		FStream.FSTM.Write(@F,SizeOf(UInt64),@F);
		// info
		FStream.FSTM.Seek(0,STREAM_SEEK_CUR,FInfoSPos);
		F:=0;
		FStream.FSTM.Write(ST.Memory,ST.Size,@F);
		ST.FREE;
		FStream.FSTM.Seek(0,STREAM_SEEK_CUR,FInfoEPos);
		// RESERVED
		F:=0;
		FStream.FSTM.Write(@F,SizeOf(UInt64),@F);
		F:=0;
		SRV:=361995;
		FStream.FSTM.Write(@SRV,SizeOf(UInt64),@F);
		F:=0;
		FStream.FSTM.Write(@F,SizeOf(UInt64),@F);
		FStream.FSTM.Seek(0,STREAM_SEEK_CUR,FContentSPos);
		FDictionary.Sorted:=True;
		FDictionaryIndex:=0;
	end else begin
		R:=0;
		F:=SizeOf(TDocHeader);
		FStream.FSTM.Read(@rHdr,F,@R);
		if (R<>SizeOf(TDocHeader))or not CompareMem(@rHdr.FMagic[0],@C_Magic[0],6) then
				FDException(Self,[S_FD_LStan],er_FD_StanStrgInvBinFmt,[]);
		FStreamVersion:=rHdr.FVersion;
		FStream.FSTM.Seek(rHdr.FInfoSPos,STREAM_SEEK_SET,PUINT64(nil)^);
		F:=rHdr.FInfoSize;
		if F>0 then begin
			PP:=CoTaskMemAlloc(F);
			FStream.FSTM.Read(PP,F,@F);
			FStream.FInfo:=WideCharToString(PP);
			CoTaskMemFree(PP);
		end;
		FStream.TExt:=string(TEncoding.UTF8.GetString(rHdr.FExt));
		FStream.TNUM:=rHdr.FNUM;
		FStream.TUser:=rHdr.FUser;
		FStream.TST:=rHdr.FST;
		FStream.FPass:=string(TEncoding.UTF8.GetString(rHdr.FPass));
		FStream.FSTM.Seek(rHdr.FDictionaryOffset,STREAM_SEEK_SET,PUINT64(nil)^);
		FDictionary.Sorted:=False;
		iLen:=0;
		iPos:=rHdr.FDictionaryOffset;
		while (iPos<rHdr.FContentEPos) do begin
			F:=SizeOf(Word);
			FStream.FSTM.Read(@iLen,F,@F);
			if iLen>0 then begin
				F:=iLen;
				SetLength(S,iLen div SizeOf(WideChar));
				FStream.FSTM.Read(@S[1],F,@F);
				Amdf.RichEdit.Lines.Add(S);
				FDictionary.Add(S);
				S:='';
			end;
			FStream.FSTM.Seek(0,STREAM_SEEK_CUR,iPos);
		end;
		FEOFPos:=rHdr.FEndPos;
		FStream.FSTM.Seek(rHdr.FContentSPos,STREAM_SEEK_SET,PUINT64(nil)^);
		// CheckBuffer(C_FD_MaxFixedSize);
	end;
end;

{ ------------------------------------------------------------------------------- }
function DoCompareObjects(List:TStringList;Index1,Index2:Integer):Integer;
begin
	Result:=Integer(TFDStringList(List).Ints[Index1])-Integer(TFDStringList(List).Ints[Index2]);
end;

procedure TFDBinStorage.Close;
var
	i:Integer;
	F,SRV:UInt64;
	iLen:Word;
	rHdr:TDocHeader;
	EXT:HRD6;
	PP:Pchar;
	S:string;
begin
	Amdf.RichEdit.Lines.Add('close S'+#13+'------------------------');
	if (FStream<>nil)and(FMode=smWrite) then begin
		FDictionary.Sorted:=False;
		FDictionary.CustomSort(DoCompareObjects);
		FStream.FSTM.Seek(0,STREAM_SEEK_CUR,rHdr.FDictionaryOffset);
		for i:=0 to FDictionary.Count-1 do begin
			iLen:=Length(FDictionary[i])*SizeOf(WideChar);
			F:=0;
			FStream.FSTM.Write(@iLen,SizeOf(Word),@F);
			if iLen>0 then begin
				// PP:=CoTaskMemAlloc(iLen);
				SetLength(S,iLen);
				S:=FDictionary[i];
				// _SHStrDupW(Pchar(s),PP);
				F:=0;
				FStream.FSTM.Write(@S[1],iLen,@F);
				// CoTaskMemFree(PP);
				// Amdf.RichEdit.Lines.Add(S+' [ '+F.ToString+'_'+iLen.ToString+' ]');
			end;
		end;
		FStream.FSTM.Seek(0,STREAM_SEEK_CUR,rHdr.FContentEPos);
		// RESERVED
		F:=0;
		FStream.FSTM.Write(@F,SizeOf(UInt64),@F);
		F:=0;
		SRV:=361995;
		FStream.FSTM.Write(@SRV,SizeOf(UInt64),@F);
		F:=0;
		FStream.FSTM.Write(@F,SizeOf(UInt64),@F);
		FStream.FSTM.Seek(0,STREAM_SEEK_CUR,rHdr.FEndPos);
		// header
		EXT:=FOT(FStream.TExt);
		Move(C_Magic[0],rHdr.FMagic[0],6);
		Move(EXT[0],rHdr.FExt[0],6);
		Move(TEncoding.UTF8.GetBytes(FStream.TPass)[0],rHdr.FPass[0],32);
		rHdr.FNUM:=FStream.FNUM;
		rHdr.FUser:=FStream.FUser;
		rHdr.FST:=FStream.FST;
		rHdr.FVersion:=FStreamVersion;
		rHdr.FStartPos:=FStarPos;
		rHdr.FContentSPos:=FContentSPos;
		rHdr.FContent:=rHdr.FContentEPos-rHdr.FContentSPos;
		rHdr.FInfoSize:=FInfoSize;
		rHdr.FInfoSPos:=FInfoSPos;
		rHdr.FInfoEPos:=FInfoEPos;
		FStream.FSTM.Seek(rHdr.FStartPos,STREAM_SEEK_SET,PUINT64(nil)^);
		F:=0;
		FStream.FSTM.Write(@rHdr,SizeOf(rHdr),@F);
		FStream.FSTM.Seek(rHdr.FEndPos,STREAM_SEEK_SET,PUINT64(nil)^);
	end;
	if (FMode=smRead) then FStream.FSTM.Seek(FEOFPos,STREAM_SEEK_SET,PUINT64(nil)^);
	FDictionary.Clear;
	inherited Close;
	Amdf.RichEdit.Lines.Add('close E'+#13+'------------------------');
end;

{ ------------------------------------------------------------------------------- }
procedure TFDBinStorage.InternalReadProperty(var AName:string);
var
	iDict:Word;
	F:UInt64;
begin
	iDict:=0;
	F:=SizeOf(Word);
	FStream.FSTM.Read(@iDict,F,@F);
	if (iDict and $FF)<C_ObjEnd then AName:=FDictionary[iDict];
	Amdf.RichEdit.Lines.Add('InternalReadProperty    '+AName);
end;

{ ------------------------------------------------------------------------------- }
function TFDBinStorage.TestProperty(const APropName:string):boolean;
var
	iPos:UInt64;
	sName:string;
begin
	FStream.FSTM.Seek(0,STREAM_SEEK_CUR,iPos);
	InternalReadProperty(sName);
	Result:=CompareText(sName,APropName)=0;
	FStream.FSTM.Seek(iPos,STREAM_SEEK_SET,PUINT64(nil)^);
	Amdf.RichEdit.Lines.Add('TestProperty    '+APropName);
end;

{ ------------------------------------------------------------------------------- }
function TFDBinStorage.TestAndReadProperty(const APropName:string):boolean;
var
	iPos:UInt64;
	sName:string;
begin
	FStream.FSTM.Seek(0,STREAM_SEEK_CUR,iPos);
	InternalReadProperty(sName);
	Result:=CompareText(sName,APropName)=0;
	if not Result then FStream.FSTM.Seek(iPos,STREAM_SEEK_SET,PUINT64(nil)^);
	Amdf.RichEdit.Lines.Add('TestAndReadProperty    '+APropName);
end;

{ ------------------------------------------------------------------------------- }
function TFDBinStorage.ReadBoolean(const APropName:string;ADefValue:boolean):boolean;
VAR
	F:UInt64;
begin
	Amdf.RichEdit.Lines.Add('ReadBoolean');
	if TestAndReadProperty(APropName) then begin
		F:=SizeOf(boolean);
		FStream.FSTM.Read(@Result,F,@F);
	end
	else Result:=ADefValue;
end;

{ ------------------------------------------------------------------------------- }
function TFDBinStorage.ReadDate(const APropName:string;ADefValue:TDateTime):TDateTime;
VAR
	F:UInt64;
begin
	Amdf.RichEdit.Lines.Add('ReadDATA');
	if TestAndReadProperty(APropName) then begin
		F:=SizeOf(TDateTime);
		FStream.FSTM.Read(@Result,F,@F);
	end
	else Result:=ADefValue;
end;

{ ------------------------------------------------------------------------------- }
function TFDBinStorage.ReadEnum(const APropName:string;ATypeInfo:PTypeInfo;ADefValue:Integer):Integer;

	function DoReadEnum1:Integer;
	VAR
		F:UInt64;
	begin
		if TestAndReadProperty(APropName) then begin
			F:=SizeOf(Integer);
			FStream.FSTM.Read(@Result,F,@F);
			if (FStreamVersion=1)and(ATypeInfo=TypeInfo(TFDDataType)) then begin
				if Result>=Integer(dtXML) then Inc(Result);
				if Result>=Integer(dtTimeIntervalFull) then Inc(Result,3);
				if Result>=Integer(dtExtended) then Inc(Result);
				if Result>=Integer(dtSingle) then Inc(Result);
			end;
		end
		else Result:=ADefValue;
	end;

	function DoReadEnum3:Integer;
	var
		sStr:string;
	begin
		sStr:=ReadString(APropName,'');
		if sStr='' then Result:=ADefValue
		else Result:=GetEnumValue(ATypeInfo,Copy(GetCachedEnumName(ATypeInfo,Integer(ADefValue)),1,2)+sStr);
	end;

var
	iDict:Word;
	F:UInt64;
begin
	Amdf.RichEdit.Lines.Add('ReadENUM');
	if FStreamVersion>=5 then begin
		if TestAndReadProperty(APropName) then begin
			F:=SizeOf(Word);
			FStream.FSTM.Read(@iDict,F,@F);
			Result:=GetEnumValue(ATypeInfo,FDictionary[iDict]);
		end
		else Result:=ADefValue;
	end else if FStreamVersion>=3 then Result:=DoReadEnum3
	else Result:=DoReadEnum1;
end;

{ ------------------------------------------------------------------------------- }
function TFDBinStorage.ReadFloat(const APropName:string;ADefValue:Double):Double;
VAR
	F:UInt64;
begin
	Amdf.RichEdit.Lines.Add('ReadFLOAT');
	if TestAndReadProperty(APropName) then begin
		F:=SizeOf(Double);
		FStream.FSTM.Read(@Result,F,@F);
	END
	else Result:=ADefValue;
end;

{ ------------------------------------------------------------------------------- }
function TFDBinStorage.ReadInteger(const APropName:string;ADefValue:Integer):Integer;
VAR
	F:UInt64;
begin
	Amdf.RichEdit.Lines.Add('ReadINTEGER');
	if TestAndReadProperty(APropName) then begin
		F:=SizeOf(Integer);
		FStream.FSTM.Read(@Result,F,@F);
	end
	else Result:=ADefValue;
end;

{ ------------------------------------------------------------------------------- }
function TFDBinStorage.ReadLongWord(const APropName:string;ADefValue:Cardinal):Cardinal;
VAR
	F:UInt64;
begin
	Amdf.RichEdit.Lines.Add('ReadLONGINTEGER');
	if TestAndReadProperty(APropName) then begin
		F:=SizeOf(Cardinal);
		FStream.FSTM.Read(@Result,F,@F);
	end
	else Result:=ADefValue;
end;

{ ------------------------------------------------------------------------------- }
function TFDBinStorage.ReadInt64(const APropName:string;ADefValue:Int64):Int64;
VAR
	F:UInt64;
begin
	Amdf.RichEdit.Lines.Add('ReadINT64');
	if TestAndReadProperty(APropName) then begin
		F:=SizeOf(Int64);
		FStream.FSTM.Read(@Result,F,@F);
	end
	else Result:=ADefValue;
end;

{ ------------------------------------------------------------------------------- }
function TFDBinStorage.TestObject(const AObjectName:string):boolean;
var
	sName:string;
	iPos:UInt64;
begin
	Amdf.RichEdit.Lines.Add('TESTOBJ');
	FStream.FSTM.Seek(0,STREAM_SEEK_CUR,iPos);
	Result:=InternalReadObject(sName);
	if Result then Result:=CompareText(AObjectName,sName)=0;
	FStream.FSTM.Seek(iPos,STREAM_SEEK_SET,PUINT64(nil)^);
end;

{ ------------------------------------------------------------------------------- }
function TFDBinStorage.TestAndReadObjectBegin(const AObjectName:string;AStyle:TFDStorageObjectStyle):boolean;
var
	sName:string;
	iPos:UInt64;
begin
	Amdf.RichEdit.Lines.Add('TestAndReadObjectBegin');
	FStream.FSTM.Seek(0,STREAM_SEEK_CUR,iPos);
	Result:=InternalReadObject(sName);
	if Result then Result:=CompareText(AObjectName,sName)=0;
	if not Result then FStream.FSTM.Seek(iPos,STREAM_SEEK_SET,PUINT64(nil)^);
end;

{ ------------------------------------------------------------------------------- }
function TFDBinStorage.ReadObjectBegin(const AObjectName:string;AStyle:TFDStorageObjectStyle):string;
begin
	Amdf.RichEdit.Lines.Add('ReadObjectBegin');
	if not InternalReadObject(Result) then FDException(Self,[S_FD_LStan],er_FD_StanStrgCantReadObj,['<unknown>']);
	if (Result<>'')and(AObjectName<>'')and(CompareText(Result,AObjectName)<>0) then
			FDException(Self,[S_FD_LStan],er_FD_StanStrgCantReadObj,[AObjectName]);
end;

{ ------------------------------------------------------------------------------- }
function TFDBinStorage.InternalReadObject(var AName:string):boolean;
var
	b:Byte;
	iDict:Byte;
	F,F1:UInt64;
begin
	F:=SizeOf(Byte);
	F1:=0;
	FStream.FSTM.Read(@b,F,@F1);
	Amdf.RichEdit.Lines.Add('InternalReadObject  '+F1.ToString+'  '+b.ToString);
	Result:=(F1=SizeOf(Byte))and(b=C_ObjBegin);
	if Result then begin
		F:=SizeOf(Byte);
		FStream.FSTM.Read(@iDict,F,@F);
		AName:=FDictionary[iDict];
	end;
end;

{ ------------------------------------------------------------------------------- }
function TFDBinStorage.InternalReadObjectEnd:boolean;
var
	b:Byte;
	F,F1:UInt64;
begin
	Amdf.RichEdit.Lines.Add('InternalReadObjectEnd');
	F:=SizeOf(Byte);
	F1:=0;
	FStream.FSTM.Read(@b,F,@F1);
	Result:=(F1=SizeOf(Byte))and(b=C_ObjEnd);
end;

{ ------------------------------------------------------------------------------- }
function TFDBinStorage.IsObjectEnd(const AObjectName:string):boolean;
var
	iPos:UInt64;
begin
	Amdf.RichEdit.Lines.Add('IsObjectEnd');
	FStream.FSTM.Seek(0,STREAM_SEEK_CUR,iPos);
	Result:=InternalReadObjectEnd;
	FStream.FSTM.Seek(iPos,STREAM_SEEK_SET,PUINT64(nil)^);
end;

{ ------------------------------------------------------------------------------- }
procedure TFDBinStorage.ReadObjectEnd(const AObjectName:string;AStyle:TFDStorageObjectStyle);
begin
	Amdf.RichEdit.Lines.Add('ReadObjectEnd');
	InternalReadObjectEnd;
end;

{ ------------------------------------------------------------------------------- }
function TFDBinStorage.ReadAnsiString(const APropName:string;const ADefValue:TFDAnsiString):TFDAnsiString;
var
	iLen:Cardinal;
	F:UInt64;
	PP:PFDAnsiString;
begin
	Amdf.RichEdit.Lines.Add('ReadANSI');
	if TestAndReadProperty(APropName) then begin
		F:=SizeOf(Cardinal);
		FStream.FSTM.Read(@iLen,F,@F);
		if iLen<>0 then begin
			SetLength(Result,iLen DIV SizeOf(AnsiChar));
			F:=iLen;
			FStream.FSTM.Read(@Result[1],F,@F);
		end;
	end
	else Result:=ADefValue;
end;

{ ------------------------------------------------------------------------------- }
function TFDBinStorage.ReadString(const APropName:string;const ADefValue:UnicodeString):UnicodeString;
var
	iLen:Cardinal;
	F:UInt64;
	PP:Pchar;
begin
	Amdf.RichEdit.Lines.Add('ReadSTRING');
	if TestAndReadProperty(APropName) then begin
		F:=SizeOf(Cardinal);
		FStream.FSTM.Read(@iLen,F,@F);
		if iLen<>0 then begin
			SetLength(Result,iLen DIV SizeOf(WideChar));
			F:=iLen;
			FStream.FSTM.Read(@Result[1],F,@F);
		end;
	end
	else Result:=ADefValue;
end;

{ ------------------------------------------------------------------------------- }
function TFDBinStorage.ReadValue(const APropName:string;APropIndex:Word;ADataType:TFDDataType;out ABuff:Pointer;
	out ALen:Cardinal):boolean;
var
	oMS:TMemoryStream;
	iProp:Word;
	iLen:Byte;
	iBmk,F:UInt64;
begin
	Amdf.RichEdit.Lines.Add('ReadVALUE');
	ABuff:=nil;
	ALen:=0;
	Result:=False;
	if FStreamVersion>=4 then begin
		FStream.FSTM.Seek(0,STREAM_SEEK_CUR,iBmk);
		F:=SizeOf(Word);
		FStream.FSTM.Read(@iProp,F,@F);
		if iProp<>APropIndex then begin
			FStream.FSTM.Seek(iBmk,STREAM_SEEK_SET,PUINT64(nil)^);
			exit;
		end;
	end else begin
		if not TestAndReadProperty(APropName) then exit;
	end;
	Result:=True;
	case ADataType of
		dtObject,dtRowSetRef,dtCursorRef,dtRowRef,dtArrayRef:ALen:=0;
		dtMemo,dtHMemo,dtWideMemo,dtXML,dtWideHMemo,dtByteString,dtBlob,dtHBlob,dtHBFile,dtAnsiString,dtWideString:begin
				F:=SizeOf(Cardinal);
				FStream.FSTM.Read(@ALen,F,@F);
			END;
		dtBoolean:ALen:=SizeOf(WordBool);
		dtSByte:ALen:=SizeOf(ShortInt);
		dtInt16:ALen:=SizeOf(SmallInt);
		dtInt32:ALen:=SizeOf(Integer);
		dtInt64:ALen:=SizeOf(Int64);
		dtByte:ALen:=SizeOf(Byte);
		dtUInt16:ALen:=SizeOf(Word);
		dtUInt32,dtParentRowRef:ALen:=SizeOf(Cardinal);
		dtUInt64:ALen:=SizeOf(UInt64);
		dtSingle:ALen:=SizeOf(Single);
		dtDouble:ALen:=SizeOf(Double);
		dtExtended:ALen:=SizeOf(Extended);
		dtCurrency:ALen:=SizeOf(Currency);
		dtBCD,dtFmtBCD: if FStreamVersion>=4 then begin
				F:=SizeOf(Byte);
				FStream.FSTM.Read(@iLen,F,@F);
				ALen:=SizeOf(TBcd);
				oMS:=CheckBuffer(ALen);
				ABuff:=oMS.Memory;
				if iLen<>0 then begin
					F:=iLen;
					FStream.FSTM.Read(ABuff,F,@F);
				end;
				FillChar((PByte(ABuff)+iLen)^,ALen-iLen,0);
				exit;
			end
			else ALen:=SizeOf(TBcd);
		dtDateTime:ALen:=SizeOf(TDateTimeAlias);
		dtDateTimeStamp:ALen:=SizeOf(TSQLTimeStamp);
		dtTimeIntervalFull,dtTimeIntervalYM,dtTimeIntervalDS:ALen:=SizeOf(TFDSQLTimeInterval);
		dtTime,dtDate:ALen:=SizeOf(Integer);
		dtGUID:ALen:=SizeOf(TGUID);
	end;
	oMS:=CheckBuffer(ALen);
	if ALen<>0 then begin
		F:=ALen;
		FStream.FSTM.Read(oMS.Memory,F,@F);
	end;
	ABuff:=oMS.Memory;
	if ADataType in [dtWideMemo,dtXML,dtWideHMemo,dtWideString] then ALen:=ALen div SizeOf(WideChar);
end;

{ ------------------------------------------------------------------------------- }
function TFDBinStorage.LookupName(const AName:string):Word;
var
	i:Integer;
begin
	i:=FDictionary.IndexOf(AName);
	if i=-1 then begin
		if FDictionaryIndex>=$FFFF then FDException(Self,[S_FD_LStan],er_FD_StanStrgDictOverflow,[]);
		FDictionary.AddInt(AName,LongWord(FDictionaryIndex));
		Result:=Word(FDictionaryIndex);
		Inc(FDictionaryIndex);
		if FDictionaryIndex=C_ObjEnd then begin
			LookupName('<end>');
			LookupName('<begin>');
		end;
	end
	else Result:=Word(LongWord(FDictionary.Ints[i]));
end;

{ ------------------------------------------------------------------------------- }
procedure TFDBinStorage.InternalWriteProperty(const APropName:string;ApValue:Pointer;ALen:Cardinal);
var
	iDict:Word;
	F:UInt64;
begin
	iDict:=LookupName(APropName);
	F:=0;
	FStream.FSTM.Write(@iDict,SizeOf(Word),@F);
	if ApValue<>nil then begin
		F:=0;
		FStream.FSTM.Write(ApValue,ALen,@F);
	end;
end;

{ ------------------------------------------------------------------------------- }
procedure TFDBinStorage.WriteBoolean(const APropName:string;const AValue,ADefValue:boolean);
begin
	if AValue<>ADefValue then InternalWriteProperty(APropName,@AValue,SizeOf(AValue));
end;

{ ------------------------------------------------------------------------------- }
procedure TFDBinStorage.WriteDate(const APropName:string;const AValue,ADefValue:TDateTime);
begin
	if AValue<>ADefValue then InternalWriteProperty(APropName,@AValue,SizeOf(AValue));
end;

{ ------------------------------------------------------------------------------- }
procedure TFDBinStorage.WriteEnum(const APropName:string;ATypeInfo:PTypeInfo;const AValue,ADefValue:Integer);

	procedure DoWriteEnum1;
	var
		iVal:Integer;
	begin
		iVal:=AValue;
		if (FStreamVersion=1)and(ATypeInfo=TypeInfo(TFDDataType)) then begin
			if iVal>Integer(dtWideMemo) then Dec(iVal);
			if iVal>Integer(dtDateTimeStamp) then Dec(iVal,3);
		end;
		InternalWriteProperty(APropName,@iVal,SizeOf(iVal));
	end;

	procedure DoWriteEnum3;
	begin
		WriteString(APropName,Copy(GetCachedEnumName(ATypeInfo,AValue),3,MAXINT),
			Copy(GetCachedEnumName(ATypeInfo,ADefValue),3,MAXINT))
	end;

var
	iDict:Word;
begin
	// Amdf.RichEdit.Lines.Add('write enum S  '+AValue.ToString);
	if AValue<>ADefValue then
		if FStreamVersion>=5 then begin
			iDict:=LookupName(GetCachedEnumName(ATypeInfo,AValue));
			InternalWriteProperty(APropName,@iDict,SizeOf(iDict));
		end else if FStreamVersion>=3 then DoWriteEnum3()
		else DoWriteEnum1();
	// Amdf.RichEdit.Lines.Add('write enum E  '+AValue.ToString);
end;

{ ------------------------------------------------------------------------------- }
procedure TFDBinStorage.WriteFloat(const APropName:string;const AValue,ADefValue:Double);
begin
	if AValue<>ADefValue then InternalWriteProperty(APropName,@AValue,SizeOf(AValue));
end;

{ ------------------------------------------------------------------------------- }
procedure TFDBinStorage.WriteInteger(const APropName:string;const AValue,ADefValue:Integer);
begin
	if AValue<>ADefValue then InternalWriteProperty(APropName,@AValue,SizeOf(AValue));
end;

{ ------------------------------------------------------------------------------- }
procedure TFDBinStorage.WriteLongWord(const APropName:string;const AValue,ADefValue:Cardinal);
var
	uiVal:Cardinal;
begin
	if AValue<>ADefValue then begin
		uiVal:=AValue;
		InternalWriteProperty(APropName,@uiVal,SizeOf(uiVal));
	end;
end;

{ ------------------------------------------------------------------------------- }
procedure TFDBinStorage.WriteInt64(const APropName:string;const AValue,ADefValue:Int64);
begin
	if AValue<>ADefValue then InternalWriteProperty(APropName,@AValue,SizeOf(AValue));
end;

{ ------------------------------------------------------------------------------- }
procedure TFDBinStorage.WriteObjectBegin(const AObjectName:string;AStyle:TFDStorageObjectStyle);
var
	b:Byte;
	iDict:Byte;
	F:UInt64;
begin
	b:=C_ObjBegin;
	F:=0;
	FStream.FSTM.Write(@b,SizeOf(Byte),@F);
	iDict:=LookupName(AObjectName);
	F:=0;
	FStream.FSTM.Write(@iDict,SizeOf(Byte),@F);
	// Amdf.RichEdit.Lines.Add('WriteObjectBegin   '+b.ToString);
	// Amdf.RichEdit.Lines.Add('WriteObjectBegin   '+iDict.ToString);
end;

{ ------------------------------------------------------------------------------- }
procedure TFDBinStorage.WriteObjectEnd(const AObjectName:string;AStyle:TFDStorageObjectStyle);
var
	b:Byte;
	F:UInt64;
begin
	b:=C_ObjEnd;
	F:=0;
	FStream.FSTM.Write(@b,SizeOf(Byte),@F);
	// Amdf.RichEdit.Lines.Add('WriteObjectEnd   '+b.ToString);
end;

{ ------------------------------------------------------------------------------- }
procedure TFDBinStorage.WriteAnsiString(const APropName:string;const AValue,ADefValue:TFDAnsiString);
var
	iLen:Cardinal;
	F:UInt64;
	PP:PAnsiChar;
	S:TFDAnsiString;
begin
	// Amdf.RichEdit.Lines.Add('write ansi   '+AValue+'  '+Length(AValue).ToString);
	if AValue<>ADefValue then begin
		InternalWriteProperty(APropName,nil,0);
		iLen:=Length(AValue)*SizeOf(AnsiChar);
		F:=0;
		FStream.FSTM.Write(@iLen,SizeOf(Cardinal),@F);
		if iLen<>0 then begin
			F:=0;
			SetLength(S,Length(AValue));
			S:=AValue;
			FStream.FSTM.Write(@S[1],iLen,@F);
		end;
	end;
end;

{ ------------------------------------------------------------------------------- }
procedure TFDBinStorage.WriteString(const APropName:string;const AValue,ADefValue:UnicodeString);
var
	iLen:Cardinal;
	F:UInt64;
	PP:Pchar;
	S:string;
begin
	// Amdf.RichEdit.Lines.Add('write unicode   '+AValue+'  '+Length(AValue).ToString);
	if AValue<>ADefValue then begin
		InternalWriteProperty(APropName,nil,0);
		iLen:=Length(AValue)*SizeOf(WideChar);
		F:=0;
		FStream.FSTM.Write(@iLen,SizeOf(Cardinal),@F);
		if iLen<>0 then begin
			F:=0;
			SetLength(S,Length(AValue));
			S:=AValue;
			FStream.FSTM.Write(@S[1],iLen,@F);
		end;
	end;
end;

{ ------------------------------------------------------------------------------- }
procedure TFDBinStorage.WriteValue(const APropName:string;APropIndex:Word;ADataType:TFDDataType;ABuff:Pointer;
	ALen:Cardinal);
var
	iLen:Byte;
	F:UInt64;
	PP:Pointer;
	Px:Pchar;
	PA:PAnsiChar;
	S:string;
	ss:AnsiString;
begin
	if ABuff=nil then exit;
	if FStreamVersion>=4 then begin
		F:=0;
		FStream.FSTM.Write(@APropIndex,SizeOf(Word),@F);
	end
	else InternalWriteProperty(APropName,nil,0);
	F:=0;
	case ADataType of
		dtObject,dtRowSetRef,dtCursorRef,dtRowRef,dtArrayRef:;
		// dtBlob:Amdf.RichEdit.Lines.Add('dtBlob = '+Integer(FStream.FSTM.Write(ABuff,ALen,@F)).ToString+#13+F.ToString);
		dtWideMemo,dtXML,dtWideString,dtWideHMemo:begin
				// Amdf.RichEdit.Lines.Add('WriteValue WIDECHAR S = '+Pchar(ABuff));
				iLen:=ALen*SizeOf(WideChar);
				F:=0;
				FStream.FSTM.Write(@ALen,SizeOf(Cardinal),@F);
				F:=0;
				FStream.FSTM.Write(ABuff,iLen,@F);
				// Amdf.RichEdit.Lines.Add('WriteValue WIDECHAR E = '+Pchar(ABuff));
			end;
		dtMemo,dtHMemo,dtAnsiString:begin
				// Amdf.RichEdit.Lines.Add('WriteValue ANSICHAR S = '+PAnsiChar(ABuff));
				iLen:=ALen*SizeOf(AnsiChar);
				F:=0;
				FStream.FSTM.Write(@ALen,SizeOf(Cardinal),@F);
				F:=0;
				FStream.FSTM.Write(ABuff,iLen,@F);
				// Amdf.RichEdit.Lines.Add('WriteValue ANSICHAR E = '+PAnsiChar(ABuff));
			end;
		dtByteString,dtBlob,dtHBlob,dtHBFile:begin
				// Amdf.RichEdit.Lines.Add('WriteValue dtByteString S = '+SizeOf(ABuff).ToString+'.'+ALen.ToString);
				FStream.FSTM.Write(@ALen,SizeOf(Cardinal),@F);
				F:=0;
				FStream.FSTM.Write(@TBytes(ABuff)[0],ALen,@F);
				// Amdf.RichEdit.Lines.Add('WriteValue dtByteString E = '+SizeOf(ABuff).ToString+'.'+ALen.ToString);
			end;
		dtBCD,dtFmtBCD: if FStreamVersion>=4 then begin
				// Amdf.RichEdit.Lines.Add('WriteValue BCD S = '+SizeOf(ABuff).ToString+'.'+ALen.ToString);
				iLen:=2+(PBcd(ABuff)^.Precision+1)div 2;
				F:=0;
				FStream.FSTM.Write(@iLen,SizeOf(Byte),@F);
				F:=0;
				PP:=CoTaskMemAlloc(iLen);
				Move(ABuff,PP,iLen);
				FStream.FSTM.Write(PP,iLen,@F);
				CoTaskMemFree(PP);
				// Amdf.RichEdit.Lines.Add('WriteValue BCD E = '+SizeOf(ABuff).ToString+'.'+ALen.ToString);
			end;
	else begin
			// Amdf.RichEdit.Lines.Add('WriteValue OTHER S = '+SizeOf(ABuff).ToString+'.'+ALen.ToString);
			F:=0;
			FStream.FSTM.Write(ABuff,ALen,@F);
			// Amdf.RichEdit.Lines.Add('WriteValue OTHER E = '+SizeOf(ABuff).ToString+'.'+ALen.ToString);
		end;
	end;
	// ShowMessage('write value end');
end;

{ ------------------------------------------------------------------------------- }
type
	TFDBinStorageBmk=class(TObject)
	private
		FPos:UInt64;
	end;

function TFDBinStorage.GetBookmark:TObject;
begin
	Result:=TFDBinStorageBmk.Create;
	FStream.FSTM.Seek(0,STREAM_SEEK_CUR,TFDBinStorageBmk(Result).FPos);
end;

{ ------------------------------------------------------------------------------- }
procedure TFDBinStorage.SetBookmark(const AValue:TObject);
begin
	FStream.FSTM.Seek(TFDBinStorageBmk(AValue).FPos,STREAM_SEEK_SET,PUINT64(nil)^);
end;

{ -----------------------------------TAMDStM----------------------------------- }

constructor TAMDStM.Create(const HGlob:HGLOBAL);
begin
	inherited Create;
	FHGlob:=HGlob;
	CreateStreamOnHGlobal(FHGlob,True,FSTM);
end;

constructor TAMDStM.Create(const AFile:string;MODE:Word=0);
begin
	inherited Create;
	FFile:=AFile;
	if MODE=0 then
			SHCreateStreamOnFileEx(Pchar(AFile),STGM_CREATE or STGM_READWRITE or STGM_SHARE_EXCLUSIVE,0,True,nil,FSTM)
	else SHCreateStreamOnFileEx(Pchar(AFile),STGM_READWRITE,0,False,nil,FSTM)
end;

destructor TAMDStM.Destroy;
begin
	FSTM._Release;
	FSTM:=nil;
	// GlobalFree(FHGlob);
	inherited Destroy;
end;

function TAMDStM.GetPosition:Int64;
begin
	ShowMessage('GetPosition');
	FSTM.Seek(0,STREAM_SEEK_CUR,PUINT64(Result)^);
end;

procedure TAMDStM.SetPosition(const Pos:Int64);
begin
	ShowMessage('SetPosition');
	FSTM.Seek(Pos,STREAM_SEEK_SET,PUINT64(nil)^);
end;

procedure TAMDStM.SetSize64(const NewSize:Int64);
begin
	ShowMessage('SetSize64');
	FSTM.SetSize(NewSize);
end;

function TAMDStM.Skip(Amount:Int64):Int64;
begin
	ShowMessage('Skip');
	FSTM.Seek(Amount,STREAM_SEEK_CUR,PUINT64(Result)^);
end;

function TAMDStM.GetSize:Int64;
VAR
	statstg:TStatStg;
begin
	ShowMessage('GetSize');
	FSTM.Stat(statstg,STATFLAG_NONAME);
	Result:=statstg.cbSize;
end;

procedure TAMDStM.SetSize(NewSize:Longint);
begin
	ShowMessage('SetSize');
	FSTM.SetSize(UInt64(NewSize));
end;

procedure TAMDStM.SetSize(const NewSize:Int64);
begin
	ShowMessage('SetSize');
	FSTM.SetSize(UInt64(NewSize));
end;

function TAMDStM.Seek32(const Offset:Integer;Origin:TSeekOrigin):Int64;
VAR
	ORI:Cardinal;
begin
	ShowMessage('Seek32');
	case Origin of
		soBeginning:ORI:=STREAM_SEEK_SET;
		soCurrent:ORI:=STREAM_SEEK_CUR;
		soEnd:ORI:=STREAM_SEEK_END;
	end;
	FSTM.Seek(Int64(Offset),ORI,PUINT64(Result)^);
end;

function TAMDStM.Seek(Offset:Longint;Origin:Word):Longint;
VAR
	ORI:Cardinal;
begin
	ShowMessage('Seek');
	case Origin of
		0:ORI:=STREAM_SEEK_SET;
		1:ORI:=STREAM_SEEK_CUR;
		2:ORI:=STREAM_SEEK_END;
	end;
	FSTM.Seek(Int64(Offset),ORI,PUINT64(Result)^);
end;

function TAMDStM.Seek(const Offset:Int64;Origin:TSeekOrigin):Int64;
VAR
	ORI:Cardinal;
begin
	ShowMessage('Seek');
	case Origin of
		soBeginning:ORI:=STREAM_SEEK_SET;
		soCurrent:ORI:=STREAM_SEEK_CUR;
		soEnd:ORI:=STREAM_SEEK_END;
	end;
	FSTM.Seek(Int64(Offset),ORI,PUINT64(Result)^);
end;

function TAMDStM.Seek(const Offset:Int64;Origin:Word):Int64;
VAR
	ORI:Cardinal;
begin
	ShowMessage('Seek');
	case Origin of
		0:ORI:=STREAM_SEEK_SET;
		1:ORI:=STREAM_SEEK_CUR;
		2:ORI:=STREAM_SEEK_END;
	end;
	FSTM.Seek(Int64(Offset),ORI,PUINT64(Result)^);
end;

function TAMDStM.Read(var Buffer;Count:Longint):Longint;
VAR
	F:UInt64;
begin
	ShowMessage('Read');
	if SizeOf(Buffer)=0 then exit;
	F:=Count;
	FSTM.Read(@Buffer,F,@Result);
end;

function TAMDStM.Write(const Buffer;Count:Longint):Longint;
begin
	ShowMessage('Write');
	Result:=0;
	if SizeOf(Buffer)=0 then exit;
	FSTM.Write(@Buffer,Count,@Result);
end;

function TAMDStM.Read(Buffer:TBytes;Offset,Count:Longint):Longint;
begin
	ShowMessage('Read');
	if (Length(Buffer)=0) then SetLength(Buffer,Count);
	FSTM.Read(@Buffer[Offset],Cardinal(GetByteCount(Buffer,Offset,Count)),@Result);
end;

function TAMDStM.Write(const Buffer:TBytes;Offset,Count:Longint):Longint;
begin
	ShowMessage('Write');
	Result:=0;
	if (Length(Buffer)=0) then exit;
	FSTM.Write(@Buffer[Offset],Cardinal(GetByteCount(Buffer,Offset,Count)),@Result);
end;

function TAMDStM.Read(var Buffer:TBytes;Count:Longint):Longint;
begin
	ShowMessage('Read');
	if (Length(Buffer)=0) then SetLength(Buffer,Count);
	Result:=Read(Buffer,0,Count);
end;

function TAMDStM.Write(const Buffer:TBytes;Count:Longint):Longint;
begin
	ShowMessage('Write');
	Result:=Write(Buffer,0,Count);
end;

function TAMDStM.Read64(Buffer:TBytes;Offset,Count:Int64):Int64;
begin
	ShowMessage('Read64');
	if (Length(Buffer)=0) then SetLength(Buffer,Count);
	Result:=Read(Buffer,0,Count);
end;

function TAMDStM.Write64(const Buffer:TBytes;Offset,Count:Int64):Int64;
begin
	ShowMessage('Write64');
	Result:=Write(Buffer,0,Count);
end;

function TAMDStM.ReadData(Buffer:Pointer;Count:NativeInt):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('ReadData');
	if (SizeOf(Buffer)=0) then exit;
	if Count>SizeOf(Buffer) then Count:=SizeOf(Buffer);
	F:=Count;
	FSTM.Read(@Buffer,F,@Result);
end;

function TAMDStM.ReadData(const Buffer:TBytes;Count:NativeInt):NativeInt;
begin
	ShowMessage('ReadData');
	Result:=Read(Buffer,0,Count);
end;

function TAMDStM.ReadData(var Buffer:boolean):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('ReadData');
	F:=SizeOf(boolean);
	FSTM.Read(@Buffer,F,@Result);
end;

function TAMDStM.ReadData(var Buffer:boolean;Count:NativeInt):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('ReadData');
	F:=SizeOf(boolean);
	FSTM.Read(@Buffer,F,@Result);
end;

function TAMDStM.ReadData(var Buffer:AnsiChar):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('ReadData');
	F:=SizeOf(AnsiChar);
	FSTM.Read(@Buffer,F,@Result);
end;

function TAMDStM.ReadData(var Buffer:AnsiChar;Count:NativeInt):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('ReadData');
	F:=SizeOf(AnsiChar);
	FSTM.Read(@Buffer,F,@Result);
end;

function TAMDStM.ReadData(var Buffer:Char):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('ReadData');
	F:=SizeOf(Char);
	FSTM.Read(@Buffer,F,@Result);
end;

function TAMDStM.ReadData(var Buffer:Char;Count:NativeInt):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('ReadData');
	F:=SizeOf(Char);
	FSTM.Read(@Buffer,F,@Result);
end;

function TAMDStM.ReadData(var Buffer:Int8):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('ReadData');
	F:=SizeOf(Int8);
	FSTM.Read(@Buffer,F,@Result);
end;

function TAMDStM.ReadData(var Buffer:Int8;Count:NativeInt):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('ReadData');
	F:=SizeOf(Int8);
	FSTM.Read(@Buffer,F,@Result);
end;

function TAMDStM.ReadData(var Buffer:UInt8):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('ReadData');
	F:=SizeOf(UInt8);
	FSTM.Read(@Buffer,F,@Result);
end;

function TAMDStM.ReadData(var Buffer:UInt8;Count:NativeInt):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('ReadData');
	F:=SizeOf(UInt8);
	FSTM.Read(@Buffer,F,@Result);
end;

function TAMDStM.ReadData(var Buffer:Int16):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('ReadData');
	F:=SizeOf(Int16);
	FSTM.Read(@Buffer,F,@Result);
end;

function TAMDStM.ReadData(var Buffer:Int16;Count:NativeInt):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('ReadData');
	F:=SizeOf(Int16);
	FSTM.Read(@Buffer,F,@Result);
end;

function TAMDStM.ReadData(var Buffer:UInt16):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('ReadData');
	F:=SizeOf(UInt16);
	FSTM.Read(@Buffer,F,@Result);
end;

function TAMDStM.ReadData(var Buffer:UInt16;Count:NativeInt):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('ReadData');
	F:=SizeOf(UInt16);
	FSTM.Read(@Buffer,F,@Result);
end;

function TAMDStM.ReadData(var Buffer:Int32):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('ReadData');
	F:=SizeOf(Int32);
	FSTM.Read(@Buffer,F,@Result);
end;

function TAMDStM.ReadData(var Buffer:Int32;Count:NativeInt):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('ReadData');
	F:=SizeOf(Int32);
	FSTM.Read(@Buffer,F,@Result);
end;

function TAMDStM.ReadData(var Buffer:UInt32):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('ReadData');
	F:=SizeOf(UInt32);
	FSTM.Read(@Buffer,F,@Result);
end;

function TAMDStM.ReadData(var Buffer:UInt32;Count:NativeInt):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('ReadData');
	F:=SizeOf(UInt32);
	FSTM.Read(@Buffer,F,@Result);
end;

function TAMDStM.ReadData(var Buffer:Int64):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('ReadData');
	F:=SizeOf(Int64);
	FSTM.Read(@Buffer,F,@Result);
end;

function TAMDStM.ReadData(var Buffer:Int64;Count:NativeInt):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('ReadData');
	F:=SizeOf(Int64);
	FSTM.Read(@Buffer,F,@Result);
end;

function TAMDStM.ReadData(var Buffer:UInt64):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('ReadData');
	F:=SizeOf(UInt64);
	FSTM.Read(@Buffer,F,@Result);
end;

function TAMDStM.ReadData(var Buffer:UInt64;Count:NativeInt):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('ReadData');
	F:=SizeOf(UInt64);
	FSTM.Read(@Buffer,F,@Result);
end;

function TAMDStM.ReadData(var Buffer:Single):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('ReadData');
	F:=SizeOf(Single);
	FSTM.Read(@Buffer,F,@Result);
end;

function TAMDStM.ReadData(var Buffer:Single;Count:NativeInt):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('ReadData');
	F:=SizeOf(Single);
	FSTM.Read(@Buffer,F,@Result);
end;

function TAMDStM.ReadData(var Buffer:Double):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('ReadData');
	F:=SizeOf(Double);
	FSTM.Read(@Buffer,F,@Result);
end;

function TAMDStM.ReadData(var Buffer:Double;Count:NativeInt):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('ReadData');
	F:=SizeOf(Double);
	FSTM.Read(@Buffer,F,@Result);
end;

function TAMDStM.ReadData(var Buffer:Extended):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('ReadData');
	F:=SizeOf(Extended);
	FSTM.Read(@Buffer,F,@Result);
end;

function TAMDStM.ReadData(var Buffer:Extended;Count:NativeInt):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('ReadData');
	F:=SizeOf(Extended);
	FSTM.Read(@Buffer,F,@Result);
end;

function TAMDStM.ReadData(var Buffer:TExtended80Rec):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('ReadData');
	F:=SizeOf(TExtended80Rec);
	FSTM.Read(@Buffer,F,@Result);
end;

function TAMDStM.ReadData(var Buffer:TExtended80Rec;Count:NativeInt):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('ReadData');
	F:=SizeOf(TExtended80Rec);
	FSTM.Read(@Buffer,F,@Result);
end;

function TAMDStM.ReadData<T>(var Buffer:T):NativeInt;
begin
	ShowMessage('ReadData');
	Result:=Read(Buffer,SizeOf(Buffer));
end;

function TAMDStM.ReadData<T>(var Buffer:T;Count:NativeInt):NativeInt;
const
	BufSize=SizeOf(Buffer);
begin
	ShowMessage('ReadData');
	if Count<>BufSize then begin
		Buffer:=Default (T);
		Result:=Skip(Count);
	end
	else Result:=Read(Buffer,BufSize);
end;

function TAMDStM.WriteData(const Buffer:TBytes;Count:NativeInt):NativeInt;
begin
	ShowMessage('WriteData');
	Result:=Write(Buffer,0,Count);
end;

function TAMDStM.WriteData(const Buffer:Pointer;Count:NativeInt):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('WriteData');
	if (SizeOf(Buffer)=0) then exit;
	if Count>SizeOf(Buffer) then Count:=SizeOf(Buffer);
	F:=Count;
	FSTM.Write(@Buffer,F,@Result);
end;

function TAMDStM.WriteData(const Buffer:boolean):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('WriteData');
	F:=SizeOf(boolean);
	FSTM.Write(@Buffer,F,@Result);
end;

function TAMDStM.WriteData(const Buffer:boolean;Count:NativeInt):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('WriteData');
	F:=SizeOf(boolean);
	FSTM.Write(@Buffer,F,@Result);
end;

function TAMDStM.WriteData(const Buffer:AnsiChar):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('WriteData');
	F:=SizeOf(AnsiChar);
	FSTM.Write(@Buffer,F,@Result);
end;

function TAMDStM.WriteData(const Buffer:AnsiChar;Count:NativeInt):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('WriteData');
	F:=SizeOf(AnsiChar);
	FSTM.Write(@Buffer,F,@Result);
end;

function TAMDStM.WriteData(const Buffer:Char):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('WriteData');
	F:=SizeOf(Char);
	FSTM.Write(@Buffer,F,@Result);
end;

function TAMDStM.WriteData(const Buffer:Char;Count:NativeInt):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('WriteData');
	F:=SizeOf(Char);
	FSTM.Write(@Buffer,F,@Result);
end;

function TAMDStM.WriteData(const Buffer:Int8):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('WriteData');
	F:=SizeOf(Int8);
	FSTM.Write(@Buffer,F,@Result);
end;

function TAMDStM.WriteData(const Buffer:Int8;Count:NativeInt):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('WriteData');
	F:=SizeOf(Int8);
	FSTM.Write(@Buffer,F,@Result);
end;

function TAMDStM.WriteData(const Buffer:UInt8):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('WriteData');
	F:=SizeOf(UInt8);
	FSTM.Write(@Buffer,F,@Result);
end;

function TAMDStM.WriteData(const Buffer:UInt8;Count:NativeInt):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('WriteData');
	F:=SizeOf(UInt8);
	FSTM.Write(@Buffer,F,@Result);
end;

function TAMDStM.WriteData(const Buffer:Int16):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('WriteData');
	F:=SizeOf(Int16);
	FSTM.Write(@Buffer,F,@Result);
end;

function TAMDStM.WriteData(const Buffer:Int16;Count:NativeInt):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('WriteData');
	F:=SizeOf(Int16);
	FSTM.Write(@Buffer,F,@Result);
end;

function TAMDStM.WriteData(const Buffer:UInt16):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('WriteData');
	F:=SizeOf(UInt16);
	FSTM.Write(@Buffer,F,@Result);
end;

function TAMDStM.WriteData(const Buffer:UInt16;Count:NativeInt):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('WriteData');
	F:=SizeOf(UInt16);
	FSTM.Write(@Buffer,F,@Result);
end;

function TAMDStM.WriteData(const Buffer:Int32):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('WriteData');
	F:=SizeOf(Int32);
	FSTM.Write(@Buffer,F,@Result);
end;

function TAMDStM.WriteData(const Buffer:Int32;Count:NativeInt):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('WriteData');
	F:=SizeOf(Int32);
	FSTM.Write(@Buffer,F,@Result);
end;

function TAMDStM.WriteData(const Buffer:UInt32):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('WriteData');
	F:=SizeOf(UInt32);
	FSTM.Write(@Buffer,F,@Result);
end;

function TAMDStM.WriteData(const Buffer:UInt32;Count:NativeInt):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('WriteData');
	F:=SizeOf(UInt32);
	FSTM.Write(@Buffer,F,@Result);
end;

function TAMDStM.WriteData(const Buffer:Int64):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('WriteData');
	F:=SizeOf(Int64);
	FSTM.Write(@Buffer,F,@Result);
end;

function TAMDStM.WriteData(const Buffer:Int64;Count:NativeInt):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('WriteData');
	F:=SizeOf(Int64);
	FSTM.Write(@Buffer,F,@Result);
end;

function TAMDStM.WriteData(const Buffer:UInt64):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('WriteData');
	F:=SizeOf(UInt64);
	FSTM.Write(@Buffer,F,@Result);
end;

function TAMDStM.WriteData(const Buffer:UInt64;Count:NativeInt):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('WriteData');
	F:=SizeOf(UInt64);
	FSTM.Write(@Buffer,F,@Result);
end;

function TAMDStM.WriteData(const Buffer:Single):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('WriteData');
	F:=SizeOf(Single);
	FSTM.Write(@Buffer,F,@Result);
end;

function TAMDStM.WriteData(const Buffer:Single;Count:NativeInt):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('WriteData');
	F:=SizeOf(Single);
	FSTM.Write(@Buffer,F,@Result);
end;

function TAMDStM.WriteData(const Buffer:Double):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('WriteData');
	F:=SizeOf(Double);
	FSTM.Write(@Buffer,F,@Result);
end;

function TAMDStM.WriteData(const Buffer:Double;Count:NativeInt):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('WriteData');
	F:=SizeOf(Double);
	FSTM.Write(@Buffer,F,@Result);
end;

function TAMDStM.WriteData(const Buffer:Extended):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('WriteData');
	F:=SizeOf(Extended);
	FSTM.Write(@Buffer,F,@Result);
end;

function TAMDStM.WriteData(const Buffer:Extended;Count:NativeInt):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('WriteData');
	F:=SizeOf(Extended);
	FSTM.Write(@Buffer,F,@Result);
end;

function TAMDStM.WriteData(const Buffer:TExtended80Rec):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('WriteData');
	F:=SizeOf(TExtended80Rec);
	FSTM.Write(@Buffer,F,@Result);
end;

function TAMDStM.WriteData(const Buffer:TExtended80Rec;Count:NativeInt):NativeInt;
VAR
	F:UInt64;
begin
	ShowMessage('WriteData');
	F:=SizeOf(TExtended80Rec);
	FSTM.Write(@Buffer,F,@Result);
end;

function TAMDStM.WriteData<T>(const Buffer:T):NativeInt;
begin
	Result:=Write(Buffer,SizeOf(Buffer));
end;

function TAMDStM.WriteData<T>(const Buffer:T;Count:NativeInt):NativeInt;
const
	BufSize=SizeOf(Buffer);
begin
	if Count>BufSize then begin
		Result:=Write(Buffer,BufSize);
		Result:=Result+Skip(Count-BufSize);
	end
	else Result:=Write(Buffer,Count)
end;

procedure TAMDStM.ReadBuffer(var Buffer:TBytes;Offset,Count:NativeInt);
var
	LTotalCount,LReadCount:NativeInt;
begin
	{ Perform a read directly. Most of the time this will succeed
		without the need to go into the WHILE loop. }
	LTotalCount:=Read(Buffer,Offset,Count);
	{ Check if there was an error }
	while (LTotalCount<Count) do begin
		{ Try to read a contiguous block of <Count> size }
		LReadCount:=Read(Buffer,Offset+LTotalCount,(Count-LTotalCount));
		{ Check if we read something and decrease the number of bytes left to read }
		if LReadCount>0 then Inc(LTotalCount,LReadCount);
	end
end;

procedure TAMDStM.ReadBuffer(var Buffer;Count:NativeInt);
var
	LTotalCount,LReadCount:NativeInt;
begin
	{ Perform a read directly. Most of the time this will succeed
		without the need to go into the WHILE loop. }
	LTotalCount:=Read(Buffer,Count);
	while (LTotalCount<Count) do begin
		{ Try to read a contiguous block of <Count> size }
		LReadCount:=Read(PByte(PByte(@Buffer)+LTotalCount)^,(Count-LTotalCount));
		{ Check if we read something and decrease the number of bytes left to read }
		if LReadCount>0 then Inc(LTotalCount,LReadCount);
	end
end;

procedure TAMDStM.ReadBuffer(var Buffer:TBytes;Count:NativeInt);
begin
	ReadBuffer(Buffer,0,Count);
end;

procedure TAMDStM.ReadBufferData(var Buffer:boolean);
begin
	ReadData(Buffer);
end;

procedure TAMDStM.ReadBufferData(var Buffer:boolean;Count:NativeInt);
begin
	ReadData(Buffer,Count);
end;

procedure TAMDStM.ReadBufferData(var Buffer:AnsiChar);
begin
	ReadData(Buffer);
end;

procedure TAMDStM.ReadBufferData(var Buffer:AnsiChar;Count:NativeInt);
begin
	ReadData(Buffer,Count);
end;

procedure TAMDStM.ReadBufferData(var Buffer:Char);
begin
	ReadData(Buffer);
end;

procedure TAMDStM.ReadBufferData(var Buffer:Char;Count:NativeInt);
begin
	ReadData(Buffer,Count);
end;

procedure TAMDStM.ReadBufferData(var Buffer:Int8);
begin
	ReadData(Buffer);
end;

procedure TAMDStM.ReadBufferData(var Buffer:Int8;Count:NativeInt);
begin
	ReadData(Buffer,Count);
end;

procedure TAMDStM.ReadBufferData(var Buffer:UInt8);
begin
	ReadData(Buffer);
end;

procedure TAMDStM.ReadBufferData(var Buffer:UInt8;Count:NativeInt);
begin
	ReadData(Buffer,Count);
end;

procedure TAMDStM.ReadBufferData(var Buffer:Int16);
begin
	ReadData(Buffer);
end;

procedure TAMDStM.ReadBufferData(var Buffer:Int16;Count:NativeInt);
begin
	ReadData(Buffer,Count);
end;

procedure TAMDStM.ReadBufferData(var Buffer:UInt16);
begin
	ReadData(Buffer);
end;

procedure TAMDStM.ReadBufferData(var Buffer:UInt16;Count:NativeInt);
begin
	ReadData(Buffer,Count);
end;

procedure TAMDStM.ReadBufferData(var Buffer:Int32);
begin
	ReadData(Buffer);
end;

procedure TAMDStM.ReadBufferData(var Buffer:Int32;Count:NativeInt);
begin
	ReadData(Buffer,Count);
end;

procedure TAMDStM.ReadBufferData(var Buffer:UInt32);
begin
	ReadData(Buffer);
end;

procedure TAMDStM.ReadBufferData(var Buffer:UInt32;Count:NativeInt);
begin
	ReadData(Buffer,Count);
end;

procedure TAMDStM.ReadBufferData(var Buffer:Int64);
begin
	ReadData(Buffer);
end;

procedure TAMDStM.ReadBufferData(var Buffer:Int64;Count:NativeInt);
begin
	ReadData(Buffer,Count);
end;

procedure TAMDStM.ReadBufferData(var Buffer:UInt64);
begin
	ReadData(Buffer);
end;

procedure TAMDStM.ReadBufferData(var Buffer:UInt64;Count:NativeInt);
begin
	ReadData(Buffer,Count);
end;

procedure TAMDStM.ReadBufferData(var Buffer:Single);
begin
	ReadData(Buffer);
end;

procedure TAMDStM.ReadBufferData(var Buffer:Single;Count:NativeInt);
begin
	ReadData(Buffer,Count);
end;

procedure TAMDStM.ReadBufferData(var Buffer:Double);
begin
	ReadData(Buffer);
end;

procedure TAMDStM.ReadBufferData(var Buffer:Double;Count:NativeInt);
begin
	ReadData(Buffer,Count);
end;

procedure TAMDStM.ReadBufferData(var Buffer:Extended);
begin
	ReadData(Buffer);
end;

procedure TAMDStM.ReadBufferData(var Buffer:Extended;Count:NativeInt);
begin
	ReadData(Buffer,Count);
end;

procedure TAMDStM.ReadBufferData(var Buffer:TExtended80Rec);
begin
	ReadData(Buffer);
end;

procedure TAMDStM.ReadBufferData(var Buffer:TExtended80Rec;Count:NativeInt);
begin
	ReadData(Buffer,Count);
end;

procedure TAMDStM.WriteBuffer(const Buffer;Count:NativeInt);
var
	LTotalCount,LWrittenCount:NativeInt;
begin
	{ Perform a write directly. Most of the time this will succeed
		without the need to go into the WHILE loop. }
	LTotalCount:=Write(Buffer,Count);
	{ Check if there was an error }
	while (LTotalCount<Count) do begin
		{ Try to write a contiguous block of <Count> size }
		LWrittenCount:=Write(PByte(PByte(@Buffer)+LTotalCount)^,(Count-LTotalCount));
		{ Check if we written something and decrease the number of bytes left to write }
		if LWrittenCount>0 then Inc(LTotalCount,LWrittenCount);
	end
end;

procedure TAMDStM.WriteBuffer(const Buffer:TBytes;Count:NativeInt);
begin
	WriteBuffer(Buffer,0,Count);
end;

procedure TAMDStM.WriteBuffer(const Buffer:TBytes;Offset,Count:NativeInt);
var
	LTotalCount,LWrittenCount:NativeInt;
begin
	{ Perform a write directly. Most of the time this will succeed
		without the need to go into the WHILE loop. }
	LTotalCount:=Write(Buffer,Offset,Count);
	{ Check if there was an error }
	while (LTotalCount<Count) do begin
		{ Try to write a contiguous block of <Count> size }
		LWrittenCount:=Write(Buffer,Offset+LTotalCount,(Count-LTotalCount));
		{ Check if we written something and decrease the number of bytes left to write }
		if LWrittenCount>0 then Inc(LTotalCount,LWrittenCount);
	end;
end;

procedure TAMDStM.WriteBufferData(var Buffer:Integer;Count:NativeInt);
var
	C:NativeInt;
begin
	C:=Count;
	if C>4 then C:=4;
	Write(Buffer,C);
	if C<Count then Skip(Count-C);
end;

function TAMDStM.CopyFrom(const Source:TStream;Count:Int64;BufferSize:Integer):Int64;
var
	N:Integer;
	Buffer:TBytes;
	AdjustSize:boolean;
	CurPos:Int64;
	CurSize:Int64;
	NewSize:Int64;
begin
	ShowMessage('CopyFrom START');
	if BufferSize<=0 then exit;
	if Count<=0 then begin
		Source.Position:=0;
		Count:=Source.Size;
	end;
	if Count<0 then begin
		Result:=0;
		SetLength(Buffer,BufferSize);
		while True do begin
			N:=Source.Read(Buffer,BufferSize);
			if N=0 then Break;
			WriteBuffer(Buffer,N);
			Inc(Result,N);
		end;
	end else begin
		Result:=Count;
		if Count<BufferSize then BufferSize:=Count;
		SetLength(Buffer,BufferSize);
		AdjustSize:=False;
		try
			while Count<>0 do begin
				if Count>BufferSize then N:=BufferSize
				else N:=Count;
				Source.ReadBuffer(Buffer,N);
				WriteBuffer(Buffer,N);
				Dec(Count,N);
			end;
		except
			if AdjustSize then Size:=Position;
			raise;
		end;
	end;
	ShowMessage('CopyFrom END');
end;

function TAMDStM.ReadComponent(const Instance:TComponent):TComponent;
var
	Reader:TReader;
begin
	ShowMessage('ReadComponent START');
	Reader:=TReader.Create(Self,4096);
	try Result:=Reader.ReadRootComponent(Instance);
	finally Reader.FREE;
	end;
	ShowMessage('ReadComponent END');
end;

function TAMDStM.ReadComponentRes(const Instance:TComponent):TComponent;
begin
	ReadResHeader;
	Result:=ReadComponent(Instance);
end;

procedure TAMDStM.WriteComponent(const Instance:TComponent);
begin
	WriteDescendent(Instance,nil);
end;

procedure TAMDStM.WriteComponentRes(const ResName:string;const Instance:TComponent);
begin
	WriteDescendentRes(ResName,Instance,nil);
end;

procedure TAMDStM.WriteDescendent(const Instance,Ancestor:TComponent);
var
	Writer:TWriter;
begin
	ShowMessage('WriteDescendent START');
	Writer:=TWriter.Create(Self,4096);
	try Writer.WriteDescendent(Instance,Ancestor);
	finally Writer.FREE;
	end;
	ShowMessage('WriteDescendent END');
end;

procedure TAMDStM.WriteDescendentRes(const ResName:string;const Instance,Ancestor:TComponent);
var
	FixupInfo:Integer;
begin
	ShowMessage('WriteDescendentRes START');
	WriteResourceHeader(ResName,FixupInfo);
	WriteDescendent(Instance,Ancestor);
	FixupResourceHeader(FixupInfo);
	ShowMessage('WriteDescendentRes END');
end;

const
	Dummy32bitResHeader: array [0..31] of Byte=($00,$00,$00,$00,$20,$00,$00,$00,$FF,$FF,$00,$00,$FF,$FF,$00,$00,$00,$00,
		$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00);

procedure TAMDStM.WriteResourceHeader(const ResName:string;out FixupInfo:Integer);
var
	L,HeaderSize:Integer;
	NameBytes:TBytes;
	Header:TBytes; // array[0..255] of Byte;
	UpcaseResName:string;
begin
	ShowMessage('WriteResourceHeader START');
	UpcaseResName:=AnsiUpperCase(ResName);
	NameBytes:=TEncoding.UTF8.GetBytes(UpcaseResName);
	SetLength(Header,255);
	if Length(NameBytes)>Length(ResName) then begin
		NameBytes:=TEncoding.Unicode.GetBytes(UpcaseResName);
		L:=Length(NameBytes);
		if L div 2>63 then L:=63*2;
		SetLength(NameBytes,L+2);
		PWord(@NameBytes[L])^:=0;
		WriteBuffer(Dummy32bitResHeader,Length(Dummy32bitResHeader));

		FixupInfo:=-(Position+4);
		PInteger(@Header[0])^:=0;
		PInteger(@Header[4])^:=12+L+2+16;
		PInteger(@Header[8])^:=$000AFFFF;
		L:=12+Length(NameBytes);
		Move(NameBytes[0],Header[12],Length(NameBytes));
		PInteger(@Header[L])^:=0; // Data Version
		PWord(@Header[L+4])^:=0; // MemoryFlags
		PWord(@Header[L+6])^:=$0409; // LangID - for now just use US as the language ID
		PInteger(@Header[L+8])^:=0; // Version
		PInteger(@Header[L+12])^:=0; // Characteristics
		WriteBuffer(Header,L+16);
	end else begin
		Header[0]:=$FF;
		Word((@Header[1])^):=10;
		L:=Length(NameBytes);
		if L>63 then L:=64;
		SetLength(NameBytes,L+1);
		NameBytes[L]:=0;
		Move(NameBytes[0],Header[3],Length(NameBytes));
		HeaderSize:=Length(NameBytes)+9;
		Word((@Header[HeaderSize-6])^):=$1030;
		Integer((@Header[HeaderSize-4])^):=0;
		WriteBuffer(Header,HeaderSize);
		FixupInfo:=Position;
	end;
	ShowMessage('WriteResourceHeader END');
end;

procedure TAMDStM.FixupResourceHeader(FixupInfo:Integer);
var
	ImageSize,HeaderSize:Int32;
begin
	ShowMessage('FixupResourceHeader START');
	if FixupInfo<0 then begin
		ImageSize:=Position-(-FixupInfo);
		Position:=-FixupInfo;
		ReadBuffer(HeaderSize,SizeOf(HeaderSize));
		ImageSize:=ImageSize-HeaderSize+4;
		Position:=-FixupInfo-4;
		WriteBuffer(ImageSize,SizeOf(ImageSize));
		Position:=-FixupInfo+ImageSize+HeaderSize-4;
	end else begin
		ImageSize:=Position-FixupInfo;
		Position:=FixupInfo-4;
		WriteBuffer(ImageSize,SizeOf(ImageSize));
		Position:=FixupInfo+ImageSize;
	end;
	ShowMessage('FixupResourceHeader END');
end;

type
	TUInt32Helper=record helper for UInt32
	protected
		function GetBytes(Index:Cardinal):UInt8;
		function GetWords(Index:Cardinal):UInt16;
		procedure SetBytes(Index:Cardinal;const Value:UInt8);
		procedure SetWords(Index:Cardinal;const Value:UInt16);

	public
		function ToBytes:TBytes;
		function FromBytes(T:TBytes;Offset:Integer=0):UInt32;

		property Bytes[Index:Cardinal]:UInt8 read GetBytes write SetBytes;
		property Words[Index:Cardinal]:UInt16 read GetWords write SetWords;
	end;

function TUInt32Helper.GetBytes(Index:Cardinal):UInt8;
begin
	case Index of
		0:Result:=Self and $FF;
		1:Result:=(Self shr 8)and $FF;
		2:Result:=(Self shr 16)and $FF;
		3:Result:=(Self shr 24)and $FF;
	end;
end;

function TUInt32Helper.GetWords(Index:Cardinal):UInt16;
begin
	case Index of
		0:Result:=Self and $FFFF;
		1:Result:=(Self shr 16)and $FFFF;
	end;
end;

procedure TUInt32Helper.SetBytes(Index:Cardinal;const Value:UInt8);
begin
	case Index of
		0:Self:=(Self and $FFFFFF00)or Value;
		1:Self:=(Self and $FFFF00FF)or(Value shl 8);
		2:Self:=(Self and $FF00FFFF)or(Value shl 16);
		3:Self:=(Self and $00FFFFFF)or(Value shl 24);
	end;
end;

procedure TUInt32Helper.SetWords(Index:Cardinal;const Value:UInt16);
begin
	case Index of
		0:Self:=(Self and $FFFF0000)or Value;
		1:Self:=(Self and $0000FFFF)or(Value shl 16);
	end;
end;

function TUInt32Helper.ToBytes:TBytes;
begin
	SetLength(Result,4);
	Result[0]:=Self and $FF;
	Result[1]:=(Self shr 8)and $FF;
	Result[2]:=(Self shr 16)and $FF;
	Result[3]:=(Self shr 24)and $FF;
end;

function TUInt32Helper.FromBytes(T:TBytes;Offset:Integer):UInt32;
begin
	Self:=0;
	if Length(T)>Offset then Self:=Self or T[Offset];
	if Length(T)>Offset+1 then Self:=Self or(T[Offset+1] shl 8);
	if Length(T)>Offset+2 then Self:=Self or(T[Offset+2] shl 16);
	if Length(T)>Offset+3 then Self:=Self or(T[Offset+3] shl 24);
	Result:=Self;
end;

procedure TAMDStM.ReadResHeader;
var
	C,ReadCount:Cardinal;
	Header:TBytes;
begin
	ShowMessage('ReadResHeader START');
	SetLength(Header,256);
	FillChar(Header[0],Length(Header),0);
	ReadCount:=Read(Header,0,Length(Header)-1);
	if (Integer(ReadCount)>Length(Dummy32bitResHeader))and CompareMem(@Dummy32bitResHeader,@Header[0],
		Length(Dummy32bitResHeader)) then begin
		Seek(Length(Dummy32bitResHeader),soBeginning);
		ReadCount:=Read(Header,0,Length(Header)-1);
		C:=0;
		if C.FromBytes(Header,8)=$000AFFFF then begin
			C.FromBytes(Header,4);
			Seek(Int64(C)-ReadCount,soCurrent);
		end;
	end else if (Header[0]=$FF)and(Header[1]=10)and(Header[2]=0) then begin
		C:=3;
		while Header[C]<>0 do Inc(C);
		Seek(Int64(C)-3+10-ReadCount,soCurrent)
	end;
	ShowMessage('ReadResHeader END');
end;

var
	oFact:TFDFactory;

initialization

oFact:=TFDMultyInstanceFactory.Create(TFDBinStorage,IFDStanStorage,'BIN;.FDS;.FDB;.BIN;.DAT;');

finalization

FDReleaseFactory(oFact);

end.
