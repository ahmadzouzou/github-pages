unit Unit2;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Winapi.ShlObj,
  ActiveX;

type
  TForm1=class(TForm)
    procedure FormCreate(Sender:TObject);
    procedure FormDestroy(Sender:TObject);
  private
    procedure OnNotifyEvent(var AMessage:TMessage);message WM_USER;
  end;

var
  Form1:TForm1;
  Hand:THandle;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender:TObject);
var
  Desktop:IShellFolder;
  pidl:PItemIdList;
  Path:String;
  Eaten,attr,Events,Sources:DWord;
  cnPIDL:TSHChangeNotifyEntry;
begin
  if Succeeded(SHGetDesktopFolder(Desktop))then begin
    Path:='D:\TEST';
    if Succeeded(Desktop.ParseDisplayName(0,nil,PWideChar(Path),Eaten,pidl,attr))then begin
      Caption:=Path;
      cnPIDL.pidl:=pidl;
      cnPIDL.fRecursive:=true;
      Sources:=SHCNRF_INTERRUPTLEVEL or SHCNRF_SHELLLEVEL or SHCNRF_NEWDELIVERY or
        SHCNRF_RECURSIVEINTERRUPT;
      Events:=SHCNE_FREESPACE;
      Hand:=SHChangeNotifyRegister(Handle,Sources,Events,WM_USER,1,cnPIDL);;
      CoTaskMemFree(pidl);
    end;
  end;
end;

procedure TForm1.FormDestroy(Sender:TObject);
begin
  SHChangeNotifyDeregister(Hand);
end;

procedure TForm1.OnNotifyEvent(var AMessage:TMessage);
begin
  if AMessage.Msg=WM_USER then SHOWMESSAGE(' x');
end;

end.
