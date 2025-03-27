unit clsFileType;
{
	This is a procedure named "SendKeys".
	This function like the same named statment of Visual Basic.
	It provide the same features by VB's function.
	This version not use "wait" flg.
	Ver 1.2   '95.9.7

	CopyRights 1995, Makoto Muramatsu
}

interface

uses
	Wintypes;

procedure Sendkeys(H:Hwnd;const Keys:string;Wait:Boolean);

implementation

uses
	Winprocs,
	Messages,
	Sysutils,
	Forms,
	Dialogs,
	System.Uitypes;

type
	Twindowobj=class(Tobject)
	private
		Windowhandle:Hwnd;
		Targetclass:Pchar;
		Namelength:Integer;
		Buffer:Pchar;
	public
		constructor Create;
		destructor Destroy;
		procedure Settargetclass(Classname:string);
		procedure Setwindowhandle(Hwnd:Hwnd);
		function Getwindowhandle:Hwnd;
		function Equal(Handle:Hwnd):Boolean;

	end;

const
	Openbrace='{';
	Closebrace='}';
	Plus='+';
	Caret='^';
	Percent='%';
	Space=' ';
	Tilde='~';
	Shiftkey=$10;
	Ctrlkey=$11;
	Altkey=$12;
	Enterkey=$13;
	Openparentheses='(';
	Closeparentheses=')';
	Null=#0;
	Targetcontrolclass='Edit';

	{ ================ GetTextWindow ============================= }
function Enumchildproc(Hwnd:Hwnd;Lparam:Longint):Bool;export;
var
	Continueflg:Boolean;
	Hobj:Twindowobj;
begin
	Hobj:=Twindowobj(Lparam);
	if Hobj.Equal(Hwnd) then begin
		Hobj.Setwindowhandle(Hwnd);
		Continueflg:=False;
	end;
	Result:=Continueflg; { Stop Enumerate }
end;

function Getfocuswindow(H:Hwnd):Hwnd;
{ GetFocus and if return 0 then search Edit Control in Children of the window }
var
	Enumfunc:Tfarproc;
	Param:Longint;
	Proc:Tfarproc;
	Ok:Boolean;
	Hobj:Twindowobj;
	Targetwindow:Hwnd;

begin
	Targetwindow:=Getfocus;
	if Targetwindow<>0 then begin
		Result:=Targetwindow;
		Result:=0;
		Exit;
	end;
	H:=Getactivewindow;
	Proc:=@Enumchildproc;
	Enumfunc:=Makeprocinstance(Proc,Hinstance);
	if not Assigned(Enumfunc) then begin
		Messagedlg('MakeprocInstanceFail',Mterror,[Mbok],0);
		Exit;
	end;
	Hobj:=Twindowobj.Create;
	Hobj.Settargetclass(Targetcontrolclass);
	Param:=Longint(Hobj);
	Result:=0;
	try
		Ok:=Enumchildwindows(H,Enumfunc,Param);
		Targetwindow:=Hobj.Getwindowhandle;
	finally
		Freeprocinstance(Enumfunc);
		Hobj.Free;
	end;
	Result:=H;
	if Targetwindow<>0 then begin
		if Iswindowenabled(Targetwindow) then begin
			Result:=Targetwindow;
		end;
	end;
end;

{ ================ TWindowObj ============================= }
{ transfer User Data from EnumChildWindow to EnumChildProc }
constructor Twindowobj.Create;
begin
	Targetclass:=nil;
end;

destructor Twindowobj.Destroy;
begin
	if Assigned(Targetclass) then begin
		Strdispose(Targetclass);
	end;
	if Assigned(Buffer) then begin
		Strdispose(Buffer);
	end;
end;

function Twindowobj.Equal(Handle:Hwnd):Boolean;
var
	Classnamelength:Integer;
begin
	Result:=False;
	Classnamelength:=Getclassname(Handle,Buffer,Namelength+1);
	if Classnamelength=0 then Exit;
	if Strlicomp(Targetclass,Buffer,Namelength)=0 then begin
		Result:=True;
	end;
end;

procedure Twindowobj.Settargetclass(Classname:string);
begin
	if Assigned(Targetclass) then begin
		Strdispose(Targetclass);
	end;
	if Assigned(Buffer) then begin
		Strdispose(Buffer);
	end;
	Namelength:=Length(Classname);
	Targetclass:=Stralloc(Namelength+1);
	Strpcopy(Targetclass,Classname);
	Buffer:=Stralloc(Namelength+1);
end;

procedure Twindowobj.Setwindowhandle(Hwnd:Hwnd);
begin
	Windowhandle:=Hwnd;
end;

function Twindowobj.Getwindowhandle:Hwnd;
begin
	Result:=Windowhandle;
end;

{ =============  SendKeys ============================ }
procedure Sendonekey(Window:Hwnd;Virtualkey:Word;Repeatcounter:Integer;Shift:Boolean;Ctrl:Boolean;Menu:Boolean;
	Wait:Boolean);
{ Send One VirtualKey, to other Window }
var
	Lparam:Longint;
	Counter:Integer;
	Keyboardstate:Tkeyboardstate;
begin
	Window:=Getfocuswindow(Window);
	for Counter:=0 to Repeatcounter-1 do begin
		Lparam:=$00000001;
		if Menu then begin
			Lparam:=Lparam or $20000000;
		end;
		if Shift or Ctrl or Menu then begin
			{ Set KeyboardState }
			Getkeyboardstate(Keyboardstate);
			if Menu then begin
				Postmessage(Window,Wm_syskeydown,Altkey,Lparam);
				Keyboardstate[Altkey]:=$81;
			end;
			if Shift then begin
				Postmessage(Window,Wm_keydown,Shiftkey,Lparam);
				Keyboardstate[Shiftkey]:=$81;
			end;
			if Ctrl then begin
				Postmessage(Window,Wm_keydown,Ctrlkey,Lparam);
				Keyboardstate[Ctrlkey]:=$81;
			end;
			Setkeyboardstate(Keyboardstate);
		end;
		if Menu then begin
			Postmessage(Window,Wm_syskeydown,Virtualkey,Lparam);
		end else begin
			Postmessage(Window,Wm_keydown,Virtualkey,Lparam);
		end;
		Application.Processmessages;
		Lparam:=Lparam or $D0000000;
		if Menu then begin
			Postmessage(Window,Wm_syskeyup,Virtualkey,Lparam);
		end else begin
			Postmessage(Window,Wm_keyup,Virtualkey,Lparam);
		end;
		if Shift or Ctrl or Menu then begin
			{ unSet KeyBoardState }
			Getkeyboardstate(Keyboardstate);
			if Ctrl then begin
				Postmessage(Window,Wm_keyup,Ctrlkey,Lparam);
				Keyboardstate[Ctrlkey]:=$00;
			end;
			if Shift then begin
				Postmessage(Window,Wm_keyup,Shiftkey,Lparam);
				Keyboardstate[Shiftkey]:=$00;
			end;
			if Menu then begin
				Lparam:=Lparam and $DFFFFFFF;
				Postmessage(Window,Wm_syskeyup,Altkey,Lparam);
				Keyboardstate[Altkey]:=$00;
			end;
			Setkeyboardstate(Keyboardstate);
		end;
	end;
end;

procedure Sendonechar(Window:Hwnd;Onechar:Char;Wait:Boolean);
{ Send One Character to target Window }
var
	Lparam:Longint;
	Key:Word;
begin
	Window:=Getfocuswindow(Window);
	Lparam:=$00000001;
	Key:=Word(Onechar);
	Postmessage(Window,Wm_char,Key,Lparam);
	Application.Processmessages;
end;

function Recognizechar(S:string):Byte;
{ Recognize Virtual Key by KEYWORD }
begin
	if (Comparetext(S,'BS')=0)or(Comparetext(S,'BACKSPACE')=0)or(Comparetext(S,'BKSP')=0) then begin
		Result:=$08;
	end else if Comparetext(S,'BREAK')=0 then begin
		Result:=$13;
	end else if Comparetext(S,'CAPSLOCK')=0 then begin
		Result:=$14;
	end else if Comparetext(S,'CLEAR')=0 then begin
		Result:=$0C;
	end else if (Comparetext(S,'DEL')=0)or(Comparetext(S,'DELETE')=0) then begin
		Result:=$2E;
	end else if Comparetext(S,'DOWN')=0 then begin
		Result:=$28;
	end else if Comparetext(S,'END')=0 then begin
		Result:=$23;
	end else if Comparetext(S,'ENTER')=0 then begin
		Result:=$0D;
	end else if (Comparetext(S,'ESC')=0)or(Comparetext(S,'ESCAPE')=0) then begin
		Result:=$1B;
	end else if Comparetext(S,'HELP')=0 then begin
		Result:=$2F;
	end else if Comparetext(S,'HOME')=0 then begin
		Result:=$24;
	end else if Comparetext(S,'INSERT')=0 then begin
		Result:=$2D;
	end else if Comparetext(S,'LEFT')=0 then begin
		Result:=$25;
	end else if Comparetext(S,'NUMLOCK')=0 then begin
		Result:=$90;
	end else if Comparetext(S,'PGDN')=0 then begin
		Result:=$22;
	end else if Comparetext(S,'PGUP')=0 then begin
		Result:=$21;
	end else if Comparetext(S,'PRTSC')=0 then begin
		Result:=$2C;
	end else if Comparetext(S,'RIGHT')=0 then begin
		Result:=$27;
	end else if Comparetext(S,'SCROLLLOCK')=0 then begin
		Result:=$91;
	end else if Comparetext(S,'TAB')=0 then begin
		Result:=$09;
	end else if Comparetext(S,'UP')=0 then begin
		Result:=$26;
	end else if Comparetext(S,'F1')=0 then begin
		Result:=$70;
	end else if Comparetext(S,'F2')=0 then begin
		Result:=$71;
	end else if Comparetext(S,'F3')=0 then begin
		Result:=$72;
	end else if Comparetext(S,'F4')=0 then begin
		Result:=$73;
	end else if Comparetext(S,'F5')=0 then begin
		Result:=$74;
	end else if Comparetext(S,'F6')=0 then begin
		Result:=$75;
	end else if Comparetext(S,'F7')=0 then begin
		Result:=$76;
	end else if Comparetext(S,'F8')=0 then begin
		Result:=$77;
	end else if Comparetext(S,'F9')=0 then begin
		Result:=$78;
	end else if Comparetext(S,'F10')=0 then begin
		Result:=$79;
	end else if Comparetext(S,'F11')=0 then begin
		Result:=$7A;
	end else if Comparetext(S,'F12')=0 then begin
		Result:=$7B;
	end else if Comparetext(S,'F13')=0 then begin
		Result:=$7C;
	end else if Comparetext(S,'F14')=0 then begin
		Result:=$7D;
	end else if Comparetext(S,'F15')=0 then begin
		Result:=$7E;
	end else if Comparetext(S,'F16')=0 then begin
		Result:=$7F;
	end else if Comparetext(S,'F17')=0 then begin
		Result:=$80;
	end else if Comparetext(S,'F18')=0 then begin
		Result:=$81;
	end else if Comparetext(S,'F19')=0 then begin
		Result:=$82;
	end else if Comparetext(S,'F20')=0 then begin
		Result:=$83;
	end else if Comparetext(S,'F21')=0 then begin
		Result:=$84;
	end else if Comparetext(S,'F22')=0 then begin
		Result:=$85;
	end else if Comparetext(S,'F23')=0 then begin
		Result:=$86;
	end else if Comparetext(S,'F24')=0 then begin
		Result:=$87;
	end else begin
		Result:=0;
	end;
end;

function Chartovirtualkey(Source:Char;var Shift:Boolean;var Ctrl:Boolean;var Menu:Boolean):Word;
var
	Resultcode:Word;
	Upperword:Word;
begin
	Resultcode:=Vkkeyscan(Source);
	Upperword:=Resultcode shr 8;
	case Upperword of
		1,3,4,5:Shift:=True;
		6:begin
				Ctrl:=True;
				Menu:=True;
			end;
		7:begin
				Shift:=True;
				Ctrl:=True;
				Menu:=True;
			end;
	end;
	Result:=Resultcode and $00FF;
end;

function Getspecialchar(Specialchar:Pchar;var Repeatcount:Integer;var Shift:Boolean;var Ctrl:Boolean;
	var Menu:Boolean):Word;
{ In Brace String Parser }
var
	P:Pchar;
	S:string;
	Virtualkey:Byte;
begin
	P:=Strscan(Specialchar,Space);
	if P<>nil then begin
		P^:=Null;
		Inc(P);
		S:=Strpas(P);
		Repeatcount:=Strtoint(S);
	end else begin
		Repeatcount:=1;
	end;
	S:=Strpas(Specialchar);
	Virtualkey:=Recognizechar(S);
	if Virtualkey=0 then begin
		Result:=Chartovirtualkey(Specialchar^,Shift,Ctrl,Menu);
	end else begin
		Result:=Virtualkey;
	end;
end;

procedure Parser(Window:Hwnd;Chars:Pchar;Wait:Boolean);
{ Parse String Line and Send keys }
var
	P:Pchar;
	Specialchar:Pchar;
	Shift,Ctrl,Menu:Boolean;
	Parenthese:Boolean;
	Repeatcounter:Integer;
	Vertualkey:Word;

	procedure Clearaddkey;
	begin
		Shift:=False;
		Ctrl:=False;
		Menu:=False;
	end;

begin
	P:=Chars;
	Clearaddkey;
	Parenthese:=False;
	while P^<>Null do begin
		if P^=Openbrace then begin
			{ Control Code }
			Inc(P);
			Specialchar:=P;
			while P^<>Null do begin
				if P^=Closebrace then begin
					if (P+1)^=Closebrace then begin
						Inc(P);
					end;
					Break;
				end;
				Inc(P);
			end;
			if P^=Null then begin
				Messagedlg('Illegal string ',Mterror,[Mbok],0);
				Break;
			end;
			P^:=Null;
			Vertualkey:=Getspecialchar(Specialchar,Repeatcounter,Shift,Ctrl,Menu);
			Sendonekey(Window,Vertualkey,Repeatcounter,Shift,Ctrl,Menu,Wait);
			if not Parenthese then begin
				Clearaddkey;
			end;
		end else if P^=Plus then begin
			Shift:=True;
		end else if P^=Caret then begin
			Ctrl:=True;
		end else if P^=Percent then begin
			Menu:=True;
		end else if P^=Tilde then begin
			Sendonekey(Window,Enterkey,1,Shift,Ctrl,Menu,Wait);
			if not Parenthese then begin
				Clearaddkey;
			end;
		end else if (Shift or Ctrl or Menu)and(P^=Openparentheses) then begin
			Parenthese:=True;
		end else if Parenthese and(P^=Closeparentheses) then begin
			Parenthese:=False;
		end else begin
			if ($80 and Byte(P^))>0 then begin
				{ 2 Bytes Char }
				Sendonechar(Window,P^,Wait);
				Inc(P);
				Sendonechar(Window,P^,Wait);
			end else begin
				Vertualkey:=Chartovirtualkey(P^,Shift,Ctrl,Menu);
				Sendonekey(Window,Vertualkey,1,Shift,Ctrl,Menu,Wait);
			end;
			if not Parenthese then begin
				Clearaddkey;
			end;
		end;
		Inc(P);
	end;
end;

procedure Sendkeys(H:Hwnd;const Keys:string;Wait:Boolean);
{ SendKeys send strings to Window by specific HWND.
	Before sending keys,  activate the window.
	if h = 0 then send string to current activate Window
	sorry, this version not use wait. }
var
	Window:Hwnd;
	Chars:Pchar;
begin
	{ handle check }
	if H=0 then begin
		Window:=Getactivewindow;
	end else begin
		Window:=H;
		Setactivewindow(Window);
	end;

	Chars:=Stralloc(Length(Keys)+1);
	Strpcopy(Chars,Keys);
	Parser(Window,Chars,Wait);
	Strdispose(Chars);
end;

end.
