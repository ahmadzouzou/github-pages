unit isResourceWriterUnit;

interface

uses
	Windows,
	Sysutils,
	Vcl.Dialogs,
	Classes;

type
	// Класс для записи ресурсов в exe файл
	Tisresourcewriter=class
	private
		Fexename:Tfilename;
		Freshandle:Thandle;
		Fautocommit:Boolean;
	public
		constructor Create(const Exename:Tfilename);
		procedure Commit;

		procedure Writestring(const Resname,Value:string);
		procedure Writebuffer(const Resname:string;const Buffer;Buffersize:Longword;Lptype:Pchar=Rt_rcdata);

		property Autocommit:Boolean read Fautocommit write Fautocommit;
	end;

procedure Updateico(Urpath,Urtype,Urname:Pchar;Icofilename:Tfilename);

implementation

uses
	Amdfun1,
	Amdfun2;

procedure Errorwithlasterror(const Message:string);
begin
	raise Exception.Createfmt('%s: %s (#%d)',[message,Syserrormessage(Getlasterror),Getlasterror]);
end;

procedure Error(const Message:string);
begin
	raise Exception.Create(message);
end;

function Enumlangsfunc(Hmodule:Cardinal;Lptype,Lpname:Pchar;Wlanguage:Word;Lparam:Integer):Boolean;stdcall;
begin
	Pword(Lparam)^:=Wlanguage;
	Result:=False;
end;

function Getresourcelanguage(Hmodule:Cardinal;Lptype,Lpname:Pchar;var Wlanguage:Word):Boolean;
begin
	Wlanguage:=0;
	Enumresourcelanguages(Hmodule,Lptype,Lpname,@Enumlangsfunc,Integer(@Wlanguage));
	Result:=True;
end;

{ TisResourceWriter }

procedure Tisresourcewriter.Commit;
begin
	try
		if Freshandle=0 then Error('noting data to commit');

		if not Endupdateresource(Freshandle,False) then Errorwithlasterror('');

		Freshandle:=0;
	except
		on E:Exception do raise Exception.Createfmt('An exception while trying commit resource: %s',[E.Message]);
	end;
end;

constructor Tisresourcewriter.Create(const Exename:Tfilename);
begin
	inherited Create;

	Fexename:=Exename;
end;

procedure Tisresourcewriter.Writestring(const Resname,Value:string);
begin
	Writebuffer(Resname,Value[1],Length(Value)*Sizeof(Char));
end;

procedure Tisresourcewriter.Writebuffer(const Resname:string;const Buffer;Buffersize:Longword;Lptype:Pchar);
begin
	try
		if not Ansisamestr(Ansiuppercase(Resname),Resname) then Error('resource name can by only upper case');

		// Если режим работы не автокоммит
		if Autocommit then
			if Freshandle<>0 then Error('not committed update in last not autommit session')
			else Freshandle:=Beginupdateresource(Pchar(Fexename),False);

		if (not Autocommit)and(Freshandle=0) then Freshandle:=Beginupdateresource(Pchar(Fexename),False);

		if Freshandle=0 then Errorwithlasterror('');

		try
			if not Updateresource(Freshandle,Lptype,Pchar(Resname),Sublang_sys_default*2048 or Lang_neutral,@Buffer,Buffersize)
			then Errorwithlasterror('');
		finally
			if Autocommit then Commit;
		end;
	except
		on E:Exception do
				raise Exception.Createfmt('An exception while trying write resource "%s": %s',[Resname,E.Message]);
	end;
end;

// Замена страндартной иконки. Взято из исхоников InnoSetup
procedure Updateico(Urpath,Urtype,Urname:Pchar;Icofilename:Tfilename);
type
	{ PIcoItemHeader=^TIcoItemHeader;

		TIcoItemHeader=packed record
		Width:Byte;
		Height:Byte;
		Colors:Byte;
		Reserved:Byte;
		Planes:Word;
		BitCount:Word;
		ImageSize:DWORD;
		end;

		PIcoItem=^TIcoItem;

		TIcoItem=packed record
		Header:TIcoItemHeader;
		Offset:DWORD;
		end;

		PIcoHeader=^TIcoHeader;

		TIcoHeader=packed record
		Reserved:Word;
		Typ:Word;
		ItemCount:Word;
		Items: array [0..MaxInt shr 4-1] of TIcoItem;
		end;

		PGroupIconDirItem=^TGroupIconDirItem;

		TGroupIconDirItem=packed record
		Header:TIcoItemHeader;
		Id:Word;
		end;

		PGroupIconDir=^TGroupIconDir;

		TGroupIconDir=packed record
		Reserved:Word;
		Typ:Word;
		ItemCount:Word;
		Items: array [0..MaxInt shr 4-1] of TGroupIconDirItem;
		end; }

	Picoitemheader=^Ticoitemheader;

	Ticoitemheader=packed record
		Width:Byte;
		Height:Byte;
		Colors:Byte; // 0 for 256+ colors
		Reserved:Byte;
		Planes:Word;
		Bitcount:Word;
		Imagesize:Dword;
	end;

	// structure of ico file header
	Picoitem=^Ticoitem;

	Ticoitem=packed record
		Header:Ticoitemheader;
		Offset:Dword; // data offset in ico file
	end;

	Picoheader=^Ticoheader;

	Ticoheader=packed record
		Reserved:Word;
		Typ:Word; // 1 = icon
		Itemcount:Word;
		Items: array [0..Maxint shr 4-1] of Ticoitem;
	end;

	// structure of icon group resources
	Pgroupicondiritem=^Tgroupicondiritem;

	Tgroupicondiritem=packed record
		Header:Ticoitemheader;
		Id:Word; // id of linked RT_ICON resource
	end;

	Pgroupicondir=^Tgroupicondir;

	Tgroupicondir=packed record
		Reserved:Word;
		Typ:Word; // 1 = icon
		Itemcount:Word;
		Items: array [0..Maxint shr 4-1] of Tgroupicondiritem;
	end;

	function Isvalidicon(P:Pointer;Size:Cardinal):Boolean;
	var
		Itemcount:Cardinal;
	begin
		Result:=False;
		if Size<Cardinal(Sizeof(Word)*3) then Exit;
		if (Pchar(P)[0]='M')and(Pchar(P)[1]='Z') then Exit;
		Itemcount:=Picoheader(P).Itemcount;
		if Size<Cardinal((Sizeof(Word)*3)+(Itemcount*Sizeof(Ticoitem))) then Exit;
		P:=@Picoheader(P).Items;
		while Itemcount>Cardinal(0) do begin
			if (Cardinal(Picoitem(P).Offset+Picoitem(P).Header.Imagesize)<Cardinal(Picoitem(P).Offset))or
				(Cardinal(Picoitem(P).Offset+Picoitem(P).Header.Imagesize)>Cardinal(Size)) then Exit;
			Inc(Picoitem(P));
			Dec(Itemcount);
		end;
		Result:=True;
	end;

var
	R:Hrsrc;
	H:Thandle;
	M:Hmodule;
	I:Integer;
	N:Cardinal;
	Res:Hglobal;
	F:Tfilestream;
	Ico:Picoheader;
	Wlanguage:Word;
	Newgroupicondirsize:Longint;
	Groupicondir:Pgroupicondir;
	Newgroupicondir:Pgroupicondir;
	Ss:Tstrings;
	Ri:Pris;
	La:Integer;
	Restyp:Pchar;
	G,S:string;
begin
	if Win32platform<>Ver_platform_win32_nt then Error('Only supported on Windows NT and above');
	Ico:=nil;
	if Is_intresource(Urtype) then begin
		case Nativeuint(Urtype) of
			12:Restyp:=Rt_cursor;
			14:Restyp:=Rt_icon;
		end;
	end;

	try
		// Load the icons
		F:=Tfilestream.Create(Icofilename,Fmopenread);
		try
			N:=F.Size;
			if Cardinal(N)>Cardinal($100000) then { sanity check }
					Error('Icon file is too large');
			Getmem(Ico,N);
			F.Readbuffer(Ico^,N);
		finally F.Free;
		end;

		// Ensure the icon is valid
		if not Isvalidicon(Ico,N) then Error('Icon file is invalid');
		// Update the resources
		H:=Beginupdateresource(Urpath,False);
		if H=0 then Errorwithlasterror('BeginUpdateResource failed (1)');
		try
			M:=Loadlibraryex(Urpath,0,Load_library_as_datafile);
			if M=0 then Errorwithlasterror('LoadLibraryEx failed (1)');
			try
				// Load the "MAINICON" group icon resource
				R:=Findresource(M,Urname,Urtype);
				if R<>0 then begin
					Res:=Loadresource(M,R);
					if Res=0 then Errorwithlasterror('LoadResource failed (1)');
					Groupicondir:=Lockresource(Res);
					if Groupicondir=nil then Errorwithlasterror('LockResource failed (1)');
					// Delete "MAINICON"
					if not Getresourcelanguage(M,Urtype,Urname,Wlanguage) then Error('GetResourceLanguage failed (1)');
					if not Updateresource(H,Urtype,Urname,Wlanguage,nil,0) then Errorwithlasterror('UpdateResource failed (1)');
					{ G:='';
						G:=G+'RES INFO'+#13+'================'+#13+'Reserved : '+GroupIconDir.Reserved.ToString+
						#13+'Typ : '+GroupIconDir.Typ.ToString+#13+'ItemCount : '+
						GroupIconDir.ItemCount.ToString+#13+'================'+#13;

						for I:=0 to GroupIconDir.ItemCount-1 do begin
						S:='item'+GroupIconDir.Items[I].Id.ToString+'W-H '+GroupIconDir.Items[I]
						.Header.Width.ToString+#13+'COLORS '+GroupIconDir.Items[I].Header.Colors.ToString+#13+
						'REVERSED '+GroupIconDir.Items[I].Header.Reserved.ToString+#13+'PLANS '+
						GroupIconDir.Items[I].Header.Planes.ToString+#13+'BITCOUNT '+GroupIconDir.Items[I]
						.Header.BitCount.ToString+#13+'SIZE '+GroupIconDir.Items[I].Header.ImageSize.ToString+
						#13+'=============='+#13;
						G:=G+S;
						S:='';
						end;
						ShowMessage(G); }

					// Delete the RT_ICON icon resources that belonged to "MAINICON"
					for I:=0 to Groupicondir.Itemcount-1 do begin
						if not Getresourcelanguage(M,Restyp,Makeintresource(Groupicondir.Items[I].Id),Wlanguage) then
								Error('GetResourceLanguage failed (2)');
						if not Updateresource(H,Restyp,Makeintresource(Groupicondir.Items[I].Id),Wlanguage,nil,0) then
								Errorwithlasterror('UpdateResource failed (2)');
					end;
				end else begin
					Wlanguage:=0;
				end;
			finally Freelibrary(M);
			end;
			// Build the new group icon resource
			Newgroupicondirsize:=3*Sizeof(Word)+Ico.Itemcount*Sizeof(Tgroupicondiritem);
			Getmem(Newgroupicondir,Newgroupicondirsize);
			try
				// Build the new group icon resource
				Newgroupicondir.Reserved:=Ico.Reserved; // GroupIconDir.Reserved;
				Newgroupicondir.Typ:=Ico.Typ; // GroupIconDir.Typ;

				Newgroupicondir.Itemcount:=Ico.Itemcount;
				with Tstringlist.Create do begin
					Ri:=Aloadresorce('logo\ASS.dll',Restyp,nil,nil,2);
					Text:=Ri.Ulist;
					La:=Strtoint64def(Strings[Count-1],0);
					for I:=0 to Newgroupicondir.Itemcount-1 do begin
						Newgroupicondir.Items[I].Header:=Ico.Items[I].Header;
						repeat La:=La+1;
						until (Indexof(La.Tostring)=-1);
						Newgroupicondir.Items[I].Id:=La;
					end;
					Free;
					Ri.Udis;
				end;
				{ G:='';
					G:=G+'FILE INFO'+#13+'================'+#13+'Reserved : '+NewGroupIconDir.Reserved.ToString+
					#13+'Typ : '+NewGroupIconDir.Typ.ToString+#13+'ItemCount : '+
					NewGroupIconDir.ItemCount.ToString+#13+'================'+#13;

					for I:=0 to NewGroupIconDir.ItemCount-1 do begin
					S:='item'+NewGroupIconDir.Items[I].Id.ToString+'W-H '+NewGroupIconDir.Items[I]
					.Header.Width.ToString+#13+'COLORS '+NewGroupIconDir.Items[I].Header.Colors.ToString+#13
					+'REVERSED '+NewGroupIconDir.Items[I].Header.Reserved.ToString+#13+'PLANS '+
					NewGroupIconDir.Items[I].Header.Planes.ToString+#13+'BITCOUNT '+NewGroupIconDir.Items[I]
					.Header.BitCount.ToString+#13+'SIZE '+NewGroupIconDir.Items[I].Header.ImageSize.ToString
					+#13+'=============='+#13;
					G:=G+S;
					S:='';
					end;
					ShowMessage(G); }
				// Update "MAINICON"
				for I:=0 to Newgroupicondir.Itemcount-1 do
					if not Updateresource(H,Restyp,Makeintresource(Newgroupicondir.Items[I].Id),Wlanguage,
						Pointer(Dword(Ico)+Ico.Items[I].Offset),Ico.Items[I].Header.Imagesize) then
							Errorwithlasterror('UpdateResource failed (3)');

				// Update the icons
				if not Updateresource(H,Urtype,Urname,Wlanguage,Newgroupicondir,Newgroupicondirsize) then
						Errorwithlasterror('UpdateResource failed (4)');
			finally Freemem(Newgroupicondir);
			end;

		except
			Endupdateresource(H,True); // discard changes
			raise;
		end;
		if not Endupdateresource(H,False) then Errorwithlasterror('EndUpdateResource failed');
	finally Freemem(Ico);
	end;
end;

end.
