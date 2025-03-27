unit UFileSummary;

interface

uses
  System.Sysutils,
  Winapi.Windows,
  Winapi.Activex,
  System.Win.Comobj,
  Vcl.Dialogs,//System.IOUtils,
  System.Classes,
  System.Variants,
  Winapi.Shlobj,
  Winapi.PropKey,
  Winapi.Propsys;

type
  Trew=array of string;

  Tdocumentsummaryinfo=record
    Acategory:Widestring;
    Amanager:Widestring;
    Acompany:Widestring;
  end;

function Setfilesummaryinfo(Filename:string;Apro:Trew;Uindex:Integer=-1):Boolean;
function Getfilesummaryinfo(Afilename:string;var Apro:Trew;Uindex:Integer=-1):string;

function Setdocinfo(Afile:string;Title,Subject:string):Boolean;
function Getdocinfo(const Filename:Widestring):string;

function Setexlinfo(Afile:string;Title,Subject:string):Boolean;
function Getexlinfo(const Filename:Widestring):string;

function Clearfilesummaryinfo(const Afilename:Widestring):Boolean;

function Getextendedfileproperties(const Filename:string):string;

function Isntfs(Afilename:string):Boolean;

const
  Stgfmt_file=3;
  Stgfmt_any=4;
  Stgfmt_docfile=5;

  Pid_category=2;
  Pid_presformat=3;
  Pid_bytecount=4;
  Pid_linecount=5;
  Pid_parcount=6;
  Pid_slidecount=7;
  Pid_notecount=8;
  Pid_hiddencount=9;
  Pid_mmclipcount=10;
  Pid_scale=11;
  Pid_headingpair=12;
  Pid_docparts=13;
  Pid_manager=14;
  Pid_company=15;
  Pid_linksdirty=16;
  Pid_charcount2=17;

  //FMTID_MediaFileSummaryInfo
  Pidmsi_editor=$00000002;//VT_LPWSTR
  Pidmsi_supplier=$00000003;
  Pidmsi_source=$00000004;
  Pidmsi_sequence_no=$00000005;
  Pidmsi_project=$00000006;
  Pidmsi_status=$00000007;//VT_UI4
  Pidmsi_owner=$00000008;//VT_LPWSTR
  Pidmsi_rating=$00000009;
  Pidmsi_production=$0000000A;//VT_FILETIME (UTC)
  Pidmsi_copyright=$0000000B;//VT_LPWSTR

  //FMTID_AudioSummaryInformation
  Pidasi_format=$00000002;//VT_BSTR
  Pidasi_timelength=$00000003;//VT_UI4, milliseconds
  Pidasi_avg_data_rate=$00000004;//VT_UI4,  Hz
  Pidasi_sample_rate=$00000005;//VT_UI4,  bits
  Pidasi_sample_size=$00000006;//VT_UI4,  bits
  Pidasi_channel_count=$00000007;//VT_UI4
  Pidasi_stream_number=$00000008;//VT_UI2
  Pidasi_stream_name=$00000009;//VT_LPWSTR
  Pidasi_compression=$0000000A;//VT_LPWSTR

  //FMTID_VideoSummaryInformation
  Pidvsi_stream_name=$00000002;//"StreamName", VT_LPWSTR
  Pidvsi_frame_width=$00000003;//"FrameWidth", VT_UI4
  Pidvsi_frame_height=$00000004;//"FrameHeight", VT_UI4
  Pidvsi_timelength=$00000007;//"TimeLength", VT_UI4, milliseconds
  Pidvsi_frame_count=$00000005;//"FrameCount". VT_UI4
  Pidvsi_frame_rate=$00000006;//"FrameRate", VT_UI4, frames/millisecond
  Pidvsi_data_rate=$00000008;//"DataRate", VT_UI4, bytes/second
  Pidvsi_sample_size=$00000009;//"SampleSize", VT_UI4
  Pidvsi_compression=$0000000A;//"Compression", VT_LPWSTR
  Pidvsi_stream_number=$0000000B;//"StreamNumber", VT_UI2

  Upro:array of string=['NO1','NO2','Title','Subject','Author','Keywords','Comments','Template',
    'Last Saved By','Revision Number','Edit Time','LastPrint','Ceate Date','Last Save','Page Count',
    'Word Count','Char Count','Thumbnail','Name of Creating App','Security'];

  Fmtid_summaryinformation:Tguid='{F29F85E0-4FF9-1068-AB91-08002B27B3D9}';
  Fmtid_docsummaryinformation:Tguid='{D5CDD502-2E9C-101B-9397-08002B2CF9AE}';
  Fmtid_userdefinedproperties:Tguid='{D5CDD505-2E9C-101B-9397-08002B2CF9AE}';
  Fmtid_audiosummaryinformation:Tguid='{64440490-4C8B-11D1-8B70-080036B11A03}';
  Fmtid_videosummaryinformation:Tguid='{64440491-4C8B-11D1-8B70-080036B11A03}';
  Fmtid_imagesummaryinformation:Tguid='{6444048f-4c8b-11d1-8b70-080036b11a03}';
  Fmtid_mediafilesummaryinformation:Tguid='{64440492-4c8b-11d1-8b70-080036b11a03}';
  Iid_ipropertysetstorage:Tguid='{0000013A-0000-0000-C000-000000000046}';
  Iid_istorage:Tguid='{0000000B-0000-0000-C000-000000000046}';

function StgOpenStorageEx(const Pwcsname:Pwidechar;Grfmode:Longint;Stgfmt:Dword;Grfattrs:Dword;
  Pstgoptions:Pointer;Reserved2:Pointer;Riid:Pguid;out Stgopen:Istorage):Hresult;stdcall;
  external 'ole32.dll';

function StgCreateStorageEx(const Pwcsname:Pwidechar;Grfmode:Longint;Stgfmt:Dword;Grfattrs:Dword;
  Pstgoptions:Pointer;Reserved2:Pointer;Riid:Pguid;out Stgopen:Istorage):Hresult;stdcall;
  external 'ole32.dll';
{$EXTERNALSYM SHCreateStreamOnFileEx}
function SHCreateStreamOnFileEx(pszFile:Pwidechar;Grfmode,dwAttributes:Dword;fCreate:Bool;
  pstmTemplate:IStream;out ppstm:IStream):Hresult;stdcall;
  external 'shlwapi.dll' name 'SHCreateStreamOnFileEx';

implementation

uses
  amdfun1;

function Isntfs(Afilename:string):Boolean;
var
  Fso,Drv:Olevariant;
begin
  Isntfs:=False;
  Fso:=Createoleobject('Scripting.FileSystemObject');
  Drv:=Fso.Getdrive(Fso.Getdrivename(Afilename));
  if Drv.Filesystem='NTFS' then Isntfs:=True;
end;

function Getvarvalue(const Value:Tpropvariant):Widestring;
begin
  try
    if Value.Vt=Vt_lpwstr then Result:=Value.Pwszval
    else Result:=Value.Pszval;
  except
    on E:Exception do
  end;
end;

function Setfilesummaryinfo(Filename:string;Apro:Trew;Uindex:Integer=-1):Boolean;
label
  RR;
var
  Propsetstg:IPropertySetStorage;
  Propspec:array of TPropSpec;
  Propstg:IPropertyStorage;
  PropVariant:array of Tpropvariant;
  Stg:Istorage;
  I,U:Integer;
  Epro:string;
  Hr:Hresult;
  pPersistStream:IPersistStream;
  pstm,sst:IStream;
  psps:IPersistSerializedPropStorage;
  statstg:TStatStg;
  grfStatFlag:Longint;
  EnumSTATSTG:IEnumSTATSTG;
  PP:PChar;
  f:FixedUInt;
  PH,LS:Integer;
  L:string;
begin
  goto RR;
  Result:=False;
  if not Fileexists(Filename)then Exit;
  if(Uindex>-1)then begin
    Epro:=Apro[0];
    if(Getfilesummaryinfo(Filename,Apro)<>'')then Apro[Uindex]:=Epro
    else Exit;
  end;
  Propsetstg:=nil;
  Stg:=nil;
  Propstg:=nil;
  try
    Hr:=StgOpenStorageEx(Pwidechar(Filename),Stgm_share_exclusive or Stgm_readwrite,Stgfmt_any,0,
      nil,nil,@Iid_ipropertysetstorage,Stg);
    if(Hr=S_ok)then begin
      Propsetstg:=Stg as IPropertySetStorage;
      Hr:=Propsetstg.Create(Fmtid_summaryinformation,Fmtid_summaryinformation,0,
        Stgm_create or Stgm_readwrite or Stgm_share_exclusive,Propstg);
      if(Hr=S_ok)then begin
        U:=Length(Apro);
        Setlength(Propspec,U);
        Setlength(PropVariant,U);
        for I:=low(Apro)to high(Apro)do begin
          Propspec[I].Ulkind:=Prspec_propid;
          Propspec[I].Propid:=I+2;
          PropVariant[I].Vt:=Vt_lpwstr;
          PropVariant[I].Pwszval:=@Apro[I][1];
        end;
        Propstg.Writemultiple(U,@Propspec[0],@PropVariant[0],2);
        Propstg.Commit(STGC_DEFAULT);
        Setlength(Propspec,0);
        Setlength(PropVariant,0);
        Result:=True;
      end;
    end;
  except
    on E:Exception do Showmessage(E.Message);

  end;
RR:;
  {SHCreateStreamOnFileEx(Pchar('C:\Users\MICLE\Desktop\PS.amd'),STGM_CREATE or STGM_READWRITE,0,
   True,nil,pstm);}
  {StgCreateStorageEx('C:\Users\MICLE\Desktop\PS.amd',Stgm_share_exclusive or Stgm_create or Stgm_readwrite,3,0,nil,nil,
   @Iid_ipropertysetstorage,Stg);}
  StgOpenStorageEx('C:\Users\MICLE\Desktop\PS.amd',Stgm_share_exclusive or Stgm_readwrite,3,0,nil,
    nil,@Iid_ipropertysetstorage,Stg);
  if not Assigned(Stg)then Showmessage('NOT');
  Stg.CreateStream('ASD',Stgm_create or Stgm_readwrite,0,0,pstm);
  f:=0;
  L:=CPROP('.ainv');
  LS:=Length(L);
  PH:=(LS+1)*SizeOf(Char);
  PP:=CoTaskMemAlloc(PH);
  StrCopy(PP,PChar(L+#0));
  pstm.Write(PP,PH,@f);
  CoTaskMemFree(PP);

  pstm.Commit(0);

  //OleCheck(Stg.EnumElements(0,nil,0,EnumSTATSTG));
  //OleCheck(EnumSTATSTG.Next(1,statstg,nil));
  //Showmessage(statstg.Pwcsname);
  //CoTaskMemFree(statstg.Pwcsname);
end;

function Getfilesummaryinfo(Afilename:string;var Apro:Trew;Uindex:Integer=-1):string;
var
  I,N:Integer;
  Propsetstg:IPropertySetStorage;
  Propenum:IEnumSTATPROPSTG;
  Stg:Istorage;
  Propstat:TStatPropStg;
  Propspec:array of TPropSpec;
  Propstg:IPropertyStorage;
  PropVariant:array of Tpropvariant;
  Rslt,Hr:Hresult;
begin
  Result:='';
  if not Fileexists(Afilename)then Exit;
  Propsetstg:=nil;
  Propenum:=nil;
  Stg:=nil;
  Propstg:=nil;
  try
    Hr:=StgOpenStorageEx(Pwidechar(Afilename),Stgm_share_exclusive or Stgm_readwrite,Stgfmt_any,0,
      nil,nil,@Iid_ipropertysetstorage,Stg);
    if(Hr=S_ok)then begin
      Propsetstg:=Stg as IPropertySetStorage;
      Hr:=Propsetstg.Open(Fmtid_summaryinformation,Stgm_share_exclusive or Stgm_readwrite,Propstg);
      if(Hr=S_ok)then begin
        Propstg.Enum(Propenum);
        I:=0;
        Hr:=Propenum.Next(1,Propstat,nil);
        while Hr=S_ok do begin
          Inc(I,1);
          Setlength(Propspec,I);
          Propspec[I-1].Ulkind:=Prspec_propid;
          Propspec[I-1].Propid:=Propstat.Propid;
          Hr:=Propenum.Next(1,Propstat,nil);
        end;
        Setlength(PropVariant,I);
        Rslt:=Propstg.Readmultiple(I,@Propspec[0],@PropVariant[0]);
        if Rslt=S_false then Exit;
        Setlength(Apro,I);
        if(Uindex=-1)then begin
          for N:=0 to I-1 do begin
            Apro[N]:=Getvarvalue(PropVariant[N]);
            Result:=Result+Apro[N]+#13;
          end;
        end else begin
          Apro[0]:=Getvarvalue(PropVariant[Uindex]);
          for N:=0 to I-1 do begin
            Result:=Result+Getvarvalue(PropVariant[N])+#13;
          end;
        end;
        Setlength(Propspec,0);
        Setlength(PropVariant,0);
      end else begin
        Setlength(Apro,1000);
      end;
    end;
  except
    on E:Exception do

  end;
end;

function Clearfilesummaryinfo(const Afilename:Widestring):Boolean;
var
  Propsetstg:IPropertySetStorage;
  Propenum:IEnumSTATPROPSTG;
  Propstgenum:Ienumstatpropsetstg;
  Propstgenumelement:Statpropsetstg;
  Stg:Istorage;
  Propstg:IPropertyStorage;
  Hr:Hresult;
begin
  Result:=False;
  Propsetstg:=nil;
  Propenum:=nil;
  Stg:=nil;
  Propstg:=nil;
  try
    StgOpenStorageEx(Pwidechar(Afilename),Stgm_share_exclusive or Stgm_readwrite,Stgfmt_any,0,nil,
      nil,@Iid_ipropertysetstorage,Stg);
    Propsetstg:=Stg as IPropertySetStorage;
    Propsetstg.Enum(Propstgenum);
    Hr:=Propstgenum.Next(1,Propstgenumelement,nil);
    while Hr=S_ok do begin
      try
        Propsetstg.Delete(Propstgenumelement.Fmtid);
      except
      end;
      Hr:=Propstgenum.Next(1,Propstgenumelement,nil);
    end;
    Result:=True;
  except
    on E:Exception do
  end;
end;

function Getextendedfileproperties(const Filename:string):string;
var
  Shell:Ishelldispatch;
  Filefolder:Folder;
  Fileitem:Folderitem;
  Column,Count:Integer;
  S,Name:Widestring;
  Properties:Tstrings;
begin
  Result:='';
  Column:=0;
  try
    Properties:=Tstringlist.Create();
    Properties.Clear();
    if Fileexists(Filename)then begin
      Shell:=Createcomobject(Clsid_shell)as Ishelldispatch;
      OleCheck(Shell.Namespace(Extractfiledir(Filename),Filefolder));
      OleCheck(Filefolder.Parsename(Extractfilename(Filename),Fileitem));
      repeat
        OleCheck(Filefolder.Getdetailsof(0,Column,name));
        OleCheck(Filefolder.Getdetailsof(Fileitem,Column,S));
        //if (name<>'') then
        Properties.Values[name]:=S;//Properties.Add(Name+'='+S);
        Inc(Column,1);
      until(name='');
      Result:=Properties.Text;
    end;
    Properties.Free;
  except
    on E:Exception do
  end;
end;

/// /////////////////////////////////////////////////////////////////////////////
const
  Wdpropertytitle=$00000001;
  Wdpropertysubject=$00000002;
  Wdpropertyauthor=$00000003;
  Wdpropertykeywords=$00000004;
  Wdpropertycomments=$00000005;
  Wdpropertytemplate=$00000006;
  Wdpropertylastauthor=$00000007;
  Wdpropertyrevision=$00000008;
  Wdpropertyappname=$00000009;
  Wdpropertytimelastprinted=$0000000A;
  Wdpropertytimecreated=$0000000B;
  Wdpropertytimelastsaved=$0000000C;
  Wdpropertyvbatotaledit=$0000000D;
  Wdpropertypages=$0000000E;
  Wdpropertywords=$0000000F;
  Wdpropertycharacters=$00000010;
  Wdpropertysecurity=$00000011;
  Wdpropertycategory=$00000012;
  Wdpropertyformat=$00000013;
  Wdpropertymanager=$00000014;
  Wdpropertycompany=$00000015;
  Wdpropertybytes=$00000016;
  Wdpropertylines=$00000017;
  Wdpropertyparas=$00000018;
  Wdpropertyslides=$00000019;
  Wdpropertynotes=$0000001A;
  Wdpropertyhiddenslides=$0000001B;
  Wdpropertymmclips=$0000001C;
  Wdpropertyhyperlinkbase=$0000001D;
  Wdpropertycharswspaces=$0000001E;
  Wdsavechanges=$FFFFFFFF;

function Setdocinfo(Afile:string;Title,Subject:string):Boolean;
var
  Wordapp,Savechanges:Olevariant;
begin
  Result:=False;
  try
    Wordapp:=Createoleobject('Word.Application');
    Wordapp.Visible:=False;
    Wordapp.Documents.Open(Afile);
    Wordapp.Activedocument.Builtindocumentproperties[Wdpropertytitle].Value:=Title;
    Wordapp.Activedocument.Builtindocumentproperties[Wdpropertysubject].Value:=Subject;
    Savechanges:=Wdsavechanges;
    Wordapp.Quit(Savechanges,Emptyparam,Emptyparam);
    Wordapp:=Unassigned;
    Result:=True;
  except
    on E:Exception do
  end;
end;

function Getdocinfo(const Filename:Widestring):string;
var
  Wordapp,Savechanges:Olevariant;
begin
  Result:='';
  try
    Wordapp:=Createoleobject('Word.Application');
    Wordapp.Visible:=False;
    Wordapp.Documents.Open(Filename);
    Result:=Result+Wordapp.Activedocument.Builtindocumentproperties[Wdpropertytitle].Value+#13;
    Result:=Result+Wordapp.Activedocument.Builtindocumentproperties[Wdpropertysubject].Value;
    Savechanges:=Wdsavechanges;
    Wordapp.Quit(Savechanges,Emptyparam,Emptyparam);
    Wordapp:=Unassigned;
  except
    on E:Exception do
  end;
end;

function Setexlinfo(Afile:string;Title,Subject:string):Boolean;
var
  Xap,Savechanges:Olevariant;
begin
  Result:=False;
  try
    Xap:=Createoleobject('Excel.Application');
    Xap.Visible:=False;
    Xap.Displayalerts:=False;
    Xap.Workbooks.Open(Afile);
    Xap.Activeworkbook.Builtindocumentproperties[Wdpropertytitle].Value:=Title;
    Xap.Activeworkbook.Builtindocumentproperties[Wdpropertysubject].Value:=Subject;
    Savechanges:=Wdsavechanges;
    Xap.Activeworkbook.Save;
    Xap.Quit;
    Xap:=Unassigned;
    Result:=True;
  except
    on E:Exception do
  end;
end;

function Getexlinfo(const Filename:Widestring):string;
var
  Xap,Savechanges:Olevariant;
begin
  Result:='';
  try
    Xap:=Createoleobject('Excel.Application');
    Xap.Visible:=False;
    Xap.Displayalerts:=False;
    Xap.Workbooks.Open(Filename);
    Result:=Result+Xap.Activeworkbook.Builtindocumentproperties[Wdpropertytitle].Value+#13;
    Result:=Result+Xap.Activeworkbook.Builtindocumentproperties[Wdpropertysubject].Value;
    Xap.Quit;
    Xap:=Unassigned;
  except
    on E:Exception do
  end;
end;

function FileTimeToDateTimeStr(f:Tfiletime):string;
var
  Localfiletime:Tfiletime;
  Systemtime:Tsystemtime;
  Datetime:Tdatetime;
begin
  if Comp(f)=0 then Result:='-'
  else begin
    Filetimetolocalfiletime(f,Localfiletime);
    Filetimetosystemtime(Localfiletime,Systemtime);
    with Systemtime do
        Datetime:=Encodedate(Wyear,Wmonth,Wday)+Encodetime(Whour,Wminute,Wsecond,Wmilliseconds);
    Result:=Datetimetostr(Datetime);
  end;
end;

/// //////////////////////////////////////////////////////////////////////////////

end.
