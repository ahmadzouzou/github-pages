unit amdfun2;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
	// system,
	Winapi.Windows,
	Winapi.Messages,
	System.Sysutils,
	System.Variants,
	System.Classes,
	System.Types,
	System.Ioutils,
	Vcl.Graphics,
	Vcl.Controls,
	Vcl.Forms,
	Vcl.Dialogs,
	Vcl.Comctrls,
	Vcl.Toolwin,
	Vcl.Stdctrls,
	System.Strutils,
	Vcl.Menus,
	Vcl.Imglist,
	Jpeg,
	Stgs,
	Gifimg,
	Vcl.Themes,
	Vcl.Extctrls,
	Vcl.Listactns,
	System.Dateutils,
	Vcl.Mask,
	Winapi.Shellapi,
	Pngimage,
	Winapi.Commctrl,
	Extdlgs,
	Winapi.Commdlg,
	System.Uitypes,
	Rzcommon,
	Rzcmbobx,
	System.Win.Taskbarcore,
	System.Generics.Collections,
	Rzprgres,
	Vcl.Winxctrls,
	Amdmain,
	Amdfun1,
	Vcl.Buttons,
	AMD.Dragdrop,
	AMD.Dropsource,
	AMD.Droptarget,
	AMD.Dragdropfile,
	AMD.Chrometabs,
	AMD.Chrometabstypes,
	AMD.Chrometabsclasses;

function Msg1(F:Twincontrol;Ca,Ti,Te:string;Ic:Integer;Bca:string;Df:Integer;Ck:string;var Ch1:Boolean;Al:Integer=1;
	Tu:Integer=0):Integer;
function Msg2(F:Twincontrol;Ucaption,Utitle,Utext:string;Uicon:Integer=I_n;Ubns:string='';Udfb:Integer=1;Urd:string='';
	Uck:Boolean=False;Utimeout:Integer=0):Ttsg;
function Waitforms:Tform;
procedure Waitformh(Waitf:Tform);
function Tts(Path:string):string;
function Copyfiles(Ufrom,Uto:string;Forcewrite:Boolean=True):Integer;
function LoadFromDirC(uPath:string;BF:Integer=0):string;
function Loadfromdirbf(Udir,Ufname,Uext:string;BF:Integer):string;
procedure Savedialog;
procedure Folderdialog;
function Aloadresorce(Ufile:Pchar;Urtype:Pchar=nil;Urname:Pchar=nil;Uwd:Pchar=nil;Uf:Word=0):Pris;
function Asaveresorce(Urpath,Urtype,Urname:Pchar;Sm:Tstream):Boolean;
procedure Updateresstring(Afilename,Anewstring:string;Astringident:Integer;Lang:Integer=0);
function Aram(A,Cr1,Cr2:string):string;
function Enam(A,Cr1,Cr2:string):string;
function Lant(uPath,Ulang,Unum,Ucr1,Ucr2:string):string;

implementation

uses
	isResourceWriterUnit;

function Lant(uPath,Ulang,Unum,Ucr1,Ucr2:string):string;
begin
	Result:='';
	Lan:=Ulang;
	if (Lan='Arabic') then begin
		Result:=Aram(Unum,Ucr1,Ucr2);
	end;
	if (Lan='English') then begin
		Result:=Enam(Unum,Ucr1,Ucr2);
	end;
end;

function Aram(A,Cr1,Cr2:string):string;
	function Artar(N:string):string;
	var
		U1: array [0..9] of string;
		Sp,Nu1,Nu2,Nu3,Nu4,Nu5,Nu6,Nu12,Nu123,Nu45,Nu456,Nu7,O1,O2,O3,O4,O5,O6:string;
		I:Integer;
	begin
		Sp:=' '+Sl1(1)+' ';
		O1:=N[6];
		O2:=N[5];
		O3:=N[4];
		O4:=N[3];
		O5:=N[2];
		O6:=N[1];
		// FIRST.
		U1[0]:='';
		U1[1]:=Sl1(5);
		U1[2]:=Sl1(6);
		if (O2='0')or(O2='1') then begin
			for I:=3 to 9 do begin
				U1[I]:=Sl1(4+I)+Sl1(2);
			end;
			U1[8]:=Sl1(12)+Sl1(3)+Sl1(2);
		end else begin
			for I:=3 to 9 do begin
				U1[I]:=Sl1(4+I);
			end;
		end;
		Nu1:=U1[Na(O1)];
		// SECOND.
		U1[0]:='';
		for I:=2 to 9 do begin
			U1[I]:=Sl1(15+I);
		end;
		Nu2:=U1[Na(O2)];
		Nu12:=Nu1+Sp+Nu2;
		if (Nu1='') then begin
			Nu12:=Nu2;
		end;
		if (Nu2='') then begin
			Nu12:=Nu1;
		end;
		if (Nu1='')and(Nu2='') then begin
			Nu12:='';
		end;
		if (O2='1') then begin
			Nu12:=Nu1+' '+Sl1(14);
			if (O1='0') then begin
				Nu12:=Sl1(14)+Sl1(2);
			end;
			if (O1='1') then begin
				Nu12:=Sl1(15);
			end;
			if (O1='2') then begin
				Nu12:=Sl1(16);
			end;
		end;
		// THIRD.
		U1[0]:='';
		U1[1]:=Sl1(25);
		U1[2]:=Sl1(27);
		for I:=3 to 9 do begin
			U1[I]:=Sl1(4+I)+Sl1(25);
		end;
		Nu3:=U1[Na(O3)];
		Nu123:=Nu3+Sp+Nu12;
		if (Nu3='') then begin
			Nu123:=Nu12;
		end;
		if (Nu12='') then begin
			Nu123:=Nu3;
		end;
		if (Nu12='')and(Nu3='') then begin
			Nu123:='';
		end;
		// FORTH
		U1[0]:='';
		U1[1]:=Sl1(5);
		U1[2]:=Sl1(6);
		if (O5='0')or(O5='1') then begin
			for I:=3 to 9 do begin
				U1[I]:=Sl1(4+I)+Sl1(2);
			end;
			U1[8]:=Sl1(12)+Sl1(3)+Sl1(2);
		end else begin
			for I:=3 to 9 do begin
				U1[I]:=Sl1(4+I);
			end;
		end;
		Nu4:=U1[Na(O4)];
		// FIFTH.
		U1[0]:='';
		for I:=2 to 9 do begin
			U1[I]:=Sl1(15+I);
		end;
		Nu5:=U1[Na(O5)];
		Nu45:=Nu4+Sp+Nu5;
		if (Nu4='') then begin
			Nu45:=Nu5;
		end;
		if (Nu5='') then begin
			Nu45:=Nu4;
		end;
		if (Nu4='')and(Nu5='') then begin
			Nu45:='';
		end;
		if (O5='1') then begin
			Nu45:=Nu4+' '+Sl1(14);
			if (O4='0') then begin
				Nu45:=Sl1(14)+Sl1(2);
			end;
			if (O4='1') then begin
				Nu45:=Sl1(15);
			end;
			if (O4='2') then begin
				Nu45:=Sl1(16);
			end;
		end;
		// SIXTH.
		U1[0]:='';
		U1[1]:=Sl1(25);
		U1[2]:=Sl1(27);
		for I:=3 to 9 do begin
			U1[I]:=Sl1(4+I)+Sl1(25);
		end;
		Nu6:=U1[Na(O6)];
		Nu456:=Nu6+Sp+Nu45+' '+Sl1(28);
		if (Nu6='') then begin
			Nu456:=Nu45+' '+Sl1(28);
		end;
		if (Nu45='') then begin
			Nu456:=Nu6+' '+Sl1(28);
		end;
		if (Nu45='')and(Nu6='') then begin
			Nu456:='';
		end;
		if (O4='0')and(O5='0')and(O6='2') then begin
			Nu456:=Sl1(26)+' '+Sl1(28);
		end;
		if (O5='0')and(O6='0') then begin
			Nu456:=Nu4+' '+Sl1(30);
			if (O4='0') then begin
				Nu456:='';
			end;
			if (O4='1') then begin
				Nu456:=Sl1(28);
			end;
			if (O4='2') then begin
				Nu456:=Sl1(29);
			end;
		end;
		if (Na(O5+O4) in [3..10])and(O6='0') then begin
			Nu456:=Nu45+' '+Sl1(30);
		end;
		Nu7:=Nu456+Sp+Nu123;
		if (Nu123='') then begin
			Nu7:=Nu456;
		end;
		if (Nu456='') then begin
			Nu7:=Nu123;
		end;
		if (Nu123='')and(Nu456='') then begin
			Nu7:='';
		end;
		Result:=Nu7;
	end;

var
	U1,F1: array [0..9] of string;
	U,I:Integer;
	Sp,Cur,Nu,Nu0:string;
begin
	Sp:=' '+Sl1(1)+' ';
	Cur:=' '+Cr1;
	try
		if (Pos('-',A)>0) then begin
			A:=Copy(A,Pos('-',A)+1,Maxint);
		end;
		Nu:=A;
		Nu0:='00';
		if (Pos('.',A)>0) then begin
			Nu:=Copy(A,1,Pos('.',A)-1);
			Nu0:=Copy(A,Pos('.',A)+1,Maxint);
			if (Length(Nu0)=1) then begin
				Nu0:=Nu0+'0';
			end;
			if (Length(Nu0)>2) then begin
				Nu0:=Copy(Nu0,1,2);
				if (Na(Nu0)<99)and(Na(Nu0)>0) then begin
					Nu0:=(Na(Nu0)+1).Tostring;
				end;
			end;
			Nu0:='0000'+Nu0;
		end;
	except
		on E:Exception do Exit;
	end;
	if (Nu0<>'')and(Na(Nu0)>0) then begin
		if (Ne(Nu)=0) then begin
			Cur:='';
			F1[0]:=Artar(Nu0)+' '+Cr2;
		end else begin
			F1[0]:=Sp+Artar(Nu0)+' '+Cr2;
		end;
	end else begin
		F1[0]:='';
	end;
	if (Ne(A)=0) then begin
		Result:=Sl1(4)+Cur;
		Exit;
	end;
	if (Length(Nu)=1) then begin
		Nu:='00000'+Nu;
	end;
	if (Length(Nu)=2) then begin
		Nu:='0000'+Nu;
	end;
	if (Length(Nu)=3) then begin
		Nu:='000'+Nu;
	end;
	if (Length(Nu)=4) then begin
		Nu:='00'+Nu;
	end;
	if (Length(Nu)=5) then begin
		Nu:='0'+Nu;
	end;
	if ((Length(Nu)mod 6)>0) then begin
		Nu:=Stringofchar(Char('0'),6-(Length(Nu)mod 6))+Nu;
	end;
	U:=(Length(Nu)div 6);
	for I:=U-1 downto 0 do begin
		U1[U-I]:=Copy(Nu,(I*6)+1,6);
	end;
	if (U1[1]<>'')and(Na(U1[1])>0) then begin
		F1[1]:=Artar(U1[1]);
	end else begin
		F1[1]:='';
	end;
	if (U1[2]<>'')and(Na(U1[2])>0) then begin
		F1[2]:=Artar(U1[2])+' '+Sl1(31);
		if (Na(U1[2])=1) then begin
			F1[2]:=Sl1(31);
		end;
		if (Na(U1[2])=2) then begin
			F1[2]:=Sl1(32);
		end;
		if (Na(U1[2]) in [3..10]) then begin
			F1[2]:=Artar(U1[2])+' '+Sl1(33);
		end;
		if (F1[1]<>'') then begin
			F1[2]:=F1[2]+Sp;
		end;
	end else begin
		F1[2]:='';
	end;
	if (U1[3]<>'')and(Na(U1[3])>0) then begin
		F1[3]:=Artar(U1[3])+' '+Sl1(34);
		if (Na(U1[3])=1) then begin
			F1[3]:=Sl1(34);
		end;
		if (Na(U1[3])=2) then begin
			F1[3]:=Sl1(35);
		end;
		if (Na(U1[3]) in [3..10]) then begin
			F1[3]:=Artar(U1[3])+' '+Sl1(36);
		end;
		if (F1[1]<>'')or(F1[2]<>'') then begin
			F1[3]:=F1[3]+Sp;
		end;
	end else begin
		F1[3]:='';
	end;
	if (U1[4]<>'')and(Na(U1[4])>0) then begin
		F1[4]:=Artar(U1[4])+' '+Sl1(37);
		if (Na(U1[4])=1) then begin
			F1[4]:=Sl1(37);
		end;
		if (Na(U1[4])=2) then begin
			F1[4]:=Sl1(38);
		end;
		if (Na(U1[4]) in [3..10]) then begin
			F1[4]:=Artar(U1[4])+' '+Sl1(39);
		end;
		if (F1[1]<>'')or(F1[2]<>'')or(F1[3]<>'') then begin
			F1[4]:=F1[4]+Sp;
		end;
	end else begin
		F1[4]:='';
	end;
	if (U1[5]<>'')and(Na(U1[5])>0) then begin
		F1[5]:=Artar(U1[5])+' '+Sl1(40);
		if (Na(U1[4])=1) then begin
			F1[5]:=Sl1(40);
		end;
		if (Na(U1[5])=2) then begin
			F1[5]:=Sl1(41);
		end;
		if (Na(U1[5]) in [3..10]) then begin
			F1[5]:=Artar(U1[5])+' '+Sl1(42);
		end;
		if (F1[1]<>'')or(F1[2]<>'')or(F1[3]<>'')or(F1[4]<>'') then begin
			F1[5]:=F1[5]+Sp;
		end;
	end else begin
		F1[5]:='';
	end;
	Result:=F1[5]+F1[4]+F1[3]+F1[2]+F1[1]+Cur+F1[0];
end;

function Enam(A,Cr1,Cr2:string):string;
	function Entar(N:string):string;
	var
		U1: array [0..9] of string;
		Sp,Nu1,Nu2,Nu3,Nu4,Nu5,Nu6,Nu12,Nu123,Nu45,Nu456,Nu7,O1,O2,O3,O4,O5,O6:string;
		I:Integer;
	begin
		Sp:=' '+Sl1(1)+' ';
		O1:=N[6];
		O2:=N[5];
		O3:=N[4];
		O4:=N[3];
		O5:=N[2];
		O6:=N[1];
		// FIRST.
		U1[0]:='';
		for I:=1 to 9 do begin
			U1[I]:=Sl1(4+I);
		end;
		Nu1:=U1[Na(O1)];
		// SECOND.
		U1[0]:='';
		for I:=2 to 9 do begin
			U1[I]:=Sl1(22+I);
		end;
		Nu2:=U1[Na(O2)];
		Nu12:=Nu2+' '+Nu1;
		if (Nu1='') then begin
			Nu12:=Nu2;
		end;
		if (Nu2='') then begin
			Nu12:=Nu1;
		end;
		if (Nu1='')and(Nu2='') then begin
			Nu12:='';
		end;
		if (O2='1') then begin
			Nu12:=Sl1(14+Na(O1));
		end;
		// THIRD.
		U1[0]:='';
		for I:=1 to 9 do begin
			U1[I]:=Sl1(4+I)+' '+Sl1(32);
		end;
		Nu3:=U1[Na(O3)];
		Nu123:=Nu3+Sp+Nu12;
		if (Nu3='') then begin
			Nu123:=Nu12;
		end;
		if (Nu12='') then begin
			Nu123:=Nu3;
		end;
		if (Nu12='')and(Nu3='') then begin
			Nu123:='';
		end;
		// FORTH
		U1[0]:='';
		for I:=1 to 9 do begin
			U1[I]:=Sl1(4+I);
		end;
		Nu4:=U1[Na(O4)];
		// FIFTH.
		U1[0]:='';
		for I:=2 to 9 do begin
			U1[I]:=Sl1(22+I);
		end;
		Nu5:=U1[Na(O5)];
		Nu45:=Nu5+' '+Nu4;
		if (Nu4='') then begin
			Nu45:=Nu5;
		end;
		if (Nu5='') then begin
			Nu45:=Nu4;
		end;
		if (Nu4='')and(Nu5='') then begin
			Nu45:='';
		end;
		if (O5='1') then begin
			Nu45:=Sl1(14+Na(O4));
		end;
		// SIXTH.
		U1[0]:='';
		for I:=1 to 9 do begin
			U1[I]:=Sl1(4+I)+' '+Sl1(32);
		end;
		Nu6:=U1[Na(O6)];
		Nu456:=Nu6+Sp+Nu45+' '+Sl1(33);
		if (Nu6='') then begin
			Nu456:=Nu45+' '+Sl1(33);
		end;
		if (Nu45='') then begin
			Nu456:=Nu6+' '+Sl1(33);
		end;
		if (Nu45='')and(Nu6='') then begin
			Nu456:='';
		end;
		Nu7:=Nu456+Sp+Nu123;
		if (Nu123='') then begin
			Nu7:=Nu456;
		end;
		if (Nu456='') then begin
			Nu7:=Nu123;
		end;
		if (Nu123='')and(Nu456='') then begin
			Nu7:='';
		end;
		Result:=Nu7;
	end;

var
	U1,F1: array [0..9] of string;
	U,I:Integer;
	Sp,Cur,Nu,Nu0:string;
begin
	Sp:=' '+Sl1(1)+' ';
	Cur:=' '+Cr1;
	try
		if (Pos('-',A)>0) then begin
			A:=Copy(A,Pos('-',A)+1,Maxint);
		end;
		Nu:=A;
		Nu0:='00';
		if (Pos('.',A)>0) then begin
			Nu:=Copy(A,1,Pos('.',A)-1);
			Nu0:=Copy(A,Pos('.',A)+1,Maxint);
			if (Length(Nu0)=1) then begin
				Nu0:=Nu0+'0';
			end;
			if (Length(Nu0)>2) then begin
				Nu0:=Copy(Nu0,1,2);
				if (Na(Nu0)<99)and(Na(Nu0)>0) then begin
					Nu0:=(Na(Nu0)+1).Tostring;
				end;
			end;
			Nu0:='0000'+Nu0;
		end;
	except
		on E:Exception do Exit;
	end;
	if (Nu0<>'')and(Na(Nu0)>0) then begin
		if (Ne(Nu)=0) then begin
			Cur:='';
			F1[0]:=Entar(Nu0)+' '+Cr2;
		end else begin
			F1[0]:=Sp+Entar(Nu0)+' '+Cr2;
		end;
	end else begin
		F1[0]:='';
	end;
	if (Ne(A)=0) then begin
		Result:=Sl1(4)+Cur;
		Exit;
	end;
	if (Length(Nu)=1) then begin
		Nu:='00000'+Nu;
	end;
	if (Length(Nu)=2) then begin
		Nu:='0000'+Nu;
	end;
	if (Length(Nu)=3) then begin
		Nu:='000'+Nu;
	end;
	if (Length(Nu)=4) then begin
		Nu:='00'+Nu;
	end;
	if (Length(Nu)=5) then begin
		Nu:='0'+Nu;
	end;
	if ((Length(Nu)mod 6)>0) then begin
		Nu:=Stringofchar(Char('0'),6-(Length(Nu)mod 6))+Nu;
	end;
	U:=(Length(Nu)div 6);
	for I:=U-1 downto 0 do begin
		U1[U-I]:=Copy(Nu,(I*6)+1,6);
	end;
	if (U1[1]<>'')and(Na(U1[1])>0) then begin
		F1[1]:=Entar(U1[1]);
	end else begin
		F1[1]:='';
	end;
	if (U1[2]<>'')and(Na(U1[2])>0) then begin
		F1[2]:=Entar(U1[2])+' '+Sl1(34);
		if (F1[1]<>'') then begin
			F1[2]:=F1[2]+Sp;
		end;
	end else begin
		F1[2]:='';
	end;
	if (U1[3]<>'')and(Na(U1[3])>0) then begin
		F1[3]:=Entar(U1[3])+' '+Sl1(35);
		if (F1[1]<>'')or(F1[2]<>'') then begin
			F1[3]:=F1[3]+Sp;
		end;
	end else begin
		F1[3]:='';
	end;
	if (U1[4]<>'')and(Na(U1[4])>0) then begin
		F1[4]:=Entar(U1[4])+' '+Sl1(36);
		if (F1[1]<>'')or(F1[2]<>'')or(F1[3]<>'') then begin
			F1[4]:=F1[4]+Sp;
		end;
	end else begin
		F1[4]:='';
	end;
	if (U1[5]<>'')and(Na(U1[5])>0) then begin
		F1[5]:=Entar(U1[5])+' '+Sl1(37);
		if (F1[1]<>'')or(F1[2]<>'')or(F1[3]<>'')or(F1[4]<>'') then begin
			F1[5]:=F1[5]+Sp;
		end;
	end else begin
		F1[5]:='';
	end;
	Result:=F1[5]+F1[4]+F1[3]+F1[2]+F1[1]+Cur+F1[0];
end;

/// /////////////////// MAIN Functions ////////////////////////////////////

procedure Mimagelisthw;cdecl;
begin
	Gr0(Textinput[1],'|');
	S1[1]:=Copy(S1[1],Pos('t',S1[1])+1,2000);
	Il[Strtoint(S1[1])].Height:=Strtoint(S1[2]);
	Il[Strtoint(S1[1])].Width:=Strtoint(S1[3]);
end;

procedure Mimagelistmasked;cdecl;
begin
	Gr0(Textinput[1],'|');
	S1[1]:=Copy(S1[1],Pos('t',S1[1])+1,2000);
	Il[Strtoint(S1[1])].Masked:=Boolean(Strtoint(S1[2]));
end;

procedure Mimagelistdrawing;cdecl;
begin
	Gr0(Textinput[1],'|');
	S1[1]:=Copy(S1[1],Pos('t',S1[1])+1,2000);
	Il[Strtoint(S1[1])].Drawingstyle:=Tdrawingstyle(Strtoint(S1[2]));
end;

procedure Mimagelisttype;cdecl;
begin
	Gr0(Textinput[1],'|');
	S1[1]:=Copy(S1[1],Pos('t',S1[1])+1,2000);
	Il[Strtoint(S1[1])].Imagetype:=Timagetype(Strtoint(S1[2]));
end;

procedure Mimagelistbkc;cdecl;
begin
	Gr0(Textinput[1],'|');
	S1[1]:=Copy(S1[1],Pos('t',S1[1])+1,2000);
	Il[Strtoint(S1[1])].Bkcolor:=Getcolor(S1[2]);
end;

procedure Mimagelistclear;cdecl;
begin
	Gr0(Textinput[1],'|');
	S1[1]:=Copy(S1[1],Pos('t',S1[1])+1,2000);
	Il[Strtoint(S1[1])].Clear;
end;

procedure Mimagelistcount;cdecl;
begin
	Textoutput:='';
	Gr0(Textinput[1],'|');
	S1[1]:=Copy(S1[1],Pos('t',S1[1])+1,2000);
	Textoutput:=Inttostr(Il[Strtoint(S1[1])].Count);
end;

procedure Ildeleteimage;cdecl;
var
	I:Integer;
begin
	Gr0(Textinput[1],'|');
	S1[1]:=Copy(S1[1],Pos('t',S1[1])+1,2000);
	for I:=1 to Gr0(S1[2],',') do begin
		Il[Strtoint(S1[1])].Delete(Strtoint(S1[I]));
	end;
end;

procedure Ilmoveimage;cdecl;
var
	I:Integer;
	Ims:Timagelist;
	J,Ind:Integer;
begin
	Gr0(Textinput[1],'|');
	S1[1]:=Copy(S1[1],Pos('t',S1[1])+1,2000);
	Ims:=Il[Strtoint(S1[1])];
	Ind:=Strtoint(S1[3]);
	J:=Gr0(S1[2],',');
	for I:=1 to J do begin
		Ims.Move(Strtoint(S1[I]),Ind+I-1);
	end;
	Ims:=nil;
end;

procedure Ilreplacefsingle;cdecl;
var
	I:Integer;
	Ims:Timagelist;
	Ig:Timage;
	Masks,Bitmap,Bitmap1:Tbitmap;
	J:Integer;
	Trans,S3,S4:string;
	Ni: array [1..5000] of Integer;
	Ficon:Ticon;
	Largeicon0,Smallicon0:Hicon;
begin
	Gr0(Textinput[1],'|');
	S1[1]:=Copy(S1[1],Pos('t',S1[1])+1,2000);
	Ims:=Il[Strtoint(S1[1])];
	Trans:=S1[2];
	S3:=S1[3];
	S4:=S1[4];
	if (S3<>'')and(S4<>'') then begin
		J:=Gr0(S1[3],',');
		for I:=1 to J do begin
			Ni[I]:=Strtoint(S1[I]);
		end;
		Gr0(S4,',');
		Ig:=Timage.Create(Amdf);
		Ig.Autosize:=True;
		for I:=1 to J do begin
			if (Lowercase(Extractfileext(S1[I]))='.ico') then begin
				try
					Ficon:=Ticon.Create;
					Extracticonex(Pchar(S1[I]),0,Largeicon0,Smallicon0,1);
					Ficon.Handle:=Largeicon0;
					Ims.Replaceicon(Ni[I],Ficon);
				finally Ficon.Free;
				end;
			end else begin
				try
					Ig.Picture.Loadfromfile(S1[I]);
					Bitmap:=Tbitmap.Create;
					Bitmap.Pixelformat:=Pf32bit;
					Bitmap1:=Tbitmap.Create;
					Bitmap1.Pixelformat:=Pf32bit;
					Masks:=Tbitmap.Create;
					Masks.Pixelformat:=Pf32bit;
					Bitmap.Setsize(Ig.Picture.Graphic.Width,Ig.Picture.Graphic.Height);
					Bitmap.Canvas.Draw(0,0,Ig.Picture.Graphic);
					if (Trans='1') then begin
						Bitmap.Canvas.Brush.Color:=Bitmap.Canvas.Pixels[0,Bitmap.Height-1];
						Bitmap.Canvas.Fillrect(Rect(0,0,Bitmap.Width,Bitmap.Height));
						Bitmap.Canvas.Draw(0,0,Ig.Picture.Graphic);
						Bitmap1.Setsize(Ims.Width,Ims.Height);
						Stretchblt(Bitmap1.Canvas.Handle,0,0,Bitmap1.Width,Bitmap1.Height,Bitmap.Canvas.Handle,0,0,Bitmap.Width,
							Bitmap.Height,Srccopy);
						Masks.Assign(Bitmap1);
						Masks.Canvas.Brush.Color:=Bitmap.Canvas.Pixels[0,Bitmap.Height-1];
						Masks.Monochrome:=True;
						Ims.Replace(Ni[I],Bitmap1,Masks);
					end else begin
						Bitmap1.Setsize(Ims.Width,Ims.Height);
						Stretchblt(Bitmap1.Canvas.Handle,0,0,Bitmap1.Width,Bitmap1.Height,Bitmap.Canvas.Handle,0,0,Bitmap.Width,
							Bitmap.Height,Srccopy);
						Ims.Replace(Ni[I],Bitmap1,nil);
					end;
				finally
					Bitmap.Free;
					Bitmap1.Free;
					Masks.Free;
				end;
			end;
		end;
		Ig.Free;
	end;
	Ims:=nil;
	Trans:='';
	S3:='';
	S4:='';
end;

procedure Ilreplacefdivisible;cdecl;
var
	I:Integer;
	Mask,Image,Bmp,Bmp1:Tbitmap;
	Imm:Timage;
	Il1:Timagelist;
	Mx,My,X,Y,Xx,Yy,Hi,Wi,Ro,J,M,N:Integer;
	St1,S2,S5:string;
	Acolor:Tcolor;
	Ii: array [1..5000] of Integer;
	Pi: array [1..5000] of Integer;
begin
	Gr0(Textinput[1],'|');
	S2:=S1[2];
	S5:=S1[5];
	St1:=S1[6];
	S1[1]:=Copy(S1[1],Pos('t',S1[1])+1,2000);
	Il1:=Il[Strtoint(S1[1])];
	if (S1[3]='') then begin
		Hi:=Il1.Height;
	end else begin
		Hi:=Strtoint(S1[3]);
	end;
	if (S1[4]='') then begin
		Wi:=Il1.Width;
	end else begin
		Wi:=Strtoint(S1[4]);
	end;
	if (S2<>'')and(S5<>'')and(St1<>'') then begin
		Ro:=Gr0(S2,',');
		for I:=1 to Ro do begin
			Ii[I]:=Strtoint(S1[I]);
		end;
		J:=Gr0(S5,',');
		for I:=1 to J do begin
			Pi[I]:=Strtoint(S1[I]);
		end;
		Imm:=Timage.Create(Amdf);
		Imm.Autosize:=True;
		Imm.Picture.Loadfromfile(St1);
		if (Ro>J) then begin
			Ro:=J;
		end;
		for I:=1 to Ro do begin
			Mask:=Tbitmap.Create;
			Mask.Pixelformat:=Pf32bit;
			Image:=Tbitmap.Create;
			Image.Pixelformat:=Pf32bit;
			Bmp:=Tbitmap.Create;
			Bmp.Pixelformat:=Pf32bit;
			Bmp1:=Tbitmap.Create;
			Bmp1.Pixelformat:=Pf32bit;
			try
				Image.Setsize(Imm.Picture.Graphic.Width,Imm.Picture.Graphic.Height);
				Image.Canvas.Draw(0,0,Imm.Picture.Graphic);
				Acolor:=Image.Canvas.Pixels[0,Image.Height-1];
				if (Hi>0)and(Wi>0) then begin
					X:=Wi;
					Y:=Hi;
				end else begin
					X:=Il1.Width;
					Y:=Il1.Height;
				end;
				Mx:=X-(Image.Width mod X);
				My:=Y-(Image.Height mod Y);
				if (Mx<>X)or(My<>Y) then begin
					Image.Setsize(Imm.Picture.Graphic.Width+Mx,Imm.Picture.Graphic.Height+My);
					Image.Canvas.Brush.Color:=Acolor;
					Image.Canvas.Fillrect(Rect(0,0,Image.Width,Image.Height));
					Image.Canvas.Draw(Mx div 2,My div 2,Imm.Picture.Graphic);
				end;
				Bmp.Setsize(X,Y);
				Bmp1.Setsize(Il1.Width,Il1.Height);
				Xx:=0;
				Yy:=0;
				M:=Trunc(Pi[I] div(Image.Width div X));
				N:=(Image.Width div X);
				Yy:=Y*M;
				Xx:=X*(Pi[I]-(M*N)-1);
				if (Pi[I]=(M*N)) then begin
					M:=M-1;
					Yy:=Y*M;
					Xx:=X*(Pi[I]-(M*N)-1);
				end;
				Bmp.Canvas.Draw(-Xx,-Yy,Image);
				Stretchblt(Bmp1.Canvas.Handle,0,0,Bmp1.Width,Bmp1.Height,Bmp.Canvas.Handle,0,0,Bmp.Width,Bmp.Height,Srccopy);
				Mask.Assign(Bmp1);
				Mask.Canvas.Brush.Color:=Acolor;
				Mask.Monochrome:=True;
				Il1.Replace(Ii[I],Bmp1,Mask);
			finally
				Bmp.Free;
				Mask.Free;
				Image.Free;
			end;
		end;
		Imm.Free;
	end;
	St1:='';
	Il1:=nil;
	S2:='';
	S5:='';
end;

procedure Ilreplacefromrs;cdecl;
var
	I:Integer;
	Ic,Ro1,J1:Integer;
	Iicon:Ticon;
	Largeicon,Smallicon:Hicon;
	Ext,Ph1,S2,S3:string;
	Im:Timagelist;
	Ir: array [1..5000] of Integer;
	Pr: array [1..5000] of Integer;
begin
	Gr0(Textinput[1],'|');
	S2:=S1[2];
	S3:=S1[3];
	Ph1:=S1[4];
	S1[1]:=Copy(S1[1],Pos('t',S1[1])+1,2000);
	Im:=Il[Strtoint(S1[1])];
	if (S2<>'')and(S3<>'')and(Ph1<>'') then begin
		Ro1:=Gr0(S2,',');
		for I:=1 to Ro1 do begin
			Ir[I]:=Strtoint(S1[I]);
		end;
		J1:=Gr0(S3,',');
		for I:=1 to J1 do begin
			Pr[I]:=Strtoint(S1[I]);
		end;
		if (Ro1>J1) then begin
			Ro1:=J1;
		end;
		Iicon:=Ticon.Create;
		Ext:=Lowercase(Extractfileext(Ph1));
		if (Ext='.exe')or(Ext='.dll')or(Ext='.icl') then begin
			Ic:=Extracticonex(Pchar(Ph1),-1,Largeicon,Smallicon,0);
			for I:=1 to Ro1 do begin
				if (Pr[I]<=Ic) then begin
					Extracticonex(Pchar(Ph1),Pr[I],Largeicon,Smallicon,1);
					Iicon.Releasehandle;
					Iicon.Handle:=Largeicon;
					Im.Replaceicon(Ir[I],Iicon);
				end;
			end;
		end;
		Iicon.Free;
		Ext:='';
		Ph1:='';
		S2:='';
		S3:='';
	end;
end;

procedure Iladdsingle;cdecl;
var
	I:Integer;
	J,Aa1:Integer;
	Ig:Timage;
	Masks,Bitmap,Bitmap1:Tbitmap;
	Trans:string;
	Ficon:Ticon;
	Largeicon1,Smallicon1:Hicon;
begin
	Gr0(Textinput[1],'|');
	S1[1]:=Copy(S1[1],Pos('t',S1[1])+1,2000);
	Aa1:=Strtoint(S1[1]);
	Trans:=S1[2];
	Textoutput:='';
	if (S1[3]>'') then begin
		J:=Gr0(S1[3],',');
		Ig:=Timage.Create(Amdf);
		Ig.Autosize:=True;
		for I:=1 to J do begin
			if (Lowercase(Extractfileext(S1[I]))='.ico') then begin
				try
					Ficon:=Ticon.Create;
					Extracticonex(Pchar(S1[I]),0,Largeicon1,Smallicon1,1);
					Ficon.Handle:=Largeicon1;
					Il[Aa1].Addicon(Ficon);
				finally Ficon.Free;
				end;
			end else begin
				try
					Ig.Picture.Loadfromfile(S1[I]);
					Bitmap:=Tbitmap.Create;
					Bitmap.Pixelformat:=Pf32bit;
					Bitmap1:=Tbitmap.Create;
					Bitmap1.Pixelformat:=Pf32bit;
					Masks:=Tbitmap.Create;
					Masks.Pixelformat:=Pf32bit;
					Bitmap.Setsize(Ig.Picture.Graphic.Width,Ig.Picture.Graphic.Height);
					Bitmap.Canvas.Draw(0,0,Ig.Picture.Graphic);
					if (Trans='1') then begin
						Bitmap.Canvas.Brush.Color:=Bitmap.Canvas.Pixels[0,Bitmap.Height-1];
						Bitmap.Canvas.Fillrect(Rect(0,0,Bitmap.Width,Bitmap.Height));
						Bitmap.Canvas.Draw(0,0,Ig.Picture.Graphic);
						Bitmap1.Setsize(Il[Aa1].Width,Il[Aa1].Height);
						Stretchblt(Bitmap1.Canvas.Handle,0,0,Bitmap1.Width,Bitmap1.Height,Bitmap.Canvas.Handle,0,0,Bitmap.Width,
							Bitmap.Height,Srccopy);
						Masks.Assign(Bitmap1);
						Masks.Canvas.Brush.Color:=Bitmap.Canvas.Pixels[0,Bitmap.Height-1];
						Masks.Monochrome:=True;
						Il[Aa1].Add(Bitmap1,Masks);
					end else begin
						Bitmap1.Setsize(Il[Aa1].Width,Il[Aa1].Height);
						Stretchblt(Bitmap1.Canvas.Handle,0,0,Bitmap1.Width,Bitmap1.Height,Bitmap.Canvas.Handle,0,0,Bitmap.Width,
							Bitmap.Height,Srccopy);
						Il[Aa1].Add(Bitmap1,nil);
					end;
				finally
					Bitmap.Free;
					Bitmap1.Free;
					Masks.Free;
				end;
			end;
		end;
		Ig.Free;
		Textoutput:=Inttostr(Il[Aa1].Count)+'|'+Inttostr(J)+'|';
	end;
	Trans:='';
end;

procedure Iladddivisible;cdecl;
var
	I:Integer;
	Mask,Image,Bmp,Bmp1:Tbitmap;
	Imm:Timage;
	Il1:Timagelist;
	Mx,My,X,Y,Xx,Yy,Cnt,Me,Hi,Wi,Noi,Ro:Integer;
	St,Sof:string;
	Acolor:Tcolor;
begin
	Textoutput:='';
	Gr0(Textinput[1],'|');
	Noi:=Strtoint(S1[5]);
	St:=S1[6];
	S1[1]:=Copy(S1[1],Pos('t',S1[1])+1,2000);
	Il1:=Il[Strtoint(S1[1])];
	if (S1[3]='') then begin
		Hi:=Il1.Height;
	end else begin
		Hi:=Strtoint(S1[3]);
	end;
	if (S1[4]='') then begin
		Wi:=Il1.Width;
	end else begin
		Wi:=Strtoint(S1[4]);
	end;
	Assert((St<>'')and Assigned(Il1));
	if (S1[2]='1') then begin
		Il1.Clear;
	end;
	if (Noi<0) then begin
		Noi:=0;
	end;
	Ro:=Gr0(St,',');
	for I:=1 to Ro do begin
		Mask:=Tbitmap.Create;
		Mask.Pixelformat:=Pf32bit;
		Image:=Tbitmap.Create;
		Image.Pixelformat:=Pf32bit;
		Bmp:=Tbitmap.Create;
		Bmp.Pixelformat:=Pf32bit;
		Bmp1:=Tbitmap.Create;
		Bmp1.Pixelformat:=Pf32bit;
		Imm:=Timage.Create(Amdf);
		Imm.Autosize:=True;
		Imm.Picture.Loadfromfile(S1[I]);
		try
			Image.Setsize(Imm.Picture.Graphic.Width,Imm.Picture.Graphic.Height);
			Image.Canvas.Draw(0,0,Imm.Picture.Graphic);
			Acolor:=Image.Canvas.Pixels[0,Image.Height-1];
			if (Hi>0)and(Wi>0) then begin
				X:=Wi;
				Y:=Hi;
			end else begin
				X:=Il1.Width;
				Y:=Il1.Height;
			end;
			Mx:=X-(Image.Width mod X);
			My:=Y-(Image.Height mod Y);
			if (Mx<>X)or(My<>Y) then begin
				Image.Setsize(Imm.Picture.Graphic.Width+Mx,Imm.Picture.Graphic.Height+My);
				Image.Canvas.Brush.Color:=Acolor;
				Image.Canvas.Fillrect(Rect(0,0,Image.Width,Image.Height));
				Image.Canvas.Draw(Mx div 2,My div 2,Imm.Picture.Graphic);
			end;
			Bmp.Setsize(X,Y);
			Bmp1.Setsize(Il1.Width,Il1.Height);
			if Noi>0 then begin
				Cnt:=Noi;
				Me:=Cnt;
			end else begin
				Cnt:=(Image.Width div X)*(Image.Height div Y);
				Me:=Cnt;
			end;
			Xx:=0;
			Yy:=0;
			while (Cnt>0)and(Yy<Image.Height) do begin
				Bmp.Canvas.Draw(-Xx,-Yy,Image);
				Stretchblt(Bmp1.Canvas.Handle,0,0,Bmp1.Width,Bmp1.Height,Bmp.Canvas.Handle,0,0,Bmp.Width,Bmp.Height,Srccopy);
				Mask.Assign(Bmp1);
				Mask.Canvas.Brush.Color:=Acolor;
				Mask.Monochrome:=True;
				Il1.Add(Bmp1,Mask);
				Dec(Cnt);
				Inc(Xx,X);
				if Xx+X>Image.Width then begin
					Xx:=0;
					Inc(Yy,Y);
				end;
			end;
		finally
			Bmp.Free;
			Mask.Free;
			Image.Free;
			Imm.Free;
		end;
		Sof:=Sof+Extractfilename(S1[I])+' : '+Inttostr(Me)+' ,';
	end;
	Textoutput:=Inttostr(Il1.Count)+'|'+Sof+'|';
	St:='';
	Sof:='';
end;

procedure Iladdfromrs;cdecl;
var
	I,J,Iconcount,Sn,En,Re:Integer;
	Iicon:Ticon;
	Largeicon,Smallicon:Hicon;
	Ext,Ph,Sul:string;
	Im:Timagelist;
begin
	Textoutput:='';
	Gr0(Textinput[1],'|');
	S1[1]:=Copy(S1[1],Pos('t',S1[1])+1,2000);
	Im:=Il[Strtoint(S1[1])];
	Sn:=Strtoint(S1[3]);
	En:=Strtoint(S1[4]);
	Ph:=S1[5];
	Iicon:=Ticon.Create;
	if (S1[2]='1') then begin
		Im.Clear;
	end;
	if (Sn<0) then begin
		Sn:=0;
	end;
	Re:=Gr0(Ph,',');
	for I:=1 to Re do begin
		Ext:=Lowercase(Extractfileext(S1[I]));
		if (Ext='.exe')or(Ext='.dll')or(Ext='.icl') then begin
			Iconcount:=Extracticonex(Pchar(S1[I]),-1,Largeicon,Smallicon,0);
			if (En<1) then begin
				En:=Iconcount-1;
			end;
			for J:=Sn to En do begin
				Extracticonex(Pchar(S1[I]),J,Largeicon,Smallicon,1);
				Iicon.Releasehandle;
				Iicon.Handle:=Largeicon;
				Im.Addicon(Iicon);
			end;
			Sul:=Sul+Extractfilename(S1[I])+' : '+Inttostr(Iconcount)+',';
			Textoutput:=Inttostr(Im.Count)+'|'+Sul+'|';
		end;
	end;
	Iicon.Free;
	Ext:='';
	Sul:='';
	Ph:='';
end;

procedure Ilgetassingle;cdecl;
var
	I:Integer;
	Hi,Wi,Sm,Em:Integer;
	Al,Gl:Timagelist;
	Extn,Fo:string;
	Gb,Bitmap,Bitmap1:Tbitmap;
	Gj:Tjpegimage;
	Gp:Tpngimage;
	Gg:Tgifimage;
	Gi,Gi1:Ticon;
	Ac,Nc:Tcolor;
begin
	Gr0(Textinput[1],'|');
	S1[1]:=Copy(S1[1],Pos('t',S1[1])+1,2000);
	Al:=Il[Strtoint(S1[1])];
	Fo:=S1[8];
	if (S1[2]='') then begin
		Extn:='.bmp';
	end else begin
		Extn:=Lowercase(S1[2]);
	end;
	if (S1[3]='') then begin
		Hi:=0;
	end else begin
		Hi:=Strtoint(S1[3]);
	end;
	if (S1[4]='') then begin
		Wi:=0;
	end else begin
		Wi:=Strtoint(S1[4]);
	end;
	if (S1[5]='') then begin
		Sm:=0;
	end else begin
		Sm:=Strtoint(S1[5]);
	end;
	if (S1[6]='') then begin
		Em:=0;
	end else begin
		Em:=Strtoint(S1[6]);
	end;
	if (S1[7]='')or(S1[7]='0') then begin
		Nc:=Clnone;
	end else begin
		Nc:=Getcolor(S1[7]);
	end;
	if (Fo<>'') then begin
		if (Directoryexists(Fo,True)=False) then begin
			Forcedirectories(Fo);
		end;
		if (Hi<1)or(Wi<1) then begin
			Hi:=Al.Height;
			Wi:=Al.Width;
		end;
		if (Em<0) then begin
			Em:=Al.Count-1;
		end;
		Ac:=Al.Bkcolor;
		Al.Bkcolor:=Nc;
		for I:=Sm to Em do begin
			Bitmap:=Tbitmap.Create;
			Bitmap.Pixelformat:=Pf32bit;
			Bitmap1:=Tbitmap.Create;
			Bitmap1.Pixelformat:=Pf32bit;
			Bitmap1.Setsize(Wi,Hi);
			try
				Al.Getbitmap(I,Bitmap);
				Stretchblt(Bitmap1.Canvas.Handle,0,0,Bitmap1.Width,Bitmap1.Height,Bitmap.Canvas.Handle,0,0,Bitmap.Width,
					Bitmap.Height,Srccopy);
				Bitmap.Transparent:=True;
				Bitmap1.Transparent:=True;
				if (Extn='bmp') then begin
					Gb:=Tbitmap.Create;
					Gb.Pixelformat:=Pf32bit;
					Gb.Assign(Bitmap1);
					Gb.Savetofile(Fo+'\myimg'+Inttostr(I)+'.bmp');
					Gb.Free;
				end;
				if (Extn='jpg')or(Extn='jpeg') then begin
					Gj:=Tjpegimage.Create;
					Gj.Performance:=Jpbestquality;
					Gj.Pixelformat:=Jf24bit;
					Gj.Assign(Bitmap1);
					Gj.Savetofile(Fo+'\myimg'+Inttostr(I)+'.jpg');
					Gj.Free;
				end;
				if (Extn='png') then begin
					Gp:=Tpngimage.Create;
					Gp.Assign(Bitmap1);
					Gp.Savetofile(Fo+'\myimg'+Inttostr(I)+'.png');
					Gp.Free;
				end;
				if (Extn='gif') then begin
					Gg:=Tgifimage.Create;
					Gg.Assign(Bitmap1);
					Gg.Savetofile(Fo+'\myimg'+Inttostr(I)+'.gif');
					Gg.Free;
				end;
				if (Extn='ico') then begin
					Gi:=Ticon.Create;
					Gi1:=Ticon.Create;
					Gl:=Timagelist.Create(nil);
					Gl.Colordepth:=Cd32bit;
					Gl.Setsize(Wi,Hi);
					Al.Geticon(I,Gi1);
					Gl.Addicon(Gi1);
					Gl.Geticon(0,Gi);
					Gi.Savetofile(Fo+'\myimg'+Inttostr(I)+'.ico');
					Gi.Free;
					Gi1.Free;
					Gl.Free;
				end;
			finally
				Bitmap.Free;
				Bitmap1.Free;
			end;
		end;
		Al.Bkcolor:=Ac;
	end;
	Extn:='';
	Fo:='';
end;

procedure Ilgetasdivisible;cdecl;
var
	I:Integer;
	Hi,Wi,Sm1,Em1,J,X,Y,X1,Y1,Cou:Integer;
	Al,Gl:Timagelist;
	Extn,Fl:string;
	Gb1,Bitmap,Bitmap1,Bitmap2:Tbitmap;
	Gj1:Tjpegimage;
	Gp1:Tpngimage;
	Gg1:Tgifimage;
	Gi:Ticon;
	Ac,Nc:Tcolor;
begin
	Gr0(Textinput[1],'|');
	S1[1]:=Copy(S1[1],Pos('t',S1[1])+1,2000);
	Al:=Il[Strtoint(S1[1])];
	Fl:=S1[8];
	if (Fl<>'') then begin
		Extn:=Lowercase(Extractfileext(Fl));
	end;
	if (S1[2]='') then begin
		S1[2]:='0';
	end;
	if (S1[3]='') then begin
		Hi:=0;
	end else begin
		Hi:=Strtoint(S1[3]);
	end;
	if (S1[4]='') then begin
		Wi:=0;
	end else begin
		Wi:=Strtoint(S1[4]);
	end;
	if (S1[5]='') then begin
		Sm1:=0;
	end else begin
		Sm1:=Strtoint(S1[5]);
	end;
	if (S1[6]='') then begin
		Em1:=0;
	end else begin
		Em1:=Strtoint(S1[6]);
	end;
	if (S1[7]='')or(S1[7]='0') then begin
		Nc:=Clnone;
	end else begin
		Nc:=Getcolor(S1[7]);
	end;
	if (Fl<>'') then begin
		if (Hi<1)or(Wi<1) then begin
			Hi:=Al.Height;
			Wi:=Al.Width;
		end;
		if (Em1<0) then begin
			Em1:=Al.Count-1;
		end;
		Ac:=Al.Bkcolor;
		Al.Bkcolor:=Nc;
		Cou:=(Em1-Sm1)+1;
		Bitmap:=Tbitmap.Create;
		Bitmap.Pixelformat:=Pf32bit;
		if (S1[2]='0') then begin
			Y:=Trunc(Sqrt(Cou));
			X:=Y;
			while (Cou>(Y*X)) do begin
				Inc(X,1);
			end;
			Bitmap.Setsize(X*Wi,Y*Hi);
			X1:=0;
			Y1:=0;
			J:=Sm1;
			Bitmap.Canvas.Brush.Color:=Nc;
			Bitmap.Canvas.Fillrect(Rect(0,0,Bitmap.Width,Bitmap.Height));
			while ((Cou>0)and(Y1<Bitmap.Height)and(J<=Em1)) do begin
				try
					Bitmap1:=Tbitmap.Create;
					Bitmap1.Pixelformat:=Pf32bit;
					Bitmap2:=Tbitmap.Create;
					Bitmap2.Pixelformat:=Pf32bit;
					Bitmap2.Setsize(Wi,Hi);
					Al.Getbitmap(J,Bitmap1);
					Stretchblt(Bitmap2.Canvas.Handle,0,0,Bitmap2.Width,Bitmap2.Height,Bitmap1.Canvas.Handle,0,0,Bitmap1.Width,
						Bitmap1.Height,Srccopy);
					Bitmap.Canvas.Draw(X1,Y1,Bitmap2);
					Inc(X1,Wi);
					Dec(Cou,1);
					Inc(J,1);
					if (X1=X*Wi) then begin
						X1:=0;
						Inc(Y1,Hi);
					end;
				finally
					Bitmap1.Free;
					Bitmap2.Free;
				end;
			end;
		end;
		if (S1[2]='1') then begin
			Bitmap.Setsize(Wi*Cou,Hi);
			J:=0;
			for I:=Sm1 to Em1 do begin
				try
					Bitmap1:=Tbitmap.Create;
					Bitmap1.Pixelformat:=Pf32bit;
					Bitmap2:=Tbitmap.Create;
					Bitmap2.Pixelformat:=Pf32bit;
					Bitmap2.Setsize(Wi,Hi);
					Al.Getbitmap(I,Bitmap1);
					Stretchblt(Bitmap2.Canvas.Handle,0,0,Bitmap2.Width,Bitmap2.Height,Bitmap1.Canvas.Handle,0,0,Bitmap1.Width,
						Bitmap1.Height,Srccopy);
					Bitmap.Canvas.Draw(J*Wi,0,Bitmap2);
					Inc(J,1);
				finally
					Bitmap1.Free;
					Bitmap2.Free;
				end;
			end;
		end;
		if (S1[2]='2') then begin
			Bitmap.Setsize(Wi,Hi*Cou);
			J:=0;
			for I:=Sm1 to Em1 do begin
				try
					Bitmap1:=Tbitmap.Create;
					Bitmap1.Pixelformat:=Pf32bit;
					Bitmap2:=Tbitmap.Create;
					Bitmap2.Pixelformat:=Pf32bit;
					Bitmap2.Setsize(Wi,Hi);
					Al.Getbitmap(I,Bitmap1);
					Stretchblt(Bitmap2.Canvas.Handle,0,0,Bitmap2.Width,Bitmap2.Height,Bitmap1.Canvas.Handle,0,0,Bitmap1.Width,
						Bitmap1.Height,Srccopy);
					Bitmap.Canvas.Draw(0,J*Hi,Bitmap2);
					Inc(J,1);
				finally
					Bitmap1.Free;
					Bitmap2.Free;
				end;
			end;
		end;
		if (Extn<>'') then begin
			if (Extn='.bmp') then begin
				Gb1:=Tbitmap.Create;
				Gb1.Pixelformat:=Pf32bit;
				Gb1.Assign(Bitmap);
				Gb1.Savetofile(Fl);
				Gb1.Free;
			end;
			if (Extn='.jpg')or(Extn='.jpeg') then begin
				Gj1:=Tjpegimage.Create;
				Gj1.Performance:=Jpbestquality;
				Gj1.Pixelformat:=Jf24bit;
				Gj1.Assign(Bitmap);
				Gj1.Savetofile(Fl);
				Gj1.Free;
			end;
			if (Extn='.png') then begin
				Gp1:=Tpngimage.Create;
				Gp1.Assign(Bitmap);
				Gp1.Savetofile(Fl);
				Gp1.Free;
			end;
			if (Extn='.gif') then begin
				Gg1:=Tgifimage.Create;
				Gg1.Assign(Bitmap);
				Gg1.Savetofile(Fl);
				Gg1.Free;
			end;
			if (Extn='.ico') then begin
				Gl:=Timagelist.Create(nil);
				Gl.Colordepth:=Cd32bit;
				Gi:=Ticon.Create;
				Gl.Setsize(Bitmap.Width,Bitmap.Height);
				Gl.Bkcolor:=Nc;
				Gl.Add(Bitmap,nil);
				Gl.Geticon(0,Gi);
				Gi.Transparent:=True;
				Gi.Savetofile(Fl);
				Gi.Free;
				Gl.Free;
			end;
		end;
		Bitmap.Free;
		Al.Bkcolor:=Ac;
	end;
	Extn:='';
	Fl:='';
end;

procedure Sdateformat;cdecl;
begin
	if (Textinput[1]>'') then begin
		Formatsettings.Dateseparator:=Textinput[1][1];
	end;
	if (Textinput[2]>'') then begin
		Formatsettings.Shortdateformat:=Textinput[2];
	end;

end;

procedure Stimeformat;cdecl;
begin
	if (Textinput[1]>'') then begin
		Formatsettings.Timeseparator:=Textinput[1][1];
	end;
	if (Textinput[2]>'') then begin
		Formatsettings.Shorttimeformat:=Textinput[2];
	end;

end;

procedure Gdateformat;cdecl;
begin
	Textoutput:='';
	Textoutput:=Formatsettings.Dateseparator+'|'+Formatsettings.Shortdateformat+'|';
end;

procedure Gtimeformat;cdecl;
begin
	Textoutput:='';
	Textoutput:=Formatsettings.Timeseparator+'|'+Formatsettings.Shorttimeformat+'|';
end;

procedure Comparedatetime;cdecl;
var
	I:Integer;
	C: array [1..6] of Integer;
	D1,D2:Extended;
begin
	Textoutput:='';
	Gr0(Textinput[1],'|');
	I:=Strtoint(S1[3]);
	D1:=Strtodatetime(S1[1]);
	D2:=Strtodatetime(S1[2]);
	S1[1]:=Inttostr(Yearsbetween(D1,D2));
	S1[2]:=Inttostr(Monthsbetween(D1,D2));
	S1[3]:=Inttostr(Daysbetween(D1,D2));
	S1[4]:=Inttostr(Hoursbetween(D1,D2));
	S1[5]:=Inttostr(Minutesbetween(D1,D2));
	S1[6]:=Inttostr(Secondsbetween(D1,D2));
	S1[7]:=Inttostr(Millisecondsbetween(D1,D2));
	S1[8]:=Inttostr(Comparedate(D1,D2));
	C[1]:=Strtoint(S1[2])-(Strtoint(S1[1])*12);
	C[2]:=Strtoint64(S1[4])-(Strtoint(S1[3])*24);
	C[3]:=Strtoint64(S1[5])-(Strtoint(S1[3])*1440)-(C[2]*60);
	C[4]:=Strtoint64(S1[6])-(Strtoint(S1[3])*86400)-(C[2]*3600)-(C[3]*60);
	C[5]:=Strtoint64(S1[7])-(Strtoint(S1[3])*86400000)-(C[2]*3600000)-(C[3]*60000)-(C[4]*1000);
	if (I>0)and(I<9) then begin
		Textoutput:=S1[I];
	end;
	if (I=9) then begin
		for I:=1 to 5 do begin
			S1[9]:=S1[9]+Inttostr(C[I])+'|';
		end;
		Textoutput:=S1[1]+'|'+S1[9];
	end;
	if (I=0) then begin
		for I:=1 to 7 do begin
			S1[9]:=S1[9]+S1[I]+'|';
		end;
		Textoutput:=S1[9];
	end;

end;

procedure Comparedatetimenum;cdecl;
var
	I:Integer;
	C: array [1..6] of Integer;
	D1,D2:Extended;
	L: array [1..15] of Word;
begin
	Textoutput:='';
	Gr0(Textinput[1],'|');
	I:=Strtoint(S1[3]);
	L[1]:=Strtoint(Copy(S1[1],0,4));
	L[2]:=Strtoint(Copy(S1[1],5,2));
	L[3]:=Strtoint(Copy(S1[1],7,2));
	L[4]:=Strtoint(Copy(S1[1],9,2));
	L[5]:=Strtoint(Copy(S1[1],11,2));
	L[6]:=Strtoint(Copy(S1[1],13,2));
	L[7]:=Strtoint(Copy(S1[1],15,3));
	L[8]:=Strtoint(Copy(S1[2],0,4));
	L[9]:=Strtoint(Copy(S1[2],5,2));
	L[10]:=Strtoint(Copy(S1[2],7,2));
	L[11]:=Strtoint(Copy(S1[2],9,2));
	L[12]:=Strtoint(Copy(S1[2],11,2));
	L[13]:=Strtoint(Copy(S1[2],13,2));
	L[14]:=Strtoint(Copy(S1[2],15,3));
	D1:=Encodedatetime(L[1],L[2],L[3],L[4],L[5],L[6],L[7]);
	D2:=Encodedatetime(L[8],L[9],L[10],L[11],L[12],L[13],L[14]);
	S1[1]:=Inttostr(Yearsbetween(D1,D2));
	S1[2]:=Inttostr(Monthsbetween(D1,D2));
	S1[3]:=Inttostr(Daysbetween(D1,D2));
	S1[4]:=Inttostr(Hoursbetween(D1,D2));
	S1[5]:=Inttostr(Minutesbetween(D1,D2));
	S1[6]:=Inttostr(Secondsbetween(D1,D2));
	S1[7]:=Inttostr(Millisecondsbetween(D1,D2));
	S1[8]:=Inttostr(Comparedate(D1,D2));
	C[1]:=Strtoint(S1[2])-(Strtoint(S1[1])*12);
	C[2]:=Strtoint64(S1[4])-(Strtoint(S1[3])*24);
	C[3]:=Strtoint64(S1[5])-(Strtoint(S1[3])*1440)-(C[2]*60);
	C[4]:=Strtoint64(S1[6])-(Strtoint(S1[3])*86400)-(C[2]*3600)-(C[3]*60);
	C[5]:=Strtoint64(S1[7])-(Strtoint(S1[3])*86400000)-(C[2]*3600000)-(C[3]*60000)-(C[4]*1000);
	if (I>0)and(I<9) then begin
		Textoutput:=S1[I];
	end;
	if (I=9) then begin
		for I:=1 to 5 do begin
			S1[9]:=S1[9]+Inttostr(C[I])+'|';
		end;
		Textoutput:=S1[1]+'|'+S1[9];
	end;
	if (I=0) then begin
		for I:=1 to 7 do begin
			S1[9]:=S1[9]+S1[I]+'|';
		end;
		Textoutput:=S1[9];
	end;

end;

procedure Filetodatetimefunc;cdecl;
begin
	Textoutput:='';
	S1[1]:=Textinput[1];
	Textoutput:=Formatdatetime(Formatsettings.Shortdateformat+'|'+Formatsettings.Shorttimeformat+'|',
		Filedatetodatetime(Strtoint(S1[1])));

end;

procedure Datetimetoftfunc;cdecl;
var
	I:Integer;
	Y: array [0..22] of Integer;
begin
	Textoutput:='';
	Gr0(Textinput[1],'|');
	Y[1]:=Monthoftheyear(Strtodatetime(S1[1]+S1[2]));
	Y[2]:=Dayofthemonth(Strtodatetime(S1[1]+S1[2]));
	Y[3]:=Dayoftheyear(Strtodatetime(S1[1]+S1[2]));
	Y[4]:=Houroftheday(Strtodatetime(S1[1]+S1[2]));
	Y[5]:=Hourofthemonth(Strtodatetime(S1[1]+S1[2]));
	Y[6]:=Houroftheyear(Strtodatetime(S1[1]+S1[2]));
	Y[7]:=Minuteofthehour(Strtodatetime(S1[1]+S1[2]));
	Y[8]:=Minuteoftheday(Strtodatetime(S1[1]+S1[2]));
	Y[9]:=Minuteofthemonth(Strtodatetime(S1[1]+S1[2]));
	Y[10]:=Minuteoftheyear(Strtodatetime(S1[1]+S1[2]));
	Y[11]:=Secondoftheminute(Strtodatetime(S1[1]+S1[2]));
	Y[12]:=Secondofthehour(Strtodatetime(S1[1]+S1[2]));
	Y[13]:=Secondoftheday(Strtodatetime(S1[1]+S1[2]));
	Y[14]:=Secondofthemonth(Strtodatetime(S1[1]+S1[2]));
	Y[15]:=Secondoftheyear(Strtodatetime(S1[1]+S1[2]));
	Y[16]:=Millisecondofthesecond(Strtodatetime(S1[1]+S1[2]));
	Y[17]:=Millisecondoftheminute(Strtodatetime(S1[1]+S1[2]));
	Y[18]:=Millisecondofthehour(Strtodatetime(S1[1]+S1[2]));
	Y[19]:=Millisecondoftheday(Strtodatetime(S1[1]+S1[2]));
	Y[20]:=Millisecondofthemonth(Strtodatetime(S1[1]+S1[2]));
	Y[21]:=Millisecondoftheyear(Strtodatetime(S1[1]+S1[2]));
	Textoutput:=Inttostr(Y[Strtoint(S1[3])]);
	if (Strtoint(S1[3])=0) then begin
		for I:=1 to 21 do begin
			S1[4]:=S1[4]+Inttostr(Y[I])+'|';
			Textoutput:=S1[4];
		end;
	end;
	for I:=0 to 21 do begin
		Y[I]:=0;
	end;
end;

procedure Gdayofyear;cdecl;
var
	Y0:Extended;
begin
	Textoutput:='';
	Gr0(Textinput[1],'|');
	Y0:=Endofaday(Strtoint(S1[1]),Strtoint(S1[2]));
	Textoutput:=Formatdatetime(Formatsettings.Shortdateformat,Y0);

end;

procedure Gdateba;cdecl;
begin
	Textoutput:='';
	Gr0(Textinput[1],'|');
	Textoutput:=Datetostr(Strtodate(S1[1])+Strtoint(S1[2]));

end;

procedure Fdatetime;cdecl;
begin
	Textoutput:='';
	Numoutput:=0;
	Gr0(Textinput[1],'|');
	Textoutput:=Formatdatetime(S1[2],Strtodatetime(S1[1]));
	Numoutput:=Datetimetofiledate(Strtodate(S1[1]));

end;

procedure Isvaliddate;cdecl;
var
	Y1,Y2,Y3,Y4,Y5,Y6,Y7,Y8:Integer;
begin
	Textoutput:='';
	S1[2]:='0';
	S1[1]:=Textinput[1];
	if (Strtoint(Copy(S1[1],0,4))>1000)and(Strtoint(Copy(S1[1],5,2))<13)and(Strtoint(Copy(S1[1],5,2))>0) then begin
		S1[2]:=Inttostr(Daysinamonth(Strtoint(Copy(S1[1],0,4)),Strtoint(Copy(S1[1],5,2))));
	end;
	if Charinset(S1[1][1],['1'..'9']) then Y1:=0
	else Y1:=1;
	if Charinset(S1[1][2],['0'..'9']) then Y2:=0
	else Y2:=1;
	if Charinset(S1[1][3],['0'..'9']) then Y3:=0
	else Y3:=1;
	if Charinset(S1[1][4],['0'..'9']) then Y4:=0
	else Y4:=1;
	if Charinset(S1[1][5],['0'..'1']) then Y5:=0
	else Y5:=1;
	if Charinset(S1[1][6],['0'..'9']) then Y6:=0
	else Y6:=1;
	if (S1[1][5]='1')and(Charinset(S1[1][6],['3'..'9'])) then Y6:=1;
	if Charinset(S1[1][7],['0'..S1[2][1]]) then Y7:=0
	else Y7:=1;
	if Charinset(S1[1][8],['0'..'9']) then Y8:=0
	else Y8:=1;
	if (S1[1][7]=S1[2][1])and(Strtoint(S1[1][8])>Strtoint(S1[2][2])) then Y8:=1;
	Textoutput:=Inttostr(Y1+Y2+Y3+Y4+Y5+Y6+Y7+Y8);
end;

procedure Isvalidtime;cdecl;
var
	Y1,Y2,Y3,Y4,Y5,Y6,Y7,Y8,Y9:Integer;
begin
	Textoutput:='';
	S1[1]:=Textinput[1];
	if Charinset(S1[1][1],['0'..'2']) then Y1:=0
	else Y1:=1;
	if Charinset(S1[1][2],['0'..'9']) then Y2:=0
	else Y2:=1;
	if (S1[1][1]='2')and(Strtoint(S1[1][2])>3) then Y2:=1;
	if Charinset(S1[1][3],['0'..'5']) then Y3:=0
	else Y3:=1;
	if Charinset(S1[1][4],['0'..'9']) then Y4:=0
	else Y4:=1;
	if Charinset(S1[1][5],['0'..'5']) then Y5:=0
	else Y5:=1;
	if Charinset(S1[1][6],['0'..'9']) then Y6:=0
	else Y6:=1;
	if Charinset(S1[1][7],['0'..'9']) then Y7:=0
	else Y7:=1;
	if Charinset(S1[1][8],['0'..'9']) then Y8:=0
	else Y8:=1;
	if Charinset(S1[1][9],['0'..'9']) then Y9:=0
	else Y9:=1;
	Textoutput:=Inttostr(Y1+Y2+Y3+Y4+Y5+Y6+Y7+Y8+Y9);
end;

procedure Isvaliddatetimenum;cdecl;
var
	Y1,Y2,Y3,Y4,Y5,Y6,Y7,Y8,Y9,Y10,Y11,Y12,Y13,Y14,Y15,Y16,Y17:Integer;
begin
	Textoutput:='';
	S1[2]:='0';
	S1[1]:=Textinput[1];
	if (Strtoint(Copy(S1[1],0,4))>1000)and(Strtoint(Copy(S1[1],5,2))<13)and(Strtoint(Copy(S1[1],5,2))>0) then begin
		S1[2]:=Inttostr(Daysinamonth(Strtoint(Copy(S1[1],0,4)),Strtoint(Copy(S1[1],5,2))));
	end;
	if Charinset(S1[1][1],['1'..'9']) then Y1:=0
	else Y1:=1;
	if Charinset(S1[1][2],['0'..'9']) then Y2:=0
	else Y2:=1;
	if Charinset(S1[1][3],['0'..'9']) then Y3:=0
	else Y3:=1;
	if Charinset(S1[1][4],['0'..'9']) then Y4:=0
	else Y4:=1;
	if Charinset(S1[1][5],['0'..'1']) then Y5:=0
	else Y5:=1;
	if Charinset(S1[1][6],['0'..'9']) then Y6:=0
	else Y6:=1;
	if (S1[1][5]='1')and(Charinset(S1[1][6],['3'..'9'])) then Y6:=1;
	if Charinset(S1[1][7],['0'..S1[2][1]]) then Y7:=0
	else Y7:=1;
	if Charinset(S1[1][8],['0'..'9']) then Y8:=0
	else Y8:=1;
	if (S1[1][7]=S1[2][1])and(Strtoint(S1[1][8])>Strtoint(S1[2][2])) then Y8:=1;
	if Charinset(S1[1][9],['0'..'2']) then Y9:=0
	else Y9:=1;
	if Charinset(S1[1][10],['0'..'9']) then Y10:=0
	else Y10:=1;
	if (S1[1][9]='2')and(Strtoint(S1[1][10])>3) then Y10:=1;
	if Charinset(S1[1][11],['0'..'5']) then Y11:=0
	else Y11:=1;
	if Charinset(S1[1][12],['0'..'9']) then Y12:=0
	else Y12:=1;
	if Charinset(S1[1][13],['0'..'5']) then Y13:=0
	else Y13:=1;
	if Charinset(S1[1][14],['0'..'9']) then Y14:=0
	else Y14:=1;
	if Charinset(S1[1][15],['0'..'9']) then Y15:=0
	else Y15:=1;
	if Charinset(S1[1][16],['0'..'9']) then Y16:=0
	else Y16:=1;
	if Charinset(S1[1][17],['0'..'9']) then Y17:=0
	else Y17:=1;
	Textoutput:=Inttostr(Y1+Y2+Y3+Y4+Y5+Y6+Y7+Y8+Y9+Y10+Y11+Y12+Y13+Y14+Y15+Y16+Y17);
end;

/// ///////////////////////DIALOGS /////////////////////////

{ function Msg1(F:TWinControl;ca,ti,te:String;ic:Integer;bca:String;df:Integer;ck:String;
	var ch1:Boolean;al:Integer=1;tu:Integer=0):Integer;
	var
	CC,minh,maxh,minw,maxw,th,tw,tp,lf,sd,hs,vs,I,BW:Integer;
	PN:TPanel;
	RT:TRichEdit;
	MSGF:TForm;
	IMG:TImage;
	begin
	minh:=100;
	minw:=250;
	maxh:=Screen.WorkAreaHeight-10;
	maxw:=Screen.WorkAreaWidth-10;
	Result:=0;
	try
	MSGF:=TForm.Create(F);
	with MSGF do begin
	Parent:=nil;
	BorderStyle:=bsDialog;
	BorderIcons:=[];
	Position:=poScreenCenter;
	FormStyle:=fsStayOnTop;
	Font:=AMDF.Font;
	BiDiMode:=AMDF.BiDiMode;
	Icon:=Application.Icon;
	Tag:=1;
	Color:=clWindow; // AMDF.Color;
	Name:='MSG1';
	Caption:='    '+ca+'    ';
	KeyPreview:=True;
	AutoSize:=True;
	Font.Color:=clBlack;
	Font.Style:=[];
	Width:=minw;
	Height:=minh;
	Constraints.MinWidth:=minw;
	Constraints.MinHeight:=minh;
	Constraints.MaxWidth:=maxw;
	Constraints.MAXHeight:=maxh;
	OnActivate:=AMDF.user4;
	OnKeyPress:=AMDF.user8;
	th:=Height-ClientHeight;
	tw:=Width-ClientWidth;
	end;
	PN:=TPanel.Create(MSGF);
	with PN do begin
	Parent:=MSGF;
	AlignWithMargins:=True;
	TabStop:=False;
	Top:=0;
	Left:=0;
	BevelOuter:=bvNone;
	Height:=54;
	Constraints.MaxWidth:=maxw-tw;
	Name:='PL1';
	ShowCaption:=False;
	end;
	IMG:=TImage.Create(PN);
	with IMG do begin
	Parent:=PN;
	Center:=True;
	AlignWithMargins:=True;
	Height:=32;
	Width:=32;
	Top:=0;
	Left:=0;
	if (MSGF.BiDiMode=bdLeftToRight) then begin
	Align:=alLeft;
	end
	else begin
	Align:=alRight;
	end;
	if (ic>0) then begin
	Picture.Icon.Handle:=SIC1(ic);
	end;
	end;
	with TLabel.Create(PN) do begin
	Parent:=PN;
	Font.Size:=11;
	Caption:=' '+ti+' ';
	Name:='TL1';
	Font.Color:=clHighlight;
	Height:=54;
	WordWrap:=True;
	Constraints.MAXHeight:=54;
	Constraints.MaxWidth:=PN.Constraints.MaxWidth-60;
	Layout:=tlCenter;
	if (MSGF.BiDiMode=bdLeftToRight) then begin
	Align:=alLeft;
	end
	else begin
	Align:=alRight;
	end;
	end;
	PN.Width:=IMG.Width+TLabel(PN.FindComponent('TL1')).Width+12;
	RT:=TRichEdit.Create(MSGF);
	with RT do begin
	Parent:=MSGF;
	BorderStyle:=bsNone;
	AlignWithMargins:=True;
	ReadOnly:=True;
	PlainText:=False;
	ParentColor:=True;
	ScrollBars:=TScrollStyle(2);
	OnKeyPress:=AMDF.user8;
	TabStop:=False;
	Name:='RT1';
	Top:=57;
	if (al=1) then begin
	Alignment:=taCenter;
	end;
	Lines.Text:=te;
	ClientHeight:=(RT.Font.Size-4+(RT.Lines.Count+1)*-1*(RT.Font.Height-3))+18;
	ClientWidth:=MSGF.ClientWidth+18;
	hs:=(GetWindowlong(Handle,GWL_STYLE)and WS_HSCROLL);
	vs:=(GetWindowlong(Handle,GWL_STYLE)and WS_VSCROLL);
	end;
	with TLabel.Create(RT) do begin
	Parent:=RT;
	AlignWithMargins:=True;
	Visible:=False;
	Constraints.MaxWidth:=maxw-tw-12;
	Align:=alTop;
	if (pos(' ',te)=0) then begin
	if (pos(#13,te)<>0)or(Length(te)<100) then begin
	Caption:=te;
	end
	else begin
	for I:=0 to Round(Length(te)/100) do begin
	insert(#13,te,(I+1)*100);
	end;
	Caption:=WrapText(te,100);
	end;
	end
	else begin
	Caption:=te;
	end;
	Caption:=te;
	WordWrap:=True;
	if (al=1) then begin
	Alignment:=taCenter;
	end;
	RT.ClientHeight:=Height+22;
	RT.ClientWidth:=Width+5;
	Free;
	end;
	CC:=GR0(bca,'|');
	tp:=103;
	lf:=0;
	BW:=70;
	if (CC>0) then begin
	for I:=0 to CC-1 do begin
	sd:=lf*(BW+10);
	lf:=lf+1;
	if ((sd+((BW+10)*2))>(maxw-tw)) then begin
	lf:=0;
	tp:=tp+30;
	end;
	if (tp>Round((maxh-th)/2)) then begin
	CC:=I+1;
	Break
	end;
	end;
	end;
	if (RT.Height>maxh-th-tp) then begin
	RT.Height:=maxh-th-tp-30;
	end;
	if (RT.Width>maxw-tw-6) then begin
	RT.Width:=maxw-tw-6;
	end;
	with TCheckBox.Create(MSGF) do begin
	Parent:=MSGF;
	AlignWithMargins:=True;
	Top:=RT.Top+RT.Height+5;
	Width:=RT.ClientWidth-6;
	Left:=5;
	Name:='CHB';
	Caption:=ck;
	if (ck='') then begin
	Visible:=False;
	end;
	end;
	if (CC>0) then begin
	tp:=63;
	lf:=0;
	for I:=1 to CC do begin
	with TButton.Create(MSGF) do begin
	Parent:=MSGF;
	AlignWithMargins:=True;
	Caption:=S0[I];
	ModalResult:=I;
	Width:=BW;
	Height:=25;
	Left:=lf*(BW+10);
	lf:=lf+1;
	Top:=RT.Height+tp+25;
	Default:=False;
	TabOrder:=I-1;
	if (I=df)and(df>0)and(df<=CC) then begin
	Name:='BR';
	ElevationRequired:=True;
	Default:=True;
	end;
	if ((Left+(Width+5)*2)>(maxw-tw)) then begin
	lf:=0;
	tp:=tp+30;
	end;
	end;
	end;
	end;
	if (tu>0) then begin
	MSGF.Tag:=tu;
	with TTimer.Create(MSGF) do begin
	Enabled:=True;
	Interval:=500;
	// OnTimer:=AMDF.TT1;
	Name:='TM1';
	end;
	end;
	PSN1(ic-1);
	MSGF.ActiveControl:=TButton(MSGF.FindComponent('BR'));
	Result:=MSGF.ShowModal;
	if not(ck='') then begin
	ch1:=TCheckBox(MSGF.FindComponent('CHB')).Checked;
	end;
	FreeAndNil(MSGF);
	except
	on E:Exception do Result:=0;
	end;
	end; }

function Msg1(F:Twincontrol;Ca,Ti,Te:string;Ic:Integer;Bca:string;Df:Integer;Ck:string;var Ch1:Boolean;Al:Integer=1;
	Tu:Integer=0):Integer;
var
	Rs:Ttsg;
begin
	Rs:=Msg2(F,Ca,Ti,Te,Ic,Bca,Df,'',True,Tu);
	Ch1:=Rs.Uchecked;
	Result:=Rs.Ubuttonmodal;
end;

function Msg2(F:Twincontrol;Ucaption,Utitle,Utext:string;Uicon:Integer=I_n;Ubns:string='';Udfb:Integer=1;Urd:string='';
	Uck:Boolean=False;Utimeout:Integer=0):Ttsg;
var
	Cc,I:Integer;
begin
	Result.Ubuttonmodal:=0;
	Result.Uradioid:=0;
	Result.Uchecked:=False;
	Result.Uhyperresult:=False;
	Result.Uurl:='';
	try
		// TStyleManager.SystemHooks:=TStyleManager.SystemHooks-[shDialogs];
		with Ttaskdialog.Create(F) do begin
			Caption:=Ucaption;
			Title:=Utitle;
			Text:=Utext;
			if Uck then Verificationtext:=Sfl1(136);
			Expandbuttoncaption:=Sfl1(139);
			Commonbuttons:=[];
			Flags:=[Tfenablehyperlinks,Tfcanbeminimized,Tfrtllayout,Tfcallbacktimer,Tfallowdialogcancellation,
				Tfnodefaultradiobutton];
			if (Uicon>900000) then begin
				case Uicon of
					I_n:Uicon:=0;
					I_w:Uicon:=1;
					I_e:Uicon:=2;
					I_i:Uicon:=3;
					I_s:Uicon:=4;
				end;
				Mainicon:=Ttaskdialogicon(Uicon);
			end else begin
				Flags:=Flags+[Tfusehiconmain];
				Custommainicon.Handle:=Sic1(Uicon);
			end;
			Cc:=Gr0(Ubns,'|');
			if (Cc>0) then
				for I:=1 to Cc do begin
					with Ttaskdialogbuttonitem(Buttons.Add) do begin
						Caption:=S0[I];
						default:=False;
						Modalresult:=I+100;
						if (I=Udfb)and(Udfb>0)and(Udfb<=Cc) then begin
							Elevationrequired:=True;
							default:=True;
						end;
					end;
				end;
			Cc:=Gr0(Urd,'|');
			if (Cc>0) then
				for I:=1 to Cc do begin
					with Ttaskdialogradiobuttonitem(Radiobuttons.Add) do begin
						Caption:=S0[I];
						default:=False;
					end;
				end;
			if (Utimeout>0) then begin
				Tag:=Utimeout;
				Ontimer:=Amdf.Tt1;
			end;
			if (Uicon<90001) then Psn1(Uicon);
			Onbuttonclicked:=Amdf.Tkbuttonclicked;
			Onradiobuttonclicked:=Amdf.Tkradioclicked;
			Onverificationclicked:=Amdf.Tkvclicked;
			Onhyperlinkclicked:=Amdf.Tkhclicked;
			Uselatestcommondialogs:=False;
			if Execute then begin
				if (Radiobutton<>nil) then Result.Uradioid:=Radiobutton.Index+1;
				if (Button<>nil) then Result.Ubuttonmodal:=Button.Index+1;
				if Tfverificationflagchecked in Flags then Result.Uchecked:=True
				else Result.Uchecked:=False;
				if Tfenablehyperlinks in Flags then Result.Uhyperresult:=True;
				if Tfenablehyperlinks in Flags then Result.Uurl:=Url;
			end;
			// TStyleManager.SystemHooks:=TStyleManager.SystemHooks+[shDialogs];
			Free;
		end;
	except
		on E:Exception do Showmessage(E.Tostring);
	end;
end;

function Waitforms:Tform;
var
	Fgh:Tactivityindicator;
	Waitf:Tform;
begin
	Result:=nil;
	try
		Waitf:=Tform.Create(nil);
		Waitf.Parent:=nil;
		Waitf.Borderstyle:=Bssingle;
		Waitf.Formstyle:=Fsstayontop;
		Waitf.Position:=Poscreencenter;
		Waitf.Brush.Color:=Amdf.Color;
		Waitf.Bidimode:=Amdf.Bidimode;
		Waitf.Font:=Amdf.Font;
		Fgh:=Tactivityindicator.Create(Waitf);
		Fgh.Parent:=Waitf;
		Fgh.Left:=5;
		Fgh.Top:=5;
		Fgh.Indicatortype:=Aitsectorring;
		Fgh.Indicatorsize:=Aisxlarge;
		Fgh.Animate:=True;
		with Tlabel.Create(Waitf) do begin
			Parent:=Waitf;
			Autosize:=True;
			Parentbidimode:=True;
			Font.Size:=15;
			Font.Style:=Font.Style+[Fsbold];
			Transparent:=True;
			Layout:=Tlcenter;
			Alignment:=Tacenter;
			Caption:=Sfl1(23);
			name:='TF';
		end;
		Waitf.Alphablend:=True;
		Waitf.Alphablendvalue:=200;
		Setwindowlong(Waitf.Handle,Gwl_style,Getwindowlong(Waitf.Handle,Gwl_style)and not Ws_border and not Ws_sizebox and
			not Ws_dlgframe);
		Setwindowpos(Waitf.Handle,Hwnd_top,Waitf.Left,Waitf.Top,Waitf.Width,Waitf.Height,Swp_framechanged);
		// S6[1]:=Sfl1(23);
		Fgh.Indicatorsize:=Aisxlarge;
		Fgh.Indicatortype:=Aitsectorring;
		Waitf.Setbounds(0,0,300,Fgh.Height+15);
		Tlabel(Waitf.Findcomponent('TF')).Left:=Fgh.Left+Fgh.Width+40;
		Tlabel(Waitf.Findcomponent('TF')).Top:=Fgh.Top+((Fgh.Height-Tlabel(Waitf.Findcomponent('TF')).Height)div 2);
		if (Tmr[3]=nil) then begin
			Tmr[3]:=Ttimer.Create(Waitf);
			Tmr[3].Enabled:=False;
			Tmr[3].Interval:=500;
			Tmr[3].Ontimer:=Amdf.Tt2;
		end;
		Result:=Waitf;
		Waitf.Show;
		Poin1:=Disabletaskwindows(Waitf.Handle);
	except
		on E:Exception do
	end
end;

procedure Waitformh(Waitf:Tform);
begin
	if not(Waitf=nil) then begin
		Freeandnil(Tmr[3]);
		Enabletaskwindows(Poin1);
		Waitf.Close;
		Freeandnil(Waitf);
	end;
end;

procedure Opendialog;cdecl;
var
	I:Integer;
	Fn:string;
	Opendialog1:Topentextfiledialog;
begin
	Textoutput:='';
	Numoutput:=0;
	Gr0(Textinput[1],'|');
	Opendialog1:=Topentextfiledialog.Create(Amdf);
	Opendialog1.Title:=S0[1];
	Opendialog1.Filename:=S0[7];
	Opendialog1.Onshow:=Amdf.User2;
	if (S0[8]='1') then begin
		Opendialog1.Options:=[Ofhidereadonly,Ofallowmultiselect,Ofenablesizing];
	end else begin
		Opendialog1.Options:=[Ofhidereadonly,Ofenablesizing];
	end;
	Opendialog1.Filter:=Textinput[2];
	Opendialog1.Encodings.Clear;
	Opendialog1.Defaultext:='txt';
	Psn1(5);
	if Opendialog1.Execute() then begin
		if Fileexists(Opendialog1.Filename) then begin
			for I:=0 to Opendialog1.Files.Count-1 do begin
				Fn:=Fn+Opendialog1.Files.Strings[I]+',';
			end;
			Textoutput:=Copy(Fn,0,Length(Fn)-1);
			Numoutput:=Opendialog1.Files.Count;
		end else begin
			Textoutput:='';
			Numoutput:=0;
		end;
	end else begin
		Textoutput:='';
		Numoutput:=0;
	end;
	Opendialog1.Free;
	Fn:='';
end;

procedure Savedialog;
var
	I:Integer;
	Q1,Q2,Q3:string;
	Savedialog1:Tsavetextfiledialog;
begin
	Savedialog1:=Tsavetextfiledialog.Create(Amdf);
	Savedialog1.Title:='SAVE DIALOG';
	Savedialog1.Filename:='AMD';
	Savedialog1.Options:=[Ofenablesizing];
	Savedialog1.Filter:=
		'Bitmaps (*.bmp)|*.bmp|JPEG Images (*.jpeg)|*.jpeg|GIF Images (*.gif)|*.gif|PNG Images (*.png)|*.png|Icons (*.ico)|*.ico|Enhanced Metafiles (*.emf)|*.emf|Metafiles (*.wmf)|*.wmf|TIFF Images (*.tif)|*.tif|TIFF Images (*.tiff)|*.tiff||';
	Savedialog1.Encodings.Clear;
	Savedialog1.Defaultext:='txt';
	Savedialog1.Onshow:=Amdf.User2;
	Savedialog1.Fileeditstyle:=Fscombobox;
	Psn1(5);
	if Savedialog1.Execute() then begin
		I:=1;
		while Fileexists(Savedialog1.Filename) do begin
			Q1:=Extractfilepath(Savedialog1.Filename);
			Q2:=Extractfilename(Savedialog1.Filename);
			Q3:=Extractfileext(Savedialog1.Filename);
			Q2:=Copy(Q2,0,Pos('.',Q2)-1)+Inttostr(I);
			Savedialog1.Filename:=Q1+Q2+Q3;
			Inc(I,1);
		end;
		Textoutput:=Savedialog1.Filename;
		Numoutput:=1;
	end else begin
		Textoutput:='';
		Numoutput:=0;
	end;
	for I:=0 to Savedialog1.Componentcount-1 do begin
		S0[1]:=S0[1]+Savedialog1.Components[I].Tostring+'|'+Savedialog1.Components[I].Name+'|'+#13
	end;
	Showmessage(S0[1]);
	Savedialog1.Free;
	Q1:='';
	Q2:='';
	Q3:='';
end;

procedure Fontdialog;cdecl;
var
	Fontdialog1:Tfontdialog;
begin
	Textoutput:='';
	Gr0(Textinput[1],'|');
	Fontdialog1:=Tfontdialog.Create(Amdf);
	Fontdialog1.Device:=Fdboth;
	if (Textinput[1]<>'') then begin
		Fontdialog1.Font.Name:=S0[1];
		Fontdialog1.Font.Color:=Getcolor(S0[2]);
		Fontdialog1.Font.Size:=Strtoint(S0[3]);
		Fontdialog1.Font.Charset:=Strtoint(S0[4]);
		Fontdialog1.Font.Style:=Strtostyle(S0[5]);
	end;
	Psn1(5);
	if Fontdialog1.Execute then begin
		Textoutput:=Fontdialog1.Font.Name+'|'+Getrgb(Fontdialog1.Font.Color)+'|'+Inttostr(Fontdialog1.Font.Size)+'|'+
			Inttostr(Fontdialog1.Font.Charset)+'|'+Styletostr(Fontdialog1.Font.Style)+'|';
		Numoutput:=1;
	end else begin
		Textoutput:='';
		Numoutput:=0;
	end;
	Fontdialog1.Free;
end;

{ procedure FolderDialog; cdecl;
	var
	opt: TSelectDirExtOpts;
	begin
	TextOutput:='';
	GR0(TextInput[1],'|');
	opt:=[sdNewFolder,sdShowEdit,sdNewUI,sdShowShares,sdValidateDir];
	PSN1(5);
	if SelectDirectory(S0[1],S0[2],S0[3],opt,AMDF)then begin
	TextOutput:=S0[3];
	NumOutput:=1;
	end else begin
	TextOutput:='';               //Vcl.FileCtrl,
	NumOutput:=0;
	end;
	opt:=[];
	end; }

procedure Folderdialog;
begin
	with Tfileopendialog.Create(nil) do
		try
			Options:=[Fdopickfolders,Fdoforcepreviewpaneon,Fdoforcefilesystem,Fdoforceshowhidden,Fdoallowmultiselect];
			if Execute then Showmessage(Filename);
		finally Free;
		end;
end;

/// ///////////////////// Resources /////////////////////////////

function Stockresourcetype(Restype:Pchar):string;
var
	Resid:Cardinal absolute Restype;
begin
	if Resid in [1..24] then Result:=Restypenames[Resid]
	else Result:=Format('%d',[Nativeuint(Restype)]);

end;

function Aloadresorce(Ufile:Pchar;Urtype:Pchar=nil;Urname:Pchar=nil;Uwd:Pchar=nil;Uf:Word=0):Pris;
	function Enumreslangproc(Module:Hmodule;Restype,Resname:Pchar;Widlanguage:Word;List:Tstrings):Integer;stdcall;
	begin
		{ list.Add(PRIMARYLANGID(wIDLanguage).ToString);
			list.Add(SUBLANGID(wIDLanguage).ToString);
			list.Add(MAKELANGID(9,1).ToString); }
		if (Restyp<>nil)or(Resnme<>nil) then begin
			if (Ufl=3) then begin
				List.Add(Format('%d',[Widlanguage]));
			end;
			Reslng:=Widlanguage;
		end else begin
			if (Widlanguage=0) then begin
				List.Add('LANGUAGE NEUTRAL ,SUB_NEUTRAL');
			end else begin
				List.Add(Languages.Namefromlocaleid[Widlanguage]);
			end;
		end;
		Result:=1;
	end;

	function Enumresnamesproc(Module:Hmodule;Restype,Resname:Pchar;List:Tstrings):Integer;stdcall;
	var
		Pcd:Pchar;
		E:Ansistring;
	begin
		if (Restyp<>nil)and(Resnme<>nil) then begin
			Pcd:=Resname;
			if Is_intresource(Resname) then begin
				Resname:=Pchar(Format('#%d',[Nativeuint(Resname)]));
			end;
			if Sametext(Resname,Resnme) then begin
				if (Ufl=3) then begin
					Resname:=Pcd;
					Enumresourcelanguages(Module,Restype,Resname,@Enumreslangproc,Integer(List));
				end else begin
					if (Ufl=2)and Is_intresource(Resname) then begin
						Resname:=Pcd;
						Resname:=Pchar(Format('%d',[Nativeuint(Resname)]));
					end;
					List.Add(Resname);
				end;
			end;
		end else begin
			if not Is_intresource(Resname) then begin
				List.Add(Resname);
			end else begin
				if (Ufl=2) then begin
					List.Add(Format('%d',[Nativeuint(Resname)]));
				end else begin
					List.Add(Format('#%d',[Nativeuint(Resname)]));
				end;
			end;
			Enumresourcelanguages(Module,Restype,Resname,@Enumreslangproc,Integer(List));
		end;
		Result:=1;
	end;

	function Enumrestypesproc(Module:Hmodule;Restype:Pchar;List:Tstrings):Integer;stdcall;
	var
		N:Integer;
	begin
		if (Restyp<>nil) then begin
			if not Is_intresource(Restype)and not Is_intresource(Restyp) then begin
				if Sametext(Restype,Restyp) then begin
					if (Ufl=1) then begin
						List.Add(Restype);
					end else begin
						Enumresourcenames(Module,Restype,@Enumresnamesproc,Integer(List));
					end;
				end;
			end else begin
				if (Nativeuint(Restype)=Nativeuint(Restyp)) then begin
					if (Ufl=1) then begin
						List.Add(Format('%d',[Nativeuint(Restype)]));
					end else begin
						Enumresourcenames(Module,Restype,@Enumresnamesproc,Integer(List));
					end;
				end;
			end;
		end else begin
			if not Is_intresource(Restype) then begin
				List.Add(Restype);
			end else begin
				List.Add(Format('%d: %s',[Nativeuint(Restype),Stockresourcetype(Restype)]));
			end;
			Enumresourcenames(Module,Restype,@Enumresnamesproc,Integer(List));
		end;
		Result:=1;
	end;

var
	S,I,Cu,Id:Integer;
	F,G:string;
	Lst:Tstringlist;
	An:Ansistring;
	Sm:Tresourcestream;
	Bl:Boolean;
begin
	try
		Restyp:=Urtype;
		Resnme:=Urname;
		Reslng:=0;
		Ufl:=Uf;
		Bl:=True;
		Lst:=Tstringlist.Create;
		Result:=New(Pris);
		Result.Umoudle:=Loadlibraryex(Ufile,0,Load_library_as_datafile);
		if (Result.Umoudle<>0) then begin
			if not Is_intresource(Restyp) then begin
				S:=Strtouint64def(Restyp,0);
				if (S=0) then begin
					S:=Indexstr(Uppercase(string(Restyp)),Restypenames)+1;
					if (S>0) then begin
						Restyp:=Pchar(S);
					end;
				end else begin
					Restyp:=Pchar(S);
				end;
			end;
			if (Resnme<>nil) then begin
				if not Is_intresource(Resnme) then begin
					S:=Strtouint64def(Resnme,0);
					if (S<>0) then begin
						Resnme:=Pchar('#'+string(Resnme));
					end;
				end else begin
					Resnme:=Pchar(Format('#%d',[Nativeuint(Resnme)]));
				end;
			end;
			case Uf of
				2:Bl:=Enumresourcenames(Result.Umoudle,Restyp,@Enumresnamesproc,Lparam(Lst));
				3:Bl:=Enumresourcelanguages(Result.Umoudle,Restyp,Resnme,@Enumreslangproc,Lparam(Lst));
			else Bl:=Enumresourcetypes(Result.Umoudle,@Enumrestypesproc,Lparam(Lst));
			end;
			if Bl then begin
				Result.Ulist:=Lst.Text;
				if (Urtype<>nil)and(Urname<>nil)and(Lst.Count<>0)and(Uf=0) then begin
					Result.Ulang:=Reslng;
					if Is_intresource(Restyp) then begin
						case Nativeuint(Restyp) of
							1,2,3,12,14:begin
									if (Uwd<>nil) then begin
										if Is_intresource(Uwd) then begin
											Id:=Nativeuint(Uwd);
										end else begin
											S:=Strtouint64def(Uwd,0);
											if (S<>0) then begin
												Id:=S;
											end else begin
												Id:=0;
											end;
										end;
									end;
									case Nativeuint(Restyp) of
										1,12:I:=Image_cursor;
										2:I:=Image_bitmap;
										3,14:I:=Image_icon;
									end;

									Result.Udatas.Uhk:=I;
									S:=Loadimage(Result.Umoudle,Resnme,I,Id,Id,Lr_defaultcolor);
									Result.Udatas.Uh:=S;
								end;
							6:begin
									if not Is_intresource(Urname) then begin
										S:=Strtouint64def(Urname,0);
										if (S<>0) then begin
											Resnme:=Pchar(S);
										end else begin
											Resnme:=Urname;
											// StrScan()
											if (string(Resnme)[1]='#') then begin
												Resnme:=Pchar(Copy(string(Resnme),2,Maxint));
												S:=Strtouint64def(Resnme,0);
												if (S<>0) then begin
													Resnme:=Pchar(S);
												end else begin
													Exit;
												end;
											end;
										end;
									end;
									if (Uwd<>nil) then begin
										if Is_intresource(Uwd) then begin
											Id:=Nativeuint(Uwd);
										end else begin
											S:=Strtouint64def(Uwd,0);
											if (S<>0) then begin
												Id:=S;
											end else begin
												Id:=0;
											end;
										end;
									end;
									if (Id<>0) then begin
										Cu:=((Nativeuint(Resnme)*16)-16);
										if not((Id-Cu) in [0..15])and(Id in [1..16]) then begin
											Id:=Cu+Id-1;
										end else begin
											if not((Id-Cu) in [0..15]) then Id:=Cu;
										end;
										G:='';
										F:='';
										Setlength(F,1024);
										S:=Loadstring(Result.Umoudle,Id,Pchar(F),Length(F));
										Setlength(F,S);
										G:=F;
									end else begin
										G:='';
										for I:=1 to 16 do begin
											F:='';
											Setlength(F,1024);
											Cu:=((Nativeuint(Resnme)*16)-17+I);
											S:=Loadstring(Result.Umoudle,Cu,Pchar(F),Length(F));
											Setlength(F,S);
											G:=G+Cu.Tostring+' - '+F+#13;
										end;
									end;
									Result.Udatas.Udata:=Pchar(G);
								end;
							23,24:begin
									with Tresourcestream.Create(Result.Umoudle,Resnme,Restyp) do begin
										Position:=0;
										if (Uwd<>nil) then begin
											if not Is_intresource(Uwd) then begin
												Savetofile(Uwd);
											end;
										end;
										Setlength(An,Size);
										read(An[1],Size);
										Free;
									end;
									Result.Udatas.Udata:=Pchar(An);
								end;
							16:begin
									/// ////  VERSION.
								end;
						end;
					end else begin
						Sm:=Tresourcestream.Create(Result.Umoudle,Resnme,Restyp);
						Sm.Position:=0;
						if (Uwd<>nil) then begin
							if not Is_intresource(Uwd) then begin
								Tresourcestream(Sm).Savetofile(Uwd);
							end;
						end;
						Sm.Free;
					end;
				end;
			end;
		end;
		Lst.Free;
	except
		on E:Exception do Showmessage(E.Tostring);
	end;
end;

function Asaveresorce(Urpath,Urtype,Urname:Pchar;Sm:Tstream):Boolean;
var
	Hupdate:Thandle;
	Module:Hmodule;
	Me:Tmemorystream;
	S:Integer;
	Hf:Hfile;
	Filename:Pchar;
	Ulag,Datalength,Dw:Dword;
	Data:Pointer;
	P:string;
	Bm:Tbitmap;
	function Enumreslangproc(Module:Hmodule;Restype,Resname:Pchar;Widlanguage:Word;Lparam:Integer):Boolean;stdcall;
	begin
		Pword(Lparam)^:=Widlanguage;
		Result:=False;
	end;

begin
	Result:=False;
	if not(Fileexists(Urpath)) then Exit;
	try
		if not Is_intresource(Urname) then begin
			S:=Strtouint64def(Urname,0);
			if (S<>0) then begin
				Urname:=Pchar(S);
			end else if (string(Urname)[1]='#') then begin
				P:=string(Urname);
				Delete(P,1,1);
				S:=Strtouint64def(P,0);
				if (S<>0) then begin
					Urname:=Pchar(S);
				end;
			end;
		end;
		if not Is_intresource(Urtype) then begin
			S:=Strtouint64def(Urtype,0);
			if (S=0) then begin
				S:=Indexstr(Urtype,Restypenames)+1;
				if (S>0) then begin
					Urtype:=Pchar(S);
				end;
			end else begin
				Urtype:=Pchar(S);
			end;
		end;
		Module:=Loadlibraryex(Urpath,0,Load_library_as_datafile);
		Enumresourcelanguages(Module,Urtype,Urname,@Enumreslangproc,Integer(@Ulag));
		Freelibrary(Module);
		if Is_intresource(Urtype) then begin
			case Nativeuint(Urtype) of
				2:begin
						Filename:='H:\printer\AADELPHI\photos\Bitmap\0419\310.bmp';
						P:=Getenvironmentvariable('TEMP')+'\TMP.bmp';
						Bm:=Tbitmap.Create;
						Bm.Loadfromfile(Filename);
						if Fileexists(P) then Deletefile(P);
						Bm.Savetofile(P);
						Bm.Free;
						Filename:=Pchar(P);
						Hf:=Createfile(Filename,Generic_read,0,nil,Open_existing,File_attribute_normal,0);
						if Hf<>Invalid_handle_value then begin
							Datalength:=Getfilesize(Hf,nil)-Sizeof(Bitmapfileheader);
							Getmem(Data,Datalength);
							Setfilepointer(Hf,Sizeof(Bitmapfileheader),nil,0);
							Readfile(Hf,Data^,Datalength,Dw,nil);
							Closehandle(Hf);
							if Fileexists(P) then Deletefile(P);
							Hupdate:=Beginupdateresource(Urpath,False);
							Win32check(Hupdate<>0);
							Win32check(Updateresource(Hupdate,Urtype,Urname,Ulag,Data,Datalength));
							if not Endupdateresource(Hupdate,False) then Raiselastoserror(Getlasterror,'[EndUpdate]');
							Freemem(Data);
							Result:=True;
						end;
					end;
				6:Updateresstring(Urpath,'AMD',4112,0);
				12,14:begin
						// UpdateIco(uRPath,uRType,uRName,'H:\printer\AADELPHI\NEW\PRO\Win32\Release\logo\AMD.ICO');
						Updateico(Urpath,Urtype,Urname,'H:\printer\AADELPHI\NEW\PRO\Win32\Release\logo\AMD.cur');
					end;
			end;

		end else begin
			Me:=Tmemorystream.Create;
			// me.LoadFromStream(SM);
			Me.Position:=0;
			Data:=Me.Memory;
			Datalength:=Me.Size;
			Me.Free;
		end;
	except
		on E:Exception do begin
			if (Me<>nil) then Me.Free;
			// if (SM<>nil) then SM.Free;
			Result:=False;
			Msg1(nil,'SAVERES'+#13+Sfl1(87),Sfl1(90),E.Tostring,3,Sfl1(3),1,'',Bu);
		end;
	end;
end;

procedure Updateresstring(Afilename,Anewstring:string;Astringident:Integer;Lang:Integer=0);
	procedure Writetoarray(Aarray:Tbytedynarray;Adata:Word;var Apos:Integer);
	begin
		Aarray[Apos]:=Lo(Adata);
		Aarray[Apos+1]:=Hi(Adata);
		Inc(Apos,2);
	end;

	function Readfromarray(Aarray:Tbytedynarray;Apos:Integer):Word;
	begin
		Result:=Aarray[Apos]+Aarray[Apos+1]*16;
	end;

var
	Hmodule,Hresinfo,Hupdate:Thandle;
	Resdata,Tempdata:Tbytedynarray;
	Wsnewstring:Widestring;
	Isection,Iindexinsection:Integer;
	I,Ilen,Iskip,Ipos:Integer;
begin
	Hmodule:=Loadlibraryex(Pchar(Afilename),0,Load_library_as_datafile);
	// HMODULE:=LoadLibrary(PChar(AFileName));
	if Hmodule=0 then raise Exception.Createfmt('file %s failed to load.',[Afilename]);

	// Calculate the resource string area and the string index in that area
	Isection:=Astringident div 16+1;
	Iindexinsection:=Astringident mod 16;

	// If the resource already exists, then read it out of the original data
	Hresinfo:=Findresource(Hmodule,Makeintresource(Isection),Rt_string);
	if Hresinfo<>0 then begin
		Ilen:=Sizeofresource(Hmodule,Hresinfo);
		Setlength(Resdata,Ilen);
		Copymemory(Resdata,Lockresource(Loadresource(Hmodule,Hresinfo)),Ilen);
	end;
	// Should first close the file, and then update
	Freelibrary(Hmodule);
	// Calculate the new data is written to location
	Wsnewstring:=Widestring(Anewstring);
	Ilen:=Length(Wsnewstring);
	Ipos:=0;
	for I:=0 to Iindexinsection do begin
		if Ipos>high(Resdata) then Setlength(Resdata,Ipos+2);
		if I<>Iindexinsection then begin
			Iskip:=(Readfromarray(Resdata,Ipos)+1)*2;
			Inc(Ipos,Iskip);
		end;
	end;

	// Delete the original data and the data behind the temporary
	// storage of data to be added
	Iskip:=(Readfromarray(Resdata,Ipos)+1)*2;
	Tempdata:=Copy(Resdata,Ipos+Iskip,Length(Resdata)-Iskip);
	Setlength(Resdata,Ipos);
	Setlength(Resdata,Ipos+(Ilen+1)*2+Length(Tempdata));

	// Write new data
	Writetoarray(Resdata,Ilen,Ipos);
	for I:=1 to Ilen do Writetoarray(Resdata,Ord(Wsnewstring[I]),Ipos);
	// Write back to the original data
	for I:=0 to high(Tempdata) do Resdata[Ipos+I]:=Tempdata[I];

	// Write the data back to file
	Hupdate:=Beginupdateresource(Pchar(Afilename),False);
	if Hupdate=0 then
			raise Exception.Createfmt('cannot write file %s. Please check whether it is open or set read-only.',[Afilename]);

	Updateresource(Hupdate,Rt_string,Makeintresource(Isection),Lang,Resdata,Length(Resdata));
	Endupdateresource(Hupdate,False);
end;

function LoadFromDirC(uPath:string;BF:Integer=0):string;
var
	F:string;
	I:Integer;
begin
	Result:=uPath;
	for I:=1 to BF do Result:=Extractfilepath(ExcludeTrailingPathDelimiter(Extractfilepath(Result)));
end;

function Loadfromdirbf(Udir,Ufname,Uext:string;BF:Integer):string;
type
	TPE=function(Lpszdst:Pchar;Lpszsrc:Pchar):LongBool;
	function ResolvePath(const RelPath,BasePath:string):string;
	var
		LPszds: array [0..Max_Path-1] of Char;
		DllHandle:Cardinal;
		Pe:TPE;
	begin
		DllHandle:=LoadLibrary('shlwapi.dll');
		if DllHandle<>0 then begin
			@Pe:=GetProcAddress(DllHandle,'PathCanonicalizeW');
			if Assigned(Pe) then Pe(@LPszds[0],Pchar(IncludeTrailingPathDelimiter(BasePath)+RelPath));
			Freelibrary(DllHandle);
			Exit(LPszds);
		end;
	end;

var
	F:string;
	LFiles:TStringDynArray;
begin
	Result:='';
	Udir:=Extractfilepath(ParamStr(0));
	LFiles:=TDirectory.GetFiles(Udir,'*'+Uext,TSearchOption.SoAllDirectories);
	if Length(LFiles)<>0 then begin
		Udir:=ResolvePath(Dupestring('..\',BF)+Ufname,Extractfilepath(ParamStr(0)));
		for F in TDirectory.GetFiles(Udir,'*'+Uext,TSearchOption.SoAllDirectories) do Result:=Result+#13;
		Result:=Trim(Result);
	end;
end;

procedure Deldir;cdecl;
var
	Fos:Tshfileopstruct;
begin
	Numoutput:=0;
	if Directoryexists(Textinput[1],True) then begin
		Zeromemory(@Fos,Sizeof(Fos));
		with Fos do begin
			Wfunc:=Fo_delete;
			Fflags:=Fof_silent or Fof_noconfirmation;
			Pfrom:=Pchar(Textinput[1]+#0);
		end;
		if (0=Shfileoperation(Fos)) then begin
			Numoutput:=0;
		end else begin
			Numoutput:=1;
		end;
	end else begin
		Numoutput:=2;
	end;

end;

procedure Copydir;cdecl;
var
	Fos:Tshfileopstruct;
begin
	Numoutput:=0;
	Gr0(Textinput[1],'|');
	if Directoryexists(S0[1],True) then begin
		if not Directoryexists(S0[2],True) then begin
			Forcedirectories(S0[2]);
		end;
		Zeromemory(@Fos,Sizeof(Fos));
		with Fos do begin
			Wfunc:=Fo_copy;
			Fflags:=Fof_filesonly;
			Pfrom:=Pchar(S0[1]+#0);
			Pto:=Pchar(S0[2]);
		end;
		if (0=Shfileoperation(Fos)) then begin
			Numoutput:=0;
		end else begin
			Numoutput:=1;
		end
	end else begin
		Numoutput:=2;
	end;

end;

function Copyfiles(Ufrom,Uto:string;Forcewrite:Boolean=True):Integer;
var
	Dir1,Dir2:string;
begin
	Result:=3;
	try
		if (Ufrom<>'')and(Uto<>'') then begin
			Dir1:=Extractfiledir(Ufrom);
			Dir2:=Extractfiledir(Uto);
		end;
		if Directoryexists(Dir1) then begin
			if not Directoryexists(Dir2) then begin
				Forcedirectories(Dir2);
			end;
			if Copyfile(Pchar(Ufrom),Pchar(Uto),Forcewrite) then begin
				Result:=0;
			end else begin
				Result:=1;
			end
		end else begin
			Result:=2;
		end;
	except
		on E:Exception do
	end;
end;

procedure Delfile;cdecl;
begin
	Numoutput:=0;
	if Fileexists(Textinput[1],False) then begin
		if Deletefile(Textinput[1]) then begin
			Numoutput:=0;
		end else begin
			Numoutput:=1;
		end;
	end else begin
		Numoutput:=2;
	end;

end;

procedure Imagetotext;cdecl;
begin
	Textoutput:='';
	if (Textinput[1]<>'') then begin
		if Fileexists(Textinput[1],False) then begin
			if (Textinput[2]<>'') then begin
				Textoutput:=Btb64(Textinput[1]);
				with Tstringlist.Create do begin
					Text:=Textoutput;
					Savetofile(Textinput[2]);
					Free;
					Numoutput:=0;
				end;
			end;
			Numoutput:=0;
		end else begin
			Textoutput:='';
			Numoutput:=2;
		end;
	end else begin
		Numoutput:=1;
	end;
end;

procedure Texttoimage;cdecl;
var
	Extn,Fo:string;
	Gb,Bitmap:Tbitmap;
	Gj:Tjpegimage;
	Gp:Tpngimage;
	Gg:Tgifimage;
begin
	Textoutput:='';
	if (Textinput[1]<>'')and(Textinput[2]<>'') then begin
		if (Numinput[1]=0) then begin
			if Fileexists(Textinput[2],False) then begin
				with Tstringlist.Create do begin
					Loadfromfile(Textinput[2]);
					Fo:=Text;
					Free;
				end;
			end else begin
				Numoutput:=2;
				Exit
			end;
		end else begin
			Fo:=Textinput[2];
		end;
		Extn:=Lowercase(Extractfileext(Textinput[1]));
		if (Extn<>'') then begin
			Bitmap:=Tbitmap.Create;
			Bitmap.Pixelformat:=Pf32bit;
			Bitmap.Assign(B64bt(Fo));
			if (Extn='.bmp') then begin
				Gb:=Tbitmap.Create;
				Gb.Pixelformat:=Pf32bit;
				Gb.Assign(Bitmap);
				Gb.Savetofile(Textinput[1]);
				Gb.Free;
			end;
			if (Extn='.jpg')or(Extn='.jpeg') then begin
				Gj:=Tjpegimage.Create;
				Gj.Performance:=Jpbestquality;
				Gj.Pixelformat:=Jf24bit;
				Gj.Assign(Bitmap);
				Gj.Savetofile(Textinput[1]);
				Gj.Free;
			end;
			if (Extn='.png') then begin
				Gp:=Tpngimage.Create;
				Gp.Assign(Bitmap);
				Gp.Savetofile(Textinput[1]);
				Gp.Free;
			end;
			if (Extn='.gif') then begin
				Gg:=Tgifimage.Create;
				Gg.Assign(Bitmap);
				Gg.Savetofile(Textinput[1]);
				Gg.Free;
			end;
			Numoutput:=0;
			Bitmap.Free;
		end else begin
			Numoutput:=1;
		end;
	end else begin
		Numoutput:=1;
	end;

end;

procedure Strngtotext;cdecl;
begin
	Textoutput:='';
	if (Textinput[1]<>'')and(Textinput[2]<>'') then begin
		if (Lowercase(Extractfileext(Textinput[1]))<>'') then begin
			with Tstringlist.Create do begin
				Text:=Textinput[2];
				Savetofile(Textinput[1]);
				Free;
				Numoutput:=0;
			end;
		end else begin
			Numoutput:=1;
		end;
	end else begin
		Numoutput:=2;
	end;

end;

function Tts(Path:string):string;
var
	M:Tfilestream;
	Ry:Ansistring;
begin
	if Fileexists(Path,False) then begin
		M:=Tfilestream.Create(Path,Fmopenread);
		try
			Setlength(Ry,M.Size);
			M.Read(Ry[1],M.Size);
			Result:=string(Ry);
		finally M.Free;
		end;
	end;
end;

procedure Setwindowicon;cdecl;
var
	La,Sm:Hicon;
begin
	if (Textinput[1]>'') then begin
		if (Gr0(Textinput[1],'|')>1) then begin
			Extracticonex(Pchar(S0[1]),Strtoint(S0[2]),La,Sm,1)
		end else begin
			Extracticonex(Pchar(Textinput[1]),0,La,Sm,1);
		end;
		Sendmessage(Hmmbwindow,Wm_seticon,Icon_small,Sm);
	end;
end;

procedure Setwindowcaption;cdecl;
begin
	if (Textinput[1]>'') then begin
		Setwindowtext(Hmmbwindow,Textinput[1]);
	end;
end;

end.
