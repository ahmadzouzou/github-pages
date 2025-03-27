unit AMDExport0;

interface

uses
  Windows,
  Sysutils,
  Classes,
  Dialogs,
  Inifiles,
  System.Variants,
  Excel2010,
  Word2010,
  Stgs,
  Amdfun1;

function Sgtexcel(Sj:TsJ;Asheetname,Afilename:string):Boolean;
function Exceltsg(Sj:Tsg;Asheetname,Afilename:string):Boolean;
function Sgtword(Sj:Tsj;Afilename:string):Boolean;
function Wordtsg(Sj:Tsg;Afilename:string):Boolean;
function Sgtcsv(Sj:Tsg;Afilename:string):Boolean;
function Csvtsg(Sj:Tsg;Afilename:string):Boolean;
function Exltwrd(Afilenameexl,Asheetname,Afilenamewrd:string):Boolean;
function Wrdtexl(Afilenamewrd,Afilenameexl:string):Boolean;

implementation

uses
  Amdmain;

function Sgtexcel(Sj:TsJ;Asheetname,Afilename:string):Boolean;
  function Reftocell(Arow,Acol:Integer):string;
  begin
    Result:=Chr(Ord('A')+Acol-1)+Arow.Tostring;
  end;

const
  Xlworksheet=-4167;
  Xlbottom=-4107;
  Xlleft=-4131;
  Xlright=-4152;
  Xltop=-4160;
  Xlhaligncenter=-4108;
  Xlvaligncenter=-4108;
  Xlthin=2;
var
  Row,Col:Integer;
  S:string;
  Data:Olevariant;
  I,J,Numpars:Integer;
  Xap:Texcelapplication;
  Bok:Texcelworkbook;
  Sh:array[1..5000] of Texcelworksheet;
  Lcid1:Cardinal;
begin
  Lcid1:=Getuserdefaultlcid;
  Data:=Vararraycreate([1,Sj.Rowcount,1,Sj.Colcount],Varvariant);
  for I:=0 to Sj.Colcount-1 do begin
    for J:=0 to Sj.Rowcount-1 do begin
      Data[J+1,I+1]:=Sj.Cells[I,J];
    end;
  end;
  Result:=False;
  try
    Xap:=Texcelapplication.Create(nil);
    Xap.Connect;
    Xap.Visible[Lcid1]:=False;
    Xap.Displayalerts[Lcid1]:=False;
    Xap.Workbooks.Add(Emptyparam,Lcid1);
    Bok:=Texcelworkbook.Create(Xap);
    Bok.Connectto(Xap.Activeworkbook);
    Sh[1]:=Texcelworksheet.Create(Bok);
    Sh[1].Connectto(Bok.Activesheet as _worksheet);
    Sh[1].Name:=Asheetname+Chr(Ord('A'));
    Bok.Worksheets.Add(Emptyparam,Emptyparam,Emptyparam,Emptyparam,Lcid1);
    Sh[2]:=Texcelworksheet.Create(Bok);
    Sh[2].Connectto(Bok.Activesheet as _worksheet);
    Sh[2].Name:=Asheetname+Chr(Ord('B'));
    for I:=1 to 2 do begin
      Sh[I].Activate;
      Sh[I].Range[Reftocell(1,1),Reftocell(Sj.Rowcount,Sj.Colcount)].Value2:=Data;
      Sh[I].Usedrange[Lcid1].Columns.Autofit;
      Sh[I].Usedrange[Lcid1].Horizontalalignment:=-4108;
      Sh[I].Usedrange[Lcid1].Verticalalignment:=-4108;
      Sh[I].Usedrange[Lcid1].Borders.Weight:=2;
      Sh[I].Range[Reftocell(1,1),Reftocell(1,Sj.Colcount)].Font.Bold:=True;
      Sh[I].Usedrange[Lcid1].Font.Color:=Rgb(0,0,255);
      Sh[I].Range[Reftocell(1,1),Reftocell(1,Sj.Colcount)].Interior.Color:=Rgb(180,220,255);
      for J:=1 to Sj.Colcount do begin
        Sh[I].Range[Reftocell(1,J),Reftocell(1,J)].Addcomment(Sj.Cells[J-1,0]);
      end;
      Sh[I].Disconnect;
      Freeandnil(Sh[I]);
    end;
    Xap.Workbooks[1].Savecopyas(Afilename,Lcid1);
    Bok.Close(True,Afilename);//Saves the changes to mentioned file//
    Bok.Disconnect;
    Freeandnil(Bok);
    Result:=True;
    Xap.Disconnect;
    Xap.Quit;
    Freeandnil(Xap);
    Varclear(Data);
    Data:=Unassigned;
  except
    on E:Exception do begin
      Showmessage(E.Tostring);
      Xap.Disconnect;
      Xap.Quit;
      Freeandnil(Xap);
      Varclear(Data);
      Data:=Unassigned;
    end;
  end;
end;

function Exceltsg(Sj:Tsg;Asheetname,Afilename:string):Boolean;
var
  Rangematrix:Olevariant;
  X,Y,K,R,C,I:Integer;
  Xap:Texcelapplication;
  Sh:_worksheet;
  S:string;
  Lcid1:Cardinal;
begin
  Lcid1:=Getuserdefaultlcid;
  Result:=False;
  try
    Xap:=Texcelapplication.Create(nil);
    Xap.Connect;
    Xap.Visible[Lcid1]:=False;
    Xap.Displayalerts[Lcid1]:=False;
    Xap.Workbooks.Open(Afilename,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,
      Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,
      Emptyparam,Lcid1);
    Sh:=(Xap.Worksheets[Asheetname] as _worksheet);
    Sh.Activate(Lcid1);
    {c:=XAp.Workbooks[1].Worksheets.Count;
     for I:=1 to c do begin
     S:=S+(XAp.Workbooks[1].Worksheets[I] as _Worksheet).Name+#13;
     end;}
    X:=Xap.Cells.Specialcells(11,Emptyparam).Row;
    Y:=Xap.Cells.Specialcells(11,Emptyparam).Column;
    Sj.Rowcount:=X;
    Sj.Colcount:=Y;
    Rangematrix:=Xap.Range['A1',Xap.Cells.Item[X,Y]].Value2;
    for K:=1 to X do begin
      for R:=1 to Y do begin
        Sj.Cells[R-1,K-1]:=Rangematrix[K,R];
      end;
    end;
    //AMDF.SGTLC(SJ);
    Result:=True;
    Xap.Disconnect;
    Xap.Quit;
    Freeandnil(Xap);
    Rangematrix:=Unassigned;
  except
    on E:Exception do begin
      Showmessage(E.Tostring);
      Xap.Disconnect;
      Xap.Quit;
      Freeandnil(Xap);
      Rangematrix:=Unassigned;
    end;
  end;

end;

function Sgtword(Sj:Tsj;Afilename:string):Boolean;
var
  X,Y,Cl,Rw:Integer;
  Wd:Twordapplication;
begin
  Result:=False;
  try
    Wd:=Twordapplication.Create(nil);
    Wd.Connect;
    Wd.Displayalerts:=0;
    Wd.Visible:=False;
    Wd.Documents.Add(Emptyparam,Emptyparam,Emptyparam,Emptyparam);
    Cl:=Sj.Colcount;
    Rw:=Sj.Rowcount;
    Wd.Activedocument.Content.Font.Size:=Sj.Font.Size;
    Wd.Activedocument.Content.Font.Color:=Sj.Font.Color;
    Wd.Activedocument.Pagesetup.Orientation:=1;//0 Portrait - 1 Landscape
    Wd.Activedocument.Pagesetup.Rightmargin:=10;
    Wd.Activedocument.Pagesetup.Leftmargin:=10;
    Wd.Activedocument.Pagesetup.Topmargin:=10;
    Wd.Activedocument.Pagesetup.Bottommargin:=10;
    Wd.Activedocument.Tables.Add(Wd.Activedocument.Content,Rw,Cl,Emptyparam,Emptyparam);
    Wd.Activedocument.Tables.Item(1).Borders.Insidelinestyle:=1;
    Wd.Activedocument.Tables.Item(1).Borders.Outsidelinestyle:=1;
    Wd.Activedocument.Tables.Item(1).Rows.Item(1).Shading.Backgroundpatterncolor:=Rgb(180,220,255);
    for X:=1 to Rw do begin
      for Y:=1 to Cl do begin
        Wd.Activedocument.Tables.Item(1).Cell(X,Y).Range.Insertafter(Sj.Cells[Y-1,X-1]);
      end;
    end;
    Wd.Activedocument.Tables.Item(1).Range.Paragraphformat.Alignment:=1;
    Wd.Documents.Item(1).Saveas(Afilename,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,
      Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,
      Emptyparam,Emptyparam);
    Result:=True;
    Wd.Documents.Item(1).Close(Wdsavechanges,Wdworddocument,False);
    Wd.Disconnect;
    Wd.Quit;
    Freeandnil(Wd);
  except
    on E:Exception do begin
      Showmessage('SGTWORD'+#13+E.Tostring);
      Wd.Disconnect;
      Wd.Quit;
      Freeandnil(Wd);
    end;
  end;
end;

function Wordtsg(Sj:Tsg;Afilename:string):Boolean;
var
  X,Y,Cl,Rw:Integer;
  Wd:Twordapplication;
  S:string;
begin
  Result:=False;
  try
    Wd:=Twordapplication.Create(nil);
    Wd.Connect;
    Wd.Displayalerts:=0;
    Wd.Visible:=False;
    Wd.Documents.Open(Afilename,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,
      Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,
      Emptyparam);
    Rw:=Wd.Activedocument.Tables.Item(1).Rows.Count;
    Cl:=Wd.Activedocument.Tables.Item(1).Columns.Count;
    Sj.Rowcount:=Rw;
    Sj.Colcount:=Cl;
    for X:=1 to Rw do begin
      for Y:=1 to Cl do begin
        S:=Wd.Activedocument.Tables.Item(1).Cell(X,Y).Range.Text;
        Sj.Cells[Y-1,X-1]:=Stringreplace(S,Copy(S,Pos(#13,S),Length(S)),'',[Rfreplaceall]);
      end;
    end;
    //AMDF.SGTLC(SJ);
    Result:=True;
    Wd.Disconnect;
    Wd.Quit;
    Freeandnil(Wd);
  except
    on E:Exception do begin
      Showmessage('WORDTSG'+#13+E.Tostring);
      Wd.Disconnect;
      Wd.Quit;
      Freeandnil(Wd);
    end;
  end;
end;

function Sgtcsv(Sj:Tsg;Afilename:string):Boolean;
var
  I:Integer;
  Csv:Tstrings;
begin
  Result:=False;
  try
    Csv:=Tstringlist.Create;
    for I:=0 to Sj.Rowcount-1 do begin
      Csv.Add(Sj.Rows[I].Commatext);
    end;
    Csv.Savetofile(Afilename);
    Result:=True;
    Csv.Free;
  except
    on E:Exception do Csv.Free;
  end;
end;

function Csvtsg(Sj:Tsg;Afilename:string):Boolean;
var
  I:Integer;
  Csv:Tstrings;
begin
  Result:=False;
  try
    Csv:=Tstringlist.Create;
    Csv.Loadfromfile(Afilename);
    Sj.Rowcount:=Csv.Count;
    Sj.Colcount:=Gr0(Csv.Strings[0],',');
    for I:=0 to Csv.Count-1 do begin
      Sj.Rows[I].Commatext:=Csv.Strings[I];
    end;
    //AMDF.SGTLC(SJ);
    Result:=True;
    Csv.Free;
  except
    on E:Exception do Csv.Free;
  end;
end;

function Exltwrd(Afilenameexl,Asheetname,Afilenamewrd:string):Boolean;
var
  Range:Wordrange;
  Xap:Texcelapplication;
  Sh:_worksheet;
  Wd:Twordapplication;
  Numpars:Integer;
  Lcid1:Cardinal;
begin
  Lcid1:=Getuserdefaultlcid;
  Result:=False;
  try
    Xap:=Texcelapplication.Create(nil);
    Xap.Connect;
    Xap.Visible[Lcid1]:=False;
    Xap.Displayalerts[Lcid1]:=False;
    Xap.Workbooks.Open(Afilenameexl,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,
      Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,
      Emptyparam,Lcid1);
    Wd:=Twordapplication.Create(nil);
    Wd.Connect;
    Wd.Displayalerts:=0;
    Wd.Visible:=False;
    Wd.Documents.Add(Emptyparam,Emptyparam,Emptyparam,Emptyparam);
    Wd.Activedocument.Pagesetup.Orientation:=1;//0 Portrait - 1 Landscape
    Wd.Activedocument.Pagesetup.Rightmargin:=10;
    Wd.Activedocument.Pagesetup.Leftmargin:=10;
    Wd.Activedocument.Pagesetup.Topmargin:=10;
    Wd.Activedocument.Pagesetup.Bottommargin:=10;
    Numpars:=Wd.Documents.Item(1).Paragraphs.Count;
    Sh:=(Xap.Worksheets[Asheetname] as _worksheet);
    Sh.Activate(Lcid1);
    Sh.Usedrange[Lcid1].Copy(Emptyparam);
    Range:=Wd.Documents.Item(1).Range(Wd.Documents.Item(1).Paragraphs.Item(Numpars).Range.Start,
      Wd.Documents.Item(1).Paragraphs.Item(Numpars).Range.End_);
    Range.Paste;
    Wd.Documents.Item(1).Content.Paragraphformat.Alignment:=1;
    Wd.Documents.Item(1).Saveas(Afilenamewrd,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,
      Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,
      Emptyparam,Emptyparam);
    Result:=True;
    Wd.Documents.Item(1).Close(Wdsavechanges,Wdworddocument,False);
    Wd.Disconnect;
    Wd.Quit;
    Freeandnil(Wd);
    Xap.Disconnect;
    Xap.Quit;
    Freeandnil(Xap);
  except
    on E:Exception do begin
      Showmessage('EXLTWRD'+#13+E.Tostring);
      Xap.Disconnect;
      Xap.Quit;
      Freeandnil(Xap);
      Wd.Disconnect;
      Wd.Quit;
      Freeandnil(Wd);
    end;
  end;
end;

function Wrdtexl(Afilenamewrd,Afilenameexl:string):Boolean;
var
  Wd:Twordapplication;
  Xap:Texcelapplication;
  Bok:Texcelworkbook;
  Sh:Texcelworksheet;
  Lcid1:Cardinal;
begin
  Lcid1:=Getuserdefaultlcid;
  Result:=False;
  try
    Wd:=Twordapplication.Create(nil);
    Wd.Connect;
    Wd.Displayalerts:=0;
    Wd.Visible:=False;
    Wd.Documents.Open(Afilenamewrd,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,
      Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,
      Emptyparam,Emptyparam);
    Wd.Activedocument.Tables.Item(1).Select;
    Wd.Selection.Copy;
    Xap:=Texcelapplication.Create(nil);
    Xap.Connect;
    Xap.Visible[Lcid1]:=False;
    Xap.Displayalerts[Lcid1]:=False;
    Xap.Workbooks.Add(Emptyparam,Lcid1);
    Bok:=Texcelworkbook.Create(Xap);
    Bok.Connectto(Xap.Activeworkbook);
    Sh:=Texcelworksheet.Create(Bok);
    Sh.Connectto(Bok.Activesheet as _worksheet);//-4163
    Sh.Name:='AMD'+Chr(Ord('A'));
    Sh.Usedrange[Lcid1].Pastespecial(Xlpastevalues,Xlpastespecialoperationnone,Emptyparam,
      Emptyparam);
    Sh.Disconnect;
    Freeandnil(Sh);
    Xap.Workbooks[1].Savecopyas(Afilenameexl,Lcid1);
    Bok.Close(True,Afilenameexl);//Saves the changes to mentioned file//
    Bok.Disconnect;
    Freeandnil(Bok);
    Result:=True;
    Xap.Disconnect;
    Xap.Quit;
    Freeandnil(Xap);
    Wd.Disconnect;
    Wd.Quit;
    Freeandnil(Wd);
  except
    on E:Exception do begin
      Showmessage('WRDTEXL'+#13+E.Tostring);
      Xap.Disconnect;
      Xap.Quit;
      Freeandnil(Xap);
      Wd.Disconnect;
      Wd.Quit;
      Freeandnil(Wd);
    end;
  end;
end;

end.
