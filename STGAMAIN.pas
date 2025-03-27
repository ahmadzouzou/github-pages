unit STGAMAIN;

interface

uses
	Winapi.Windows,
	Winapi.Messages,
	System.SysUtils,
	System.Variants,
	System.Classes,
	Vcl.Graphics,
	Vcl.Controls,
	Vcl.Forms,
	Vcl.Dialogs,
	amdmain,
 //	AMDChromeTabs,
	Vcl.StdCtrls,
	amdfun1,
	STGS,
	Vcl.ExtCtrls,
	Vcl.ComCtrls, ChromeTabs, Vcl.Mask, Vcl.WinXCtrls;

type
	TSSTGA=class(TFrm)
		GroupBox1:TGroupBox;
		SJ1:TSJ;
		Panel1:TPanel;
		Panel2:TPanel;
		Panel3:TPanel;
		Panel4:TPanel;
		StatusBar1:TStatusBar;
		StatusBar2:TStatusBar;
    StaticText1: TStaticText;
    LinkLabel1: TLinkLabel;
    ButtonedEdit1: TButtonedEdit;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    SearchBox1: TSearchBox;
    procedure LinkLabel1Click(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
	private
		{ Private declarations }
	public
		{ Public declarations }
	end;

var
	SSTGA:TSSTGA;

implementation

{$R *.dfm}

procedure TSSTGA.LinkLabel1Click(Sender: TObject);
begin
 ShowMessage('link');
end;

procedure TSSTGA.StaticText1Click(Sender: TObject);
begin
 ShowMessage('static');
end;

end.
