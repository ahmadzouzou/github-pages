unit Vcl.Styles.Utils.SystemMenu;

interface

uses
	System.Rtti,
	System.Classes,
	System.Generics.Collections,
	Winapi.Windows,
	Winapi.Messages,
	Vcl.Themes,
	Vcl.Graphics,
	Vcl.Forms,
	Vcl.Dialogs;

type
	Tmethodinfo=class;

	Tproccallback=Reference to procedure(Info:Tmethodinfo);
	TFeedBack=Reference to procedure(Sender:TObject;StyleName:string);

	Tmethodinfo=class
		Value1:Tvalue;
		Value2:Tvalue;
		Method:Tproccallback;
	end;

	TVCLStylesSystemMenu=class(TComponent)
	strict private
		Fvclstylesmenu:Hmenu;
		Forgwndproc:Twndmethod;
		Fform:Tform;
		Fmethodsdict:Tobjectdictionary<Nativeuint,Tmethodinfo>;

		procedure Createmenus;
		procedure Deletemenus;
		procedure Createmenustyles;
		procedure Wndproc(var Message:Tmessage);
	private
		Fmenucaption:string;
		Fshownativestyle:Boolean;
    FBeforChangeStyle:TFeedBack;
		FAfterChangeStyle:TFeedBack;
		procedure Setmenucaption(const Value:string);
		procedure Setshownativestyle(const Value:Boolean);
	public
		property Shownativestyle:Boolean read Fshownativestyle write Setshownativestyle;
		property OnBeforChangeStyle:TFeedBack read FBeforChangeStyle write FBeforChangeStyle;
		property OnAfterChangeStyle:TFeedBack read FAfterChangeStyle write FAfterChangeStyle;
		property Menucaption:string read Fmenucaption write Setmenucaption;
		constructor Create(Aowner:Tform;Cap:string);reintroduce;
		destructor Destroy;override;
	end;

implementation

uses
	Vcl.Controls,
	Amdfun1,
	Amdmain,
	System.Sysutils;

const
	Vclstylesmenu=Wm_user+666;

function Insertmenuhelper(Hmenu:Hmenu;Uposition:Uint;Uidnewitem:Uint_ptr;Lpnewitem:Lpcwstr;Icon:Hbitmap):Bool;
var
	Lmenuitem:Tmenuiteminfo;
begin
	Zeromemory(@Lmenuitem,Sizeof(Tmenuiteminfo));
	Lmenuitem.Cbsize:=Sizeof(Tmenuiteminfo);
	Lmenuitem.Fmask:=Miim_ftype or Miim_id or Miim_bitmap or Miim_string;
	Lmenuitem.Ftype:=Mft_string;
	Lmenuitem.Wid:=Uidnewitem;
	Lmenuitem.Dwtypedata:=Lpnewitem;
	Lmenuitem.Hbmpitem:=Icon;
	Result:=Insertmenuitem(Hmenu,Uposition,True,Lmenuitem);
end;

procedure Addmenuseparatorhelper(Hmenu:Hmenu;var Menuindex:Integer);
var
	Lmenuinfo:Tmenuiteminfo;
	Buffer: array [0..79] of Char;
begin
	Zeromemory(@Lmenuinfo,Sizeof(Tmenuiteminfo));
	Lmenuinfo.Cbsize:=Sizeof(Lmenuinfo);
	Lmenuinfo.Fmask:=Miim_type;
	Lmenuinfo.Dwtypedata:=Buffer;
	Lmenuinfo.Cch:=Sizeof(Buffer);
	if Getmenuiteminfo(Hmenu,Menuindex-1,True,Lmenuinfo) then begin
		if (Lmenuinfo.Ftype and Mft_separator)=Mft_separator then
		else begin
			Insertmenu(Hmenu,Menuindex,Mf_byposition or Mf_separator,0,nil);
			Inc(Menuindex);
		end;
	end;
end;

{ TVclStylesSystemMenu }

constructor TVCLStylesSystemMenu.Create(Aowner:Tform;Cap:string);
begin
	inherited Create(Aowner);
	Fshownativestyle:=True;
	Fmenucaption:=Cap;
	Fform:=Aowner;
	Fmethodsdict:=Tobjectdictionary<Nativeuint,Tmethodinfo>.Create([Doownsvalues]);
	Forgwndproc:=Fform.Windowproc;
	Fform.Windowproc:=Wndproc;
	Createmenus;
end;

destructor TVCLStylesSystemMenu.Destroy;
begin
	Deletemenus;
	Fform.Windowproc:=Forgwndproc;
	Fmethodsdict.Free;
	inherited;
end;

procedure TVCLStylesSystemMenu.Setmenucaption(const Value:string);
begin
	Deletemenus;
	Fmenucaption:=Value;
	Createmenus;
end;

procedure TVCLStylesSystemMenu.Setshownativestyle(const Value:Boolean);
begin
	Deletemenus;
	Fshownativestyle:=Value;
	Createmenus;
end;

procedure TVCLStylesSystemMenu.Createmenus;
begin
	Createmenustyles;
end;

procedure TVCLStylesSystemMenu.Deletemenus;
var
	Lsysmenu:Hmenu;
begin
	if Ismenu(Fvclstylesmenu) then
		while Getmenuitemcount(Fvclstylesmenu)>0 do Deletemenu(Fvclstylesmenu,0,Mf_byposition);

	if Fform.Handleallocated then begin
		Lsysmenu:=Getsystemmenu(Fform.Handle,False);
		if Ismenu(Lsysmenu) then Deletemenu(Lsysmenu,Vclstylesmenu,Mf_bycommand);
	end;
	Fmethodsdict.Clear;
end;

procedure TVCLStylesSystemMenu.Createmenustyles;
var
	Lsysmenu:Hmenu;
	Lmenuitem:Tmenuiteminfo;
	Uidnewitem,Lsubmenuindex:Integer;
	Lmethodinfo:Tmethodinfo;
	S:string;
	Lstylenames:Tarray<string>;

begin
	Lsysmenu:=Getsystemmenu(Fform.Handle,False);

	Lsubmenuindex:=Getmenuitemcount(Lsysmenu);
	Addmenuseparatorhelper(Lsysmenu,Lsubmenuindex);

	Fvclstylesmenu:=Createpopupmenu();

	Uidnewitem:=Vclstylesmenu;
	Zeromemory(@Lmenuitem,Sizeof(Tmenuiteminfo));
	Lmenuitem.Cbsize:=Sizeof(Tmenuiteminfo);
	Lmenuitem.Fmask:=Miim_submenu or Miim_ftype or Miim_id or Miim_bitmap or Miim_string;
	Lmenuitem.Ftype:=Mft_string;
	Lmenuitem.Wid:=Vclstylesmenu;
	Lmenuitem.Hsubmenu:=Fvclstylesmenu;
	Lmenuitem.Dwtypedata:=Pwidechar(Fmenucaption);
	Lmenuitem.Cch:=Length(Fmenucaption);

	Insertmenuitem(Lsysmenu,Getmenuitemcount(Lsysmenu),True,Lmenuitem);
	Inc(Uidnewitem);
	Lsubmenuindex:=0;

	Lstylenames:=Tstylemanager.Stylenames;
	Tarray.Sort<string>(Lstylenames);

	for S in Lstylenames do begin

		if not Fshownativestyle and Sametext('Windows',S) then Continue;

		Insertmenuhelper(Fvclstylesmenu,Lsubmenuindex,Uidnewitem,Pchar(S),0);
		if Sametext(Tstylemanager.Activestyle.Name,S) then
				Checkmenuitem(Fvclstylesmenu,Lsubmenuindex,Mf_byposition or Mf_checked);

		if Sametext('Windows',S) then Addmenuseparatorhelper(Fvclstylesmenu,Lsubmenuindex);

		Inc(Lsubmenuindex);
		Inc(Uidnewitem);
		Lmethodinfo:=Tmethodinfo.Create;
		Lmethodinfo.Value1:=S;
		Lmethodinfo.Method:=procedure(Info:Tmethodinfo)
			begin
				Tstylemanager.Setstyle(Info.Value1.Asstring);
				Fform.Refresh;
			end;
		Fmethodsdict.Add(Uidnewitem-1,Lmethodinfo);
	end;
end;

procedure TVCLStylesSystemMenu.Wndproc(var Message:Tmessage);
var
	Lverb:Nativeuint;
begin
	case message.Msg of
		CM_RECREATEWND:begin
				Deletemenus;
				Forgwndproc(message);
				Createmenus;
			end;

		WM_SYSCOMMAND:begin
				if Fmethodsdict.Containskey(Twmsyscommand(message).Cmdtype) then begin
					if Assigned(FBeforChangeStyle) then FBeforChangeStyle(Self,Tstylemanager.Activestyle.Name);
					Lverb:=Twmsyscommand(message).Cmdtype;
					Fmethodsdict.Items[Lverb].Method(Fmethodsdict.Items[Lverb]);
					if Assigned(FAfterChangeStyle) then FAfterChangeStyle(Self,Tstylemanager.Activestyle.Name);
				end
				else Forgwndproc(message);
			end
	else Forgwndproc(message);
	end;
end;

end.
