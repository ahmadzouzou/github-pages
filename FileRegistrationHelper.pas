unit FileRegistrationHelper;

interface

uses
  Windows,
  Dialogs,
  Sysutils,
  Shellapi;

type
  Tfileversioninfo=record
    Filetype,Companyname,Filedescription,Fileversion,Internalname,Legalcopyright,Legaltrademarks,Originalfilename,
      Productname,Productversion,Comments,Specialbuildstr,Privatebuildstr,Filefunction:string;
    Debugbuild,Prerelease,Specialbuild,Privatebuild,Patched,Infoinferred:Boolean;
  end;

const
{$IF Defined(NEXTGEN) and Declared(System.Embedded)}
  Advapi32kernel='kernelbase.dll';
{$ELSE}
  Advapi32kernel='advapi32.dll';
{$ENDIF}
  Shell32='shell32.dll';
  Shcne_assocchanged=$08000000;
  Shcnf_idlist=$0000;
  Shcnf_dword=$0003;
  Shcnf_flush=$1000;
function Isuseranadmin:Bool; stdcall; external Shell32 name 'IsUserAnAdmin';
function Regsetkeyvalue(Hkey:Hkey; Pszsubkey,Pszvalue:Lpcwstr; Dwtype:Dword; Pvdata:Pointer; Cbdata:Dword):Dword;
  stdcall; external Advapi32kernel name 'RegSetKeyValueW';
function Regdeletekeyvalue(Hkey:Hkey; Pszsubkey,Pszvalue:Lpcwstr):Dword; stdcall;
  external Advapi32kernel name 'RegDeleteKeyValueW';
function Regdeletetree(Hkey:Hkey; Pszsubkey:Lpcwstr):Dword; stdcall; external Advapi32kernel name 'RegDeleteTreeW';
function Runasadmin(Hwnd:Hwnd; Filename:string; Parameters:string):Boolean;
procedure Shchangenotify(Weventid:Integer; Uflags:Uint; Dwitem1,Dwitem2:Pointer); stdcall;
  external Shell32 name 'SHChangeNotify';
function Regsetstring(Key:Hkey; Pszsubkey:string; Pszvalue:string; Pszdata:string; Flg:Cardinal=Reg_sz):Hresult;
function Regprog(Udo:Boolean; Uname:string; Upath:string=''; Ufname:string=''; Udescreption:string=''; Uico:string='';
  Ufico:string=''):Boolean;
function Regext(Udo:Boolean; Uext:string; Uname:string; Upath:string=''; Ucomnd:string=''; Udlgdescreption:string='';
  Udescreption:string=''; Utooltip:string=''; Uico:string=''; Ufico:string=''; Shname:string=''; Shico:string='';
  Shfico:string=''; Shcomm:string=''):Boolean;

function Fileversioninfo(const Sappnamepath:Tfilename):Tfileversioninfo;
function RegToString(Key:Hkey; Subkey,Value:string):string;
/// ////

implementation

{ TFileRegistrationHelper }

function RegToString(Key:Hkey; Subkey,Value:string):string;
var
  Xbuffer_size,rslt:Longword;
  Xbuffer: array [Word] of Char;
begin
  Result:='';
  Xbuffer:='';
  if not(RegOpenKeyEx(Key,Pchar(Subkey),0,1,Key)=0) then begin
    Exit;
  end else begin
    Xbuffer_size:=MAXWORD+2;
  end;
  rslt:=ERROR_MORE_DATA;
  repeat
    rslt:=RegQueryValueEx(Key,Pchar(Value),0,nil,@Xbuffer,@Xbuffer_size);
    Xbuffer_size:=Xbuffer_size+2;
  until (rslt=0);
  Result:=Xbuffer;
  RegCloseKey(Key);
end;

function Isfiletyperegistered:Boolean;
var
  Hkeyprogid:Hkey;
begin
  Result:=False;
  if (Succeeded(Hresultfromwin32(Regopenkey(Hkey_classes_root,Pwidechar(''),Hkeyprogid)))) then begin
    Result:=True;
    RegCloseKey(Hkeyprogid);
  end;
end;

function Regsetstring(Key:Hkey; Pszsubkey,Pszvalue,Pszdata:string; Flg:Cardinal=Reg_sz):Hresult;
begin
  Result:=Hresultfromwin32(Regsetkeyvalue(Key,Pwidechar(Pszsubkey),Pwidechar(Pszvalue),Flg,Pwidechar(Pszdata),
    (Length(Pszdata)+1)*Sizeof(Char))); // SHSetValue
end;

function Regprog(Udo:Boolean; Uname:string; Upath:string=''; Ufname:string=''; Udescreption:string=''; Uico:string='';
  Ufico:string=''):Boolean;
var
  K1,K2:Hkey;
  Lres,Hresl:Integer;
  Pszico:string;
begin
  Result:=False;
  if (Ufico='') then Pszico:=Upath+','+Uico
  else Pszico:=Ufico+','+Uico;
  if Udo then begin
    Hresl:=Hresultfromwin32(RegOpenKeyEx(Hkey_classes_root,'Applications',0,Key_set_value or Key_create_sub_key,K1));
    if (Succeeded(Hresl)) then begin
      Hresl:=Hresultfromwin32(Regcreatekeyex(K1,Pwidechar(Uname+'.exe'),0,nil,0,Key_set_value or Key_create_sub_key,
        nil,K2,nil));
      if (Succeeded(Hresl)) then begin
        Regsetstring(K2,'','',Uname);
        Regsetstring(K2,'','FriendlyAppName',Ufname);
        Regsetstring(K2,'DefaultIcon','',Pszico);
        Regsetstring(K2,'shell\Open\Command','','"'+Upath+'" "%1"');
        Regsetstring(K2,'SupportedTypes','','');
        RegCloseKey(K2);
        Result:=True;
      end else begin
        Result:=False;
      end;
      RegCloseKey(K1);
    end else begin
      Result:=False;
    end;
    Hresl:=Hresultfromwin32(RegOpenKeyEx(Hkey_local_machine,'Software\Microsoft\Windows\CurrentVersion\App Paths',0,
      Key_set_value or Key_create_sub_key or Key_all_access,K1));
    if (Succeeded(Hresl)) then begin
      Hresl:=Hresultfromwin32(Regcreatekeyex(K1,Pwidechar(Uname+'.exe'),0,nil,0,Key_set_value or Key_create_sub_key,
        nil,K2,nil));
      if (Succeeded(Hresl)) then begin
        Regsetstring(K2,'','',Upath);
        Regsetstring(K2,'','Path',Extractfilepath(Upath));
        RegCloseKey(K2);
        Result:=True;
      end else begin
        Result:=False;
      end;
      RegCloseKey(K1);
    end else begin
      Result:=False;
    end;
    //
    Hresl:=Hresultfromwin32(RegOpenKeyEx(Hkey_local_machine,'Software',0,Key_set_value or Key_create_sub_key,K1));
    if (Succeeded(Hresl)) then begin
      Hresl:=Hresultfromwin32(Regcreatekeyex(K1,Pwidechar(Uname),0,nil,0,Key_set_value or Key_create_sub_key,
        nil,K2,nil));
      if (Succeeded(Hresl)) then begin
        Regsetstring(K2,'','exe32',Upath);
        Regsetstring(K2,'Capabilities','ApplicationDescription',Udescreption);
        Regsetstring(K2,'Capabilities\FileAssociations','','');
        RegCloseKey(K2);
        Result:=True;
      end else begin
        Result:=False;
      end;
      RegCloseKey(K1);
    end else begin
      Result:=False;
    end;
    Hresl:=Hresultfromwin32(RegOpenKeyEx(Hkey_local_machine,'Software\RegisteredApplications',0,
      Key_set_value or Key_create_sub_key,K1));
    if (Succeeded(Hresl)) then begin
      Regsetstring(K1,'',Uname,'Software\'+Uname+'\Capabilities');
      RegCloseKey(K1);
      Result:=True;
    end else begin
      Result:=False;
    end;
    if Result then Shchangenotify(Shcne_assocchanged,Shcnf_dword or Shcnf_flush,nil,nil);
  end else begin
    Hresl:=Hresultfromwin32(RegOpenKeyEx(Hkey_classes_root,'Applications',0,Key_set_value or Key_create_sub_key,K1));
    Lres:=Regdeletetree(K1,Pwidechar(Uname+'.exe')); // SHDeleteKey
    if ((Error_success=Lres)or(Error_file_not_found=Lres)) then Result:=True;
    RegCloseKey(K1);
    //
    Lres:=Regdeletekey(Hkey_local_machine,Pwidechar('Software\Microsoft\Windows\CurrentVersion\App Paths\'+
      Uname+'.exe'));
    if ((Error_success=Lres)or(Error_file_not_found=Lres)) then Result:=True;
    //
    Hresl:=Hresultfromwin32(RegOpenKeyEx(Hkey_local_machine,'Software',0,Key_set_value or Key_create_sub_key,K1));
    Lres:=Regdeletetree(K1,Pwidechar(Uname));
    if ((Error_success=Lres)or(Error_file_not_found=Lres)) then Result:=True;
    RegCloseKey(K1);
    //
    Lres:=Regdeletekeyvalue(Hkey_local_machine,'Software\RegisteredApplications',Pwidechar(Uname));
    if ((Error_success=Lres)or(Error_file_not_found=Lres)) then Result:=True;
    if Result then Shchangenotify(Shcne_assocchanged,Shcnf_dword or Shcnf_flush,nil,nil);
  end;
end;

function Regext(Udo:Boolean; Uext:string; Uname:string; Upath:string=''; Ucomnd:string=''; Udlgdescreption:string='';
  Udescreption:string=''; Utooltip:string=''; Uico:string=''; Ufico:string=''; Shname:string=''; Shico:string='';
  Shfico:string=''; Shcomm:string=''):Boolean;
var
  K1,K2:Hkey;
  Lres,Hresl:Integer;
  Pszext,Psznam,Pszico,Pszshico:string;
begin
  Result:=False;
  Pszext:='.'+Uext;
  Psznam:=Uname+Pszext;
  if (Ufico='') then Pszico:=Upath+','+Uico
  else Pszico:=Ufico+','+Uico;
  if (Ufico='') then Pszshico:=Upath+','+Shico
  else Pszshico:=Shfico+','+Shico;
  if Udo then begin
    Lres:=Hresultfromwin32(Regcreatekeyex(Hkey_classes_root,Pwidechar(Psznam),0,nil,0,
      Key_set_value or Key_create_sub_key,nil,K1,nil));
    if (Succeeded(Lres)) then begin
      Regsetstring(K1,'','',Udlgdescreption); // TO DIALOG/SAVE RO OPEN
      Regsetstring(K1,'','FriendlyTypeName',Udescreption,Reg_expand_sz); // uDescreption
      Regsetstring(K1,'','InfoTip',Utooltip,Reg_expand_sz); // uTooltip
      Regsetstring(K1,'DefaultIcon','',Pszico);
      Regsetstring(K1,'CurVer','',Psznam);
      Regsetstring(K1,'shell','','Open');
      Regsetstring(K1,'shell\Open\Command','',Ucomnd);
      RegCloseKey(K1);
      Result:=True;
    end else begin
      Result:=False;
    end;
    Lres:=Hresultfromwin32(Regcreatekeyex(Hkey_classes_root,Pwidechar(Pszext),0,nil,0,Key_set_value,nil,K1,nil));
    if Succeeded(Lres) then begin
      Regsetstring(K1,'','',Pwidechar(Psznam));
      Regsetstring(K1,'OpenWithList\'+Psznam,'','');
      Regsetstring(K1,'OpenWithProgids','','');
      Regsetstring(K1,'OpenWithProgids',Psznam,'');
      RegCloseKey(K1);
      Result:=True;
    end else begin
      Result:=False;
    end;
    // context menu
    Lres:=Hresultfromwin32(RegOpenKeyEx(Hkey_classes_root,'SystemFileAssociations',0,
      Key_set_value or Key_create_sub_key,K1));
    if Succeeded(Lres) then begin
      Lres:=Hresultfromwin32(Regcreatekeyex(K1,Pwidechar(Pszext),0,nil,0,Key_set_value,nil,K2,nil));
      if Succeeded(Lres) then begin
        Regsetstring(K2,'','ExtendedTileInfo','prop:System.CanonicalType;System.Size;'+
          'System.DateModified;System.Author;System.OfflineAvailability');
        Regsetstring(K2,'','FullDetails','prop:System.PropGroup.Description;System.Title;'+
          'System.Subject;System.Rating;System.Keywords;System.Category;System.Comment;'+'System.PropGroup.Origin;'+
          'System.Author;System.Document.LastAuthor;System.Document.RevisionNumber;'+
          'System.Document.Version;System.ApplicationName;System.Company;System.Document.Manager;'+
          'System.Document.DateCreated;System.Document.DateSaved;System.Document.DatePrinted;'+
          'System.PropGroup.Content;System.ContentStatus;System.ContentType;System.Document.Scale;'+
          'System.Document.LinksDirty;System.Language;System.PropGroup.FileSystem;System.DisplayName;'+
          'System.CanonicalType;System.DisplayFolder;System.Size;System.DateCreated;'+
          'System.DateModified;System.DateAccessed;System.Attributes;System.OfflineAvailability;'+
          'System.OfflineStatus;System.SharedWith;System.File.Owner;System.ComputerName');
        Regsetstring(K2,'','InfoTip','prop:Type;DocAuthor;DocTitle;DocSubject;DocComments;Size;Write');
        Regsetstring(K2,'','PreviewDetails','prop:System.Title;System.Author;*System.Size;'+
          '*System.DateModified;System.Keywords;System.Category;System.ContentStatus;'+
          'System.ContentType;*System.OfflineAvailability;*System.OfflineStatus;*System.File.Owner;'+
          'System.Subject;System.Comment;*System.DateCreated;*System.DateAccessed;*System.Attributes;'+
          '*System.SharedWith;*System.ComputerName;*System.Document.LastAuthor;'+
          '*System.Document.DateCreated;*System.Document.DateSaved;*System.Document.DatePrinted;System.Rating;');
        Regsetstring(K2,'','SetDefaultsFor','prop:System.Author;System.Document.DateCreated;'+'System.Photo.DateTaken');
        Regsetstring(K2,'shell\'+Shname,'','');
        Regsetstring(K2,'shell\'+Shname,'Icon',Pszshico);
        Regsetstring(K2,'shell\'+Shname+'\Command','',Shcomm);
        RegCloseKey(K2);
        Result:=True;
      end else begin
        Result:=False;
      end;
      RegCloseKey(K1);
    end else begin
      Result:=False;
    end;
    Lres:=Hresultfromwin32(RegOpenKeyEx(Hkey_classes_root,Pchar('Applications\'+Uname+'.exe'),0,
      Key_set_value or Key_create_sub_key,K1));
    if Succeeded(Lres) then begin
      Regsetstring(K1,'SupportedTypes',Pszext,'');
      RegCloseKey(K1);
      Result:=True;
    end else begin
      Result:=False;
    end;
    Lres:=Hresultfromwin32(RegOpenKeyEx(Hkey_local_machine,Pchar('Software\'+Uname),0,
      Key_set_value or Key_create_sub_key,K1));
    if Succeeded(Lres) then begin
      Regsetstring(K1,'Capabilities\FileAssociations',Pszext,Psznam);
      RegCloseKey(K1);
      Result:=True;
    end else begin
      Result:=False;
    end;
    if Result then Shchangenotify(Shcne_assocchanged,Shcnf_dword or Shcnf_flush,nil,nil);
  end else begin
    Lres:=Regdeletetree(Hkey_classes_root,Pwidechar(Psznam));
    if ((Error_success=Lres)or(Error_file_not_found=Lres)) then Result:=True;
    //
    Lres:=Regdeletetree(Hkey_classes_root,Pwidechar(Pszext));
    if ((Error_success=Lres)or(Error_file_not_found=Lres)) then Result:=True;
    //
    Hresl:=Hresultfromwin32(RegOpenKeyEx(Hkey_classes_root,'SystemFileAssociations',0,
      Key_set_value or Key_create_sub_key,K1));
    Lres:=Regdeletetree(K1,Pwidechar(Pszext));
    if ((Error_success=Lres)or(Error_file_not_found=Lres)) then Result:=True;
    RegCloseKey(K1);
    //
    Lres:=Hresultfromwin32(RegOpenKeyEx(Hkey_classes_root,Pchar('Applications\'+Uname+'.exe\SupportedTypes'),0,
      Key_set_value or Key_create_sub_key,K1));
    if Succeeded(Lres) then begin
      Lres:=Regdeletevalue(K1,Pchar(Pszext));
      if ((Error_success=Lres)or(Error_file_not_found=Lres)) then Result:=True;
      RegCloseKey(K1);
    end;
    Lres:=Hresultfromwin32(RegOpenKeyEx(Hkey_local_machine,Pchar('Software\'+Uname+'\Capabilities\FileAssociations'),0,
      Key_set_value or Key_create_sub_key,K1));
    if Succeeded(Lres) then begin
      Lres:=Regdeletevalue(K1,Pchar(Pszext));
      if ((Error_success=Lres)or(Error_file_not_found=Lres)) then Result:=True;
      RegCloseKey(K1);
    end;
    //
    if Result then Shchangenotify(Shcne_assocchanged,Shcnf_dword or Shcnf_flush,nil,nil);
  end;
end;

function Runasadmin(Hwnd:Hwnd; Filename:string; Parameters:string):Boolean;
var
  Sei:Tshellexecuteinfo;
begin
  Zeromemory(@Sei,Sizeof(Sei));
  Sei.Cbsize:=Sizeof(Tshellexecuteinfo);
  Sei.Wnd:=Hwnd;
  Sei.Fmask:=See_mask_flag_ddewait or See_mask_flag_no_ui;
  Sei.Lpverb:=Pchar('runas');
  Sei.Lpfile:=Pchar(Filename);
  if Parameters<>'' then Sei.Lpparameters:=Pchar(Parameters);
  Sei.Nshow:=Sw_shownormal;
  Result:=Shellexecuteex(@Sei);
end;

/// /////////////////////////////////////////////////////////////////////////////////////////////
var
  Rshfi:Tshfileinfo;
  Iret:Integer;
  Versize:Integer;
  Verbuf:Pchar;
  Verbufvalue:Pansichar;
  Verhandle:Cardinal;
  Verbuflen:Cardinal;
  Verkey:string;
  Fixedfileinfo:Pvsfixedfileinfo;

function Fileversioninfo(const Sappnamepath:Tfilename):Tfileversioninfo;
{ var
  rSHFI: TSHFileInfo;
  iRet: Integer;
  VerSize: Integer;
  VerBuf: PChar;
  VerBufValue: PAnsiChar;
  VerHandle: Cardinal;
  VerBufLen: Cardinal;
  VerKey: string;
  FixedFileInfo: PVSFixedFileInfo; }

// dwFileType, dwFileSubtype
  function Getfilesubtype(Fixedfileinfo:Pvsfixedfileinfo):string;
  begin
    case Fixedfileinfo.Dwfiletype of

      Vft_unknown:Result:='Unknown';
      Vft_app:Result:='Application';
      Vft_dll:Result:='DLL';
      Vft_static_lib:Result:='Static-link Library';

      Vft_drv: case Fixedfileinfo.Dwfilesubtype of
          Vft2_unknown:Result:='Unknown Driver';
          Vft2_drv_comm:Result:='Communications Driver';
          Vft2_drv_printer:Result:='Printer Driver';
          Vft2_drv_keyboard:Result:='Keyboard Driver';
          Vft2_drv_language:Result:='Language Driver';
          Vft2_drv_display:Result:='Display Driver';
          Vft2_drv_mouse:Result:='Mouse Driver';
          Vft2_drv_network:Result:='Network Driver';
          Vft2_drv_system:Result:='System Driver';
          Vft2_drv_installable:Result:='InstallableDriver';
          Vft2_drv_sound:Result:='Sound Driver';
        end;
      Vft_font: case Fixedfileinfo.Dwfilesubtype of
          Vft2_unknown:Result:='Unknown Font';
          Vft2_font_raster:Result:='Raster Font';
          Vft2_font_vector:Result:='Vector Font';
          Vft2_font_truetype:Result:='Truetype Font';
        else;
        end;
      Vft_vxd:Result:='Virtual Defice Identifier = '+Inttohex(Fixedfileinfo.Dwfilesubtype,8);
    end;
  end;

  function Hasdwfileflags(Fixedfileinfo:Pvsfixedfileinfo; Flag:Word):Boolean;
  begin
    Result:=(Fixedfileinfo.Dwfileflagsmask and Fixedfileinfo.Dwfileflags and Flag)=Flag;
  end;

  function Getfixedfileinfo:Pvsfixedfileinfo;
  begin
    if not Verqueryvalue(Verbuf,'',Pointer(Result),Verbuflen) then Result:=nil
  end;

  function Getinfo(const Akey:string):string;
  begin
    Result:='';
    Verkey:=Format('\StringFileInfo\%.4x%.4x\%s',[Loword(Integer(Verbufvalue^)),Hiword(Integer(Verbufvalue^)),Akey]);
    if Verqueryvalue(Verbuf,Pchar(Verkey),Pointer(Verbufvalue),Verbuflen) then Result:=Strpas(Verbufvalue);
  end;

  function Queryvalue(const Avalue:string):string;
  begin
    Result:='';
    // obtain version information about the specified file
    if Getfileversioninfo(Pchar(Sappnamepath),Verhandle,Versize,Verbuf)and
    // return selected version information
      Verqueryvalue(Verbuf,'\VarFileInfo\Translation',Pointer(Verbufvalue),Verbuflen) then Result:=Getinfo(Avalue);
  end;

begin
  // Initialize the Result
  with Result do begin
    Filetype:='';
    Companyname:='';
    Filedescription:='';
    Fileversion:='';
    Internalname:='';
    Legalcopyright:='';
    Legaltrademarks:='';
    Originalfilename:='';
    Productname:='';
    Productversion:='';
    Comments:='';
    Specialbuildstr:='';
    Privatebuildstr:='';
    Filefunction:='';
    Debugbuild:=False;
    Patched:=False;
    Prerelease:=False;
    Specialbuild:=False;
    Privatebuild:=False;
    Infoinferred:=False;
  end;

  // Get the file type
  if Shgetfileinfo(Pchar(Sappnamepath),0,Rshfi,Sizeof(Rshfi),Shgfi_typename)<>0 then begin
    Result.Filetype:=Rshfi.Sztypename;
  end;

  Iret:=Shgetfileinfo(Pchar(Sappnamepath),0,Rshfi,Sizeof(Rshfi),Shgfi_exetype);
  if Iret<>0 then begin
    // determine whether the OS can obtain version information
    Versize:=Getfileversioninfosize(Pchar(Sappnamepath),Verhandle);
    if Versize>0 then begin
      Verbuf:=Allocmem(Versize);
      try
        with Result do begin
          Companyname:=Queryvalue('CompanyName');
          Filedescription:=Queryvalue('FileDescription');
          Fileversion:=Queryvalue('FileVersion');
          Internalname:=Queryvalue('InternalName');
          Legalcopyright:=Queryvalue('LegalCopyRight');
          Legaltrademarks:=Queryvalue('LegalTradeMarks');
          Originalfilename:=Queryvalue('OriginalFileName');
          Productname:=Queryvalue('ProductName');
          Productversion:=Queryvalue('ProductVersion');
          Comments:=Queryvalue('Comments');
          Specialbuildstr:=Queryvalue('SpecialBuild');
          Privatebuildstr:=Queryvalue('PrivateBuild');
          // Fill the VS_FIXEDFILEINFO structure
          Fixedfileinfo:=Getfixedfileinfo;
          Debugbuild:=Hasdwfileflags(Fixedfileinfo,Vs_ff_debug);
          Prerelease:=Hasdwfileflags(Fixedfileinfo,Vs_ff_prerelease);
          Privatebuild:=Hasdwfileflags(Fixedfileinfo,Vs_ff_privatebuild);
          Specialbuild:=Hasdwfileflags(Fixedfileinfo,Vs_ff_specialbuild);
          Patched:=Hasdwfileflags(Fixedfileinfo,Vs_ff_patched);
          Infoinferred:=Hasdwfileflags(Fixedfileinfo,Vs_ff_infoinferred);
          Filefunction:=Getfilesubtype(Fixedfileinfo);
        end;
      finally Freemem(Verbuf,Versize);
      end
    end;
  end
end;

end.
