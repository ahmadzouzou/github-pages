unit Vcl.TrayIco;

interface

uses
{$IF DEFINED(CLR)}
	System.ComponentModel.Design.Serialization,
{$ENDIF}
	Winapi.Messages,
	Winapi.Windows,
	System.SysUtils,
	System.Classes,
	System.Contnrs,
	System.Types,
	System.UITypes,
	Vcl.Controls,
	Vcl.Forms,
	Vcl.Menus,
	Vcl.Graphics,
	Vcl.StdCtrls,
	Vcl.GraphUtil,
	Vcl.ImgList,
	Vcl.Themes,
	Vcl.ExtCtrls,
	Winapi.ShellAPI;

type

	TTryIcon=class(TComponent)
	private
		class var RM_TaskbarCreated:DWORD;
	private
		FAnimate:Boolean;
		FBalloonHint:string;
		FBalloonTitle:string;
		FBalloonFlags:Cardinal;
		FIsClicked:Boolean;
		FCurrentIcon:TIcon;
{$IF DEFINED(CLR)}
		FData:TNotifyIconData;
{$ELSE}
		FData:PNotifyIconData;
{$ENDIF}
		FIcon:TIcon;
		FIconList:TCustomImageList;
		FPopupMenu:TPopupMenu;
		FTimer:TTimer;
		FHint:string;
		FIconIndex:Integer;
		FVisible:Boolean;
		FOnBalloonClick:TNotifyEvent;
		FOnClick:TNotifyEvent;
		FOnDblClick:TNotifyEvent;
		FOnMouseDown:TMouseEvent;
		FOnMouseMove:TMouseMoveEvent;
		FOnMouseUp:TMouseEvent;
		FOnAnimate:TNotifyEvent;
		function GetData:TNotifyIconData;
	protected
		procedure Notification(AComponent:TComponent;Operation:TOperation);override;
		procedure SetHint(const Value:string);
		function GetAnimateInterval:Cardinal;
		procedure SetAnimateInterval(Value:Cardinal);
		procedure SetAnimate(Value:Boolean);
		procedure SetBalloonHint(const Value:string);
		function GetBalloonTimeout:Integer;
		procedure SetBalloonTimeout(Value:Integer);
		procedure SetBalloonTitle(const Value:string);
		procedure SetVisible(Value:Boolean);virtual;
		procedure SetIconIndex(Value:Integer);virtual;
		procedure SetIcon(Value:TIcon);
		procedure SetIconList(Value:TCustomImageList);
		procedure WindowProc(var Message:TMessage);virtual;
		procedure DoOnAnimate(Sender:TObject);virtual;
		property Data:TNotifyIconData read GetData;
		function Refresh(Message:Integer):Boolean;overload;
	public
		constructor Create(Owner:TComponent);override;
		destructor Destroy;override;
		procedure Refresh;overload;
		procedure SetDefaultIcon;
		procedure ShowBalloonHint;virtual;
		property Animate:Boolean read FAnimate write SetAnimate default False;
		property AnimateInterval:Cardinal read GetAnimateInterval write SetAnimateInterval default 1000;
		property Hint:string read FHint write SetHint;
		property BalloonHint:string read FBalloonHint write SetBalloonHint;
		property BalloonTitle:string read FBalloonTitle write SetBalloonTitle;
		property BalloonTimeout:Integer read GetBalloonTimeout write SetBalloonTimeout default 10000;
		property BalloonFlags:Cardinal read FBalloonFlags write FBalloonFlags default NIIF_NONE;
		property Icon:TIcon read FIcon write SetIcon;
		property Icons:TCustomImageList read FIconList write SetIconList;
		property IconIndex:Integer read FIconIndex write SetIconIndex default 0;
		property PopupMenu:TPopupMenu read FPopupMenu write FPopupMenu;
		property Visible:Boolean read FVisible write SetVisible default False;
		property OnBalloonClick:TNotifyEvent read FOnBalloonClick write FOnBalloonClick;
		property OnClick:TNotifyEvent read FOnClick write FOnClick;
		property OnDblClick:TNotifyEvent read FOnDblClick write FOnDblClick;
		property OnMouseMove:TMouseMoveEvent read FOnMouseMove write FOnMouseMove;
		property OnMouseUp:TMouseEvent read FOnMouseUp write FOnMouseUp;
		property OnMouseDown:TMouseEvent read FOnMouseDown write FOnMouseDown;
		property OnAnimate:TNotifyEvent read FOnAnimate write FOnAnimate;
	end;

const
	WM_SYSTEM_TRAY_MESSAGE=WM_USER+1;

implementation

uses
{$IF DEFINED(CLR)}
	WinUtils,
	System.Text,
	System.Security.Permissions,
	System.Runtime.InteropServices,
{$ENDIF}
	Vcl.Consts,
	Vcl.Dialogs,
	System.Math,
	Winapi.UxTheme,
	Winapi.DwmApi,
	Winapi.CommCtrl;

{ TTrayIcon }

constructor TTryIcon.Create(Owner:TComponent);
begin
	inherited;
{$IF NOT DEFINED(CLR)}
	New(FData);
{$ENDIF}
	FAnimate:=False;
	FBalloonFlags:=0;
	BalloonTimeout:=10000;
	FIcon:=TIcon.Create;
	FCurrentIcon:=TIcon.Create;
	FTimer:=TTimer.Create(nil);
	FIconIndex:=0;
	FVisible:=False;
	FIsClicked:=False;
	FTimer.Enabled:=False;
	FTimer.OnTimer:=DoOnAnimate;
	FTimer.Interval:=1000;

	if not(csDesigning in ComponentState) then begin
{$IF DEFINED(CLR)}
		FData.cbSize:=Marshal.SizeOf(FData);
		FData.Wnd:=AllocateHwnd(WindowProc);
		FData.szTip:=Application.Title;
{$ELSE}
		FillChar(FData^,SizeOf(FData^),0);
		FData^.cbSize:=FData^.SizeOf; // Use SizeOf method to get platform specific size
		FData^.Wnd:=AllocateHwnd(WindowProc);
		StrPLCopy(FData^.szTip,Application.Title,Length(FData^.szTip)-1);
{$ENDIF}
		FData.uID:=FData.Wnd;
		FData.uTimeout:=10000;
		FData.hIcon:=FCurrentIcon.Handle;
		FData.uFlags:=NIF_ICON or NIF_MESSAGE;
		FData.uCallbackMessage:=WM_SYSTEM_TRAY_MESSAGE;
		if Length(Application.Title)>0 then FData.uFlags:=FData.uFlags or NIF_TIP;
		Refresh;
	end;
end;

destructor TTryIcon.Destroy;
begin
	if not(csDesigning in ComponentState) then begin
		Refresh(NIM_DELETE);
		DeallocateHWnd(FData.Wnd);
	end;
	FCurrentIcon.Free;
	FIcon.Free;
	FTimer.Free;
{$IF NOT DEFINED(CLR)}
	Dispose(FData);
{$ENDIF}
	inherited;
end;

procedure TTryIcon.SetVisible(Value:Boolean);
begin
	if FVisible<>Value then begin
		FVisible:=Value;
		if (not FAnimate)or(FAnimate and FCurrentIcon.Empty) then SetDefaultIcon;

		if not(csDesigning in ComponentState) then begin
			if FVisible then Refresh(NIM_ADD)
			else if not(csLoading in ComponentState) then begin
				if not Refresh(NIM_DELETE) then raise EOutOfResources.Create(STrayIconRemoveError);
			end;
			if FAnimate then FTimer.Enabled:=Value;
		end;
	end;
end;

procedure TTryIcon.SetIconList(Value:TCustomImageList);
begin
	if FIconList<>Value then begin
		FIconList:=Value;
		if not(csDesigning in ComponentState) then begin
			if Assigned(FIconList) then FIconList.GetIcon(FIconIndex,FCurrentIcon)
			else SetDefaultIcon;
			Refresh;
		end;
	end;
end;

procedure TTryIcon.SetHint(const Value:string);
begin
	if CompareStr(FHint,Value)<>0 then begin
		FHint:=Value;
{$IF DEFINED(CLR)}
		FData.szTip:=Hint;
{$ELSE}
		StrPLCopy(FData.szTip,FHint,Length(FData.szTip)-1);
{$ENDIF}
		if Length(Hint)>0 then FData.uFlags:=FData.uFlags or NIF_TIP
		else FData.uFlags:=FData.uFlags and not NIF_TIP;
		Refresh;
	end;
end;

function TTryIcon.GetAnimateInterval:Cardinal;
begin
	Result:=FTimer.Interval;
end;

procedure TTryIcon.SetAnimateInterval(Value:Cardinal);
begin
	FTimer.Interval:=Value;
end;

procedure TTryIcon.SetAnimate(Value:Boolean);
begin
	if FAnimate<>Value then begin
		FAnimate:=Value;
		if not(csDesigning in ComponentState) then begin
			if (FIconList<>nil)and(FIconList.Count>0)and Visible then FTimer.Enabled:=Value;
			if (not FAnimate)and(not FCurrentIcon.Empty) then FIcon.Assign(FCurrentIcon);
		end;
	end;
end;

{ Message handler for the hidden shell notification window. Most messages
	use WM_SYSTEM_TRAY_MESSAGE as the Message ID, with WParam as the ID of the
	shell notify icon data. LParam is a message ID for the actual message, e.g.,
	WM_MOUSEMOVE. Another important message is WM_ENDSESSION, telling the shell
	notify icon to delete itself, so Windows can shut down.

	Send the usual events for the mouse messages. Also interpolate the OnClick
	event when the user clicks the left button, and popup the menu, if there is
	one, for right click events. }

procedure TTryIcon.WindowProc(var Message:TMessage);

{ Return the state of the shift keys. }
	function ShiftState:TShiftState;
	begin
		Result:=[];
		if GetKeyState(VK_SHIFT)<0 then Include(Result,ssShift);
		if GetKeyState(VK_CONTROL)<0 then Include(Result,ssCtrl);
		if GetKeyState(VK_MENU)<0 then Include(Result,ssAlt);
	end;

var
	Point:TPoint;
	Shift:TShiftState;
begin
	case Message.Msg of
		WM_QUERYENDSESSION:Message.Result:=1;
		WM_ENDSESSION: if TWmEndSession(Message).EndSession then Refresh(NIM_DELETE);
		WM_SYSTEM_TRAY_MESSAGE:begin
				case Int64(Message.lParam) of
					WM_MOUSEMOVE: if Assigned(FOnMouseMove) then begin
							Shift:=ShiftState;
							GetCursorPos(Point);
							FOnMouseMove(Self,Shift,Point.X,Point.Y);
						end;
					WM_LBUTTONDOWN:begin
							if Assigned(FOnMouseDown) then begin
								Shift:=ShiftState+[ssLeft];
								GetCursorPos(Point);
								FOnMouseDown(Self,mbLeft,Shift,Point.X,Point.Y);
							end;
							FIsClicked:=True;
						end;
					WM_LBUTTONUP:begin
							Shift:=ShiftState+[ssLeft];
							GetCursorPos(Point);
							if FIsClicked and Assigned(FOnClick) then begin
								FOnClick(Self);
								FIsClicked:=False;
							end;
							if Assigned(FOnMouseUp) then FOnMouseUp(Self,mbLeft,Shift,Point.X,Point.Y);
						end;
					WM_RBUTTONDOWN: if Assigned(FOnMouseDown) then begin
							Shift:=ShiftState+[ssRight];
							GetCursorPos(Point);
							FOnMouseDown(Self,mbRight,Shift,Point.X,Point.Y);
						end;
					WM_RBUTTONUP:begin
							Shift:=ShiftState+[ssRight];
							GetCursorPos(Point);
							if Assigned(FOnMouseUp) then FOnMouseUp(Self,mbRight,Shift,Point.X,Point.Y);
							if Assigned(FPopupMenu) then begin
								SetForegroundWindow(Application.Handle);
								Application.ProcessMessages;
								FPopupMenu.AutoPopup:=False;
								FPopupMenu.PopupComponent:=Owner;
								FPopupMenu.Popup(Point.X,Point.Y);
							end;
						end;
					WM_LBUTTONDBLCLK,WM_MBUTTONDBLCLK,WM_RBUTTONDBLCLK: if Assigned(FOnDblClick) then FOnDblClick(Self);
					WM_MBUTTONDOWN: if Assigned(FOnMouseDown) then begin
							Shift:=ShiftState+[ssMiddle];
							GetCursorPos(Point);
							FOnMouseDown(Self,mbMiddle,Shift,Point.X,Point.Y);
						end;
					WM_MBUTTONUP: if Assigned(FOnMouseUp) then begin
							Shift:=ShiftState+[ssMiddle];
							GetCursorPos(Point);
							FOnMouseUp(Self,mbMiddle,Shift,Point.X,Point.Y);
						end;
					NIN_BALLOONHIDE,NIN_BALLOONTIMEOUT:FData.uFlags:=FData.uFlags and not NIF_INFO;
					NIN_BALLOONUSERCLICK: if Assigned(FOnBalloonClick) then FOnBalloonClick(Self);
				end;
			end;
	else if (Cardinal(Message.Msg)=RM_TaskbarCreated)and Visible then Refresh(NIM_ADD);
	end;
end;

procedure TTryIcon.Refresh;
begin
	if not(csDesigning in ComponentState) then begin
		FData.hIcon:=FCurrentIcon.Handle;
		if Visible then Refresh(NIM_MODIFY);
	end;
end;

function TTryIcon.Refresh(Message:Integer):Boolean;
// var
// SavedTimeout: Integer;
begin
	Result:=Shell_NotifyIcon(Message,FData);
	{ if Result then
		begin
		SavedTimeout := FData.uTimeout;
		FData.uTimeout := 4;
		Result := Shell_NotifyIcon(NIM_SETVERSION, FData);
		FData.uTimeout := SavedTimeout;
		end; }
end;

procedure TTryIcon.SetIconIndex(Value:Integer);
begin
	if FIconIndex<>Value then begin
		FIconIndex:=Value;
		if not(csDesigning in ComponentState) then begin
			if Assigned(FIconList) then FIconList.GetIcon(FIconIndex,FCurrentIcon);
			Refresh;
		end;
	end;
end;

procedure TTryIcon.DoOnAnimate(Sender:TObject);
begin
	if Assigned(FOnAnimate) then FOnAnimate(Self);
	if Assigned(FIconList)and(FIconIndex<FIconList.Count-1) then IconIndex:=FIconIndex+1
	else IconIndex:=0;
	Refresh;
end;

procedure TTryIcon.SetIcon(Value:TIcon);
begin
	FIcon.Assign(Value);
	FCurrentIcon.Assign(Value);
	Refresh;
end;

procedure TTryIcon.SetBalloonHint(const Value:string);
begin
	if CompareStr(FBalloonHint,Value)<>0 then begin
		FBalloonHint:=Value;
{$IF DEFINED(CLR)}
		FData.szInfo:=FBalloonHint;
{$ELSE}
		StrPLCopy(FData.szInfo,FBalloonHint,Length(FData.szInfo)-1);
{$ENDIF}
		Refresh(NIM_MODIFY);
	end;
end;

procedure TTryIcon.SetDefaultIcon;
begin
	if not FIcon.Empty then FCurrentIcon.Assign(FIcon)
	else FCurrentIcon.Assign(Application.Icon);
	Refresh;
end;

procedure TTryIcon.SetBalloonTimeout(Value:Integer);
begin
	FData.uTimeout:=Value;
end;

function TTryIcon.GetBalloonTimeout:Integer;
begin
	Result:=FData.uTimeout;
end;

function TTryIcon.GetData:TNotifyIconData;
begin
	Result:=FData{$IFNDEF CLR}^{$ENDIF};
end;

procedure TTryIcon.Notification(AComponent:TComponent;Operation:TOperation);
begin
	inherited Notification(AComponent,Operation);
	if (AComponent=FPopupMenu)and(Operation=opRemove) then FPopupMenu:=nil;
	if (AComponent=FIconList)and(Operation=opRemove) then FIconList:=nil;
end;

procedure TTryIcon.ShowBalloonHint;
begin
	FData.uFlags:=FData.uFlags or NIF_INFO;
	FData.dwInfoFlags:=Cardinal(FBalloonFlags);
	Refresh(NIM_MODIFY);
end;

procedure TTryIcon.SetBalloonTitle(const Value:string);
begin
	if CompareStr(FBalloonTitle,Value)<>0 then begin
		FBalloonTitle:=Value;
{$IF DEFINED(CLR)}
		FData.szInfoTitle:=FBalloonTitle;
{$ELSE}
		StrPLCopy(FData.szInfoTitle,FBalloonTitle,Length(FData.szInfoTitle)-1);
{$ENDIF}
		Refresh(NIM_MODIFY);
	end;
end;

end.
