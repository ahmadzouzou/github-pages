unit ToolTipManager;

interface

uses
	Windows,
	Messages,
	Classes,
	Graphics,
	Controls;

type

	Ttooltipitem=class;
	Ttooltipitems=class;
	Ttooltipmanager=class;

	Ttooltipitemclass=class of Ttooltipitem;

	Ttooltipicon=(Ttinone,Ttiinformation,Ttiwarning,Ttierror,Ttiinformationlarge,Ttiwarninglarge,Ttierrorlarge,Tticustom);

	Ttooltipevent=procedure(Sender:Tobject;Tooltip:Ttooltipitem) of object;

	// TToolTip Item
	Ttooltipitem=class(Tcollectionitem)
	private
		Fcontrol:Twincontrol;
		Ficontype:Ttooltipicon;
		Fcustomicon:Ticon;
		Ftitle:string;
		Fdescription:string;
		Fcolor:Tcolor;
		Ftextcolor:Tcolor;
		procedure Setcontrol(Value:Twincontrol);
		procedure Setcustomicon(Value:Ticon);
		function Geticon:Hicon;
	protected
		function Getdisplayname:string;override;
		function Getmanager:Ttooltipmanager;
		property Icon:Hicon read Geticon;
	public
		constructor Create(Collection:Tcollection);override;
		destructor Destroy;override;
		procedure Assign(Source:Tpersistent);override;
		procedure Refresh;
	published
		property Control:Twincontrol read Fcontrol write Setcontrol;
		property Customicon:Ticon read Fcustomicon write Setcustomicon;
		property Icontype:Ttooltipicon read Ficontype write Ficontype default Ttinone;
		property Title:string read Ftitle write Ftitle;
		property Description:string read Fdescription write Fdescription;
		property Color:Tcolor read Fcolor write Fcolor default Cldefault;
		property Textcolor:Tcolor read Ftextcolor write Ftextcolor default Cldefault;
	end;

	// TToolTipItems
	Ttooltipitems=class(Tcollection)
	private
		Fowner:Tpersistent;
		function Getitem(Index:Integer):Ttooltipitem;
		procedure Setitem(Index:Integer;Value:Ttooltipitem);
		function Getbyhandle(Handle:Thandle):Ttooltipitem;
	protected
		function Getowner:Tpersistent;override;
	public
{$IFNDEF COMPILER4_UP}
		constructor Create(Aowner:Tpersistent;Itemclass:Ttooltipitemclass);virtual;
{$ELSE}
		constructor Create(Aowner:Tpersistent;Itemclass:Ttooltipitemclass);reintroduce;virtual;
{$ENDIF}
		function Add:Ttooltipitem;
{$IFDEF COMPILER4_UP}
		function Insert(Index:Integer):Ttooltipitem;
{$ENDIF}
		property Byhandle[Handle:Thandle]:Ttooltipitem read Getbyhandle;
		property Items[index:Integer]:Ttooltipitem read Getitem write Setitem;default;
	end;

	Ttooltipmanager=class(Tcomponent)
	private
		Fenabled:Boolean;
		Ftooltips:Ttooltipitems;
		Fdefaultcolor:Tcolor;
		Fdefaulttextcolor:Tcolor;
		Fdefaultcustomicon:Ticon;
		Fcentertip:Boolean;
		Fballoontip:Boolean;
		Fshowpause:Dword;
		Fhidepause:Dword;
		Freshowpause:Dword;
		Fownerwnd:Thandle;
		Ftooltipwnd:Thandle;
		Fvisibletooltip:Ttooltipitem;
		Fonbeforeshow:Ttooltipevent;
		Fonshow:Ttooltipevent;
		Fonhide:Ttooltipevent;
		procedure Setenabled(Value:Boolean);
		procedure Settooltips(Value:Ttooltipitems);
		procedure Setballoontip(Value:Boolean);
		procedure Setcentertip(Value:Boolean);
		procedure Setshowpause(Value:Dword);
		procedure Sethidepause(Value:Dword);
		procedure Setreshowpause(Value:Dword);
		procedure Setdefaultcustomicon(Value:Ticon);
		procedure Callback(var Message:Tmessage);
	protected
		procedure Notification(Acomponent:Tcomponent;Operation:Toperation);override;
		procedure Loaded;override;
		procedure Addtooltip(Tooltip:Ttooltipitem);virtual;
		procedure Updatetooltip(Tooltip:Ttooltipitem);virtual;
		procedure Removetooltip(Tooltip:Ttooltipitem);virtual;
		procedure Applytooltipparams(Tooltip:Ttooltipitem);virtual;
		property Ownerwnd:Thandle read Fownerwnd;
		property Tooltipwnd:Thandle read Ftooltipwnd;
	public
		constructor Create(Aowner:Tcomponent);override;
		destructor Destroy;override;
		procedure Rebuildtooltips;virtual;
		procedure Removetooltips;virtual;
		property Visibletooltip:Ttooltipitem read Fvisibletooltip;
	published
		property Balloontip:Boolean read Fballoontip write Setballoontip default True;
		property Centertip:Boolean read Fcentertip write Setcentertip default False;
		property Defaultcolor:Tcolor read Fdefaultcolor write Fdefaultcolor default Clinfobk;
		property Defaulttextcolor:Tcolor read Fdefaulttextcolor write Fdefaulttextcolor default Clinfotext;
		property Defaultcustomicon:Ticon read Fdefaultcustomicon write Setdefaultcustomicon;
		property Enabled:Boolean read Fenabled write Setenabled default True;
		property Showpause:Dword read Fshowpause write Setshowpause default 500;
		property Hidepause:Dword read Fhidepause write Sethidepause default 5000;
		property Reshowpause:Dword read Freshowpause write Setreshowpause default 100;
		property Tooltips:Ttooltipitems read Ftooltips write Settooltips;
		property Onbeforeshow:Ttooltipevent read Fonbeforeshow write Fonbeforeshow;
		property Onshow:Ttooltipevent read Fonshow write Fonshow;
		property Onhide:Ttooltipevent read Fonhide write Fonhide;
	end;

implementation

uses
	Commctrl,
	Forms;

const
	Tts_balloon=$40;
{$IFDEF UNICODE}
	Ttm_settitle=Wm_user+33;
{$ELSE}
	Ttm_settitle=Wm_user+32;
{$ENDIF}
	{ TToolTipItem }

constructor Ttooltipitem.Create(Collection:Tcollection);
begin
	inherited Create(Collection);
	Fcustomicon:=Ticon.Create;
	Fcolor:=Cldefault;
	Ftextcolor:=Cldefault;
end;

destructor Ttooltipitem.Destroy;
begin
	Control:=nil;
	Fcustomicon.Free;
	inherited Destroy;
end;

procedure Ttooltipitem.Assign(Source:Tpersistent);
begin
	if Source is Ttooltipitem then
		with Ttooltipitem(Source) do begin
			Self.Control:=Control;
			Self.Icontype:=Icontype;
			Self.Customicon:=Customicon;
			Self.Title:=Title;
			Self.Description:=Description;
			Self.Color:=Color;
			Self.Textcolor:=Textcolor;
		end
	else inherited Assign(Source);
end;

function Ttooltipitem.Getdisplayname:string;
begin
	if Title<>'' then
		if Description<>'' then Result:='<'+Title+'> '+Description
		else Result:='<'+Title+'>'
	else if Description<>'' then Result:=Description
	else Result:=inherited Getdisplayname;
end;

function Ttooltipitem.Getmanager:Ttooltipmanager;
begin
	Result:=Ttooltipmanager(Ttooltipitems(Collection).Getowner);
end;

procedure Ttooltipitem.Setcontrol(Value:Twincontrol);
begin
	if Control<>Value then begin
		if Assigned(Control)and not(Csdestroying in Control.Componentstate) then begin
{$IFDEF COMPILER5_UP}
			Control.Removefreenotification(Getmanager);
{$ENDIF}
			Getmanager.Removetooltip(Self);
		end;
		Fcontrol:=Value;
		if Assigned(Control) then begin
			Control.Freenotification(Getmanager);
			if Title='' then Title:=Getshorthint(Control.Hint);
			if Description='' then Description:=Getlonghint(Control.Hint);
			Getmanager.Addtooltip(Self);
		end;
	end;
end;

procedure Ttooltipitem.Setcustomicon(Value:Ticon);
begin
	Customicon.Assign(Value);
end;

function Ttooltipitem.Geticon:Hicon;
begin
	if Icontype=Tticustom then begin
		if not Customicon.Empty then Result:=Customicon.Handle
		else if not Getmanager.Defaultcustomicon.Empty then Result:=Getmanager.Defaultcustomicon.Handle
		else Result:=Application.Icon.Handle;
	end
	else Result:=Ord(Icontype);
end;

procedure Ttooltipitem.Refresh;
begin
	if Control<>nil then Getmanager.Updatetooltip(Self);
end;

{ TToolTipItems }

constructor Ttooltipitems.Create(Aowner:Tpersistent;Itemclass:Ttooltipitemclass);
begin
	inherited Create(Itemclass);
	Fowner:=Aowner;
end;

function Ttooltipitems.Getowner:Tpersistent;
begin
	Result:=Fowner;
end;

function Ttooltipitems.Add:Ttooltipitem;
begin
	Result:=Ttooltipitem(inherited Add);
end;

{$IFDEF COMPILER4_UP}

function Ttooltipitems.Insert(Index:Integer):Ttooltipitem;
begin
	Result:=Ttooltipitem(inherited Insert(index));
end;
{$ENDIF}

function Ttooltipitems.Getbyhandle(Handle:Thandle):Ttooltipitem;
var
	I:Integer;
	Nearest:Ttooltipitem;
begin
	Nearest:=nil;
	for I:=Count-1 downto 0 do begin
		Result:=Items[I];
		if Assigned(Result.Control) then begin
			if Result.Control.Handle=Handle then Exit
			else if not Assigned(Nearest)and Ischild(Result.Control.Handle,Handle) then Nearest:=Result;
		end;
	end;
	Result:=Nearest;
end;

function Ttooltipitems.Getitem(Index:Integer):Ttooltipitem;
begin
	Result:=Ttooltipitem(inherited Items[index]);
end;

procedure Ttooltipitems.Setitem(Index:Integer;Value:Ttooltipitem);
begin
	inherited Items[index]:=Value;
end;

{ TToolTipManager }

constructor Ttooltipmanager.Create(Aowner:Tcomponent);
begin
	inherited Create(Aowner);
	Fownerwnd:={$IFDEF COMPILER6_UP}Classes.{$ENDIF}Allocatehwnd(Callback);
	Ftooltips:=Ttooltipitems.Create(Self,Ttooltipitem);
	Fdefaultcustomicon:=Ticon.Create;
	Fdefaultcolor:=Clinfobk;
	Fdefaulttextcolor:=Clinfotext;
	Fshowpause:=500;
	Fhidepause:=5000;
	Freshowpause:=100;
	Fballoontip:=True;
	Fenabled:=True;
end;

destructor Ttooltipmanager.Destroy;
begin
	Ftooltips.Free;
	Fdefaultcustomicon.Free;
	Removetooltips;
{$IFDEF COMPILER6_UP}Classes.{$ENDIF}Deallocatehwnd(Fownerwnd);
	inherited Destroy;
end;

procedure Ttooltipmanager.Notification(Acomponent:Tcomponent;Operation:Toperation);
var
	I:Integer;
begin
	inherited Notification(Acomponent,Operation);
	if Operation=Opremove then
		for I:=0 to Tooltips.Count-1 do
			if Tooltips[I].Control=Acomponent then Tooltips[I].Control:=nil;
end;

procedure Ttooltipmanager.Loaded;
begin
	inherited Loaded;
	Rebuildtooltips;
end;

procedure Ttooltipmanager.Setenabled(Value:Boolean);
begin
	if Enabled<>Value then begin
		Fenabled:=Value;
		if Fenabled then Rebuildtooltips
		else Removetooltips;
	end;
end;

procedure Ttooltipmanager.Setballoontip(Value:Boolean);
begin
	if Balloontip<>Value then begin
		Fballoontip:=Value;
		Rebuildtooltips;
	end;
end;

procedure Ttooltipmanager.Setcentertip(Value:Boolean);
begin
	if Centertip<>Value then begin
		Fcentertip:=Value;
		Rebuildtooltips;
	end;
end;

procedure Ttooltipmanager.Setshowpause(Value:Dword);
begin
	if Showpause<>Value then begin
		Fshowpause:=Value;
		if Tooltipwnd<>0 then Sendmessage(Tooltipwnd,Ttm_setdelaytime,Ttdt_initial,Makelong(Fshowpause,0));
	end;
end;

procedure Ttooltipmanager.Sethidepause(Value:Dword);
begin
	if Hidepause<>Value then begin
		Fhidepause:=Value;
		if Tooltipwnd<>0 then Sendmessage(Tooltipwnd,Ttm_setdelaytime,Ttdt_autopop,Makelong(Fhidepause,0));
	end;
end;

procedure Ttooltipmanager.Setreshowpause(Value:Dword);
begin
	if Reshowpause<>Value then begin
		Freshowpause:=Value;
		if Tooltipwnd<>0 then Sendmessage(Tooltipwnd,Ttm_setdelaytime,Ttdt_reshow,Makelong(Freshowpause,0));
	end;
end;

procedure Ttooltipmanager.Setdefaultcustomicon(Value:Ticon);
begin
	Fdefaultcustomicon.Assign(Value);
end;

procedure Ttooltipmanager.Settooltips(Value:Ttooltipitems);
begin
	Tooltips.Assign(Value);
end;

procedure Ttooltipmanager.Rebuildtooltips;
var
	I:Integer;
	Style:Dword;
begin
	if not(Csloading in Componentstate)and not(Csdesigning in Componentstate)and not(Csdestroying in Componentstate)and Fenabled
	then begin
		Removetooltips;
		Style:=Tts_noprefix or Tts_alwaystip;
		if Balloontip then Style:=Style or Tts_balloon;
		Ftooltipwnd:=Createwindow(Tooltips_class,nil,Style,0,0,0,0,Fownerwnd,0,Hinstance,nil);
		if Ftooltipwnd<>0 then begin
			Sendmessage(Tooltipwnd,Ttm_setmaxtipwidth,0,Screen.Width div 3);
			Sendmessage(Tooltipwnd,Ttm_setdelaytime,Ttdt_initial,Makelong(Fshowpause,0));
			Sendmessage(Tooltipwnd,Ttm_setdelaytime,Ttdt_autopop,Makelong(Fhidepause,0));
			Sendmessage(Tooltipwnd,Ttm_setdelaytime,Ttdt_reshow,Makelong(Freshowpause,0));
			for I:=0 to Tooltips.Count-1 do Addtooltip(Tooltips[I]);
		end;
	end;
end;

procedure Ttooltipmanager.Removetooltips;
begin
	if Ftooltipwnd<>0 then begin
		Destroywindow(Ftooltipwnd);
		Ftooltipwnd:=0;
	end;
	Fvisibletooltip:=nil;
end;

procedure Ttooltipmanager.Addtooltip(Tooltip:Ttooltipitem);
begin
	Updatetooltip(Tooltip);
end;

procedure Ttooltipmanager.Updatetooltip(Tooltip:Ttooltipitem);
var
	Toolinfo:Ttoolinfo;
begin
	if (Tooltipwnd<>0)and Assigned(Tooltip.Control) then begin
		Fillchar(Toolinfo,Sizeof(Toolinfo),0);
		Toolinfo.Cbsize:=Sizeof(Toolinfo);
		Toolinfo.Hwnd:=Ownerwnd;
		Toolinfo.Uid:=Tooltip.Control.Handle;
		Toolinfo.Uflags:=Ttf_transparent or Ttf_subclass or Ttf_idishwnd;
		if Centertip then Toolinfo.Uflags:=Toolinfo.Uflags or Ttf_centertip;
		Toolinfo.Lpsztext:=Lpstr_textcallback;
		Sendmessage(Tooltipwnd,Ttm_addtool,0,Integer(@Toolinfo));
		if not(Csacceptscontrols in Tooltip.Control.Controlstyle) then begin
			Toolinfo.Uid:=Getwindow(Tooltip.Control.Handle,Gw_child);
			while Toolinfo.Uid<>0 do begin
				Sendmessage(Tooltipwnd,Ttm_addtool,0,Integer(@Toolinfo));
				Toolinfo.Uid:=Getwindow(Toolinfo.Uid,Gw_hwndnext);
			end;
		end;
	end;
end;

procedure Ttooltipmanager.Removetooltip(Tooltip:Ttooltipitem);
var
	Toolinfo:Ttoolinfo;
begin
	if (Tooltipwnd<>0)and Assigned(Tooltip.Control) then begin
		Fillchar(Toolinfo,Sizeof(Toolinfo),0);
		Toolinfo.Cbsize:=Sizeof(Toolinfo);
		Toolinfo.Hwnd:=Ownerwnd;
		Toolinfo.Uid:=Tooltip.Control.Handle;
		Sendmessage(Tooltipwnd,Ttm_deltool,0,Integer(@Toolinfo));
	end;
end;

procedure Ttooltipmanager.Applytooltipparams(Tooltip:Ttooltipitem);
begin
	if Tooltipwnd<>0 then begin
		if Tooltip.Color=Cldefault then Sendmessage(Tooltipwnd,Ttm_settipbkcolor,Colortorgb(Defaultcolor),0)
		else Sendmessage(Tooltipwnd,Ttm_settipbkcolor,Colortorgb(Tooltip.Color),0);
		if Tooltip.Textcolor=Cldefault then Sendmessage(Tooltipwnd,Ttm_settiptextcolor,Colortorgb(Defaulttextcolor),0)
		else Sendmessage(Tooltipwnd,Ttm_settiptextcolor,Colortorgb(Tooltip.Textcolor),0);
		Sendmessage(Tooltipwnd,Ttm_settitle,Tooltip.Icon,Integer(Pchar(Tooltip.Title)));
	end;
end;

procedure Ttooltipmanager.Callback(var Message:Tmessage);
var
	Notifymsg:Twmnotify absolute message;
	Tooltip:Ttooltipitem;
begin
	if message.Msg=Wm_notify then begin
		Tooltip:=Tooltips.Byhandle[Notifymsg.Nmhdr^.Idfrom];
		if Assigned(Tooltip) then
			case Notifymsg.Nmhdr^.Code of
				Ttn_needtext:begin
						if Assigned(Onbeforeshow) then Onbeforeshow(Self,Tooltip);
						Pnmttdispinfo(Notifymsg.Nmhdr)^.Lpsztext:=Pchar(Tooltip.Description);
						Applytooltipparams(Tooltip);
					end;
				Ttn_show:begin
						if Assigned(Onshow) then Onshow(Self,Tooltip);
						Fvisibletooltip:=Tooltip;
					end;
				Ttn_pop:begin
						Fvisibletooltip:=nil;
						if Assigned(Onhide) then Onhide(Self,Tooltip);
					end;
			end;
	end
	else
		with message do Result:=Defwindowproc(Ownerwnd,Msg,Wparam,Lparam);
end;

end.
