unit AMD.Export;

interface

uses
	Winapi.Windows,
	System.Sysutils,
	System.Classes,
	Vcl.Dialogs,
	System.Inifiles,
	System.Variants,
	Excel2020,
	Word2020,
	Office2020,
	Stgs,
	Amdfun1;

function Sgtexcel(Sj:TsJ;Asheetname,Afilename:string):Boolean;
function Exceltsg(Sj:Tsg;Asheetname,Afilename:string):Boolean;
function Sgtword(Sj:TsJ;Afilename:string):Boolean;
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
	Xap:ExcelApplication;
	Sh: array [1..5] of excelworksheet;
	Lcid1:Cardinal;
	ER:ExcelRange;
begin
	Lcid1:=Getuserdefaultlcid;
	Data:=Vararraycreate([1,Sj.Rowcount,1,Sj.Colcount],Varvariant);
	for I:=0 to Sj.Colcount-1 do
		for J:=0 to Sj.Rowcount-1 do Data[J+1,I+1]:=Sj.Cells[I,J];
	Result:=False;
	try
		Xap:=CoExcelApplication.Create;
		Xap.Visible[Lcid1]:=False;
		Xap.Displayalerts[Lcid1]:=False;
		Xap.Workbooks.Add(Emptyparam,Lcid1);
		Sh[1]:=Xap.ActiveWorkbook.Worksheets.Item[1] as _worksheet;
		Sh[1].Name:=Asheetname+Chr(Ord('A'));
		Sh[2]:=Xap.ActiveWorkbook.Worksheets.Add(Emptyparam,Emptyparam,Emptyparam,Emptyparam,Lcid1) as _worksheet;
		// Sh[2]:=Xap.ActiveWorkbook.Worksheets.Item[1] as _worksheet;
		Sh[2].Name:=Asheetname+Chr(Ord('B'));

		for I:=1 to 2 do begin
			Sh[I].Activate(Lcid1);
			Sh[I].Range[Reftocell(1,1),Reftocell(Sj.Rowcount,Sj.Colcount)].Value2:=Data;
			Sh[I].Usedrange[Lcid1].Columns.Autofit;
			Sh[I].Usedrange[Lcid1].Horizontalalignment:=-4108;
			Sh[I].Usedrange[Lcid1].Verticalalignment:=-4108;
			Sh[I].Usedrange[Lcid1].Borders.Weight:=2;
			ER:=Sh[I].Range[Reftocell(1,1),Reftocell(1,Sj.Colcount)];
			ER.Font.Bold:=True;
			ER.RowHeight:=20;
			ER.Interior.Color:=Rgb(180,220,255);
			Sh[I].Usedrange[Lcid1].Font.Color:=Rgb(0,0,255);
			Sh[I].Usedrange[Lcid1].AutoFilter(1,Emptyparam,xlFilterValues,Emptyparam,True,Emptyparam);
			for J:=1 to Sj.Colcount do Sh[I].Range[Reftocell(1,J),Reftocell(1,J)].Addcomment(Sj.Cells[J-1,0]);
		end;
		{ Xap.ActiveWorkbook.Title[Lcid1]:='amd Title';
			Xap.ActiveWorkbook.Subject[Lcid1]:='amd Subject';
			Xap.ActiveWorkbook.Author[Lcid1]:='amd Author';
			Xap.ActiveWorkbook.Keywords[Lcid1]:='amd Keywords1;amd Keywords2;amd Keywords3';
			Xap.ActiveWorkbook.Comments[Lcid1]:='amd Comments'; }
		// Xap.ActiveWorkbook.Password:='0000';
		// Xap.ActiveWorkbook.WritePassword:='0000';
		Xap.ActiveWorkbook.Saveas(Afilename,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,xlNoChange,Emptyparam,
			Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Lcid1);
		Xap.ActiveWorkbook.Close(True,Afilename,Emptyparam,Lcid1);
		Result:=True;
		Xap.Quit;
		Varclear(Data);
		Data:=Unassigned;
	except
		on E:Exception do begin
			ShowMessage(E.Tostring);
			Xap.Quit;
			Varclear(Data);
			Data:=Unassigned;
		end;
	end;
end;

function Exceltsg(Sj:Tsg;Asheetname,Afilename:string):Boolean;
var
	Rangematrix:Olevariant;
	X,Y,K,R,C,I:Integer;
	Xap:ExcelApplication;
	Sh:_worksheet;
	S:string;
	Lcid1:Cardinal;
begin
	Lcid1:=Getuserdefaultlcid;
	Result:=False;
	try
		Xap:=CoExcelApplication.Create;
		Xap.Visible[Lcid1]:=False;
		Xap.Displayalerts[Lcid1]:=False;
		Xap.Workbooks.Open(Afilename,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,
			Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Lcid1);
		Sh:=(Xap.Worksheets[Asheetname] as _worksheet);
		Sh.Activate(Lcid1);
		{ c:=XAp.Workbooks[1].Worksheets.Count;
			for I:=1 to c do begin
			S:=S+(XAp.Workbooks[1].Worksheets[I] as _Worksheet).Name+#13;
			end; }
		X:=Xap.Cells.Specialcells(11,Emptyparam).Row;
		Y:=Xap.Cells.Specialcells(11,Emptyparam).Column;
		Sj.Rowcount:=X;
		Sj.Colcount:=Y;
		Rangematrix:=Xap.Range['A1',Xap.Cells.Item[X,Y]].Value2;
		for K:=1 to X do
			for R:=1 to Y do Sj.Cells[R-1,K-1]:=Rangematrix[K,R];
		// AMDF.SGTLC(SJ);
		Result:=True;
		Xap.Quit;
		Rangematrix:=Unassigned;
	except
		on E:Exception do begin
			ShowMessage(E.Tostring);
			Xap.Quit;
			Rangematrix:=Unassigned;
		end;
	end;

end;

function Sgtword(Sj:TsJ;Afilename:string):Boolean;
var
	X,Y,Cl,Rw:Integer;
	Wd:wordapplication;
begin
	Result:=False;
	try
		Wd:=CoWordApplication.Create;
		Wd.Displayalerts:=0;
		Wd.Visible:=False;
		Wd.Documents.Add(Emptyparam,Emptyparam,Emptyparam,Emptyparam);
		Cl:=Sj.Colcount;
		Rw:=Sj.Rowcount;
		Wd.Activedocument.Content.Font.Size:=Sj.Font.Size;
		Wd.Activedocument.Content.Font.Color:=Sj.Font.Color;
		Wd.Activedocument.Pagesetup.Orientation:=wdOrientLandscape; // 0 Portrait - 1 Landscape
		Wd.Activedocument.Pagesetup.Rightmargin:=10;
		Wd.Activedocument.Pagesetup.Leftmargin:=10;
		Wd.Activedocument.Pagesetup.Topmargin:=10;
		Wd.Activedocument.Pagesetup.Bottommargin:=10;
		Wd.Activedocument.Tables.Add(Wd.Activedocument.Content,Rw,Cl,Emptyparam,Emptyparam);
		Wd.Activedocument.Tables.Item(1).Borders.Insidelinestyle:=1;
		Wd.Activedocument.Tables.Item(1).Borders.Outsidelinestyle:=1;
		Wd.Activedocument.Tables.Item(1).Rows.Item(1).Shading.Backgroundpatterncolor:=Rgb(180,220,255);
		for X:=1 to Rw do
			for Y:=1 to Cl do Wd.Activedocument.Tables.Item(1).Cell(X,Y).Range.Insertafter(Sj.Cells[Y-1,X-1]);
		Wd.Activedocument.Tables.Item(1).Range.Paragraphformat.Alignment:=1;
		// Xap.ActiveWorkbook.Password:='0000';
		// Xap.ActiveWorkbook.WritePassword:='0000';
		Wd.Activedocument.Saveas(Afilename,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,
			Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam);
		Result:=True;
		Wd.Activedocument.Close(wdPromptToSaveChanges,Wdworddocument,False);
		Wd.Quit(wdPromptToSaveChanges,Wdworddocument,False);
	except
		on E:Exception do begin
			ShowMessage('SGTWORD'+#13+E.Tostring);
			Wd.Quit(wdPromptToSaveChanges,Wdworddocument,False);
		end;
	end;
end;

function Wordtsg(Sj:Tsg;Afilename:string):Boolean;
var
	X,Y,Cl,Rw:Integer;
	Wd:wordapplication;
	S:string;
begin
	Result:=False;
	try
		Wd:=CoWordApplication.Create;
		Wd.Displayalerts:=0;
		Wd.Visible:=False;
		Wd.Documents.Open(Afilename,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,
			Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam);
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
		// AMDF.SGTLC(SJ);
		Result:=True;
		Wd.Quit(True,Emptyparam,Emptyparam);
	except
		on E:Exception do begin
			ShowMessage('WORDTSG'+#13+E.Tostring);
			Wd.Quit(True,Emptyparam,Emptyparam);
		end;
	end;
end;

function Sgtcsv(Sj:Tsg;Afilename:string):Boolean;
var
	I:Integer;
	Csv:Tstringlist;
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
	Csv:Tstringlist;
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
		// AMDF.SGTLC(SJ);
		Result:=True;
		Csv.Free;
	except
		on E:Exception do Csv.Free;
	end;
end;

function Exltwrd(Afilenameexl,Asheetname,Afilenamewrd:string):Boolean;
var
	Range:Wordrange;
	Xap:ExcelApplication;
	Sh:_worksheet;
	Wd:wordapplication;
	Numpars:Integer;
	Lcid1:Cardinal;
begin
	Lcid1:=Getuserdefaultlcid;
	Result:=False;
	try
		Xap:=CoExcelApplication.Create;
		Xap.Visible[Lcid1]:=False;
		Xap.Displayalerts[Lcid1]:=False;
		Xap.Workbooks.Open(Afilenameexl,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,
			Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Lcid1);
		Wd:=CoWordApplication.Create;
		Wd.Displayalerts:=0;
		Wd.Visible:=False;
		Wd.Documents.Add(Emptyparam,Emptyparam,Emptyparam,Emptyparam);
		Wd.Activedocument.Pagesetup.Orientation:=1; // 0 Portrait - 1 Landscape
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
		Wd.Documents.Item(1).Saveas(Afilenamewrd,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,
			Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam);
		Result:=True;
		Wd.Documents.Item(1).Close(Wdsavechanges,Wdworddocument,False);
		Wd.Quit(True,Emptyparam,Emptyparam);
		Xap.Quit;
	except
		on E:Exception do begin
			ShowMessage('EXLTWRD'+#13+E.Tostring);
			Xap.Quit;
			Wd.Quit(True,Emptyparam,Emptyparam);
		end;
	end;
end;

function Wrdtexl(Afilenamewrd,Afilenameexl:string):Boolean;
var
	Wd:wordapplication;
	Xap:ExcelApplication;
	Bok:excelworkbook;
	Sh:excelworksheet;
	Lcid1:Cardinal;
begin
	Lcid1:=Getuserdefaultlcid;
	Result:=False;
	try
		Wd:=CoWordApplication.Create;
		Wd.Displayalerts:=0;
		Wd.Visible:=False;
		Wd.Documents.Open(Afilenamewrd,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,
			Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam,Emptyparam);
		Wd.Activedocument.Tables.Item(1).Select;
		Wd.Selection.Copy;
		Xap:=CoExcelApplication.Create;
		Xap.Visible[Lcid1]:=False;
		Xap.Displayalerts[Lcid1]:=False;
		Xap.Workbooks.Add(Emptyparam,Lcid1);
		Bok:=CoExcelWorkbook.Create;
		Sh:=CoExcelWorksheet.Create;
		Sh.Name:='AMD'+Chr(Ord('A'));
		Sh.Usedrange[Lcid1].Pastespecial(Xlpastevalues,Xlpastespecialoperationnone,Emptyparam,Emptyparam);
		Xap.Workbooks[1].Savecopyas(Afilenameexl,Lcid1);
		Bok.Close(True,Afilenameexl,Emptyparam,Lcid1); // Saves the changes to mentioned file//
		Result:=True;
		Xap.Quit;
		Wd.Quit(True,Emptyparam,Emptyparam);
	except
		on E:Exception do begin
			ShowMessage('WRDTEXL'+#13+E.Tostring);
			Xap.Quit;
			Wd.Quit(True,Emptyparam,Emptyparam);
		end;
	end;
end;

end.
