unit DRAGOBJ;

/// /////////////////////////////////////////////////////////////////////////////
// Test of drag / drop from the OS to determine the drop type
/// /////////////////////////////////////////////////////////////////////////////
interface

/// /////////////////////////////////////////////////////////////////////////////
// Include units
/// /////////////////////////////////////////////////////////////////////////////
uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  System.Win.ComObj,
  Winapi.ActiveX,
  Winapi.ShlObj,
  Vcl.AxCtrls,
  Vcl.ExtCtrls,
  Winapi.ShellAPI,
  Vcl.clipbrd,
  Vcl.StdCtrls,
  Vcl.Themes;

/// /////////////////////////////////////////////////////////////////////////////
// Custom drop target helper
/// /////////////////////////////////////////////////////////////////////////////
const
  SID_IDropTargetHelper='{4657278B-411B-11D2-839A-00C04FD918D0}';
  IID_IDropTargetHelper:TGUID=(D1:$4657278B;D2:$411B;D3:$11D2;D4:($83,$9A,$00,$C0,$4F,$D9,$18,$D0));
  CLSID_DragDropHelper:TGUID=(D1:$4657278A;D2:$411B;D3:$11D2;D4:($83,$9A,$00,$C0,$4F,$D9,$18,$D0));

  IID_IDragSourceHelper:TGUID=(D1:$DE5BF786;D2:$477A;D3:$11D2;D4:($83,$9D,$00,$C0,$4F,$D9,$18,$D0));
  IID_IDropTarget:TGUID=(D1:$00000122;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));

  /// /////////////////////////////////////////////////////////////////////////////
  // IDropTargetHelper
  /// /////////////////////////////////////////////////////////////////////////////
type
  IDropTargetHelper=interface(IUnknown)
    [SID_IDropTargetHelper]
    function DragEnter(hwndTarget:HWND;pDataObject:IDataObject;var ppt:TPoint;dwEffect:Integer)
      :HResult;stdcall;
    function DragLeave:HResult;stdcall;
    function DragOver(var ppt:TPoint;dwEffect:Integer):HResult;stdcall;
    function Drop(pDataObject:IDataObject;var ppt:TPoint;dwEffect:Integer):HResult;stdcall;
    function Show(fShow:Boolean):HResult;stdcall;
  end;

  IDragDrop=interface
    function DropAllowed(const FileNames:string):Boolean;
    procedure Drop(const FileNames:string);
  end;

  /// /////////////////////////////////////////////////////////////////////////////
  // TForm1   TWinControl,IDispatch,IDropSource,IDropTarget
  /// /////////////////////////////////////////////////////////////////////////////
type

  TAMZ=class(TWinControl,IDispatch,IDropSource,IDropTarget)
    // procedures
  private
    // Private declarations
    fOwner:TWinControl;
    FDragHelp:IDropTargetHelper;
    FDragDrop:IDragDrop;
    FDropPath:String;
    FAcceptDrop:Boolean;
    FOleInit:Boolean;
    procedure SetEffect(var dwEffect:Integer);
    function GetFileNames(dataObj:IDataObject):string;
    function GetFormatEtc(cfFormat:TClipFormat;ptd:PDVTargetDevice;dwAspect:Longint;lindex:Longint;
      tymed:Longint):TFormatEtc;
    procedure SaveFileFromMemory(FileDesc:TFileDescriptor;Storage:TStgMedium);
    procedure SaveFileFromName(FileDesc:TFileDescriptor;Storage:TStgMedium);
    procedure SaveFileFromStream(FileDesc:TFileDescriptor;Storage:TStgMedium);
    procedure SaveFileFromStorage(FileDesc:TFileDescriptor;Storage:TStgMedium);
  protected
    // Protected declarations
    function DragEnter(const dataObj:IDataObject;grfKeyState:Longint;pt:TPoint;var dwEffect:Longint)
      :HResult;stdcall;
    function DragOver(grfKeyState:Longint;pt:TPoint;var dwEffect:Longint):HResult;
      reintroduce;stdcall;
    function DragLeave:HResult;stdcall;
    function Drop(const dataObj:IDataObject;grfKeyState:Longint;pt:TPoint;var dwEffect:Longint)
      :HResult;stdcall;
    function GiveFeedback(Effect:Integer):HResult;stdcall;
    function QueryContinueDrag(EscapePressed:BOOL;KeyState:Integer):HResult;stdcall;
  public
    constructor Create(AOwner:TWinControl);
    destructor Destroy;
    // Public declarations
    property DropPath:String read FDropPath write FDropPath;
  end;

  /// /////////////////////////////////////////////////////////////////////////////
  // Global clipboard format variables
  /// /////////////////////////////////////////////////////////////////////////////
var
  CF_IDLIST:UINT=0;
  CF_IDLISTOFS:UINT=0;
  CF_NETRES:UINT=0;
  CF_FILEDESCA:UINT=0;
  CF_FILEDESCW:UINT=0;
  CF_FILECONTENTS:UINT=0;
  CF_FILENAMEA:UINT=0;
  CF_FILENAMEW:UINT=0;
  CF_FILEMAPA:UINT=0;
  CF_FILEMAPW:UINT=0;
  CF_SHELLURL:UINT=0;

  /// /////////////////////////////////////////////////////////////////////////////
  // Global form variable
  /// /////////////////////////////////////////////////////////////////////////////

implementation

/// / TForm1 ////////////////////////////////////////////////////////////////////

constructor TAMZ.Create(AOwner:TWinControl);
begin
  inherited Create(AOwner);
  fOwner:=AOwner;
  // Initialize the OLE library
  FOleInit:=Succeeded(OleInitialize(nil));
  // Resource protection
  try
    // Make sure drag helper is nilled
    FDragHelp:=nil;
    // Set default drop path
    FDropPath:=IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
  finally
    // Register the window for drag drop operations
      OleCheck(RegisterDragDrop(AOwner.Handle,Self));
  end;
  ParentWindow:=AOwner.Handle;
  DragAcceptFiles(AOwner.Handle,true);
end;

destructor TAMZ.Destroy;
begin
  // Resource protection
  try
    // Revoke from drag drop operations
    RevokeDragDrop(fOwner.Handle);
    DragAcceptFiles(fOwner.Handle,False);
  finally
    // Uninitialize the OLE library
    if FOleInit then OleUninitialize();
  end;
  inherited Destroy;
end;

procedure TAMZ.SetEffect(var dwEffect:Integer);
begin
  if FAcceptDrop then begin
    dwEffect:=DROPEFFECT_COPY;
  end else begin
    dwEffect:=DROPEFFECT_NONE;
  end;
end;

function TAMZ.DragEnter(const dataObj:IDataObject;grfKeyState:Longint;pt:TPoint;
  var dwEffect:Longint):HResult;
var
  pvEnum:IEnumFORMATETC;
  lpFormat:TFormatEtc;
  dwFetch:Integer;
begin
  result:=S_FALSE;
  try
    FAcceptDrop:=False;
    FDragHelp:=nil;
    if Succeeded(dataObj.EnumFormatEtc(DATADIR_GET,pvEnum)) then begin
      try
        while Succeeded(pvEnum.Next(1,lpFormat,@dwFetch))and(dwFetch=1) do begin
          // Check for formats that we can handle
          if (lpFormat.cfFormat=CF_HDROP) then begin // CF_FILEDESCA
            result:=S_OK;
            break;
          end;
        end;
      finally pvEnum:=nil;
      end;
    end;
    if (result=S_OK)and(Trim(GetFileNames(dataObj))<>'') then begin
      FAcceptDrop:=true;
      SetEffect(dwEffect);
    end;
    // Create drag helper
    if Succeeded(CoCreateInstance(CLSID_DragDropHelper,nil,CLSCTX_INPROC_SERVER,
      IID_IDropTargetHelper,FDragHelp)) then begin
      FDragHelp.DragEnter(Handle,dataObj,pt,dwEffect);
    end;

  finally result:=S_OK;
  end;
end;

function TAMZ.DragOver(grfKeyState:Longint;pt:TPoint;var dwEffect:Longint):HResult;
var
  Shift:TShiftState;
begin

  Shift:=KeysToShiftState(grfKeyState);
  if FAcceptDrop then begin
    if ssCtrl in Shift then begin
      // copy or link
      if ssShift in Shift then begin
        // link
        dwEffect:=DROPEFFECT_LINK;
      end else begin
        // copy
        dwEffect:=DROPEFFECT_COPY;
      end;
    end else begin
      // move, link or default
      if ssShift in Shift then begin
        // move
        dwEffect:=DROPEFFECT_MOVE;
      end else begin
        // link or default
        if ssAlt in Shift then begin
          // link
          dwEffect:=DROPEFFECT_LINK;
        end else begin
          SetEffect(dwEffect);
        end;
      end;
    end;
  end else begin
    SetEffect(dwEffect);
  end;
  if Assigned(FDragHelp) then FDragHelp.DragOver(pt,dwEffect);
  result:=S_OK;
end;

function TAMZ.DragLeave:HResult;
begin
  if Assigned(FDragHelp) then FDragHelp.DragLeave;
  FDragHelp:=nil;
  FAcceptDrop:=False;
  result:=S_OK;
end;

function TAMZ.Drop(const dataObj:IDataObject;grfKeyState:Longint;pt:TPoint;
  var dwEffect:Longint):HResult;
var
  lpDesc:PFileGroupDescriptor;
  lpfDesc:TFormatEtc;
  lpfContents:TFormatEtc;
  lpStgDesc:TStgMedium;
  lpStgContent:TStgMedium;
  dwIndex:Integer;
  FileNames:TArray<string>;
begin
  try
    if Assigned(FDragHelp) then FDragHelp.DragLeave;
    if FAcceptDrop then begin
      // Set formats for the query
      lpfDesc:=GetFormatEtc(CF_FILEDESCA,nil,DVASPECT_CONTENT,-1,TYMED_HGLOBAL);
      lpfContents:=GetFormatEtc(CF_FILECONTENTS,nil,DVASPECT_CONTENT,-1,
        TYMED_HGLOBAL or TYMED_FILE or TYMED_ISTREAM or TYMED_ISTORAGE);
      // Query for the file descriptor and content formats
      if Succeeded(dataObj.QueryGetData(lpfDesc))and Succeeded(dataObj.QueryGetData(lpfContents))
      then begin
        // Get the data for the descriptor
        if Succeeded(dataObj.GetData(lpfDesc,lpStgDesc)) then begin
          // Resource protection
          try
            // Global lock the memory
            lpDesc:=GlobalLock(lpStgDesc.hGlobal);
            // Resuorce protection
            try
              // Set count and starting enumerator
              dwIndex:=0;
              // Enumerate the files that are being dropped
              while (dwIndex<Integer(lpDesc^.cItems)) do begin
                // Set file content index
                lpfContents.lindex:=dwIndex;
                // Attempt to get the file contents as IStream
                if Succeeded(dataObj.GetData(lpfContents,lpStgContent)) then begin
                  // Resource protection
                  try
                    // Handle the tymed type
                    case lpStgContent.tymed of
                      TYMED_HGLOBAL:SaveFileFromMemory(lpDesc^.fgd[dwIndex],lpStgContent);
                      TYMED_FILE:SaveFileFromName(lpDesc^.fgd[dwIndex],lpStgContent);
                      TYMED_ISTREAM:SaveFileFromStream(lpDesc^.fgd[dwIndex],lpStgContent);
                      TYMED_ISTORAGE:SaveFileFromStorage(lpDesc^.fgd[dwIndex],lpStgContent);
                    end
                  finally
                    // Release the storage medium
                      ReleaseStgMedium(lpStgContent);
                  end;
                end;
                // Inc index
                Inc(dwIndex);
              end;
            finally
              // Unlock memory
                GlobalUnlock(lpStgDesc.hGlobal);
            end;
          finally
            // Release the storage medium
              ReleaseStgMedium(lpStgDesc);
          end;
        end;
      end;
    end;
  finally
    FAcceptDrop:=False;
    SetEffect(dwEffect);
    result:=S_OK;
    ShowMessage(GetFileNames(dataObj));
  end;
end;

function TAMZ.GiveFeedback(Effect:Integer):HResult;
begin
  result:=DRAGDROP_S_USEDEFAULTCURSORS;
end;

// ----------------------------------------------------------------------------------------------------------------------

function TAMZ.QueryContinueDrag(EscapePressed:BOOL;KeyState:Integer):HResult;
var
  RButton,LButton:Boolean;
begin
  LButton:=(KeyState and MK_LBUTTON)<>0;
  RButton:=(KeyState and MK_RBUTTON)<>0;
  // Drag'n drop canceled by pressing both mouse buttons or Esc?
  if (LButton and RButton)or EscapePressed then begin
    result:=DRAGDROP_S_CANCEL
    // Drag'n drop finished?
  end else if not(LButton or RButton) then begin
    result:=DRAGDROP_S_DROP
  end else begin
    result:=S_OK;
  end;
end;

procedure TAMZ.SaveFileFromMemory(FileDesc:TFileDescriptor;Storage:TStgMedium);
var
  strmFile:TFileStream;
  ulSize:ULARGE_INTEGER;
  lpszData:PChar;
begin
  // Create destination file
  strmFile:=TFileStream.Create(IncludeTrailingPathDelimiter(FDropPath)+FileDesc.cFileName,fmCreate);
  // Resource protection
  try
    // Lock the global memory
    lpszData:=GlobalLock(Storage.hGlobal);
    // Resource protection
    try
      // Get total size to write
      ulSize.LowPart:=FileDesc.nFileSizeLow;
      ulSize.HighPart:=FileDesc.nFileSizeHigh;
      // Write memory to stream
      strmFile.Write(lpszData^,ulSize.QuadPart);
    finally
      // Unlock memory
        GlobalUnlock(Storage.hGlobal);
    end;
  finally
    // Free file stream
      strmFile.Free;
  end;
end;

procedure TAMZ.SaveFileFromName(FileDesc:TFileDescriptor;Storage:TStgMedium);
var
  strmFile:TFileStream;
  strmSource:TFileStream;
begin
  // Create destination file
  strmFile:=TFileStream.Create(IncludeTrailingPathDelimiter(FDropPath)+FileDesc.cFileName,fmCreate);
  // Resource protection
  try
    // Create stream on source file
    strmSource:=TFileStream.Create(String(WideString(Storage.lpszFileName)),
      fmOpenRead or fmShareDenyNone);
    // Resource protection
    try
      // Copy contents from source stream
        strmFile.CopyFrom(strmSource,0);
    finally
      // Free source stream
        strmSource.Free;
    end;
  finally
    // Free file stream
      strmFile.Free;
  end;
end;

procedure TAMZ.SaveFileFromStream(FileDesc:TFileDescriptor;Storage:TStgMedium);
var
  strmFile:TFileStream;
  strmOle:TOleStream;
begin
  // Create destination file
  strmFile:=TFileStream.Create(IncludeTrailingPathDelimiter(FDropPath)+FileDesc.cFileName,fmCreate);
  // Resource protection
  try
    // Create OLE stream wrapper around IStream
    strmOle:=TOleStream.Create(IStream(Storage.stm));
    // Resource protection
    try
      // Copy contents from OLE stream
        strmFile.CopyFrom(strmOle,0);
    finally
      // Free OLE stream
        strmOle.Free;
    end;
  finally
    // Free file stream
      strmFile.Free;
  end;
end;

procedure TAMZ.SaveFileFromStorage(FileDesc:TFileDescriptor;Storage:TStgMedium);
var
  lpwszFileName: Array [0..MAX_PATH] of WideChar;
  pvStgDest:IStorage;
begin
  // Convert filename to wide char
  StringToWideChar(IncludeTrailingPathDelimiter(FDropPath)+FileDesc.cFileName,
    @lpwszFileName,MAX_PATH);
  // Create destination storage
  if Succeeded(StgCreateDocfile(@lpwszFileName,STGM_READWRITE or STGM_SHARE_EXCLUSIVE or
    STGM_DIRECT or STGM_CREATE,0,pvStgDest)) then begin
    // Resource protection
    try
      // Copy dropped storage to file based storage
      if Succeeded(IStorage(Storage.stg).CopyTo(0,nil,nil,pvStgDest)) then begin
        // Commit the destination data
        pvStgDest.Commit(STGC_DEFAULT);
      end;
    finally
      // Release the interface
        pvStgDest:=nil;
    end;
  end;
end;

function TAMZ.GetFormatEtc(cfFormat:TClipFormat;ptd:PDVTargetDevice;dwAspect:Longint;lindex:Longint;
  tymed:Longint):TFormatEtc;
begin
  // Set format etc fields
  result.cfFormat:=cfFormat;
  result.ptd:=ptd;
  result.dwAspect:=dwAspect;
  result.lindex:=lindex;
  result.tymed:=tymed;
end;

function TAMZ.GetFileNames(dataObj:IDataObject):string;
var
  DFC,FNL,I:Integer;
  formatetcIn:TFormatEtc;
  medium:TStgMedium;
  DH:HDROP;
  FNames:string;
  DP:TPoint;
begin
  result:='';
  formatetcIn.cfFormat:=CF_HDROP;
  formatetcIn.ptd:=nil;
  formatetcIn.dwAspect:=DVASPECT_CONTENT;
  formatetcIn.lindex:=-1;
  formatetcIn.tymed:=TYMED_HGLOBAL;
  if dataObj.GetData(formatetcIn,medium)=S_OK then begin
    DH:=HDROP(medium.hGlobal);
    DFC:=DragQueryFile(DH,$FFFFFFFF,nil,0);
    DragQueryPoint(DH,DP);
    for I:=0 to Pred(DFC) do begin
      FNL:=DragQueryFile(DH,I,nil,0);
      SetLength(FNames,FNL);
      DragQueryFile(DH,I,PChar(FNames),FNL+1);
      result:=result+ExtractFileName(FNames)+#13;
    end;
    result:=Trim(result);
  end;
end;

initialization

// Register the clipboard formats that we can handle from external sources
CF_IDLIST:=RegisterClipboardFormat(CFSTR_SHELLIDLIST);
CF_IDLISTOFS:=RegisterClipboardFormat(CFSTR_SHELLIDLISTOFFSET);
CF_NETRES:=RegisterClipboardFormat(CFSTR_NETRESOURCES);
CF_FILEDESCA:=RegisterClipboardFormat(CFSTR_FILEDESCRIPTORA);
CF_FILEDESCW:=RegisterClipboardFormat(CFSTR_FILEDESCRIPTORW);
CF_FILECONTENTS:=RegisterClipboardFormat(CFSTR_FILECONTENTS);
CF_FILENAMEA:=RegisterClipboardFormat(CFSTR_FILENAMEA);
CF_FILENAMEW:=RegisterClipboardFormat(CFSTR_FILENAMEW);
CF_FILEMAPA:=RegisterClipboardFormat(CFSTR_FILENAMEMAPA);
CF_FILEMAPW:=RegisterClipboardFormat(CFSTR_FILENAMEMAPW);
CF_SHELLURL:=RegisterClipboardFormat(CFSTR_SHELLURL);

finalization

end.
