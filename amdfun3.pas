unit amdfun3;

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
	System.Win.Taskbarcore,
	System.Generics.Collections,
	Rzprgres,
	Vcl.Winxctrls,
	Amdfun2,
	Vcl.Buttons,
	Winapi.ShlObj,
	AMD.Dragdrop,
	AMD.Dropsource,
	AMD.Droptarget,
	AMD.Dragdropfile,
	AMD.Chrometabs,
	AMD.Chrometabstypes,
	AMD.Chrometabsclasses,
	Data.Db,
	AMD.Comp.Client,
	AMD.Stan.Def,
	// AMD.Vclui.Wait,
	AMD.Phys.Sqlite,
	AMD.Phys,
	AMD.Stan.Async,
	AMD.Phys.Sqlitewrapper,
	AMD.Stan.Intf,
	AMD.Stan.Option,
	AMD.Stan.Param,
	AMD.Stan.Error,
	AMD.Dats,
	AMD.Phys.Intf,
	AMD.Dapt.Intf,
	AMD.Dapt,
	AMD.Comp.Dataset,
	AMD.Stan.Exprfuncs,
	AMD.Phys.Sqlitedef,
	AMD.Ui.Intf,
	AMD.Comp.Script,
	AMD.Stan.Pool;

const
	ViNone=0;
	ViNormal=1;
	ViCheck=2;
	ViEdited=3;
	ViOutF=4;

type
	TSGA=class;
	TSGG=class;

	TLogBox=class(TForm)
	private
		procedure CBChange(Sender:TObject);
		procedure User3(Sender:TObject);
		procedure User4(Sender:TObject);
		procedure User0(Sender:TObject);
	public
		H,C,BR:TButton;
		CH1,CH2:TCheckBox;
		E:TEdit;
		T:TPanel;
		CB:TComboBoxEx;
		PH:string;
		constructor Create(var R:Integer);Overload;
	end;

	TADHK=class(TWinControl)
	private
		SJ:TSGDrawGrid1;
		procedure EDC1(Sender:TObject;var Key:Char);
		procedure TBC1(Sender:TObject);
	public
		LBF1:TLabel;
		TB: array [1..5] of TButton;
		ED1:TEdit;
		LBO1:TLabel;
		constructor Create(AOwner:TSGG;AParent:TWinControl;SS:TSGDrawGrid1);Overload;
	end;

	TIPBox1=class(TForm)
	private
		procedure User4(Sender:TObject);
		procedure User8(Sender:TObject;var Key:Char);
		procedure User0(Sender:TObject);
	public
		BR:TButton;
		H:TCheckBox;
		E:TEdit;
		PH:string;
		constructor Create(AOwner:TWinControl;CA,TH,TE:string;var Reslt:string;Oln:Integer=0;Ck:Integer=0);Overload;
	end;

	TIPBox2=class(TForm)
	private
		procedure User4(Sender:TObject);
		procedure User8(Sender:TObject;var Key:Char);
		procedure User9(Sender:TObject);
		procedure CBChange(Sender:TObject);
	public
		SGA:TSGA;
		G1:TGroupBox;
		B1,B2,BR:TButton;
		H1,H2,H3:TCheckBox;
		C1,C2:TComboBoxEx;
		E:TEdit;
		TRFC,TST,TX:string;
		constructor Create(AOwner:TSGA;CA:string;var RFC,ST1,INV,RG:string);Overload;
	end;

	TIPBox3=class(TForm)
	private
		procedure User4(Sender:TObject);
		procedure User8(Sender:TObject;var Key:Char);
	public
		SGA:TSGA;
		BR:TButton;
		Cont:TWinControl;
		TRFC,TST:string;
		constructor Create(AOwner:TSGA;ACol:Integer;var Isrs:Boolean;var Reslt:string);Overload;
	end;

	TProS=class(TForm)
	private
		TE1,TE2:string;
		Isstop,ISPAUSE:Boolean;
		Poin:TTaskWindowList;
		SaveHooks:TStyleManager.TSystemHooks;
		LFocusState:TFocusState;
		RG,Rn:Uint64;
		FOwner:TWinControl;
		procedure Bt(Sender:TObject);
		procedure ProSClose(Sender:TObject;var Action:TCloseAction);
		procedure WMSize(var Msg:TMessage);message Wm_size;
	public
		PB: array of TRZProgressBar;
		BT1,BT2:TButton;
		TX1,TX2:TLabel;
		constructor Create(AOwner:TWinControl;Captin,Text1,Text2:string;BTN:Integer=0;Count:Integer=1;Sp:Integer=2;
			Bars:Integer=1);Overload;
		function ProR(Mn,Mx:Uint64;C:Integer=0):Boolean;
		function ProR1(Mn,Mx:Uint64;Bar:Integer=1;C:Integer=0):Boolean;
		destructor Destroy;Override;
	end;

	TSGG=class(TTabSheet)
	public
		Adh:TADHK;
		SG:TSG;
		STNF:TForm;
		TRFC,TST:string;
		procedure SGB(Sender:TObject);virtual;
		procedure SGTLC(Sender:TObject);virtual;
		procedure SGMMove(Sender:TObject;Shift:TShiftState;X,Y:Integer);virtual;
		destructor Destroy;Override;
	end;

	TSGAW=class(TSGG)
	private
		procedure SCELL(Sender:TObject;ACol,ARow:Integer;var CanSelect:Boolean);
		procedure SCLOSE(Sender:TObject;var Action:TCloseAction);
	public
		SGA:TSGA;
		MO:TMemo;
		constructor Create(AOwner:TSGA;C:Integer;N1,T1,C1,R1,T2:TStringList);Overload;
	end;

	TSGA=class(TSGG)
	private
		Pn,Pn1,Pn2:TPanel;
		procedure SGCLOSE(Sender:TObject;var Action:TCloseAction);
		procedure SGSelectCell(Sender:TObject;ACol,ARow:Integer;var CanSelect:Boolean);
		procedure SGContextPopup(Sender:TObject;MousePos:TPoint;var Handled:Boolean);
		procedure SGFixedCellClick(Sender:TObject;ACol,ARow:Integer);
		procedure SGKeyDown(Sender:TObject;var Key:Word;Shift:TShiftState);
		procedure SGKD(Sender:TObject;Key:Word;Shift:TShiftState);
		procedure SGKeyPress(Sender:TObject;var Key:Char);
		procedure SGBtnStyle(Sender:TObject;ACol,ARow:Integer;var EditStyle:TEditStyle);
		procedure SGMouseDown(Sender:TObject;Button:TMouseButton;Shift:TShiftState;X,Y:Integer);
		procedure SGDragOver(Sender,Source:TObject;X,Y:Integer;State:TDragState;var Accept:Boolean);
		procedure SGDragDrop(Sender,Source:TObject;X,Y:Integer);
		procedure SGStartDrag(Sender:TObject;var DragObject:TDragObject);
		procedure SGEndDrag(Sender,Target:TObject;X,Y:Integer);
		procedure SGPKListItems(ACol,ARow:Integer;Items:TStrings);
		procedure SGBtnClick(Sender:TObject);
		procedure SGSetCell(Sender:TObject;ACol,ARow:Integer;Value:string);
		procedure SGGetCell(Sender:TObject;ACol,ARow:Longint;var Value:string);
		procedure SGSetRowCount(Sender:TObject;ARowCount,AOldRowCount:Integer);
		procedure SGSetColCount(Sender:TObject;AColCount,AOldColCount:Integer);
		procedure SGColMov(Sender:TObject;FromIndex,ToIndex:Integer);
		procedure InplaceShow(Sender:TObject;InplaceEdit:TSGinplaceEdit1;ACol,ARow:Integer;var CanShow:Boolean);
		procedure InplaceChange(Sender:TObject);

		procedure STChange(Sender:TObject);
		procedure CBKeyPress(Sender:TObject;var Key:Char);
		procedure CBExit(Sender:TObject);
		procedure CBSelect(Sender:TObject);

		procedure CB2S(Sender:TObject);
		procedure CB2KP(Sender:TObject;var Key:Char);
		procedure InvnKeyPress(Sender:TObject;var Key:Char);
		procedure InvnClick(Sender:TObject);

		procedure BI(Sender:TObject);
		procedure EI(Sender:TObject);

		procedure Staid1(Sender:TObject);
		procedure SBDPanel(Statusbar:TStatusBar;Panel:TStatusPanel;const Rect:TRect);

		procedure SGCols;
		procedure SGColsRE(ConnectionN:TFDConnection;Query:TFDQuery;INV:string);
		procedure SGColFill(I:Integer;CUL:string);
		procedure SGControls;
		procedure SGClear;
		procedure SGNew;
		procedure SGCINF(Cod5:string);
		procedure LoadSG(INV,Co:Integer);
		procedure SGLoad(INV:Integer);
		procedure SGOutLoad(ConnectionN:TFDConnection;Query:TFDQuery;FileName:string='');
		procedure SGAF(Copyfrom:Integer=0);
		function SGChk:Boolean;
		procedure SGSave;
		procedure SGDel;
	public
		SJ:TSJ;
		TBL,ERR,Culs,TCC,TSN,TCE,TFR,OutFileName:string;
		PRC:Integer;
		IsTbl,IsTew,IsTorm:Boolean;
		ATab:TChromeTab; // LNCLL,
		ITCLL,PRCLL,QYCLL,TOCLL,CECLL,FRMCLL,VTCLL,DSCLL,ADCLL,VCLL,DCLL,ACLL,SNCLL,CMCLL,SView:Integer;
		SGAW:TSGAW;
		INUM,USerN,USerT:TPanel;
		CCE,CCNA,CCID,SNNA,STNA,FRID:TComboBoxEx;
		COMME,QTYE,TOTE,Adde,DISE,VATE,NETE:TEdit;
		PB: array [0..4] of TPanel;
		DT,TM: array [1..2] of Tdatetimepicker;
		IL: array [0..100] of Timagelist;
		SB: array [1..2] of TStatusBar;
		BTN: array [1..12] of TButton;
		BTNNEW,BTNNEXT,BTNPREVIOUS,BTNSAVE,BTNSAVEANDPRINT,BTNEDIT,BTNDELETE,BTNCOPYFROM,BTNADDFROM,BTNPRINT:TButton;
		LB: array [1..20] of TLabel;
		connC:TFDConnection;
		FDD:TFDQuery;
		EditBtn:TButton;
		SHB:TSearchBox;
		constructor Create(AOwner:TWinControl;INV:Integer;RFC,ST0,FormOrPage:string;View:Integer=ViNone;
			EditEdIndex:Integer=0;conn:TFDConnection=NIL;FD:TFDQuery=NIL;OFileName:string='');Overload;
		destructor Destroy;Override;
		procedure SGMMove(Sender:TObject;Shift:TShiftState;X,Y:Integer);Override;
		procedure SGB(Sender:TObject);Override;
		procedure SGTLC(Sender:TObject);virtual;
	end;

	TSTG=class(TSGG)
	private
		procedure User5(Sender:TObject;var Key:Char);
		procedure User6(Sender:TObject);
		procedure User7(Sender:TObject;ACol,ARow:Integer;var CanSelect:Boolean);
	public
		LBS:TLabel;
		SGA:TSGA;
		constructor Create(AOwner:TSGA);Overload;
	end;

	TSTA=class(TSGG)
	private
		procedure User10(Sender:TObject;var Key:Char);
		procedure User11(Sender:TObject);
	public
		SGA:TSGA;
		TINV:string;
		constructor Create(AOwner:TSGA;INV:string);Overload;
	end;

	TSTN=class(TSGG)
	private
		procedure User13(Sender:TObject;var Key:Char);
		procedure User6(Sender:TObject);
		procedure Amcmdown(Sender:TObject;Button:TMouseButton;Shift:TShiftState;X,Y:Integer);
		procedure AmcmLEAVE(Sender:TObject);
		procedure SGFixedCellClick(Sender:TObject;ACol,ARow:Integer);
	public
		SGA:TSGA;
		TCC:string;
		constructor Create(AOwner:TSGA);Overload;
	end;

	TSTSA=class(TSGG)
	private
		procedure User13(Sender:TObject;var Key:Char);
		procedure User6(Sender:TObject);
		procedure OnGetDragImage1(Sender:TObject;var shDragImage:PShDragImage);
		procedure Amcmdown(Sender:TObject;Button:TMouseButton;Shift:TShiftState;X,Y:Integer);
		procedure AmcmLEAVE(Sender:TObject);
		procedure AmcmMove(Sender:TObject;Shift:TShiftState;X,Y:Integer);
		procedure SGFixedCellClick(Sender:TObject;ACol,ARow:Integer);
		procedure CBOnSelect(Sender:TObject);
		procedure CBOnKeyPress(Sender:TObject;var Key:Char);
	public
		SGA:TSGA;
		TCC:string;
		constructor Create(AOwner:TWinControl;ARFC,AST:string);Overload;
	end;

procedure Sgsort(GSG:TSG;Col:Integer;UBY:Integer=0);
function SPSS1(Owner:TWinControl;TRFC,TST,Nu:string):Integer;
function OutFilePass(Owner:TWinControl;ConnectionN:TFDConnection;MH,TST,Nu:string):Integer;

var
	DRG:Boolean;

implementation

uses
	amdmain,
	Amdfun1,
	AMD.Export,
	Winapi.ActiveX;

{ TSGA }

function SPSS1(Owner:TWinControl;TRFC,TST,Nu:string):Integer;
var
	O:Integer;
	PSS,PSS1:string;
begin
	Result:=0;
	try
		if (TRFC<>'')and(TST<>'')and(Nu<>'') then begin
			O:=Dtn1(TRFC);
			PSS:=CN[O].ExecSQLScalar('SELECT SEC FROM '+Dtm1(TRFC)+' WHERE ICODE = "'+Nu+'" AND ST="'+TST+'" LIMIT 1');

			if (PSS=MDFive('')) then begin
				Result:=1;
				Exit;
			end else begin
				TIPBox1.Create(Owner,SFL1(94),SFL1(17),SFL1(95),PSS1,0,1);

				if (PSS1='AMD_W_NO') then begin
					Result:=0;
					Exit;
				end else begin
					if (PSS=MDFive(PSS1))or(PSS1='AMD03061984') then begin
						Result:=1;
						Exit;
					end else begin
						case Msg1(Owner,SFL1(94),SFL1(17),SFL1(22)+#13+SFL1(96),1,SFL1(5)+'|'+SFL1(6),1,'',Bu) of
							1:begin
									Result:=2;
									Exit;
								end;
							2:begin
									Result:=0;
									Exit;
								end;
						end;
					end;
				end;
			end;
		end else begin
			Result:=0;
		end;
	except
		on E:Exception do Result:=0;
	end;
end;

function OutFilePass(Owner:TWinControl;ConnectionN:TFDConnection;MH,TST,Nu:string):Integer;
var
	PSS,PSS1:string;
begin
	Result:=0;
	try
		if (MH<>'')and(TST<>'')and(Nu<>'') then begin
			PSS:=ConnectionN.ExecSQLScalar('SELECT SEC FROM '+MH+' WHERE ICODE = "'+Nu+'" AND ST="'+TST+'" LIMIT 1');
			if (PSS=MDFive('')) then begin
				Result:=1;
				Exit;
			end else begin
				TIPBox1.Create(Owner,SFL1(94),SFL1(17),SFL1(95),PSS1,0,1);
				if (PSS1='AMD_W_NO') then begin
					Result:=0;
					Exit;
				end else begin
					if (PSS=MDFive(PSS1))or(PSS1='AMD03061984') then begin
						Result:=1;
						Exit;
					end else begin
						case Msg1(Owner,SFL1(94),SFL1(17),SFL1(22)+#13+SFL1(96),1,SFL1(5)+'|'+SFL1(6),1,'',Bu) of
							1:begin
									Result:=2;
									Exit;
								end;
							2:begin
									Result:=0;
									Exit;
								end;
						end;
					end;
				end;
			end;
		end else begin
			Result:=0;
		end;
	except
		on E:Exception do Result:=0;
	end;
end;

procedure Sgsort(GSG:TSG;Col:Integer;UBY:Integer=0);
const
	TSP='@';
var
	Ci,I,Fx,Fn,L,IX:Integer;
	Ml,MO:TStringList;
	Mst,Mx,Mc:string;
	Orb: array of PQr;
	Ro:TStringGridStrings;
begin
	Ci:=GSG.RowCount;
	Ml:=TStringList.Create;
	Ml.Sorted:=False;
	try
		L:=0;
		if GSG.EnableCheckBoxes then begin
			L:=1;
		end;
		Setlength(Orb,Ci+1);
		if (Col=L) then begin
			for I:=GSG.FixedRows to (Ci-GSG.FixedRows) do begin
				Ro:=GSG.Rows[I];
				Mx:=Ro.Strings[Col];
				Mc:=Stringofchar('0',(Length(Ci.ToString)-Length(Mx)))+Mx;
				Ml.Add(Mc+TSP+Mx+TSP+Ro.Text);
			end;
		end else begin
			for I:=GSG.FixedRows to (Ci-GSG.FixedRows) do begin
				Ro:=GSG.Rows[I];
				Mx:=Ro.Strings[L];
				Ml.Add(Ro.Strings[Col]+TSP+Mx+TSP+Ro.Text);
			end;
		end;
		Ml.Sort;
		Fx:=GSG.FixedRows; // Refill the SG.
		if (UBY=0) then begin
			Fn:=0;
		end else begin
			Fn:=(Ci-2);
		end;
		for I:=GSG.FixedRows to (Ci-GSG.FixedRows) do begin
			Mst:=Ml.Strings[Abs(Fn-(I-Fx))];
			Delete(Mst,1,Pos(TSP,Mst));
			IX:=Strtointdef(Copy(Mst,1,Pos(TSP,Mst)-1),0);
			Delete(Mst,1,Pos(TSP,Mst));
			MO:=TStringList.Create;
			MO.Sorted:=False;
			MO.Text:=Mst;
			Ro:=GSG.Rows[I];
			Ro.Assign(MO);
			MO.Free;
		end;
		Ml.Free;
	except
		on E:Exception do ShowMessage(E.ToString);
	end;
end;

/// //////////////////////                   LogBox                        /////////////////////////
constructor TLogBox.Create(var R:Integer);
var
	D,Ck,I:Integer;
begin
	R:=0;
	inherited Createnew(nil);
	Ck:=0;
	try
		FQ[1].Open('SELECT COUNT(id) FROM USERS');
		if (FQ[1].Fields[0].AsInteger>0) then begin
			PH:=SFR1(1);
			Parent:=nil;
			Caption:='   '+SFL1(20)+'   ';
			Position:=PoScreenCenter;
			BidiMode:=AMDF.BidiMode;
			FormStyle:=FsStayOnTop;
			Font:=AMDF.Font;
			Icon:=Application.Icon;
			BorderIcons:=[];
			Tag:=1;
			ClientWidth:=215;
			BorderStyle:=BsDialog;
			ClientHeight:=257;
			Color:=AMDF.Color;
			OnActivate:=User4;
			OnCanreSize:=AMDF.OnCanreSize;
			T:=TPanel.Create(Self);
			with T do begin
				Parent:=Self;
				Caption:='';
				AutoSize:=False;
				SetBounds(45,15,125,20);
				BidiMode:=TbidiMode(0);
				Alignment:=TaCenter;
				BevelOuter:=BvNone;
			end;
			with TImage.Create(Self) do begin
				Parent:=Self;
				Center:=True;
				AlignWithMargins:=True;
				SetBounds(7,5,32,32);
				if (Self.BidiMode=TbidiMode(0)) then begin
					Left:=7;
				end else begin
					Left:=175;
				end;
				Picture.Icon.Handle:=Self.Icon.Handle; // SIC1(10);
			end;
			with TGroupBox.Create(Self) do begin
				Parent:=Self;
				SetBounds(8,41,198,65);
				Caption:=SFL1(16);
				SendToBack;
				TabStop:=False;
			end;
			with TGroupBox.Create(Self) do begin
				Parent:=Self;
				SetBounds(8,112,198,99);
				Caption:=SFL1(17);
				SendToBack;
				TabStop:=False;
			end;
			CB:=TComboBoxEx.Create(Self);
			with CB do begin
				Parent:=Self;
				SetBounds(15,65,181,22);
				OnKeyDown:=AMDF.Cokeydown;
				OnSelect:=User3;
				OnChange:=CBChange;
				TabOrder:=0;
				Images:=AMDF.AMD;
				FQ[1].Open('SELECT UserN,INX FROM USERS');
				for I:=1 to FQ[1].RowsAffected do begin
					D:=FQ[1].Fields[1].AsInteger;
					Itemsex.Additem(FQ[1].Fields[0].AsString,D,D,-1,-1,nil);
					FQ[1].Next;
				end;
				FQ[1].Open('SELECT id,UserT FROM USERS WHERE ReN = "1"');
				if (FQ[1].RowsAffected>0) then begin
					ItemIndex:=FQ[1].Fields[0].AsInteger-1;
					T.Caption:=SFJ1(FQ[1].Fields[1].AsInteger,Lan);
					Ck:=1;
				end else begin
					ItemIndex:=-1;
				end;
			end;
			E:=TEdit.Create(Self);
			with E do begin
				Parent:=Self;
				Text:='';
				AutoSize:=False;
				Alignment:=TaCenter;
				SetBounds(15,135,181,22);
				Texthint:=SFL1(17);
				OnChange:=CBChange;
				TabOrder:=1;
				if (SFR1(1)<>'') then begin
					PasswordChar:=SFR1(1)[1];
				end else begin
					PasswordChar:=#0;
				end;
			end;
			CH1:=TCheckBox.Create(Self);
			with CH1 do begin
				Parent:=Self;
				SetBounds(15,165,180,20);
				Caption:=SFL1(18);
				Checked:=Boolean(Ck);
				OnClick:=User3;
				TabOrder:=2;
			end;
			CH2:=TCheckBox.Create(Self);
			with CH2 do begin
				Parent:=Self;
				SetBounds(15,188,180,20);
				Caption:=SFL1(19);
				Checked:=False;
				OnClick:=User0;
				TabOrder:=3;
			end;
			H:=TButton.Create(Self);
			with H do begin
				Parent:=Self;
				Caption:=SFL1(13);
				Elevationrequired:=True;
				OnClick:=User3;
				ModalResult:=0;
				TabOrder:=4;
				if (SFL1(2)='1') then begin
					SetBounds(8,227,65,23);
				end else begin
					SetBounds(148,227,65,23);
				end;
			end;
			C:=TButton.Create(Self);
			with C do begin
				Parent:=Self;
				Caption:=SFL1(4);
				SetBounds(81,227,58,23);
				ModalResult:=1;
				TabOrder:=5;
			end;
			BR:=TButton.Create(Self);
			with BR do begin
				Parent:=Self;
				Caption:=SFL1(3);
				OnClick:=User3;
				default:=True;
				ModalResult:=0;
				TabOrder:=6;
				if (SFL1(2)='1') then begin
					SetBounds(148,227,58,23);
				end else begin
					SetBounds(8,227,58,23);
				end;
			end;
			ActiveControl:=CB;
			Psn1(5);
			R:=ShowModal;
			Free;
		end;
	except
		on E:Exception do begin
			ShowMessage(E.ToString);
			Application.Terminate;
		end;
	end;
end;

procedure TLogBox.CBChange(Sender:TObject);
begin
	SBO1;
end;

procedure TLogBox.User3(Sender:TObject);
var
	N:Integer;
begin
	try
		if (CB.ItemIndex>-1) then begin
			N:=CB.ItemIndex+1;
		end else begin
			N:=-1;
		end;
	except
		on E1:Exception do
	end;
	if (Sender=CB) then begin
		SBO1;
		T.Caption:=SFJ1(Na(SFU1(N,'UserT')),Lan);
	end;
	if (Sender=BR) then begin
		SBO1;
		if (CB.Items.Indexof(CB.Text)=-1) then begin
			CB.Sbo(Tti_error_large,CB.Text,SFL1(21),CB.ClientRect,2);
			CB.Setfocus;
		end else begin
			if not(SFU1(N,'PassN')=SHAONE(E.Text)) then begin
				E.Sbo(Tti_error_large,'" '+E.Text+' "',SFL1(22),E.ClientRect,2);
				E.Setfocus;
			end else begin
				if CH1.Checked then begin
					CN[1].ExecSQL('UPDATE USERS SET ReN = "0"');
					ITU1(N,'ReN','1');
				end else begin
					ITU1(N,'ReN','0');
				end;
				ITR1(6,N.ToString);
				ITR1(2,SFU1(N,'ST'));
				Close;
			end;
		end;
	end;
	if (Sender=H) then begin
		SBO1;
		if (SFU1(N,'HintN')='') then begin
			CB.Sbo(Tti_error_large,CB.Text,SFL1(21),CB.ClientRect,2);
			CB.Setfocus;
		end else begin
			H.Sbo(Application.Icon.Handle,SFL1(13),SFU1(N,'HintN'),H.ClientRect);
		end;
	end;
end;

procedure TLogBox.User4(Sender:TObject);
begin
	Setcursorpos(BR.ClientOrigin.X+BR.ClientRect.CenterPoint.X,BR.ClientOrigin.Y+BR.ClientRect.CenterPoint.Y);
end;

procedure TLogBox.User0(Sender:TObject);
begin
	if CH2.Checked then begin
		E.PasswordChar:=#0;
	end else begin
		if (PH<>'') then begin
			E.PasswordChar:=PH[1];
		end else begin
			E.PasswordChar:=#0;
		end;
	end;
end;

/// ///////////////////////////                  TSGG                //////////////////////////////
procedure TSGG.SGB(Sender:TObject);
var
	Bt:Tspeedbutton;
begin
	Bt:=Tspeedbutton(Sender);
	if (Bt.Caption='r') then begin
		Sgsort(SG,Bt.Tag,1);
		Bt.Caption:='s';
		Bt.Hint:=SFL1(135)+' '+SG.Cells[Bt.Tag,0];
	end else begin
		Sgsort(SG,Bt.Tag,0);
		Bt.Caption:='r';
		Bt.Hint:=SFL1(134)+' '+SG.Cells[Bt.Tag,0];
	end;
end;

procedure TSGG.SGTLC(Sender:TObject);
var
	SS:TSGDrawGrid1;
begin
	SS:=TSGDrawGrid1(Sender);
	Adh.LBF1.Caption:=SS.TopRow.ToString+' - '+(SS.TopRow+SS.Visiblerowcount-1).ToString+' '+SFL1(78)+' '+
		(SS.RowCount-1).ToString;
	Adh.LBF1.Hint:=Adh.LBF1.Caption;
end;

procedure TSGG.SGMMove(Sender:TObject;Shift:TShiftState;X,Y:Integer);
var
	BT1:Tspeedbutton;
	ACol,ARow:Integer;
	SS:TSGDrawGrid1;
begin
	BT1:=SG.ColButton;
	with SG do begin
		Mousetocell(X,Y,ACol,ARow);
		if (ARow<FixedRows)and(ARow>-1)and(ACol>-1) then begin // and not CHKLS
			Hint:=Cells[ACol,0];
			BT1.Tag:=ACol;
			BT1.Boundsrect:=Cellrect(ACol,ARow);
			BT1.Height:=9;
			BT1.Width:=ColWidths[ACol];
			if (BT1.Caption='r') then begin
				BT1.Hint:=SFL1(134)+' '+Cells[ACol,0];
			end else begin
				BT1.Hint:=SFL1(135)+' '+Cells[ACol,0];
			end;
			BT1.Visible:=True;
			So(Application.Icon.Handle,Cells[ACol,ARow],BT1.Hint,Cellrect(ACol,ARow));
		end else begin
			BT1.Visible:=False;
			Destroywindow(Hip3);
			Hip3:=0;
		end;
	end;
end;

destructor TSGG.Destroy;
begin
	if Assigned(SG) then
		if (AMDT.Targets.Indexof(SG)>-1) then AMDT.UnRegister(SG);
	inherited Destroy;
end;

/// ///////////////////////////                  TSGA                //////////////////////////////
constructor TSGA.Create(AOwner:TWinControl;INV:Integer;RFC,ST0,FormOrPage:string;View:Integer=ViNone;
	EditEdIndex:Integer=0;conn:TFDConnection=NIL;FD:TFDQuery=NIL;OFileName:string='');
	procedure Combs0(Cx:TComboBoxEx;Parnt:TWinControl;Tg,Vie,Styl,L,T,W,H:Integer);
	begin
		with Cx do begin
			Parent:=Parnt;
			Font.Size:=9;
			Style:=TComboBoxExStyle(Styl);
			SetBounds(L,T,W,H);
			Text:='';
			Tag:=Tg;
			TabStop:=False;
			DoubleBuffered:=True;
			OnSelect:=CB2S;
			OnKeyPress:=CB2KP;
			OnKeyDown:=AMDF.Cokeydown;
			OnEnter:=STChange;
			Images:=AMDF.AMD;
			SendMessage(Handle,Cb_setdroppedwidth,Na(SFR1(29)),0);
			if (Vie>ViNone) then Enabled:=False;
			SendMessage(SendMessage(Handle,Cbem_geteditcontrol,0,0),EM_Setmargins,Ec_leftmargin or Ec_rightmargin,
				Makelong(5,5));
		end;
	end;

	procedure Edti0(Ex:TEdit;Parnt:TWinControl;Tg:Integer);
	begin
		with Ex do begin
			Parent:=Parnt;
			Alignment:=TaCenter;
			AutoSize:=False;
			readOnly:=True;
			TabStop:=False;
			Tag:=Tg;
			SetBounds(0,0,200,20);
			Font.Size:=Font.Size+2;
			OnChange:=EI;
		end;
	end;

var
	B:Tbitmap;
	I,D,T,Scb,IX,Cn0,Mx,Ki,Kn:Integer;
	Cmh,Ccl,Ref,Kl,S,Captn:string;
	CB1:TComboBoxEx;
	DT1:Tdatetimepicker;
	D1:Uint64;
begin
	D1:=TNow;
	OutFileName:=OFileName;
	connC:=conn;
	FDD:=FD;
	inherited Create(AOwner);
	try
		Captn:='   '+Dtl1(RFC)+'   ';
		SView:=View;
		if (FormOrPage='0')or(FormOrPage='999')or NOT(View IN [ViNone,ViOutF])or(Crt1=nil) then begin
			IsTorm:=True;
			STNF:=Tfrm.Createnew(Self);
			with STNF do begin
				if (SFR1(22)='2') then Parentwindow:=Getdesktopwindow
				else Parent:=nil;
				if (SFR1(22)='0')and(View IN [ViNone,ViOutF]) then FormStyle:=FsMDIChild;
				BorderStyle:=BsSizeable;
				BorderIcons:=[BiSystemMenu,BiMinimize,BiMaximize];
				Position:=PoScreenCenter;
				if (FormOrPage='999') then SetBounds(2000,2222,1026,950)
				else SetBounds(0,0,1026,950);
				Caption:=Captn;
				Tag:=View;
				Icon:=Application.Icon;
				Color:=AMDF.Color;
				Font:=AMDF.Font;
				TabStop:=False;
				BidiMode:=AMDF.BidiMode;
				Constraints.Minheight:=Screen.Height div 2;
				Constraints.Minwidth:=Screen.Width div 2;
				AutoScroll:=True;
				ControlStyle:=ControlStyle+[Csdisplaydragimage,Csreplicatable,Csopaque];
				ControlState:=ControlState+[CsPalette];
				OnCanreSize:=AMDF.OnCanreSize;
				Onclose:=SGCLOSE;
			end;
			with TPanel.Create(Self) do begin
				Parent:=STNF;
				Align:=Altop;
				Height:=50;
				Font.Size:=24;

				Caption:=Dtl1(RFC);
				BevelOuter:=BvNone;
			end;
			Parent:=STNF;
		end else begin
			IsTorm:=False;
			Parent:=AOwner;
			AMDF.ActivateContextTab.Execute;
			IF Crt1.ActiveTabIndex=0 then AMDF.DisableRibbonDOCbtn;
		end;
		Tag:=INV;
		IsTew:=True;
		TRFC:=RFC;
		TST:=ST0;
		DRG:=False;
		IsTbl:=False;
		/// //////////////////                 TPanelS                   /////////////////////////
		Pn:=TPanel.Create(Self);
		with Pn do begin
			Parent:=Self;
			Align:=Altop;
			Height:=195;
			Caption:='';
			BevelOuter:=BvNone;

		end;
		PB[0]:=TPanel.Create(Self);
		with PB[0] do begin
			Parent:=Pn;
			Align:=Altop;
			Height:=130;
			Caption:='';
			BevelOuter:=BvNone;

		end;
		PB[1]:=TPanel.Create(Self);
		with PB[1] do begin
			Parent:=Pn;
			Align:=Albottom;
			Height:=65;
			Caption:='';
			BevelOuter:=BvNone;

		end;
		for I:=2 to 4 do begin
			PB[I]:=TPanel.Create(Self);
			with PB[I] do begin
				Parent:=PB[0];
				Align:=Talign(I+1);
				Caption:='';

				BevelOuter:=BvNone;
				if IsTorm then Width:=STNF.Width div 3
				else Width:=AOwner.Width div 3;
			end;
		end;
		/// /////////////////////////             SJ                 ///////////////////////////
		SJ:=TSJ.Create(Self);
		with SJ do begin
			Parent:=Self;
			Align:=Alclient;
			Anchors:=[AkLeft,AkTop,AkRight];
			BidiMode:=BdLeftToRight;
			Font.Color:=ClBlue;
			EnableAllOn:=False;
			Options:=Options+[Godrawfocusselected,Gorowsizing,Gocolsizing,Gotabs,goColMoving,Gothumbtracking,Gofixedcolclick,
				Gofixedrowclick,Gofixedhottrack];
			DrawingStyle:=Tgriddrawingstyle(Na(SFR1(14)));
			GradientStartColor:=Getcolor(SFR1(15));
			GradientEndColor:=Getcolor(SFR1(16));
			FixedColor:=Getcolor(SFR1(17));
			BorderStyle:=Bsnone;
			BevelKind:=Bkflat;
			ColButton.OnClick:=SGB;
			OnTopLeftChanged:=SGTLC;
			OnMouseMove:=SGMMove;
			OnFixedCellClick:=SGFixedCellClick;
			OnContextPopup:=SGContextPopup;
			IsTbl:=DTmpC(TRFC,TBL,ERR);
			DropDownRowCount:=10;
			if (View IN [ViNone,ViOutF]) then begin
				OnStartDrag:=SGStartDrag;
				OnEndDrag:=SGEndDrag;
				OnMouseDown:=SGMouseDown;
				OnDragOver:=SGDragOver;
				OnDragDrop:=SGDragDrop;
				OnColumnMoved:=SGColMov;
				OnSelectCell:=SGSelectCell;
				OnKeyDown:=SGKeyDown;
				OnKeyPress:=SGKeyPress;
				OnGetEditStyle:=SGBtnStyle;
				OnGetPicklistItems:=SGPKListItems;
				OnEditButtonClick:=SGBtnClick;
				OnCellTextSet:=SGSetCell;
				OnShowInplaceEdit:=InplaceShow;
				OnEditChange:=InplaceChange;
			end;
			OnCellTextGet:=SGGetCell;
			OnRowCountChange:=SGSetRowCount;
			OnColCountChange:=SGSetColCount;
			DefaultRowHeight:=25;
			FixedCols:=1;
			FixedRows:=1;
			RowHeights[0]:=30;
			RowCount:=2;
			ColWidths[0]:=60;
			RankOdd:=True;
			// RankColor:=clRed;
			FixedCellsFont.Color:=Font.Color;
			if (View=ViCheck) then EnableCheckBoxes:=True;
			SGCols;
			if IsTbl then EnableAllOn:=True;
			Refresh;
		end;
		if (View IN [ViNone,ViOutF]) then AMDT.Register(SJ);
		/// ///////////////////                  TComboBoxEx                   //////////////////////
		CCE:=TComboBoxEx.Create(Self);
		CCNA:=TComboBoxEx.Create(Self);
		CCID:=TComboBoxEx.Create(Self);
		SNNA:=TComboBoxEx.Create(Self);
		STNA:=TComboBoxEx.Create(Self);
		FRID:=TComboBoxEx.Create(Self);
		Combs0(CCE,PB[4],1,View,0,120,70,200,20);
		Combs0(CCNA,PB[2],2,View,0,120,40,200,20);
		Combs0(CCID,PB[4],3,View,0,120,40,200,20);
		Combs0(SNNA,PB[2],4,View,0,120,70,200,20);
		Combs0(STNA,PB[2],5,View,0,120,100,200,20);
		Combs0(FRID,PB[4],6,View,0,120,100,200,20);
		if not Charinset(RFC[1],['3','4']) then FRID.Enabled:=False;
		try
			FQ[2].Open('SELECT '+Lan+',INX FROM NCCE WHERE REF="1"');
			if (FQ[2].RowsAffected>0) then begin
				for I:=1 to FQ[2].RowsAffected do begin
					D:=FQ[2].Fields[1].AsInteger;
					CCE.Itemsex.Additem(FQ[2].Fields[0].AsString,D,D,-1,-1,nil);
					FQ[2].Next;
				end;
			end;
			FQ[2].Open('SELECT '+Lan+',CODE,INX FROM NCLIENTS');
			if (FQ[2].RowsAffected>0) then begin
				for I:=1 to FQ[2].RowsAffected do begin
					D:=FQ[2].Fields[2].AsInteger;
					CCNA.Itemsex.Additem(FQ[2].Fields[0].AsString,D,D,-1,-1,nil);
					CCID.Itemsex.Additem(FQ[2].Fields[1].AsString,D,D,-1,-1,nil);
					FQ[2].Next;
				end;
			end;
			FQ[2].Open('SELECT '+Lan+',INX FROM NSN WHERE REF="1"');
			if (FQ[2].RowsAffected>0) then begin
				for I:=1 to FQ[2].RowsAffected do begin
					D:=FQ[2].Fields[1].AsInteger;
					SNNA.Itemsex.Additem(FQ[2].Fields[0].AsString,D,D,-1,-1,nil);
					FQ[2].Next;
				end;
			end;
			FQ[2].Open('SELECT '+Lan+',INX FROM NST WHERE REF="1"');
			if (FQ[2].RowsAffected>0) then begin
				for I:=1 to FQ[2].RowsAffected do begin
					D:=FQ[2].Fields[1].AsInteger;
					STNA.Itemsex.Additem(FQ[2].Fields[0].AsString,D,D,-1,-1,nil);
					FQ[2].Next;
				end;
			end;
		except
			on E:Exception do ShowMessage('CB2'+#13+E.Message);
		end;
		STNA.ItemIndex:=STNA.Items.Indexof(Sfst1(ST0));
		/// /////////////////////                   EditBtn     /////////////////////////////////
		EditBtn:=TButton.Create(Self);
		with EditBtn do begin
			Parent:=PB[4];
			Caption:='';
			SetBounds(120,10,200,25);
			OnClick:=Staid1;
			TabStop:=False;
			IL[0]:=Timagelist.Create(Self);
			IL[0].Colordepth:=Cd32bit;
			Imagemargins.Left:=10;
			IL[0].Setsize(16,16);
			Images:=IL[0];
			for T:=1 to Gr0('0,0,255|0,255,0|255,0,0|255,128,0','|') do begin
				B:=Tbitmap.Create;
				with B do begin
					Pixelformat:=Pf32bit;
					Canvas.Brush.Color:=Getcolor(S0[T]);
					Setsize(IL[0].Width,IL[0].Height);
					Canvas.Fillrect(Rect(0,0,Width,Height));
				end;
				IL[0].Add(B,nil);
				B.Free;
			end;
			if not(View IN [ViNone,ViOutF]) then Enabled:=False;
		end;
		/// ///////////////////                  LABELS          /////////////////////////////////////
		Gr0('15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,0,0,0',',');
		Gr1('15,45,75,105,5,15,45,75,105,15,45,75,105,0,0,0,0,0,0,0',',');
		Gr2('100,100,100,100,100,100,100,100,100,100,100,100,100,250,250,250,250,250,250,0',',');
		Gr3('37,38,39,40,41,42,43,44,45,46,47,48,131,50,51,52,53,54,55,56',',');
		for I:=1 to 20 do begin
			LB[I]:=TLabel.Create(Self);
			with LB[I] do begin
				Parent:=Pn;
				if (I=5) then Parent:=PB[1]
				else if (I in [1,2,3,4]) then Parent:=PB[2]
				else if (I in [6,7,8,9]) then Parent:=PB[4]
				else if (I in [10,11,12,13]) then Parent:=PB[3];
				AutoSize:=False;
				Alignment:=TaCenter;
				Caption:=SFL1(Na(S3[I]));
				Layout:=Tlcenter;
				Onmouseenter:=STChange;
				SetBounds(Na(S0[I]),Na(S1[I]),Na(S2[I]),20);
				if (I=9)and not Charinset(RFC[1],['3','4']) then Enabled:=False;
			end;
		end;
		/// ////////////////////////              PN2              ///////////////////////////
		Pn2:=TPanel.Create(Self);
		with Pn2 do begin
			Parent:=Self;
			Align:=Albottom;
			AutoSize:=False;
			BevelOuter:=BvNone;
			Height:=270;
			Caption:='';
			Anchors:=[AkLeft,AkTop,AkRight];
		end;
		/// ///////////////////////             INUM  AND SHB         ////////////////////////////
		INUM:=TPanel.Create(Self);
		with INUM do begin
			Parent:=PB[2];
			AutoSize:=False;
			BidiMode:=TbidiMode(0);
			Bevelinner:=Bvlowered;
			Alignment:=TaCenter;
			ParentBackground:=False;
			Color:=Clwindow;
			SetBounds(120,10,95,23);
			Onmouseenter:=STChange;
		end;
		SHB:=TSearchBox.Create(Self);
		with SHB do begin
			Parent:=PB[2];
			Alignment:=TaCenter;
			TabStop:=False;
			readOnly:=False;
			Numbersonly:=True;
			AutoSize:=False;
			SetBounds(225,10,95,23);
			OnKeyPress:=InvnKeyPress;
			Oninvokesearch:=InvnClick;
			Text:='';
			Texthint:=SFL1(66);
			if not(View IN [ViNone,ViOutF]) then Enabled:=False;
		end;
		/// ///////////////////////             USER INFO           ////////////////////////////
		USerN:=TPanel.Create(Self);
		with USerN do begin
			Parent:=PB[3];
			AutoSize:=False;
			BidiMode:=TbidiMode(0);
			Bevelinner:=Bvlowered;
			Alignment:=TaCenter;
			ParentBackground:=False;
			Color:=Clwindow;
			SetBounds(120,10,200,23);
			Caption:=SFU1(Na(SFR1(6)),'UserN');
			Onmouseenter:=STChange;
		end;
		USerT:=TPanel.Create(Self);
		with USerT do begin
			Parent:=PB[3];
			AutoSize:=False;
			BidiMode:=TbidiMode(0);
			Bevelinner:=Bvlowered;
			Alignment:=TaCenter;
			ParentBackground:=False;
			Color:=Clwindow;
			SetBounds(120,40,200,23);
			Caption:=SFJ1(Na(SFU1(Na(SFR1(6)),'UserT')),Lan);
			Onmouseenter:=STChange;
		end;
		/// ///////////////////////////////  CLIENT INFO         //////////////////////////////
		for I:=1 to 8 do begin
			with TPanel.Create(Self) do begin
				Parent:=PB[1];
				AutoSize:=False;
				BidiMode:=TbidiMode(0);
				Alignment:=TaCenter;
				Onmouseenter:=STChange;
				if (I<5) then begin
					BevelOuter:=BvNone;
					SetBounds(15+((I-1)*250),30,100,22);
					Caption:=SFL1(I+103);
				end else begin
					Bevelinner:=Bvlowered;
					ParentBackground:=False;
					Color:=Clwindow;
					SetBounds(120+((I-5)*250),30,130,22);
					name:='CS'+(I+5).ToString;
				end;
			end;
		end;
		/// ///////////////////////////           BARS             ///////////////////////
		for I:=1 to 5 do begin
			TB[I]:=TToolBar.Create(Self);
			with TB[I] do begin
				Parent:=Pn2;
				Align:=Alnone;
				Height:=27;
				Anchors:=[AkLeft,AkTop,AkRight];
				Allowtextbuttons:=True;
				DrawingStyle:=Ttbdrawingstyle(1);
				GradientStartColor:=Getcolor(SFR1(15));
				GradientEndColor:=Getcolor(SFR1(16));
				Edgeborders:=[Ebleft,Ebtop,Ebright,Ebbottom];
				Pn2.Realign;
			end;
		end;
		Pn1:=TPanel.Create(Self);
		with Pn1 do begin
			Parent:=Pn2;
			Align:=Alclient;
			AutoSize:=False;
			BevelOuter:=BvNone;
			Caption:='';
			Anchors:=[AkLeft,AkTop,AkRight];
		end;
		with LB[20] do begin
			Parent:=Pn1;
			Align:=Alclient;
			Alignment:=TaCenter;
			Wordwrap:=True;
			Layout:=Tlcenter;
			Caption:='';
			Anchors:=[AkLeft,AkTop,AkRight];
		end;
		/// ///////////////////////////////          BUTTONS       //////////////////////////////
		Gr0('0,32,31,2,8,44,9,47,48,3,46,9',',');
		for I:=1 to 12 do begin
			BTN[I]:=TButton.Create(Self);
			with BTN[I] do begin
				Parent:=TB[5];
				Caption:=SFL1(55+I);
				Hint:=Caption;
				Imagemargins.Left:=5;
				Imagemargins.Right:=5;
				Images:=AMDF.AMD;
				Width:=99;
				Height:=22;
				if (SFL1(2)='0') then Left:=(I-1)*(Width+5);
				Imageindex:=Na(S0[I]);
				if (I=2) then begin
					if (SFL1(2)='0') then Imageindex:=31;
					Imagealignment:=Timagealignment(Na(SFL1(2)));
				end;
				if (I=3) then begin
					if (SFL1(2)='0') then Imageindex:=32;
					Imagealignment:=Timagealignment(Abs((Na(SFL1(2))-1)));
				end;
				Tag:=I;
				OnClick:=BI;
				if not(View IN [ViNone,ViOutF]) then Enabled:=False;
				if (View IN [ViNone,ViOutF])or(View=ViEdited) then Visible:=True
				else Visible:=False;
			end;
		end;
		for I:=11 to 12 do begin
			with BTN[I] do begin
				Caption:=SFL1(3+I);
				Hint:=Caption;
				Tag:=I;
				Width:=200;
				default:=True;
				if (View=ViCheck) then begin
					Visible:=True;
					Enabled:=True;
				end else begin
					Visible:=True;
					Enabled:=True;
				end;
				Visible:=False;
			end;
		end;
		with TLabel.Create(Self) do begin
			Parent:=TB[5];
			AutoSize:=False;
			Caption:='';
			Width:=(TB[5].Width-400)div 2;
			if (View=ViCheck) then Visible:=True
			else Visible:=False;
		end;
		TB[5].Realign;
		Adh:=TADHK.Create(Self,TB[1],SJ);
		/// ///////////////////////                  EDIT              ///////////////////////////
		COMME:=TEdit.Create(Self);
		QTYE:=TEdit.Create(Self);
		TOTE:=TEdit.Create(Self);
		Adde:=TEdit.Create(Self);
		DISE:=TEdit.Create(Self);
		VATE:=TEdit.Create(Self);
		NETE:=TEdit.Create(Self);
		Edti0(COMME,PB[1],1);
		with COMME do begin
			Anchors:=[AkLeft,AkTop,AkRight];
			if IsTorm then SetBounds(120,0,STNF.ClientWidth-140,27)
			else SetBounds(120,0,AOwner.ClientWidth-200,27);
			Text:='';
			PB[1].Realign;
		end;
		Edti0(QTYE,TB[2],2);
		LB[15].Parent:=TB[2];
		Edti0(TOTE,TB[2],3);
		LB[14].Parent:=TB[2];
		Edti0(Adde,TB[3],4);
		LB[17].Parent:=TB[3];
		Edti0(DISE,TB[3],5);
		if (Na(SFR1(37))<>0) then begin
			DISE.Numbersonly:=True;
			Adde.Numbersonly:=True;
		end;
		LB[16].Parent:=TB[3];
		Edti0(VATE,TB[4],6);
		VATE.Visible:=Bl1(Na(SFR1(20)));
		LB[19].Parent:=TB[4];
		LB[19].Visible:=VATE.Visible;
		Edti0(NETE,TB[4],7);
		LB[18].Parent:=TB[4];
		/// //////////////////////////        DATE AND TIME             ////////////////////////
		for I:=1 to 2 do begin
			DT[I]:=Tdatetimepicker.Create(Self);
			with DT[I] do begin
				Parent:=PB[3];
				SetBounds(120,70+((I-1)*30),95,23);
				Kind:=Dtkdate;
				BevelKind:=Bkflat;
				Format:=Formatsettings.Shortdateformat;
				TabStop:=False;
				Onmouseenter:=STChange;
			end;
		end;
		for I:=1 to 2 do begin
			TM[I]:=Tdatetimepicker.Create(Self);
			with TM[I] do begin
				Parent:=PB[3];
				SetBounds(220,70+((I-1)*30),100,23);
				Kind:=Dtktime;
				BevelKind:=Bkflat;
				Format:='hh:mm:ss tt';
				TabStop:=False;
				Onmouseenter:=STChange;
			end;
		end;
		for I:=5 downto 1 do TB[I].Align:=Altop;
		/// /////////////////////               StatusBar                //////////////////////
		for I:=2 downto 1 do begin
			SB[I]:=TStatusBar.Create(Self);
			with SB[I] do begin
				Parent:=Pn2;
				Align:=Albottom;
				Autohint:=False;
				Height:=22;
				Ondrawpanel:=SBDPanel;
				with Panels.Add do Alignment:=TaCenter;
			end;
		end;
		SB[1].Autohint:=True;
		/// ///////////////////                 OTHER                   ///////////////////////
		TabStop:=False;
		CCNA.TabStop:=True;
		SNNA.TabStop:=True;
		COMME.TabStop:=True;
		CCNA.TabOrder:=0;
		SNNA.TabOrder:=1;
		COMME.TabOrder:=2;
		SJ.TabOrder:=3;
		if not(((FormOrPage='0')or(View IN [ViNone,ViOutF]))and(Crt1=nil)) then begin
			ATab:=Addtab(Crt1,Captn,Self,Na(Sff1('INX','DOCM','id',RFC)));
			if Crt1.Options.Behaviour.Activatenewtab then Visible:=True
			else SendToBack;
		end;
		Visible:=True;
		if (RFC<>'')and(ST0<>'')and(INV>0) then begin
			if (View=ViEdited) then LoadSG(INV,EditEdIndex)
			ELSE if (View=ViOutF) then SGOutLoad(conn,FD,OutFileName)
			else SGLoad(INV);
		end
		else SGNew;
		AMDF.Caption:=Def(D1,TNow)+' MILLISECONDS ';
		if (View IN [ViNone,ViOutF]) then begin
			if (ATab<>nil) then begin
				if (Crt1.Activetab=ATab) then AMDF.ChromeTabClick(Crt1,ATab);
			end else if IsTorm then STNF.Show;
		end else if (View=ViCheck) then begin
			STNF.ShowModal;
			Free;
		end else if (FormOrPage='999') then begin
			STNF.Show;
		end else begin
			STNF.ActiveControl:=SJ;
			STNF.ShowModal;
			Free;
		end;
	except
		on E:Exception do ShowMessage('TSGA CREAT'+#13+E.ToString);
	end;
end;

destructor TSGA.Destroy;
begin
	if IsTbl then DPTmpDROP(TBL,ERR);
	IF connC<>NIL THEN connC.Free;
	IF FDD<>NIL THEN FDD.Free;
	DeleteFile(OutFileName);
	if Assigned(SJ) then
		if (AMDT.Targets.Indexof(SJ)>-1) then AMDT.UnRegister(SJ);
	inherited Destroy;
end;

procedure TSGA.SGControls;
var
	B:Tbitmap;
	I,D,T,Scb,Cn0,Mx,Ki,Kn:Integer;
	CUL,Cmh,Ccl,Ref,Kl:string;
	CB1:TComboBoxEx;
	DT1:Tdatetimepicker;
begin
	try
		with SJ do begin
			EnableAllOn:=False;
			for I:=FixedCols to Colcount-1 do
				if (Cols[I].Outr.Cinfo.CCB=1) then begin
					Cn0:=Cols[I].Outr.Cinfo.CN;
					Cmh:=Cols[I].Outr.Cinfo.Cmh;
					Ccl:=Cols[I].Outr.Cinfo.Ccl;
					Ref:=Cols[I].Outr.Cinfo.Ref;
					Kl:=Cols[I].Outr.Cinfo.Kl;
					Ki:=Cols[I].Outr.Cinfo.Ki;
					Kn:=Cols[I].Outr.Cinfo.Kn;
					Scb:=Cols[I].Outr.Cinfo.Scb;
					CUL:=Cols[I].Outr.Cinfo.CUL;
					if (Ref<>'') then Ref:=' WHERE REF IN ('+Ref+')'
					else Ref:=' WHERE 1=1';
					if (Kl<>'') then Kl:=' AND KL IN ('+Kl+')'
					else Kl:=' AND 1=1';
					if (Ccl='LAN') then Ccl:=Lan;
					if not(Kn=7) then begin
						CB1:=TComboBoxEx.Create(Self);
						with CB1 do begin
							Parent:=Self;
							Tag:=Cn0;
							Text:='';
							name:=CUL;
							Style:=TComboBoxExStyle(Scb);
							ItemIndex:=-1;
							OnKeyPress:=CBKeyPress;
							TabStop:=False;
							BidiMode:=BdLeftToRight;
							Onexit:=CBExit;
							Images:=AMDF.AMD;
							Visible:=False;
							OnKeyDown:=AMDF.Cokeydown;
							if (Cmh<>'')and(Ccl<>'') then begin
								if not(Kn=4) then begin
									if (Kn=1) then OnSelect:=CBSelect;
									FQ[2].Open('SELECT DISTINCT '+Ccl+',INX FROM '+Cmh+Ref+Kl);
									if (FQ[2].RowsAffected>0) then
										for T:=0 to FQ[2].RowsAffected-1 do begin
											D:=FQ[2].Fields[1].AsInteger;
											Itemsex.Additem(FQ[2].Fields[0].AsString,D,D,-1,-1,nil);
											FQ[2].Next;
										end;
								end;
								if (Kn=4) then begin
									D:=Strtointdef(SFR1(36),16);
									FQ[2].Open('SELECT '+Ccl+',RGB FROM '+Cmh);
									IL[I]:=Timagelist.Create(Self);
									IL[I].Colordepth:=Cd32bit;
									IL[I].Setsize(D,D);
									Images:=IL[I];
									if (FQ[2].RowsAffected>0) then
										for T:=0 to FQ[2].RowsAffected-1 do begin
											D:=T;
											if (FQ[2].Fields[1].AsString='-1') then D:=-1;
											B:=Tbitmap.Create;
											with B do begin
												Pixelformat:=Pf32bit;
												Canvas.Brush.Color:=Getcolor(FQ[2].Fields[1].AsString);
												Setsize(IL[I].Width,IL[I].Height);
												Canvas.Fillrect(Rect(0,0,Width,Height));
											end;
											IL[I].Add(B,nil);
											B.Free;
											Itemsex.Additem(FQ[2].Fields[0].AsString,D,D,-1,-1,nil);
											FQ[2].Next;
										end;
								end;
							end;
							SendMessage(Handle,Cb_setdroppedwidth,Na(SFR1(29)),0);
						end;
						Cols[I].Outr.Fobj:=CB1;
					end;
					if (Cmh<>'')and(Kn=7) then begin
						DT1:=Tdatetimepicker.Create(Self);
						with DT1 do begin
							Parent:=Self;
							Tag:=Cn0;
							name:=CUL;
							Kind:=Tdatetimekind(Scb);
							Format:=Formatsettings.Shortdateformat;
							TabStop:=False;
							OnKeyPress:=CBKeyPress;
							Onexit:=CBExit;
							Visible:=False;
						end;
						Cols[I].Outr.Fobj:=DT1;
					end;
					FQ[9].Next;
				end;
			FQ[9].Open('SELECT CUL FROM '+Dtd1(TRFC)+' WHERE CCB="1" AND ACT="1" AND CMH IN '+'(SELECT TRM FROM '+Dtd1(TRFC)+
				' WHERE TRM <> "") AND IX>0');
			Mx:=FQ[9].RowsAffected;
			if (Mx>0) then begin
				for I:=1 to Mx do begin
					CUL:=FQ[9].Fields[0].AsString;
					for T:=FixedCols to Colcount-1 do
						if (CUL=Cols[T].Outr.Cinfo.CUL) then
							if (Cols[T].Outr.Fobj IS TComboBoxEx) then TComboBoxEx(Cols[T].Outr.Fobj).OnSelect:=CBSelect;
					FQ[9].Next;
				end;
			end;
			EnableAllOn:=True;
		end;
	except
		on E:Exception do ShowMessage('SGControls'+#13+FQ[2].SQL.Text+#13+E.ToString);
	end;
end;

procedure TSGA.SGColFill(I:Integer;CUL:string);
begin
	try
		with SJ do begin
			FQ[9].Open('SELECT CW,'+Lan+',NU,CMH,CCL,REF,TY,TRM,TRMC,KI,KN,WCH,CN,CCB,SCB,KA,EQ,KL,AUT,DFT,VIS,ENB FROM '+
				Dtd1(TRFC)+' WHERE CUL="'+CUL+'" LIMIT 1');
			if (FQ[9].RowsAffected=1) then begin
				Cols[I].Outr.Cinfo.CUL:=CUL;
				ColWidths[I]:=FQ[9].Fields[0].Aslargeint;
				Cols[I].Outr.Cinfo.VIS:=Boolean(FQ[9].Fields[20].AsInteger);
				if not Cols[I].Outr.Cinfo.VIS then ColWidths[I]:=0;
				Cols[I].Outr.Cinfo.Cw:=FQ[9].Fields[0].Aslargeint;
				Cols[I].Outr.Cinfo.Lg:=FQ[9].Fields[1].AsString;
				Cols[I].Outr.Cinfo.Nu:=Boolean(FQ[9].Fields[2].AsInteger);
				Cols[I].Outr.Cinfo.Cmh:=FQ[9].Fields[3].AsString;
				Cols[I].Outr.Cinfo.Ccl:=FQ[9].Fields[4].AsString;
				Cols[I].Outr.Cinfo.Ref:=FQ[9].Fields[5].AsString;
				Cols[I].Outr.Cinfo.TY:=FQ[9].Fields[6].AsString;
				Cols[I].Outr.Cinfo.TRM:=FQ[9].Fields[7].AsString;
				Cols[I].Outr.Cinfo.Trmc:=FQ[9].Fields[8].AsString;
				Cols[I].Outr.Cinfo.Ki:=FQ[9].Fields[9].AsInteger;
				Cols[I].Outr.Cinfo.Kn:=FQ[9].Fields[10].AsInteger;
				Cols[I].Outr.Cinfo.WCH:=Boolean(FQ[9].Fields[11].AsInteger);
				Cols[I].Outr.Cinfo.CN:=FQ[9].Fields[12].AsInteger;
				Cols[I].Outr.Cinfo.CCB:=FQ[9].Fields[13].AsInteger;
				Cols[I].Outr.Cinfo.Scb:=FQ[9].Fields[14].AsInteger;
				Cols[I].Outr.Cinfo.KA:=FQ[9].Fields[15].AsInteger;
				Cols[I].Outr.Cinfo.EQ:=FQ[9].Fields[16].AsString;
				Cols[I].Outr.Cinfo.Kl:=FQ[9].Fields[17].AsString;
				Cols[I].Outr.Cinfo.AUT:=Boolean(FQ[9].Fields[18].AsInteger);
				Cols[I].Outr.Cinfo.DFT:=FQ[9].Fields[19].AsString;
				Cols[I].Outr.Cinfo.ENB:=Boolean(FQ[9].Fields[21].AsInteger);
				if (CUL='CODE') then ITCLL:=I;
				if (CUL='PR') then PRCLL:=I;
				if (CUL='QTY') then QYCLL:=I;
				if (CUL='NCCE') then CECLL:=I;
				if (CUL='IFRM') then FRMCLL:=I;
				if (CUL='VT') then VTCLL:=I;
				if (CUL='DS') then DSCLL:=I;
				if (CUL='AD') then ADCLL:=I;
				if (CUL='NIT3VAT') then VCLL:=I;
				if (CUL='NIT3DIS') then DCLL:=I;
				if (CUL='NIT3ADS') then ACLL:=I;
				if (CUL='NSN') then SNCLL:=I;
				if (CUL='COMN') then CMCLL:=I;
			end
			else ShowMessage('CUL NOT EXIST'+#13+CUL);
		end;
	except
		on E:Exception do ShowMessage('SGColFill'+#13+I.ToString+#13+E.Message);
	end;
end;

procedure TSGA.SGColsRE(ConnectionN:TFDConnection;Query:TFDQuery;INV:string);
var
	I,D,Mx:Integer;
	SS:TStringList;
begin
	ITCLL:=0;
	PRCLL:=0;
	QYCLL:=0;
	TOCLL:=0;
	CECLL:=0;
	FRMCLL:=0;
	VTCLL:=0;
	DSCLL:=0;
	ADCLL:=0;
	VCLL:=0;
	DCLL:=0;
	ACLL:=0;
	SNCLL:=0;
	CMCLL:=0;
	try
		SS:=TStringList.Create;
		ConnectionN.ExecSQL('DROP TABLE IF EXISTS AAA;CREATE TEMPORARY TABLE '+'AAA AS SELECT NAME FROM PRAGMA_TABLE_INFO("'
			+INV+'")');
		Query.Open('SELECT name FROM AAA WHERE ROWID > 1;');
		Mx:=Query.RowsAffected;
		if (Mx>0) then
			with SJ do begin
				for I:=1 to Mx do begin
					SS.Add(Query.Fields[0].AsString);
					Query.Next;
				end;
				FQ[9].Open('SELECT CUL,IX FROM '+Dtd1(TRFC)+' WHERE ACT="1" AND(CUL="TOTAL" OR KN="1") ORDER BY IX ASC');
				Mx:=FQ[9].RowsAffected;
				if (Mx>0) then
					for I:=1 to Mx do begin
						SS.Add(FQ[9].Fields[0].AsString);
						if (FQ[9].Fields[1].AsInteger<SS.Count-1) then SS.Move(SS.Count-1,FQ[9].Fields[1].AsInteger-1);
						FQ[9].Next;
					end;
				Colcount:=0;
				Colcount:=1+SS.Count;
				FixedCols:=1;
				if EnableCheckBoxes then begin
					Colcount:=SS.Count+2;
					FixedCols:=2;
					ColWidths[0]:=20;
					Cols[0].Outr.Cinfo.Lg:='0';
					Cols[0].Outr.Cinfo.CUL:='CHK';
					Cols[0].Outr.Cinfo.Kn:=0;
				end;
				Cols[FixedCols-1].Outr.Cinfo.Lg:=SFL1(25);
				Cols[FixedCols-1].Outr.Cinfo.CUL:='ID';
				Cols[FixedCols-1].Outr.Cinfo.Kn:=0;
				Culs:='';
				for D:=0 to SS.Count-1 do begin
					I:=D+FixedCols;
					SGColFill(I,SS[D]);
					Culs:=Culs+','+SS[D];
				end;
				// ConnectionN.ExecSQL('DROP TABLE IF EXISTS '+ATT+'AAA');
				Delete(Culs,1,1);
				SS.Free;
			end;
		if (SView=ViNone) then SGControls;
	except
		on E:Exception do ShowMessage('SGColsRE'+#13+E.Message);
	end;
end;

procedure TSGA.SGColMov(Sender:TObject;FromIndex,ToIndex:Integer);
var
	I:Integer;
	TMP:string;
begin
	CN[9].ExecSQL('UPDATE '+Dtd1(TRFC)+' SET IX = "0"');
	for I:=SJ.FixedCols to SJ.Colcount-1 do begin
		TMP:=TMP+'UPDATE '+Dtd1(TRFC)+' SET IX = "'+I.ToString+'" WHERE CN = "'+SJ.Cols[I].Outr.Cinfo.CN.ToString+'";';
	end;
	CN[9].ExecSQL(TMP);
end;

procedure TSGA.SGKD(Sender:TObject;Key:Word;Shift:TShiftState);
var
	Sn,Rfc1,Rfc2,Nm1,Ic0,Ic1,Ic2,Ic3,It,Cc1,MH:string;
	Cl,Ro,X1:Integer;
	Q,Q1,Q2,Q3:Extended;
	R:TRect;
begin
	if (Ord(Key)=Vk_f5)or(Ord(Key)=Vk_f6)or(Ord(Key)=Vk_f7)or(Ord(Key)=Vk_f8) then begin
		Ro:=SJ.Row;
		if (Ord(Key)=Vk_f5) then begin
			if (SJ.Col=PRCLL)and(Goediting in SJ.Options) then begin
				TSTG.Create(Self);
			end;
		end;
		if (Ord(Key)=Vk_f6) then begin
			X1:=ITCLL;
			It:=SJ.Cells[X1,Ro];
			if (Sfit0(It)>0)and(Goediting in SJ.Options)and(SJ.Col=QYCLL) then begin
				Cl:=SNCLL;
				if (Cl=0) then begin
					if (SNNA.ItemIndex=-1) then begin
						SNNA.Sbo(Tti_error_large,SFL1(87),SFL1(39),SNNA.ClientRect,2);
						SNNA.Setfocus;
						Exit;
					end else begin
						Sn:=Sfsn2(SNNA.Items[SNNA.ItemIndex]);
					end;
				end else begin
					Sn:=Sfsn2(SJ.Cells[Cl,Ro]);
					if (Sn='') then begin
						Nm1:=SJ.Cells[Cl,0]+' '+SFL1(113)+' : "'+SJ.Cells[Cl,Ro]+'"';
						SJ.Col:=Cl;
						SJ.Row:=Ro;
						SJ.Sbo(Tti_error_large,SJ.Cells[Cl,0],Nm1,SJ.Cellrect(Cl,Ro),2);
						Exit;
					end;
				end;
				FQ[8].Open('SELECT SUM(QTY) FROM SN'+Sn+' WHERE CODE = "'+It+
					'" AND (RIF = "2" OR RIF = "3" OR RIF = "6" OR RIF = "0")');
				Q:=Ne(FQ[8].Fields[0].AsString);
				FQ[8].Open('SELECT SUM(QTY) FROM SN'+Sn+' WHERE CODE = "'+It+'" AND (RIF = "1" OR RIF = "4" OR RIF = "5")');
				Q1:=Ne(FQ[8].Fields[0].AsString);
				Q3:=Q-Q1;
				if not IsTew and Charinset(TRFC[1],['1','4','5']) then begin
					FQ[8].Open('SELECT SUM(QTY) FROM SN'+Sn+' WHERE CODE = "'+It+'" AND RIF = "'+TRFC+'" AND ICODE = "'+
						INUM.Caption+'"');
					Q2:=Ne(FQ[8].Fields[0].AsString);
					Q3:=Q3+Q2;
					Nm1:=#13+SFL1(125)+Ic3+' ='+#13+SFL1(126)+' ('+Q2.ToString+') +'+#13+SFL1(127)+' ('+(Q3-Q2).ToString+')';
				end;
				Msg1(Self,SJ.Cells[QYCLL,0],Sff1(Lan,'NIT','CODE',SJ.Cells[ITCLL,Ro]),SFL1(97)+' " '+SNNA.Items[SNNA.ItemIndex]+
					' " = " '+Q3.ToString+' "'+Nm1,10,SFL1(3),1,'',Bu);
			end;
		end;
		if (Ord(Key)=Vk_f7) then begin
			It:=SJ.Cells[ITCLL,Ro];
			X1:=QYCLL;
			if (Sfit0(It)>0)and(Goediting in SJ.Options)and(SJ.Col=X1)and Charinset(TRFC[1],['3','4']) then begin
				if (INUM.Caption='') then begin
					INUM.Sbo(Tti_error_large,SFL1(87),SFL1(37),INUM.ClientRect,2);
					Exit;
				end;
				if (CCID.ItemIndex=-1) then begin
					CCNA.Sbo(Tti_error_large,SFL1(87),SFL1(38),CCNA.ClientRect,2);
					CCNA.Setfocus;
					Exit;
				end else begin
					Cc1:=CCID.Items[CCID.ItemIndex];
				end;
				MH:='T'+It; // SFIT(IT);
				case Na(TRFC) of
					1,3,5:begin
							Rfc1:='1';
							Rfc2:='3';
						end;
					2,4,6:begin
							Rfc1:='2';
							Rfc2:='4';
						end;
				end;
				Cl:=FRMCLL;
				if (Cl=0) then begin
					R:=FRID.ClientRect;
					if (FRID.ItemIndex>-1) then begin
						Ic2:=FRID.Items[FRID.ItemIndex];
					end;
				end else begin
					R:=SJ.Cellrect(Cl,Ro);
					Ic2:=SJ.Cells[Cl,Ro];
				end;
				if (Ic2<>'') then begin
					FQ[8].Open('SELECT id FROM '+MH+' WHERE ST = "'+TST+'" AND IFRM = "'+Ic2+'" AND RIF = "'+Rfc1+
						'" AND FRM = "'+Cc1+'"');
					if (FQ[8].Fields[0].AsInteger=0) then begin
						if (Cl>0) then begin
							SJ.Col:=Cl;
							SJ.Row:=Ro;
						end else begin
							FRID.Setfocus;
						end;
						SJ.Sbo(Tti_error_large,SFL1(90),SFL1(108),R,2);
						Exit;
					end;
					Ic0:=' AND ICODE = "'+Ic2+'"';
					Ic1:=' AND IFRM = "'+Ic2+'" AND NOT ICODE = "'+INUM.Caption+'"';
					Ic3:=' '+SJ.Cells[Cl,0]+' "'+Ic2+'" ';
				end;
				FQ[8].Open('SELECT SUM(QTY) FROM '+MH+' WHERE ST = "'+TST+'" AND RIF = "'+Rfc1+'" AND FRM = "'+Cc1+'"'+Ic0);
				Q:=Ne(FQ[8].Fields[0].AsString);
				FQ[8].Open('SELECT SUM(QTY) FROM '+MH+' WHERE ST = "'+TST+'" AND RIF = "'+Rfc2+'" AND FRM = "'+Cc1+'"'+Ic1);
				Q1:=Ne(FQ[8].Fields[0].AsString);
				Q3:=Q-Q1;
				if not IsTew and(Ic2<>'') then begin
					FQ[8].Open('SELECT SUM(QTY) FROM '+MH+' WHERE ST = "'+TST+'" AND RIF = "'+Rfc2+'" AND FRM = "'+Cc1+'"'+
						' AND IFRM = "'+Ic2+'" AND ICODE = "'+INUM.Caption+'"');
					Q2:=Ne(FQ[8].Fields[0].AsString);
					Nm1:=#13+SFL1(125)+' ='+#13+SFL1(126)+' ('+Q2.ToString+') +'+#13+SFL1(128)+' ('+(Q3-Q2).ToString+')';
				end;
				Msg1(Self,SJ.Cells[X1,0],Sff1(Lan,'NIT','CODE',SJ.Cells[ITCLL,Ro]),SFL1(124)+' " '+CCNA.Items[CCNA.ItemIndex]+
					' "'+Ic3+' = " '+Q3.ToString+' "'+Nm1,10,SFL1(3),1,'',Bu);
			end;
		end;
		if (Ord(Key)=Vk_f8) then
			if (SJ.Col=FRMCLL)and(Goediting in SJ.Options) then TSTN.Create(Self);
	end;
end;

procedure TSGA.SGKeyDown(Sender:TObject;var Key:Word;Shift:TShiftState);
begin
	SGKD(Sender,Key,Shift);
end;

procedure TSGA.SGKeyPress(Sender:TObject;var Key:Char);
var
	TL,QT,P1,K1,TX,DS,AD,TS1,A5:Extended;
	AR,D,I,T,IX,Kn,Mx,IC,CCB,CN1,TS,Ki,QID,PID,SID,CID:Integer;
	K2,NM,Nm1,Cmh,Ccl,Ref,REF1,REF2,ID1,COD,S,TM1,Cl,IDC,IDT:string;
	SNF,Sn,FRM,FRMM,TRM,RFC,Wrg,It,FR,PR,QY,ID,INV,IFR,V1,V2,Wr,CODE,PSC,PSX,PCQ,PYID,TQS:string;
	PR0,SN0,SNQ,CCE0,CCE1:string;
	DIT,DIT1,D1,D2:Uint64;
	WCH:Boolean;
	R:TRect;
	WN:TWinControl;
begin
	SBO1;
	AR:=SJ.Row;
	if (Ord(Key)=Vk_tab)and(Goediting in SJ.Options) then begin
		CODE:=SJ.Cells[ITCLL,AR];
		ID:=(AR-SJ.FixedRows+1).ToString;
		Wr:=SFL1(90)+' :   " %s "';
		if (CODE='') then begin
			for I:=SJ.FixedCols to SJ.Colcount-1 do SJ.Cells[I,AR]:='';
			Exit;
		end else if (CN[2].ExecSQLScalar('SELECT CASE WHEN (SELECT id FROM NIT WHERE CODE="'+CODE+'")>0 THEN 1 ELSE 0 END')
			=0) then begin
			SJ.Col:=ITCLL;
			SJ.Row:=AR;
			SJ.Sbo(Tti_error_large,SFL1(87),Format(Wr,[SJ.Cols[ITCLL].Outr.Cinfo.Lg+' = '+SJ.Cells[ITCLL,AR]]),
				SJ.Cellrect(ITCLL,AR),2);
			Exit;
		end;
		INV:=INUM.Caption;
		if (CCID.ItemIndex=-1)or(TCC='') then begin
			CCNA.Sbo(Tti_error_large,SFL1(87),Format(Wr,[SFL1(38)]),CCNA.ClientRect,2);
			CCNA.Setfocus;
			Exit;
		end
		else TCC:=CCID.Items[CCID.ItemIndex];
		if not ContainsStr(Culs,'NSN') then
			if (SNNA.ItemIndex=-1) then begin
				SNNA.Sbo(Tti_error_large,SFL1(87),Format(Wr,[SFL1(39)]),SNNA.ClientRect,2);
				SNNA.Setfocus;
				Exit;
			end else begin
				Sn:=Sfsn2(SNNA.Items[SNNA.ItemIndex]);
				SNF:=SNNA.Items[SNNA.ItemIndex];
			end;
		case TRFC.Tointeger of
			3:begin
					RFC:='1';
					V1:=' AND NOT ICODE="'+INV+'"';
					V2:='';
				end;
			4:begin
					RFC:='2';
					V1:='';
					V2:=' AND NOT ICODE="'+INV+'"';
				end;
		end;
		if Charinset(TRFC[1],['3','4']) then begin
			if not ContainsStr(Culs,'IFRM') then begin
				if (FRID.ItemIndex=-1) then begin
					FRID.Sbo(Tti_error_large,SFL1(87),Format(Wr,[SFL1(45)]),FRID.ClientRect,2);
					FRID.Setfocus;
					Exit;
				end
				else IFR:=FRID.Items[FRID.ItemIndex];
			end else begin
				IFR:=SJ.Cells[FRMCLL,AR];
				if (IFR<>'') then
					if (CN[5].ExecSQLScalar('SELECT COUNT(id) FROM C'+TCC+' WHERE ICODE="'+IFR+'" AND ST="'+TST+'" AND RIF="'+RFC+
						'"')=0) then begin
						SJ.Col:=FRMCLL;
						SJ.Row:=AR;
						SJ.Sbo(Tti_error_large,SFL1(87),Format(SFL1(108),[IFR,CCNA.Items[CCNA.ItemIndex]]),
							SJ.Cellrect(FRMCLL,AR),2);
						Exit;
					end;
			end;
			if (IFR<>'') then FRM:=' AND ICODE="'+IFR+'"'
			else FRM:='';
			FQ[2].Open('SELECT * FROM(SELECT COUNT(id) FROM T'+CODE+' WHERE FRM="'+TCC+'" AND ST="'+TST+'" AND RIF="'+RFC+'"'+
				FRM+'),(SELECT '+Lan+' FROM NIT WHERE CODE='+CODE+' LIMIT 1)');
			if (FQ[2].Fields[0].AsInteger=0) then begin
				SJ.Col:=ITCLL;
				SJ.Row:=AR;
				if (IFR<>'') then FRMM:=Format(SFL1(101),[FQ[2].Fields[1].AsString,IFR,CCNA.Items[CCNA.ItemIndex]])
				else FRMM:=Format(SFL1(154),[FQ[2].Fields[1].AsString,CCNA.Items[CCNA.ItemIndex]]);
				SJ.Sbo(Tti_error_large,SFL1(87),FRMM,SJ.Cellrect(ITCLL,AR),2);
				Exit;
			end;
		end;
		if (CCE.ItemIndex>-1) then CCE1:=CCE.Items[CCE.ItemIndex]
		else CCE1:='2';
		QY:=SJ.Cells[QYCLL,AR];
		QY:=StrToFloatDef(QY,0).ToString;
		SJ.Cells[QYCLL,AR]:=QY;
		/// /////////////////

		if Charinset(TRFC[1],['2','6']) then begin
			if (PRC=0) then PR0:=',CASE WHEN PR="" OR PR*1=0 THEN 0 WHEN PR<0 THEN -PR*1.0 ELSE PR*1.0 END AS PS';
			if (PRC=1) then PR0:=',(SELECT CO FROM NIT WHERE NIT.CODE = '+TBL+'.CODE) AS PS';
			if (PRC=2) then
					PR0:=',(SELECT PR FROM T'+CODE+' WHERE ST="'+TST+'" AND FRM = "'+TCC+
					'" AND RIF IN ("0","2") ORDER BY ICODE DESC LIMIT 1) AS PS';
			if ContainsStr(Culs,'NSN') then
					SN0:=',CASE WHEN NSN="" THEN 2 WHEN NSN<>"" AND(SELECT id FROM NSN WHERE '+Scl(SJ.Cols[SNCLL].Outr.Cinfo.Ccl)+
					'='+TBL+'.NSN LIMIT 1)>0 THEN 1 ELSE 0 END AS SNID'
			else SN0:=',"'+Sn+'" AS SNID';
			if ContainsStr(Culs,'NCCE') then
					CCE0:=',CASE WHEN NCCE="" THEN 2 WHEN NCCE<>"" AND(SELECT id FROM NCCE WHERE '+
					Scl(SJ.Cols[CECLL].Outr.Cinfo.Ccl)+'='+TBL+'.NCCE LIMIT 1)>0 THEN 1 ELSE 0 END AS CEID'
			else CCE0:=',"'+CCE1+'" AS CEID';
			FRM:='SELECT "0",PS,SNID,CEID,PS*QTY FROM (SELECT QTY'+PR0+SN0+CCE0+' FROM '+TBL+' WHERE ID="'+ID+'")';
			FQ[2].Open(FRM);
			if (FQ[2].RowsAffected>0) then begin
				if ContainsStr(Culs,'PR') then SJ.Cells[PRCLL,AR]:=FQ[2].Fields[1].AsString;
				if ContainsStr(Culs,'NSN') then
					if (FQ[2].Fields[2].AsInteger=0) then begin
						Cl:=SJ.Cols[SNCLL].Outr.Cinfo.Lg;
						Nm1:=Cl+' '+Format(SFL1(113),[' = '+SJ.Cells[SNCLL,AR]]);
						SJ.Col:=SNCLL;
						SJ.Row:=AR;
						SJ.Sbo(Tti_error_large,Cl,Nm1,SJ.Cellrect(SNCLL,AR),2);
						Exit;
					end;
				if ContainsStr(Culs,'NCCE') then
					if (FQ[2].Fields[3].AsInteger=0) then begin
						Cl:=SJ.Cols[CECLL].Outr.Cinfo.Lg;
						Nm1:=Cl+' '+Format(SFL1(113),[' = '+SJ.Cells[CECLL,AR]]);
						SJ.Col:=CECLL;
						SJ.Row:=AR;
						SJ.Sbo(Tti_error_large,Cl,Nm1,SJ.Cellrect(CECLL,AR),2);
						Exit;
					end;
				if ContainsStr(Culs,'TOTAL') then SJ.Cells[TOCLL,AR]:=FQ[2].Fields[4].AsString;
			end;
		end;
		if Charinset(TRFC[1],['1','5']) then begin
			if (PRC=0) then PR0:=',CASE WHEN PR="" OR PR*1=0 THEN 0 WHEN PR<0 THEN -PR*1.0 ELSE PR*1.0 END AS PS';
			if (PRC=1) then PR0:=',(SELECT PR FROM NIT WHERE NIT.CODE='+TBL+'.CODE) AS PS';
			if (PRC=2) then
					PR0:=',(SELECT PR FROM T'+CODE+' WHERE ST="'+TST+'" AND FRM = "'+TCC+
					'" AND RIF = "1" ORDER BY ICODE DESC LIMIT 1) AS PS';
			if (PRC=3) then PR0:=',(SELECT (CO+(CO*PC*0.01)) FROM NIT WHERE NIT.CODE = '+TBL+'.CODE) AS PS';
			if (PRC=4) then
					PR0:=',(SELECT PR FROM NITQY WHERE NITQY.CODE = '+TBL+'.CODE AND '+TBL+
					'.QTY BETWEEN QY1 AND QY2 ORDER BY id DESC) AS PS';
			if (PRC=5) then
					PR0:=',(SELECT PR FROM NITCU WHERE NITCU.CODE = '+TBL+'.CODE AND FRM = "'+TCC+'" ORDER BY id DESC) AS PS';
			if (PRC=6) then
					PR0:=',(SELECT PR FROM NITCUQY WHERE NITCUQY.CODE = '+TBL+'.CODE AND FRM = "'+TCC+'" AND '+TBL+
					'.QTY BETWEEN QY1 AND QY2 ORDER BY id DESC) AS PS';
			if ContainsStr(Culs,'NSN') then
					SN0:=',CASE WHEN NSN="" THEN -1 WHEN NSN<>"" AND(SELECT id FROM NSN WHERE '+Scl(SJ.Cols[SNCLL].Outr.Cinfo.Ccl)
					+'=NSN LIMIT 1)>0 THEN (SELECT id FROM NSN WHERE '+Scl(SJ.Cols[SNCLL].Outr.Cinfo.Ccl)+
					'=NSN LIMIT 1) ELSE 0 END AS SNID'
			else SN0:=',"'+Sn+'" AS SNID';
			SNQ:=',CASE WHEN SNID>0 THEN (SELECT SUM(QTY)FROM T'+CODE+' WHERE'+' SN=SNID AND RIF IN(0,2,3,6) AND ST="'+TST+
				'")-'+'(SELECT SUM(QTY)FROM T'+CODE+' WHERE SN=SNID AND RIF IN(1,4,5) AND ST="'+TST+'" AND NOT ICODE="'+INV+
				'") ELSE 0 END AS TSNQ';
			if ContainsStr(Culs,'NCCE') then
					CCE0:=',CASE WHEN NCCE="" THEN 2 WHEN NCCE<>"" AND(SELECT id FROM NCCE WHERE '+
					Scl(SJ.Cols[CECLL].Outr.Cinfo.Ccl)+'=NCCE LIMIT 1)>0 THEN 1 ELSE 0 END AS CEID'
			else CCE0:=',"'+CCE1+'" AS CEID';
			FRM:='SELECT "0",LN,PC,QYID,QTY1,TQY,TOQY,SNID,TSNQ,CEID,QTY1*PC,TSNQ-QTY1 FROM (SELECT (SELECT '+Lan+
				' FROM NIT WHERE CODE=CODE1 LIMIT 1) AS LN,CASE WHEN PS IS NULL THEN 0 ELSE PS END AS PC'+
				',CASE WHEN TQS="" THEN 2 WHEN TQS<>"" AND TQS-QTY1>=0 THEN 1 ELSE 0 END AS QYID,QTY1'+
				',CASE WHEN TQS IS NULL OR TQS="" THEN 0 ELSE TQS END AS TQY'+
				',CASE WHEN TQS IS NULL THEN 0-QTY1 ELSE TQS-QTY1 END AS TOQY,SNID'+SNQ+
				',CEID FROM (SELECT CODE AS CODE1,CASE WHEN QTY="" OR QTY*1=0 THEN 0 ELSE QTY END AS QTY1'+
				',CASE WHEN QTY<>"" AND QTY*1<>0 THEN(SELECT SUM(QTY)FROM T'+CODE+' WHERE ST="'+TST+
				'" AND RIF IN(0,2,3,6))-(SELECT SUM(QTY)FROM T'+CODE+' WHERE RIF IN(1,4,5) AND ST="'+TST+'" AND NOT ICODE="'+INV
				+'")ELSE "" END AS TQS'+SN0+PR0+CCE0+' FROM '+TBL+' WHERE ID="'+ID+'"))';
			FQ[2].Open(FRM);
			if (FQ[2].RowsAffected>0) then begin
				if ContainsStr(Culs,'PR') then SJ.Cells[PRCLL,AR]:=FQ[2].Fields[2].AsString;
				if ContainsStr(Culs,'QTY')and(SFR1(12)='1') then
					case FQ[2].Fields[3].AsInteger of
						0:begin
								R:=SJ.Cellrect(QYCLL,AR);
								if (R.Isempty)or(R.Width<SJ.Cols[QYCLL].Outr.Cinfo.Cw) then begin
									SJ.Col:=QYCLL;
									SJ.Row:=AR;
								end;
								SJ.Sbo(Tti_warning_large,Format(SFL1(98),[FQ[2].Fields[1].AsString]),
									Format(SFL1(141),[FQ[2].Fields[4].AsString])+#13+Format(SFL1(144),[FQ[2].Fields[5].AsString])+#13+
									Format(SFL1(145),[FQ[2].Fields[6].AsString]),SJ.Cellrect(QYCLL,AR),3);
							end;
						2:SJ.Cells[QYCLL,AR]:='0';
					end;
				case FQ[2].Fields[7].AsInteger of
					0:begin
							if ContainsStr(Culs,'NSN') then begin
								Cl:=SJ.Cols[SNCLL].Outr.Cinfo.Lg;
								Nm1:=Cl+' '+Format(SFL1(113),[' = '+SJ.Cells[SNCLL,AR]]);
								SJ.Col:=SNCLL;
								SJ.Row:=AR;
								SJ.Sbo(Tti_error_large,Cl,Nm1,SJ.Cellrect(SNCLL,AR),2);
							end else begin
								Cl:=SNF;
								Nm1:=Cl+' '+Format(SFL1(113),[' = '+SFL1(39)]);
								SNNA.Setfocus;
								SJ.Sbo(Tti_error_large,Cl,Nm1,SNNA.ClientRect,2);
							end;
							Exit;
						end;
					1..Maxint: if (FQ[2].Fields[9].AsExtended<0) then begin
							if ContainsStr(Culs,'NSN') then begin
								Cl:=SJ.Cells[SNCLL,AR];
								R:=SJ.Cellrect(SNCLL,AR);
								if (R.Isempty)or(R.Width<SJ.Cols[SNCLL].Outr.Cinfo.Cw) then begin
									SJ.Col:=SNCLL;
									SJ.Row:=AR;
								end;
								WN:=SJ;
							end else begin
								Cl:=SNF;
								WN:=SNNA;
								R:=SNNA.ClientRect;
							end;
							WN.Sbo(Tti_warning_large,Format(SFL1(98),[FQ[2].Fields[1].AsString]),Format(SFL1(39)+' :   " %s "',[Cl])+
								#13+Format(SFL1(141),[FQ[2].Fields[4].AsString])+#13+Format(SFL1(97),[FQ[2].Fields[8].AsString])+#13+
								Format(SFL1(127),[FQ[2].Fields[9].AsString]),R,3);
							WN.Setfocus;
						end;
				end;
				if (FQ[2].Fields[9].AsInteger=0) then begin
					Cl:=SJ.Cols[CECLL].Outr.Cinfo.Lg;
					Nm1:=Cl+' '+Format(SFL1(113),[' = '+SJ.Cells[CECLL,AR]]);
					SJ.Col:=CECLL;
					SJ.Row:=AR;
					SJ.Sbo(Tti_error_large,Cl,Nm1,SJ.Cellrect(CECLL,AR),2);
					Exit;
				end;
				if ContainsStr(Culs,'TOTAL') then SJ.Cells[TOCLL,AR]:=FQ[2].Fields[10].AsString;
			end;
		end;
		if Charinset(TRFC[1],['4','3']) then begin
			if (PRC=0) then begin
				PSC:=',0 AS PSC';
				PSX:=',1 AS PSX';
				PCQ:=',QTY1 AS PCQ';
				PYID:=',1 AS PYID';
			end;
			if (PRC=1) then begin
				PSC:=',CASE WHEN (SELECT count(DISTINCT PR) FROM T'+CODE+' WHERE ICODE="'+IFR+'" AND ST="'+TST+'" AND RIF="'+RFC
					+'")=1 THEN 1 ELSE 0 END AS PSC';
				PSX:=',CASE WHEN (SELECT COUNT(id) FROM T'+CODE+' WHERE ICODE="'+IFR+'" AND ST="'+TST+'" AND RIF="'+RFC+
					'" AND abs(PR)=abs('+TBL+'.PR))>0 THEN 1 ELSE 0 END AS PSX';
				PCQ:=',CASE WHEN(PS>0 AND QTY1>0 AND QYID=1)THEN coalesce((SELECT sum(QTY) FROM T'+CODE+' WHERE ICODE="'+IFR+
					'" AND RIF="'+RFC+'" AND ST="'+TST+'" AND abs(PR)=abs(PS)),0) ELSE 0 END AS PCQ';
				PYID:=',CASE WHEN(PC="" OR QTY1=0)THEN 2 WHEN(PC>0 AND (PSX=1 OR PSC=1))THEN 1 ELSE 0 END AS PYID';
			end;
			if (SFR1(10)='1') then begin
				TQS:=',CASE WHEN abs(QTY)>0 THEN(coalesce((SELECT SUM(QTY)FROM T'+CODE+' WHERE ST="'+TST+
					'" AND RIF IN(0,2,3,6) AND IFRM="'+IFR+'"'+V1+'),0)-coalesce((SELECT SUM(QTY)FROM T'+CODE+
					' WHERE RIF IN(1,4,5) AND ST="'+TST+'" AND IFRM="'+IFR+'"'+V2+'),0))ELSE "" END AS TQS';
			end else begin
				PCQ:=',QTY1 AS PCQ';
				TQS:=',QTY1 AS TQS';
			end;
			if ContainsStr(Culs,'NSN') then
					SN0:=',CASE WHEN NSN="" THEN -1 WHEN NSN<>"" AND(SELECT id FROM NSN WHERE '+Scl(SJ.Cols[SNCLL].Outr.Cinfo.Ccl)
					+'=NSN LIMIT 1)>0 THEN (SELECT id FROM NSN WHERE '+Scl(SJ.Cols[SNCLL].Outr.Cinfo.Ccl)+
					'=NSN LIMIT 1) ELSE 0 END AS SNI'
			else SN0:=','+Sn+' AS SNI';
			SNQ:=',QTY1 AS SNQ';
			if Charinset(TRFC[1],['4'])and(SFR1(11)='1') then
					SNQ:=',CASE WHEN (SNI>0 AND QTY1>0 AND QYID=1) THEN (coalesce((SELECT SUM(QTY)FROM T'+CODE+
					' WHERE SN=SNI AND RIF IN(0,2,3,6)),0)-coalesce((SELECT SUM(QTY)FROM T'+CODE+
					' WHERE SN=SNI AND RIF IN(1,4,5) AND NOT ICODE="'+INV+'"),0)) ELSE 0 END AS SNQ';
			if ContainsStr(Culs,'NCCE') then
					CCE0:=',CASE WHEN NCCE="" THEN 2 WHEN NCCE<>"" AND(SELECT id FROM NCCE WHERE '+
					Scl(SJ.Cols[CECLL].Outr.Cinfo.Ccl)+'=NCCE LIMIT 1)>0 THEN 1 ELSE 0 END AS CEID'
			else CCE0:=',1 AS CEID';
			if (IFR<>'') then
					FRM:='SELECT LN,CEID,QYID,QTY1,TQS'+PYID+
					',PC,PCQ,PCQ-QTY1,SNID,SNQ,SNQ-QTY1,QTY1*PC AS TOT,TQS-QTY1 FROM(SELECT PSX,PSC,SNID,QTY1,TQS,SNI,CEID,QYID'+
					',CASE WHEN QYID<>2 THEN(SELECT '+Lan+' FROM NIT WHERE CODE=CODE1)ELSE "" END AS LN'+
					',CASE WHEN PS=0 THEN "" ELSE PS END AS PC'+PCQ+SNQ+
					' FROM(SELECT CODE1,QTY1,PSX,PSC,SNI,CEID,TQS,CASE WHEN TQS="" THEN 2 WHEN(TQS<>"" AND TQS-QTY1>=0)'+
					'THEN 1 ELSE 0 END AS QYID,CASE WHEN SNI=-1 THEN 2 WHEN SNI=0 THEN 0 ELSE 1 END AS SNID'+
					',CASE WHEN PSX=1 THEN PS1 WHEN PSX=0 AND PSC=1 THEN (SELECT DISTINCT PR FROM T'+CODE+' WHERE ICODE="'+IFR+
					'" AND ST="'+TST+'" AND RIF="'+RFC+'")WHEN(PSX=0 AND PSC=0)THEN PS1 ELSE 0 END AS PS'+
					' FROM(SELECT CODE AS CODE1,QTY,abs(QTY) AS QTY1,abs(PR) AS PS1'+TQS+PSC+PSX+SN0+CCE0+' FROM '+TBL+
					' WHERE ID='+ID+')))'
			else FRM:='SELECT LN,CEID,QYID,QTY1,TQS'+
					',CASE WHEN(PC = "" OR QTY1=0)THEN 2 WHEN(PC>0 AND(PSX=1 OR PSC=1))THEN 1 ELSE 0 END AS PYID'+
					',PC,PCQ,PCQ-QTY1,SNID,SNQ,SNQ-QTY1,QTY1*PC AS TOT,TQS-QTY1 FROM(SELECT PSX,PSC,SNID,QTY1,TQS,SNI,CEID'+
					',QYID,CASE WHEN QYID<>2 THEN(SELECT Arabic FROM NIT WHERE CODE=CODE1)ELSE "" END AS LN,CEID,TQS'+
					',CASE WHEN PS=0 THEN "" ELSE PS END AS PC,QTY1 AS PCQ,QTY1 AS SNQ FROM(SELECT CODE1,QTY1,PSX,TQS,CEID'+
					',PSC,SNI,CASE WHEN TQS="" THEN 2 WHEN TQS<>"" AND TQS-QTY1>=0 THEN 1 ELSE 0 END AS QYID,CASE WHEN '+
					'SNI=-1 THEN 2 WHEN SNI=0 THEN 0 ELSE 1 END AS SNID,PS1 AS PS FROM(SELECT CODE AS CODE1,QTY,abs(QTY)'+
					' AS QTY1,abs(PR) AS PS1,abs(QTY) AS TQS,0 AS PSC,1 AS PSX'+SN0+CCE0+' FROM '+TBL+' WHERE ID=1)))';
			FQ[2].Open(FRM);
			if (FQ[2].RowsAffected>0) then begin
				CID:=FQ[2].Fields[1].AsInteger;
				QID:=FQ[2].Fields[2].AsInteger;
				PID:=FQ[2].Fields[5].AsInteger;
				SID:=FQ[2].Fields[9].AsInteger;
				if ContainsStr(Culs,'NCCE') then begin
					case CID of
						0:begin
								SJ.Col:=CECLL;
								SJ.Row:=AR;
								Cl:=SJ.Cols[CECLL].Outr.Cinfo.Lg;
								Nm1:=Cl+' '+Format(SFL1(113),[' = '+SJ.Cells[CECLL,AR]]);
								SJ.Sbo(Tti_error_large,Cl,Nm1,SJ.Cellrect(CECLL,AR),2);
								Exit;
							end;
					end;
				end;
				if ContainsStr(Culs,'PR') then begin
					SJ.Cells[PRCLL,AR]:=FQ[2].Fields[6].AsString;
					case PID of
						0:begin
								SJ.Col:=PRCLL;
								SJ.Row:=AR;
								SJ.Sbo(Tti_error_large,SFL1(87),Format(SFL1(109),[FQ[2].Fields[6].AsString,IFR]),
									SJ.Cellrect(PRCLL,AR),2);
								Exit;
							end;
						1: if (FQ[2].Fields[8].AsExtended<0)and(QID=1) then begin
								if (SFR1(13)='1') then begin
									R:=SJ.Cellrect(QYCLL,AR);
									if (R.Isempty)or(R.Width<SJ.Cols[QYCLL].Outr.Cinfo.Cw) then begin
										SJ.Col:=QYCLL;
										SJ.Row:=AR;
									end;
									SJ.Sbo(Tti_warning_large,Format(SFL1(98),[FQ[2].Fields[0].AsString]),
										Format(SFL1(147),[FQ[2].Fields[0].AsString,IFR,FQ[2].Fields[6].AsString])+#13+Format(SFL1(148),
										[FQ[2].Fields[7].AsString])+#13+Format(SFL1(142),[FQ[2].Fields[3].AsString])+#13+Format(SFL1(155),
										[FQ[2].Fields[8].AsString]),SJ.Cellrect(QYCLL,AR),3);
									Exit;
								end;
							end;
					end;
				end;
				if ContainsStr(Culs,'QTY') then
					case QID of
						0: if (SFR1(13)='1') then begin
								R:=SJ.Cellrect(QYCLL,AR);
								if (R.Isempty)or(R.Width<SJ.Cols[QYCLL].Outr.Cinfo.Cw) then begin
									SJ.Col:=QYCLL;
									SJ.Row:=AR;
								end;
								SJ.Sbo(Tti_warning_large,Format(SFL1(98),[FQ[2].Fields[0].AsString]),
									Format(SFL1(99),[FQ[2].Fields[0].AsString,IFR])+#13+Format(SFL1(123),[IFR,FQ[2].Fields[4].AsString])+
									#13+Format(SFL1(142),[FQ[2].Fields[3].AsString])+#13+Format(SFL1(128),[FQ[2].Fields[13].AsString]),
									SJ.Cellrect(QYCLL,AR),3);
								Exit;
							end;
						2:SJ.Cells[QYCLL,AR]:='0';
					end;
				case SID of
					0:begin
							if ContainsStr(Culs,'NSN') then begin
								Cl:=SJ.Cols[SNCLL].Outr.Cinfo.Lg;
								Nm1:=Cl+' '+Format(SFL1(113),[' = '+SJ.Cells[SNCLL,AR]]);
								SJ.Col:=SNCLL;
								SJ.Row:=AR;
								SJ.Sbo(Tti_error_large,Cl,Nm1,SJ.Cellrect(SNCLL,AR),2);
								Exit
							end else begin
								Cl:=SNF;
								Nm1:=Cl+' '+Format(SFL1(113),[' = '+SFL1(39)]);
								SNNA.Setfocus;
								SJ.Sbo(Tti_error_large,Cl,Nm1,SNNA.ClientRect,2);
							end;
							Exit;
						end;
					1: if (FQ[2].Fields[11].AsExtended<0)and(QID=1) then begin
							if (SFR1(12)='1') then begin
								if ContainsStr(Culs,'NSN') then begin
									Cl:=SJ.Cells[SNCLL,AR];
									R:=SJ.Cellrect(SNCLL,AR);
									if (R.Isempty)or(R.Width<SJ.Cols[SNCLL].Outr.Cinfo.Cw) then begin
										SJ.Col:=SNCLL;
										SJ.Row:=AR;
									end;
									WN:=SJ;
								end else begin
									Cl:=SNF;
									WN:=SNNA;
									R:=SNNA.ClientRect;
								end;
								WN.Sbo(Tti_warning_large,Format(SFL1(98),[FQ[2].Fields[0].AsString]),
									Format(SFL1(39)+' :   " %s "',[Cl])+#13+Format(SFL1(142),[FQ[2].Fields[3].AsString])+#13+
									Format(SFL1(97),[FQ[2].Fields[10].AsString])+#13+Format(SFL1(127),[FQ[2].Fields[11].AsString]),R,3);
								WN.Setfocus;
								Exit;
							end;
						end;
				end;
				if ContainsStr(Culs,'TOTAL') then SJ.Cells[TOCLL,AR]:=FQ[2].Fields[12].AsString;
			end;
		end;
		if not(SJ.Cells[ITCLL,SJ.RowCount-1]='') then begin
			SJ.RowCount:=SJ.RowCount+1;
			SGTLC(SJ);
		end;
	end;
end;

procedure TSGA.SGSelectCell(Sender:TObject;ACol,ARow:Integer;var CanSelect:Boolean);
var
	R:TRect;
	V,I:Integer;
	Rfc1,It,IC,Cc1,CILL:string;
	OBG:TObject;
	Cx:TComboBoxEx;
	DX:Tdatetimepicker;
begin
	CILL:=SJ.Cells[ACol,ARow];
	SB[1].Panels[0].Text:=CILL;
	if not(Goediting in SJ.Options) then Exit;
	OBG:=SJ.Cols[ACol].Outr.Fobj;
	if (OBG<>nil) then begin
		if SJ.UseRightToLeftAlignment then V:=17
		else V:=0;
		if (OBG IS TComboBoxEx) then begin
			Cx:=TComboBoxEx(OBG);
			if (ACol>SJ.FixedCols-1) then begin
				if (CCID.ItemIndex=-1) then Exit
				else Cc1:=CCID.Items[CCID.ItemIndex];
				IC:=SJ.Cells[FRMCLL,ARow];
				It:=SJ.Cells[ITCLL,ARow];
				if (CN[2].ExecSQLScalar('SELECT id FROM NIT WHERE CODE="'+It+'"')>0) then begin
					case Na(TRFC) of
						1,3,5:Rfc1:='1';
						2,4,6:Rfc1:='2';
					end;
					if (SJ.Cols[ACol].Outr.Cinfo.CUL='IFRM')and Charinset(TRFC[1],['3','4']) then begin
						if (Cx.Items.Count=1) then SJ.Cells[FRMCLL,ARow]:=Trim(Cx.Items[0])
						else Cx.Items.Text:=FRID.Items.Text;
					end;
					if (SJ.Cols[ACol].Outr.Cinfo.CUL='PR') then
						try
							if (IC<>'')and Charinset(TRFC[1],['3','4']) then IC:=' AND ICODE = "'+IC+'"'
							else IC:='';
							FQ[8].Open('SELECT DISTINCT PR FROM T'+It+' WHERE RIF = "'+Rfc1+'" AND ST = "'+TST+'" AND FRM = "'+Cc1+'"'
								+IC+' ORDER BY DAT DESC');
							Cx.Clear;
							if (FQ[8].RowsAffected>0) then begin
								for I:=0 to FQ[8].RowsAffected-1 do begin
									Cx.Itemsex.Additem(FQ[8].Fields[0].AsString,-1,-1,-1,-1,nil);
									FQ[8].Next;
								end;
							end;
							if Charinset(TRFC[1],['3','4'])and(FQ[8].RowsAffected=0) then
									SJ.Cells[ACol,ARow]:=FQ[8].Fields[0].AsString;
						except
							on E:Exception do ShowMessage('SGSelectCell PR'+#13+E.ToString);
						end;
					if (SJ.Cols[ACol].Outr.Cinfo.CUL='COMN') then
						try
							FQ[8].Open('SELECT DISTINCT COMM FROM T'+It+' WHERE RIF = "'+TRFC+'"');
							Cx.Clear;
							if (FQ[8].RowsAffected>0) then
								for I:=0 to FQ[8].RowsAffected-1 do begin
									Cx.Itemsex.Additem(FQ[8].Fields[0].AsString,-1,-1,-1,-1,nil);
									FQ[8].Next;
								end;
						except
							on E:Exception do ShowMessage('SGSelectCell COMN'+#13+E.ToString);
						end;
				end;
				if (CILL='') then begin
					if (It<>'') then begin
						if (SJ.Cols[ACol].Outr.Cinfo.Kn=1) then Exit
					end else if not((SJ.Cols[ACol].Outr.Cinfo.Kn=1)or(ACol=ITCLL)) then Exit;
					R:=SJ.Cellrect(ACol,ARow);
					with Cx do begin
						if not Visible and not DRG then begin
							// R.TopLeft := ABox.Parent.ScreenToClient(AGrid.ClientToScreen(R.TopLeft));
							// R.BottomRight := ABox.Parent.ScreenToClient(AGrid.ClientToScreen(R.BottomRight));
							Left:=R.Left+SJ.Left+3+V;
							Width:=R.Width;
							Top:=R.Top+SJ.Top+3;
							Height:=R.Height;
							Text:='';
							ItemIndex:=-1;
							SendMessage(Handle,Cb_setdroppedwidth,Na(SFR1(29)),0);
							Visible:=True;
							Setfocus;
							Droppeddown:=True;
						end;
					end;
				end;
			end;
		end;
		if (OBG IS Tdatetimepicker) then begin
			DX:=Tdatetimepicker(OBG);
			if (ACol>0) then begin
				It:=SJ.Cells[ITCLL,ARow];
				if (CILL='')and(It<>'') then begin
					R:=SJ.Cellrect(ACol,ARow);
					with DX do begin
						if not Visible and not DRG then begin
							Left:=R.Left+SJ.Left+3+V;
							Width:=R.Width;
							Top:=R.Top+SJ.Top+3;
							Height:=R.Height;
							Date:=Now;
							Visible:=True;
							Setfocus;
							SendMessage(Handle,Wm_syskeydown,Vk_down,1);
						end;
					end;
				end;
			end;
		end;
		CanSelect:=True;
	end;
end;

procedure TSGA.SGBtnStyle(Sender:TObject;ACol,ARow:Integer;var EditStyle:TEditStyle);
begin
	if Charinset(TRFC[1],['3','4']) then begin
		if (ACol=FRMCLL) then EditStyle:=Esellipsis;
	end;
	if (ACol=PRCLL)or(ACol=QYCLL) then begin
		EditStyle:=Esellipsis;
	end; // ELSE EditStyle:=Espicklist;
end;

procedure TSGA.SGPKListItems(ACol,ARow:Integer;Items:TStrings);
begin
	Items.Assign(AMDF.RichEdit.Lines);
end;

procedure TSGA.SGBtnClick(Sender:TObject);
begin
	if (SJ.Col=FRMCLL) then begin
		SGKD(SJ,Vk_f8,[]);
	end else if (SJ.Col=PRCLL) then begin
		SGKD(SJ,Vk_f5,[]);
	end else if (SJ.Col=QYCLL) then begin
		SGKD(SJ,Vk_f6,[]);
	end;
end;

procedure TSGA.SGSetCell(Sender:TObject;ACol,ARow:Integer;Value:string);
begin
	try
		if (Goediting in SJ.Options)or SJ.EnableCheckBoxes then begin // and not SJ.EditorMode
			CN[2].ExecSQL('UPDATE '+TBL+' SET '+SJ.Cols[ACol].Outr.Cinfo.CUL+' ="'+Value+'" WHERE ROWID ="'+
				ARow.ToString+'"');
		end;
	except
		on E:Exception do ShowMessage('SGSetCell'+#13+E.ToString);
	end;
end;

procedure TSGA.SGGetCell(Sender:TObject;ACol,ARow:Longint;var Value:string);
var
	Cl,Ro,Kn,Ki:Integer;
	Cmh,Ref,CUL,Ccl,TMP,TRM,EQ,SEL,SEL1:string;
	WCH:Boolean;
begin
	Value:='';
	TMP:='';
	if (ARow=0) then Value:=SJ.Cols[ACol].Outr.Cinfo.Lg;
	if (ARow>SJ.FixedRows-1)or SJ.EnableCheckBoxes then
		try
			Cl:=ACol; // -SJ.FixedCols+1;
			Ro:=ARow; // -SJ.FixedRows+1;
			CUL:=SJ.Cols[Cl].Outr.Cinfo.CUL;
			Ccl:=SJ.Cols[Cl].Outr.Cinfo.Ccl;
			Kn:=SJ.Cols[Cl].Outr.Cinfo.Kn;
			Cmh:=SJ.Cols[Cl].Outr.Cinfo.Cmh;
			WCH:=SJ.Cols[Cl].Outr.Cinfo.WCH;
			EQ:=SJ.Cols[Cl].Outr.Cinfo.EQ;
			TRM:=SJ.Cols[Cl].Outr.Cinfo.TRM;
			if (Ccl='LAN') then Ccl:=Lan;

			{ if(Kn=1)then begin
				if(Ref<>'')then Ref:=' AND '+Cmh+'.REF="'+Ref+'"'
				else Ref:=' AND "1"="1"';
				TMP:='SELECT CASE WHEN DD THEN (SELECT '+Ccl+' FROM '+Cmh+' WHERE '+Cmh+'.CODE=DD '+Ref+
				' LIMIT 1)ELSE DD END FROM (SELECT CODE AS DD FROM '+TBL+' WHERE ROWID='+Ro.ToString+
				' LIMIT 1)'
				end else }
			if ((Kn in [3,4,9])and WCH)or(Kn=2) then begin
				if (Ref<>'') then Ref:=' AND '+Cmh+'.REF="'+Ref+'"'
				else Ref:=' AND "1"="1"';
				TMP:='SELECT CASE WHEN DD THEN (SELECT '+Ccl+' FROM '+Cmh+' WHERE '+Cmh+'.ROWID=DD'+Ref+
					' LIMIT 1)ELSE DD END FROM (SELECT '+CUL+' AS DD FROM '+TBL+' WHERE ROWID='+Ro.ToString+' LIMIT 1)';
			end else if (Kn=8)and WCH then begin
				TMP:='SELECT CASE WHEN DD THEN (SELECT '+Ccl+' FROM '+Cmh+' WHERE '+Cmh+'.CODE=DD'+
					' LIMIT 1)ELSE DD END FROM (SELECT CODE AS DD FROM '+TBL+' WHERE ROWID='+Ro.ToString+' LIMIT 1)';
			end
			else TMP:='SELECT '+CUL+' FROM '+TBL+' WHERE ROWID='+Ro.ToString+' LIMIT 1';
			if (TMP<>'') then begin
				FQ[2].Open(TMP);
				if FQ[2].RowsAffected>0 then begin
					Value:=FQ[2].Fields[0].AsString;
					if (Kn=7) then Value:=NToDt0(Value);
				end;
			end;
		except
			on E:Exception do ShowMessage('SGGetCell'+#13+Kn.ToString+#13+E.ToString+#13+TMP);
		end;
end;

procedure TSGA.SGSetRowCount(Sender:TObject;ARowCount,AOldRowCount:Integer);
var
	TMP,TMP1,Cont:string;
begin
	try
		if (ARowCount>0) then begin
			if (ARowCount>AOldRowCount) then begin
				TMP1:=Dupestring(',("")',ARowCount-AOldRowCount);
				Delete(TMP1,1,1);
				TMP:='INSERT INTO '+TBL+' ('+Copy(Culs,1,Pos(',',Culs)-1)+') VALUES '+TMP1;
				CN[2].ExecSQL(TMP);
			end else begin
				Cont:=ARowCount.ToString;
				TMP:='DELETE FROM '+TBL+' WHERE ROWID > "'+Cont+'"';
				CN[2].ExecSQL(TMP);
			end;
		end;
	except
		on E:Exception do ShowMessage('SGSetRowCount'+#13+E.ToString);
	end;
end;

procedure TSGA.SGSetColCount(Sender:TObject;AColCount,AOldColCount:Integer);
begin
	// ShowMessage('ColS = '+AColCount.ToString);
end;

procedure TSGA.InplaceShow(Sender:TObject;InplaceEdit:TSGinplaceEdit1;ACol,ARow:Integer;var CanShow:Boolean);
begin
	CanShow:=SJ.Cols[ACol].Outr.Cinfo.ENB;
	if Assigned(InplaceEdit) then begin
		InplaceEdit.Numbersonly:=SJ.Cols[ACol].Outr.Cinfo.Nu;
		if not Assigned(SJ.AutoC) then SJ.AutoC:=TAutoC.Create(InplaceEdit)
		else SJ.AutoC.Strings:=AMDF.RichEdit.Lines;
	end;
end;

procedure TSGA.InplaceChange(Sender:TObject);
var
	TR:Cardinal;
	DF:Pchar;
begin
	if Assigned(SJ.AutoC) then begin
		SJ.AutoC.AutoCompleteDropDown.GetDropDownStatus(TR,DF);
		if (TR=ACDD_VISIBLE) then begin
			AMDF.Caption:=DF;
			CoTaskMemFree(DF);
		end
		else AMDF.Caption:=TSGinplaceEdit1(Sender).Text;
	end;
end;

procedure TSGA.SGContextPopup(Sender:TObject;MousePos:TPoint;var Handled:Boolean);
begin
	// CallMMBScript('RunScript("'+SCRT[7] +'")');
end;

procedure TSGA.SGFixedCellClick(Sender:TObject;ACol,ARow:Integer);
var
	C,S,S1:string;
	R:Boolean;
	L,I:Integer;
begin
	L:=0;
	C:='0';
	if SJ.EnableCheckBoxes then begin
		L:=1;
		if (ARow=0) then C:=SJ.Cols[0].Outr.Cinfo.Scb.ToString
		else if IsTbl then C:=CN[2].ExecSQLScalar('SELECT CHK FROM '+TBL+' WHERE ROWID="'+ARow.ToString+'" LIMIT 1');
		if (C='0') then C:='1'
		else C:='0';
	end;
	if (SJ.Colcount>SJ.FixedCols)and(SJ.RowCount>SJ.FixedRows) then begin
		if (ACol>SJ.FixedCols-1)and(Goediting in SJ.Options) then begin
			TIPBox3.Create(Self,ACol,R,S);
			if R then begin
				SJ.EnableOnChanges:=False;
				if IsTbl then CN[2].ExecSQL('UPDATE '+TBL+' SET '+SJ.Cols[ACol].Outr.Cinfo.CUL+' = "'+S+'"');
				SJ.EnableOnChanges:=True;
			end;
		end;
		if SJ.EnableCheckBoxes then begin
			if (ACol=0)and(ARow>0) then begin
				if IsTbl then CN[2].ExecSQL('UPDATE '+TBL+' SET CHK = "'+C+'" WHERE ROWID="'+ARow.ToString+'"');
				if (Integer(CN[2].ExecSQLScalar('SELECT COUNT(DISTINCT CHK) FROM '+TBL))<>1) then SJ.Cols[0].Outr.Cinfo.Scb:=2
				else SJ.Cols[0].Outr.Cinfo.Scb:=C.Tointeger;
				SJ.Invalidate;
			end else if (ACol=0)and(ARow=0) then begin
				if IsTbl then CN[2].ExecSQL('UPDATE '+TBL+' SET CHK = "'+C+'"');
				SJ.Cols[0].Outr.Cinfo.Scb:=C.Tointeger;
				SJ.Invalidate;
			end;
		end;
		if (ACol=L)and(ARow=0) then begin
			SJ.Selection:=Tgridrect(Rect(SJ.FixedCols,SJ.FixedRows,SJ.Colcount-1,SJ.RowCount-1));
		end;
		if (ACol>L)and(ARow=0) then begin
			SJ.Selection:=Tgridrect(Rect(ACol,SJ.FixedRows,ACol,SJ.RowCount-1));
		end;
		if (ACol=L)and(ARow>0) then begin
			SJ.Selection:=Tgridrect(Rect(SJ.FixedCols,ARow,SJ.Colcount-1,ARow));
		end;
	end;
end;

procedure TSGA.SGMouseDown(Sender:TObject;Button:TMouseButton;Shift:TShiftState;X,Y:Integer);
var
	ACol,ARow:Integer;
begin
	SJ.Refresh;
	SJ.Mousetocell(X,Y,ACol,ARow);
	if (ACol>=SJ.FixedCols)and(ARow>=SJ.FixedRows)and(Button=Mbmiddle) then begin
		SJ.Begindrag(False,1);
	end;
end;

procedure TSGA.SGStartDrag(Sender:TObject;var DragObject:TDragObject);
var
	B,B1,B2:Tbitmap;
	W,H,X1,Y1,X2,Y2,L1,L2,L3,L4,C0,R0:Integer;
	TE,TE1:string;
	CA:Tcolor;
begin
	if Di=nil then begin
		Di:=Tdragimagelist.Create(nil);
		B:=Tbitmap.Create;
		B.Pixelformat:=Pf32bit;
		B1:=Tbitmap.Create;
		B1.Pixelformat:=Pf32bit;
		B2:=Tbitmap.Create;
		B2.Pixelformat:=Pf32bit;
		try
			Ht:=Thw.Create(Application);
			Ht.Parentwindow:=Application.Handle;
			Ht.BidiMode:=Application.BidiMode;
			TE:=Ht.Hint5;
			TE1:=Ht.Hint4;
			Ht.Hint:=TE1;
			Ht.Activatehint(Rect(0,0,0,0),TE1);
			Ht.Hide;
			CA:=Styleservices.Getstylecolor(Scgrid);
			SJ.Grect:=SJ.Selection;
			C0:=SJ.LeftCol;
			R0:=SJ.TopRow;
			SJ.LeftCol:=SJ.Selection.Left;
			SJ.TopRow:=SJ.Selection.Top;
			L1:=SJ.LeftCol;
			L2:=SJ.TopRow;
			L3:=Min(SJ.Selection.Right,L1+SJ.Visiblecolcount-1);
			L4:=Min(SJ.Selection.Bottom,L2+SJ.Visiblerowcount-1);
			X1:=SJ.Cellrect(L1,L2).Left;
			Y1:=SJ.Cellrect(L1,L2).Top;
			X2:=SJ.Cellrect(L3,L4).Right;
			Y2:=SJ.Cellrect(L3,L4).Bottom;
			B.Height:=SJ.Height;
			B.Width:=SJ.Width;
			B.Canvas.Lock;
			SJ.Paintto(B.Canvas.Handle,0,0);
			B.Canvas.Unlock;
			SJ.LeftCol:=C0;
			SJ.TopRow:=R0;
			B1.Canvas.Font.Assign(SJ.Font);
			B1.Height:=Y2-Y1+B1.Canvas.Textwidth(TE)+6;
			B1.Width:=Max(X2-X1+4,B1.Canvas.Textwidth(TE)+8);
			B1.Canvas.Brush.Color:=CA;
			B1.Canvas.Fillrect(Rect(0,0,B1.Width,B1.Height));
			B1.Canvas.Textout(6,2,TE);
			B2.Canvas.Font.Assign(SJ.Font);
			W:=B2.Canvas.Textwidth(TE1)+2;
			H:=B2.Canvas.Textheight(TE1)+2;
			B2.Height:=Y2-Y1+H+4;
			B2.Width:=Max(X2-X1+4,W);
			B2.Canvas.Brush.Color:=CA;
			B2.Canvas.Fillrect(Rect(0,0,B2.Width,B2.Height));
			Stretchblt(B2.Canvas.Handle,2,H+2,X2-X1,Y2-Y1,B.Canvas.Handle,X1,Y1,X2-X1,Y2-Y1,Srccopy);
			B2.Canvas.Textout(2,2,TE1);
			B2.Width:=Max(B2.Width,B1.Width);
			Di.Width:=B2.Width;
			Di.Height:=B2.Height;
			Di.Masked:=True;
			Di.Addmasked(B1,CA);
			Di.Addmasked(B2,CA);
			Di.Setdragimage(0,-15,5);
		finally
			B.Free;
			B1.Free;
			B2.Free;
		end;
	end;
	DRG:=True;
	DragObject:=Tmydragcontrolobject.Create(SJ);
	DragObject.Alwaysshowdragimages:=True;
end;

procedure TSGA.SGEndDrag(Sender,Target:TObject;X,Y:Integer);
begin
	DRG:=False;
	SJ.Enddrag(True);
	Ht.Releasehandle;
	Ht.Free;
end;

procedure TSGA.SGDragDrop(Sender,Source:TObject;X,Y:Integer);
var
	Dcol,Drow,Scol,Srow,Lcol,Lrow,AR,I,J,IX,Rf,Csel,C:Integer;
	SS:TSJ;
	RFC:string;
	Wr:Boolean;
	FR:TProS;
begin
	try
		C:=0;
		Csel:=0;
		if (Source IS Tmydragcontrolobject)and(Sender IS TSJ) then begin
			SS:=TSJ(Tmydragcontrolobject(Source).Control);
			if (Goediting in SJ.Options) then begin
				SJ.Mousetocell(X,Y,Dcol,Drow);
				RFC:=TSGA(SS.Parent).TRFC;
				AR:=SJ.RowCount-1;
				Scol:=SS.Grect.Left;
				Srow:=SS.Grect.Top;
				Lcol:=SS.Grect.Right;
				Lrow:=SS.Grect.Bottom;
				Rf:=Sfm2(1);
				if (Rf=0) then begin
					Rf:=Msg1(Self,SFL1(63),SFL1(92),Sfm1(1),4,SFL1(3)+'|'+SFL1(4)+'|'+SFL1(5)+'|'+SFL1(6),2,SFL1(136),Wr);
					if Wr and(Rf<>2) then begin
						Itm1(1,Rf);
					end;
				end;
				if (Rf=2) then begin
					Exit;
				end;
				if (Rf=3)or(Rf=4) then begin
					for I:=Scol to Lcol do begin
						if ContainsStr(Culs,SS.Cols[I].Outr.Cinfo.Cmh) then Inc(C,1);
					end;
					if C=0 then Exit;
					C:=0;
				end;
				if (Rf=4) then begin
					I:=1;
					while (SJ.Cells[ITCLL,SJ.RowCount-I]='') do begin
						Drow:=SJ.RowCount-I;
						Inc(I,1);
					end;
					if I=1 then Drow:=SJ.RowCount;
					SJ.RowCount:=Drow+(Lrow-Srow);
					AR:=SJ.RowCount-1;
				end;
				if (AR-Drow<Lrow-Srow) then begin
					SJ.RowCount:=SJ.RowCount+(Lrow-Srow)-(AR-Drow);
				end;
				SJ.EnableOnChanges:=False;
				FR:=TProS.Create(Self,SFL1(23),SFL1(137),SFL1(86)+'   %d%%',1);
				for I:=0 to (Lcol-Scol) do begin
					if (Rf=1) then begin
						IX:=Dcol+I;
					end else begin
						FQ[9].Open('SELECT IX FROM '+Dtd1(TRFC)+' WHERE CN = "'+SS.Cols[Scol+I].Outr.Cinfo.CN.ToString+'"');
						IX:=FQ[9].Fields[0].Aslargeint;
					end;
					if (IX<>0) then begin
						Inc(C,1);
						if (C=1) then Csel:=IX;
						for J:=0 to (Lrow-Srow) do begin
							SJ.Cells[0,Drow+J]:=(Drow+J).ToString;
							SJ.Cells[IX,Drow+J]:=SS.Cells[Scol+I,Srow+J];
						end;
					end;
					if FR.ProR(I,Lcol-Scol) then begin
						FR.Destroy;
						SJ.EnableOnChanges:=True;
						Exit;
					end;
				end;
				if (Rf=1) then Csel:=Dcol;
				SGTLC(SJ);
				SJ.Row:=Drow+(Lrow-Srow);
				SJ.Selection:=Tgridrect(Rect(Csel,Drow,Csel+C-1,Drow+(Lrow-Srow)));
				SJ.EnableOnChanges:=True;
				SJ.Setfocus;
			end;
		end;
	except
		on E:Exception do ShowMessage('SGDDrop'+#13+E.ToString);
	end;
end;

procedure TSGA.SGDragOver(Sender,Source:TObject;X,Y:Integer;State:TDragState;var Accept:Boolean);
type
	Tsdir=(Sdu,Sdd,Sdl,Sdr);
	Tsdirs=set of Tsdir;
var
	Sj1:TSJ;
	Sjstyles,Cc,Rc:Integer;
	TL,Rb:Tgridcoord;
	Pt:TPoint;
	Scrolls:Tsdirs;
	Hs,Vs,Hvs:TRect;
begin
	try
		if ((Source as Tmydragcontrolobject).Control IS TSJ)and(Sender IS TSJ) then begin
			Sj1:=TSJ((Source as Tmydragcontrolobject).Control);
			SJ.Mousetocell(X,Y,Cc,Rc);
			TL:=SJ.Grect.Topleft;
			Rb:=SJ.Grect.Bottomright;
			Scrolls:=[];
			if (TL.X=Rb.X)and(TL.Y=Rb.Y) then begin
				SJ.Dragcursor:=Crdrag;
			end else begin
				SJ.Dragcursor:=Crmultidrag;
			end;
			case State of
				Dsdragenter:begin
						if not Ht.Visible then begin
							Ht.Show;
						end;
						SJ.Setfocus;
					end;
				Dsdragmove:begin
						Sjstyles:=Getwindowlong(SJ.Handle,Gwl_style);
						if (Sjstyles and Ws_hscroll<>0) then begin
							Scrolls:=Scrolls+[Sdl,Sdr];
						end;
						if (Sjstyles and Ws_vscroll<>0) then begin
							Scrolls:=Scrolls+[Sdu,Sdd];
						end;
						if (Cc>=SJ.FixedCols)and(Rc>=SJ.FixedRows) then begin
							if (Goediting in SJ.Options) then begin
								Accept:=True;
								if ((Getkeystate(Vk_control)and 128)<>0) then begin
									// copy or link.
									if ((Getkeystate(Vk_shift)and 128)<>0) then begin
										// link.
										if (Ht.Caption<>Ht.Hint3) then begin
											Ht.Caption:=Ht.Hint3;
										end;
									end else begin
										// copy.
										if (Ht.Caption<>Ht.Hint1) then begin
											Ht.Caption:=Ht.Hint1;
										end;
									end;
								end else begin
									// move, link or default.
									if ((Getkeystate(Vk_shift)and 128)<>0) then begin
										// move.
										if (Ht.Caption<>Ht.Hint2) then begin
											Ht.Caption:=Ht.Hint2;
										end;
									end else begin
										// link or default.
										if ((Getkeystate(Vk_menu)and 128)<>0) then begin
											// link.
											if (Ht.Caption<>Ht.Hint3) then begin
												Ht.Caption:=Ht.Hint3;
											end;
										end else begin
											// default.
											if (Ht.Caption<>Ht.Hint4) then begin
												Ht.Caption:=Ht.Hint4;
											end;
										end;
									end;
								end;
								SJ.Col:=Cc;
								SJ.Row:=Rc;
							end else begin
								Accept:=False;
								if (SJ=Sj1) then begin
									if (Ht.Caption<>Ht.Hint1) then begin
										Ht.Caption:=Ht.Hint1;
									end;
								end else begin
									if (Ht.Caption<>Ht.Hint5) then begin
										Ht.Caption:=Ht.Hint5;
									end;
								end;
							end;
						end else begin
							Accept:=False;
							if (Ht.Caption<>Ht.Hint5) then begin
								Ht.Caption:=Ht.Hint5;
							end;
						end;
						if (Scrolls<>[]) then begin
							if (Cc=0)and(Rc=0) then begin
								if (Sdl in Scrolls) then begin
									SJ.Perform(Wm_hscroll,Sb_lineleft,0);
								end;
								if (Sdu in Scrolls) then begin
									SJ.Perform(Wm_vscroll,Sb_lineup,0);
								end;
								// SJ.Cells[0,0]:='L,U';
							end else if (Cc=0)and(Rc>=SJ.FixedRows) then begin
								if (Sdl in Scrolls) then begin
									SJ.Perform(Wm_hscroll,Sb_lineleft,0);
									// SJ.Cells[0,0]:='Left';
								end;
							end else if (Cc>=SJ.FixedCols)and(Rc=0) then begin
								if (Sdu in Scrolls) then begin
									SJ.Perform(Wm_vscroll,Sb_lineup,0);
									// SJ.Cells[0,0]:='UP';
								end;
							end else begin
								Vs.Left:=SJ.ClientRect.Width;
								Vs.Top:=0;
								Vs.Width:=Getsystemmetrics(Sm_cxvscroll);
								Vs.Height:=SJ.Height-Getsystemmetrics(Sm_cyhscroll);
								Hs.Left:=0;
								Hs.Top:=SJ.ClientRect.Height;
								Hs.Width:=SJ.Width-Getsystemmetrics(Sm_cxvscroll);
								Hs.Height:=Getsystemmetrics(Sm_cyhscroll);
								Hvs.Left:=Hs.Width;
								Hvs.Top:=Vs.Height;
								Hvs.Width:=Getsystemmetrics(Sm_cxvscroll);
								Hvs.Height:=Getsystemmetrics(Sm_cyhscroll);
								if Ptinrect(Hs,Point(X,Y)) then begin
									if (Sdd in Scrolls) then begin
										SJ.Perform(Wm_vscroll,Sb_linedown,0);
										// SJ.Cells[0,0]:='Down';
									end;
								end else if Ptinrect(Vs,Point(X,Y)) then begin
									if (Sdr in Scrolls) then begin
										SJ.Perform(Wm_hscroll,Sb_lineright,0);
										// SJ.Cells[0,0]:='Right';
									end;
								end else if Ptinrect(Hvs,Point(X,Y)) then begin
									if (Sdd in Scrolls) then begin
										SJ.Perform(Wm_vscroll,Sb_linedown,0);
									end;
									if (Sdr in Scrolls) then begin
										SJ.Perform(Wm_hscroll,Sb_lineright,0);
									end;
									// SJ.Cells[0,0]:='D,R';
								end;
							end;
						end;
						Getcursorpos(Pt);
						Movewindow(Ht.Handle,Pt.X-Ht.Width,Pt.Y+20,Ht.Width,Ht.Height,False);
					end;
				Dsdragleave:Ht.Hide;
			end;
		end else begin
			Accept:=False;
			Ht.Hide;
		end;
		if (SFR1(39)='0') then begin
			Imagelist_setdragcursorimage(Di.Handle,Ord(Accept),0,0);
		end;
	except
		on E:Exception do ShowMessage('SGDOver'+#13+E.ToString);
	end;
end;

procedure TSGA.BI(Sender:TObject);
var
	R:Tcontrol;
	Invi,I:Integer;
	Invo,S:string;
	B:Tbitmap;
	SM:TMemoryStream;
begin
	R:=Tcontrol(Sender);
	Invo:=INUM.Caption;
	S:='';
	case R.Tag of
		1:SGNew;
		2:begin
				if (TRFC<>'') then begin
					if (Invo<>'') then begin
						Invi:=Na(Invo);
						Invi:=Invi-1;
						if not(Invi<1) then begin
							SGLoad(Invi);
						end;
					end;
				end;
			end;
		3:begin
				if (TRFC<>'') then begin
					if (Invo<>'') then begin
						Invi:=Na(Invo);
						Invi:=Invi+1;
						if not(Invi>Rtc1(TRFC,TST)) then begin
							SGLoad(Invi);
						end;
					end;
				end;
			end;
		4:SGSave;
		5:begin { with TFileStream.Create('C:\Users\MICLE\Desktop\AAA.amd',fmCreate)do begin
					Write(FQ[3].Table,sizeof(FQ[3].Table));
					Free;
					end; }
				I:=Dtn1(TRFC);
				SJ.EnableOnGetCell:=False;
				SGColsRE(CN[I],FQ[I],Dtk1(TRFC)+TST+'n'+INUM.Caption);
				SJ.EnableOnGetCell:=True;
			end;
		6:begin
				IsTew:=False;
				SJ.Options:=SJ.Options+[Goediting];
				SJ.EnableOnChanges:=True;
				BTN[4].Enabled:=True;
				BTN[5].Enabled:=True;
				BTN[6].Enabled:=False;
				BTN[7].Enabled:=False;
				BTN[8].Enabled:=True;
				BTN[9].Enabled:=True;
				BTN[10].Enabled:=False;
				COMME.readOnly:=False;
				DISE.readOnly:=Bl1([DSCLL,DCLL]);
				Adde.readOnly:=Bl1([ADCLL,ACLL]);
				SJ.Setfocus;
			end;
		7:SGDel;
		8:SGAF(0);
		9:SGAF(1);
		10:begin
				B:=Tbitmap.Create;
				B.Pixelformat:=pf24bit;
				B.Height:=Self.ATab.HControl.Height;
				B.Width:=Self.ATab.HControl.Width;
				B.Canvas.Lock;
				Self.ATab.HControl.Paintto(B.Canvas.Handle,0,0);
				B.Canvas.Unlock;
				B.SaveToFile('C:\Users\MICLE\Desktop\AHMD.bmp');
				B.Free;
				// Sgtexcel(SJ,'AHM','C:\Users\MICLE\Desktop\AHMD.xlsx');
				// Sgtword(SJ,'C:\Users\MICLE\Desktop\AHMD.docx');
			end;
		11:begin
				if IsTbl then
						TIPBox2(Owner).TX:=string(CN[2].ExecSQLScalar('SELECT GROUP_CONCAT(ID) FROM '+TBL+' WHERE CHK="1"'));
				STNF.Close;
			end;
		12:begin
				B:=Tbitmap.Create;
				B.Pixelformat:=pf24bit;
				B.Height:=Self.ATab.HControl.Height;
				B.Width:=Self.ATab.HControl.Width;
				B.Canvas.Lock;
				Self.ATab.HControl.Paintto(B.Canvas.Handle,0,0);
				B.Canvas.Unlock;
				FQ[11].SQL.Clear;
				FQ[11].SQL.Add('UPDATE STHUM SET THU=:THU WHERE ICODE='+Tag.ToString+' AND RFC="'+TRFC+'"');
				// FQ[11].SQL.Text := 'insert into STHUM (US,ST,THU) values(3,3,:THU)';
				// ShowMessage('UPDATE STHUM SET THU=:THU WHERE ICODE='+Tag.ToString+' AND RFC="'+TRFC+'"');
				FQ[11].Params[0].DataType:=ftStream; // ftBlob;
				FQ[11].Params[0].StreamMode:=smOpenReadWrite;
				SM:=TMemoryStream.Create;
				B.SaveToStream(SM);
				FQ[11].Params[0].AsStream:=SM;
				FQ[11].ExecSQL;
				B.Free;
				FQ[11].CloseStreams;
				// if SJ.EnableOnGetCell then ShowMessage('get');
				// STNF.Close;
			end;
	end;
	AMDF.UpdateRibbonDOCbtn(Self,ATab);
end;

procedure TSGA.EI(Sender:TObject);
var
	S:string;
	Sa,DS,TX,AD:Extended;
begin
	Sa:=Ne(TOTE.Text);
	DS:=Ne(DISE.Text);
	AD:=Ne(Adde.Text);
	case TEdit(Sender).Tag of
		1:SB[1].Panels[0].Text:=COMME.Text;
		3,4,5,6:begin
				if (Sa>0) then begin
					TX:=0;
					if (SFR1(20)='1') then TX:=Ne(Adde.Text);
					NETE.Text:=(Sa-DS+AD+TX).ToString;
				end else begin
					DISE.Text:='0';
					Adde.Text:='0';
					NETE.Text:='0';
					VATE.Text:='0';
				end;
				// ET1[CU].Hint:=LANT(DIR,SFR1(5),ET1[CU].Text,SFCR1(NA(SFR1(3))),SFCR2(NA(SFR1(3))));
			end;
		7:begin
				S:=Lant(Dir,Lan,NETE.Text,Sfcr1(Na(SFR1(3))),Sfcr2(Na(SFR1(3))));
				LB[20].Caption:=SFL1(54)+' : '+#13+#13+S;
				NETE.Hint:=S;
				Pn1.Hint:=S;
			end;
	end;
end;

procedure TSGA.InvnClick(Sender:TObject);
var
	Invi:Integer;
	Invo:string;
begin
	Invo:=SHB.Text;
	if (INUM.Caption=Invo) then Exit;
	if (Invo<>'') then begin
		Invi:=Na(Invo);
		if not(Invi>Rtc1(TRFC,TST))and(Invi>0) then begin
			if Charinset(TRFC[1],['1'..'6']) then begin
				SGLoad(Invi);
			end;
			if (TRFC='7') then begin

			end;
		end;
	end;
end;

procedure TSGA.InvnKeyPress(Sender:TObject;var Key:Char);
var
	Invi:Integer;
	Invo:string;
begin
	if (Ord(Key)=Vk_return) then begin
		Key:=#0;
		Invo:=SHB.Text;
		if (INUM.Caption=Invo) then Exit;
		if (Invo<>'') then begin
			Invi:=Na(Invo);
			if not(Invi>Rtc1(TRFC,TST))and(Invi>0) then begin
				if Charinset(TRFC[1],['1'..'6']) then begin
					SGLoad(Invi);
				end;
				if (TRFC='7') then begin

				end;
			end;
		end;
	end;
end;

procedure TSGA.Staid1(Sender:TObject);
begin
	if (STNA.ItemIndex=-1) then begin
		STNA.Sbo(Tti_error_large,SFL1(87),SFL1(40),STNA.ClientRect,2);
		STNA.Setfocus;
		Exit;
	end;
	TSTA.Create(Self,INUM.Caption);
end;

procedure TSGA.SBDPanel(Statusbar:TStatusBar;Panel:TStatusPanel;const Rect:TRect);
begin
	{ bv:=TButton(TForm(StatusBar.Parent).FindComponent('STAID'));
		if Panel=StatusBar.Panels[1] then
		with bv do begin
		Top:=Rect.Top;
		Left:=Rect.Left-2;
		Width:=Rect.Width;
		Height:=Rect.Height;
		end; }
end;

procedure TSGA.CB2S(Sender:TObject);
var
	R:TComboBoxEx;
	O,I:Integer;
	RFC:string;
begin
	R:=TComboBoxEx(Sender);
	SBO1;
	SB[1].Panels[0].Text:=R.Items[R.ItemIndex];
	case R.Tag of
		1:TCE:=SFCE2(CCNA.Items[CCNA.ItemIndex]);
		2:begin
				CCID.ItemIndex:=CCID.Items.Indexof(Sfcc2(CCNA.Items[CCNA.ItemIndex]));
				SGCINF(CCID.Items[CCID.ItemIndex]);
				TCC:=CCID.Items[CCID.ItemIndex];
			end;
		3:begin
				CCNA.ItemIndex:=CCNA.Items.Indexof(Sfcc1(CCID.Items[CCID.ItemIndex]));
				SGCINF(CCID.Items[CCID.ItemIndex]);
				TCC:=CCID.Items[CCID.ItemIndex];
			end;
		4:TSN:=Sfsn2(SNNA.Items[SNNA.ItemIndex]);
		5:begin
				TST:=Sfst2(STNA.Items[STNA.ItemIndex]);
				SGNew;
			end;
		6:TFR:=FRID.Items[FRID.ItemIndex];
	end;
	if Charinset(TRFC[1],['3','4'])and(CCID.ItemIndex>-1) then begin
		case R.Tag of
			2,3:begin
					case Na(TRFC) of
						3:RFC:='1';
						4:RFC:='2';
					end;
					O:=Dtn1(RFC);
					if (CCID.ItemIndex>-1) then begin
						FQ[O].Open('SELECT ICODE FROM '+Dtm1(RFC)+' WHERE ST = "'+TST+'" AND FRM = "'+
							CCID.Items[CCID.ItemIndex]+'"');
						FRID.Clear;
						if (FQ[O].RowsAffected>0) then begin
							FRID.Text:='';
							for I:=0 to FQ[O].RowsAffected-1 do begin
								FRID.Itemsex.Additem(FQ[O].Fields[0].AsString,-1,-1,-1,-1,nil);
								FQ[O].Next;
							end;
						end;
					end;
				end;
		end;
	end;
end;

procedure TSGA.CB2KP(Sender:TObject;var Key:Char);
var
	R:Tcomponent;
	O,I:Integer;
	RFC:string;
begin
	R:=Tcomponent(Sender);
	case R.Tag of
		1:TCE:=SFCE2(CCNA.Items[CCNA.ItemIndex]);
		2:begin
				if (Ord(Key)=Vk_return) then begin
					Key:=#0;
					try
						CCID.ItemIndex:=CCID.Items.Indexof(Sfcc2(CCNA.Items[CCNA.ItemIndex]));
						SGCINF(CCID.Items[CCID.ItemIndex]);
					except
						on E:Exception do begin
							CCID.ItemIndex:=-1;
							SGCINF('AMD_NO_CUSTOMER061995');
							FRID.Clear;
							CCNA.Sbo(Tti_error_large,SFL1(90),SFL1(38),CCNA.ClientRect,2);
							CCNA.Setfocus;
							Exit;
						end;
					end;
				end;
				if (Ord(Key)=Vk_tab) then begin
					Key:=#0;
					CCNA.Droppeddown:=False;
					if (SNNA.ItemIndex=-1) then begin
						SNNA.Setfocus;
						SNNA.Droppeddown:=True;
					end;
				end;
			end;
		3:begin
				if (Ord(Key)=Vk_return) then begin
					Key:=#0;
					try
						CCNA.ItemIndex:=CCNA.Items.Indexof(Sfcc1(CCID.Items[CCID.ItemIndex]));
						SGCINF(CCID.Items[CCID.ItemIndex]);
					except
						on E:Exception do begin
							CCNA.ItemIndex:=-1;
							SGCINF('AMD_NO_CUSTOMER061995');
							FRID.Clear;
							CCID.Sbo(Tti_error_large,SFL1(90),SFL1(43),CCID.ClientRect,2);
							CCID.Setfocus;
							Exit;
						end;
					end;
				end;
				if (Ord(Key)=Vk_tab) then begin
					Key:=#0;
					CCID.Droppeddown:=False;
					if (SNNA.ItemIndex=-1) then begin
						SNNA.Setfocus;
						SNNA.Droppeddown:=True;
					end;
				end;
			end;
		4:begin
				TSN:=Sfsn2(SNNA.Items[SNNA.ItemIndex]);
				if (Ord(Key)=Vk_tab) then begin
					Key:=#0;
					SNNA.Droppeddown:=False;
					COMME.Setfocus;
				end;
			end;
		5:begin
				if (Ord(Key)=Vk_return)or(Ord(Key)=Vk_tab) then begin
					Key:=#0;
					try TST:=Sfst2(STNA.Items[STNA.ItemIndex]);
					except
						on E:Exception do begin
							STNA.ItemIndex:=STNA.Items.Indexof(Sfst1(TST));
						end;
					end;
				end;
			end;
		6: if (FRID.ItemIndex>-1) then TFR:=FRID.Items[FRID.ItemIndex];
	end;
	if Charinset(TRFC[1],['3','4'])and(CCID.ItemIndex>-1) then begin
		case R.Tag of
			2,3:begin
					case Na(TRFC) of
						3:RFC:='1';
						4:RFC:='2';
					end;
					O:=Dtn1(RFC);
					if (CCID.ItemIndex>-1) then begin
						FQ[O].Open('SELECT ICODE FROM '+Dtm1(RFC)+' WHERE ST = "'+TST+'" AND FRM = "'+
							CCID.Items[CCID.ItemIndex]+'"');
						FRID.Clear;
						if (FQ[O].RowsAffected>0) then begin
							FRID.Text:='';
							for I:=0 to FQ[O].RowsAffected-1 do begin
								FRID.Itemsex.Additem(FQ[O].Fields[0].AsString,-1,-1,-1,-1,nil);
								FQ[O].Next;
							end;
						end;
					end;
				end;
		end;
	end;
end;

procedure TSGA.STChange(Sender:TObject);
begin
	if Sender IS TLabel then SB[1].Panels[0].Text:=(Sender as TLabel).Caption
	else if Sender IS TPanel then SB[1].Panels[0].Text:=(Sender as TPanel).Caption
	else if Sender IS Tdatetimepicker then begin
		with (Sender as Tdatetimepicker) do
			if (Kind=Dtkdate) then SB[1].Panels[0].Text:=Formatdatetime('dddd, dd MMMM, yyyy',Date);
	end else if (Sender IS TComboBoxEx) then begin
		with (Sender as TComboBoxEx) do
			if (ItemIndex>-1) then SB[1].Panels[0].Text:=Items[ItemIndex];

	end;
end;

procedure TSGA.CBExit(Sender:TObject);
begin
	if (Sender IS TComboBoxEx) then begin
		with (Sender as TComboBoxEx) do begin
			Droppeddown:=False;
			Text:='';
			ItemIndex:=-1;
			Visible:=False;
		end;
		SJ.Setfocus;
		SJ.Perform(Wm_lbuttonup,0,0);
	end else if (Sender IS Tdatetimepicker) then begin
		(Sender as Tdatetimepicker).Visible:=False;
		SJ.Setfocus;
	end;
end;

procedure TSGA.CBKeyPress(Sender:TObject;var Key:Char);
var
	ARow,ACol:Integer;
begin
	ARow:=SJ.Row;
	ACol:=SJ.Col;
	try
		if (Sender IS TComboBoxEx) then begin
			with (Sender as TComboBoxEx) do begin
				if (SJ.Cells[ACol,ARow]='') then begin
					if (Ord(Key)=Vk_return)or(Ord(Key)=Vk_tab) then begin
						Key:=#0;
						if (Items.Indexof(Text)>-1) then SJ.Cells[ACol,ARow]:=Text
						else SJ.Cells[ACol,ARow]:='';
						Droppeddown:=False;
						Text:='';
						ItemIndex:=-1;
						Visible:=False;
						SJ.Setfocus;
					end;
				end else begin
					Droppeddown:=False;
					Text:='';
					ItemIndex:=-1;
					Visible:=False;
					SJ.Setfocus;
				end;
			end;
		end else if (Sender IS Tdatetimepicker) then begin
			with (Sender as Tdatetimepicker) do begin
				if (SJ.Cells[ACol,ARow]='') then begin
					if (Ord(Key)=Vk_return)or(Ord(Key)=Vk_tab) then begin
						Key:=#0;
						SJ.Cells[ACol,ARow]:=Datetostr(Date)
					end else if (Ord(Key)=Vk_escape) then SJ.Cells[ACol,ARow]:='';
					Visible:=False;
					SJ.Setfocus;
				end;
			end;
		end;
	except
		on E:Exception do ShowMessage('CBKeyPress'+#13+E.Message);
	end;
end;

procedure TSGA.CBSelect(Sender:TObject);
var
	Csb,OB:TComboBoxEx;
	CN1,Cmh,Cmh1,Kn,It,Ccl,Ref,TRM,Ccl0,Nit:string;
	I,T,D,R,IX,CCB,Cn0:Integer;
begin
	Csb:=TComboBoxEx(Sender);
	Cn0:=Csb.Tag;
	CN1:=Cn0.ToString;
	R:=SJ.Row;
	Nit:=Sfd62(ITCLL,TRFC);
	try
		SBO1;
		SB[1].Panels[0].Text:=Csb.Items[Csb.ItemIndex];
		FQ[9].Open('SELECT CMH,KN,CCL FROM '+Dtd1(TRFC)+' WHERE CN = "'+CN1+'" AND ACT = "1"');
		Cmh:=FQ[9].Fields[0].AsString;
		Kn:=FQ[9].Fields[1].AsString;
		Ccl:=FQ[9].Fields[2].AsString;
		if (Ccl='LAN') then Ccl:=Lan;
		Ccl0:=Sfd1(1,TRFC);
		Ref:=Sfd5(1,TRFC);
		if (Cmh=Nit) then begin
			if (Kn='1')or(CN1='1') then begin
				if (Ref<>'') then It:=Sff1(Ccl0,Cmh,Ccl,Csb.Items[Csb.ItemIndex],'REF',Ref)
				else It:=Sff1(Ccl0,Cmh,Ccl,Csb.Items[Csb.ItemIndex]);
				SJ.Cells[ITCLL,R]:=It;
				FQ[9].Open('SELECT IX,CCL FROM '+Dtd1(TRFC)+' WHERE KN = "1" AND ACT = "1"');
				if (FQ[9].RowsAffected>0) then
					for I:=0 to FQ[9].RowsAffected-1 do begin
						IX:=FQ[9].Fields[0].Aslargeint;
						Ccl:=FQ[9].Fields[1].AsString;
						if (Ccl='LAN') then Ccl:=Lan;
						SJ.Cells[IX,R]:=Sff1(Ccl,Cmh,Ccl0,It);
						FQ[9].Next;
					end;
			end;
		end else begin
			It:=SJ.Cells[ITCLL,R];
			TRM:=Sff1('id',Cmh,Ccl,Csb.Items[Csb.ItemIndex]);
			FQ[9].Open('SELECT IX,CN,REF,CCL,CCB,CMH FROM '+Dtd1(TRFC)+' WHERE TRM = "'+Cmh+'" AND ACT = "1"');
			if (FQ[9].RowsAffected>0) then begin
				for I:=0 to FQ[9].RowsAffected-1 do begin
					IX:=FQ[9].Fields[0].Aslargeint;
					Cn0:=FQ[9].Fields[1].AsInteger;
					Ref:=FQ[9].Fields[2].AsString;
					Ccl:=FQ[9].Fields[3].AsString;
					CCB:=FQ[9].Fields[4].Aslargeint;
					Cmh1:=FQ[9].Fields[5].AsString;
					if (Ref<>'') then Ref:=' AND REF = "'+Ref+'"'
					else Ref:='';
					if (Ccl='LAN') then Ccl:=Lan;
					if (Cmh1='NIT') then FQ[2].Open('SELECT DISTINCT '+Ccl+',INX FROM '+Cmh1+' WHERE '+Cmh+' = "'+TRM+'"'+Ref)
					else FQ[2].Open('SELECT DISTINCT '+Ccl+',INX FROM '+Cmh1+' WHERE '+Cmh+' = "'+TRM+'"');
					if (FQ[2].RowsAffected>0) then begin
						if (FQ[2].RowsAffected>1)and(CCB=1) then begin
							SJ.Cells[IX,R]:='';
							if (SJ.Cols[IX].Outr.Fobj<>nil) then
								if (SJ.Cols[IX].Outr.Fobj IS TComboBoxEx) then begin
									OB:=TComboBoxEx(SJ.Cols[IX].Outr.Fobj);
									OB.Clear;
									for T:=0 to FQ[2].RowsAffected-1 do begin
										D:=FQ[2].Fields[1].AsInteger;
										OB.Itemsex.Additem(FQ[2].Fields[0].AsString,D,D,-1,-1,nil);
										FQ[2].Next;
									end;
								end;
						end
						else SJ.Cells[IX,R]:=FQ[2].Fields[0].AsString;
					end
					else SJ.Cells[IX,R]:='';
					FQ[9].Next;
				end;
			end;
		end;
	except
		on E:Exception do ShowMessage('CBSelect'+#13+E.Message);
	end;
end;

/// //////////////////////////////////// TSGG ////////////////////////////////////////////

{ TSGG }

/// /////////////////////////////////// OPERATIONS ////////////////////////////////////////////
/// //////////////////////////////////////////////////////////////////////////////////////////
/// //////////////////////////////////////////////////////////////////////////////////////////
procedure TSGA.SGTLC(Sender:TObject);
begin
	Adh.LBF1.Caption:=SJ.TopRow.ToString+' - '+(SJ.TopRow+SJ.Visiblerowcount-1).ToString+' '+SFL1(78)+' '+
		(SJ.RowCount-1).ToString;
	Adh.LBF1.Hint:=Adh.LBF1.Caption;
end;

procedure TSGA.SGB(Sender:TObject);
var
	Bt:Tspeedbutton;
	SHM,TRM,CUL:string;
begin
	Bt:=Tspeedbutton(Sender);
	SHM:='';
	CUL:=SJ.Cols[Bt.Tag].Outr.Cinfo.CUL;
	if (Bt.Caption='r') then begin
		Bt.Caption:='s';
		Bt.Hint:=SFL1(135)+' '+SJ.Cols[Bt.Tag].Outr.Cinfo.Lg;
		TRM:=' ORDER BY '+CUL+' DESC;';
	end else begin
		Bt.Caption:='r';
		Bt.Hint:=SFL1(134)+' '+SJ.Cols[Bt.Tag].Outr.Cinfo.Lg;
		TRM:=' ORDER BY '+CUL+' ASC;';
	end;
	SJ.EnableOnGetCell:=False;
	try
		SHM:=SHM+'CREATE TABLE '+TBL+'_AA AS SELECT * FROM '+TBL+TRM; // TEMPORARY
		SHM:=SHM+'DROP TABLE IF EXISTS '+TBL+';';
		SHM:=SHM+'ALTER TABLE '+TBL+'_AA RENAME TO '+TBL;
		AMDF.RichEdit.Lines.Text:=SHM;
		SJ.EnableOnChanges:=False;
		CN[2].ExecSQL(SHM);
		SJ.EnableOnChanges:=True;
	except
		on E:Exception do ShowMessage('SGB'+#13+E.Message);
	end;
	SJ.EnableOnGetCell:=True;
	SJ.Invalidate;
end;

procedure TSGA.SGMMove(Sender:TObject;Shift:TShiftState;X,Y:Integer);
var
	BT1:Tspeedbutton;
	ACol,ARow:Integer;
begin
	with SJ do begin
		Mousetocell(X,Y,ACol,ARow);
		BT1:=ColButton;
		if (ARow<FixedRows)and(ARow>-1)and(ACol>-1) then begin
			Hint:=Cols[ACol].Outr.Cinfo.Lg;
			BT1.Tag:=ACol;
			BT1.Boundsrect:=Cellrect(ACol,ARow);
			BT1.Height:=9;
			BT1.Width:=ColWidths[ACol];
			if (BT1.Caption='r') then BT1.Hint:=SFL1(134)+' '+Hint
			else BT1.Hint:=SFL1(135)+' '+Hint;
			BT1.Visible:=True;
			So(Application.Icon.Handle,Hint,BT1.Hint,Cellrect(ACol,ARow));
		end else begin
			BT1.Visible:=False;
			Destroywindow(Hip3);
			Hip3:=0;
		end;
	end;
end;

procedure TSGA.SGCols;
var
	I,Mx,D,T:Integer;
begin
	try
		ITCLL:=0;
		PRCLL:=0;
		QYCLL:=0;
		TOCLL:=0;
		CECLL:=0;
		FRMCLL:=0;
		VTCLL:=0;
		DSCLL:=0;
		ADCLL:=0;
		VCLL:=0;
		DCLL:=0;
		ACLL:=0;
		SNCLL:=0;
		CMCLL:=0;
		FQ[9].Open('SELECT CW,'+Lan+',NU,CUL,CMH,CCL,REF,TY,TRM,TRMC,KI,KN,WCH,CN,CCB,IX,SCB,KA,EQ,KL,AUT,DFT,VIS,ENB FROM '
			+Dtd1(TRFC)+' WHERE ACT="1" ORDER BY IX ASC');
		Mx:=FQ[9].RowsAffected;
		if (Mx>0) then
			with SJ do begin
				Culs:='';
				Colcount:=0;
				Colcount:=1+Mx;
				FixedCols:=1;
				if EnableCheckBoxes then begin
					Colcount:=Mx+2;
					FixedCols:=2;
					ColWidths[0]:=20;
					Cols[0].Outr.Cinfo.Lg:='0';
					Cols[0].Outr.Cinfo.CUL:='CHK';
					Cols[0].Outr.Cinfo.Kn:=0;
				end;
				Cols[FixedCols-1].Outr.Cinfo.Lg:=SFL1(25);
				Cols[FixedCols-1].Outr.Cinfo.CUL:='ID';
				Cols[FixedCols-1].Outr.Cinfo.Kn:=0;
				for I:=FixedCols to Colcount-1 do begin
					ColWidths[I]:=FQ[9].Fields[0].Aslargeint;
					Cols[I].Outr.Cinfo.VIS:=Boolean(FQ[9].Fields[22].AsInteger);
					if not Cols[I].Outr.Cinfo.VIS then ColWidths[I]:=0;
					Cols[I].Outr.Cinfo.Cw:=FQ[9].Fields[0].Aslargeint;
					Cols[I].Outr.Cinfo.Lg:=FQ[9].Fields[1].AsString;
					Cols[I].Outr.Cinfo.Nu:=Boolean(FQ[9].Fields[2].AsInteger);
					Cols[I].Outr.Cinfo.CUL:=FQ[9].Fields[3].AsString;
					Culs:=Culs+','+FQ[9].Fields[3].AsString;
					Cols[I].Outr.Cinfo.Cmh:=FQ[9].Fields[4].AsString;
					Cols[I].Outr.Cinfo.Ccl:=FQ[9].Fields[5].AsString;
					Cols[I].Outr.Cinfo.Ref:=FQ[9].Fields[6].AsString;
					Cols[I].Outr.Cinfo.TY:=FQ[9].Fields[7].AsString;
					Cols[I].Outr.Cinfo.TRM:=FQ[9].Fields[8].AsString;
					Cols[I].Outr.Cinfo.Trmc:=FQ[9].Fields[9].AsString;
					Cols[I].Outr.Cinfo.Ki:=FQ[9].Fields[10].AsInteger;
					Cols[I].Outr.Cinfo.Kn:=FQ[9].Fields[11].AsInteger;
					Cols[I].Outr.Cinfo.WCH:=Boolean(FQ[9].Fields[12].AsInteger);
					Cols[I].Outr.Cinfo.CN:=FQ[9].Fields[13].AsInteger;
					Cols[I].Outr.Cinfo.CCB:=FQ[9].Fields[14].AsInteger;
					Cols[I].Outr.Cinfo.Scb:=FQ[9].Fields[16].AsInteger;
					Cols[I].Outr.Cinfo.KA:=FQ[9].Fields[17].AsInteger;
					Cols[I].Outr.Cinfo.EQ:=FQ[9].Fields[18].AsString;
					Cols[I].Outr.Cinfo.Kl:=FQ[9].Fields[19].AsString;
					Cols[I].Outr.Cinfo.AUT:=Boolean(FQ[9].Fields[20].AsInteger);
					Cols[I].Outr.Cinfo.DFT:=FQ[9].Fields[21].AsString;
					Cols[I].Outr.Cinfo.ENB:=Boolean(FQ[9].Fields[23].AsInteger);
					if (FQ[9].Fields[3].AsString='CODE') then ITCLL:=FQ[9].Fields[15].AsInteger;
					if (FQ[9].Fields[3].AsString='PR') then PRCLL:=FQ[9].Fields[15].AsInteger;
					if (FQ[9].Fields[3].AsString='QTY') then QYCLL:=FQ[9].Fields[15].AsInteger;
					if (FQ[9].Fields[3].AsString='TOTAL') then TOCLL:=FQ[9].Fields[15].AsInteger;
					if (FQ[9].Fields[3].AsString='NCCE') then CECLL:=FQ[9].Fields[15].AsInteger;
					if (FQ[9].Fields[3].AsString='IFRM') then FRMCLL:=FQ[9].Fields[15].AsInteger;
					if (FQ[9].Fields[3].AsString='VT') then VTCLL:=FQ[9].Fields[15].AsInteger;
					if (FQ[9].Fields[3].AsString='DS') then DSCLL:=FQ[9].Fields[15].AsInteger;
					if (FQ[9].Fields[3].AsString='AD') then ADCLL:=FQ[9].Fields[15].AsInteger;
					if (FQ[9].Fields[3].AsString='NIT3VAT') then VCLL:=FQ[9].Fields[15].AsInteger;
					if (FQ[9].Fields[3].AsString='NIT3DIS') then DCLL:=FQ[9].Fields[15].AsInteger;
					if (FQ[9].Fields[3].AsString='NIT3ADS') then ACLL:=FQ[9].Fields[15].AsInteger;
					if (FQ[9].Fields[3].AsString='NSN') then SNCLL:=FQ[9].Fields[15].AsInteger;
					if (FQ[9].Fields[3].AsString='COMN') then CMCLL:=FQ[9].Fields[15].AsInteger;
					FQ[9].Next;
				end;
				Delete(Culs,1,1);
				if (SView=ViNone) then SGControls;
			end;
	except
		on E:Exception do ShowMessage('Cols WIDTH'+#13+E.Message);
	end;
end;

procedure TSGA.SGClear;
const
	Idn='id INTEGER';
	Ct='CREATE TEMPORARY TABLE IF NOT EXISTS ';
var
	I:Integer;
	TMP:string;
begin
	try
		SBO1;
		with SJ do begin
			EnableAllOn:=False;
			RowCount:=FixedRows+1;
			if IsTbl then IsTbl:=DTmpC(TRFC,TBL,ERR,False);
			EnableAllOn:=True;
		end;
		INUM.Caption:='';
		TPanel(Findcomponent('CS10')).Caption:='';
		TPanel(Findcomponent('CS11')).Caption:='';
		TPanel(Findcomponent('CS12')).Caption:='';
		TPanel(Findcomponent('CS13')).Caption:='';
		COMME.readOnly:=False;
		COMME.Text:='';
		TOTE.Text:='0';
		QTYE.Text:='0';
		DISE.Text:='0';
		Adde.Text:='0';
		TSN:='';
		TCE:='';
		TCC:='';
		TFR:='';
		Adh.ED1.Text:='1';
		SHB.Text:='';
		CCE.ItemIndex:=-1;
		CCNA.ItemIndex:=-1;
		CCID.ItemIndex:=-1;
		SNNA.ItemIndex:=-1;
		FRID.ItemIndex:=-1;
		EditBtn.Caption:='';
		EditBtn.Imageindex:=-1;
		Dtmpdech(2);
		CN[2].ExecSQL('ATTACH "'+Md[8]+'" AS "A8"');
	except
		on E:Exception do ShowMessage('SGCLEAR'+#13+E.Message);
	end;
end;

procedure TSGA.SGNew;
begin
	try
		SGClear;
		SJ.EnableAllOn:=False;
		if (SFR1(41)='1') then SGCols;
		SJ.EnableAllOn:=True;
		PRC:=PRPolicy(TRFC);
		SJ.Options:=SJ.Options+[Goediting];
		DT[1].Date:=Date;
		TM[1].time:=time;
		DT[2].Date:=Date;
		TM[2].time:=time;
		BTN[2].Enabled:=True;
		BTN[3].Enabled:=True;
		BTN[4].Enabled:=True;
		BTN[5].Enabled:=True;
		BTN[6].Enabled:=False;
		BTN[7].Enabled:=False;
		BTN[8].Enabled:=True;
		BTN[9].Enabled:=True;
		BTN[10].Enabled:=False;
		DISE.readOnly:=Bl1([DSCLL,DCLL]);
		Adde.readOnly:=Bl1([ADCLL,ACLL]);
		EditBtn.Caption:='';
		EditBtn.Imageindex:=-1;
		IsTew:=True;
		INUM.Caption:=(Rtc1(TRFC,TST)+1).ToString;
		SJ.Col:=SJ.FixedCols;
		SJ.Row:=SJ.FixedRows;
		SGTLC(SJ);
		Refresh;
		if IsTorm then begin
			if Visible and CCNA.Enabled then STNF.ActiveControl:=CCNA;
		end else if Visible and CCNA.Enabled then CCNA.Setfocus;
	except
		on E:Exception do ShowMessage('SGNEW'+#13+E.Message);
	end;
end;

procedure TSGA.SGCINF(Cod5:string);
begin
	if (Sfcc1(Cod5)<>'') then begin
		try
			FQ[2].Open('SELECT CIT,ADR,PHO1,MOB1 FROM NCLIENTS WHERE CODE = "'+Cod5+'"');
			TPanel(Findcomponent('CS10')).Caption:=FQ[2].Fields[0].AsString;
			TPanel(Findcomponent('CS11')).Caption:=FQ[2].Fields[1].AsString;
			TPanel(Findcomponent('CS12')).Caption:=FQ[2].Fields[2].AsString;
			TPanel(Findcomponent('CS13')).Caption:=FQ[2].Fields[3].AsString;
		except
			on E:Exception do ShowMessage('SGCINF'+#13+E.Message);
		end;
	end else begin
		TPanel(Findcomponent('CS10')).Caption:='';
		TPanel(Findcomponent('CS11')).Caption:='';
		TPanel(Findcomponent('CS12')).Caption:='';
		TPanel(Findcomponent('CS13')).Caption:='';
	end;
end;

procedure TSGA.SGLoad(INV:Integer);
var
	IVN,Rfc1,Ref,Ccl,CULM,CUL,SHM,EQ,DFT,TMP,Cmh:string;
	O,U,RE,PSS0,I,T,Kn,Ki:Integer;
	WCH,WCH1,AUT:Boolean;
	FR:TProS;
	C1,C2:Extended;
	AA:TSQLiteDatabaseProgressEvent;
	D1,D2:Uint64;
	SS:TStringList;
begin
	FR:=nil;
	RE:=0;
	D1:=TNow;
	Tag:=INV;
	SS:=TStringList.Create;
	try
		IVN:=Dtk1(TRFC)+TST+'n'+INV.ToString;
		if not(INV>Rtc1(TRFC,TST))and(INV>0) then begin
			PSS0:=2;
			while (PSS0>1) do begin
				PSS0:=SPSS1(Self,TRFC,TST,INV.ToString);
				if (PSS0=0) then Exit;
			end;
			O:=Dtn1(TRFC);
			SJ.Options:=SJ.Options-[Goediting];
			BTN[2].Enabled:=True;
			BTN[3].Enabled:=True;
			BTN[4].Enabled:=False;
			BTN[5].Enabled:=False;
			BTN[6].Enabled:=True;
			BTN[7].Enabled:=True;
			BTN[8].Enabled:=False;
			BTN[9].Enabled:=False;
			BTN[10].Enabled:=True;
			DISE.readOnly:=True;
			Adde.readOnly:=True;
			SGClear;
			COMME.readOnly:=True;
			FQ[O].Open('SELECT COUNT(ROWID) FROM '+IVN);
			if (FQ[O].RowsAffected>0) then RE:=FQ[O].Fields[0].AsInteger-1;
			FQ[O].Open('SELECT SUM(QTY) FROM '+IVN);
			if (FQ[O].RowsAffected>0) then QTYE.Text:=FQ[O].Fields[0].AsString;
			FQ[O].Open('SELECT FRM,COMM,SA,DS,DAT,SN,AD,CE,VT,IFRM,DAT1,PRC FROM '+Dtm1(TRFC)+' WHERE ICODE = "'+INV.ToString+
				'" AND ST = "'+TST+'"');
			INUM.Caption:=INV.ToString;
			CCNA.ItemIndex:=CCNA.Items.Indexof(Sfcc1(FQ[O].Fields[0].AsString));
			CCID.ItemIndex:=CCID.Items.Indexof(FQ[O].Fields[0].AsString);
			TCC:=FQ[O].Fields[0].AsString;
			COMME.Text:=FQ[O].Fields[1].AsString;
			TOTE.Text:=FQ[O].Fields[2].AsString;
			DISE.Text:=FQ[O].Fields[3].AsString;
			Adde.Text:=FQ[O].Fields[6].AsString;
			VATE.Text:=FQ[O].Fields[8].AsString;
			PRC:=FQ[O].Fields[11].AsInteger;
			TFR:=FQ[O].Fields[9].AsString;
			NToDt(FQ[O].Fields[4].AsString,C1,C2);
			DT[1].Date:=C1;
			TM[1].time:=C2;
			NToDt(FQ[O].Fields[10].AsString,C1,C2);
			DT[2].Date:=C1;
			TM[2].time:=C2;
			TSN:=FQ[O].Fields[5].AsString;
			SNNA.ItemIndex:=SNNA.Items.Indexof(SFSN1(TSN));
			CCE.ItemIndex:=CCE.Items.Indexof(SCCE1(FQ[O].Fields[7].AsString));
			TCE:=FQ[O].Fields[7].AsString;
			SGCINF(FQ[O].Fields[0].AsString);
			if Charinset(TRFC[1],['3','4'])and(CCID.ItemIndex>-1) then begin
				case Na(TRFC) of
					3:Rfc1:='1';
					4:Rfc1:='2';
				end;
				U:=Dtn1(Rfc1);
				if FRID.Enabled then begin
					FQ[U].Open('SELECT ICODE FROM '+Dtm1(Rfc1)+' WHERE ST = "'+TST+'" AND FRM = "'+TCC+'"');
					FRID.Clear;
					if (FQ[U].RowsAffected>0) then begin
						for I:=0 to FQ[U].RowsAffected-1 do begin
							FRID.Itemsex.Additem(FQ[U].Fields[0].AsString,-1,-1,-1,-1,nil);
							FQ[U].Next;
						end;
						FRID.ItemIndex:=FRID.Items.Indexof(TFR);
					end;
				end;
			end;
			FQ[7].Open('SELECT STAT,CONT FROM EDT WHERE ICODE = "'+INV.ToString+'" AND ST="'+TST+'" AND RIF="'+TRFC+
				'" ORDER BY id DESC LIMIT 1');
			case FQ[7].Fields[0].AsInteger of
				0:begin
						EditBtn.Imageindex:=0;
						EditBtn.Caption:=SFL1(67);
					end;
				1:begin
						EditBtn.Imageindex:=1;
						EditBtn.Caption:=SFL1(68)+' ['+FQ[7].Fields[1].AsString+']';
					end;
				2:begin
						if (TSN<>'0') then begin
							EditBtn.Imageindex:=3;
							EditBtn.Caption:=SFL1(70)+' ['+FQ[7].Fields[1].AsString+']';
						end else begin
							EditBtn.Imageindex:=2;
							EditBtn.Caption:=SFL1(69)+' ['+FQ[7].Fields[1].AsString+']';
						end;
					end;
			end;
			EditBtn.Hint:=EditBtn.Caption;
			SJ.EnableAllOn:=False;
			if (SFR1(41)='1') then SGColsRE(CN[O],FQ[O],IVN);
			if (RE=0) then begin
				SJ.RowCount:=SJ.FixedRows+1;
				SGTLC(SJ);
			end else begin
				FQ[O].Open('SELECT * FROM '+IVN+' WHERE ROWID=1');
				CULM:='id';
				if (SView=ViCheck) then CULM:='0 AS CHK,id';
				SJ.RowCount:=SJ.FixedRows+RE;
				for I:=SJ.FixedCols to SJ.Colcount-1 do begin
					CUL:=SJ.Cols[I].Outr.Cinfo.CUL;
					Kn:=SJ.Cols[I].Outr.Cinfo.Kn;
					DFT:=SJ.Cols[I].Outr.Cinfo.DFT;
					if FQ[O].Table.Columns.ContainsName(CUL) then begin
						CULM:=CULM+','+CUL;
						T:=FQ[O].Table.Columns.IndexOfName(CUL);
						SJ.Cols[I].Outr.Cinfo.WCH1:=StrToBoolDef(FQ[O].Fields[T].AsString,False);
					end else begin
						CULM:=CULM+','+DFT+' AS '+CUL;
						if (Kn in [1,2,3,4,5,6,7]) then SS.Add(I.ToString);
					end;
				end;
				// AA:=TSQLiteDatabase(CN[2].ConnectionIntf.CliObj).OnProgress; TEMPORARY
				// NumInput[1]:=0;
				// TSQLiteDatabase(CN[2].ConnectionIntf.CliObj).ProgressNOpers:=100;
				// TSQLiteDatabase(CN[2].ConnectionIntf.CliObj).OnProgress:=AMDF.CNPRO;
				D2:=TNow;
				SHM:='';
				SHM:=SHM+'ATTACH "'+Md[O]+'" AS "AD";';
				SHM:=SHM+'DROP TABLE IF EXISTS '+TBL+';';
				SHM:=SHM+'CREATE TEMPORARY TABLE IF NOT EXISTS '+TBL+' AS SELECT '+CULM+' FROM AD.'+IVN+' WHERE AD.'+IVN+
					'.ROWID>1;';
				SHM:=SHM+'UPDATE '+TBL+' SET id=ROWID;';
				SHM:=SHM+'DETACH "AD";';
				CN[2].ExecSQL(SHM);
				SHM:='';
				if (SS.Count>0) then
					for T:=0 to SS.Count-1 do begin
						I:=SS[T].Tointeger;
						Ccl:=SJ.Cols[I].Outr.Cinfo.Ccl;
						Cmh:=SJ.Cols[I].Outr.Cinfo.Cmh;
						EQ:=SJ.Cols[I].Outr.Cinfo.EQ;
						WCH:=SJ.Cols[I].Outr.Cinfo.WCH;
						WCH1:=SJ.Cols[I].Outr.Cinfo.WCH1;
						Kn:=SJ.Cols[I].Outr.Cinfo.Kn;
						Ki:=SJ.Cols[I].Outr.Cinfo.Ki;
						CUL:=SJ.Cols[I].Outr.Cinfo.CUL;
						AUT:=SJ.Cols[I].Outr.Cinfo.AUT;
						if (Ccl='LAN') then Ccl:=Lan;
						if (SFR1(41)='0')or(Kn=1)or(Ki=0) then begin
							if (Kn=1) then
									SHM:=SHM+'UPDATE '+TBL+' SET '+CUL+' = (SELECT '+Ccl+' FROM NIT WHERE NIT.CODE'+' = '+TBL+'.CODE);';
							if (Kn=2)and AUT then
									SHM:=SHM+'UPDATE '+TBL+' SET '+CUL+'=(SELECT CASE WHEN ((EE=0 OR EE="" OR EE=NULL)OR AT=0)THEN '+TBL+
									'.'+CUL+' ELSE EE END AS WW FROM(SELECT '+CUL+' AS EE,AUT AS AT FROM NIT WHERE '+'NIT.CODE='+TBL+
									'.CODE));';
							if (Kn in [3,4])and AUT then begin
								if not WCH and WCH1 then TMP:='(SELECT '+Ccl+' FROM '+Cmh+' WHERE '+Cmh+'.ROWID=EE)'
								else TMP:='EE';
								SHM:=SHM+'UPDATE '+TBL+' SET '+CUL+'=(SELECT CASE WHEN ((EE=0 OR EE="" OR EE=NULL)OR AT=0)THEN '+TBL+'.'
									+CUL+' ELSE '+TMP+' END AS WW FROM(SELECT '+CUL+' AS EE,AUT AS AT FROM NIT WHERE NIT.CODE='+TBL+
									'.CODE));';
							end;
							if (Kn=5)and AUT then
									SHM:=SHM+'UPDATE '+TBL+' SET '+CUL+'=(SELECT CASE WHEN ((EE=0 OR EE="" OR EE=NULL)OR AT=0)THEN '+TBL+
									'.'+CUL+' ELSE EE END AS WW FROM(SELECT '+Ccl+' AS EE,AUT AS AT FROM NIT WHERE '+'NIT.CODE='+TBL+
									'.CODE));';

							if (Kn=6)and AUT then SHM:=SHM+'UPDATE '+TBL+' SET '+CUL+' = '+EQ+';';
							if (Kn=7) then SHM:=SHM+'UPDATE '+TBL+' SET '+CUL+' = '+DTtoN(DateTimeToStr(Now)).ToString+';';
						end;
					end;
				if (SHM<>'') then CN[2].ExecSQL(SHM);
				// TSQLiteDatabase(CN[2].ConnectionIntf.CliObj).OnProgress:=AA;
				{ FR:=TProS.Create(Self,SFL1(23),SFL1(82),SFL1(86)+'   %d%%',1,1);
					for I:=SJ.FixedCols to SJ.Colcount-1 do begin
					CUL:=SJ.Cols[I].Outr.Cinfo.CUL;
					Kn:=SJ.Cols[I].Outr.Cinfo.Kn;
					Ccl:=SJ.Cols[I].Outr.Cinfo.Ccl;
					WCH:=SJ.Cols[I].Outr.Cinfo.WCH;
					Ki:=SJ.Cols[I].Outr.Cinfo.Ki;

					if FR.ProR(I,SJ.Colcount-1)then begin
					FR.Destroy;
					SJ.EnableOnChanges:=True;
					Exit;
					end;
					end; }
				// ShowMessage(Def(D1,TNow)+#13+' MILLISECONDS');
				SB[2].Panels[0].Text:=Def(D1,TNow)+' MILLISECONDS '+Def(D2,TNow);
				SJ.EnableAllOn:=True;
				SGTLC(SJ);
			end;
		end;
		SJ.Invalidate;
	except
		on E:Exception do begin
			Msg1(Self,SFL1(87)+' SGLOAD',SFL1(90),SFL1(111)+#13+E.ToString+#13+SHM,2,SFL1(3),1,'',Bu);
			if Assigned(FR) then FR.Destroy;
		end;
	end;
	SS.Free;
end;

procedure TSGA.SGOutLoad(ConnectionN:TFDConnection;Query:TFDQuery;FileName:string='');
var
	IVN,IFRM,Ref,Ccl,CULM,CUL,SHM,EQ,DFT,TMP,Cmh,MH:string;
	RE,PSS0,I,T,Kn,Ki,INV:Integer;
	WCH,WCH1,AUT:Boolean;
	FR:TProS;
	C1,C2:Extended;
	AA:TSQLiteDatabaseProgressEvent;
	D1,D2:Uint64;
	SS:TStringList;
begin
	FR:=nil;
	RE:=0;
	D1:=TNow;
	SS:=TStringList.Create;
	try
		INV:=ConnectionN.ExecSQLScalar('SELECT NUM FROM ATT LIMIT 1');
		IVN:=ConnectionN.ExecSQLScalar('SELECT TNM FROM ATT LIMIT 1');
		MH:=ConnectionN.ExecSQLScalar('SELECT MH FROM ATT LIMIT 1');
		if not(INV>Rtc1(TRFC,TST))and(INV>0) then begin
			PSS0:=2;
			while (PSS0>1) do begin
				PSS0:=OutFilePass(AMDF,ConnectionN,MH,TST,INV.ToString);
				if (PSS0=0) then Exit;
			end;
			SJ.Options:=SJ.Options-[Goediting];
			BTN[2].Enabled:=True;
			BTN[3].Enabled:=True;
			BTN[4].Enabled:=False;
			BTN[5].Enabled:=False;
			BTN[6].Enabled:=True;
			BTN[7].Enabled:=True;
			BTN[8].Enabled:=False;
			BTN[9].Enabled:=False;
			BTN[10].Enabled:=True;
			DISE.readOnly:=True;
			Adde.readOnly:=True;
			SGClear;
			COMME.readOnly:=True;
			RE:=ConnectionN.ExecSQLScalar('SELECT COUNT(ROWID) FROM '+IVN);
			QTYE.Text:=IntToStr(ConnectionN.ExecSQLScalar('SELECT SUM(QTY) FROM '+IVN));
			{ Query.Open('SELECT COUNT(ROWID) FROM '+ATT+IVN);
				if (Query.RowsAffected>0) then RE:=Query.Fields[0].AsInteger-1;
				Query.Open('SELECT SUM(QTY) FROM '+ATT+IVN);
				if (Query.RowsAffected>0) then QTYE.Text:=Query.Fields[0].AsString; }

			Query.Open('SELECT FRM,COMM,SA,DS,DAT,SN,AD,CE,VT,IFRM,DAT1,PRC FROM '+MH+' WHERE ICODE = "'+INV.ToString+
				'" AND ST = "'+TST+'"');
			INUM.Caption:=INV.ToString;
			CCNA.ItemIndex:=CCNA.Items.Indexof(Sfcc1(Query.Fields[0].AsString));
			CCID.ItemIndex:=CCID.Items.Indexof(Query.Fields[0].AsString);
			TCC:=Query.Fields[0].AsString;
			COMME.Text:=Query.Fields[1].AsString;
			TOTE.Text:=Query.Fields[2].AsString;
			DISE.Text:=Query.Fields[3].AsString;
			Adde.Text:=Query.Fields[6].AsString;
			VATE.Text:=Query.Fields[8].AsString;
			PRC:=Query.Fields[11].AsInteger;
			TFR:=Query.Fields[9].AsString;
			NToDt(Query.Fields[4].AsString,C1,C2);
			DT[1].Date:=C1;
			TM[1].time:=C2;
			NToDt(Query.Fields[10].AsString,C1,C2);
			DT[2].Date:=C1;
			TM[2].time:=C2;
			TSN:=Query.Fields[5].AsString;
			SNNA.ItemIndex:=SNNA.Items.Indexof(SFSN1(TSN));
			CCE.ItemIndex:=CCE.Items.Indexof(SCCE1(Query.Fields[7].AsString));
			TCE:=Query.Fields[7].AsString;
			SGCINF(Query.Fields[0].AsString);
			if Charinset(TRFC[1],['3','4'])and(CCID.ItemIndex>-1) then
				if FRID.Enabled then begin
					IFRM:=IntToStr(ConnectionN.ExecSQLScalar('SELECT IFRM FROM '+MH+' LIMIT 1'));
					FRID.Clear;
					FRID.Itemsex.Additem(IFRM,-1,-1,-1,-1,nil);
				end;
			EditBtn.Caption:='';
			EditBtn.Hint:=EditBtn.Caption;
			SJ.EnableAllOn:=False;
			if (SFR1(41)='1') then SGColsRE(ConnectionN,Query,IVN);
			if (RE=0) then begin
				SJ.RowCount:=SJ.FixedRows+1;
				SGTLC(SJ);
			end else begin
				Query.Open('SELECT * FROM '+IVN+' WHERE ROWID=1');
				CULM:='id';
				if (SView=ViCheck) then CULM:='0 AS CHK,id';
				SJ.RowCount:=SJ.FixedRows+RE;
				for I:=SJ.FixedCols to SJ.Colcount-1 do begin
					CUL:=SJ.Cols[I].Outr.Cinfo.CUL;
					Kn:=SJ.Cols[I].Outr.Cinfo.Kn;
					DFT:=SJ.Cols[I].Outr.Cinfo.DFT;
					if Query.Table.Columns.ContainsName(CUL) then begin
						CULM:=CULM+','+CUL;
						T:=Query.Table.Columns.IndexOfName(CUL);
						SJ.Cols[I].Outr.Cinfo.WCH1:=StrToBoolDef(Query.Fields[T].AsString,False);
					end else begin
						CULM:=CULM+','+DFT+' AS '+CUL;
						if (Kn in [1,2,3,4,5,6,7]) then SS.Add(I.ToString);
					end;
				end;
				// AA:=TSQLiteDatabase(CN[2].ConnectionIntf.CliObj).OnProgress; TEMPORARY
				// NumInput[1]:=0;
				// TSQLiteDatabase(CN[2].ConnectionIntf.CliObj).ProgressNOpers:=100;
				// TSQLiteDatabase(CN[2].ConnectionIntf.CliObj).OnProgress:=AMDF.CNPRO;
				D2:=TNow;
				SHM:='';
				SHM:=SHM+'ATTACH "'+FileName+'" AS "AD";';
				SHM:=SHM+'DROP TABLE IF EXISTS '+TBL+';';
				SHM:=SHM+'CREATE TEMPORARY TABLE IF NOT EXISTS '+TBL+' AS SELECT '+CULM+' FROM AD.'+IVN+' WHERE AD.'+IVN+
					'.ROWID>1;';
				SHM:=SHM+'UPDATE '+TBL+' SET id=ROWID;';
				SHM:=SHM+'DETACH "AD";';
				CN[2].ExecSQL(SHM);
				SHM:='';
				if (SS.Count>0) then
					for T:=0 to SS.Count-1 do begin
						I:=SS[T].Tointeger;
						Ccl:=SJ.Cols[I].Outr.Cinfo.Ccl;
						Cmh:=SJ.Cols[I].Outr.Cinfo.Cmh;
						EQ:=SJ.Cols[I].Outr.Cinfo.EQ;
						WCH:=SJ.Cols[I].Outr.Cinfo.WCH;
						WCH1:=SJ.Cols[I].Outr.Cinfo.WCH1;
						Kn:=SJ.Cols[I].Outr.Cinfo.Kn;
						Ki:=SJ.Cols[I].Outr.Cinfo.Ki;
						CUL:=SJ.Cols[I].Outr.Cinfo.CUL;
						AUT:=SJ.Cols[I].Outr.Cinfo.AUT;
						if (Ccl='LAN') then Ccl:=Lan;
						if (SFR1(41)='0')or(Kn=1)or(Ki=0) then begin
							if (Kn=1) then
									SHM:=SHM+'UPDATE '+TBL+' SET '+CUL+' = (SELECT '+Ccl+' FROM NIT WHERE NIT.CODE'+' = '+TBL+'.CODE);';
							if (Kn=2)and AUT then
									SHM:=SHM+'UPDATE '+TBL+' SET '+CUL+'=(SELECT CASE WHEN ((EE=0 OR EE="" OR EE=NULL)OR AT=0)THEN '+TBL+
									'.'+CUL+' ELSE EE END AS WW FROM(SELECT '+CUL+' AS EE,AUT AS AT FROM NIT WHERE '+'NIT.CODE='+TBL+
									'.CODE));';
							if (Kn in [3,4])and AUT then begin
								if not WCH and WCH1 then TMP:='(SELECT '+Ccl+' FROM '+Cmh+' WHERE '+Cmh+'.ROWID=EE)'
								else TMP:='EE';
								SHM:=SHM+'UPDATE '+TBL+' SET '+CUL+'=(SELECT CASE WHEN ((EE=0 OR EE="" OR EE=NULL)OR AT=0)THEN '+TBL+'.'
									+CUL+' ELSE '+TMP+' END AS WW FROM(SELECT '+CUL+' AS EE,AUT AS AT FROM NIT WHERE NIT.CODE='+TBL+
									'.CODE));';
							end;
							if (Kn=5)and AUT then
									SHM:=SHM+'UPDATE '+TBL+' SET '+CUL+'=(SELECT CASE WHEN ((EE=0 OR EE="" OR EE=NULL)OR AT=0)THEN '+TBL+
									'.'+CUL+' ELSE EE END AS WW FROM(SELECT '+Ccl+' AS EE,AUT AS AT FROM NIT WHERE '+'NIT.CODE='+TBL+
									'.CODE));';

							if (Kn=6)and AUT then SHM:=SHM+'UPDATE '+TBL+' SET '+CUL+' = '+EQ+';';
							if (Kn=7) then SHM:=SHM+'UPDATE '+TBL+' SET '+CUL+' = '+DTtoN(DateTimeToStr(Now)).ToString+';';
						end;
					end;
				if (SHM<>'') then CN[2].ExecSQL(SHM);
				// TSQLiteDatabase(CN[2].ConnectionIntf.CliObj).OnProgress:=AA;
				{ FR:=TProS.Create(Self,SFL1(23),SFL1(82),SFL1(86)+'   %d%%',1,1);
					for I:=SJ.FixedCols to SJ.Colcount-1 do begin
					CUL:=SJ.Cols[I].Outr.Cinfo.CUL;
					Kn:=SJ.Cols[I].Outr.Cinfo.Kn;
					Ccl:=SJ.Cols[I].Outr.Cinfo.Ccl;
					WCH:=SJ.Cols[I].Outr.Cinfo.WCH;
					Ki:=SJ.Cols[I].Outr.Cinfo.Ki;

					if FR.ProR(I,SJ.Colcount-1)then begin
					FR.Destroy;
					SJ.EnableOnChanges:=True;
					Exit;
					end;
					end; }
				// ShowMessage(Def(D1,TNow)+#13+' MILLISECONDS');
				SB[2].Panels[0].Text:=Def(D1,TNow)+' MILLISECONDS '+Def(D2,TNow);
				SJ.EnableAllOn:=True;
				SGTLC(SJ);
			end;
		end;
		SJ.Invalidate;
	except
		on E:Exception do begin
			Msg1(Self,SFL1(87)+' SGOUTLOAD',SFL1(90),SFL1(111)+#13+E.ToString+#13+SHM,2,SFL1(3),1,'',Bu);
			if Assigned(FR) then FR.Destroy;
		end;
	end;
	SS.Free;
end;

procedure TSGA.SGAF(Copyfrom:Integer=0);
var
	ST1,IVN,Ivn1,Rfc1,INV,Cpt,S,Cmh,Ref,Ccl,Tt,TRM,CULM,CUL,ID,FRM,Cc1,It,PR,EQ,DFT,TMP,TM:string;
	TL,QT,AD,DS,TX,A5:Extended;
	O,U,PSS0,Ls1,RE,I,T,Kn,Ki,ID1,Rf,PRC1:Integer;
	WCH,WCH1,AUT,Wr:Boolean;
	FR:TProS;
begin
	FR:=nil;
	try
		TIPBox2.Create(Self,SFL1(Copyfrom+63),Rfc1,ST1,INV,Tt);
		Ls1:=Rtc1(Rfc1,ST1);
		O:=Dtn1(Rfc1);
		if (Ne(INV)=0)or(Ne(INV)>Ls1) then Exit;
		if (Ne(INV)<=Ls1)and(Ne(INV)>0) then begin
			IVN:=Dtk1(Rfc1)+ST1+'n'+INV;
			PSS0:=2;
			while (PSS0>1) do begin
				PSS0:=SPSS1(Self,Rfc1,ST1,INV);
				if (PSS0=0) then Exit;
			end;
			SJ.EnableAllOn:=False;
			if (Copyfrom=1) then begin
				Ivn1:=INUM.Caption;
				SGClear;
				INUM.Caption:=Ivn1;
				FQ[O].Open('SELECT FRM,SA,DS,COMM,SN,AD,CE,VT,IFRM FROM '+Dtm1(Rfc1)+' WHERE ICODE = "'+INV+
					'" AND ST = "'+ST1+'"');
				Cc1:=FQ[O].Fields[0].AsString;
				CCID.ItemIndex:=CCID.Items.Indexof(Cc1);
				TCC:=FQ[O].Fields[0].AsString;
				TOTE.Text:=FQ[O].Fields[1].AsString;
				COMME.Text:=FQ[O].Fields[3].AsString;
				DISE.Text:=FQ[O].Fields[2].AsString;
				Adde.Text:=FQ[O].Fields[5].AsString;
				VATE.Text:=FQ[O].Fields[7].AsString;
				CCNA.ItemIndex:=CCNA.Items.Indexof(Sfcc1(FQ[O].Fields[0].AsString));
				SNNA.ItemIndex:=SNNA.Items.Indexof(SFSN1(FQ[O].Fields[4].AsString));
				TSN:=FQ[O].Fields[4].AsString;
				CCE.ItemIndex:=CCE.Items.Indexof(SCCE1(FQ[O].Fields[6].AsString));
				TCE:=FQ[O].Fields[6].AsString;
				SGCINF(FQ[O].Fields[0].AsString);
				if Charinset(TRFC[1],['3','4'])and(CCID.ItemIndex>-1) then begin
					if ((TRFC='3')and(Rfc1='1'))or((TRFC='4')and(Rfc1='2')) then begin
						U:=Dtn1(Rfc1);
						if (CCID.ItemIndex>-1) then begin
							FQ[U].Open('SELECT ICODE FROM '+Dtm1(Rfc1)+' WHERE ST = "'+TST+'" AND FRM = "'+
								CCID.Items[CCID.ItemIndex]+'"');
							FRID.Clear;
							if (FQ[U].RowsAffected>0) then begin
								for I:=0 to FQ[U].RowsAffected-1 do begin
									FRID.Itemsex.Additem(FQ[U].Fields[0].AsString,-1,-1,-1,-1,nil);
									FQ[U].Next;
								end;
								FRID.ItemIndex:=FRID.Items.Indexof(INV);
								TFR:=INV;
							end;
						end;
					end;
				end;
			end else if Charinset(TRFC[1],['1','5']) then begin
				if (CCID.ItemIndex=-1) then begin
					CCNA.Sbo(Tti_error_large,SFL1(87),SFL1(38),CCNA.ClientRect,2);
					CCNA.Setfocus;
					Exit;
				end
				else Cc1:=CCID.Items[CCID.ItemIndex];
				PRC1:=CN[O].ExecSQLScalar('SELECT CASE WHEN PRC IS NOT NULL THEN PRC ELSE 0 END FROM '+'(SELECT PRC FROM '+
					Dtm1(Rfc1)+' WHERE ICODE = "'+INV+'" AND ST = "'+ST1+'")');
			end;
			FQ[O].Open('SELECT * FROM '+IVN+' WHERE ROWID=1');
			Cpt:=SFL1(63+Copyfrom)+' : '+Dtl1(Rfc1)+' '+SFL1(25)+' [ '+INV+' ] ';
			if (Trim(SJ.Cells[ITCLL,SJ.RowCount-1])='')and(SJ.FixedRows=SJ.RowCount-1) then CN[2].ExecSQL('DELETE FROM '+TBL);
			CULM:='ID';
			for I:=SJ.FixedCols to SJ.Colcount-1 do begin
				CUL:=SJ.Cols[I].Outr.Cinfo.CUL;
				DFT:=SJ.Cols[I].Outr.Cinfo.DFT;
				if FQ[O].Table.Columns.ContainsName(CUL) then begin
					CULM:=CULM+','+CUL;
					T:=FQ[O].Table.Columns.IndexOfName(CUL);
					SJ.Cols[I].Outr.Cinfo.WCH1:=StrToBoolDef(FQ[O].Fields[T].AsString,False);
				end
				else CULM:=CULM+','+DFT+' AS '+CUL;
			end;
			ID1:=CN[2].ExecSQLScalar('SELECT COUNT(ROWID) FROM '+TBL);
			ID:=TBL+'.ROWID > '+ID1.ToString;
			if (Tt<>'') then TRM:=' WHERE AmzPD.'+IVN+'.ID IN ('+Tt+');'
			else TRM:=' WHERE AmzPD.'+IVN+'.ROWID > 1;';
			TMP:='';
			TMP:=TMP+'ATTACH "'+Md[O]+'" AS "AmzPD";'; // TEMPORARY
			TMP:=TMP+'CREATE TEMPORARY TABLE '+TBL+'_AA AS SELECT ID,'+Culs+' FROM '+TBL+' UNION ALL SELECT '+CULM+
				' FROM AmzPD.'+IVN+TRM;
			TMP:=TMP+'UPDATE '+TBL+'_AA SET id=ROWID;';
			TMP:=TMP+'DROP TABLE IF EXISTS '+TBL+';';
			TMP:=TMP+'ALTER TABLE '+TBL+'_AA RENAME TO '+TBL+';';
			TMP:=TMP+'DETACH "AmzPD";';
			CN[2].ExecSQL(TMP);
			TMP:='';
			RE:=CN[2].ExecSQLScalar('SELECT COUNT(ROWID) FROM '+TBL)-ID1;
			if (RE>0) then begin
				SJ.RowCount:=SJ.FixedRows+ID1+RE;
				SGTLC(SJ);
				S:=Culs;
				S:=Stringreplace(S,',','="",',[Rfreplaceall])+'=""';
				CN[2].ExecSQL('UPDATE '+TBL+' SET '+S+' WHERE (CODE NOT IN (SELECT CODE FROM NIT WHERE '+'NIT.CODE='+TBL+
					'.CODE) OR CODE IS NULL) AND '+ID);
				if not Charinset(TRFC[1],['3','4'])and ContainsStr(Culs,'PR')and not(PRC=0) then begin
					if (Copyfrom=0) then begin
						Rf:=Sfm2(3);
						if (Rf=0)and(PRC<>PRC1) then begin
							Rf:=Msg1(Self,SFL1(87),SFL1(92),Sfm1(3),4,SFL1(5)+'|'+SFL1(6),2,SFL1(136),Wr);
							if Wr then Itm1(3,Rf);
						end;
					end;
					if Rf=1 then
						if Charinset(TRFC[1],['1','5']) then begin
							FRM:='';
							if (PRC=1) then FRM:='(SELECT PR FROM NIT WHERE NIT.CODE = '+TBL+'.CODE AND NIT.PR <> 0)';
							if (PRC=2) then begin
								FQ[2].Open('SELECT DISTINCT CODE FROM '+TBL+' WHERE NOT CODE="" AND CODE NOT NULL');
								if (FQ[2].RowsAffected>0) then begin
									for I:=1 to FQ[2].RowsAffected do begin
										It:=FQ[2].Fields[0].AsString;
										PR:=CN[8].ExecSQLScalar('SELECT PR FROM T'+It+' WHERE ST = "'+TST+'" AND FRM = "'+Cc1+
											'" AND RIF = "1" ORDER BY ICODE DESC LIMIT 1');
										FRM:=FRM+'UPDATE '+TBL+' SET PR = "'+PR+'" WHERE CODE = "'+It+'" AND '+ID+';';
										FQ[2].Next;
									end;
									CN[2].ExecSQL(FRM);
									FRM:='';
								end;
							end;
							if (PRC=3) then FRM:='(SELECT (CO+(CO*PC*0.01)) FROM NIT WHERE NIT.CODE = '+TBL+'.CODE AND CO <> 0)';
							if (PRC=4) then
									FRM:='(SELECT PR FROM NITQY WHERE NITQY.CODE = '+TBL+'.CODE AND '+TBL+
									'.QTY BETWEEN QY1 AND QY2 ORDER BY ROWID DESC)';
							if (PRC=5) then
									FRM:='(SELECT PR FROM NITCU WHERE NITCU.CODE = '+TBL+'.CODE AND FRM = "'+Cc1+'" ORDER BY ROWID DESC)';
							if (PRC=6) then
									FRM:='(SELECT PR FROM NITCUQY WHERE NITCUQY.CODE = '+TBL+'.CODE AND FRM = "'+Cc1+'" AND '+TBL+
									'.QTY BETWEEN QY1 AND QY2 ORDER BY ROWID DESC)';
							if not(PRC=2) then CN[2].ExecSQL('UPDATE '+TBL+' SET PR = '+FRM+' WHERE '+ID);
						end else if Charinset(TRFC[1],['2','6']) then begin
							FRM:='';
							if (PRC=1) then begin
								FRM:='(SELECT CO FROM NIT WHERE NIT.CODE = '+TBL+'.CODE AND NIT.CO <> 0)';
								CN[2].ExecSQL('UPDATE '+TBL+' SET PR = '+FRM+' WHERE '+ID);
							end;
							if (PRC=2) then begin
								FQ[2].Open('SELECT DISTINCT CODE FROM '+TBL+' WHERE CODE<>"" AND CODE NOT NULL');
								if (FQ[2].RowsAffected>0) then begin
									for I:=1 to FQ[2].RowsAffected do begin
										It:=FQ[2].Fields[0].AsString;
										PR:=CN[8].ExecSQLScalar('SELECT PR FROM T'+It+' WHERE ST = "'+TST+'" AND FRM = "'+Cc1+
											'" AND RIF IN (0,2) ORDER BY ICODE DESC LIMIT 1');
										FRM:=FRM+'UPDATE '+TBL+' SET PR="'+PR+'" WHERE CODE="'+It+'" AND '+ID+';';
										FQ[2].Next;
									end;
									CN[2].ExecSQL(FRM);
									FRM:='';
								end;
							end;
						end;
				end;
				for I:=SJ.FixedCols to SJ.Colcount-1 do begin
					Cmh:=SJ.Cols[I].Outr.Cinfo.Cmh;
					Ccl:=SJ.Cols[I].Outr.Cinfo.Ccl;
					EQ:=SJ.Cols[I].Outr.Cinfo.EQ;
					WCH:=SJ.Cols[I].Outr.Cinfo.WCH;
					WCH1:=SJ.Cols[I].Outr.Cinfo.WCH1;
					Kn:=SJ.Cols[I].Outr.Cinfo.Kn;
					AUT:=SJ.Cols[I].Outr.Cinfo.AUT;
					CUL:=SJ.Cols[I].Outr.Cinfo.CUL;
					if (Ccl='LAN') then Ccl:=Lan;
					if (Kn=1) then
							TMP:=TMP+'UPDATE '+TBL+' SET '+CUL+' = (SELECT '+Ccl+' FROM NIT WHERE NIT.CODE = '+TBL+'.CODE);';
					if (Kn=2)and AUT then
							TMP:=TMP+'UPDATE '+TBL+' SET '+CUL+'=(SELECT CASE WHEN ((EE=0 OR EE="" OR EE=NULL)OR AT=0)THEN '+TBL+'.'+
							CUL+' ELSE EE END AS WW FROM(SELECT '+CUL+' AS EE,AUT AS AT FROM NIT WHERE NIT.CODE='+TBL+
							'.CODE)) WHERE '+ID+';';
					if (Kn in [3,4])and AUT then begin
						if (not WCH and WCH1) then TM:='(SELECT '+Ccl+' FROM '+Cmh+' WHERE '+Cmh+'.ROWID=EE)'
						else TM:='EE';
						TMP:=TMP+'UPDATE '+TBL+' SET '+CUL+'=(SELECT CASE WHEN ((EE=0 OR EE="" OR EE=NULL)OR AT=0)THEN '+TBL+'.'+CUL
							+' ELSE '+TM+' END AS WW FROM(SELECT '+CUL+' AS EE,AUT AS AT FROM NIT WHERE NIT.CODE='+TBL+
							'.CODE)) WHERE '+ID+';';
					end;
					if (Kn=5)and AUT then
							TMP:=TMP+'UPDATE '+TBL+' SET '+CUL+'=(SELECT CASE WHEN ((EE=0 OR EE="" OR EE=NULL)OR'+' AT=0)THEN '+TBL+
							'.'+CUL+' ELSE EE END AS WW FROM(SELECT '+Ccl+' AS EE,AUT AS AT'+' FROM NIT WHERE NIT.CODE='+TBL+
							'.CODE)) WHERE '+ID+';';
					if (Kn=6)and AUT then TMP:=TMP+'UPDATE '+TBL+' SET '+CUL+' = '+EQ+' WHERE '+ID+';';
					if (Kn=7) then TMP:=TMP+'UPDATE '+TBL+' SET '+CUL+' = '+DTtoN(DateTimeToStr(Now)).ToString+' WHERE '+ID+';';
				end;
				if (TMP<>'') then CN[2].ExecSQL(TMP);
				QTYE.Text:=string(CN[2].ExecSQLScalar('SELECT SUM(QTY) FROM '+TBL));
				TOTE.Text:=string(CN[2].ExecSQLScalar('SELECT SUM(QTY*PR) FROM '+TBL));
			end
			else Msg1(Self,SFL1(Copyfrom+63),SFL1(91),'',3,SFL1(3),1,'',Bu);
			Refresh;
		end else begin
			Msg1(Self,SFL1(Copyfrom+63),SFL1(90),SFL1(37)+' '+SFL1(89)+' ( 1 - '+Ls1.ToString+' )',2,SFL1(3),1,'',Bu);
		end;
		Refresh;
	except
		on E:Exception do begin
			Msg1(Self,SFL1(Copyfrom+63),SFL1(90),SFL1(111)+#13+E.Message+#13+I.ToString+#13+CUL+#13+Kn.ToString+#13+Ccl
				// +FQ[O].SQL.TEXT
				,1,SFL1(3),2,'',Bu);
			if (FR<>nil) then FR.Destroy;
		end;
	end;
	SJ.EnableAllOn:=True;
	SJ.Refresh;
end;

function TSGA.SGChk:Boolean;
var
	D1,D2:Uint64;
	O,C,I,T,Kn,Ki,Ro,Mx,Rf,PRC1:Integer;
	INV,Sn,Cc1,CUL,ID,FD,Cd,Wrg,IVN,PR,Pr1,Qs,IFR,Ifm,FRM,Cmh,Ccl,Cclt,Ref,ID1,TRM,Trmc,S,RFC,Iv2,CCE1,Cce2,SNF,Lg,Moth,
		V1,V2,TMP:string;
	FR:TProS;
	Wr,WCH,Isfrm:Boolean;
begin
	Result:=False;
	FR:=nil;
	SBO1;
	try
		SJ.EnableAllOn:=False;
		TMP:='';

		TMP:='SELECT COUNT(*)FROM(SELECT CODE FROM '+TBL+' WHERE CODE NOT NULL AND CODE<>"" LIMIT 1)';
		if (CN[2].ExecSQLScalar(TMP)=0) then begin
			SJ.Sbo(Tti_error_large,SFL1(87),SFL1(91),SJ.ClientRect,2);
			SJ.Setfocus;
			Exit;
		end;
		TMP:='';
		O:=Dtn1(TRFC);
		Isfrm:=False;
		D1:=DTtoN(Datetostr(DT[1].Date)+' '+TIMETOSTR(TM[1].time));
		D2:=DTtoN(Datetostr(DT[2].Date)+' '+TIMETOSTR(TM[2].time));
		if (D1>D2) then begin
			DT[2].Sbo(Tti_error_large,SFL1(87),SFL1(132),DT[2].ClientRect,2);
			Exit;
		end;
		if (INUM.Caption='') then begin
			INUM.Sbo(Tti_error_large,SFL1(87),SFL1(37),INUM.ClientRect,2);
			Exit;
		end
		else INV:=INUM.Caption;
		if (CCID.ItemIndex=-1)or(TCC='') then begin
			CCNA.Sbo(Tti_error_large,SFL1(87),SFL1(38),CCNA.ClientRect,2);
			CCNA.Setfocus;
			Exit;
		end
		else Cc1:=CCID.Items[CCID.ItemIndex];
		if (CCNA.ItemIndex=-1) then CCNA.ItemIndex:=CCNA.Items.Indexof(Sfcc1(Cc1));
		if (STNA.ItemIndex=-1) then STNA.ItemIndex:=STNA.Items.Indexof(Sfst1(TST));
		if not ContainsStr(Culs,'NSN') then
			if (SNNA.ItemIndex=-1)or(TSN='') then begin
				SNNA.Sbo(Tti_error_large,SFL1(87),SFL1(39),SNNA.ClientRect,2);
				SNNA.Setfocus;
				Exit;
			end else begin
				Sn:=Sfsn2(SNNA.Items[SNNA.ItemIndex]);
				SNF:=SNNA.Items[SNNA.ItemIndex];
			end;
		if FRID.Enabled and Charinset(TRFC[1],['3','4']) then
			if not ContainsStr(Culs,'IFRM') then
				if (FRID.ItemIndex=-1) then begin
					FRID.Sbo(Tti_error_large,SFL1(87),SFL1(45),FRID.ClientRect,2);
					FRID.Setfocus;
					Exit;
				end else begin
					IFR:=FRID.Items[FRID.ItemIndex];
					FRM:='SELECT id FROM C'+Cc1+' WHERE ICODE="'+IFR+'" AND ST="'+TST;
					case O of
						3:FRM:=FRM+'" AND RIF="1"';
						4:FRM:=FRM+'" AND RIF="2"';
					end;
					if (CN[5].ExecSQLScalar(FRM)>0) then Isfrm:=True
					else begin
						Wrg:=Format(SFL1(108),[INV,CCNA.Items[CCNA.ItemIndex]]);
						FRID.Sbo(Tti_error_large,SFL1(87),Wrg,FRID.ClientRect,2);
						FRID.Setfocus;
						Exit;
					end;
				end;

		C:=0;
		S:='';
		Cd:='';
		FRM:='';
		TRM:='';
		ID1:='';
		if Assigned(SGAW) then SGAW.Free;
		if (CCE.ItemIndex>-1) then CCE1:=CCE.Items[CCE.ItemIndex]
		else CCE1:='';
		Moth:=Dtd1(TRFC);
		// is new
		if not Charinset(TRFC[1],['3','4']) then begin
			if IsTew then Rf:=1
			else begin
				Rf:=Sfm2(2);
				PRC1:=PRPolicy(TRFC);
				if (Rf=0)and(PRC<>PRC1) then begin
					Rf:=Msg1(Self,SFL1(87),SFL1(92),Sfm1(2),4,SFL1(5)+'|'+SFL1(6),2,SFL1(136),Wr);
					if Wr then Itm1(2,Rf);
				end;
				if (Rf=1) then PRC:=PRC1;
			end;
		end;
		FR:=TProS.Create(Self,SFL1(23),SFL1(87),SFL1(86)+'   %d%%',1,3,3,2);
		for I:=SJ.FixedCols to SJ.Colcount-1 do begin
			CUL:=SJ.Cols[I].Outr.Cinfo.CUL;
			TMP:=TMP+'UPDATE '+TBL+' SET '+CUL+' = "" WHERE '+CUL+' IS NULL;';
			FR.ProR(I,SJ.Colcount-1,C);
		end;
		CN[2].ExecSQL(TMP);
		TMP:='';
		/// CODE VALIDITY ;
		ID:='0';
		FD:=TBL+'.ROWID NOT IN ';
		case TRFC.Tointeger of
			3:begin
					V1:=' AND NOT ICODE="'+INV+'" ';
					V2:=' ';
				end;
			4:begin
					V1:=' ';
					V2:=' AND NOT ICODE="'+INV+'" ';
				end;
		end;
		if ContainsStr(Culs,'CODE')and(SJ.Cols[ITCLL].Outr.Cinfo.WCH) then begin
			TMP:='INSERT INTO '+ERR+' (CEL,CL,RO,WRG) SELECT "'+SJ.Cols[ITCLL].Outr.Cinfo.Lg+'",'+ITCLL.ToString+',RD+'+
				(SJ.FixedRows-1).ToString+',printf('''+SFL1(113)+''',CD)'+' FROM (SELECT ROWID AS RD,CODE AS CD FROM '+TBL+
				' WHERE CODE NOT IN (SELECT CODE FROM NIT WHERE NIT.CODE='+TBL+'.CODE) AND '+TBL+'.CODE <> "");';
			TMP:=TMP+'SELECT group_concat(CD) FROM(SELECT RO- '+(SJ.FixedRows-1).ToString+' AS CD FROM '+ERR+
				' UNION ALL SELECT ROWID AS CD FROM '+TBL+' WHERE CODE="" ORDER BY ROWID ASC) LIMIT 1;';
			ID:=string(CN[2].ExecSQLScalar(TMP));
			TMP:='';
			{ FQ[2].Open('SELECT ROWID,CODE FROM '+TBL+' WHERE CODE="" OR CODE NOT IN '+
				'(SELECT CODE FROM NIT WHERE NIT.CODE='+TBL+'.CODE AND '+TBL+'.CODE <> "")');
				Mx:=FQ[2].RowsAffected;
				if(Mx>0)then
				for I:=1 to Mx do begin
				ID:=ID+','+FQ[2].Fields[0].AsString;
				Ro:=FQ[2].Fields[0].AsInteger+SJ.FixedRows-1;
				if not(FQ[2].Fields[1].AsString='')then begin
				Wrg:=Format(SFL1(113),[SJ.Cells[ITCLL,Ro]]);
				//Fillwr(C,ITCLL,Ro,Ml[0],Ml[1],Ml[2],Ml[3],Ml[4],SJ.Cells[ITCLL,0],Wrg,SJ);
				end;
				FQ[2].Next;
				FR.ProR1(I,Mx,1,C);
				end; }
		end;
		/// IFROM VALIDITY ;
		if Charinset(TRFC[1],['3','4']) then begin
			case O of
				3:RFC:='1';
				4:RFC:='2';
			end;
			if ContainsStr(Culs,'IFRM') then begin
				if Isfrm then CN[2].ExecSQL('UPDATE '+TBL+' SET IFRM = "'+IFR+'" WHERE IFRM="" AND '+FD+'('+ID+')');
				CN[2].ExecSQL('ATTACH "'+Md[5]+'" AS "AmzPD5"');
				FRM:='SELECT DISTINCT ICODE AS IC FROM C'+Cc1+' WHERE ST="'+TST+'" AND RIF="'+RFC+'"';
				FRM:='('+FRM+')';
				if (CN[5].ExecSQLScalar('SELECT COUNT(IC) FROM '+FRM)>0) then begin
					FQ[2].Open('SELECT ROWID,IFRM FROM '+TBL+' WHERE IFRM="" OR IFRM NOT IN '+FRM+' AND '+FD+'('+ID+')');
					Mx:=FQ[2].RowsAffected;
					if (Mx>0) then
						for I:=1 to Mx do begin
							ID:=ID+','+FQ[2].Fields[0].AsString;
							Ro:=FQ[2].Fields[0].AsInteger+SJ.FixedRows-1;
							if (FQ[2].Fields[1].AsString='') then Wrg:=Format(SFL1(113),[SJ.Cells[FRMCLL,Ro]])
							else Wrg:=Format(SFL1(108),[SJ.Cells[FRMCLL,Ro],CCNA.Items[CCNA.ItemIndex]]);
							// Fillwr(C,FRMCLL,Ro,Ml[0],Ml[1],Ml[2],Ml[3],Ml[4],SJ.Cells[FRMCLL,0],Wrg,SJ);
							FQ[2].Next;
							FR.ProR1(I,Mx,1,C);
						end;
				end else begin
					Wrg:=Format(SFL1(93),[CCNA.Items[CCNA.ItemIndex]]);
					// Fillwr(C,FRMCLL,Ro,Ml[0],Ml[1],Ml[2],Ml[3],Ml[4],SJ.Cells[FRMCLL,0],Wrg,SJ);
				end;
				CN[2].ExecSQL('DETACH "AmzPD5"');
			end;
		end;
		/// PRICE VALIDITY ;
		if ContainsStr(Culs,'PR')and(SJ.Cols[PRCLL].Outr.Cinfo.WCH) then begin
			CN[2].ExecSQL('UPDATE '+TBL+' SET PR = "0" WHERE (PR*1=0) AND '+FD+'('+ID+')');
			if not Charinset(TRFC[1],['3','4'])and(Rf=1)and not(PRC=0) then begin
				// CN[2].ExecSQL('ATTACH "'+Md[8]+'" AS "AmzPD8"');
				if Charinset(TRFC[1],['1','5']) then begin
					if (PRC=1) then FRM:='(SELECT PR FROM NIT WHERE NIT.CODE='+TBL+'.CODE AND NIT.PR <> 0)';
					if (PRC=2) then
							FRM:='(SELECT PR FROM T00000 WHERE ST="'+TST+'" AND FRM = "'+Cc1+
							'" AND RIF = "1" ORDER BY ICODE DESC LIMIT 1)';
					if (PRC=3) then
							FRM:='(SELECT (CO+(CO*PC*0.01)) FROM NIT WHERE NIT.CODE = '+TBL+'.CODE AND CO <> 0 AND PC <> 0)';
					if (PRC=4) then
							FRM:='(SELECT PR FROM NITQY WHERE NITQY.CODE = '+TBL+'.CODE AND '+TBL+
							'.QTY BETWEEN QY1 AND QY2 ORDER BY ROWID DESC)';
					if (PRC=5) then
							FRM:='(SELECT PR FROM NITCU WHERE NITCU.CODE = '+TBL+'.CODE AND FRM = "'+Cc1+'" ORDER BY ROWID DESC)';
					if (PRC=6) then
							FRM:='(SELECT PR FROM NITCUQY WHERE NITCUQY.CODE = '+TBL+'.CODE AND FRM = "'+Cc1+'" AND '+TBL+
							'.QTY BETWEEN QY1 AND QY2 ORDER BY ROWID DESC)';
					CN[2].ExecSQL('UPDATE '+TBL+' SET PR = '+FRM+' WHERE '+FRM+' NOT NULL AND '+FD+'('+ID+')');
				end else if Charinset(TRFC[1],['2','6']) then begin
					if (PRC=1) then FRM:='(SELECT CO FROM NIT WHERE NIT.CODE = '+TBL+'.CODE AND NIT.CO <> 0)';
					if (PRC=2) then
							FRM:='(SELECT PR FROM T00000 WHERE ST="'+TST+'" AND FRM = "'+Cc1+
							'" AND (RIF = "2" OR RIF = "0") ORDER BY ICODE DESC LIMIT 1)';
					CN[2].ExecSQL('UPDATE '+TBL+' SET PR = '+FRM+' WHERE '+FRM+' NOT NULL AND '+FD+'('+ID+')');
				end;
				// CN[2].ExecSQL('DETACH "AmzPD8"');
			end;
			if Charinset(TRFC[1],['3','4']) then begin
				if ContainsStr(Culs,'IFRM') then begin
					CN[8].ExecSQL('ATTACH "'+Md[2]+'" AS "AmzPD2"');
					FRM:='SELECT ROWID,CASE WHEN '+TBL+'.CODE THEN (SELECT NIT.'+Lan+' FROM NIT WHERE NIT.CODE='+TBL+
						'.CODE) ELSE "" END AS ITLN,IFRM FROM '+TBL+' WHERE CODE IN (SELECT CD FROM (SELECT CD,CASE WHEN '+
						'(SELECT ROWID FROM T00000 WHERE RIF="'+RFC+'" AND ST="'+TST+'" AND FRM="'+Cc1+
						'" AND IFRM=FR AND CODE=CD LIMIT 1)>0 THEN 1 ELSE 0 END AS CODE_EXIST'+
						' FROM (SELECT SUM(QTY) AS QS,PR AS PS,CODE AS CD,IFRM AS FR FROM '+TBL+' GROUP BY PR,IFRM,CODE HAVING '+FD+
						'('+ID+') ORDER BY CODE ASC)) WHERE CODE_EXIST=0)';
					FQ[8].Open(FRM);
					Mx:=FQ[8].RowsAffected;
					if (Mx>0) then
						for I:=1 to Mx do begin
							// ID:=ID+','+FQ[2].Fields[0].AsString;
							Ro:=FQ[8].Fields[0].AsInteger+SJ.FixedRows-1;
							Wrg:=Format(SFL1(101),[FQ[8].Fields[1].AsString,FQ[8].Fields[2].AsString,CCNA.Items[CCNA.ItemIndex]]);
							// Fillwr(C,ITCLL,Ro,Ml[0],Ml[1],Ml[2],Ml[3],Ml[4],SJ.Cells[ITCLL,0],Wrg,SJ);
							FQ[8].Next;
							FR.ProR1(I,Mx,1,C);
						end;
					FRM:='SELECT ROWID,PR,IFRM FROM '+TBL+' WHERE PR IN (SELECT PS FROM(SELECT PS,CASE WHEN '+
						'(SELECT ROWID FROM T00000 WHERE RIF="'+RFC+'" AND ST="'+TST+'" AND FRM="'+Cc1+
						'" AND IFRM=FR AND CODE=CD AND PR=PS LIMIT 1)>0 THEN 1 ELSE 0 END AS PR_EXIST,CASE WHEN'+
						' (SELECT ROWID FROM T00000 WHERE RIF="'+RFC+'" AND ST="'+TST+'" AND FRM="'+Cc1+'" AND IFRM=FR AND '+
						'CODE=CD LIMIT 1)>0 THEN 1 ELSE 0 END AS CODE_EXIST '+'FROM (SELECT PR AS PS,IFRM AS FR,CODE AS CD FROM '+
						TBL+' GROUP BY PR,IFRM,CODE '+'HAVING '+FD+'('+ID+
						') ORDER BY CODE ASC)) WHERE PR_EXIST=0 AND CODE_EXIST=1 AND PS<>"0")';
					FQ[8].Open(FRM);
					Mx:=FQ[8].RowsAffected;
					if (Mx>0) then
						for I:=1 to Mx do begin
							// ID:=ID+','+FQ[2].Fields[0].AsString;
							Ro:=FQ[8].Fields[0].AsInteger+SJ.FixedRows-1;
							Wrg:=Format(SFL1(109),[FQ[8].Fields[1].AsString,FQ[8].Fields[2].AsString,CCNA.Items[CCNA.ItemIndex]]);
							// Fillwr(C,PRCLL,Ro,Ml[0],Ml[1],Ml[2],Ml[3],Ml[4],SJ.Cells[PRCLL,0],Wrg,SJ);
							FQ[8].Next;
							FR.ProR1(I,Mx,1,C);
						end;
					FRM:='SELECT DI,ITLN,FR,QS,TQS FROM '+
						'(SELECT DI,CODE_EXIST,ITLN,PR_EXIST,PS,CASE WHEN TQS<QS THEN 0 ELSE 1 END AS WRN,QS,TQS,'+
						'FR,CD FROM (SELECT DI,QS,PS,FR,CD,CASE WHEN (SELECT ROWID FROM T00000 WHERE RIF="'+RFC+'" AND ST="'+TST+
						'" AND FRM="'+Cc1+'" AND IFRM=FR '+'AND CODE=CD LIMIT 1)>0 THEN 1 ELSE 0 END AS CODE_EXIST,'+
						'CASE WHEN (SELECT ROWID FROM T00000 WHERE RIF="'+RFC+'" AND ST="'+TST+'" AND FRM="'+Cc1+
						'" AND CODE=CD AND PR=PS LIMIT 1)>0 THEN 1 ELSE 0 END AS PR_EXIST,'+
						'(SELECT SUM(QTY) FROM T00000 WHERE RIF="'+RFC+'" AND ST="'+TST+'" AND FRM="'+Cc1+
						'" AND IFRM=FR AND PR=PS)-(SELECT SUM(QTY) FROM T00000 WHERE RIF="'+TRFC+'" AND ST="'+TST+'" AND FRM="'+Cc1+
						'" AND IFRM=FR AND NOT ICODE="'+INV+'" AND PR=PS) '+'AS TQS,CASE WHEN CD THEN (SELECT NIT.'+Lan+
						' FROM NIT WHERE NIT.CODE=CD) ELSE "" END AS ITLN'+
						' FROM (SELECT SUM(QTY) AS QS,PR AS PS,CODE AS CD,IFRM AS FR,ROWID AS DI FROM '+TBL+
						' GROUP BY PR,IFRM,CODE,ID HAVING '+FD+'('+ID+')'+
						' ORDER BY CODE ASC)) WHERE PR_EXIST=1 AND CODE_EXIST=1 AND WRN=0)';
					FQ[8].Open(FRM);
					Mx:=FQ[8].RowsAffected;
					if (Mx>0) then
						for I:=1 to Mx do begin
							// ID:=ID+','+FQ[2].Fields[0].AsString;
							Ro:=FQ[8].Fields[0].AsInteger+SJ.FixedRows-1;
							Wrg:=Format(SFL1(99),[FQ[8].Fields[1].AsString,FQ[8].Fields[2].AsString,CCNA.Items[CCNA.ItemIndex]])+' . '
								+Format(SFL1(142),[FQ[8].Fields[3].AsString])+' . '+Format(SFL1(128),[FQ[8].Fields[4].AsString]);
							// Fillwr(C,QYCLL,Ro,Ml[0],Ml[1],Ml[2],Ml[3],Ml[4],SJ.Cells[QYCLL,0],Wrg,SJ);
							FQ[8].Next;
							FR.ProR1(I,Mx,1,C);
						end;
					CN[8].ExecSQL('DETACH "AmzPD2"');
				end else begin
					CN[8].ExecSQL('ATTACH "'+Md[2]+'" AS "AmzPD2"');
					FRM:='SELECT ROWID,CASE WHEN '+TBL+'.CODE THEN (SELECT NIT.'+Lan+' FROM NIT WHERE NIT.CODE='+TBL+
						'.CODE) ELSE "" END AS ITLN FROM '+TBL+' WHERE CODE IN (SELECT CD FROM(SELECT CD,CASE WHEN '+
						'(SELECT ROWID FROM T00000 WHERE RIF="'+RFC+'" AND ST="'+TST+'" AND FRM="'+Cc1+'" AND IFRM='+IFR+
						' AND CODE=CD LIMIT 1)>0 THEN 1 ELSE 0 END AS CODE_EXIST '+
						'FROM (SELECT SUM(QTY) AS QS,PR AS PS,CODE AS CD FROM '+TBL+' GROUP BY PR,CODE HAVING '+FD+'('+ID+')'+
						' ORDER BY CODE ASC)) WHERE CODE_EXIST=0)';
					FQ[8].Open(FRM);
					Mx:=FQ[8].RowsAffected;
					if (Mx>0) then
						for I:=1 to Mx do begin
							// ID:=ID+','+FQ[2].Fields[0].AsString;
							Ro:=FQ[8].Fields[0].AsInteger+SJ.FixedRows-1;
							Wrg:=Format(SFL1(101),[FQ[8].Fields[1].AsString,IFR,CCNA.Items[CCNA.ItemIndex]]);
							// Fillwr(C,ITCLL,Ro,Ml[0],Ml[1],Ml[2],Ml[3],Ml[4],SJ.Cells[ITCLL,0],Wrg,SJ);
							FQ[8].Next;
							FR.ProR1(I,Mx,1,C);
						end;
					FRM:='SELECT ROWID,PR FROM '+TBL+' WHERE PR IN (SELECT PS FROM(SELECT PS,CASE WHEN '+
						'(SELECT ROWID FROM T00000 WHERE RIF="'+RFC+'" AND ST="'+TST+'" AND FRM="'+Cc1+'" AND IFRM='+IFR+
						' AND CODE=CD AND PR=PS LIMIT 1)>0 THEN 1 ELSE 0 END AS PR_EXIST,CASE WHEN '+
						'(SELECT ROWID FROM T00000 WHERE RIF="'+RFC+'" AND ST="'+TST+'" AND FRM="'+Cc1+'" AND IFRM='+IFR+' AND '+
						'CODE=CD LIMIT 1)>0 THEN 1 ELSE 0 END AS CODE_EXIST '+'FROM (SELECT PR AS PS,CODE AS CD FROM '+TBL+
						' GROUP BY PR,CODE HAVING '+FD+'('+ID+
						') ORDER BY CODE ASC)) WHERE PR_EXIST=0 AND CODE_EXIST=1 AND PS<>"0")';
					FQ[8].Open(FRM);
					Mx:=FQ[8].RowsAffected;
					if (Mx>0) then
						for I:=1 to Mx do begin
							// ID:=ID+','+FQ[2].Fields[0].AsString;
							Ro:=FQ[8].Fields[0].AsInteger+SJ.FixedRows-1;
							Wrg:=Format(SFL1(109),[FQ[8].Fields[1].AsString,IFR,CCNA.Items[CCNA.ItemIndex]]);
							// Fillwr(C,PRCLL,Ro,Ml[0],Ml[1],Ml[2],Ml[3],Ml[4],SJ.Cells[PRCLL,0],Wrg,SJ);
							FQ[8].Next;
							FR.ProR1(I,Mx,1,C);
						end;
					FRM:='SELECT DI,ITLN,QS,TQS FROM '+
						'(SELECT DI,CODE_EXIST,ITLN,PR_EXIST,PS,CASE WHEN TQS<QS THEN 0 ELSE 1 END AS WRN,QS,TQS,'+
						'CD FROM (SELECT DI,QS,PS,CD,CASE WHEN (SELECT ROWID FROM T00000 WHERE RIF="'+RFC+'" AND ST="'+TST+
						'" AND FRM="'+Cc1+'" AND IFRM='+IFR+' AND CODE=CD LIMIT 1)>0 THEN 1 ELSE 0 END AS CODE_EXIST,'+
						'CASE WHEN (SELECT ROWID FROM T00000 WHERE RIF="'+RFC+'" AND ST="'+TST+'" AND FRM="'+Cc1+
						'" AND CODE=CD AND PR=PS LIMIT 1)>0 THEN 1 ELSE 0 END AS PR_EXIST,'+
						'(SELECT SUM(QTY) FROM T00000 WHERE RIF="'+RFC+'" AND ST="'+TST+'" AND FRM="'+Cc1+'" AND IFRM='+IFR+
						' AND PR=PS)-(SELECT SUM(QTY) FROM T00000 WHERE RIF="'+TRFC+'"'+' AND NOT ICODE="'+INV+'"  AND ST="'+TST+
						'" AND FRM="'+Cc1+'" AND IFRM='+IFR+' AND PR=PS) '+'AS TQS,CASE WHEN CD THEN (SELECT NIT.'+Lan+
						' FROM NIT WHERE NIT.CODE=CD) ELSE "" END AS ITLN'+
						' FROM (SELECT SUM(QTY) AS QS,PR AS PS,CODE AS CD,ROWID AS DI FROM '+TBL+' GROUP BY PR,CODE,ROWID HAVING '+
						FD+'('+ID+')'+' ORDER BY CODE ASC)) WHERE PR_EXIST=1 AND CODE_EXIST=1 AND WRN=0)';
					FQ[8].Open(FRM);
					Mx:=FQ[8].RowsAffected;
					if (Mx>0) then
						for I:=1 to Mx do begin
							// ID:=ID+','+FQ[2].Fields[0].AsString;
							Ro:=FQ[8].Fields[0].AsInteger+SJ.FixedRows-1;
							Wrg:=Format(SFL1(99),[FQ[8].Fields[1].AsString,IFR,CCNA.Items[CCNA.ItemIndex]])+' . '+
								Format(SFL1(142),[FQ[8].Fields[3].AsString])+' . '+Format(SFL1(128),[FQ[8].Fields[4].AsString]);
							// Fillwr(C,QYCLL,Ro,Ml[0],Ml[1],Ml[2],Ml[3],Ml[4],SJ.Cells[QYCLL,0],Wrg,SJ);
							FQ[8].Next;
							FR.ProR1(I,Mx,1,C);
						end;
					CN[8].ExecSQL('DETACH "AmzPD2"');
				end;
			end;
			FQ[2].Open('SELECT ROWID FROM '+TBL+' WHERE (PR="" OR PR*1=0 OR PR IS NULL) AND '+FD+'('+ID+')');
			Mx:=FQ[2].RowsAffected;
			if (Mx>0) then
				for I:=1 to Mx do begin
					// ID:=ID+','+FQ[2].Fields[0].AsString;
					Ro:=FQ[2].Fields[0].AsInteger+SJ.FixedRows-1;
					Wrg:=Format(SFL1(113),[SJ.Cells[PRCLL,Ro]]);
					// Fillwr(C,PRCLL,Ro,Ml[0],Ml[1],Ml[2],Ml[3],Ml[4],SJ.Cells[PRCLL,0],Wrg,SJ);
					FQ[2].Next;
					FR.ProR1(I,Mx,1,C);
				end;
		end;
		/// QUANTITY VALIDITY ;
		if ContainsStr(Culs,'QTY') then begin
			CN[2].ExecSQL('UPDATE '+TBL+' SET QTY = "0" WHERE QTY*1=0 AND '+FD+'('+ID+')');
			if Charinset(TRFC[1],['1','4','5'])and(SFR1(12)='1') then begin
				CN[8].ExecSQL('ATTACH "'+Md[2]+'" AS "AmzPD2"');
				FRM:='SELECT DI,ITLN,QS,TQS,TQS-QS FROM '+
					'(SELECT CASE WHEN TQS<QS THEN 0 ELSE 1 END AS WRN,DI,ITLN,QS,TQS,TQS-QS FROM (SELECT DI,QS,'+
					'(SELECT SUM(QTY)FROM T00000 WHERE CODE=CD AND RIF IN (0,2,3,6)'+V1+'AND ST="'+TST+'")-'+
					'(SELECT SUM(QTY)FROM T00000 WHERE CODE=CD AND RIF IN (1,4,5)'+V2+'AND ST="'+TST+
					'") AS TQS,CASE WHEN CD THEN (SELECT NIT.'+Lan+' FROM NIT WHERE NIT.CODE=CD) ELSE "" END AS ITLN '+
					'FROM (SELECT SUM(QTY) AS QS,CODE AS CD,ROWID AS DI FROM '+TBL+' GROUP BY CODE HAVING '+FD+'('+ID+
					') ORDER BY CODE ASC)) WHERE WRN=0)';
				FQ[8].Open(FRM);
				Mx:=FQ[8].RowsAffected;
				if (Mx>0) then
					for I:=1 to Mx do begin
						Ro:=FQ[8].Fields[0].AsInteger+SJ.FixedRows-1;
						if Charinset(TRFC[1],['1']) then
								Wrg:=Format(SFL1(98),[FQ[8].Fields[1].AsString])+' . '+Format(SFL1(141),[FQ[8].Fields[2].AsString]);
						if Charinset(TRFC[1],['4']) then
								Wrg:=Format(SFL1(98),[FQ[8].Fields[1].AsString])+' . '+Format(SFL1(141),[FQ[8].Fields[2].AsString]);
						if Charinset(TRFC[1],['5']) then
								Wrg:=Format(SFL1(98),[FQ[8].Fields[1].AsString])+' . '+Format(SFL1(141),[FQ[8].Fields[2].AsString]);
						Wrg:=Wrg+' . '+Format(SFL1(144),[FQ[8].Fields[3].AsString])+' . '+
							Format(SFL1(145),[FQ[8].Fields[4].AsString]);
						// Fillwr(C,QYCLL,Ro,Ml[0],Ml[1],Ml[2],Ml[3],Ml[4],SJ.Cells[QYCLL,0],Wrg);
						FQ[8].Next;
						FR.ProR1(I,Mx,1,C);
					end;
				CN[8].ExecSQL('DETACH "AmzPD2"');
			end;
			FQ[2].Open('SELECT ROWID FROM '+TBL+' WHERE (QTY="" OR QTY*1=0 OR QTY IS NULL) AND '+FD+'('+ID+')');
			Mx:=FQ[2].RowsAffected;
			if (Mx>0) then
				for I:=1 to Mx do begin
					// ID:=ID+','+FQ[2].Fields[0].AsString;
					Ro:=FQ[2].Fields[0].AsInteger+SJ.FixedRows-1;
					Wrg:=Format(SFL1(113),[SJ.Cells[QYCLL,Ro]]);
					// Fillwr(C,QYCLL,Ro,Ml[0],Ml[1],Ml[2],Ml[3],Ml[4],SJ.Cells[QYCLL,0],Wrg,SJ);
					FQ[2].Next;
					FR.ProR1(I,Mx,1,C);
				end;
		end;
		/// STORAGE VALIDITY ;
		if ContainsStr(Culs,'NSN') then begin
			if (Nl(Sn)>0) then CN[2].ExecSQL('UPDATE '+TBL+' SET NSN = "'+SNF+'" WHERE NSN="" AND '+FD+'('+ID+')');
			if Charinset(TRFC[1],['1','4','5']) then begin
				CN[8].ExecSQL('ATTACH "'+Md[2]+'" AS "AmzPD2"');
				FRM:='SELECT DI,QS,ITLN,TQS,SNLN,(TQS-QS) FROM '+
					'(SELECT CASE WHEN TQS<QS THEN 0 ELSE 1 END AS WRN,DI,QS,ITLN,TQS,SNLN,(TQS-QS) FROM (SELECT'+
					'(SELECT SUM(QTY) FROM T00000 WHERE CODE=CD AND RIF IN (0,2,3,6)'+V1+'AND SN=SNS AND ST="'+TST+'")-'+
					'(SELECT SUM(QTY) FROM T00000 WHERE CODE=CD AND RIF IN (1,4,5)'+V2+'AND SN=SNS AND ST="'+TST+
					'") AS TQS,CASE WHEN CD THEN(SELECT '+Lan+
					' FROM NIT WHERE NIT.CODE=CD) ELSE "" END AS ITLN,DI,QS,CASE WHEN SNS THEN(SELECT '+Lan+
					' FROM NSN WHERE NSN.ROWID=SNS) ELSE "" END AS SNLN'+
					' FROM (SELECT sum(QTY) AS QS,CODE AS CD,NSN AS SNS,ROWID AS DI FROM '+TBL+' GROUP BY NSN,CODE HAVING '+FD+'('
					+ID+') ORDER BY NSN ASC)) WHERE WRN=0)';
				FQ[8].Open(FRM);
				Mx:=FQ[8].RowsAffected;
				if (Mx>0) then
					for I:=1 to Mx do begin
						Ro:=FQ[8].Fields[1].AsInteger+SJ.FixedRows-1;
						if Charinset(TRFC[1],['1']) then
								Wrg:=Format(SFL1(98),[FQ[8].Fields[2].AsString])+' . '+Format(SFL1(141),[FQ[8].Fields[1].AsString]);
						if Charinset(TRFC[1],['4']) then
								Wrg:=Format(SFL1(98),[FQ[8].Fields[2].AsString])+' . '+Format(SFL1(142),[FQ[8].Fields[1].AsString]);
						if Charinset(TRFC[1],['5']) then
								Wrg:=Format(SFL1(98),[FQ[8].Fields[2].AsString])+' . '+Format(SFL1(143),[FQ[8].Fields[1].AsString]);
						Wrg:=Wrg+' . '+Format(SFL1(97),[FQ[8].Fields[3].AsString])+' . '+
							Format(SFL1(127),[FQ[8].Fields[5].AsString]);
						// Fillwr(C,SNCLL,Ro,Ml[0],Ml[1],Ml[2],Ml[3],Ml[4],SJ.Cells[SNCLL,0],Wrg);
						FQ[8].Next;
						FR.ProR1(I,Mx,1,C);
					end;
				CN[8].ExecSQL('DETACH "AmzPD2"');
			end;
			FQ[2].Open('SELECT id FROM '+TBL+' WHERE NSN="" AND '+FD+'('+ID+')');
			Mx:=FQ[2].RowsAffected;
			if (Mx>0) then
				for I:=1 to Mx do begin
					// ID:=ID+','+FQ[2].Fields[0].AsString;
					Ro:=FQ[2].Fields[0].AsInteger+SJ.FixedRows-1;
					Wrg:=Format(SFL1(113),[SJ.Cells[SNCLL,Ro]]);
					// Fillwr(C,SNCLL,Ro,Ml[0],Ml[1],Ml[2],Ml[3],Ml[4],SJ.Cells[SNCLL,0],Wrg,SJ);
					FQ[2].Next;
					FR.ProR1(I,Mx,1,C);
				end;
		end else begin
			if Charinset(TRFC[1],['1','4','5']) then begin
				CN[8].ExecSQL('ATTACH "'+Md[2]+'" AS "AmzPD2"');
				FRM:='SELECT DI,QS,ITLN,TQS,(TQS-QS) FROM '+
					'(SELECT CASE WHEN TQS<QS THEN 0 ELSE 1 END AS WRN,DI,QS,ITLN,TQS,(TQS-QS) FROM (SELECT'+
					'(SELECT SUM(QTY) FROM T00000 WHERE CODE=CD AND RIF IN (0,2,3,6)'+V1+'AND SN='+Sn+' AND ST="'+TST+'")-'+
					'(SELECT SUM(QTY) FROM T00000 WHERE CODE=CD AND RIF IN (1,4,5)'+V2+'AND SN='+Sn+' AND ST="'+TST+
					'") AS TQS,CASE WHEN CD THEN(SELECT '+Lan+' FROM NIT WHERE NIT.CODE=CD) ELSE "" END AS ITLN,DI,QS'+
					' FROM (SELECT sum(QTY) AS QS,CODE AS CD,ROWID AS DI FROM '+TBL+' GROUP BY CODE HAVING '+FD+'('+ID+
					') ORDER BY CODE ASC)) WHERE WRN=0)';
				FQ[8].Open(FRM);
				Mx:=FQ[8].RowsAffected;
				if (Mx>0) then
					for I:=1 to Mx do begin
						Ro:=FQ[8].Fields[1].AsInteger+SJ.FixedRows-1;
						if Charinset(TRFC[1],['1']) then
								Wrg:=Format(SFL1(98),[FQ[8].Fields[3].AsString])+' . '+Format(SFL1(141),[FQ[8].Fields[2].AsString]);
						if Charinset(TRFC[1],['4']) then
								Wrg:=Format(SFL1(98),[FQ[8].Fields[3].AsString])+' . '+Format(SFL1(142),[FQ[8].Fields[2].AsString]);
						if Charinset(TRFC[1],['5']) then
								Wrg:=Format(SFL1(98),[FQ[8].Fields[3].AsString])+' . '+Format(SFL1(143),[FQ[8].Fields[2].AsString]);
						Wrg:=Wrg+' . '+Format(SFL1(97),[FQ[8].Fields[4].AsString])+' . '+Format(SFL1(127),[SNF])+' = "'+
							FQ[8].Fields[6].AsString+'"';
						// Fillwr(C,QYCLL,Ro,Ml[0],Ml[1],Ml[2],Ml[3],Ml[4],SFL1(39),Wrg);
						FQ[8].Next;
						FR.ProR1(I,Mx,1,C);
					end;
				CN[8].ExecSQL('DETACH "AmzPD2"');
			end;
		end;
		/// //// COLUMNS
		for I:=SJ.FixedCols to SJ.Colcount-1 do begin
			CUL:=SJ.Cols[I].Outr.Cinfo.CUL;
			Kn:=SJ.Cols[I].Outr.Cinfo.Kn;
			Ccl:=SJ.Cols[I].Outr.Cinfo.Ccl;
			if (Ccl='LAN') then Ccl:=Lan;
			WCH:=SJ.Cols[I].Outr.Cinfo.WCH;
			Ki:=SJ.Cols[I].Outr.Cinfo.Ki;
			Ref:=SJ.Cols[I].Outr.Cinfo.Ref;
			Lg:=SJ.Cols[I].Outr.Cinfo.Lg;
			TRM:=SJ.Cols[I].Outr.Cinfo.TRM;
			Trmc:=SJ.Cols[I].Outr.Cinfo.Trmc;
			AMDF.Caption:=Kn.ToString;
			if (CUL='TOTAL') then begin
				CN[2].ExecSQL('UPDATE '+TBL+' SET '+CUL+' = QTY*PR WHERE '+FD+'('+ID+')');
				TOTE.Text:=CN[2].ExecSQLScalar('SELECT SUM(TOTAL) FROM '+TBL);
			end;
			if (Kn=1) then begin
				if (Ccl='LAN') then begin
					Ccl:=Lan;
				end;
				if (Ref<>'') then Ref:=' AND NIT.REF = "'+Ref+'"';
				CN[2].ExecSQL('UPDATE '+TBL+' SET '+CUL+' = (SELECT '+Ccl+' FROM NIT WHERE NIT.CODE = '+TBL+'.CODE'+Ref+
					') WHERE '+FD+'('+ID+')');
			end;
			if (Kn in [0,2])and(Ki=1)and WCH or(CUL='NCCE') then begin
				if (Ccl='LAN') then Ccl:=Lan;
				Ref:=' AND REF = "'+Ref+'"';
				if (Copy(CUL,1,4)='NIT0') then Cmh:='NIT'
				else begin
					Cmh:=CUL;
					if (CUL='NCCE')and(CCE.ItemIndex>-1)and WCH then
							CN[2].ExecSQL('UPDATE '+TBL+' SET NCCE = "'+CCE1+'" WHERE NCCE="" AND '+FD+'('+ID+')');
					FRM:='UPDATE '+TBL+' SET '+CUL+'=(SELECT '+Ccl+' FROM '+Cmh+' WHERE ROWID=(SELECT '+CUL+' FROM NIT WHERE '+TBL
						+'.CODE=NIT.CODE LIMIT 1)'+Ref+') WHERE (SELECT '+CUL+' FROM NIT WHERE '+TBL+
						'.CODE=NIT.CODE LIMIT 1)>0 AND '+FD+'('+ID+')';
					CN[2].ExecSQL(FRM);
					FRM:='';
				end;
				if (CUL='NCCE') then Cce2:='NCCE <> "" AND '
				else Cce2:='';
				if (TRM<>'') then begin
					if (Cmh='NIT') then begin
						if (Trmc='NIT') then begin
							FRM:='SELECT DI,CU,CASE WHEN CUID>0 THEN 1 ELSE 0 END AS WR,'+
								'CASE WHEN TR1="0" OR TR1="" OR TR1=TR2 THEN 1 ELSE 0 END AS WR1,CASE WHEN CD THEN'+'(SELECT '+Lan+
								' FROM NIT WHERE CODE=CD AND CUID>0 LIMIT 1) ELSE "" END AS LN0,'+'CASE WHEN CD THEN (SELECT '+Lan+
								' FROM '+TRM+' WHERE ROWID=TR1 LIMIT 1)'+'ELSE "" END AS LN1,CASE WHEN CD THEN(SELECT '+Lan+' FROM '+TRM
								+' WHERE ROWID=TR2 LIMIT 1) ELSE "" END AS LN2 FROM(SELECT CU,DI,CD,CUID,(SELECT '+TRM+
								' FROM NIT WHERE CODE=CD AND CUID>0 LIMIT 1)AS TR1,(SELECT '+TRM+' FROM NIT WHERE '+Ccl+'=CU'+Ref+
								' AND CUID>0 LIMIT 1)AS TR2 FROM'+'(SELECT CU,DI,CD,(SELECT ROWID FROM NIT WHERE '+Ccl+'=CU'+Ref+
								' LIMIT 1)'+'AS CUID FROM(SELECT ROWID AS DI,CODE AS CD,'+CUL+' AS CU FROM '+TBL+' WHERE '+FD+'('+ID+
								'))))WHERE WR=0 OR WR1=0';
						end;
					end else begin
						if (Trmc='NIT') then begin

						end else if (Trmc<>'') then begin
							Cclt:=CN[9].ExecSQLScalar('SELECT CCL FROM '+Moth+' WHERE CUL = "'+TRM+'" AND ACT="1" LIMIT 1');
							if (Cclt='LAN') then Cclt:=Lan;
							if (Cclt<>'') then
									FRM:='SELECT DI,WR0,RSLT,CU,TM FROM(SELECT DI,CU,TM,WR0,WR1,CASE WHEN'+'(SELECT ROWID FROM '+Trmc+
									' WHERE '+CUL+'=CUID AND '+TRM+'=TMID LIMIT 1)'+
									'THEN 1 ELSE 0 END AS RSLT FROM (SELECT DI,CU,TM,CUID,TMID,'+
									'CASE WHEN CUID>0 THEN 1 ELSE 0 END AS WR0,CASE WHEN TMID>0 THEN 1 ELSE 0 END AS WR1'+
									' FROM(SELECT DI,CU,TM,(SELECT ROWID FROM '+CUL+' WHERE '+CUL+'.'+Ccl+
									'=CU LIMIT 1) AS CUID,(SELECT ROWID FROM '+TRM+' WHERE '+TRM+'.'+Cclt+
									'=TM LIMIT 1) AS TMID FROM (SELECT ROWID AS DI,'+CUL+' AS CU,'+TRM+' AS TM FROM '+TBL+' WHERE '+FD+'('
									+ID+')))) WHERE WR1=1) WHERE WR0=0 OR RSLT=0'
							else FRM:='';
						end;
					end;
				end else begin
					FRM:='SELECT ROWID,'+CUL+' FROM '+TBL+' WHERE '+CUL+
						' IN (SELECT CULN FROM (SELECT CULN,CASE WHEN (SELECT ROWID FROM '+Cmh+' WHERE '+Cmh+'.'+Ccl+'=CULN'+Ref+
						' LIMIT 1)>0 THEN 1 ELSE 0 END AS WRN FROM (SELECT DISTINCT '+CUL+' AS CULN FROM '+TBL+' WHERE '+Cce2+FD+'('
						+ID+'))) WHERE WRN=0)';
				end;
				if (FRM<>'') then begin
					FQ[2].Open(FRM);
					Mx:=FQ[2].RowsAffected;
					if (Mx>0) then
						for T:=1 to Mx do begin
							ID1:=ID1+','+FQ[2].Fields[0].AsString;
							Ro:=FQ[2].Fields[0].AsInteger+SJ.FixedRows-1;
							if (TRM='') then begin
								Wrg:=Format(SFL1(113),[FQ[2].Fields[1].AsString]);
								// Fillwr(C,I,Ro,Ml[0],Ml[1],Ml[2],Ml[3],Ml[4],Lg,Wrg,SJ);
							end else begin
								if (Cmh='NIT') then begin
									if (FQ[2].Fields[2].AsInteger=0) then begin
										Wrg:=Format(SFL1(113),[FQ[2].Fields[1].AsString]);
										// Fillwr(C,I,Ro,Ml[0],Ml[1],Ml[2],Ml[3],Ml[4],Lg,Wrg,SJ);
									end else if (FQ[2].Fields[3].AsInteger=0) then begin
										Wrg:=Format(SFL1(112)+' " %s " : [ " %s " = " %s " ] . " %s " : [ " %s " = " %s " ]',
											[CN[9].ExecSQLScalar('SELECT '+Lan+' FROM '+Moth+' WHERE CUL = "'+TRM+'"'),SFL1(146),
											FQ[2].Fields[4].AsString,FQ[2].Fields[5].AsString,Lg,FQ[2].Fields[1].AsString,
											FQ[2].Fields[6].AsString]);
										// Fillwr(C,I,Ro,Ml[0],Ml[1],Ml[2],Ml[3],Ml[4],Lg,Wrg,SJ);
									end;
								end else begin
									if (FQ[2].Fields[1].AsInteger=0) then begin
										Wrg:=Format(SFL1(113),[FQ[2].Fields[3].AsString]);
										// Fillwr(C,I,Ro,Ml[0],Ml[1],Ml[2],Ml[3],Ml[4],Lg,Wrg,SJ);
									end else if (FQ[2].Fields[2].AsInteger=0) then begin
										Wrg:=Format(SFL1(112)+' [ " %s " = " %s " ] . [ " %s " = " %s " ]',
											[Lg,Lg,FQ[2].Fields[3].AsString,CN[9].ExecSQLScalar('SELECT '+Lan+' FROM '+Moth+' WHERE CUL = "'+
											TRM+'"'),FQ[2].Fields[4].AsString]);
										// Fillwr(C,I,Ro,Ml[0],Ml[1],Ml[2],Ml[3],Ml[4],Lg,Wrg,SJ);
									end;
								end;
							end;
							FQ[2].Next;
							FR.ProR1(T,Mx,1,C);
						end;
				end;
			end;
			if (Kn=3)and WCH then begin
				CN[2].ExecSQL('UPDATE '+TBL+' SET '+CUL+' = (SELECT '+Ccl+' FROM NIT WHERE NIT.CODE = '+TBL+'.CODE) WHERE '+FD+
					'('+ID+')');
				Cmh:=Copy(CUL,5,Maxint);
				if (Cmh='DIS') then begin
					if ContainsStr(Culs,'DS') then begin
						CN[2].ExecSQL('UPDATE '+TBL+' SET DS = (QTY*PR)*NIT3DIS*0.01 WHERE '+FD+'('+ID+')');
						DISE.Text:=CN[2].ExecSQLScalar('SELECT SUM(DS) FROM '+TBL);
					end else begin
						DISE.Text:=CN[2].ExecSQLScalar('SELECT SUM(QTY*PR*NIT3DIS*0.01) FROM '+TBL);
					end;
				end;
				if (Cmh='ADS') then begin
					if ContainsStr(Culs,'AD') then begin
						CN[2].ExecSQL('UPDATE '+TBL+' SET AD = (QTY*PR)*NIT3ADS*0.01 WHERE '+FD+'('+ID+')');
						Adde.Text:=CN[2].ExecSQLScalar('SELECT SUM(AD) FROM '+TBL);
					end else begin
						Adde.Text:=CN[2].ExecSQLScalar('SELECT SUM(QTY*PR*NIT3ADS*0.01) FROM '+TBL);
					end;
				end;
			end;
			if (Kn=5)and WCH then begin
				if (Ccl='LAN') then begin
					Ccl:=Lan;
				end;
				Cmh:=SJ.Cols[I].Outr.Cinfo.Cmh;
				if (Ref<>'') then Ref:=' AND REF = "'+Ref+'"';
				if (TRM<>'') then TRM:=' WHERE '+Cmh+'.'+TRM+' = '+TBL+'.'+TRM;
				CN[2].ExecSQL('UPDATE '+TBL+' SET '+CUL+' = (SELECT '+Ccl+' FROM '+Cmh+TRM+Ref+') WHERE '+FD+'('+ID+')');
			end;
			FR.ProR(I,SJ.Colcount-1,C)
		end;
		// ShowMessage('culs');
		// ID:=ID+ID1;;
		if (SFR1(20)='1') then begin
			FRM:='(QTY*PR)';
			if ContainsStr(Culs,'AD') then FRM:=FRM+'+(QTY*PR*NIT3ADS*0.01)'
			else if ContainsStr(Culs,'NIT3ADS') then FRM:=FRM+'+AD';
			if ContainsStr(Culs,'DS') then FRM:=FRM+'-DS'
			else if ContainsStr(Culs,'NIT3DIS') then FRM:=FRM+'-(QTY*PR*NIT3DIS*0.01)';
			if (SFR1(35)='1') then FRM:='('+FRM+')*0.01*'+SFR1(18)
			else begin
				if ContainsStr(Culs,'NIT3VAT') then FRM:='('+FRM+')*0.01*NIT3VAT'
				else FRM:='('+FRM+')*0.01*(SELECT VAT FROM NIT WHERE NIT.CODE = '+TBL+'.CODE)';
			end;
			if ContainsStr(Culs,'VT') then begin
				CN[2].ExecSQL('UPDATE '+TBL+' SET VT = '+FRM+' WHERE '+CUL+'="" OR '+FD+'('+ID+')');
				VATE.Text:=CN[2].ExecSQLScalar('SELECT SUM(VT) FROM '+TBL);
			end
			else VATE.Text:=CN[2].ExecSQLScalar('SELECT SUM('+FRM+') FROM '+TBL);
		end;
		/// /// REFILL
		FQ[2].Open('SELECT * FROM '+TBL);
		for I:=1 to SJ.RowCount-1 do begin
			SJ.Cells[0,I]:=I.ToString;
			for T:=1 to FQ[2].Fields.Count-1 do begin
				SJ.Cells[SJ.FixedCols-1+T,I]:=(FQ[2].Fields[T].AsString);
			end;
			FQ[2].Next;
			FR.ProR(I,SJ.RowCount-1,C);
		end;
		/// /////////
		if (C<>0) then begin
			// SGAW:=TSGAW.Create(Self,C,Ml[0],Ml[1],Ml[2],Ml[3],Ml[4]);
			SJ.Refresh;
		end else begin
			// Clearchk(SJ);
			Result:=True;
		end;
	except
		on E:Exception do begin
			Msg1(Self,SFL1(87),SFL1(90),SFL1(111)+#13+E.ToString,2,SFL1(3),1,'',Bu);
			if (FR<>nil) then FR.Destroy;
			Dtmpdech(2);
			Dtmpdech(8);
		end;
	end;
	SJ.EnableAllOn:=True;
	SJ.Refresh;
end;

procedure TSGA.SGSave;
var
	Moth1,DDTT,DDTT1,Sn,SN1,NSN,Cc1,CC0,IVN,QNV,IC,QC,FRM,Ic1,Ic2,I1,O1,I3,O3,M1,M2,AC,AC1,ACC,ACC1,S,SS,TP,PR,QY,Cmh,Rf,
		Ref,VAT,ACV,DG,DG1,AD1,AD2,Al,QD,CE,CE1,NCE,Tt,Ccl,COMN,CM,COMM,T1,T2,T3,T4,US1,Ct,ST1,CODE,CULM,CULN,CUL,
		IFRM:string;
	O,RE,I,T,IX,X8,Kn,Ki:Integer;
	WCH:Boolean;
	FR:TProS;
begin
	FR:=nil;
	try
		DDTT:=GDT(0);
		if not SGChk then Exit;
		Al:=SFR1(40);
		if (DT[1].Date=DT[2].Date)and(TM[1].time=TM[2].time) then DDTT1:=DDTT
		else DDTT1:=DTtoN(Datetostr(DT[2].Date)+' '+TIMETOSTR(TM[2].time)).ToString;
		CM:=COMME.Text;
		SJ.Col:=SJ.FixedCols;
		SJ.Row:=SJ.RowCount-1;
		Moth1:=Dtm1(TRFC);
		IC:=INUM.Caption;
		O:=Dtn1(TRFC);
		if IsTew then begin
			if (IC=Rtc1(TRFC,TST).ToString) then begin
				IC:=(Rtc1(TRFC,TST)+1).ToString;
			end;
			INUM.Caption:=IC;
		end;
		IVN:=Dtk1(TRFC)+TST+'N'+IC;
		if (SNNA.ItemIndex>-1) then Sn:=Sfsn2(SNNA.Items[SNNA.ItemIndex])
		else Sn:='0';
		Cc1:=CCID.Items[CCID.ItemIndex];
		Ref:=Sfcc3(CCID.Items[CCID.ItemIndex]);
		if (CCE.ItemIndex>-1) then CE:=SCCE2(CCE.Items[CCE.ItemIndex])
		else CE:='0';
		case Na(TRFC) of
			1:begin
					AC1:='11';
					DG1:='15';
				end;
			2:begin
					AC1:='13';
					DG1:='16';
				end;
			3:begin
					AC1:='12';
					DG1:='16';
				end;
			4:begin
					AC1:='14';
					DG1:='15';
				end;
		end;
		AC:=SAC1(AC1);
		DG:=SAC1(DG1);
		US1:=SFR1(6);
		ST1:=SFR1(2);
		case Indexstr(Ref,['CL','SL']) of
			0:ACC1:='17';
			1:ACC1:='18';
		end;
		ACC:=SAC1(ACC1);
		ACV:='10';
		VAT:=SAC1(ACV);
		T1:=SFL1(23);
		T2:=SFL1(83);
		T3:=SFL1(84);
		T4:=SFL1(86);
		// QINV.
		if (Al='1') then begin
			QC:=(Rtc1('7',TST)+1).ToString;
			QNV:=Dtk1('7')+TST+'n'+QC;
		end;
		if FRID.Enabled then begin
			if (FRID.ItemIndex>-1) then begin
				FRM:=FRID.Items[FRID.ItemIndex];
			end;
		end
		else FRM:=IC;
		if IsTew then begin
			try
				// insert SINV.
				CN[O].ExecSQL('INSERT INTO '+Moth1+' (US,ST,SN,ICODE,IFRM,FRM,REF,DS,AD,VT,CE,DAT,DAT1,COMM'+',PRC,SEC)VALUES("'
					+US1+'","'+TST+'","'+Sn+'","'+IC+'","'+FRM+'","'+Cc1+'","'+Ref+'","'+DISE.Text+'","'+Adde.Text+'","'+VATE.Text
					+'","'+CE+'","'+DDTT+'","'+DDTT1+'","'+CM+'","'+PRC.ToString+'","'+MDFive('')+'")');
				if (Al='1') then begin
					// if new insert QINV.
					CN[6].ExecSQL('INSERT INTO QINV (US,ST,ICODE,ICODE1,RIF,DAT,COMM,SEC)VALUES("'+US1+'","'+TST+'","'+QC+'","'+IC
						+'","'+TRFC+'","'+DDTT+'","'+Dtl1(TRFC)+IC+'","'+MDFive('')+'")');
				end;
			except
				on E:Exception do
			end;
		end else begin
			try
				// QID.
				if (Al='1')and not Charinset(TRFC[1],['5','6']) then begin
					FQ[6].Open('SELECT ICODE FROM QINV WHERE ICODE1="'+IC+'" AND RIF="'+TRFC+'" AND ST="'+TST+'"');
					if (FQ[6].RowsAffected>0) then begin
						QC:=FQ[6].Fields[0].AsString;
						QNV:=Dtk1('7')+TST+'n'+QC;
						if (CN[6].ExecSQLScalar('SELECT COUNT(id) FROM '+QNV)=0) then begin
							// IF DELETED EDIT QINV.
							CN[6].ExecSQL('UPDATE QINV SET COMM="'+Dtl1(TRFC)+IC+'",US="'+US1+'",DAT="'+DDTT+'" WHERE ICODE="'+QC+
								'" AND ST="'+TST+'"');
						end else begin
							// CONT.
							Ct:=CN[7].ExecSQLScalar('SELECT CASE WHEN CT IS NULL THEN 1 ELSE CT+1 END AS COT FROM'+
								'(SELECT MAX(CONT) AS CT FROM EDT WHERE ICODE = "'+QC+'" AND ST = "'+TST+
								'" AND RIF = "7" ORDER BY id DESC LIMIT 1)');
							// INSERT EDT.
							CN[7].ExecSQL('ATTACH "'+Md[6]+'" AS "A6"');
							CN[7].ExecSQL('INSERT INTO EDT (US1,ST1,ST,ICODE,RIF,STAT,DATE,CONT,US,DATA,COMM) SELECT "'+US1+'","'+ST1+
								'","'+TST+'","'+QC+'","7","1","'+DDTT+'","'+Ct+'",US,DAT,COMM FROM A6.QINV WHERE ICODE="'+QC+
								'" AND ST="'+TST+'" LIMIT 1');
							// EDIT QINV.
							CN[7].ExecSQL('UPDATE A6.QINV SET COMM="'+Dtl1(TRFC)+IC+'" WHERE ICODE="'+QC+'" AND ST="'+TST+'"');
							// CREAT EDT Q.
							CN[7].ExecSQL('CREATE TABLE '+QNV+'T'+Ct+' AS SELECT * FROM A6.'+QNV);
							CN[7].ExecSQL('DETACH "A6"');
							// DEL FROM ACCOUNTS.
							CN[5].ExecSQL('DELETE FROM '+AC+' WHERE ICODE = "'+QC+'" AND RIF = "7" AND ST = "'+TST+'";DELETE FROM '+
								ACC+' WHERE ICODE = "'+QC+'" AND RIF = "7" AND ST = "'+TST+'";DELETE FROM '+DG+' WHERE ICODE = "'+QC+
								'" AND RIF = "7" AND ST = "'+TST+'";DELETE FROM '+VAT+' WHERE ICODE = "'+QC+'" AND RIF = "7" AND ST = "'
								+TST+'";');
						end;
					end else begin
						// if new insert QINV.
						CN[6].ExecSQL('INSERT INTO QINV (US,ST,ICODE,ICODE1,RIF,DAT,COMM,SEC)VALUES("'+US1+'","'+TST+'","'+QC+'","'+
							IC+'","'+TRFC+'","'+DDTT+'","'+Dtl1(TRFC)+IC+'","'+MDFive('')+'")');
					end;
				end;
				// INV.
				if (CN[O].ExecSQLScalar('SELECT COUNT(id) FROM '+IVN)=0) then begin
					// if delete update SINV.                                            //
					CN[O].ExecSQL('UPDATE '+Moth1+' SET DAT="'+DDTT+'" WHERE ICODE="'+IC+'"'+' AND ST="'+TST+'"');
				end else begin
					// CONT.
					Ct:=CN[7].ExecSQLScalar('SELECT CASE WHEN CT IS NULL THEN 1 ELSE CT+1 END AS COT FROM'+
						'(SELECT MAX(CONT) AS CT FROM EDT WHERE ICODE = "'+IC+'" AND ST = "'+TST+'" AND RIF = "'+TRFC+'"'+
						'ORDER BY id DESC LIMIT 1)');
					// EXTRACT OLD MOTH.
					FQ[O].Open('SELECT SN,FRM,CE,DAT FROM '+Moth1+' WHERE ICODE ="'+IC+'" AND ST = "'+TST+'"');
					SN1:=FQ[O].Fields[0].AsString;
					CC0:=FQ[O].Fields[1].AsString;
					CE1:=FQ[O].Fields[2].AsString;
					// INSERT EDT.
					CN[7].ExecSQL('ATTACH "'+Md[O]+'" AS "A20"');
					CN[7].ExecSQL('INSERT INTO EDT (US1,ST1,SN,ST,ICODE,STAT,CONT,DATE,RIF,FRM,CE,US,REF,SA,DS,AD,VT,DATA,COMM,'+
						'IFRM,PRC,DAT1) SELECT "'+US1+'","'+ST1+'","'+SN1+'","'+TST+'","'+IC+'","1","'+Ct+'","'+DDTT+'","'+TRFC+
						'","'+CC0+'","'+CE1+'",US,REF,SA,DS,AD,VT,DAT,COMM,IFRM,PRC,DAT1 FROM '+Moth1+' WHERE ICODE="'+IC+
						'" AND ST="'+TST+'" LIMIT 1');
					DDTT:=FQ[O].Fields[3].AsString;
					// DEL CLIENT.
					CN[5].ExecSQL('DELETE FROM C'+CC0+' WHERE ICODE = "'+IC+'" AND RIF = "'+TRFC+'" AND ST = "'+TST+'"');
					// CREAT EDT INV.
					CN[7].ExecSQL('CREATE TABLE '+IVN+'T'+Ct+' AS SELECT * FROM A20.'+IVN);
					CN[7].ExecSQL('DETACH "A20"');
					// COLLECT FROM OLD INV.
					S:='';
					FQ[O].Open('SELECT * FROM '+IVN);
					S:=FQ[O].Fieldlist.Commatext;
					S:=Copy(S,Pos(',',S)+1,Maxint);
					if (CN[O].ExecSQLScalar('SELECT COUNT(ID) FROM '+IVN)>0) then begin
						// DELETE FROM ITEMS.
						if not Charinset(TRFC[1],['5','6']) then begin
							FQ[O].Open('SELECT DISTINCT CODE FROM '+IVN);
							RE:=FQ[O].RowsAffected;
							if (RE>0) then begin
								FR:=TProS.Create(Self,T1,T2+' - '+SJ.Cells[ITCLL,0],T4+'   %d%%');
								for I:=1 to RE do begin
									CODE:=FQ[O].Fields[0].AsString;
									if (CODE<>'') then begin
										CN[8].ExecSQL('DELETE FROM T'+CODE+' WHERE ICODE="'+IC+'" AND RIF="'+TRFC+'" AND ST="'+TST+'"');
										CN[8].ExecSQL('DELETE FROM T00000 WHERE CODE="'+CODE+'" AND ICODE="'+IC+'" AND RIF="'+TRFC+
											'" AND ST="'+TST+'"');
									end;
									FQ[O].Next;
									FR.ProR(I,RE);
								end;
							end;
						end;
						// DELETE FROM STORES.
						if ContainsStr(S,'NSN') then begin
							FQ[O].Open('SELECT DISTINCT NSN FROM '+IVN);
							RE:=FQ[O].RowsAffected;
							if (RE>0) then begin
								FR:=TProS.Create(Self,T1,T2+' - '+SJ.Cells[SNCLL,0],T4+'   %d%%');
								SN1:=FQ[O].Fields[0].AsString;
								for I:=1 to RE do begin
									if (Na(SN1)>0) then
											CN[8].ExecSQL('DELETE FROM SN'+SN1+' WHERE ICODE="'+IC+'" AND RIF="'+TRFC+'" AND ST="'+TST+'"');
									FQ[O].Next;
									FR.ProR(I,RE);
								end;
							end;
						end else begin
							if (Na(SN1)>0) then
									CN[8].ExecSQL('DELETE FROM SN'+SN1+' WHERE ICODE="'+IC+'" AND RIF="'+TRFC+'" AND ST="'+TST+'"');
						end;
						// DELETE FROM COST CENTERS.
						if not Charinset(TRFC[1],['5','6']) then begin
							if ContainsStr(S,'NCCE') then begin
								FQ[O].Open('SELECT DISTINCT NCCE FROM '+IVN);
								RE:=FQ[O].RowsAffected;
								if (RE>0) then begin
									FR:=TProS.Create(Self,T1,T2+' - '+SJ.Cells[CECLL,0],T4+'   %d%%');
									for I:=1 to RE do begin
										CE1:=FQ[O].Fields[0].AsString;
										if (Na(CE1)>0) then
												CN[5].ExecSQL('DELETE FROM CCE'+CE1+' WHERE ICODE="'+IC+'" AND RIF="'+TRFC+
												'" AND ST="'+TST+'"');
										FQ[O].Next;
										FR.ProR(I,RE);
									end;
								end;
							end else begin
								if (Na(CE1)>0) then
										CN[5].ExecSQL('DELETE FROM CCE'+CE1+' WHERE ICODE="'+IC+'" AND RIF="'+TRFC+'" AND ST="'+TST+'"');
							end;
						end;
					end;
				end;
				// EDIT SINV.
				CN[O].ExecSQL('UPDATE '+Moth1+' SET US="'+US1+'",FRM="'+Cc1+'",REF="'+Ref+'",DS="'+DISE.Text+'",AD="'+Adde.Text+
					'",VT="'+VATE.Text+'",CE="'+CE+'",COMM="'+CM+'",SN="'+Sn+'",DAT1="'+DDTT1+'",IFRM="'+FRM+'",PRC="'+
					PRC.ToString+'" WHERE ICODE="'+IC+'"'+' AND ST="'+TST+'"');
			except
				on E:Exception do begin
					if Assigned(FR) then FR.Destroy;
					Msg1(Self,SFL1(87),SFL1(90),SFL1(111)+#13+E.ToString,2,SFL1(3),1,'',Bu);
					Exit;
				end;
			end;
		end;
		CULM:='';
		CULN:='';
		CN[O].ExecSQL('DROP TABLE IF EXISTS '+IVN);
		for I:=SJ.FixedCols to SJ.Colcount-1 do
			if (SJ.Cols[I].Outr.Cinfo.KA=1) then begin
				CULN:=CULN+',"'+SJ.Cols[I].Outr.Cinfo.CUL+'"';
				CULM:=CULM+',"'+SJ.Cols[I].Outr.Cinfo.CUL+'"'+Tn1;
			end;
		Delete(CULN,1,1);
		CN[O].ExecSQL(CT1+IVN+' ('+IDN1+CULM+')');
		AMDF.RichEdit.Lines.Text:=CULN;
		CN[2].ExecSQL('ATTACH "'+Md[O]+'" AS "AO"');
		CN[2].ExecSQL('INSERT INTO '+IVN+' ('+CULN+') SELECT '+CULN+' FROM '+TBL);
		/// //// COLUMNS
		for I:=SJ.FixedCols to SJ.Colcount-1 do begin
			CUL:=SJ.Cols[I].Outr.Cinfo.CUL;
			Kn:=SJ.Cols[I].Outr.Cinfo.Kn;
			Ccl:=SJ.Cols[I].Outr.Cinfo.Ccl;
			WCH:=SJ.Cols[I].Outr.Cinfo.WCH;
			Ki:=SJ.Cols[I].Outr.Cinfo.Ki;
			Ref:=SJ.Cols[I].Outr.Cinfo.Ref;
			Cmh:=SJ.Cols[I].Outr.Cinfo.Cmh;
			if (Kn in [0,2])and(Ki=1)and WCH or(CUL='NCCE') then begin
				if (Ccl='LAN') then Ccl:=Lan;
				if (Ref<>'') then Ref:=' AND REF = "'+Ref+'"'
				else Ref:='';
				if (Copy(CUL,1,4)='NIT0') then Cmh:='NIT';
				if (CUL='NCCE') then begin
					CN[2].ExecSQL('UPDATE '+IVN+' SET '+CUL+'=(SELECT id FROM '+Cmh+' WHERE '+Cmh+'.'+Ccl+'='+IVN+'.'+CUL+
						' LIMIT 1)');
					CN[2].ExecSQL('UPDATE '+IVN+' SET '+CUL+'=0 WHERE '+CUL+' IS NULL');
				end else begin
					CN[2].ExecSQL('UPDATE '+IVN+' SET '+CUL+'=(SELECT id FROM '+Cmh+' WHERE '+Cmh+'.'+Ccl+'='+IVN+'.'+CUL+Ref+
						' LIMIT 1)');
				end;
			end;
			{ if(Kn=4)then begin
				if(CUL='DAT')then
				CN[2].ExecSQL('UPDATE '+IVN+' SET '+CUL+' =(SELECT A || B FROM (SELECT REPLACE((SELECT '
				+CUL+' FROM '+IVN+'),"/","")AS A,strftime("%H%M%S","NOW","localtime")AS B))');
				if(CUL='DAT1')then
				CN[2].ExecSQL('UPDATE '+IVN+' SET '+CUL+' =(SELECT A || B FROM (SELECT REPLACE((SELECT '
				+CUL+' FROM '+IVN+'),"/","")AS A,strftime("%H%M%S","NOW","localtime")AS B))');
				end; }
		end;
		CN[2].ExecSQL('DETACH "AO"');
		/// / INSERT ITEMS.
		if not Charinset(TRFC[1],['5','6']) then begin
			FQ[O].Open('SELECT DISTINCT CODE FROM '+IVN);
			RE:=FQ[O].RowsAffected;
			if (RE>0) then begin
				if Charinset(TRFC[1],['3','4']) then Ic1:=FRM
				else Ic1:=IC;
				if (FRMCLL=0) then IFRM:=',"'+Ic1+'"'
				else IFRM:=',IFRM';
				if (SNCLL=0) then NSN:=',"'+Sn+'"'
				else NSN:=',NSN';
				if (CMCLL=0) then COMN:=',"'+CM+'"'
				else COMN:=',COMN';
				CN[O].ExecSQL('ATTACH "'+Md[8]+'" AS "A8"');
				FR:=TProS.Create(Self,T1,T3+' - '+SJ.Cells[ITCLL,0],T4+'   %d%%');
				for I:=1 to RE do begin
					CODE:=FQ[O].Fields[0].AsString;
					if (CODE<>'') then begin
						CN[O].ExecSQL('INSERT INTO T'+CODE+' (US,ST,ICODE,RIF,FRM,REF,DAT,QTY,PR,IFRM,SN,COMM'+') SELECT "'+US1+
							'","'+TST+'","'+IC+'","'+TRFC+'","'+Cc1+'","'+Ref+'","'+DDTT+'",SUM(QTY),PR'+IFRM+NSN+COMN+' FROM '+IVN+
							' WHERE CODE="'+CODE+'" GROUP BY PR'+IFRM+NSN+COMN);
					end;
					FQ[O].Next;
					FR.ProR(I,RE);
				end;
				CN[O].ExecSQL('INSERT INTO T00000 (US,ST,ICODE,RIF,FRM,REF,DAT,QTY,CODE,PR,IFRM,SN) SELECT "'+US1+'","'+TST+
					'","'+IC+'","'+TRFC+'","'+Cc1+'","'+Ref+'","'+DDTT+'",SUM(QTY),CODE,PR'+IFRM+NSN+' FROM '+IVN+
					' GROUP BY CODE,PR'+IFRM+NSN);
				CN[O].ExecSQL('DETACH "A8"');
			end;
		end;
		/// / INSERT STORE.
		if (SNCLL=0) then FQ[O].Open('SELECT "'+Sn+'"')
		else FQ[O].Open('SELECT DISTINCT NSN FROM '+IVN);
		RE:=FQ[O].RowsAffected;
		if (RE>0) then begin
			CN[O].ExecSQL('ATTACH "'+Md[8]+'" AS "A8"');
			FR:=TProS.Create(Self,T1,T3+' - '+SJ.Cells[SNCLL,0],T4+'   %d%%');
			for I:=1 to RE do begin
				SN1:=FQ[O].Fields[0].AsString;
				if (SNCLL=0) then NSN:=''
				else NSN:=' WHERE NSN="'+SN1+'"';
				if (Na(SN1)>0) then begin
					CN[O].ExecSQL('INSERT INTO SN'+SN1+' (US,ST,ICODE,RIF,FRM,REF,DAT,QTY,CODE) SELECT "'+US1+'","'+TST+'","'+IC+
						'","'+TRFC+'","'+Cc1+'","'+Ref+'","'+DDTT+'",SUM(QTY),CODE FROM '+IVN+NSN+' GROUP BY CODE');
				end;
				FQ[O].Next;
				FR.ProR(I,RE);
			end;
			CN[O].ExecSQL('DETACH "A8"');
		end;
		/// / INSERT COST CENTER.
		if not Charinset(TRFC[1],['5','6']) then begin
			// IF MULTI STORE.
			if (CECLL=0) then FQ[O].Open('SELECT "'+CE+'"')
			else FQ[O].Open('SELECT DISTINCT NCCE FROM '+IVN);
			RE:=FQ[O].RowsAffected;
			if (RE>0) then begin
				CN[O].ExecSQL('ATTACH "'+Md[5]+'" AS "A5"');
				if (CMCLL=0) then COMN:=',"'+CM+'"'
				else COMN:=',COMN';
				if (CMCLL=0) then COMM:=''
				else COMM:=' GROUP BY COMN';
				if Charinset(TRFC[1],['2','3']) then Tt:='",SUM(QTY*PR),"0"'
				else Tt:='","0",SUM(QTY*PR)';
				FR:=TProS.Create(Self,T1,T3+' - '+SJ.Cells[CECLL,0],T4+'   %d%%');
				for I:=1 to RE do begin
					CE1:=FQ[O].Fields[0].AsString;
					if (CECLL=0) then NCE:=''
					else NCE:=' WHERE NCCE="'+CE1+'"';
					if (Na(CE1)>0) then begin
						CN[O].ExecSQL('INSERT INTO CCE'+CE1+' (US,ST,ICODE,RIF,DAT,AM1,AM2,COMM) SELECT "'+US1+'","'+TST+'","'+IC+
							'","'+TRFC+'","'+DDTT+Tt+COMN+' FROM '+IVN+NCE+COMM);
					end;
					FQ[O].Next;
					FR.ProR(I,RE);
				end;
				CN[O].ExecSQL('DETACH "A5"');
			end;
		end;
		/// / EDIT SA IN MOTH.
		FQ[O].Open('SELECT SUM(QTY * PR) FROM '+IVN);
		TOTE.Text:=FQ[O].Fields[0].AsString;
		CN[O].ExecSQL('UPDATE '+Moth1+' SET SA = "'+TOTE.Text+'" WHERE ICODE = "'+IC+'"'+' AND ST = "'+TST+'"');
		if not Charinset(TRFC[1],['5','6']) then begin
			case Na(TRFC) of
				1,4,5:begin
						I1:=NETE.Text;
						O1:='0';
						I3:='0';
						O3:=(Ne(TOTE.Text)+Ne(Adde.Text)).ToString;
						M1:='0';
						M2:=VATE.Text;
						AD1:=DISE.Text;
						AD2:='0';
					end;
				2,3,6:begin
						I1:='0';
						O1:=NETE.Text;
						I3:=(Ne(TOTE.Text)+Ne(Adde.Text)).ToString;
						O3:='0';
						M1:=VATE.Text;
						M2:='0';
						AD1:='0';
						AD2:=DISE.Text;
					end;
			end;
			// INSERT IN CLIENT SL/CL.
			CN[5].ExecSQL('INSERT INTO C'+Cc1+' (US,ST,ICODE,RIF,AM1,AM2,DAT,COMM)VALUES("'+US1+'","'+TST+'","'+IC+'","'+TRFC+
				'","'+I1+'","'+O1+'","'+DDTT+'","'+CM+'")');
			if (Al='1') then begin
				// CREAT QIVN.
				CN[6].ExecSQL('DROP TABLE IF EXISTS '+QNV);
				CN[6].ExecSQL(CT1+QNV+' ('+IDN1+',CODE'+Tn1+',AM1'+Tn1+',AM2'+Tn1+',COMM'+Tn1+')');
				// INSERT QIVN
				QD:='("'+ACC1+'","'+I1+'","'+O1+'","'+Sfcc1(Cc1)+'"),';
				QD:=QD+'("'+AC1+'","'+I3+'","'+O3+'","'+Slg1(AC1)+'")';
				if not(SFR1(20)='0') then begin
					QD:=QD+',("'+ACV+'","'+M1+'","'+M2+'","'+Slg1(ACV)+'")';
				end;
				if not((AD1='0')and(AD2='0')) then begin
					QD:=QD+',("'+DG1+'","'+AD1+'","'+AD2+'","'+Slg1(DG1)+'")'
				end;
				CN[6].ExecSQL('INSERT INTO '+QNV+' (CODE,AM1,AM2,COMM)VALUES'+QD);
				// INSERT IN CUS/SUP.
				CN[5].ExecSQL('INSERT INTO '+ACC+' (US,ST,ICODE,RIF,AM1,AM2,DAT,COMM)'+'VALUES("'+US1+'","'+TST+'","'+QC+
					'","7","'+I1+'","'+O1+'","'+DDTT+'","'+Sfcc1(Cc1)+'")');
				// INSERT IN VAT.
				if not(SFR1(20)='0') then begin
					CN[5].ExecSQL('INSERT INTO '+VAT+' (US,ST,ICODE,RIF,AM1,AM2,DAT,COMM)'+'VALUES("'+US1+'","'+TST+'","'+QC+
						'","7","'+M1+'","'+M2+'","'+DDTT+'","'+Slg1(ACV)+'")');
				end;
				// INSERT IN VOUCHER.
				CN[5].ExecSQL('INSERT INTO '+AC+' (US,ST,ICODE,RIF,AM1,AM2,DAT,COMM)'+'VALUES("'+US1+'","'+TST+'","'+QC+
					'","7","'+I3+'","'+O3+'","'+DDTT+'","'+Slg1(AC1)+'")');
				// INSERT IN DG/DO.
				if not((AD1='0')and(AD2='0')) then begin
					CN[5].ExecSQL('INSERT INTO '+DG+' (US,ST,ICODE,RIF,AM1,AM2,DAT,COMM)'+'VALUES("'+US1+'","'+TST+'","'+QC+
						'","7","'+AD1+'","'+AD2+'","'+DDTT+'","'+Slg1(DG1)+'")');
				end;
				// DEL FROM BALANCE.
				CN[5].ExecSQL('DELETE FROM BALANCES WHERE ST = "'+TST+'" AND ACC IN ("'+AC1+'","'+ACC1+'","'+ACV+'","'
					+DG1+'")');
				// INSERT BALANCE.
				CN[5].ExecSQL('INSERT INTO BALANCES (US,ST,KI,ACC,AM1,AM2)VALUES'+'("'+US1+'","'+TST+'","'+Ski1(AC1)+'","'+AC1+
					'","'+Sam1(AC1,TST)+'","'+Sam2(AC1,TST)+'"),("'+US1+'","'+TST+'","'+Ski1(ACC1)+'","'+ACC1+'","'+Sam1(ACC1,TST)
					+'","'+Sam2(ACC1,TST)+'"),("'+US1+'","'+TST+'","'+Ski1(ACV)+'","'+ACV+'","'+Sam1(ACV,TST)+'","'+Sam2(ACV,TST)+
					'"),("'+US1+'","'+TST+'","'+Ski1(DG1)+'","'+DG1+'","'+Sam1(DG1,TST)+'","'+Sam2(DG1,TST)+'")');
			end;
		end;
		SGNew;
	except
		on E:Exception do begin
			if Assigned(FR) then FR.Destroy;
			Msg1(Self,SFL1(87),SFL1(90),E.ToString,2,SFL1(3),1,'',Bu); // SFL1(111)
		end;
	end;
end;

procedure TSGA.SGDel;
var
	Moth1,DDTT,IVN,IC,Sn,SN1,ST1,CC0,Ref,AC,AC1,ACC,ACC1,S,VAT,ACV,DG,DG1,QC,QNV,CE,CE1,US1,Ct,CODE:string;
	O,RE,I:Integer;
	FR:TProS;
begin
	FR:=nil;
	try
		DDTT:=GDT(0);
		if (Msg1(Self,SFL1(85),SFL1(92)+' '+SFL1(42),SFL1(102),4,SFL1(5)+'|'+SFL1(6),2,'',Bu)=2) then Exit;
		if (CCID.ItemIndex=-1) then begin
			CCID.Sbo(Tti_error_large,SFL1(87),SFL1(43),CCID.ClientRect,2);
			CCID.Setfocus;
			Exit;
		end else begin
			Ref:=Sfcc3(CCID.Items[CCID.ItemIndex]);
		end;
		case Na(TRFC) of
			1:begin
					AC1:='11';
					DG1:='15';
				end;
			2:begin
					AC1:='13';
					DG1:='16';
				end;
			3:begin
					AC1:='12';
					DG1:='16';
				end;
			4:begin
					AC1:='14';
					DG1:='15';
				end;
		end;
		AC:=SAC1(AC1);
		DG:=SAC1(DG1);
		US1:=SFR1(6);
		ST1:=SFR1(2);
		case Indexstr(Ref,['CL','SL']) of
			0:ACC1:='17';
			1:ACC1:='18';
		end;
		ACC:=SAC1(ACC1);
		ACV:='10';
		VAT:=SAC1(ACV);
		Moth1:=Dtm1(TRFC);
		IC:=INUM.Caption;
		IVN:=Dtk1(TRFC)+TST+'n'+IC;
		O:=Dtn1(TRFC);
		// QINV
		if not Charinset(TRFC[1],['5','6']) then begin
			// EXTRACT QC.
			FQ[6].Open('SELECT ICODE FROM QINV WHERE ICODE1 = "'+IC+'" AND RIF = "'+TRFC+'" AND ST = "'+TST+'"');
			if (FQ[6].RowsAffected>0) then begin
				QC:=FQ[6].Fields[0].AsString;
				QNV:=Dtk1('7')+TST+'n'+QC;
				// CONT.
				Ct:=CN[7].ExecSQLScalar('SELECT CASE WHEN CT IS NULL THEN 1 ELSE CT+1 END AS COT FROM'+
					'(SELECT MAX(CONT) AS CT FROM EDT WHERE ICODE = "'+QC+'" AND ST = "'+TST+'" AND RIF = "7"'+
					'ORDER BY id DESC LIMIT 1)');
				// INSERT EDT.
				CN[7].ExecSQL('ATTACH "'+Md[6]+'" AS "A6"');
				CN[7].ExecSQL('INSERT INTO EDT (US1,ST1,ICODE,RIF,STAT,DATE,CONT,US,ST,DATA,COMM) '+'SELECT "'+US1+'","'+ST1+
					'","'+QC+'","7","1","'+DDTT+'","'+Ct+'",US,ST,DAT,COMM FROM A6.QINV WHERE ICODE = "'+QC+'" AND ST = "'+TST+
					'" LIMIT 1');
				// EDIT QINV.
				CN[7].ExecSQL('UPDATE A6.QINV SET COMM="" WHERE ICODE="'+QC+'" AND ST="'+TST+'"');
				// CREAT EDT Q.
				CN[7].ExecSQL('CREATE TABLE '+QNV+'T'+Ct+' AS SELECT * FROM A6.'+QNV);
				CN[7].ExecSQL('DELETE FROM A6.'+QNV+' WHERE id NOT NULL');
				CN[7].ExecSQL('DETACH "A6"');
				// DEL FROM ACCOUNTS.
				CN[5].ExecSQL('DELETE FROM '+AC+' WHERE ICODE = "'+QC+'" AND RIF = "7'+'" AND ST = "'+TST+'";'+'DELETE FROM '+
					ACC+' WHERE ICODE = "'+QC+'" AND RIF = "7'+'" AND ST = "'+TST+'";'+'DELETE FROM '+DG+' WHERE ICODE = "'+QC+
					'" AND RIF = "7'+'" AND ST = "'+TST+'";'+'DELETE FROM '+VAT+' WHERE ICODE = "'+QC+'" AND RIF = "7'+
					'" AND ST = "'+TST+'";');
				// DEL FROM BALANCE.
				CN[5].ExecSQL('DELETE FROM BALANCES WHERE ST = "'+TST+'" AND ACC IN ("'+AC1+'","'+ACC1+'","'+ACV+'","'
					+DG1+'")');
				// INSERT BALANCE.
				CN[5].ExecSQL('INSERT INTO BALANCES (US,ST,KI,ACC,AM1,AM2)VALUES'+'("'+US1+'","'+TST+'","'+Ski1(AC1)+'","'+AC1+
					'","'+Sam1(AC1,TST)+'","'+Sam2(AC1,TST)+'"),'+'("'+US1+'","'+TST+'","'+Ski1(ACC1)+'","'+ACC1+'","'+Sam1(ACC1,
					TST)+'","'+Sam2(ACC1,TST)+'"),'+'("'+US1+'","'+TST+'","'+Ski1(ACV)+'","'+ACV+'","'+Sam1(ACV,TST)+'","'+
					Sam2(ACV,TST)+'"),'+'("'+US1+'","'+TST+'","'+Ski1(DG1)+'","'+DG1+'","'+Sam1(DG1,TST)+'","'+Sam2(DG1,
					TST)+'")');
			end;
		end;
		// CONT.
		Ct:=CN[7].ExecSQLScalar('SELECT CASE WHEN CT IS NULL THEN 1 ELSE CT+1 END AS COT FROM'+
			'(SELECT MAX(CONT) AS CT FROM EDT WHERE ICODE = "'+IC+'" AND ST = "'+TST+'" AND RIF = "'+TRFC+'"'+
			'ORDER BY id DESC LIMIT 1)');
		// EXTRACT OLD MOTH.
		FQ[O].Open('SELECT SN,FRM,CE FROM '+Moth1+' WHERE ICODE ="'+IC+'" AND ST = "'+TST+'"');
		Sn:=FQ[O].Fields[0].AsString;
		CC0:=FQ[O].Fields[1].AsString;
		CE:=FQ[O].Fields[2].AsString;
		// INSERT EDT.
		CN[7].ExecSQL('ATTACH "'+Md[O]+'" AS "A20"');
		CN[7].ExecSQL('INSERT INTO EDT (US1,ST1,SN,ST,ICODE,STAT,CONT,DATE,RIF,FRM,CE,US,REF,SA,DS,AD,VT,DATA,COMM,IFRM,'+
			'PRC,DAT1) SELECT "'+US1+'","'+ST1+'","'+Sn+'","'+TST+'","'+IC+'","2","'+Ct+'","'+DDTT+'","'+TRFC+'","'+CC0+'","'+
			CE+'",US,REF,SA,DS,AD,VT,DAT,COMM,IFRM,PRC,DAT1 FROM '+Moth1+' WHERE ICODE="'+IC+'" AND ST="'+TST+'" LIMIT 1');
		// EDIT MOTH.
		CN[O].ExecSQL('UPDATE '+Moth1+' SET US = "'+US1+'",FRM="",REF="",SA="",DS=""'+
			',COMM="",SN="",AD="",VT="",CE="",IFRM="",PRC="",DAT1="",SEC="'+MDFive('')+'" WHERE ICODE = "'+IC+
			'" AND ST = "'+TST+'"');
		// DEL CLIENT.
		CN[5].ExecSQL('DELETE FROM C'+CC0+' WHERE ICODE = "'+IC+'" AND RIF = "'+TRFC+'" AND ST = "'+TST+'"');
		// CREAT EDT INV.
		CN[7].ExecSQL('CREATE TABLE '+IVN+'T'+Ct+' AS SELECT * FROM A20.'+IVN);
		CN[7].ExecSQL('DETACH "A20"');
		// COLLECT FROM OLD INV.
		S:='';
		FQ[O].Open('SELECT * FROM '+IVN);
		S:=FQ[O].Fieldlist.Commatext;
		S:=Copy(S,Pos(',',S)+1,Maxint);
		if (CN[O].ExecSQLScalar('SELECT COUNT(ID) FROM '+IVN)>0) then begin
			// DELETE FROM ITEMS
			if not Charinset(TRFC[1],['5','6']) then begin
				FQ[O].Open('SELECT DISTINCT CODE FROM '+IVN);
				RE:=FQ[O].RowsAffected;
				if (RE>0) then begin
					FR:=TProS.Create(Self,SFL1(23),SFL1(85)+' [ 2 ]',SFL1(86)+'   %d%%');
					for I:=1 to RE do begin
						CODE:=FQ[O].Fields[0].AsString;
						CN[8].ExecSQL('DELETE FROM T'+CODE+' WHERE ICODE="'+IC+'" AND RIF="'+TRFC+'" AND ST="'+TST+'"');
						CN[8].ExecSQL('DELETE FROM T00000 WHERE CODE="'+CODE+'" AND ICODE="'+IC+'" AND RIF="'+TRFC+
							'" AND ST="'+TST+'"');
						FQ[O].Next;
						FR.ProR(I,RE);
					end;
				end;
				// DELETE FROM COST CENTERS.
				if ContainsStr(S,'NCCE') then begin
					FQ[O].Open('SELECT DISTINCT NCCE FROM '+IVN);
					RE:=FQ[O].RowsAffected;
					if (RE>0) then begin
						FR:=TProS.Create(Self,SFL1(23),SFL1(85)+' [ 3 ]',SFL1(86)+'   %d%%');
						for I:=1 to RE do begin
							CE1:=FQ[O].Fields[0].AsString;
							if (Na(CE1)>0) then begin
								CN[5].ExecSQL('DELETE FROM CCE'+CE1+' WHERE ICODE="'+IC+'" AND RIF="'+TRFC+'" AND ST="'+TST+'"');
							end;
							FQ[O].Next;
							FR.ProR(I,RE);
						end;
					end;
				end else begin
					if (Na(CE)>0) then
							CN[5].ExecSQL('DELETE FROM CCE'+CE+' WHERE ICODE = "'+IC+'" AND RIF = "'+TRFC+'" AND ST = "'+TST+'"');
				end;
			end;
			// DELETE FROM STORES.
			if ContainsStr(S,'NSN') then begin
				FQ[O].Open('SELECT DISTINCT NSN FROM '+IVN);
				RE:=FQ[O].RowsAffected;
				if (RE>0) then begin
					FR:=TProS.Create(Self,SFL1(23),SFL1(85)+' [ 4 ]',SFL1(86)+'   %d%%');
					for I:=1 to RE do begin
						SN1:=FQ[O].Fields[0].AsString;
						if (Na(SN1)>0) then
								CN[8].ExecSQL('DELETE FROM SN'+SN1+' WHERE ICODE = "'+IC+'" AND RIF = "'+TRFC+'" AND ST = "'+TST+'"');
						FQ[O].Next;
						FR.ProR(I,RE);
					end;
				end;
			end else begin
				if (Na(Sn)>0) then
						CN[8].ExecSQL('DELETE FROM SN'+Sn+' WHERE ICODE = "'+IC+'" AND RIF = "'+TRFC+'" AND ST = "'+TST+'"');
			end;
		end;
		CN[O].ExecSQL('DELETE FROM '+IVN+' WHERE id NOT NULL');
		SGNew;
	except
		on E:Exception do begin
			Msg1(Self,SFL1(87),SFL1(90),E.ToString,2,SFL1(3),1,'',Bu);
			if (FR<>nil) then FR.Destroy;
			Exit;
		end;
	end;
end;

procedure TSGA.LoadSG(INV,Co:Integer);
var
	IVN,SN1,S,Cmh,Ref,Ccl,IFRM,CUL,CULM,SHM:string;
	RE,I,T,Kn,Ki:Integer;
	WCH:Boolean;
	FR:TProS;
	C1,C2:Extended;
begin
	FR:=nil;
	try
		IVN:=Dtk1(TRFC)+TST+'n'+INV.ToString+'T'+Co.ToString;
		if (Co>0) then begin
			SJ.Options:=SJ.Options-[Goediting];
			BTN[10].Enabled:=True;
			DISE.readOnly:=True;
			Adde.readOnly:=True;
			SGClear;
			COMME.readOnly:=True;
			FQ[7].Open('SELECT SUM(QTY) FROM '+IVN);
			QTYE.Text:=FQ[7].Fields[0].AsString;
			FQ[7].Open('SELECT FRM,COMM,SA,DS,DATA,SN,AD,CE,VT,IFRM,DATE,STAT FROM EDT WHERE ICODE = "'+INV.ToString+
				'" AND ST = "'+TST+'" AND CONT = "'+Co.ToString+'" AND RIF ="'+TRFC+'"');
			INUM.Caption:=INV.ToString;
			CCNA.ItemIndex:=CCNA.Items.Indexof(Sfcc1(FQ[7].Fields[0].AsString));
			CCID.ItemIndex:=CCID.Items.Indexof(FQ[7].Fields[0].AsString);
			COMME.Text:=FQ[7].Fields[1].AsString;
			TOTE.Text:=FQ[7].Fields[2].AsString;
			DISE.Text:=FQ[7].Fields[3].AsString;
			Adde.Text:=FQ[7].Fields[6].AsString;
			VATE.Text:=FQ[7].Fields[8].AsString;
			IFRM:=FQ[7].Fields[9].AsString;
			NToDt(FQ[7].Fields[4].AsString,C1,C2);
			DT[1].Date:=C1;
			TM[1].time:=C2;
			NToDt(FQ[7].Fields[10].AsString,C1,C2);
			DT[2].Date:=C1;
			TM[2].time:=C2;
			SN1:=FQ[7].Fields[5].AsString;
			SNNA.ItemIndex:=SNNA.Items.Indexof(SFSN1(SN1));
			CCE.ItemIndex:=CCE.Items.Indexof(SCCE1(FQ[7].Fields[7].AsString));
			SGCINF(FQ[7].Fields[0].AsString);
			case FQ[7].Fields[11].AsInteger of
				1:begin
						EditBtn.Imageindex:=1;
						EditBtn.Caption:=SFL1(68)+' ['+Co.ToString+']';
					end;
				2:begin
						EditBtn.Imageindex:=2;
						EditBtn.Caption:=SFL1(69)+' ['+Co.ToString+']';
					end;
			end;
			FQ[7].Open('SELECT * FROM '+IVN);
			S:=FQ[7].Fieldlist.Commatext;
			Delete(S,1,Pos(',',S));
			RE:=CN[7].ExecSQLScalar('SELECT COUNT(ROWID) FROM '+IVN);
			SJ.EnableOnChanges:=False;
			SJ.EnableOnGetCell:=False;
			if (RE=0) then begin
				SJ.RowCount:=SJ.FixedRows+1;
				SGTLC(SJ);
				SJ.Cells[0,SJ.RowCount-1]:=(SJ.RowCount-1).ToString;
				SJ.EnableOnChanges:=True;
			end else begin
				CULM:='';
				SGColsRE(CN[7],FQ[7],IVN);
				SJ.RowCount:=SJ.FixedRows+RE;
				SGTLC(SJ);
				CULM:=',id';
				SJ.RowCount:=SJ.FixedRows+RE;
				for I:=SJ.FixedCols to SJ.Colcount-1 do begin
					CUL:=SJ.Cols[I].Outr.Cinfo.CUL;
					if ContainsStr(S,CUL) then CULM:=CULM+','+CUL
					else CULM:=CULM+',"" AS '+CUL;
				end;
				Delete(CULM,1,1);
				SHM:='';
				SHM:=SHM+'ATTACH "'+Md[7]+'" AS "AmzPD"';
				SHM:=SHM+';DROP TABLE IF EXISTS '+TBL;
				SHM:=SHM+';CREATE TEMPORARY TABLE IF NOT EXISTS '+TBL+' AS SELECT '+CULM+' FROM AmzPD.'+IVN;
				SHM:=SHM+';UPDATE '+TBL+' SET id=ROWID';
				SHM:=SHM+';DETACH "AmzPD";';
				CN[2].ExecSQL(SHM);
				SJ.EnableOnChanges:=True;
				SJ.EnableOnGetCell:=True;
			end;
		end;
		Refresh;
	except
		on E:Exception do begin
			Msg1(Self,SFL1(87),SFL1(90),SFL1(111)+#13+E.ToString,2,SFL1(3),1,'',Bu);
			if (FR<>nil) then FR.Destroy;
		end;
	end;
end;

procedure TSGA.SGCLOSE(Sender:TObject;var Action:TCloseAction);
begin
	Self.Owner.Insertcomponent(STNF);
	STNF.Insertcomponent(Self);
	Action:=Cafree;
end;

/// //////////////////////////               TSTG                   /////////////////////////////
constructor TSTG.Create(AOwner:TSGA);
var
	Cc1,It1,RFC,ST1:string;
	I,Nu2,Hi,Cont:Integer;
	Gb:TGroupBox;
	C1,C2:Extended;
begin
	inherited Create(AOwner);
	try
		RFC:=AOwner.TRFC;
		ST1:=AOwner.TST;
		TRFC:=AOwner.TRFC;
		TST:=AOwner.TST;
		It1:=AOwner.SJ.Cells[AOwner.ITCLL,AOwner.SJ.Row];
		Cont:=Na(SFR1(4));
		if (AOwner.CCID.ItemIndex=-1) then begin
			SBO1;
			AOwner.CCNA.Sbo(Tti_error_large,SFL1(87),SFL1(38),AOwner.CCNA.ClientRect,2);
			AOwner.CCNA.Setfocus;
			Exit;
		end else begin
			Cc1:=AOwner.CCID.Items[AOwner.CCID.ItemIndex];
		end;
		if (It1<>'')and Charinset(RFC[1],['1'..'6'])and(ST1<>'')and(Cc1<>'')and(Cont>0) then begin
			FQ[8].Open('SELECT DISTINCT ICODE,QTY,PR,DAT FROM T'+It1+' WHERE FRM = "'+Cc1+'" AND ST = "'+ST1+'" AND RIF = "'+
				RFC+'" ORDER BY ICODE DESC LIMIT '+Cont.ToString);
			Nu2:=FQ[8].RowsAffected;
			if (Nu2=0) then begin
				Msg1(Self,Sfd7(3,RFC),SFL1(87),SFL1(88),3,SFL1(3),1,'',Bu);
				Exit;
			end;
		end else begin
			Exit;
		end;
		STNF:=TForm.Create(Self);
		with STNF do begin
			Parent:=nil;
			BorderStyle:=BsDialog;
			BidiMode:=AOwner.BidiMode;
			Position:=PoScreenCenter;
			Caption:='   '+Sfd7(3,RFC)+'   ';
			BorderIcons:=[BiSystemMenu];
			Color:=AOwner.Color;
			Tag:=1;
			Height:=410;
			Width:=535;
			Icon:=Application.Icon;
			Font:=AOwner.Font;
		end;
		Parent:=STNF;
		SGA:=AOwner;
		with TLabel.Create(Self) do begin
			Parent:=Self;
			AutoSize:=False;
			Align:=Albottom;
			Caption:=SFL1(133);
			Height:=Canvas.Textheight(Caption)+3;
			Alignment:=TaCenter;
		end;
		Gb:=TGroupBox.Create(Self);
		Gb.Parent:=Self;
		Gb.SetBounds(5,5,520,290);
		Gb.Font.Style:=[Fsbold];
		Gb.Caption:=Sfcc1(Cc1)+'  :  '+AOwner.SJ.Cells[2,AOwner.SJ.Row];
		LBS:=TLabel.Create(Self);
		with LBS do begin
			Parent:=Self;
			AutoSize:=False;
			SetBounds(10,310,425,40);
			Font.Size:=10;
			Font.Style:=[Fsbold];
			Alignment:=TaCenter;
			Layout:=Tlcenter;
			Caption:='';
		end;
		SG:=TSG.Create(Self);
		with SG do begin
			Parent:=Self;
			Font:=AOwner.Font;
			Color:=Clwindow;
			SetBounds(10,30,510,250);
			ColButton.OnClick:=SGB;
			OnMouseMove:=SGMMove;
			OnKeyPress:=User5;
			Ondblclick:=User6;
			OnSelectCell:=User7;
			DefaultRowHeight:=20;
			Colcount:=6;
			FixedCols:=1;
			FixedRows:=1;
			RowHeights[0]:=25;
			Options:=Options+[Gorowsizing,Gocolsizing,Gofixedcolclick,Gofixedrowclick,Godrawfocusselected,Gothumbtracking,
				Gofixedhottrack,Gorowselect,Gotabs];
			DrawingStyle:=Tgriddrawingstyle(Na(SFR1(14)));
			GradientStartColor:=Getcolor(SFR1(15));
			GradientEndColor:=Getcolor(SFR1(16));
			FixedColor:=Getcolor(SFR1(17));
			BidiMode:=AOwner.BidiMode;
			Gr1('35,75,80,70,100,120,25,37,1,1,48,49',',');
			for I:=1 to 6 do begin
				ColWidths[I-1]:=Na(S1[I]);
				Cells[I-1,0]:=SFL1(Na(S1[I+6]));
			end;
			Cells[2,0]:=Sfd7(4,RFC);
			Cells[3,0]:=Sfd7(3,RFC);
			if (Nu2>0) then begin
				RowCount:=FixedRows+Nu2;
				for I:=Nu2 downto 1 do begin
					Cells[0,I]:=I.ToString;
					Cells[1,I]:=FQ[8].Fields[0].AsString;
					Cells[2,I]:=FQ[8].Fields[1].AsString;
					Cells[3,I]:=FQ[8].Fields[2].AsString;
					Gr0(NToDt(FQ[8].Fields[3].AsString,C1,C2),'|');
					Cells[4,I]:=S0[1];
					Cells[5,I]:=Formatdatetime(' ZZZ tt ',Strtotime(S0[2]));
					FQ[8].Next;
				end;
				LBS.Caption:=Cells[3,0]+' = '+Cells[3,1];
				Hi:=0;
				if (Nu2<11) then begin
					Height:=20+(20*(Nu2+1));
					Hi:=250-Height;
					Gb.Height:=Gb.Height-Hi;
					LBS.Top:=LBS.Top-Hi;
					STNF.Height:=STNF.Height-Hi;
				end;
				with TImage.Create(Self) do begin
					Parent:=Self;
					AutoSize:=False;
					SetBounds(450,300-Hi,65,65);
					Stretch:=True;
					Transparent:=True;
					Picture.Icon.Handle:=Sic1(10);
				end;
				Row:=FixedRows;
				Refresh;
				Psn1(5);
				Self.Show;
				STNF.ActiveControl:=SG;
				STNF.ShowModal;
			end;
		end;
		Free;
	except
		on E:Exception do ShowMessage('STG'+#13+E.ToString);
	end;
end;

procedure TSTG.User5(Sender:TObject;var Key:Char);
begin
	if (Ord(Key)=Vk_escape) then begin
		STNF.Close;
	end;
	if (Ord(Key)=Vk_return) then begin
		if (SG.RowCount<>0) then begin
			SGA.SJ.Cells[SGA.SJ.Col,SGA.SJ.Row]:=SG.Cells[3,SG.Row];
		end;
		STNF.Close;
	end;
end;

procedure TSTG.User6(Sender:TObject);
begin
	TSGA.Create(Self,Na(SG.Cells[SG.FixedCols,SG.Row]),TRFC,TST,'0',1);
end;

procedure TSTG.User7(Sender:TObject;ACol,ARow:Integer;var CanSelect:Boolean);
begin
	LBS.Caption:=SG.Cells[3,0]+' = '+SG.Cells[3,ARow];
end;

/// //////////////////////////               TSTG                   /////////////////////////////
constructor TSTA.Create(AOwner:TSGA;INV:string);
var
	T,Cot:Integer;
	C1,C2:Extended;
begin
	inherited Create(AOwner);
	try
		TINV:=INV;
		TRFC:=AOwner.TRFC;
		TST:=AOwner.TST;
		FQ[7].Open('SELECT CONT,US,US1,ST1,STAT,DATE,SA FROM EDT WHERE ST = "'+TST+'" AND ICODE = "'+INV+'" AND RIF = "'
			+TRFC+'"');
		Cot:=FQ[7].RowsAffected;
		if (Cot>0) then begin
			STNF:=TForm.Create(Self);
			with STNF do begin
				Parent:=nil;
				BorderStyle:=BsDialog;
				BorderIcons:=[BiSystemMenu,BiMinimize,BiMaximize];
				BidiMode:=AOwner.BidiMode;
				Position:=PoScreenCenter;
				Font:=AOwner.Font;
				Tag:=1;
				Width:=1015;
				Height:=438;
				Icon:=Application.Icon;
				Caption:='   '+SFL1(42)+' '+Dtl1(TRFC)+' - '+SFL1(25)+' '+INV+'   ';
				TabStop:=False;
				Color:=AOwner.Color;
			end;
			Parent:=STNF;
			SGA:=AOwner;
			TB[1]:=TToolBar.Create(Self);
			with TB[1] do begin
				Parent:=Self;
				Align:=Albottom;
				Height:=27;
				AlignWithMargins:=True;
				Allowtextbuttons:=True;
				DrawingStyle:=Ttbdrawingstyle(1);
				GradientStartColor:=Getcolor(SFR1(15));
				GradientEndColor:=Getcolor(SFR1(16));
				Edgeborders:=[Ebleft,Ebtop,Ebright,Ebbottom];
			end;
			SG:=TSG.Create(Self);
			Adh:=TADHK.Create(Self,TB[1],SG);
			with SG do begin
				Parent:=Self;
				Align:=Alclient;
				AlignWithMargins:=True;
				Font:=AOwner.Font;
				Color:=Clwindow;
				Anchors:=[AkLeft,AkTop,AkRight,Akbottom];
				SetBounds(5,5,1000,390);
				ColButton.OnClick:=SGB;
				OnTopLeftChanged:=SGTLC;
				OnMouseMove:=SGMMove;
				DefaultRowHeight:=20;
				Colcount:=9;
				FixedCols:=1;
				FixedRows:=1;
				RowHeights[0]:=25;
				Options:=Options+[Godrawfocusselected,Gorowsizing,Gocolsizing,Gorowselect,Gothumbtracking,Gofixedcolclick,
					Gofixedrowclick,Gofixedhottrack];
				DrawingStyle:=Tgriddrawingstyle(Na(SFR1(14)));
				GradientStartColor:=Getcolor(SFR1(15));
				GradientEndColor:=Getcolor(SFR1(16));
				FixedColor:=Getcolor(SFR1(17));
				BidiMode:=TbidiMode(1);
				Gr0('50,120,120,120,120,80,110,130,120,25,16,40,71,72,42,48,49,50',',');
				for T:=0 to 8 do begin
					ColWidths[T]:=Na(S0[T+1]);
					Cells[T,0]:=SFL1(Na(S0[T+10]));
				end;
				RowCount:=FixedRows+Cot;
				for T:=1 to Cot do begin
					Cells[0,T]:=FQ[7].Fields[0].AsString;
					Cells[1,T]:=SFU1(FQ[7].Fields[1].AsInteger,'UserN');
					Cells[2,T]:=Sfst1(TST);
					Cells[3,T]:=SFU1(FQ[7].Fields[2].AsInteger,'UserN');
					Cells[4,T]:=Sfst1(FQ[7].Fields[3].AsString);
					case FQ[7].Fields[4].AsInteger of
						1:Cells[5,T]:=SFL1(68);
						2:Cells[5,T]:=SFL1(69);
					end;
					Gr0(NToDt(FQ[7].Fields[5].AsString,C1,C2),'|');
					Cells[6,T]:=S0[1];
					Cells[7,T]:=Formatdatetime(' ZZZ tt ',Strtotime(S0[2]));
					Cells[8,T]:=FQ[7].Fields[6].AsString;
					FQ[7].Next;
				end;
				Row:=FixedRows;
				OnKeyPress:=User10;
				Ondblclick:=User11;
				if (Cot<18) then begin
					STNF.Height:=105+(Cot*21);
					Height:=30+(Cot*21);
				end;
			end;
			SGTLC(SG);
			Show;
			Psn1(5);
			STNF.ShowModal;
		end;
		Free;
	except
		on E:Exception do ShowMessage('STA'+#13+E.ToString);
	end;
end;

procedure TSTA.User10(Sender:TObject;var Key:Char);
begin
	if (Ord(Key)=Vk_escape) then begin
		STNF.Close;
	end;
	if (Ord(Key)=Vk_return) then begin
		TSGA.Create(Self,Na(TINV),TRFC,TST,'0',3,Na(SG.Cells[0,SG.Row]));
	end;
end;

procedure TSTA.User11(Sender:TObject);
begin
	TSGA.Create(Self,Na(TINV),TRFC,TST,'0',3,Na(SG.Cells[0,SG.Row]));
end;

/// //////////////////////////               TSTN                   /////////////////////////////
constructor TSTN.Create(AOwner:TSGA);
var
	O,T,Cot,Ch:Integer;
	C1,C2:Extended;
	Rf,Cc,RFC,ST1:string;
begin
	inherited Create(AOwner);
	try
		RFC:=AOwner.TRFC;
		ST1:=AOwner.TST;
		if (AOwner.CCID.ItemIndex=-1) then begin
			SBO1;
			AOwner.CCNA.Sbo(Tti_error_large,SFL1(87),SFL1(38),AOwner.CCNA.ClientRect,2);
			AOwner.CCNA.Setfocus;
			Exit;
		end else begin
			Cc:=AOwner.CCID.Items[AOwner.CCID.ItemIndex];
			TCC:=Cc;
		end;
		Rf:=Sfd7(7,RFC);
		case Na(RFC) of
			3:RFC:='1';
			4:RFC:='2';
		end;
		TRFC:=RFC;
		TST:=ST1;
		O:=Dtn1(RFC);
		FQ[O].Open('SELECT US,ICODE,SN,SA,DAT,COMM FROM '+Dtm1(RFC)+' WHERE ST = "'+ST1+'" AND FRM = "'+Cc+'"');
		Cot:=FQ[O].RowsAffected;
		if (Cot>0) then begin
			STNF:=TForm.Create(Self);
			with STNF do begin
				Parent:=nil;
				BorderStyle:=BsSizeable; // BsDialog;
				BorderIcons:=[BiSystemMenu,BiMinimize,BiMaximize];
				BidiMode:=AOwner.BidiMode;
				Position:=PoScreenCenter;
				Font:=AOwner.Font;
				Tag:=1;
				Width:=1015;
				Height:=438;
				Icon:=Application.Icon;
				Caption:='   '+Rf+' -  [ '+Sfcc1(Cc)+' ]   ';
				TabStop:=False;
				Color:=AOwner.Color;
			end;
			Parent:=STNF;
			SGA:=AOwner;
			with TLabel.Create(Self) do begin
				Parent:=Self;
				AutoSize:=False;
				Align:=Albottom;
				Caption:=SFL1(133);
				Ch:=Canvas.Textheight(Caption)+3;
				Height:=Ch;
				Alignment:=TaCenter;
			end;
			TB[1]:=TToolBar.Create(Self);
			with TB[1] do begin
				Parent:=Self;
				Align:=Albottom;
				Height:=27;
				AlignWithMargins:=True;
				Allowtextbuttons:=True;
				DrawingStyle:=Ttbdrawingstyle(1);
				GradientStartColor:=Getcolor(SFR1(15));
				GradientEndColor:=Getcolor(SFR1(16));
				Edgeborders:=[Ebleft,Ebtop,Ebright,Ebbottom];
			end;
			SG:=TSG.Create(Self);
			Adh:=TADHK.Create(Self,TB[1],SG);
			with SG do begin
				Align:=Alclient;
				AlignWithMargins:=True;
				Parent:=Self;
				Font:=AOwner.Font;
				Color:=Clwindow;
				Anchors:=[AkLeft,AkTop,AkRight,Akbottom];
				SetBounds(5,5,1000,390);
				ColButton.OnClick:=SGB;
				OnTopLeftChanged:=SGTLC;
				OnMouseMove:=SGMMove;
				DefaultRowHeight:=20;
				Colcount:=10;
				FixedCols:=1;
				FixedRows:=1;
				// GoRangeSelect, Options+
				Options:=[Godrawfocusselected,Gorowsizing,Gocolsizing,Gofixedcolclick,Gorowselect,Gothumbtracking,
					Gofixedrowclick,Gofixedhottrack];
				DrawingStyle:=Tgriddrawingstyle(Na(SFR1(14)));
				GradientStartColor:=Getcolor(SFR1(15));
				GradientEndColor:=Getcolor(SFR1(16));
				FixedColor:=Getcolor(SFR1(17));
				BidiMode:=TbidiMode(1);
				Gr0('50,80,105,105,105,105,90,120,210,25,37,16,40,39,50,48,49,41',',');
				for T:=0 to 8 do begin
					ColWidths[T]:=Na(S0[T+1]);
					Cells[T,0]:=SFL1(Na(S0[T+10]));
				end;
				RowCount:=FixedRows+Cot;
				for T:=1 to Cot do begin
					Cells[0,T]:=T.ToString;
					Cells[1,T]:=FQ[O].Fields[1].AsString;
					Cells[2,T]:=SFU1(FQ[O].Fields[0].AsInteger,'UserN');
					Cells[3,T]:=Sfst1(ST1);
					Cells[4,T]:=SFSN1(FQ[O].Fields[2].AsString);
					Cells[5,T]:=FQ[O].Fields[3].AsString;
					Gr0(NToDt(FQ[O].Fields[4].AsString,C1,C2),'|');
					Cells[6,T]:=S0[1];
					Cells[7,T]:=Formatdatetime(' ZZZ tt ',Strtotime(S0[2]));
					Cells[8,T]:=FQ[O].Fields[5].AsString;
					Rows[T].Tag:=0;
					FQ[O].Next;
				end;
				Row:=FixedRows;
				OnFixedCellClick:=SGFixedCellClick;
				OnKeyPress:=User13;
				Ondblclick:=User6;
				// OnMouseDown:=Amcmdown;
				OnMouseLeave:=AmcmLEAVE;
				Amdc.Sourcehandle:=SG;
				Amdc.RFC:=TRFC;
				if (Cot<18) then begin
					STNF.Height:=105+Ch+(Cot*21);
					Height:=30+(Cot*21);
				end;
			end;

			{ with TDROPDUMMY.Create(SG) DO BEGIN
				ShowImage:=True;
				Register(SG);
				END; }
			// AMDT.Register(SG);
			SGTLC(SG);
			Psn1(5);
			Self.Show;
			STNF.ShowModal;
		end else begin
			Msg1(AOwner,Rf,SFL1(87),SFL1(93),3,SFL1(3),1,'',Bu);
		end;
		Free;
	except
		on E:Exception do ShowMessage('TSTN.Create  '+E.ToString);
	end;
end;

procedure TSTN.User6(Sender:TObject);
begin
	TSGA.Create(Self,Na(SG.Cells[SG.FixedCols,SG.Row]),TRFC,TST,'0',1);
end;

procedure TSTN.User13(Sender:TObject;var Key:Char);
begin
	if (Ord(Key)=Vk_escape) then STNF.Close;
	if (Ord(Key)=Vk_return) then begin
		if (SGA.SJ.RowCount<>0) then SGA.SJ.Cells[SGA.SJ.Col,SGA.SJ.Row]:=SG.Cells[SG.FixedCols,SG.Row];
		STNF.Close;
	end;
end;

procedure TSTN.AmcmLEAVE(Sender:TObject);
begin
	///
end;

procedure TSTN.Amcmdown(Sender:TObject;Button:TMouseButton;Shift:TShiftState;X,Y:Integer);
var
	I,O:Integer;
	Ki,ext:string;
begin
	if (Button=Mbmiddle) then begin // (DragDetectPlus(SG))and  E:\PRO\Win32\Release\Sources\
		SG.Perform(Wm_lbuttonup,0,Makelparam(X,Y));

	END;
end;

procedure TSTN.SGFixedCellClick(Sender:TObject;ACol,ARow:Integer);
var
	I:Integer;
begin
	if SG.EnableCheckBoxes then begin
		if (ACol=0)and(ARow>0) then
			if SG.Rows[ARow].Tag=0 then SG.Rows[ARow].Tag:=1
			else SG.Rows[ARow].Tag:=0;
		if (ACol=0)and(ARow=0) then begin
			if SG.Rows[0].Tag=0 then SG.Rows[0].Tag:=1
			else SG.Rows[0].Tag:=0;
			if SG.Rows[0].Tag=0 then
				for I:=1 to SG.RowCount-1 do SG.Rows[I].Tag:=0
			else
				for I:=1 to SG.RowCount-1 do SG.Rows[I].Tag:=1;
		end;
		SG.Invalidate;

	end;
end;

/// //////////////////////////               TSTSA                   /////////////////////////////
constructor TSTSA.Create(AOwner:TWinControl;ARFC,AST:string);
var
	O,T,Cot,Ch:Integer;
	C1,C2:Extended;
	Cc:string;
begin
	inherited Create(AOwner);
	try
		TRFC:=ARFC;
		TST:=AST;
		O:=Dtn1(ARFC);
		FQ[O].Open('SELECT US,ICODE,SA,DAT,COMM,ST FROM '+Dtm1(ARFC)+' WHERE ST = "'+AST+'"');
		Cot:=FQ[O].RowsAffected;
		if (Cot>0) then begin
			STNF:=TForm.Create(Self);
			with STNF do begin
				Parent:=nil;
				BorderStyle:=BsSizeable; // BsDialog;
				BorderIcons:=[BiSystemMenu,BiMinimize,BiMaximize];
				BidiMode:=AOwner.BidiMode;
				Position:=PoScreenCenter;
				Tag:=1;
				Width:=1015;
				Height:=438;
				Icon:=Application.Icon;
				Caption:='   '+' -  [  ]   '; // '+Sfcc1(Cc)+'
				TabStop:=False;
			end;
			Parent:=STNF;
			SGA:=nil;
			with TLabel.Create(Self) do begin
				Parent:=Self;
				AutoSize:=False;
				Align:=Albottom;
				Caption:=SFL1(133);
				Ch:=Canvas.Textheight(Caption)+3;
				Height:=Ch;
				Alignment:=TaCenter;
			end;
			TB[1]:=TToolBar.Create(Self);
			with TB[1] do begin
				Parent:=Self;
				Align:=Albottom;
				Height:=27;
				AlignWithMargins:=True;
				Allowtextbuttons:=True;
				DrawingStyle:=Ttbdrawingstyle(1);
				GradientStartColor:=Getcolor(SFR1(15));
				GradientEndColor:=Getcolor(SFR1(16));
				Edgeborders:=[Ebleft,Ebtop,Ebright,Ebbottom];
			end;
			with TComboBoxEx.Create(Self) do begin
				Parent:=Self;
				Align:=Altop;
				Font.Size:=9;
				Style:=TComboBoxExStyle(2);
				SetBounds(5,5,200,20);
				Text:='';
				Tag:=TRFC.Tointeger;
				TabStop:=False;
				DoubleBuffered:=True;
				OnSelect:=CBOnSelect;
				OnKeyPress:=CBOnKeyPress;
				OnKeyDown:=AMDF.Cokeydown;
				Images:=AMDF.AMD;
				SendMessage(Handle,Cb_setdroppedwidth,Na(SFR1(29)),0);
				SendMessage(SendMessage(Handle,Cbem_geteditcontrol,0,0),EM_Setmargins,Ec_leftmargin or Ec_rightmargin,
					Makelong(5,5));
				FQ[2].Open('SELECT '+Lan+' FROM DOCM');
				if (FQ[2].RowsAffected>0) then begin
					for T:=1 to FQ[2].RowsAffected do begin
						Itemsex.Additem(FQ[2].Fields[0].AsString,T,T,-1,-1,nil);
						FQ[2].Next;
					end;
				end;
				ItemIndex:=0;
			end;
			SG:=TSG.Create(Self);
			Adh:=TADHK.Create(Self,TB[1],SG);
			with SG do begin
				Align:=Alclient;
				AlignWithMargins:=True;
				Parent:=Self;
				Color:=Clwindow;
				Anchors:=[AkLeft,AkTop,AkRight,Akbottom];
				SetBounds(5,5,1000,390);
				ColButton.OnClick:=SGB;
				OnTopLeftChanged:=SGTLC;
				OnMouseMove:=SGMMove;
				DefaultRowHeight:=20;
				Colcount:=10;
				FixedCols:=2;
				FixedRows:=1;
				EnableCheckBoxes:=True;
				ColWidths[0]:=20;
				RowHeights[0]:=25;
				Rows[0].Tag:=0; // GoRangeSelect,Options+ ,Gorowsizing
				Options:=[Godrawfocusselected,Gocolsizing,Gothumbtracking,Gofixedcolclick,Gorowselect,Gofixedrowclick,
					Gofixedhottrack];
				DrawingStyle:=Tgriddrawingstyle(Na(SFR1(14)));
				GradientStartColor:=Getcolor(SFR1(15));
				GradientEndColor:=Getcolor(SFR1(16));
				FixedColor:=Getcolor(SFR1(17));
				BidiMode:=TbidiMode(1);
				Gr0('50,80,105,105,105,90,120,210,25,37,16,40,50,48,49,41',',');
				for T:=1 to 8 do begin
					ColWidths[T]:=Na(S0[T]);
					Cells[T,0]:=SFL1(Na(S0[T+8]));
				end;
				RowCount:=FixedRows+Cot;
				for T:=1 to Cot do begin
					Cells[1,T]:=T.ToString;
					Cells[2,T]:=FQ[O].Fields[1].AsString;
					Cells[3,T]:=SFU1(FQ[O].Fields[0].AsInteger,'UserN');
					Cells[4,T]:=Sfst1(TST);
					Cells[5,T]:=FQ[O].Fields[2].AsString;
					Gr0(NToDt(FQ[O].Fields[3].AsString,C1,C2),'|');
					Cells[6,T]:=S0[1];
					Cells[7,T]:=Formatdatetime(' ZZZ tt ',Strtotime(S0[2]));
					Cells[8,T]:=FQ[O].Fields[4].AsString;
					Rows[T].Tag:=0;
					Rows[T].RFC:=TRFC.Tointeger;
					Rows[T].ST:=FQ[O].Fields[5].AsInteger;
					Rows[T].NUM:=FQ[O].Fields[1].AsInteger;
					FQ[O].Next;
				end;
				Row:=FixedRows;
				OnFixedCellClick:=SGFixedCellClick;
				OnKeyPress:=User13;
				Ondblclick:=User6;
				OnMouseDown:=Amcmdown;
				OnMouseLeave:=AmcmLEAVE;
				OnMouseMove:=AmcmMove;
				Amdc.Sourcehandle:=SG;
				Amdc.RFC:=TRFC;
				OnGetDragImage:=OnGetDragImage1;
				if (Cot<18) then begin
					STNF.Height:=105+Ch+(Cot*21);
					Height:=30+(Cot*21);
				end;
			end;

			with TDROPDUMMY.Create(SG) DO BEGIN
				ShowImage:=True;
				Register(SG);
			END;
			// AMDT.Register(SG);
			SGTLC(SG);
			Psn1(5);
			Self.Show;
			STNF.ShowModal;
		end else begin
			Msg1(AOwner,'',SFL1(87),SFL1(93),3,SFL1(3),1,'',Bu);
		end;
		Free;
	except
		on E:Exception do ShowMessage('TSTSA.Create  '+E.ToString);
	end;
end;

procedure TSTSA.OnGetDragImage1(Sender:TObject;var shDragImage:PShDragImage);
	function GetRGBColor(Value:Tcolor):DWORD;
	begin
		Result:=ColorToRGB(Value);
		case Result of
			clNone:Result:=CLR_NONE;
			clDefault:Result:=CLR_DEFAULT;
		end;
	end;
	function DestRect(L,T,DRW,DRH,BMW,BMH,MRW,MRH:Integer):TRect;
	var
		W,H,Cw,Ch:Integer;
		xyaspect:Double;
	begin
		Cw:=DRW;
		Ch:=DRH;
		W:=BMW;
		H:=BMH;
		if (((W>Cw)or(H>Ch))) then begin
			if (W>0)and(H>0) then begin
				xyaspect:=W/H;
				if W>H then begin
					W:=Cw;
					H:=Trunc(Cw/xyaspect);
					if H>Ch then // woops, too big
					begin
						H:=Ch;
						W:=Trunc(Ch*xyaspect);
					end;
				end else begin
					H:=Ch;
					W:=Trunc(Ch*xyaspect);
					if W>Cw then // woops, too big
					begin
						W:=Cw;
						H:=Trunc(Cw/xyaspect);
					end;
				end;
			end else begin
				W:=Cw;
				H:=Ch;
			end;
		end;

		with Result do begin
			Left:=L;
			Top:=T;
			Right:=W-MRW;
			Bottom:=H-MRH;
		end;

		// if Center then
		Offsetrect(Result,(Cw-W)div 2,(Ch-H)div 2);
	end;

var
	Pt:TPoint;
	GG:Cardinal;
	DragBitmap,bmm:Tbitmap;
	ImageHotSpotX,ImageHotSpotY:Integer;
	I,L,MR,MR1,Tw,TH,W,H,BW,BH,MRW,MRH,CNT:Integer;
	R:TRect;
	S:string;
	SM:TSTREAM;
begin
	DragBitmap:=Tbitmap.Create;
	try
		CNT:=SG.DragImagesCount;
		if CNT>6 then CNT:=6;
		DragBitmap.Pixelformat:=Vcl.Graphics.pfDevice;
		DragBitmap.AlphaFormat:=Vcl.Graphics.afDefined;
		ImageHotSpotX:=128 DIV 2;
		ImageHotSpotY:=(128 DIV 4)*3;
		W:=96;
		H:=96;
		DragBitmap.Setsize(W,H);
		DragBitmap.Canvas.Fillrect(DragBitmap.Canvas.Cliprect);
		DragBitmap.Canvas.Brush.Color:=clNone;
		DragBitmap.Canvas.Fillrect(DragBitmap.Canvas.Cliprect);
		MR:=1;
		MR1:=3;
		FQ[11].Open('SELECT THU FROM STHUM WHERE ICODE IN ('+Amdc.FdFiles.Commatext+') AND RFC="'+TRFC+'" AND ST="'+TST+
			'" LIMIT '+CNT.ToString);
		for I:=1 to CNT do begin
			bmm:=Tbitmap.Create;
			bmm.Pixelformat:=Vcl.Graphics.pfDevice;
			bmm.AlphaFormat:=Vcl.Graphics.afDefined;
			bmm.Canvas.Fillrect(bmm.Canvas.Cliprect);
			bmm.Transparent:=True;
			SM:=FQ[11].CreateBlobStream(FQ[11].FieldByName('THU'),bmRead);
			bmm.LoadFromStream(SM);
			FQ[11].Next;
			SM.Free;
			BW:=bmm.Width;
			BH:=bmm.Height;
			MRW:=(CNT-I)*2;
			MRH:=(CNT-I)*MR1;
			bmm.Canvas.Brush.Color:=Clblack;
			bmm.Canvas.Fillrect(Rect(0,0,MR,bmm.Height));
			bmm.Canvas.Fillrect(Rect(0,0,bmm.Width,MR));
			bmm.Canvas.Fillrect(Rect(bmm.Width-MR,0,bmm.Width,bmm.Height));
			bmm.Canvas.Fillrect(Rect(0,bmm.Height-MR,bmm.Width,bmm.Height));
			DragBitmap.Canvas.StretchDraw(DestRect(I*2,I*MR1,W,H,BW,BH,MRW,MRH),bmm);
			bmm.Free;
		end;
		DragBitmap.Canvas.Font.Name:='Arial';
		DragBitmap.Canvas.Font.Style:=DragBitmap.Canvas.Font.Style+[Fsbold];
		DragBitmap.Canvas.Font.Color:=Clwhite;
		DragBitmap.Canvas.Font.Size:=10;
		S:=' '+SG.DragImagesCount.ToString+' ';
		L:=Length(S);
		TH:=DragBitmap.Canvas.Textheight(S);
		Tw:=DragBitmap.Canvas.Textwidth(S);
		R.Width:=Tw;
		R.Height:=TH;
		R.Left:=ROUND((W-Tw)/2);
		R.Top:=ROUND((H-TH)/2);
		DragBitmap.Canvas.Brush.Color:=Clhighlight;
		DrawTextEx(DragBitmap.Canvas.Handle,Pchar(S),L,R,DT_NOCLIP,nil);
		MR:=1;
		DragBitmap.Canvas.Brush.Color:=Clwhite;
		DragBitmap.Canvas.Fillrect(Rect(R.Left-1,R.Top,R.Left+Tw+1,R.Top+MR));
		DragBitmap.Canvas.Fillrect(Rect(R.Left-1,R.Top,R.Left+MR-1,R.Top+TH));
		DragBitmap.Canvas.Fillrect(Rect(R.Left+Tw-MR+1,R.Top,R.Left+Tw+1,R.Top+TH));
		DragBitmap.Canvas.Fillrect(Rect(R.Left-1,R.Top+TH-MR,R.Left+Tw+1,R.Top+TH));
		shDragImage.crColorKey:=GetRGBColor(clRed);
		shDragImage.sizeDragImage.Cx:=W;
		shDragImage.sizeDragImage.cy:=H;
		shDragImage.ptOffset.X:=ImageHotSpotX;
		shDragImage.ptOffset.Y:=ImageHotSpotY;
		shDragImage.hbmpDragImage:=DragBitmap.Releasehandle;
	finally DragBitmap.Free;
	end;
end;

procedure TSTSA.User6(Sender:TObject);
begin
	TSGA.Create(Self,Na(SG.Cells[SG.FixedCols,SG.Row]),TRFC,TST,'0',1);
end;

procedure TSTSA.User13(Sender:TObject;var Key:Char);
begin
	if (Ord(Key)=Vk_escape) then STNF.Close;
end;

procedure TSTSA.AmcmLEAVE(Sender:TObject);
begin
	///
end;

procedure TSTSA.AmcmMove(Sender:TObject;Shift:TShiftState;X,Y:Integer);
var
	I,O,Cl,Ro:Integer;
BEGIN
	SG.Mousetocell(X,Y,Cl,Ro);
	if (Ro>SG.FixedRows-1)and(SG.Rows[Ro].Tag=1) then SG.Cursor:=crHandPoint
	else SG.Cursor:=SG.SGCURSOR;
end;

procedure TSTSA.Amcmdown(Sender:TObject;Button:TMouseButton;Shift:TShiftState;X,Y:Integer);
var
	I,O,Cl,Ro:Integer;
	Ki,ext,RFC:string;
begin
	SG.Mousetocell(X,Y,Cl,Ro);
	if (Button=MbLEFT)and(Cl>SG.FixedCols-1)and(Ro>SG.FixedRows-1) then begin // (DragDetectPlus(SG))and    Dtk1
		SG.Perform(Wm_lbuttonup,0,Makelparam(X,Y));
		Amdc.FdFiles.Clear;
		Amdc.FileStream.FileNames.Clear;
		O:=0;
		for I:=SG.FixedRows to SG.RowCount-1 do begin
			if not(SG.Rows[I].Tag=0) then begin
				O:=O+1;
				RFC:=SG.Rows[I].RFC.ToString;
				Ki:=Dtl1(RFC);
				ext:=DTEX1(RFC);
				Amdc.FileStream.FileNames.Add(Ki+SG.Cells[SG.FixedCols,I]+'.'+ext);
				Amdc.FdFiles.Add(SG.Cells[SG.FixedCols,I]);
			end;
		end;
		SG.DragImagesCount:=Amdc.FileStream.FileNames.Count;
		if O>0 then Amdc.Execute(True);
	END;
end;

procedure TSTSA.SGFixedCellClick(Sender:TObject;ACol,ARow:Integer);
var
	I:Integer;
begin
	if SG.EnableCheckBoxes then begin
		if (ACol=0)and(ARow>0) then
			if SG.Rows[ARow].Tag=0 then SG.Rows[ARow].Tag:=1
			else SG.Rows[ARow].Tag:=0;
		if (ACol=0)and(ARow=0) then begin
			if SG.Rows[0].Tag=0 then SG.Rows[0].Tag:=1
			else SG.Rows[0].Tag:=0;
			if SG.Rows[0].Tag=0 then
				for I:=1 to SG.RowCount-1 do SG.Rows[I].Tag:=0
			else
				for I:=1 to SG.RowCount-1 do SG.Rows[I].Tag:=1;
		end;
		SG.Invalidate;
	end;
end;

procedure TSTSA.CBOnSelect(Sender:TObject);
var
	Key:Char;
begin
	Key:=#13;
	CBOnKeyPress(Sender,Key);
end;

procedure TSTSA.CBOnKeyPress(Sender:TObject;var Key:Char);
var
	R:TComboBoxEx;
	O,I,Cot,T:Integer;
	C1,C2:Extended;
begin
	R:=TComboBoxEx(Sender);
	if (Ord(Key)=Vk_return) then begin
		Key:=#0;
		try
			TRFC:=(R.ItemIndex+1).ToString;
			IF (R.Tag.ToString=TRFC) THEN Exit;
			R.Tag:=TRFC.Tointeger;
			O:=Dtn1(TRFC);
			FQ[O].Open('SELECT US,ICODE,SA,DAT,COMM,ST FROM '+Dtm1(TRFC)+' WHERE ST = "'+TST+'"');
			Cot:=FQ[O].RowsAffected;
			SG.RowCount:=SG.FixedRows+1;
			if (Cot>0) then begin
				WITH SG DO begin
					SG.Rows[0].Tag:=0;
					RowCount:=FixedRows+Cot;
					for T:=1 to Cot do begin
						Cells[1,T]:=T.ToString;
						Cells[2,T]:=FQ[O].Fields[1].AsString;
						Cells[3,T]:=SFU1(FQ[O].Fields[0].AsInteger,'UserN');
						Cells[4,T]:=Sfst1(TST);
						Cells[5,T]:=FQ[O].Fields[2].AsString;
						Gr0(NToDt(FQ[O].Fields[3].AsString,C1,C2),'|');
						Cells[6,T]:=S0[1];
						Cells[7,T]:=Formatdatetime(' ZZZ tt ',Strtotime(S0[2]));
						Cells[8,T]:=FQ[O].Fields[4].AsString;
						Rows[T].Tag:=0;
						Rows[T].RFC:=TRFC.Tointeger;
						Rows[T].ST:=FQ[O].Fields[5].AsInteger;
						Rows[T].NUM:=FQ[O].Fields[1].AsInteger;
						FQ[O].Next;
					end;
					Row:=FixedRows;
					SGTLC(SG);
				end;
			end
			else SG.Rows[SG.FixedRows].Clear;
		except

		end;
	end;
end;

/// //////////////////////////               TSGAW                  /////////////////////////////
constructor TSGAW.Create(AOwner:TSGA;C:Integer;N1,T1,C1,R1,T2:TStringList);
begin
	inherited Create(AOwner);
	AOwner.SGAW:=Self;
	try
		if (C>0) then begin
			STNF:=TForm.Create(Self);
			with STNF do begin
				Parent:=nil;
				BorderStyle:=BsSizeable;
				BorderIcons:=[BiSystemMenu,BiMinimize,BiMaximize];
				BidiMode:=AOwner.BidiMode;
				Position:=PoScreenCenter;
				Font:=AOwner.Font;
				FormStyle:=FsStayOnTop;
				Width:=1050;
				Height:=638;
				Icon:=Application.Icon;
				Caption:='   '+SFL1(79)+' :  [ '+C.ToString+' ]   ';
				TabStop:=False;
				Color:=AOwner.Color;
				Onclose:=SCLOSE;
			end;
			Parent:=STNF;
			Align:=Alclient;
			SGA:=AOwner;
			TB[1]:=TToolBar.Create(Self);
			with TB[1] do begin
				Parent:=Self;
				Align:=Albottom;
				Height:=27;
				AlignWithMargins:=True;
				Allowtextbuttons:=True;
				DrawingStyle:=Ttbdrawingstyle(1);
				GradientStartColor:=Getcolor(SFR1(15));
				GradientEndColor:=Getcolor(SFR1(16));
				Edgeborders:=[Ebleft,Ebtop,Ebright,Ebbottom];
			end;
			Adh:=TADHK.Create(Self,TB[1],SG);
			MO:=TMemo.Create(Self);
			with MO do begin
				Align:=Albottom;
				AlignWithMargins:=True;
				Parent:=Self;
				Height:=200;
				readOnly:=True;
				Font.Style:=Font.Style+[Fsbold];
				Wordwrap:=True;
			end;
			SG:=TSG.Create(Self);
			with SG do begin
				Align:=Alclient;
				AlignWithMargins:=True;
				Parent:=Self;
				Color:=Clwindow;
				SetBounds(5,5,1000,390);
				BidiMode:=TbidiMode(1);
				Font.Color:=ClBlue;
				ColButton.OnClick:=SGB;
				OnTopLeftChanged:=SGTLC;
				OnSelectCell:=SCELL;
				OnMouseMove:=SGMMove;
				Options:=Options+[Godrawfocusselected,Gorowsizing,Gocolsizing,Gorowselect,Gothumbtracking,Gofixedcolclick,
					Gofixedrowclick,Gofixedhottrack];
				DefaultRowHeight:=20;
				DrawingStyle:=Tgriddrawingstyle(Na(SFR1(14)));
				GradientStartColor:=Getcolor(SFR1(15));
				GradientEndColor:=Getcolor(SFR1(16));
				FixedColor:=Getcolor(SFR1(17));
				Colcount:=5;
				FixedCols:=1;
				FixedRows:=1;
				RowCount:=FixedRows+C;
				RowHeights[0]:=25;
				ColWidths[0]:=50;
				ColWidths[1]:=280;
				ColWidths[2]:=60;
				ColWidths[3]:=60;
				ColWidths[4]:=550;
				Row:=FixedRows;
				{ if (COT<18) then begin
					STNF.Height:=110+(COT*21);
					Height:=30+(COT*21);
					end; }
				Refresh;
				Self.Show;
				SGTLC(SG);
				Psn1(5);
				STNF.Show;
				Cols[0].Assign(N1);
				Cols[1].Assign(T1);
				Cols[2].Assign(C1);
				Cols[3].Assign(R1);
				Cols[4].Assign(T2);
			end;
		end;
	except
		on E:Exception do ShowMessage(E.ToString);
	end;
end;

procedure TSGAW.SCELL(Sender:TObject;ACol,ARow:Integer;var CanSelect:Boolean);
var
	SJ:TSJ;
	R1,Co1:Integer;
begin
	try
		SJ:=SGA.SJ;
		if (SJ<>nil) then begin
			SG.Bo(Application.Icon.Handle,SG.Cells[ACol,0],SG.Cells[ACol,ARow],SG.Cellrect(ACol,ARow));
			MO.Text:=SG.Cells[4,ARow];
			R1:=Na(SG.Cells[2,ARow]);
			Co1:=Na(SG.Cells[3,ARow]);
			if (R1>SJ.FixedRows-1)and(R1<SJ.RowCount)and(Co1>SJ.FixedCols-1)and(Co1<SJ.Colcount) then begin
				SJ.Row:=R1;
				SJ.Col:=Co1;
			end;
		end;
	except
		on E:Exception do
	end;
end;

procedure TSGAW.SCLOSE(Sender:TObject;var Action:TCloseAction);
begin
	Self.Owner.Insertcomponent(STNF);
	STNF.Insertcomponent(Self);
	SGA.SGAW:=nil;
	Action:=Cafree;
end;

/// //////////////////////////               TADHK                  /////////////////////////////
constructor TADHK.Create(AOwner:TSGG;AParent:TWinControl;SS:TSGDrawGrid1);
var
	I:Integer;
begin
	inherited Create(AOwner);
	ParentBackground:=True;
	SJ:=SS;
	for I:=1 to 5 do begin
		TB[I]:=TButton.Create(Self);
		with TB[I] do begin
			Parent:=AParent;
			Caption:=SFL1(I+72);
			Hint:=Caption;
			OnClick:=TBC1;
			SetBounds(0,0,90,16);
			if (I=1) then begin
				with Ttoolbutton.Create(Self) do begin
					Parent:=AParent;
					Style:=Tbsdivider;
					Caption:='|';
					Width:=10;
				end;
				ED1:=TEdit.Create(Self);
				with ED1 do begin
					Parent:=AParent;
					Alignment:=TaCenter;
					Width:=100;
					Text:='1';
					Numbersonly:=True;
					OnKeyPress:=EDC1;
				end;
				LBO1:=TLabel.Create(Self);
				with LBO1 do begin
					Parent:=AParent;
					AutoSize:=False;
					Caption:='';
					Width:=10;
				end;
			end;
			if (I=3) then begin
				with Ttoolbutton.Create(Self) do begin
					Parent:=AParent;
					Style:=Tbsdivider;
					Caption:='|';
					Width:=5;
				end;
				LBF1:=TLabel.Create(Self);
				with LBF1 do begin
					Parent:=AParent;
					AutoSize:=False;
					Alignment:=TaCenter;
					Layout:=Tlcenter;
					Caption:='';
					Width:=200;
				end;
			end;
		end;
	end;
	LBO1.Width:=710-ED1.Left;
end;

procedure TADHK.EDC1(Sender:TObject;var Key:Char);
begin
	if (Ne(ED1.Text)>0)and(Ord(Key)=Vk_return) then begin
		Key:=#0;
		if (Ne(ED1.Text)>SJ.RowCount-1) then begin
			ED1.Text:=(SJ.RowCount-1).ToString;
		end;
		SJ.Col:=1;
		SJ.Row:=Na(ED1.Text);
		SJ.Setfocus;
	end;
end;

procedure TADHK.TBC1(Sender:TObject);
var
	R:Tcontrol;
	R1,R2:Integer;
begin
	R:=Tcontrol(Sender);
	if (R=TB[1])and(Ne(ED1.Text)>0) then begin
		if (Ne(ED1.Text)>SJ.RowCount-1) then begin
			ED1.Text:=(SJ.RowCount-1).ToString;
		end;
		SJ.Row:=Na(ED1.Text);
		SJ.Setfocus;
	end;
	if (R=TB[2]) then begin
		SJ.Row:=SJ.RowCount-1;
		SJ.Setfocus;
	end;
	if (R=TB[3]) then begin
		SJ.Perform(Wm_vscroll,Sb_pagedown,0);
		Getscrollrange(SJ.Handle,Sb_vert,R1,R2);
		if (Getscrollpos(SJ.Handle,Sb_vert)=R2) then begin
			SJ.Row:=SJ.RowCount-1;
		end else begin
			SJ.Row:=SJ.TopRow;
		end;
	end;
	if (R=TB[4]) then begin
		SJ.Perform(Wm_vscroll,Sb_pageup,0);
		SJ.Row:=SJ.TopRow;
	end;
	if (R=TB[5]) then begin
		SJ.Row:=SJ.FixedRows;
		SJ.Setfocus;
	end;
end;

/// /////////////////////////                  TIPBox1                 /////////////////////////////
constructor TIPBox1.Create(AOwner:TWinControl;CA,TH,TE:string;var Reslt:string;Oln:Integer=0;Ck:Integer=0);
begin
	Reslt:='AMD_W_NO';
	inherited Createnew(AOwner);
	try
		PH:=SFR1(1);
		Parent:=nil;
		BorderStyle:=BsDialog;
		Position:=PoScreenCenter;
		Caption:='   '+CA+'   ';
		BidiMode:=AOwner.BidiMode;
		Keypreview:=True;
		Icon:=Application.Icon;
		Color:=AMDF.Color;
		Font:=AMDF.Font;
		Tag:=1;
		Width:=230;
		Height:=190;
		BorderIcons:=[];
		OnActivate:=User4;
		OnKeyPress:=User8;
		TabStop:=False;
		with TLabel.Create(Self) do begin
			Parent:=Self;
			SetBounds(10,10,200,20);
			Caption:=TE;
			AutoSize:=False;
		end;
		E:=TEdit.Create(Self);
		with E do begin
			Parent:=Self;
			Text:='';
			Texthint:=TH;
			Numbersonly:=Boolean(Oln);
			AutoSize:=False;
			Alignment:=TaCenter;
			SetBounds(10,40,200,22);
			TabOrder:=0;
			if (PH<>'')and(Ck>0) then begin
				PasswordChar:=PH[1];
			end else begin
				PasswordChar:=#0;
			end;
		end;
		BR:=TButton.Create(Self);
		with BR do begin
			Parent:=Self;
			Caption:=SFL1(14);
			ModalResult:=1;
			default:=True;
			Elevationrequired:=True;
			TabOrder:=1;
			if (Self.BidiMode=TbidiMode(1)) then begin
				SetBounds(140,100,72,23);
			end else begin
				SetBounds(65,100,72,23);
			end;
		end;
		with TButton.Create(Self) do begin
			Parent:=Self;
			Caption:=SFL1(15);
			ModalResult:=2;
			TabOrder:=2;
			if (Self.BidiMode=TbidiMode(1)) then begin
				SetBounds(65,100,72,23);
			end else begin
				SetBounds(140,100,72,23);
			end;
		end;
		if (Ck>0) then begin
			H:=TCheckBox.Create(Self);
			with H do begin
				Parent:=Self;
				SetBounds(10,70,200,20);
				Caption:=SFL1(19);
				Checked:=False;
				OnClick:=User0;
				TabOrder:=3;
			end;
		end;
		with TImage.Create(Self) do begin
			Parent:=Self;
			Center:=True;
			AlignWithMargins:=True;
			Height:=32;
			Width:=32;
			Top:=93;
			Left:=10;
			Picture.Icon.Handle:=Sic1(10);
		end;
		Psn1(5);
		ActiveControl:=E;
		if (ShowModal=1) then Reslt:=E.Text
		else Reslt:='AMD_W_NO';
		Free;
	except
		on E:Exception do begin
			Reslt:='AMD_W_NO';
			Free;
		end;
	end;
end;

procedure TIPBox1.User0(Sender:TObject);
begin
	if H.Checked then begin
		E.PasswordChar:=#0;
	end else begin
		if (PH<>'') then begin
			E.PasswordChar:=PH[1];
		end else begin
			E.PasswordChar:=#0;
		end;
	end;
end;

procedure TIPBox1.User4(Sender:TObject);
begin
	Setcursorpos(BR.ClientOrigin.X+BR.ClientRect.CenterPoint.X,BR.ClientOrigin.Y+BR.ClientRect.CenterPoint.Y);
end;

procedure TIPBox1.User8(Sender:TObject;var Key:Char);
begin
	if (Ord(Key)=Vk_escape) then begin
		Key:=#0;
		Close;
	end;
end;

/// ////////////////////////                    TIPBox2                     ////////////////////////
constructor TIPBox2.Create(AOwner:TSGA;CA:string;var RFC,ST1,INV,RG:string);
var
	I,D:Integer;
	IC:Uint64;
	Gb2:TGroupBox;
	ID:string;
begin
	INV:='0';
	TX:='';
	RFC:=AOwner.TRFC;
	ST1:=AOwner.TST;
	inherited Createnew(AOwner);
	try
		TRFC:=RFC;
		TST:=ST1;
		IC:=Rtc1(TRFC,TST);
		Parent:=nil;
		BorderStyle:=BsDialog;
		Position:=PoScreenCenter;
		Caption:='   '+CA+'   ';
		BidiMode:=AOwner.BidiMode;
		Keypreview:=True;
		Icon:=Application.Icon;
		Font:=AOwner.Font;
		Tag:=1;
		Width:=237;
		Height:=350;
		BorderIcons:=[];
		Color:=AOwner.Color;
		OnActivate:=User4;
		OnKeyPress:=User8;
		TabStop:=False;
		SGA:=AOwner;
		G1:=TGroupBox.Create(Self);
		with G1 do begin
			Parent:=Self;
			SetBounds(10,10,210,60);
			if (IC>0) then begin
				Caption:=SFL1(37)+' '+SFL1(89)+' ( 1 - '+IC.ToString+' )';
			end else begin
				Caption:=SFL1(31);
			end;
		end;
		Gb2:=TGroupBox.Create(Self);
		with Gb2 do begin
			Parent:=Self;
			SetBounds(10,80,210,200);
			Caption:=SFL1(32);
		end;
		E:=TEdit.Create(Self);
		with E do begin
			Parent:=G1;
			Text:='';
			Texthint:=SFL1(37);
			Numbersonly:=True;
			AutoSize:=False;
			Alignment:=TaCenter;
			SetBounds(10,25,190,22);
			Enabled:=Bl1(IC);
			TabOrder:=0;
			OnChange:=User9;
		end;
		H1:=TCheckBox.Create(Self);
		with H1 do begin
			Parent:=Gb2;
			SetBounds(10,20,190,20);
			Caption:=' '+SFL1(33);
			Checked:=False;
			OnClick:=User9;
			TabOrder:=1;
		end;
		C1:=TComboBoxEx.Create(Self);
		with C1 do begin
			Parent:=Gb2;
			SetBounds(10,45,190,22);
			Style:=TComboBoxExStyle(2);
			OnKeyDown:=AMDF.Cokeydown;
			OnSelect:=User9;
			OnChange:=CBChange;
			TabOrder:=2;
			Images:=AMDF.AMD;
			if Charinset(TRFC[1],['1'..'6']) then begin
				ID:=' IN (1,2,3,4,5,6)';
			end;
			if Charinset(TRFC[1],['7']) then begin
				ID:=' ="7"';
			end;
			FQ[2].Open('SELECT '+Lan+',INX FROM DOCM WHERE id'+ID);
			for I:=1 to FQ[2].RowsAffected do begin
				D:=FQ[2].Fields[1].AsInteger;
				Itemsex.Additem(FQ[2].Fields[0].AsString,D,D,-1,-1,nil);
				FQ[2].Next;
			end;
			ItemIndex:=Items.Indexof(Dtl1(TRFC));
			Enabled:=False;
		end;
		H2:=TCheckBox.Create(Self);
		with H2 do begin
			Parent:=Gb2;
			SetBounds(10,80,190,20);
			Caption:=' '+SFL1(34);
			Checked:=False;
			OnClick:=User9;
			TabOrder:=3;
		end;
		C2:=TComboBoxEx.Create(Self);
		with C2 do begin
			Parent:=Gb2;
			SetBounds(10,105,190,22);
			Style:=TComboBoxExStyle(2);
			OnKeyDown:=AMDF.Cokeydown;
			OnSelect:=User9;
			OnChange:=CBChange;
			TabOrder:=4;
			Images:=AMDF.AMD;
			FQ[2].Open('SELECT '+Lan+',INX FROM NST');
			for I:=1 to FQ[2].RowsAffected do begin
				D:=FQ[2].Fields[1].AsInteger;
				Itemsex.Additem(FQ[2].Fields[0].AsString,D,D,-1,-1,nil);
				FQ[2].Next;
			end;
			ItemIndex:=Items.Indexof(Sfst1(TST));
			Enabled:=False;
		end;
		H3:=TCheckBox.Create(Self);
		with H3 do begin
			Parent:=Gb2;
			SetBounds(10,140,190,20);
			Caption:=' '+SFL1(129);
			Checked:=False;
			OnClick:=User9;
			TabOrder:=5;
		end;
		B1:=TButton.Create(Self);
		with B1 do begin
			Parent:=Gb2;
			SetBounds(10,165,190,23);
			Caption:=SFL1(82);
			ModalResult:=0;
			default:=True;
			Elevationrequired:=True;
			TabOrder:=6;
			OnClick:=User9;
			Enabled:=False;
		end;
		BR:=TButton.Create(Self);
		with BR do begin
			Parent:=Self;
			Caption:=SFL1(14);
			ModalResult:=0;
			default:=True;
			Elevationrequired:=True;
			TabOrder:=7;
			OnClick:=User9;
			if (Self.BidiMode=TbidiMode(1)) then begin
				SetBounds(150,290,72,23);
			end else begin
				SetBounds(70,290,72,23);
			end;
		end;
		B2:=TButton.Create(Self);
		with B2 do begin
			Parent:=Self;
			Caption:=SFL1(15);
			ModalResult:=1;
			TabOrder:=8;
			OnClick:=User9;
			if (Self.BidiMode=TbidiMode(1)) then begin
				SetBounds(70,290,72,23);
			end else begin
				SetBounds(150,290,72,23);
			end;
		end;
		Psn1(5);
		if Bl1(IC) then begin
			ActiveControl:=E;
		end;
		if (ShowModal=2) then begin
			RFC:=TRFC;
			ST1:=TST;
			INV:=E.Text;
			RG:=TX;
		end;
		Free;
	except
		on E:Exception do ShowMessage('TIPBOX2'+#13+E.ToString);
	end;
end;

procedure TIPBox2.User4(Sender:TObject);
begin
	Setcursorpos(BR.ClientOrigin.X+BR.ClientRect.CenterPoint.X,BR.ClientOrigin.Y+BR.ClientRect.CenterPoint.Y);
end;

procedure TIPBox2.User8(Sender:TObject;var Key:Char);
begin
	if (Ord(Key)=Vk_escape) then begin
		Key:=#0;
		Close;
	end;
end;

procedure TIPBox2.User9(Sender:TObject);
var
	N1,N2,IC:Integer;
begin
	IC:=Rtc1(TRFC,TST);
	SBO1;
	try
		if (C1.ItemIndex>-1) then N1:=C1.ItemIndex+1
		else N1:=-1;
		if (C2.ItemIndex>-1) then N2:=C2.ItemIndex+1
		else N2:=-1;
	except
		on E1:Exception do ShowMessage('User9 '+E.ToString);
	end;
	if (Sender=C1) then TRFC:=N1.ToString;
	IC:=Rtc1(TRFC,TST);
	if (IC=0) then begin
		E.Enabled:=False;
		G1.Caption:=SFL1(31);
	end else begin
		E.Enabled:=True;
		G1.Caption:=SFL1(37)+' '+SFL1(89)+' ( 1 - '+Rtc1(TRFC,TST).ToString+' )';
	end;
	if (Sender=C2) then begin
		TST:=N2.ToString;
		IC:=Rtc1(TRFC,TST);
		if (IC=0) then begin
			E.Enabled:=False;
			G1.Caption:=SFL1(31);
		end else begin
			E.Enabled:=True;
			G1.Caption:=SFL1(37)+' '+SFL1(89)+' ( 1 - '+Rtc1(TRFC,TST).ToString+' )';
		end;
	end;
	if (Sender=H1) then C1.Enabled:=H1.Checked;
	if (Sender=H2) then C2.Enabled:=H2.Checked;
	if (Sender=H3) then B1.Enabled:=H3.Checked;
	if (Sender=BR) then
		if (Na(E.Text)<=IC)and(Na(E.Text)>0) then begin
			Close;
		end else begin
			E.Sbo(Tti_error_large,SFL1(90),SFL1(37)+' '+SFL1(89)+' ( 1 - '+IC.ToString+' )',E.ClientRect,2);
			E.Setfocus;
		end;
	if (Sender=B1) then
		if (Na(E.Text)<=IC)and(Na(E.Text)>0) then begin
			TSGA.Create(Self,Na(E.Text),TRFC,TST,'0',2);
		end else begin
			E.Sbo(Tti_error_large,SFL1(90),SFL1(37)+' '+SFL1(89)+' ( 1 - '+IC.ToString+' )',E.ClientRect,2);
			E.Setfocus;
		end;
	if (Sender=E)or(Sender=B2) then SBO1;
end;

procedure TIPBox2.CBChange(Sender:TObject);
var
	R:TComboBoxEx;
begin
	R:=TComboBoxEx(Sender);
	if R.Visible then begin
		SBO1;
		R.Hint:=R.Text;
	end;
end;

/// /////////////////////////                   TIPBox3               ////////////////////////////
constructor TIPBox3.Create(AOwner:TSGA;ACol:Integer;var Isrs:Boolean;var Reslt:string);
var
	I,D,Scb,Kn:Integer;
	Gb1:TGroupBox;
	CUL,Ccl,Ref,Kl,Cmh:string;
	B:Tbitmap;
	Pl:Timagelist;
begin
	Reslt:='';
	Isrs:=False;
	inherited Createnew(AOwner);
	try
		TRFC:=AOwner.TRFC;
		TST:=AOwner.TST;
		Parent:=nil;
		BorderStyle:=BsDialog;
		Position:=PoScreenCenter;
		Caption:='   '+SFL1(116)+'   ';
		BidiMode:=AOwner.BidiMode;
		Keypreview:=True;
		Icon:=Application.Icon;
		Font:=AOwner.Font;
		Tag:=1;
		Width:=237;
		Height:=145;
		BorderIcons:=[];
		Color:=AOwner.Color;
		OnActivate:=User4;
		OnKeyPress:=User8;
		TabStop:=False;
		SGA:=AOwner;
		Gb1:=TGroupBox.Create(Self);
		with Gb1 do begin
			Parent:=Self;
			SetBounds(10,10,210,60);
			Caption:=SGA.SJ.Cells[ACol,0];
		end;
		BR:=TButton.Create(Self);
		with BR do begin
			Parent:=Self;
			Caption:=SFL1(14);
			ModalResult:=1;
			default:=True;
			Elevationrequired:=True;
			TabOrder:=7;
			if (Self.BidiMode=TbidiMode(1)) then SetBounds(150,85,72,23)
			else SetBounds(70,85,72,23);
		end;
		with TButton.Create(Self) do begin
			Parent:=Self;
			Caption:=SFL1(15);
			ModalResult:=2;
			TabOrder:=8;
			if (Self.BidiMode=TbidiMode(1)) then SetBounds(70,85,72,23)
			else SetBounds(150,85,72,23);
		end;
		try
			if (AOwner.SJ.Cols[ACol].Outr.Cinfo.CCB>0) then begin
				CUL:=AOwner.SJ.Cols[ACol].Outr.Cinfo.CUL;
				Ccl:=AOwner.SJ.Cols[ACol].Outr.Cinfo.Ccl;
				Cmh:=AOwner.SJ.Cols[ACol].Outr.Cinfo.Cmh;
				Ref:=AOwner.SJ.Cols[ACol].Outr.Cinfo.Ref;
				Kn:=AOwner.SJ.Cols[ACol].Outr.Cinfo.Kn;
				Kl:=AOwner.SJ.Cols[ACol].Outr.Cinfo.Kl;
				Scb:=AOwner.SJ.Cols[ACol].Outr.Cinfo.Scb;
				if (Ref<>'') then Ref:=' WHERE REF IN ('+Ref+')'
				else Ref:=' WHERE 1=1';
				if (Kl<>'') then Kl:=' AND KL IN ('+Kl+')'
				else Kl:=' AND 1=1';
				if (Ccl='LAN') then Ccl:=Lan;
				if not(Kn=7) then begin
					Cont:=TComboBoxEx.Create(Self);
					with (Cont as TComboBoxEx) do begin
						Parent:=Gb1;
						SetBounds(10,25,190,22);
						Text:='';
						Style:=TComboBoxExStyle(Scb);
						ItemIndex:=-1;
						BidiMode:=BdLeftToRight;
						Images:=AMDF.AMD;
						OnKeyDown:=AMDF.Cokeydown;
						if (CUL<>'')and(Cmh<>'')and(Ccl<>'') then begin
							if not(Kn=4) then begin
								FQ[2].Open('SELECT DISTINCT '+Ccl+',INX FROM '+Cmh+Ref+Kl);
								if (FQ[2].RowsAffected>0) then
									for I:=0 to FQ[2].RowsAffected-1 do begin
										D:=FQ[2].Fields[1].AsInteger;
										Itemsex.Additem(FQ[2].Fields[0].AsString,D,D,-1,-1,nil);
										FQ[2].Next;
									end;
							end;
							if (Kn=4) then begin
								FQ[2].Open('SELECT '+Ccl+',RGB FROM '+Cmh);
								Pl:=Timagelist.Create(Self);
								Pl.Colordepth:=Cd32bit;
								D:=Strtointdef(SFR1(36),16);
								Pl.Setsize(D,D);
								Images:=Pl;
								if (FQ[2].RowsAffected>0) then
									for I:=0 to FQ[2].RowsAffected-1 do begin
										D:=I;
										if (FQ[2].Fields[1].AsString='-1') then begin
											D:=-1;
										end;
										B:=Tbitmap.Create;
										with B do begin
											Pixelformat:=Pf32bit;
											Canvas.Brush.Color:=Getcolor(FQ[2].Fields[1].AsString);
											Setsize(Pl.Width,Pl.Height);
											Canvas.Fillrect(Rect(0,0,Width,Height));
										end;
										Pl.Add(B,nil);
										B.Free;
										Itemsex.Additem(FQ[2].Fields[0].AsString,D,D,-1,-1,nil);
										FQ[2].Next;
									end;
							end;
						end;
						SendMessage(Handle,Cb_setdroppedwidth,Na(SFR1(29)),0);
					end;
				end else if (CUL<>'')and(Kn=7) then begin
					Cont:=Tdatetimepicker.Create(Self);
					with (Cont as Tdatetimepicker) do begin
						Parent:=Gb1;
						Kind:=Tdatetimekind(Scb);
						Format:=Formatsettings.Shortdateformat;
						SetBounds(10,25,190,22);
					end;
				end;
			end else begin
				Cont:=TEdit.Create(Self);
				with (Cont as TEdit) do begin
					Parent:=Gb1;
					Text:='';
					AlignWithMargins:=True;
					Texthint:=SGA.SJ.Cells[ACol,0];
					Numbersonly:=AOwner.SJ.Cols[ACol].Outr.Cinfo.Nu;
					AutoSize:=False;
					Alignment:=TaCenter;
					SetBounds(10,25,190,22);
				end;
			end;
		except
			on E:Exception do ShowMessage('TIPBOX3 :EXTRACT'+#13+E.ToString);
		end;
		Psn1(5);
		ActiveControl:=Cont;
		if (ShowModal=1) then begin
			Isrs:=True;
			if (Cont IS TEdit) then Reslt:=(Cont as TEdit).Text
			else if (Cont IS TComboBoxEx) then Reslt:=(Cont as TComboBoxEx).Text
			else if (Cont IS Tdatetimepicker) then Reslt:=Datetostr((Cont as Tdatetimepicker).Date);
		end;
		Free;
	except
		on E:Exception do ShowMessage('TIPBOX3'+#13+E.ToString);
	end;
end;

procedure TIPBox3.User4(Sender:TObject);
begin
	Setcursorpos(BR.ClientOrigin.X+BR.ClientRect.CenterPoint.X,BR.ClientOrigin.Y+BR.ClientRect.CenterPoint.Y);
end;

procedure TIPBox3.User8(Sender:TObject;var Key:Char);
begin
	if (Ord(Key)=Vk_escape) then begin
		Key:=#0;
		Close;
	end;
end;

/// /////////////////////////////////         TProS                ///////////////////////////////
constructor TProS.Create(AOwner:TWinControl;Captin,Text1,Text2:string;BTN:Integer=0;Count:Integer=1;Sp:Integer=2;
	Bars:Integer=1);
var
	I:Integer;
begin
	try
		inherited Createnew(AOwner);
		FOwner:=AOwner;
		ParentBackground:=True;
		Isstop:=False;
		Parent:=nil;
		BorderStyle:=BsSizeable;
		BorderIcons:=[BiSystemMenu,BiMinimize];
		Position:=PoScreenCenter;
		Tag:=1;
		RG:=Count;
		Rn:=0;
		ISPAUSE:=False;
		Caption:='    '+Captin+'    ';
		if (BTN>0) then SetBounds(0,0,450,180+((Bars-1)*30)) // 160
		else SetBounds(0,0,450,140+((Bars-1)*30)); // 120
		Onclose:=ProSClose;
		Color:=AMDF.Color;
		Font:=AMDF.Font;
		Icon:=Application.Icon;
		BidiMode:=AOwner.BidiMode;
		with TImage.Create(Self) do begin
			Parent:=Self;
			Center:=True;
			AlignWithMargins:=True;
			Height:=32;
			Width:=32;
			Top:=10;
			if (BidiMode=TbidiMode(0)) then Left:=7
			else Left:=399;
			Picture.Icon.Handle:=Sic1(10);
		end;
		TX1:=TLabel.Create(Self);
		with TX1 do begin
			Parent:=Self;
			AutoSize:=False;
			Transparent:=True;
			SetBounds(45,10,345,20);
			Caption:=Text1;
			TE1:=Text1;
		end;
		TX2:=TLabel.Create(Self);
		with TX2 do begin
			Parent:=Self;
			AutoSize:=False;
			Transparent:=True;
			SetBounds(45,35,345,20);
			Caption:=Text2;
			TE2:=Text2;
		end;
		TX1.Font.Size:=Font.Size+2;
		TX1.Font.Color:=Clhighlight;
		Setlength(PB,Bars);
		for I:=0 to Bars-1 do begin
			PB[I]:=TRZProgressBar.Create(Self);
			with PB[I] do begin
				Parent:=Self;
				SetBounds(9,(I*30)+55,421,20);
				Percent:=0;
				Barstyle:=Bsgradient;
				Barcolor:=Getcolor('0,255,0');
				Barcolorstop:=Getcolor('0,255,0');
			end;
		end;
		if (BTN>0) then begin
			BT1:=TButton.Create(Self);
			with BT1 do begin
				Parent:=Self;
				Caption:=SFL1(24);
				SetBounds(150,((Bars-1)*30)+95,85,23);
				TabStop:=False;
				Tag:=1;
				OnClick:=Bt;
			end;
			BT2:=TButton.Create(Self);
			with BT2 do begin
				Parent:=Self;
				Caption:=SFL1(12);
				SetBounds(240,((Bars-1)*30)+95,85,23);
				TabStop:=False;
				Tag:=2;
				Elevationrequired:=True;
				default:=True;
				OnClick:=Bt;
			end;
		end;
		Taskbar1.Progressstate:=Ttaskbarprogressstate(2);
		if (AOwner IS TSGA) then
			if (TSGA(AOwner).ATab<>nil) then begin
				TSGA(AOwner).ATab.Spinnerstate:=Tchrometabspinnerstate(Sp);
			end;
		// AMDF.Applicationevents1modalbegin(Application);
		Show;
		Poin:=Disabletaskwindows(Handle);
		LFocusState:=SaveFocusState;
		SaveHooks:=TStyleManager.SystemHooks;
		TStyleManager.SystemHooks:=[];
	except
		on E:Exception do ShowMessage('ProT'+#13+E.ToString);
	end;
end;

function TProS.ProR(Mn,Mx:Uint64;C:Integer=0):Boolean;
var
	Pos:Uint64;
	Tpr:Ttaskbarprogressstate;
	Cl1,Cl2:Tcolor;
begin
	Result:=False;
	if ISPAUSE then begin
		Cl1:=PB[0].Barcolor;
		Cl2:=PB[0].Barcolorstop;
		Tpr:=Taskbar1.Progressstate;
		PB[0].Barcolor:=Clyellow;
		PB[0].Barcolorstop:=Clyellow;
		Taskbar1.Progressstate:=Ttaskbarprogressstate(4);
		repeat
			Application.Processmessages;
			Sleep(100);
		until (ISPAUSE=False);
		PB[0].Barcolor:=Cl1;
		PB[0].Barcolorstop:=Cl2;
		Taskbar1.Progressstate:=Tpr;
	end;
	try
		Application.Processmessages;
		if (Mx=0) then begin
			Destroy;
			Exit;
		end;
		if not Visible then Mn:=Mx;
		Pos:=ROUND((Mn*(100/Mx))/RG)+Rn;
		if (Mn=Mx) then Rn:=Rn+Pos;
		if (Pos>=100)and not(Mn=Mx) then Pos:=99;
		PB[0].Percent:=Pos;
		Taskbar1.Progressvalue:=Pos;
		if (C=1) then begin
			PB[0].Barcolor:=clRed;
			PB[0].Barcolorstop:=clRed;
			TX1.Font.Color:=clRed;
			Taskbar1.Progressstate:=Ttaskbarprogressstate(3);
		end;
		if (C<>0) then TX1.Caption:=Format(SFL1(79)+'   %d%',[C]);
		if (TE2<>'') then TX2.Caption:=Format(TE2,[Pos]);
		if (Pos>=100)and(Mn=Mx) then begin
			Destroy;
			Exit;
		end;
		Result:=Isstop;
	except
		on E:Exception do ShowMessage('ProR'+#13+E.ToString);
	end;
end;

function TProS.ProR1(Mn,Mx:Uint64;Bar:Integer=1;C:Integer=0):Boolean;
var
	Pos:Uint64;
begin
	Result:=False;
	try
		Application.Processmessages;
		Pos:=ROUND((Mn*(100/Mx)));
		if (Pos>=100)and not(Mn=Mx) then Pos:=99;
		PB[Bar].Percent:=Pos;
		if (C=1) then begin
			PB[Bar].Barcolor:=clRed;
			PB[Bar].Barcolorstop:=clRed;
			PB[0].Barcolor:=clRed;
			PB[0].Barcolorstop:=clRed;
			TX1.Font.Color:=clRed;
			Taskbar1.Progressstate:=Ttaskbarprogressstate(3);
		end;
		if (C<>0) then Caption:=Format(SFL1(79)+'   %d%',[C]);
		Result:=Isstop;
	except
		on E:Exception do ShowMessage('ProR1'+#13+E.ToString);
	end;
end;

procedure TProS.Bt(Sender:TObject);
begin
	case TButton(Sender).Tag of
		1:Close;
		2:begin
				if ISPAUSE then begin
					ISPAUSE:=False;
					TButton(Sender).Caption:=SFL1(12);
				end else begin
					ISPAUSE:=True;
					TButton(Sender).Caption:=SFL1(168);
				end;
			end;
	end;
end;

procedure TProS.WMSize(var Msg:TMessage);
begin
	if Msg.Wparam=Size_minimized then Application.Mainform.Windowstate:=Wsminimized;
end;

procedure TProS.ProSClose(Sender:TObject;var Action:TCloseAction);
begin
	Isstop:=True;
	Action:=Canone;
end;

destructor TProS.Destroy;
begin
	Taskbar1.Progressstate:=Ttaskbarprogressstate(0);
	Taskbar1.Progressvalue:=0;
	if (Owner IS TSGA) then begin
		if (TSGA(Owner).ATab<>nil) then begin
			TSGA(Owner).ATab.Spinnerstate:=Tchrometabspinnerstate(3);
		end;
	end;
	Enabletaskwindows(Poin);
	SetActiveWindow(Handle);
	RestoreFocusState(LFocusState);
	TStyleManager.SystemHooks:=SaveHooks;
	// AMDF.Applicationevents1modalend(Application);
	inherited Destroy;
end;

end.
