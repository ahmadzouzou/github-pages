unit AMD.DropCombo;
// -----------------------------------------------------------------------------
// Project:         New Drag and Drop Component Suite
// Module:          DragDrop
// Description:     Implements base classes and utility functions.
// Version:         5.7
// Date:            28-FEB-2015
// Target:          Win32, Win64, Delphi 6-XE7
// Authors:         Anders Melander, anders@melander.dk, http://melander.dk
// Latest Version   https://github.com/landrix/The-new-Drag-and-Drop-Component-Suite-for-Delphi
// Copyright        © 1997-1999 Angus Johnson & Anders Melander
// © 2000-2010 Anders Melander
// © 2011-2015 Sven Harazim
// -----------------------------------------------------------------------------

interface

uses
{$IF CompilerVersion >= 23.0}
	System.Classes,
	WinApi.ActiveX,
	Vcl.Graphics,
	Vcl.Dialogs,
	System.SysUtils,
{$ELSE}
	Classes,
	ActiveX,
	Graphics,
{$IFEND}
	AMD.DragDrop,
	AMD.DropTarget,
	AMD.DropSource,
	AMD.DragDropFormats,
	AMD.DragDropInternet,
	AMD.DragDropGraphics,
	AMD.DragDropFile,
	AMD.DragDropText;

type
	// Note: mfCustom is used to support DataFormatAdapters.
	TComboFormatType=(mfText,mfFile,mfURL,mfBitmap,mfMetaFile,mfData,mfStream,mfStorage,mfCustom);
	TComboFormatTypes=set of TComboFormatType;

const
	AllComboFormats=[mfText,mfFile,mfURL,mfBitmap,mfMetaFile,mfData,mfStream,mfStorage,mfCustom];

{$HPPEMIT '// Work around for stupid #define in wingdi.h of "GetMetaFile" as "GetMetaFileA".'}
{$HPPEMIT '#pragma option push'}
{$HPPEMIT '#pragma warn -8017'}
{$HPPEMIT '#define GetMetaFile  GetMetaFile'}
{$HPPEMIT '#pragma option pop'}

type
	/// /////////////////////////////////////////////////////////////////////////////
	//
	// TDropComboTarget
	//
	/// /////////////////////////////////////////////////////////////////////////////
	TDropComboTarget=class(TCustomDropMultiTarget)
	private
		FFileFormat:TFileDataFormat;
		FFileMapFormat:TFileMapDataFormat;
		FURLFormat:TURLDataFormat;
		FBitmapFormat:TBitmapDataFormat;
		FMetaFileFormat:TMetaFileDataFormat;
		FTextFormat:TTextDataFormat;
		// FDataFormat:TDataStreamDataFormat;
		FFormats:TComboFormatTypes;
		FFdfiles:TStringList;
		FFileStream:TVirtualFileStreamDataFormat;
		FFileStorage:TOutlookDataFormat;
	protected
		procedure DoAcceptFormat(const DataFormat:TCustomDataFormat;var Accept:boolean);override;
		function GetFiles:TUnicodeStrings;
		function GetTitle:string;
		function GetURL:AnsiString;
		function GetBitmap:TBitmap;
		function GetMetaFile:TMetaFile;
		function GetText:string;
		function GetFileMaps:TUnicodeStrings;
		// function GetStreams:TStreamList;
		function FDGetFiles:TStringList;
		procedure FDSetFiles(AFiles:TStringList);
	public
		constructor Create(AOwner:TComponent);override;
		destructor Destroy;override;
		property Files:TUnicodeStrings read GetFiles;
		property FileMaps:TUnicodeStrings read GetFileMaps;
		property URL:AnsiString read GetURL;
		property Title:string read GetTitle;
		property Bitmap:TBitmap read GetBitmap;
		property MetaFile:TMetaFile read GetMetaFile;
		property Text:string read GetText;
		// property Data:TStreamList read GetStreams;
		property FdFiles:TStringList read FDGetFiles write FDSetFiles;
		property FileStream:TVirtualFileStreamDataFormat read FFileStream write FFileStream;
		property FileStorage:TOutlookDataFormat read FFileStorage write FFileStorage;
	published
		property OnAcceptFormat;
		property Formats:TComboFormatTypes read FFormats write FFormats default AllComboFormats;
		property OptimizedMove default True;
	end;

	TDropComboSource=class(TCustomDropMultiSource)
	private
		FFileFormat:TFileDataFormat;
		FFileMapFormat:TFileMapDataFormat;
		FURLFormat:TURLDataFormat;
		FBitmapFormat:TBitmapDataFormat;
		FMetaFileFormat:TMetaFileDataFormat;
		FTextFormat:TTextDataFormat;
		// FDataFormat:TDataStreamDataFormat;
		FFormats:TComboFormatTypes;
		FFdfiles:TStringList;
		FFileStream:TVirtualFileStreamDataFormat;
		FFileStorage:TOutlookDataFormat;
		FRFC:string;
	protected
		function GetFiles:TUnicodeStrings;
		function GetTitle:string;
		function GetURL:AnsiString;
		function GetBitmap:TBitmap;
		function GetMetaFile:TMetaFile;
		function GetText:string;
		function GetFileMaps:TUnicodeStrings;
		// function GetStreams:TStreamList;
		function FDGetFiles:TStringList;
		procedure SetFiles(AFiles:TUnicodeStrings);
		procedure SetTitle(Title:string);
		procedure SetURL(URL:AnsiString);
		procedure SetBitmap(Bitmap:TBitmap);
		procedure SetMetaFile(MetaFile:TMetaFile);
		procedure SetText(Text:string);
		procedure SetFileMaps(FileMaps:TUnicodeStrings);
		// procedure SetStreams(StreamList:TStreamList);
		procedure FDSetFiles(AFiles:TStringList);
	public
		constructor Create(AOwner:TComponent);override;
		destructor Destroy;override;
		property Files:TUnicodeStrings read GetFiles write SetFiles;
		property FileMaps:TUnicodeStrings read GetFileMaps write SetFileMaps;
		property URL:AnsiString read GetURL write SetURL;
		property Title:string read GetTitle write SetTitle;
		property Bitmap:TBitmap read GetBitmap write SetBitmap;
		property MetaFile:TMetaFile read GetMetaFile write SetMetaFile;
		property Text:string read GetText write SetText;
		// property Data:TStreamList read GetStreams write SetStreams;
		property FdFiles:TStringList read FDGetFiles write FDSetFiles;
		property FileStream:TVirtualFileStreamDataFormat read FFileStream write FFileStream;
		property FileStorage:TOutlookDataFormat read FFileStorage write FFileStorage;
		property RFC:string read FRFC write FRFC;
	published
		property Formats:TComboFormatTypes read FFormats write FFormats default AllComboFormats;
	end;

implementation

/// /////////////////////////////////////////////////////////////////////////////
//
// TDropComboTarget
//
/// /////////////////////////////////////////////////////////////////////////////
constructor TDropComboTarget.Create(AOwner:TComponent);
begin
	inherited Create(AOwner);
	OptimizedMove:=True;
	FFileFormat:=TFileDataFormat.Create(Self);
	FURLFormat:=TURLDataFormat.Create(Self);
	FBitmapFormat:=TBitmapDataFormat.Create(Self);
	FMetaFileFormat:=TMetaFileDataFormat.Create(Self);
	FTextFormat:=TTextDataFormat.Create(Self);
	FFileMapFormat:=TFileMapDataFormat.Create(Self);
	// FDataFormat:=TDataStreamDataFormat.Create(Self);
	FFormats:=AllComboFormats;
	FFdfiles:=TStringList.Create;
	FFileStream:=TVirtualFileStreamDataFormat.Create(Self);
	FFileStorage:=TOutlookDataFormat.Create(Self);
end;

destructor TDropComboTarget.Destroy;
begin
	FFdfiles.Free;
	inherited Destroy;
end;

procedure TDropComboTarget.DoAcceptFormat(const DataFormat:TCustomDataFormat;var Accept:boolean);
begin
	if (Accept) then begin
		if (DataFormat is TURLDataFormat) then Accept:=(mfURL in FFormats)
		else if (DataFormat is TBitmapDataFormat) then Accept:=(mfBitmap in FFormats)
		else if (DataFormat is TMetaFileDataFormat) then Accept:=(mfMetaFile in FFormats)
		else if (DataFormat is TTextDataFormat) then Accept:=(mfText in FFormats)
		else if (DataFormat is TStorageDataFormat) then Accept:=(mfStorage in FFormats)
		else if (DataFormat is TVirtualFileStreamDataFormat) then Accept:=(mfStream in FFormats)
		else if (DataFormat is TFileDataFormat)or(DataFormat is TFileMapDataFormat) then Accept:=(mfFile in FFormats)
		else Accept:=(mfCustom in FFormats)
	end;
	if (Accept) then inherited DoAcceptFormat(DataFormat,Accept);
end;

function TDropComboTarget.GetBitmap:TBitmap;
begin
	Result:=FBitmapFormat.Bitmap;
end;

function TDropComboTarget.FDGetFiles:TStringList;
begin
	Result:=FFdfiles;
end;

procedure TDropComboTarget.FDSetFiles(AFiles:TStringList);
begin
	FFdfiles.Assign(AFiles);
end;

function TDropComboTarget.GetFileMaps:TUnicodeStrings;
begin
	Result:=FFileMapFormat.FileMaps;
end;

function TDropComboTarget.GetFiles:TUnicodeStrings;
begin
	Result:=FFileFormat.Files;
end;

function TDropComboTarget.GetMetaFile:TMetaFile;
begin
	Result:=FMetaFileFormat.MetaFile;
end;

{ function TDropComboTarget.GetStreams:TStreamList;
	begin
	Result:=FDataFormat.Streams;
	end; }

function TDropComboTarget.GetText:string;
begin
	Result:=FTextFormat.Text;
end;

function TDropComboTarget.GetTitle:string;
begin
	Result:=FURLFormat.Title;
end;

function TDropComboTarget.GetURL:AnsiString;
begin
	Result:=FURLFormat.URL;
end;

/// /////////////////////////////////////////////////////////////////////////////
//
// TDropComboSource
//
/// /////////////////////////////////////////////////////////////////////////////

constructor TDropComboSource.Create(AOwner:TComponent);
begin
	inherited Create(AOwner);
	FFileFormat:=TFileDataFormat.Create(Self);
	FURLFormat:=TURLDataFormat.Create(Self);
	FBitmapFormat:=TBitmapDataFormat.Create(Self);
	FMetaFileFormat:=TMetaFileDataFormat.Create(Self);
	FTextFormat:=TTextDataFormat.Create(Self);
	FFileMapFormat:=TFileMapDataFormat.Create(Self);
	// FDataFormat:=TDataStreamDataFormat.Create(Self);
	FFormats:=AllComboFormats;
	FFdfiles:=TStringList.Create;
	FFileStream:=TVirtualFileStreamDataFormat.Create(Self);
	FFileStorage:=TOutlookDataFormat.Create(Self);
end;

destructor TDropComboSource.Destroy;
begin
	FFdfiles.Free;
	inherited Destroy;
end;

function TDropComboSource.GetBitmap:TBitmap;
begin
	Result:=FBitmapFormat.Bitmap;
end;

function TDropComboSource.FDGetFiles:TStringList;
begin
	Result:=FFdfiles;
end;

function TDropComboSource.GetFileMaps:TUnicodeStrings;
begin
	Result:=FFileMapFormat.FileMaps;
end;

function TDropComboSource.GetFiles:TUnicodeStrings;
begin
	Result:=FFileFormat.Files;
end;

function TDropComboSource.GetMetaFile:TMetaFile;
begin
	Result:=FMetaFileFormat.MetaFile;
end;

{ function TDropComboSource.GetStreams:TStreamList;
	begin
	Result:=FDataFormat.Streams;
	end; }

function TDropComboSource.GetText:string;
begin
	Result:=FTextFormat.Text;
end;

function TDropComboSource.GetTitle:string;
begin
	Result:=FURLFormat.Title;
end;

function TDropComboSource.GetURL:AnsiString;
begin
	Result:=FURLFormat.URL;
end;

procedure TDropComboSource.SetBitmap(Bitmap:TBitmap);
begin
	FBitmapFormat.Bitmap.Assign(Bitmap);
end;

procedure TDropComboSource.FDSetFiles(AFiles:TStringList);
begin
	FFdfiles.Assign(AFiles);
end;

procedure TDropComboSource.SetFileMaps(FileMaps:TUnicodeStrings);
begin
	FFileMapFormat.FileMaps.Assign(FileMaps);
end;

procedure TDropComboSource.SetFiles(AFiles:TUnicodeStrings);
begin
	FFileFormat.Files.Assign(AFiles);
end;

procedure TDropComboSource.SetMetaFile(MetaFile:TMetaFile);
begin
	FMetaFileFormat.MetaFile.Assign(MetaFile);
end;

{ procedure TDropComboSource.SetStreams(StreamList:TStreamList);
	begin
	FDataFormat.Streams.Assign(StreamList);
	end; }

procedure TDropComboSource.SetText(Text:string);
begin
	FTextFormat.Text:=Text;
end;

procedure TDropComboSource.SetTitle(Title:string);
begin
	FURLFormat.Title:=Title;
end;

procedure TDropComboSource.SetURL(URL:AnsiString);
begin
	FURLFormat.URL:=URL;
end;

end.
