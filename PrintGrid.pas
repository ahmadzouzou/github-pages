// Original Author: Shalonkin Alex
// e-mail alex@vita-samara.ru
//
// This is a modified pascal unit originally written by Alex Shalonkin.
// It has been made into a component with a couple of properties added
// and the Russian remarks and text translated into English by Alexander Rodygin.
//
// Very basic yet useful component for printing your dbgrids!
//
// No warranty expressed or implied. Use at your own risk! Modify if you wish!
//
// John F. Jarrett
// johnj@jcits.d2g.com
//

unit PrintGrid;

interface

uses
	Windows,
	Messages,
	Sysutils,
	Classes,
	Graphics,
	Controls,
	Dialogs,
	Stdctrls,
	Db,
	Printers,
	Dbgrids,
	Extctrls,
	Comctrls,
	Forms;

const
	Maxcolums=10;
	Numeratecolumnwidth=30;
	Numeratefieldname='Num';

type
	Tonlogchangeevent=procedure(Sender:Tobject;Astr:string) of object;
	Tonnextpageevent=procedure(Sender:Tobject;Numpage:Integer) of object;

	Pboundrec=^Tboundrec;

	Tboundrec=record
		Apos:Integer; // relative to the top displacement
		Astr:string;
		Afontsize:Integer;
		Afontstyle:Tfontstyles;
		Aaligment:Talignment;
	end;

	Tprintbound=class(Tlist)
	private
		Fmaxpos:Integer;
		function Getbitem(Index:Integer):Tboundrec;
	public
		constructor Create;
		function Add(Apos:Integer;Astr:string;Afontsize:Integer;Afontstyle:Tfontstyles;Aaligment:Talignment):Integer;
		property Items[index:Integer]:Tboundrec read Getbitem;
		property Maxpos:Integer read Fmaxpos;
	end;

	Tcolumnrect=record
		Left:Integer;
		Right:Integer;
		Top:Integer;
		Alignment:Talignment;
		Font:Tfont;
		Color:Tcolor;
		Titlefont:Tfont;
		Titlealignment:Talignment;
		Titlecolor:Tcolor;
		Titlestr:string;
		Fieldname:string;
	end;

	Tprintgrid=class(Tcomponent)
	private
		Fdataset:Tdataset;
		Fdbgrid:Tdbgrid;
		// FPreviewImage: TImage;
		Fonlogchangeevent:Tonlogchangeevent; // Fires when the log changes
		Fonnextpageevent:Tonnextpageevent;
		Flogpanel:Tpanel; // Log output panel
		Fvisiblecolumn:Integer; // Number of visible columns
		Frownumbers:Boolean; // Should the rows be numerated
		Fheadercolor:Tcolor; // For Title Text and Page Text Color
		Fpagenumfontsize:Integer; // Set for Font Size
		Fpagenumfontname:Tfontname; // Like Times New Roman
		Fprintpagenum:Boolean; // Set if you want to print page numbers
		Fprintdialog:Boolean; // Should the print dialog be displayed
		Fprintprogressbar:Tprogressbar; // Progressbar for printing
		Fprintorientation:Tprinterorientation; // Print orientation
		Fwidth:Integer;
		Fheight:Integer; // Canvas Width & Height
		Fleftmargin:Integer;
		Frightmargin:Integer;
		Ftopmargin:Integer;
		Fbottommargin:Integer; // Margins
		Fpagenumbertop:Integer;
		Fboundmargin:Integer;
		// Margins from the bounds to the table and from the table to the bounds
		procedure Setdbgrid(const Value:Tdbgrid); // const Value
		// procedure SetPreviewImage(const Value: TImage);
	protected
		Factivetopposition:Integer; // Top border for painting
		Fcolumns: array [0..Maxcolums-1] of Tcolumnrect;
		Fcanvas:Tcanvas; // Canvas for printing (printer or picture)
		Fmaxtitleheight:Integer;
		Fmaxcolumnheight:Integer;
		Autonumber:Integer;
		Fpagenumber:Integer;
		Fuseprinter:Boolean;
		// FOnLogChangeEvent : TOnLogChangeEvent;
		// FOnNextPageEvent : TOnNextPageEvent
		procedure Paintcanvas;
		procedure Addinlog(Astr:string);
		procedure Paintbound(Bound:Tprintbound);
		procedure Processinggridcoord;
		procedure Printgridtitle;
		procedure Printrows;
		procedure Printrow;
		procedure Printpagenumber;
	public
		Title:Tprintbound;
		Bottom:Tprintbound;
		Logs:Tstringlist;
		constructor Create(Aowner:Tcomponent);override;
		destructor Destroy;override;
		procedure Loaded;override;
		// function Preview:Boolean;
		function Print:Boolean;
	published
		property Rownumbers:Boolean read Frownumbers write Frownumbers default True;
		property Pagenumfontsize:Integer read Fpagenumfontsize write Fpagenumfontsize;
		property Dbgrid:Tdbgrid read Fdbgrid write Fdbgrid; // SetDBGrid;
		property Pagenumfontname:Tfontname read Fpagenumfontname write Fpagenumfontname;
		property Headercolor:Tcolor read Fheadercolor write Fheadercolor;
		property Logpanel:Tpanel read Flogpanel write Flogpanel;
		// property PreviewImage:TImage read FPreviewImage write FPreviewImage; //SetPreviewImage;
		property Printdialog:Boolean read Fprintdialog write Fprintdialog default False;
		property Printorientation:Tprinterorientation read Fprintorientation write Fprintorientation default Poportrait;
		property Printpagenum:Boolean read Fprintpagenum write Fprintpagenum default True;
		property Printprogressbar:Tprogressbar read Fprintprogressbar write Fprintprogressbar;
		property Topmargin:Integer read Factivetopposition write Factivetopposition;
		property Bottommargin:Integer read Fbottommargin write Fbottommargin;
		property Leftmargin:Integer read Fleftmargin write Fleftmargin;
		property Rightmargin:Integer read Frightmargin write Frightmargin;
		property Onlogchangeevent:Tonlogchangeevent read Fonlogchangeevent write Fonlogchangeevent;
		property Onnextpageevent:Tonnextpageevent read Fonnextpageevent write Fonnextpageevent;
	end;

procedure Register;

implementation

// ***************************************
// Register the component on the Palette
// ***************************************
procedure Register;
begin
	Registercomponents('CES',[Tprintgrid]);
end;

// ****************************************************
// Create and Initialize
// ****************************************************
constructor Tprintgrid.Create(Aowner:Tcomponent);
begin
	inherited Create(Aowner);
	Title:=Tprintbound.Create;
	Bottom:=Tprintbound.Create;
	Logs:=Tstringlist.Create;
	Frownumbers:=True;
	Flogpanel:=nil;
	Fheadercolor:=Clblack;
	Fprintdialog:=False;
	Fprintpagenum:=True;
	Fpagenumfontname:='Times New Roman';
	Fpagenumfontsize:=8;
	Fprintprogressbar:=nil;
	Fprintorientation:=Poportrait;
	// FPreviewImage:=nil;
	Fwidth:=0;
	Fheight:=0;
	Fleftmargin:=240;
	Frightmargin:=60;
	Fbottommargin:=160;
	Factivetopposition:=0;
	Fboundmargin:=10;
	Fuseprinter:=True;
end;

// ***************************************
// Moves the rect vertically and horizontally
//
function Moverect(Rect:Tcolumnrect;X,Y:Integer):Tcolumnrect;
begin
	Result.Left:=Rect.Left+X;
	Result.Right:=Rect.Right+X;
	Result.Top:=Rect.Top+Y;
end;

// ***************************************
// Outputs the text inside a cell
// ***************************************
procedure Paintcells(Acanvas:Tcanvas;Arect:Trect;Afont:Tfont;Aalignment:Talignment;Acolor:Tcolor;Astr:string);
var
	Leftpoint:Integer;
	Lwidth:Integer;
	Toppoint:Integer;
begin
	// Fills the rectangles
	Acanvas.Brush.Color:=Acolor;
	Acanvas.Fillrect(Rect(Arect.Left+1,Arect.Top+1,Arect.Right,Arect.Bottom));

	Acanvas.Font:=Afont;

	while (Length(Astr)>0)and(Acanvas.Textwidth(Astr)>(Arect.Right-Arect.Left)-Acanvas.Textwidth('A')) do
			Delete(Astr,Length(Astr),1);

	case Aalignment of
		Taleftjustify:Leftpoint:=Arect.Left+2;
		Tacenter:begin
				Leftpoint:=Arect.Left+((Arect.Right-Arect.Left)div 2)-Acanvas.Textwidth(Astr)div 2;
			end;
		Tarightjustify:Leftpoint:=Arect.Right-Acanvas.Textwidth(Astr)-1;
	end;

	Toppoint:=Arect.Top+((Arect.Bottom-Arect.Top)div 2)-Acanvas.Textheight(Astr)div 2;

	Acanvas.Textout(Leftpoint,Toppoint,Astr);
end;

// ************************************************
// Check and see if we are in design mode. If not,
// we ensure that the DBGrid is set and the TImage
// ************************************************
procedure Tprintgrid.Loaded;
begin
	inherited Loaded;
	if not(Csdesigning in Componentstate) then begin
		if Assigned(Fdbgrid) then Setdbgrid(Fdbgrid);
		// if Assigned(FPreviewImage) then
		// SetPreviewImage(FPreviewImage);
	end;
end;

// ************************************************
// Component Destroy
// ************************************************
destructor Tprintgrid.Destroy;
begin
	Title.Free;
	Title:=nil;
	Bottom.Free;
	Bottom:=nil;
	Logs.Free;
	Logs:=nil;
	inherited Destroy;
end;

// **********************************************
// Preview Print in a TImage
// **********************************************
{ function TPrintGrid.Preview: Boolean;
	var
	Left, Right : Integer;
	begin
	Left := FLeftMargin;
	Right := FRightMargin;
	FLeftMargin := 20;
	FRightMargin := 20;
	AddInLog('Generating preview');
	Result:=Assigned(FPreviewImage);
	if Result then
	begin
	FCanvas:=FPreviewImage.Canvas;
	FWidth:=FPreviewImage.Width;
	FHeight:=FPreviewImage.Height;
	FUsePrinter:=False;
	PaintCanvas;
	end;
	AddInLog('Preview generation completed');
	if Assigned(FPrintProgressBar) then
	FPrintProgressBar.Position := 0;
	FLeftMargin := Left;
	FRightMargin := Right;
	end; }

// **************************************************
// Print the Grid within which the data will reside
// **************************************************
procedure Tprintgrid.Paintcanvas;
begin
	Addinlog('Preparing to output image');
	if Fuseprinter then begin
		Ftopmargin:=200;
		Fpagenumbertop:=50;
	end else begin
		Ftopmargin:=20;
		Fpagenumbertop:=10;
	end;
	Factivetopposition:=Ftopmargin;
	Fpagenumber:=1;
	Printpagenumber;
	if Title.Count>0 then begin
		Paintbound(Title);
		Factivetopposition:=Factivetopposition+Fboundmargin;
	end;
	Processinggridcoord;
	Printgridtitle;
	Printrows;
	if Bottom.Count>0 then begin
		Factivetopposition:=Factivetopposition+Fmaxcolumnheight+Fboundmargin;
		Paintbound(Bottom);
	end;
end;

// ***************************************************
// Sets the dbGrid
// ***************************************************
procedure Tprintgrid.Setdbgrid(const Value:Tdbgrid);
var
	I:Integer;
begin
	Fdbgrid:=Value;
	Fdataset:=Fdbgrid.Datasource.Dataset;
	Fvisiblecolumn:=0;
	for I:=0 to Fdbgrid.Columns.Count-1 do begin
		if Fdbgrid.Columns[I].Visible then Inc(Fvisiblecolumn);
		Application.Processmessages;
	end;
end;

// *****************************************************
// TPrintBound Adds Strings and Font Data to List
// *****************************************************
function Tprintbound.Add(Apos:Integer;Astr:string;Afontsize:Integer;Afontstyle:Tfontstyles;
	Aaligment:Talignment):Integer;
var
	B:Pboundrec;
begin
	New(B);
	B^.Apos:=Apos;
	B^.Astr:=Astr;
	B^.Afontsize:=Afontsize;
	B^.Afontstyle:=Afontstyle;
	B^.Aaligment:=Aaligment;
	if Fmaxpos<Apos then Fmaxpos:=Apos;
	Result:=inherited Add(B);
end;

// ******************************************************
// Creates the Print bounds
// ******************************************************
constructor Tprintbound.Create;
begin
	inherited;
	Fmaxpos:=0;
end;

// *******************************************************
// Gets the item index
// *******************************************************
function Tprintbound.Getbitem(Index:Integer):Tboundrec;
begin
	Result:=Pboundrec(inherited Items[index])^;
end;

// *******************************************************
// Sets the preview image to your Image
// *******************************************************
{ procedure TPrintGrid.SetPreviewImage(const Value: TImage);
	begin
	FPreviewImage := Value;
	FWidth:=FPreviewImage.Width;
	FHeight:=FPreviewImage.Height;
	FCanvas:=Value.Canvas;
	FUsePrinter:=False;
	end; }

// *******************************************************
// Writes events for progress and Logging
// *******************************************************
procedure Tprintgrid.Addinlog(Astr:string);
begin
	Logs.Add(Astr);
	if Assigned(Fonlogchangeevent) then Fonlogchangeevent(Logs,Astr);
	if Assigned(Fprintprogressbar) then Fprintprogressbar.Stepit;
	if Assigned(Flogpanel) then begin
		Flogpanel.Caption:=Astr;
		Flogpanel.Refresh;
	end;
end;

// ********************************************************
// Paint the boundaries
// ********************************************************
procedure Tprintgrid.Paintbound(Bound:Tprintbound);
var
	I:Integer;
	Leftpoint:Integer;
	Lwidth:Integer;
	Maxheight:Integer;
begin
	Addinlog('Bounds drawing');
	Maxheight:=0;
	for I:=0 to Bound.Count-1 do begin
		Fcanvas.Brush.Color:=Clwhite;
		Fcanvas.Font.Size:=Bound.Items[I].Afontsize;
		Fcanvas.Font.Style:=Bound.Items[I].Afontstyle;
		Fcanvas.Font.Name:='MS Sans Serif';
		case Bound.Items[I].Aaligment of
			Taleftjustify:Leftpoint:=Fleftmargin;
			Tacenter:begin
					Lwidth:=(Fwidth-(Fleftmargin+Frightmargin))div 2;
					Leftpoint:=Fleftmargin+Lwidth-Fcanvas.Textwidth(Bound.Items[I].Astr)div 2;
				end;
			Tarightjustify:Leftpoint:=Fwidth-Frightmargin-Fcanvas.Textwidth(Bound.Items[I].Astr);
		end;
		Fcanvas.Textout(Leftpoint,Factivetopposition,Bound.Items[I].Astr);
		if Fcanvas.Textheight(Bound.Items[I].Astr)>Maxheight then Maxheight:=Fcanvas.Textheight(Bound.Items[I].Astr);
		if I<Bound.Count-1 then
			if Bound.Items[I+1].Apos>Bound.Items[I].Apos then begin
				Factivetopposition:=Factivetopposition+Maxheight;
				Maxheight:=0;
			end;
	end;
	Factivetopposition:=Factivetopposition+Maxheight;
end;

// ************************************************************
// Processing and figuring the number of columns and width
// ************************************************************
procedure Tprintgrid.Processinggridcoord;
var
	I:Integer;
	Lwidth:Integer;
	Lkoeff:Real;
	J:Integer;
	Leftpoint:Integer;
begin
	Addinlog('Computing number of visible columns and width of table');
	Lwidth:=0;
	Fmaxcolumnheight:=0;
	for I:=0 to Fdbgrid.Columns.Count-1 do begin
		if Fdbgrid.Columns[I].Visible then begin
			Lwidth:=Lwidth+Fdbgrid.Columns[I].Width;
			Fcanvas.Font:=Fdbgrid.Columns[I].Font;
			if Fmaxcolumnheight<Fcanvas.Textheight('ROW HEIGHT') then Fmaxcolumnheight:=Fcanvas.Textheight('ROW HEIGHT')+2;
			Fcanvas.Font:=Fdbgrid.Columns[I].Title.Font;
			if Fmaxtitleheight<Fcanvas.Textheight('ROW HEIGHT') then Fmaxtitleheight:=Fcanvas.Textheight('ROW HEIGHT')+2;
		end;
	end;

	if Frownumbers then begin
		Inc(Fvisiblecolumn);
		Lwidth:=Lwidth+Numeratecolumnwidth;
	end;

	Addinlog('Calculating the coefficient of compression/stretch');
	Lkoeff:=(Fwidth-(Fleftmargin+Frightmargin))/Lwidth;

	Addinlog('If there is an auto-number field, add one more column');
	J:=0;
	Leftpoint:=Fleftmargin;
	if Frownumbers then begin
		Fcolumns[J].Alignment:=Taleftjustify;
		// Position of Row Number. Left is best.
		Fcolumns[J].Font:=Fdbgrid.Columns[0].Font;
		Fcolumns[J].Color:=Fdbgrid.Columns[0].Color;
		Fcolumns[J].Fieldname:=Numeratefieldname;

		Fcolumns[J].Titlefont:=Fdbgrid.Columns[0].Title.Font;
		Fcolumns[J].Titlealignment:=Taleftjustify;
		Fcolumns[J].Titlecolor:=Fdbgrid.Columns[0].Title.Color;
		Fcolumns[J].Titlestr:='Num';

		Fcolumns[J].Top:=0;
		Fcolumns[J].Left:=Leftpoint;
		Fcolumns[J].Right:=Leftpoint+Trunc(Numeratecolumnwidth*Lkoeff);
		Leftpoint:=Fcolumns[J].Right;
		Inc(J);
	end;

	Addinlog('Calculating row coordinates');
	for I:=0 to Fdbgrid.Columns.Count-1 do begin
		if Fdbgrid.Columns[I].Visible then begin
			Fcolumns[J].Alignment:=Fdbgrid.Columns[I].Alignment;
			Fcolumns[J].Font:=Fdbgrid.Columns[I].Font;
			Fcolumns[J].Color:=Fdbgrid.Columns[I].Color;
			Fcolumns[J].Fieldname:=Fdbgrid.Columns[I].Fieldname;

			Fcolumns[J].Titlefont:=Fdbgrid.Columns[I].Title.Font;
			Fcolumns[J].Titlealignment:=Fdbgrid.Columns[I].Title.Alignment;
			Fcolumns[J].Titlecolor:=Fdbgrid.Columns[I].Title.Color;
			Fcolumns[J].Titlestr:=Fdbgrid.Columns[I].Title.Caption;

			Fcolumns[J].Top:=0;
			Fcolumns[J].Left:=Leftpoint;
			Fcolumns[J].Right:=Leftpoint+Trunc(Fdbgrid.Columns[I].Width*Lkoeff);
			Leftpoint:=Fcolumns[J].Right;
			Inc(J);
		end;
	end;
end;

// ***********************************************************
// Printing the Title
// ***********************************************************
procedure Tprintgrid.Printgridtitle;
var
	I:Integer;
	Lrect:Tcolumnrect;
	Lheight:Integer;
begin
	Addinlog('Table title output');
	for I:=0 to Fvisiblecolumn-1 do begin
		Lrect:=Moverect(Fcolumns[I],0,Factivetopposition);
		// Paints the "|" of the column
		if I=0 then begin
			Fcanvas.Moveto(Lrect.Left,Lrect.Top);
			Fcanvas.Lineto(Lrect.Left,Fmaxtitleheight+Factivetopposition);
		end;
		// Paints the remaining part of the column
		Fcanvas.Moveto(Lrect.Left,Lrect.Top);
		Fcanvas.Lineto(Lrect.Right,Lrect.Top);
		Fcanvas.Lineto(Lrect.Right,Fmaxtitleheight+Factivetopposition);
		Fcanvas.Lineto(Lrect.Left,Fmaxtitleheight+Factivetopposition);
		// Paints the text
		Paintcells(Fcanvas,Rect(Lrect.Left,Lrect.Top,Lrect.Right,Fmaxtitleheight+Factivetopposition),Fcolumns[I].Titlefont,
			Fcolumns[I].Titlealignment,Fcolumns[I].Titlecolor,Fcolumns[I].Titlestr);
	end;
	Factivetopposition:=Fmaxtitleheight+Factivetopposition;
end;

// *************************************************************
// Formats the rows
// *************************************************************
procedure Tprintgrid.Printrow;
var
	I:Integer;
	Lrect:Tcolumnrect;
begin
	Addinlog('Formatting row output');
	for I:=0 to Fvisiblecolumn-1 do begin
		Lrect:=Moverect(Fcolumns[I],0,Factivetopposition);
		// Paints the "|" of the column
		if I=0 then begin
			Fcanvas.Moveto(Lrect.Left,Lrect.Top);
			Fcanvas.Lineto(Lrect.Left,Fmaxcolumnheight+Factivetopposition);
		end;
		// Paints the remaining part of the column
		Fcanvas.Moveto(Lrect.Left,Fmaxcolumnheight+Factivetopposition);
		Fcanvas.Lineto(Lrect.Right,Fmaxcolumnheight+Factivetopposition);
		Fcanvas.Lineto(Lrect.Right,Lrect.Top);
		// Paints the text
		if Fcolumns[I].Fieldname=Numeratefieldname then begin
			Paintcells(Fcanvas,Rect(Lrect.Left,Lrect.Top,Lrect.Right,Fmaxcolumnheight+Factivetopposition),Fcolumns[I].Font,
				Fcolumns[I].Alignment,Fcolumns[I].Color,Inttostr(Autonumber));
		end else begin
			Paintcells(Fcanvas,Rect(Lrect.Left,Lrect.Top,Lrect.Right,Fmaxcolumnheight+Factivetopposition),Fcolumns[I].Font,
				Fcolumns[I].Alignment,Fcolumns[I].Color,Fdataset.Fieldbyname(Fcolumns[I].Fieldname).Asstring);
		end;
	end;
end;

// ****************************************************************
// Prints the rows
// ****************************************************************
procedure Tprintgrid.Printrows;
var
	Bookmark:Tbookmark;
begin
	Addinlog('Preparing rows for output');
	Autonumber:=1;
	Fdataset.Disablecontrols;
	Bookmark:=Fdataset.Getbookmark;
	Fdataset.First;
	while not Fdataset.Eof do begin
		Printrow;
		Fdataset.Next;
		Inc(Autonumber);
		Factivetopposition:=Factivetopposition+Fmaxcolumnheight;
		if Factivetopposition+Fmaxcolumnheight>Fheight-Fbottommargin then begin
			Inc(Fpagenumber);
			if Assigned(Fonnextpageevent) then Fonnextpageevent(Self,Fpagenumber);
			if Fuseprinter then begin
				Printer.Newpage;
				Factivetopposition:=Ftopmargin;
				Printpagenumber;
				Printgridtitle;
			end;
		end;
	end;
	Fdataset.Gotobookmark(Bookmark);
	Fdataset.Enablecontrols;
end;

// **********************************************************************
// Prints the grid and formats to printer
// **********************************************************************
function Tprintgrid.Print:Boolean;
begin
	Addinlog('Formatting document');
	Result:=True;
	Fuseprinter:=True;
	if (Fprintdialog) then
		with Tprintdialog.Create(Self) do
			try Result:=Execute;
			finally Free;
			end;
	if Result then begin
		Printer.Orientation:=Fprintorientation;
		Fcanvas:=Printer.Canvas;
		Fwidth:=Printer.Pagewidth;
		Fheight:=Printer.Pageheight;
		Printer.Begindoc;
		Paintcanvas;
		Printer.Enddoc;
	end;
	Addinlog('Formatting complete and job sent to printer');
	if Assigned(Fprintprogressbar) then Fprintprogressbar.Position:=0;
end;

// ***************************************************************
// Compute and print page numbers
// ***************************************************************
procedure Tprintgrid.Printpagenumber;
begin
	Addinlog('Page number output');
	Fcanvas.Font.Color:=Fheadercolor; // fcBlack
	Fcanvas.Font.Size:=Fpagenumfontsize; // 8
	Fcanvas.Font.Style:=[];
	Fcanvas.Font.Name:=Fpagenumfontname; // 'Times New Roman';
	if Fprintpagenum then
			Fcanvas.Textout(Fwidth-Fcanvas.Textwidth('Page '+Inttostr(Fpagenumber))-Frightmargin,Fpagenumbertop,
			'Page '+Inttostr(Fpagenumber));
end;

end.
