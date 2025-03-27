program AMD;

{$R *.dres}

uses
  System.Sharemem,
  System.Ioutils,
  System.Types,
  System.Sysutils,
  System.Strutils,
  System.Classes,
  Vcl.Forms,
  Win11Forms,
  Vcl.Dialogs,
  Vcl.Themes,
  Vcl.Styles,
  Winapi.Windows,
  Winapi.Messages,
  amdfun1 in 'amdfun1.pas',
  amdfun2 in 'amdfun2.pas',
  Vcl.Styles.Utils.SystemMenu in 'Vcl.Styles.Utils.SystemMenu.pas',
  clsFileType in 'clsFileType.pas',
  ToolTipManager in 'ToolTipManager.pas',
  PrintGrid in 'PrintGrid.pas',
  AMD.Export in 'AMD.Export.pas',
  isResourceWriterUnit in 'isResourceWriterUnit.pas',
  unitExIcon in 'unitExIcon.pas',
  unitResourceGraphics in 'unitResourceGraphics.pas',
  unitResourceDetails in 'unitResourceDetails.pas',
  wincrypt in 'wincrypt.pas',
  uEncrypt in 'uEncrypt.pas',
  Vcl.TrayIco in 'Vcl.TrayIco.pas',
  EmptyVC in 'EmptyVC.pas',
  STGS in 'STGS.pas',
  Excel2020 in 'Excel2020.pas',
  Word2020 in 'Word2020.pas',
  AMD.DragDrop in 'AMD.DragDrop.pas',
  AMD.DragDropComObj in 'AMD.DragDropComObj.pas',
  AMD.DragDropContext in 'AMD.DragDropContext.pas',
  AMD.DragDropFile in 'AMD.DragDropFile.pas',
  AMD.DragDropFormats in 'AMD.DragDropFormats.pas',
  AMD.DragDropGraphics in 'AMD.DragDropGraphics.pas',
  AMD.DragDropHandler in 'AMD.DragDropHandler.pas',
  AMD.DragDropInternet in 'AMD.DragDropInternet.pas',
  AMD.DragDropPIDL in 'AMD.DragDropPIDL.pas',
  AMD.DragDropText in 'AMD.DragDropText.pas',
  Dragitem in 'Dragitem.pas',
  AMD.DropCombo in 'AMD.DropCombo.pas',
  AMD.DropHandler in 'AMD.DropHandler.pas',
  AMD.DropSource in 'AMD.DropSource.pas',
  AMD.DropTarget in 'AMD.DropTarget.pas',
  BMP in 'BMP.pas',
  AMD.Comp.Client in 'firedac\AMD.Comp.Client.pas',
  AMD.Comp.DataSet in 'firedac\AMD.Comp.DataSet.pas',
  AMD.Comp.Script in 'firedac\AMD.Comp.Script.pas',
  AMD.Comp.UI in 'firedac\AMD.Comp.UI.pas',
  AMD.DatS in 'firedac\AMD.DatS.pas',
  AMD.Stan.Async in 'firedac\AMD.Stan.Async.pas',
  AMD.Stan.Consts in 'firedac\AMD.Stan.Consts.pas',
  AMD.Stan.Def in 'firedac\AMD.Stan.Def.pas',
  AMD.Stan.Error in 'firedac\AMD.Stan.Error.pas',
  AMD.Stan.Expr in 'firedac\AMD.Stan.Expr.pas',
  AMD.Stan.ExprFuncs in 'firedac\AMD.Stan.ExprFuncs.pas',
  AMD.Stan.Factory in 'firedac\AMD.Stan.Factory.pas',
  AMD.Stan.Intf in 'firedac\AMD.Stan.Intf.pas',
  AMD.Stan.Option in 'firedac\AMD.Stan.Option.pas',
  AMD.Stan.Param in 'firedac\AMD.Stan.Param.pas',
  AMD.Stan.Pool in 'firedac\AMD.Stan.Pool.pas',
  AMD.Stan.ResStrs in 'firedac\AMD.Stan.ResStrs.pas',
  AMD.Stan.SQLTimeInt in 'firedac\AMD.Stan.SQLTimeInt.pas',
  AMD.Stan.Storage in 'firedac\AMD.Stan.Storage.pas',
  AMD.Stan.Tracer in 'firedac\AMD.Stan.Tracer.pas',
  AMD.Stan.Util in 'firedac\AMD.Stan.Util.pas',
  amdmain in 'amdmain.pas' {AMDF},
  AMD.Phys in 'firedac\AMD.Phys.pas',
  AMD.Phys.SQLGenerator in 'firedac\AMD.Phys.SQLGenerator.pas',
  AMD.Phys.SQLite in 'firedac\AMD.Phys.SQLite.pas',
  AMD.Phys.SQLiteCli in 'firedac\AMD.Phys.SQLiteCli.pas',
  AMD.Phys.SQLiteDef in 'firedac\AMD.Phys.SQLiteDef.pas',
  AMD.Phys.SQLiteMeta in 'firedac\AMD.Phys.SQLiteMeta.pas',
  AMD.Phys.SQLiteVDataSet in 'firedac\AMD.Phys.SQLiteVDataSet.pas',
  AMD.Phys.SQLiteWrapper.FDEStat in 'firedac\AMD.Phys.SQLiteWrapper.FDEStat.pas',
  AMD.Phys.SQLiteWrapper in 'firedac\AMD.Phys.SQLiteWrapper.pas',
  AMD.Phys.SQLiteWrapper.SEEStat in 'firedac\AMD.Phys.SQLiteWrapper.SEEStat.pas',
  AMD.Phys.SQLiteWrapper.Stat in 'firedac\AMD.Phys.SQLiteWrapper.Stat.pas',
  AMD.Phys.SQLPreprocessor in 'firedac\AMD.Phys.SQLPreprocessor.pas',
  AMD.Phys.Intf in 'firedac\AMD.Phys.Intf.pas',
  AMD.DApt.Column in 'firedac\AMD.DApt.Column.pas',
  AMD.DApt.Intf in 'firedac\AMD.DApt.Intf.pas',
  AMD.DApt in 'firedac\AMD.DApt.pas',
  AMD.UI.Intf in 'firedac\AMD.UI.Intf.pas',
  AMD.UI in 'firedac\AMD.UI.pas',
  AMD.Phys.Meta in 'firedac\AMD.Phys.Meta.pas',
  AMD.ChromeTabs in 'AMD.ChromeTabs.pas',
  AMD.ChromeTabsClasses in 'AMD.ChromeTabsClasses.pas',
  AMD.ChromeTabsControls in 'AMD.ChromeTabsControls.pas',
  AMD.ChromeTabsGlassForm in 'AMD.ChromeTabsGlassForm.pas',
  AMD.ChromeTabsLog in 'AMD.ChromeTabsLog.pas',
  AMD.ChromeTabsThreadTimer in 'AMD.ChromeTabsThreadTimer.pas',
  AMD.ChromeTabsTypes in 'AMD.ChromeTabsTypes.pas',
  AMD.ChromeTabsUtils in 'AMD.ChromeTabsUtils.pas',
  STGAMAIN in 'STGAMAIN.pas' {SSTGA},
  amdfun3 in 'amdfun3.pas',
  UIRibbonActions in 'UIRibbonActions.pas',
  UIRibbonApi in 'UIRibbonApi.pas',
  UIRibbonCommands in 'UIRibbonCommands.pas',
  UIRibbonForm in 'UIRibbonForm.pas',
  UIRibbonUtils in 'UIRibbonUtils.pas',
  WinApiEx in 'WinApiEx.pas',
  RibbonMarkup in 'Ribbon\RibbonMarkup.pas',
  AMD.Files in 'AMD.Files.pas',
  UIRibbon in 'UIRibbon.pas',
  AMD.CategoryButtons in 'AMD.CategoryButtons.pas';

{$R *.res}
//madExpert;
var
	Datastruct:TCopyDataStruct;
	U,STRT:Integer;
	Q:string='';

procedure Loadvclstyles;
var
	I:Integer;
	R:Pris;
	Sh:TStyleManager.TStyleServicesHandle;
begin
	R:=nil;
	try
		R:=Aloadresorce('Sources\AHDL.dll','VCLSTYLE');
		with Tstringlist.Create do begin
			Text:=R.Ulist;
			if (R.Umoudle<>0)and(Count>0) then begin
				for I:=0 to Count-1 do TStyleManager.TryLoadFromResource(R.Umoudle,Strings[I],'VCLSTYLE',Sh);
			end;
			Free;
		end;
		Dispose(R);
	except
		on E:Exception do Dispose(R);
	end;
end;

procedure SendOutFiles(PTR:string='');
var
	S:string;
	Data:Pdat;
	DSIZE:Integer;
	Hw:Hwnd;
begin
	Hw:=FindWindow('TAMDF',nil);
	if (Paramcount<>0)and(Hw<>0) then begin
		S:=PTR;
		IF (PTR='') THEN
			IF (STRT=1) THEN S:=ParamStr(1)
			ELSE S:=ParamStr(3);
		DSIZE:=Sizeof(Word)+(Sizeof(Char)*Length(S));
		Getmem(Data,DSIZE);
		try
			Data.PLength:=Length(S);
			Strmove(Data.Pdata,Pchar(S),Length(S));
			Datastruct.Dwdata:=Id_msg;
			Datastruct.Cbdata:=DSIZE;
			Datastruct.Lpdata:=Data;
			SendMessage(Hw,Wm_copydata,0,Integer(@Datastruct));
		finally FreeMem(Data);
		end;
	end;
end;

begin
	Mutex:=Createmutex(nil,True,'AMDZ');
	STRT:=1;
	if (Paramcount<>0) then
		if (ParamStr(1)='DROP') then
			if (Paramcount>2) then STRT:=3;
	if (Mutex=0)or(GetLastError=ERROR_ALREADY_EXISTS) then begin
		if (Paramcount<>0) then
			for U:=STRT to Paramcount do
				if (OutFiles.IndexOf(ParamStr(U))=-1) then BEGIN
					OutFiles.Add(ParamStr(U));
					OutFiles1.Add(ParamStr(U));
					SendOutFiles(ParamStr(U));
				END;
		// IF (Paramcount=1) THEN SendOutFiles;
		Halt(0);
	end else begin
		if (Paramcount<>0) then
			for U:=STRT to Paramcount do
				if (OutFiles.IndexOf(ParamStr(U))=-1) then BEGIN
					OutFiles.Add(ParamStr(U));
					OutFiles1.Add(ParamStr(U));
				END;

		Loadvclstyles;
		ReportMemoryLeaksOnShutdown:=True;
		Application.Initialize;
		Application.Mainformontaskbar:=True;
		Application.CreateForm(TAMDF, AMDF);
  Application.CreateForm(TSSTGA, SSTGA);
  SendOutFiles;
		Application.Showmainform:=False;
		Application.Run;
	end;
	Releasemutex(Mutex);

end.
