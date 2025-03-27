unit DiskSpace;

interface

uses
  Windows,
  Messages,
  Classes,
  ShlObj;

type
  PLONG=^LONG;
  LONG=LongInt;
  TSpaceChangeEvent=procedure(Sender:TObject;const DiskFree,DiskTotal:Int64)of object;

  TDiskSpace=class
  strict private
    FDiskRoot:String;
    FDiskFree:Int64;
    FDiskTotal:Int64;
    FWndHandle:HWND;
    FNotifierID:ULONG;
    FOnSpaceChange:TSpaceChangeEvent;
  protected
    procedure WndProc(var Msg:TMessage);virtual;
    procedure DoSpaceChange(const DiskFree,DiskTotal:Int64);virtual;
  public
    constructor Create(Drive:Char);virtual;
    destructor Destroy;override;
    property DiskRoot:String read FDiskRoot;
    property DiskFree:Int64 read FDiskFree;
    property DiskTotal:Int64 read FDiskTotal;
    property OnSpaceChange:TSpaceChangeEvent read FOnSpaceChange write FOnSpaceChange;
  end;

implementation

const
  WM_SHELL_ITEM_NOTIFY=WM_USER+666;

  {TDiskSpace}
constructor TDiskSpace.Create(Drive:Char);
var
  NotifyEntry:TSHChangeNotifyEntry;
begin
  FDiskRoot:=Drive+':\';
  FWndHandle:=AllocateHWnd(WndProc);
  NotifyEntry.pidl:=ILCreateFromPath(PWideChar(FDiskRoot));
  try
    NotifyEntry.fRecursive:=true;
    FNotifierID:=SHChangeNotifyRegister(FWndHandle,SHCNRF_SHELLLEVEL or SHCNRF_INTERRUPTLEVEL or
      SHCNRF_RECURSIVEINTERRUPT,SHCNE_CREATE or SHCNE_DELETE or SHCNE_UPDATEITEM,
      WM_SHELL_ITEM_NOTIFY,1,NotifyEntry);
  finally
    ILFree(NotifyEntry.pidl);
  end;
end;

destructor TDiskSpace.Destroy;
begin
  if FNotifierID<>0 then SHChangeNotifyDeregister(FNotifierID);
  if FWndHandle<>0 then DeallocateHWnd(FWndHandle);
  inherited;
end;

procedure TDiskSpace.WndProc(var Msg:TMessage);
var
  NewFree:Int64;
  NewTotal:Int64;
begin
  if(Msg.Msg=WM_SHELL_ITEM_NOTIFY)then begin
    if GetDiskFreeSpaceEx(PChar(FDiskRoot),NewFree,NewTotal,nil)then begin
      if(FDiskFree<>NewFree)or(FDiskTotal<>NewTotal)then begin
        FDiskFree:=NewFree;
        FDiskTotal:=NewTotal;
        DoSpaceChange(FDiskFree,FDiskTotal);
      end;
    end else begin
      FDiskFree:=-1;
      FDiskTotal:=-1;
    end;
  end
  else Msg.Result:=DefWindowProc(FWndHandle,Msg.Msg,Msg.wParam,Msg.lParam);
end;

procedure TDiskSpace.DoSpaceChange(const DiskFree,DiskTotal:Int64);
begin
  if Assigned(FOnSpaceChange)then FOnSpaceChange(Self,DiskFree,DiskTotal);
end;

end.
{And a possible usage:

type
  TForm1=class(TForm)
    procedure FormCreate(Sender:TObject);
    procedure FormDestroy(Sender:TObject);
  private
    FDiskSpace:TDiskSpace;
    procedure DiskSpaceChange(Sender:TObject;const DiskFree,DiskTotal:Int64);
  end;

implementation

procedure TForm1.FormCreate(Sender:TObject);
begin
  FDiskSpace:=TDiskSpace.Create('C');
  FDiskSpace.OnSpaceChange:=DiskSpaceChange;
end;

procedure TForm1.FormDestroy(Sender:TObject);
begin
  FDiskSpace.Free;
end;

procedure TForm1.DiskSpaceChange(Sender:TObject;const DiskFree,DiskTotal:Int64);
begin
  Caption:=Format('%d/%d B',[DiskFree,DiskTotal]);
end; }
