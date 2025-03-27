(* ======================================================================*
	| unitResourceDetails                                                  |
	|                                                                      |
	| Ultra-light classes to wrap resources and resource modules.          |
	|                                                                      |
	| TResourceModule is an abstract base class for things that can        |
	| provide lists of resources - eg. .RES files, modules, etc.           |
	|                                                                      |
	| TResourceDetails is a base class for resources.                      |
	|                                                                      |
	| ... and here's the neat trick...                                     |
	|                                                                      |
	| Call the class function TResourceDetails.CreateResourceDetails to    |
	| create an instance of the appropriate registered TResourceDetails    |
	| descendant                                                           |
	|                                                                      |
	| ** Gold code **                                                      |
	|                                                                      |
	| Copyright (c) Colin Wilson 2001                                      |
	|                                                                      |
	| All rights reserved                                                  |
	|                                                                      |
	| Version  Date        By    Description                               |
	| -------  ----------  ----  ------------------------------------------|
	| 1.0      06/02/2001  CPWW  Original                                  |
	|          28/05/2005  CPWW  ClearDirty made Protected instead of      |
	|                            Public                                    |
	|                            TResourceDetails.Create can now take      |
	|                            optional data.                            |
	*====================================================================== *)

unit unitResourceDetails;

interface

uses
	Windows,
	Classes,
	Sysutils;

type

	Tresourcedetails=class;
	Tresourcedetailsclass=class of Tresourcedetails;

{$REGION 'TResourceModule class'}
	// ======================================================================
	// TResourceModule class

	Tresourcemodule=class
	private
		Fdirty:Boolean;
		function Getdirty:Boolean;
	protected
		function Getresourcecount:Integer;virtual;abstract;
		function Getresourcedetails(Idx:Integer):Tresourcedetails;virtual;abstract;
		procedure Cleardirty;

	public
		procedure Deleteresource(Idx:Integer);virtual;
		procedure Insertresource(Idx:Integer;Details:Tresourcedetails);virtual;
		function Addresource(Details:Tresourcedetails):Integer;virtual;
		function Indexofresource(Details:Tresourcedetails):Integer;virtual;abstract;
		function Getuniqueresourcename(const Tp:Widestring):Widestring;

		procedure Savetostream(Stream:Tstream);virtual;
		procedure Loadfromstream(Stream:Tstream);virtual;

		procedure Savetofile(const Filename:string);virtual;
		procedure Loadfromfile(const Filename:string);virtual;
		procedure Sortresources;virtual;

		function Findresource(const Tp,Name:Widestring;Alanguage:Integer):Tresourcedetails;

		property Resourcecount:Integer read Getresourcecount;
		property Resourcedetails[Idx:Integer]:Tresourcedetails read Getresourcedetails;
		property Dirty:Boolean read Getdirty write Fdirty;
	end;

{$ENDREGION}
{$REGION 'TResourceDetails class'}
	// ======================================================================
	// TResourceDetails class

	Tresourcedetails=class
	private
		Fparent:Tresourcemodule;
		Fdata:Tmemorystream;
		Fcodepage:Integer;
		Fresourcelanguage:Lcid;
		Fresourcename:Widestring;
		Fresourcetype:Widestring;

		Fmemoryflags:Word; // Resource memory flags
		Fdataversion,Fversion:Dword; // Resource header version info
		Fcharacteristics:Dword;
		Fdirty:Boolean;
		Ftag:Integer;
		procedure Setresourcetype(const Value:Widestring);
		// Resource header characteristics

	protected
		constructor Create(Aparent:Tresourcemodule;Alanguage:Integer;const Aname,Atype:Widestring;Asize:Integer;
			Adata:Pointer);virtual;
		procedure Initnew;virtual;
		procedure Setresourcename(const Value:Widestring);virtual;
		class function Supportsrcdata(const Aname:string;Size:Integer;Data:Pointer):Boolean;virtual;
		class function Supportsdata(Size:Integer;Data:Pointer):Boolean;virtual;
	public
		class function Createresourcedetails(Aparent:Tresourcemodule;Alanguage:Integer;const Aname,Atype:Widestring;
			Asize:Integer;Adata:Pointer):Tresourcedetails;
		class function Getbasetype:Widestring;virtual;

		constructor Createnew(Aparent:Tresourcemodule;Alanguage:Integer;const Aname:Widestring);virtual;
		destructor Destroy;override;
		procedure Beforedelete;virtual;

		procedure Changedata(Newdata:Tmemorystream);virtual;

		property Parent:Tresourcemodule read Fparent;
		property Data:Tmemorystream read Fdata;
		property Resourcename:Widestring read Fresourcename write Setresourcename;
		property Resourcetype:Widestring read Fresourcetype write Setresourcetype;
		property Resourcelanguage:Lcid read Fresourcelanguage write Fresourcelanguage;

		property Codepage:Integer read Fcodepage write Fcodepage;
		property Characteristics:Dword read Fcharacteristics write Fcharacteristics;
		property Version:Dword read Fversion write Fdataversion;
		property Dataversion:Dword read Fdataversion write Fdataversion;
		property Memoryflags:Word read Fmemoryflags write Fmemoryflags;

		property Dirty:Boolean read Fdirty write Fdirty;
		property Tag:Integer read Ftag write Ftag;
	end;
{$ENDREGION}
{$REGION 'TAnsiResourceDetails class'}
	// ======================================================================
	// TAnsiResourceDetails class

	Tansiresourcedetails=class(Tresourcedetails)
	private
		function Gettext:string;
		procedure Settext(const Value:string);
	protected
		procedure Initnew;override;
		class function Supportsdata(Size:Integer;Data:Pointer):Boolean;override;
	public
		property Text:string read Gettext write Settext;
	end;
{$ENDREGION}
{$REGION 'TUnicodeResourceDetails'}
	// ======================================================================
	// TAnsiResourceDetails class

	Tunicoderesourcedetails=class(Tresourcedetails)
	private
		function Gettext:Widestring;
		procedure Settext(const Value:Widestring);
	protected
		procedure Initnew;override;
		class function Supportsdata(Size:Integer;Data:Pointer):Boolean;override;
	public
		property Text:Widestring read Gettext write Settext;
	end;
{$ENDREGION}
	// ======================================================================
	// Global function definitions

procedure Registerresourcedetails(Resourceclass:Tresourcedetailsclass);
procedure Unregisterresourcedetails(Resourceclass:Tresourcedetailsclass);
function Resourcewidechartostr(var Wstr:Pwidechar;Codepage:Integer):string;
function Resourcewidechartowidestr(var Wstr:Pwidechar):Widestring;
procedure Resourcestrtowidechar(const S:string;var P:Pwidechar;Codepage:Integer);
procedure Resourcewidestrtowidechar(const S:Widestring;var P:Pwidechar);
function Resourcenametoint(const S:string):Integer;
function Wideresourcenametoint(const S:Widestring):Integer;
function Comparedetails(P1,P2:Pointer):Integer;

implementation

{$REGION 'Local Declarations and Functions'}

var
	Registeredresourcedetails: array of Tresourcedetailsclass;
	Registeredresourcedetailscount:Integer=0;

resourcestring
	Rstnobasetype='Can''t register resource details class with no base type';
	Rstnostreaming='Module doesn''t support streaming';

	(* ----------------------------------------------------------------------*
		| procedure RegisterResourceDetails                                    |
		|                                                                      |
		| Add a class, derived from TResourceDetails, to the list of           |
		| registered resource details classes                                  |
		*---------------------------------------------------------------------- *)
procedure Registerresourcedetails(Resourceclass:Tresourcedetailsclass);
begin
	if Length(Registeredresourcedetails)=Registeredresourcedetailscount then
			Setlength(Registeredresourcedetails,Length(Registeredresourcedetails)+10);

	Registeredresourcedetails[Registeredresourcedetailscount]:=Resourceclass;

	Inc(Registeredresourcedetailscount)
end;

(* ----------------------------------------------------------------------*
	| procedure UnRegisterResourceDetails                                  |
	|                                                                      |
	| Remove a class, derived from TResourceDetails, from the list of      |
	| registered resource details classes                                  |
	*---------------------------------------------------------------------- *)
procedure Unregisterresourcedetails(Resourceclass:Tresourcedetailsclass);
var
	I:Integer;
begin
	I:=0;
	while I<Registeredresourcedetailscount do
		if Registeredresourcedetails[I]=Resourceclass then begin
			if I<Length(Registeredresourcedetails)-1 then
					Move(Registeredresourcedetails[I+1],Registeredresourcedetails[I],(Length(Registeredresourcedetails)-I-1)*
					Sizeof(Tresourcedetailsclass));

			Dec(Registeredresourcedetailscount)
		end
		else Inc(I)
end;

(* ----------------------------------------------------------------------------*
	| procedure ResourceWideCharToStr ()                                         |
	|                                                                            |
	| Convert Pascal-style WideChar array to a string                            |
	|                                                                            |
	| Parameters:                                                                |
	|   WStr : PWChar             The characters                                 |
	|   codePage : Integer        Code page to use in conversion                 |
	*---------------------------------------------------------------------------- *)
function Resourcewidechartostr(var Wstr:Pwidechar;Codepage:Integer):string;
var
	Len:Word;
begin
	Len:=Word(Wstr^);
	Setlength(Result,Len);
	Inc(Wstr);
	Widechartomultibyte(Codepage,0,Wstr,Len,Pansichar(Result),Len+1,nil,nil);
	Inc(Wstr,Len);
	Result:=Pchar(Result);
end;

(* ----------------------------------------------------------------------------*
	| procedure ResourceWideCharToWideStr ()                                     |
	|                                                                            |
	| Convert Pascal-style WideChar array to a WideString                        |
	|                                                                            |
	| Parameters:                                                                |
	|   WStr : PWChar             The characters                                 |
	*---------------------------------------------------------------------------- *)
function Resourcewidechartowidestr(var Wstr:Pwidechar):Widestring;
var
	Len:Word;
begin
	Len:=Word(Wstr^);
	Setlength(Result,Len);
	Inc(Wstr);
	Move(Wstr^,Pwidechar(Result)^,Len*Sizeof(Widechar));
	Inc(Wstr,Len);
end;

(* ----------------------------------------------------------------------------*
	| procedure ResourceStrToWideChar ()                                         |
	|                                                                            |
	| Convert a string to a Pascal style Wide char array                         |
	|                                                                            |
	| Parameters:                                                                |
	|   s : string                The string                                     |
	|   var p : PWideChar         [in]  Points to the start of the receiving buf |
	|                             [out] Points after the characters.             |
	|   codePage : Integer        Code page to use in conversion                 |
	*---------------------------------------------------------------------------- *)
procedure Resourcestrtowidechar(const S:string;var P:Pwidechar;Codepage:Integer);
var
	Buffer:Pwidechar;
	Len,Size:Word;
begin
	Len:=Length(S);
	Size:=(Length(S)+1)*Sizeof(Widechar);
	Getmem(Buffer,Size);
	try
		Multibytetowidechar(Codepage,0,Pansichar(S),-1,Buffer,Size);
		P^:=Widechar(Len);
		Inc(P);
		Move(Buffer^,P^,Len*Sizeof(Widechar));
		Inc(P,Len)
	finally Freemem(Buffer)
	end
end;

(* ----------------------------------------------------------------------------*
	| procedure ResourceWideStrToWideChar ()                                     |
	|                                                                            |
	| Convert a wide string to a Pascal style Wide char array                    |
	|                                                                            |
	| Parameters:                                                                |
	|   s : string                The string                                     |
	|   var p : PWideChar         [in]  Points to the start of the receiving buf |
	|                             [out] Points after the characters.             |
	*---------------------------------------------------------------------------- *)
procedure Resourcewidestrtowidechar(const S:Widestring;var P:Pwidechar);
var
	Len:Word;
begin
	Len:=Length(S);
	P^:=Widechar(Len);
	Inc(P);
	Move(Pwidechar(S)^,P^,Len*Sizeof(Widechar));
	Inc(P,Len)
end;

(* ----------------------------------------------------------------------*
	| procedure ResourceNameToInt                                          |
	|                                                                      |
	| Get integer value of resource name (or type).  Return -1 if it's     |
	| not numeric.                                                         |
	*---------------------------------------------------------------------- *)
function Resourcenametoint(const S:string):Integer;
var
	Isnumeric:Boolean;
	I:Integer;
begin
	Isnumeric:=Length(S)>0;
	for I:=1 to Length(S) do
		if not(S[I] in ['0'..'9']) then begin
			Isnumeric:=False;
			Break
		end;

	if Isnumeric then Result:=Strtoint(S)
	else Result:=-1
end;

function Wideresourcenametoint(const S:Widestring):Integer;
begin
	Result:=Resourcenametoint(S);
end;

(* ----------------------------------------------------------------------*
	| function CompareDetails                                              |
	|                                                                      |
	| 'Compare' function used when sorting resources.  p1 and p2 must be   |
	| TResourceDetails references.  Returns > 0 if details at p1 are >     |
	| details at p2.                                                       |
	|                                                                      |
	| *  Compare resource types.  If they match then compare names.        |
	| *  'Integer' ids or names must come *after* non integer ids or names.|
	*---------------------------------------------------------------------- *)
function Comparedetails(P1,P2:Pointer):Integer;
var
	D1:Tresourcedetails;
	D2:Tresourcedetails;
	I1,I2:Integer;
begin
	D1:=Tresourcedetails(P1);
	D2:=Tresourcedetails(P2);

	I1:=Resourcenametoint(D1.Resourcetype);
	I2:=Resourcenametoint(D2.Resourcetype);

	if I1>=0 then
		if I2>=0 then Result:=I1-I2 // Compare two integer ids
		else Result:=1 // id1 is int, so it's greater than non-int id2
	else if I2>=0 then Result:=-1 // id2 is int, so it's less than non-int id1
	else
		// Compare two string resource ids
			Result:=Comparetext(D1.Resourcetype,D2.Resourcetype);

	if Result=0 then // If they match, do the same with the names
	begin
		I1:=Resourcenametoint(D1.Resourcename);
		I2:=Resourcenametoint(D2.Resourcename);

		if I1>=0 then
			if I2>=0 then Result:=I1-I2
			else Result:=1
		else if I2>=0 then Result:=-1
		else Result:=Comparetext(D1.Resourcename,D2.Resourcename)
	end
end;

(* ----------------------------------------------------------------------*
	| function LCIDTOCodePage                                              |
	|                                                                      |
	| Get the ANSI code page for a given language ID                       |
	*---------------------------------------------------------------------- *)
function Lcidtocodepage(Alcid:Lcid):Integer;
var
	Buffer: array [0..6] of Char;
begin
	Getlocaleinfo(Alcid,Locale_idefaultansicodepage,Buffer,Sizeof(Buffer));
	Result:=Strtointdef(Buffer,Getacp);
end;

{$ENDREGION}
{$REGION 'TResourceDetails implementation'}
{ TResourceDetails }

(* ----------------------------------------------------------------------*
	| TResourceDetails.BeforeDelete                                        |
	|                                                                      |
	| Can override this to clear up before deleting.  Eg. deleting an      |
	| icon removes it from the icon group it's in.  Deleting an icon group |
	| removes the individual icon resources, etc.                          |
	*---------------------------------------------------------------------- *)
procedure Tresourcedetails.Beforedelete;
begin
	// Stub
end;

(* ----------------------------------------------------------------------*
	| TResourceDetails.ChangeData                                          |
	|                                                                      |
	| Change all the data.  Handy for implementing 'undo', etc.            |
	*---------------------------------------------------------------------- *)
procedure Tresourcedetails.Changedata(Newdata:Tmemorystream);
begin
	Fdata.Clear;
	Fdata.Copyfrom(Newdata,0);
end;

(* ----------------------------------------------------------------------*
	| TResourceDetails.Create                                              |
	|                                                                      |
	| Raw - protected - constructor for resource details.                  |
	*---------------------------------------------------------------------- *)
constructor Tresourcedetails.Create(Aparent:Tresourcemodule;Alanguage:Integer;const Aname,Atype:Widestring;
	Asize:Integer;Adata:Pointer);
begin
	Fparent:=Aparent;
	Fresourcelanguage:=Alanguage;
	Fcodepage:=Lcidtocodepage(Fresourcelanguage);
	Fresourcename:=Aname;
	Fresourcetype:=Atype;
	Fdata:=Tmemorystream.Create;
	if Adata<>nil then Fdata.Write(Adata^,Asize)
	else Initnew
end;

(* ----------------------------------------------------------------------*
	| TResourceDetails.CreateNew                                           |
	|                                                                      |
	| Constructor to be used when adding new resources to a module.        |
	*---------------------------------------------------------------------- *)
constructor Tresourcedetails.Createnew(Aparent:Tresourcemodule;Alanguage:Integer;const Aname:Widestring);
begin
	Fparent:=Aparent;
	Fresourcelanguage:=Alanguage;
	Fcodepage:=Lcidtocodepage(Fresourcelanguage);
	Fresourcename:=Aname;
	Fresourcetype:=Getbasetype;
	if Assigned(Aparent) then Aparent.Addresource(Self);
	Fdata:=Tmemorystream.Create;
	Initnew
end;

(* ----------------------------------------------------------------------*
	| TResourceDetails.CreateResourceDetails                               |
	|                                                                      |
	| Create a class derived from TResourceDetals that reflects the 'Type' |
	| If no matching class is registered, create a base 'TResourceDetails' |
	| class.    (Ha!  Try doing *that* in C++ ! )                          |
	*---------------------------------------------------------------------- *)
class function Tresourcedetails.Createresourcedetails(Aparent:Tresourcemodule;Alanguage:Integer;
	const Aname,Atype:Widestring;Asize:Integer;Adata:Pointer):Tresourcedetails;
var
	I:Integer;
begin
	Result:=nil;

	if (Length(Atype)>0) then
		try

			// Check for exact match

			for I:=0 to Registeredresourcedetailscount-1 do
				if Registeredresourcedetails[I].Getbasetype=Atype then begin
					if (Atype<>Inttostr(Integer(Rt_rcdata)))or Registeredresourcedetails[I].Supportsrcdata(Aname,Asize,Adata) then
					begin
						Result:=Registeredresourcedetails[I].Create(Aparent,Alanguage,Aname,Atype,Asize,Adata);
						Break
					end
				end;
		except
		end;

	// If no exact match, check each clas to see if it supports the data
	if Result=nil then
		try
			for I:=0 to Registeredresourcedetailscount-1 do
				if Registeredresourcedetails[I].Supportsdata(Asize,Adata) then begin
					Result:=Registeredresourcedetails[I].Create(Aparent,Alanguage,Aname,Atype,Asize,Adata);
					Break
				end;
		except
		end;

	if Result=nil then
		if Tansiresourcedetails.Supportsdata(Asize,Adata) then
				Result:=Tansiresourcedetails.Create(Aparent,Alanguage,Aname,Atype,Asize,Adata)
		else if Tunicoderesourcedetails.Supportsdata(Asize,Adata) then
				Result:=Tunicoderesourcedetails.Create(Aparent,Alanguage,Aname,Atype,Asize,Adata)
		else Result:=Tresourcedetails.Create(Aparent,Alanguage,Aname,Atype,Asize,Adata)
end;

(* ----------------------------------------------------------------------*
	| TResourceDetails.Destroy                                             |
	*---------------------------------------------------------------------- *)
destructor Tresourcedetails.Destroy;
begin
	Fdata.Free;
	inherited;
end;

(* ----------------------------------------------------------------------*
	| TResourceDetails.GetBaseType                                         |
	|                                                                      |
	| Return the base type for the resource details.  This is overridden   |
	| in derived classes.                                                  |
	*---------------------------------------------------------------------- *)
class function Tresourcedetails.Getbasetype:Widestring;
begin
	Result:='0';
end;

(* ----------------------------------------------------------------------*
	| TResourceDetails.InitNew                                             |
	|                                                                      |
	| Override this to initialize a new resource being added to a module.  |
	*---------------------------------------------------------------------- *)
procedure Tresourcedetails.Initnew;
begin
	// Stub
end;

(* ----------------------------------------------------------------------*
	| TResourceDetails.SetResourceName                                     |
	|                                                                      |
	| Set the resource name.                                               |
	*---------------------------------------------------------------------- *)
procedure Tresourcedetails.Setresourcename(const Value:Widestring);
begin
	if Fresourcename<>Value then begin
		Fresourcename:=Value;
		Fdirty:=True
	end
end;

procedure Tresourcedetails.Setresourcetype(const Value:Widestring);
begin
	if Fresourcetype<>Value then begin
		Fresourcetype:=Value;
		Fdirty:=True
	end
end;

(* ----------------------------------------------------------------------*
	| TResourceDetails.SupportsData                                        |
	|                                                                      |
	| Can be overridden to support a custom resource class, where you can  |
	| determine the custom class from the data - eg. RIFF data, etc.       |
	*---------------------------------------------------------------------- *)
class function Tresourcedetails.Supportsdata(Size:Integer;Data:Pointer):Boolean;
begin
	Result:=False; // stub
end;

(* ----------------------------------------------------------------------*
	| TResourceDetails.SupportsData                                        |
	|                                                                      |
	| Can be overridden to support RC data where you can determine the     |
	| type from the data and name - eg. the Delphi splash screen JPEG      |
	*---------------------------------------------------------------------- *)
class function Tresourcedetails.Supportsrcdata(const Aname:string;Size:Integer;Data:Pointer):Boolean;
begin
	Result:=False; // stub
end;

{$ENDREGION}
{$REGION 'TResourceModule implementation'}
{ TResourceModule }

function Tresourcemodule.Addresource(Details:Tresourcedetails):Integer;
begin
	Result:=-1
	// Stub
end;

procedure Tresourcemodule.Cleardirty;
var
	I:Integer;
begin
	Fdirty:=False;
	for I:=0 to Resourcecount-1 do Resourcedetails[I].Dirty:=False
end;

(* ----------------------------------------------------------------------*
	| TResourceModule.DeleteResource                                       |
	|                                                                      |
	| Must be overridden to remove the resource details object from        |
	| wherever it's stored.  The overriding method must call               |
	| inherited                                                            |
	*---------------------------------------------------------------------- *)
procedure Tresourcemodule.Deleteresource(Idx:Integer);
begin
	Fdirty:=True;
	Resourcedetails[Idx].Beforedelete;
end;

(* ----------------------------------------------------------------------*
	| TResourceModule.FindResource                                         |
	|                                                                      |
	| Find a resource with a given type/name                               |
	*---------------------------------------------------------------------- *)
function Tresourcemodule.Findresource(const Tp,Name:Widestring;Alanguage:Integer):Tresourcedetails;
var
	I:Integer;
begin
	Result:=nil;
	for I:=0 to Resourcecount-1 do
		if (Resourcedetails[I].Fresourcetype=Tp)and(Resourcedetails[I].Fresourcename=name)and
			(Integer(Resourcedetails[I].Fresourcelanguage)=Alanguage) then begin
			Result:=Resourcedetails[I];
			Break
		end;

	if not Assigned(Result) then
		for I:=0 to Resourcecount-1 do
			if (Resourcedetails[I].Fresourcetype=Tp)and(Resourcedetails[I].Fresourcename=name)and
				(Resourcedetails[I].Fresourcelanguage=0) then begin
				Result:=Resourcedetails[I];
				Break
			end
end;

(* ----------------------------------------------------------------------*
	| TResourceModule.GetDirty                                             |
	|                                                                      |
	| Returns true if the module or it's resources are 'dirty'             |
	|                                                                      |
	| nb. fDirty is only set if resources have been deleted.               |
	|     After adding a resource make sure the resource's Dirty is set to |
	|     true.                                                            |
	*---------------------------------------------------------------------- *)
function Tresourcemodule.Getdirty:Boolean;
var
	I:Integer;
begin
	Result:=Fdirty;
	if not Fdirty then
		for I:=0 to Resourcecount-1 do
			if Resourcedetails[I].Dirty then begin
				Result:=True;
				Break
			end
end;

(* ----------------------------------------------------------------------*
	| TResourceModule.GetUniqueResourceName                                |
	|                                                                      |
	| Generate a unique resource name for a given type.  Names start at    |
	| 1 (though string lists downgrade that to '0')                        |
	*---------------------------------------------------------------------- *)
function Tresourcemodule.Getuniqueresourcename(const Tp:Widestring):Widestring;
var
	I:Integer;
	N,N1:Integer;
	Details:Tresourcedetails;
begin
	N:=0;

	for I:=0 to Resourcecount-1 do begin
		Details:=Resourcedetails[I];
		if Details.Resourcetype=Tp then begin
			N1:=Resourcenametoint(Details.Resourcename);
			if N1>N then N:=N1
		end
	end;

	Result:=Inttostr(N+1);
end;

procedure Tresourcemodule.Insertresource(Idx:Integer;Details:Tresourcedetails);
begin
	// Stub
end;

(* ----------------------------------------------------------------------*
	| TResourceModule.LoadFromFile                                         |
	|                                                                      |
	| Load from file.  This can be overriden but usually isn't as it       |
	| relies on LoadFromStream, which must be.                             |
	*---------------------------------------------------------------------- *)
procedure Tresourcemodule.Loadfromfile(const Filename:string);
var
	S:Tfilestream;
begin
	S:=Tfilestream.Create(Filename,Fmopenread or Fmsharedenynone);
	try Loadfromstream(S);
	finally S.Free
	end
end;

procedure Tresourcemodule.Loadfromstream(Stream:Tstream);
begin
	raise Exception.Create(Rstnostreaming);
end;

(* ----------------------------------------------------------------------*
	| TResourceModule.SaveToFile                                           |
	|                                                                      |
	| Save to file.  This can be overriden but usually isn't as it         |
	| relies on SaveToStream, which must be.                               |
	*---------------------------------------------------------------------- *)
procedure Tresourcemodule.Savetofile(const Filename:string);
var
	S:Tfilestream;
	Oldfilename,Ext:string;
	P:Pchar;
begin
	// Rename old file to .~ext'
	Oldfilename:=Filename;
	Uniquestring(Oldfilename);
	P:=Strrscan(Pchar(Oldfilename),'.');
	if P<>nil then begin
		P^:=#0;
		Inc(P);
		Ext:=P;
		Oldfilename:=Pchar(Oldfilename);
	end
	else Ext:='';
	Ext:='~'+Ext;
	Oldfilename:=Oldfilename+'.'+Ext;

	if Fileexists(Oldfilename) then Deletefile(Oldfilename);

	Renamefile(Filename,Oldfilename);

	try
		S:=Tfilestream.Create(Filename,Fmcreate);
		try
			Savetostream(S);
			Cleardirty
		finally S.Free
		end
	except
		// Failed.  Rename old file back.
		Deletefile(Filename);
		Renamefile(Oldfilename,Filename);
		raise
	end
end;

procedure Tresourcemodule.Savetostream(Stream:Tstream);
begin
	raise Exception.Create(Rstnostreaming);
end;

procedure Tresourcemodule.Sortresources;
begin
	// Stub
end;
{$ENDREGION}
{$REGION 'TAnsiResourceDetails implementation'}
{ TAnsiResourceDetails }

function Tansiresourcedetails.Gettext:string;
begin
	Data.Seek(0,Sofrombeginning);
	Setstring(Result,Pchar(Data.Memory),Data.Size);
end;

procedure Tansiresourcedetails.Initnew;
begin
	Data.Clear;
end;

procedure Tansiresourcedetails.Settext(const Value:string);
begin
	Data.Clear;
	Data.Write(Value[1],Length(Value))
end;

class function Tansiresourcedetails.Supportsdata(Size:Integer;Data:Pointer):Boolean;
var
	I,Sample:Integer;
	Pc:Pchar;
begin
	Result:=Size>0;
	Sample:=Size;
	if Sample>1024 then Sample:=1024;
	Pc:=Pchar(Data);

	if Result then
		for I:=0 to Sample-1 do begin
			if (Pc^<' ')or(Pc^>#127) then
				if not(Pc^ in [#9,#10,#13]) then begin
					Result:=False;
					Break
				end;

			Inc(Pc)
		end
end;
{$ENDREGION}
{$REGION 'TUnicodeResourceDetails implementation'}
{ TUnicodeResourceDetails }

function Tunicoderesourcedetails.Gettext:Widestring;
begin
	Setlength(Result,Data.Size div Sizeof(Widechar));
	Move(Data.Memory^,Result[1],Data.Size);
end;

procedure Tunicoderesourcedetails.Initnew;
begin
	Data.Clear;
end;

procedure Tunicoderesourcedetails.Settext(const Value:Widestring);
begin
	Data.Write(Value[1],Length(Value)*Sizeof(Widechar))
end;

class function Tunicoderesourcedetails.Supportsdata(Size:Integer;Data:Pointer):Boolean;
var
	I,Sample:Integer;
	Pc:Pchar;
begin
	Result:=Size>5;
	Sample:=Size div 2;
	if Sample>1024 then Sample:=1024
	else Dec(Sample);
	Pc:=Pchar(Data);

	if Result then
		for I:=0 to Sample-2 do begin
			if (Pc^<' ')or(Pc^>#127) then
				if not(Pc^ in [#9,#10,#13]) then begin
					Result:=False;
					Break
				end;

			Inc(Pc,2)
		end
end;
{$ENDREGION}

end.
