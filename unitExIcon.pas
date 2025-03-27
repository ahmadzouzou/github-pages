(* ======================================================================*
	| unitExIcon.pas                                                       |
	|                                                                      |
	| Encapsulates Windows Icons & Cursors.                                |
	|                                                                      |
	| For icons In TExIconImage, the memory is the bitmapinfo, followed by |
	| the color and mask bits.                                             |
	|                                                                      |
	| For cursors it is preceeded by word x and y hotspots                 |
	|                                                                      |
	| This corresponds with what you find in resources, but not .CUR files |
	|                                                                      |
	| .CUR files look like .ICO files except:                              |
	|                                                                      |
	| 1.  The wType is '2' not '1'                                         |
	|                                                                      |
	| 2.  wPlanes and wBitCount contain the X and Y hotspot.  Because of   |
	|     they can only get the color depth from bColorCount, with its     |
	|     max of 256.                                                      |
	|                                                                      |
	| The contents of this file are subject to the Mozilla Public License  |
	| Version 1.1 (the "License"); you may not use this file except in     |
	| compliance with the License. You may obtain a copy of the License    |
	| at http://www.mozilla.org/MPL/                                       |
	|                                                                      |
	| Software distributed under the License is distributed on an "AS IS"  |
	| basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See  |
	| the License for the specific language governing rights and           |
	| limitations under the License.                                       |
	|                                                                      |
	| Copyright © Colin Wilson 2002  All Rights Reserved                   |
	|                                                                      |
	| Version  Date        By    Description                               |
	| -------  ----------  ----  ----------------------------------------- |
	| 1.0      10/10/2000  CPWW  Original                                  |
	| 1.01     30/04/2001  CPWW  Cursors working                           |
	| 1.02     17/12/2001  CPWW  Bug in displaying icons/cursor in W98     |
	|                            fixed.                                    |
	*---------------------------------------------------------------------- *)

unit unitExIcon;

interface

uses
	Windows,
	Classes,
	Sysutils,
	Graphics,
	Controls;

type

	// =============================================================================
	// TExIconImage class - Shared image structure for icons & cursors
	// nb. the memory image (and of course, the handle) are for one image only

	// TIconHeader is variously called NEWHEADER, ICONDIR and GRPICONDIR in the SDK
	Ticonheader=packed record
		Wreserved:Word; // Must be 0
		Wtype:Word; // 1 for icons, 2 for cursors
		Wcount:Word; // Number of components
	end;

	Piconheader=^Ticonheader;

	// TResourceDirectory is called RESDIR in the SDK.
	Tresourcedirectory=packed record
		Details:packed record
			case Boolean of
				False:(Cursorwidth,Cursorheight:Word);
				True:(Iconwidth,Iconheight,Iconcolorcount,Iconreserved:Byte)
		end;

		Wplanes,Wbitcount:Word;
		Lbytesinres:Dword;
		Wnameordinal:Word end;
		Presourcedirectory=^Tresourcedirectory;

		// TIconDirEntry is called ICONDIRENTRY in the SDK
		Ticondirentry=packed record Bwidth:Byte; // Width, in pixels, of the image
		Bheight:Byte; // Height, in pixels, of the image
		Bcolorcount:Byte; // Number of colors in image (0 if >=8bpp)
		Breserved:Byte; // Reserved ( must be 0)
		Wplanes:Word; // Color Planes    (X Hotspot for cursors)
		Wbitcount:Word;
		// Bits per pixel  (Y Hotspot for cursors - implies MAX 256 color cursors (!))
		Dwbytesinres:Dword; // How many bytes in this resource?
		Dwimageoffset:Dword; // Where in the file is this image?
	end;

	Picondirentry=^Ticondirentry;

	// -----------------------------------------------------------------------------
	// TExIconImage
	//
	// Each ExIconCursor can have multiple TExIconImage classes - one per format in
	// the ICO file or Icon resource/

	Texiconimage=class(Tsharedimage)
		Fisicon:Boolean;
		Fhandle:Hicon;
		Fpalette:Hpalette;
		Fmemoryimage:Tcustommemorystream;
		Fgotpalette:Boolean;
		// Indicates that we've got a the palette from the image data
		// or that there is no palette (eg. it's not pf1bit ..pf8Bit)

		Fwidth,Fheight:Integer;
		Fpixelformat:Tpixelformat;

		procedure Handleneeded;
		procedure Paletteneeded;
		procedure Imageneeded;

		function Getbitmapinfo:Pbitmapinfo;
		function Getbitmapinfoheader:Pbitmapinfoheader;
	private
		function Getmemoryimage:Tcustommemorystream;

	protected
		procedure Freehandle;override;
	public
		destructor Destroy;override;

		property Handle:Hicon read Fhandle; // The Icon image handle
		property Palettehandle:Hpalette read Fpalette; // The Icon image's palette

		property Width:Integer read Fwidth;
		property Height:Integer read Fheight;
		property Pixelformat:Tpixelformat read Fpixelformat;
		property Memoryimage:Tcustommemorystream read Getmemoryimage;
	end;

	// -----------------------------------------------------------------------------
	// TExIconCursor

	Texiconcursor=class(Tgraphic)
	private
		Fimages: array of Texiconimage;
		Fcurrentimage:Integer;
		Ftransparentcolor:Tcolor;

		function Gethandle:Hicon;
		function Getpixelformat:Tpixelformat;
		procedure Setpixelformat(const Value:Tpixelformat);
		function Getimagecount:Integer;

		procedure Releaseimages;
		function Getimage(Index:Integer):Texiconimage;
		procedure Sethandle(const Value:Hicon);
		procedure Assignfromgraphic(Source:Tgraphic);
		procedure Setcurrentimage(const Value:Integer);

		procedure Handleneeded;
		procedure Paletteneeded;
		procedure Imageneeded;
		procedure Readicon(Instance:Thandle;Stream:Tcustommemorystream;Size:Integer);
	protected
		procedure Draw(Acanvas:Tcanvas;const Rect:Trect);override;
		function Getempty:Boolean;override;
		function Getheight:Integer;override;
		function Getwidth:Integer;override;
		procedure Setheight(Value:Integer);override;
		procedure Setwidth(Value:Integer);override;
		procedure Setpalette(Value:Hpalette);override;
		function Gettransparent:Boolean;override;
		function Getpalette:Hpalette;override;

	public
		constructor Create;override;
		destructor Destroy;override;
		procedure Loadfromstream(Stream:Tstream);override;
		procedure Savetostream(Stream:Tstream);override;
		procedure Loadfromclipboardformat(Aformat:Word;Adata:Thandle;Apalette:Hpalette);override;
		procedure Loadfromresourcename(Instance:Thandle;const Resname:string);
		procedure Loadfromresourceid(Instance:Thandle;Resid:Integer);
		procedure Savetoclipboardformat(var Aformat:Word;var Adata:Thandle;var Apalette:Hpalette);override;
		procedure Assign(Source:Tpersistent);override;
		procedure Assignto(Dest:Tpersistent);override;
		function Releasehandle:Hicon;

		procedure Saveimagetofile(const Filename:string);

		// Save just the current image - SaveToFile saves all the images.

		property Handle:Hicon read Gethandle write Sethandle;
		property Pixelformat:Tpixelformat read Getpixelformat write Setpixelformat;
		property Imagecount:Integer read Getimagecount;
		property Images[index:Integer]:Texiconimage read Getimage;

		property Currentimage:Integer read Fcurrentimage write Setcurrentimage;
		property Transparentcolor:Tcolor read Ftransparentcolor write Ftransparentcolor;
	end;

	// -----------------------------------------------------------------------------
	// TExIcon

	Texicon=class(Texiconcursor)
	protected
	public
		constructor Create;override;
	end;

	// -----------------------------------------------------------------------------
	// TExCursor

	Texcursor=class(Texiconcursor)
	private
		function Gethotspot:Dword;
		procedure Sethotspot(const Value:Dword);
	protected
	public
		constructor Create;override;
		property Hotspot:Dword read Gethotspot write Sethotspot;

		// nb.  .CUR file format is not the same as resource stream format !!!!

		procedure Loadfromfile(const Filename:string);override;
		procedure Savetofile(const Filename:string);override;
	end;

function Getpixelformatnumcolors(Pf:Tpixelformat):Integer;
function Getpixelformatbitcount(Pf:Tpixelformat):Integer;

function Createmappedbitmap(Source:Tgraphic;Palette:Hpalette;Hipixelformat:Tpixelformat;Width,Height:Integer):Tbitmap;
function Getbitmapinfonumcolors(const Bi:Tbitmapinfoheader):Integer;
function Getbitmapinfopixelformat(const Bi:Tbitmapinfoheader):Tpixelformat;
procedure Getbitmapinfosizes(const Bi:Tbitmapinfoheader;var Infoheadersize,Imagesize:Dword;Iconinfo:Boolean);
function Getpixelformat(Graphic:Tgraphic):Tpixelformat;

var
	Systempalette256:Hpalette; // 256 color 'web' palette.
	Systempalette2:Hpalette;

implementation

uses
	Clipbrd;

resourcestring
	Rstinvalidicon='Invalid Icon or Cursor';
	Rstinvalidcursor='Invalid cursor';
	Rstinvalidbitmap='Invalid Bitmap';
	Rstinvalidpixelformat='Pixel Format Not Valid for Icons or Cursors';

	(* ----------------------------------------------------------------------*
		| GetPixelFormatNumColors                                              |
		|                                                                      |
		| Get number of colors for a pixel format.  0 if > pf8bit              |
		*---------------------------------------------------------------------- *)
function Getpixelformatnumcolors(Pf:Tpixelformat):Integer;
begin
	case Pf of
		Pf1bit:Result:=2;
		Pf4bit:Result:=16;
		Pf8bit:Result:=256;
	else Result:=0
	end
end;

(* ----------------------------------------------------------------------*
	| GetPixelFormatBitCount                                               |
	|                                                                      |
	| Get number of bits per pixel for a pixel format                      |
	*---------------------------------------------------------------------- *)
function Getpixelformatbitcount(Pf:Tpixelformat):Integer;
begin
	case Pf of
		Pf1bit:Result:=1;
		Pf4bit:Result:=4;
		Pf8bit:Result:=8;
		Pf15bit:Result:=16; // 16 bpp RGB.  1 unused, 5 R, 5 G, 5 B
		Pf16bit:Result:=16; // 16 bpp BITFIELDS
		Pf24bit:Result:=24;
		Pf32bit:Result:=32 // Either RGB (8 unused, 8 R, 8 G, 8 B) or 32 bit BITFIELDS
	else Result:=0
	end
end;

(* ----------------------------------------------------------------------*
	| GetPixelFormat                                                       |
	|                                                                      |
	| Get our pixel format.                                                |
	*---------------------------------------------------------------------- *)
function Getpixelformat(Graphic:Tgraphic):Tpixelformat;
begin
	if Graphic is Tbitmap then Result:=Tbitmap(Graphic).Pixelformat
	else if Graphic is Texiconcursor then Result:=Texiconcursor(Graphic).Pixelformat
	else Result:=Pfdevice
end;

(* ----------------------------------------------------------------------------*
	| function GDICheck()                                                        |
	|                                                                            |
	| Check GDI APIs                                                             |
	*---------------------------------------------------------------------------- *)
function Gdicheck(Value:Hgdiobj):Hgdiobj;
begin
	if Value=0 then Raiselastoserror;
	Result:=Value;
end;

(* ----------------------------------------------------------------------------*
	| procedure InitializeBitmapInfoHeader ()                                    |
	|                                                                            |
	| Initialize a TBitmapInfoHeader from a DIB or DDB bitmap                    |
	*---------------------------------------------------------------------------- *)
procedure Initializebitmapinfoheader(Bitmap:Hbitmap;var Bi:Tbitmapinfoheader;Pixelformat:Tpixelformat);
var
	Ds:Tdibsection;
	Bytes:Integer;
begin
	Ds.Dsbmih.Bisize:=0;
	Bytes:=Getobject(Bitmap,Sizeof(Ds),@Ds);
	if Bytes=0 then raise Einvalidgraphic.Create(Rstinvalidbitmap);

	if (Bytes>=(Sizeof(Ds.Dsbm)+Sizeof(Ds.Dsbmih)))and(Ds.Dsbmih.Bisize>=Dword(Sizeof(Ds.Dsbmih))) then Bi:=Ds.Dsbmih
		// It was a DIB bitmap
	else begin // It was a DDB bitmap
		Fillchar(Bi,Sizeof(Bi),0);
		with Bi,Ds.Dsbm do begin
			Bisize:=Sizeof(Bi);
			Biwidth:=Bmwidth;
			Biheight:=Bmheight;
		end;
	end;

	if Pixelformat in [Pf1bit..Pf8bit] then begin
		Bi.Bibitcount:=Getpixelformatbitcount(Pixelformat);
		Bi.Biclrused:=Getpixelformatnumcolors(Pixelformat)
	end else begin
		Bi.Bibitcount:=Ds.Dsbm.Bmbitspixel*Ds.Dsbm.Bmplanes;
		case Ds.Dsbm.Bmbitspixel of
			1:Bi.Biclrused:=2;
			4:Bi.Biclrused:=16;
			8:Bi.Biclrused:=256
		end
	end;

	Bi.Biplanes:=1;
	if Bi.Biclrimportant>Bi.Biclrused then Bi.Biclrimportant:=Bi.Biclrused;

	Bi.Bisizeimage:=0; // SDK sample IconPro always sets biSizeImage to 0.  It
	// seems to be safer to calculate the size from hight * bytes per
	// scan line.  So we'll do the same...
end;

(* ----------------------------------------------------------------------------*
	| function GetBitmapInfoNumColors                                            |
	|                                                                            |
	| Get the number of colors (0, 2..256) of a bitmap header.                   |
	*---------------------------------------------------------------------------- *)
function Getbitmapinfonumcolors(const Bi:Tbitmapinfoheader):Integer;
begin
	if Bi.Bibitcount<=8 then
		if Bi.Biclrused>0 then Result:=Bi.Biclrused
		else Result:=1 shl Bi.Bibitcount
	else Result:=0;
end;

(* ----------------------------------------------------------------------------*
	| function GetBitmapInfoPixelFormat                                          |
	|                                                                            |
	| Get the pixel format of a bitmap header.                                   |
	*---------------------------------------------------------------------------- *)
function Getbitmapinfopixelformat(const Bi:Tbitmapinfoheader):Tpixelformat;
begin
	case Bi.Bibitcount of
		1:Result:=Pf1bit;
		4:Result:=Pf4bit;
		8:Result:=Pf8bit;
		16: case Bi.Bicompression of
				Bi_rgb:Result:=Pf15bit;
				Bi_bitfields:Result:=Pf16bit;
			else raise Einvalidgraphic.Create(Rstinvalidpixelformat);
			end;
		24:Result:=Pf24bit;
		32:Result:=Pf32bit;
	else raise Einvalidgraphic.Create(Rstinvalidpixelformat);
	end
end;

(* ----------------------------------------------------------------------------*
	| procedure GetBitmapInfoSizes                                               |
	|                                                                            |
	| Get the size of the info (incl the colortable), and the bitmap bits        |
	*---------------------------------------------------------------------------- *)
procedure Getbitmapinfosizes(const Bi:Tbitmapinfoheader;var Infoheadersize,Imagesize:Dword;Iconinfo:Boolean);
var
	Numcolors:Integer;
	Height:Integer;
begin
	Infoheadersize:=Sizeof(Tbitmapinfoheader);

	Numcolors:=Getbitmapinfonumcolors(Bi);

	if Numcolors>0 then Inc(Infoheadersize,Sizeof(Trgbquad)*Numcolors)
	else if (Bi.Bicompression and Bi_bitfields)<>0 then Inc(Infoheadersize,12);

	Height:=Abs(Bi.Biheight);
	if Iconinfo then Height:=Height shr 1;
	Imagesize:=Bytesperscanline(Bi.Biwidth,Bi.Bibitcount,32)*Height
end;

(* ----------------------------------------------------------------------------*
	| procedure InternalGetDIBSizes ()                                           |
	|                                                                            |
	| Get size of bitmap header (incl. color table) and bitmap bits.             |
	*---------------------------------------------------------------------------- *)
procedure Internalgetdibsizes(Bitmap:Hbitmap;var Infoheadersize:Dword;var Imagesize:Dword;Pixelformat:Tpixelformat);
var
	Bi:Tbitmapinfoheader;
begin
	Initializebitmapinfoheader(Bitmap,Bi,Pixelformat);
	Getbitmapinfosizes(Bi,Infoheadersize,Imagesize,False);
end;

(* ----------------------------------------------------------------------------*
	| procedure InternalGetDIB ()                                                |
	|                                                                            |
	| Get bitmap bits.  Note that we *always* call this on a bitmap with the     |
	| required colour depth - ie. we don't use this to do mapping.               |
	|                                                                            |
	| We (therefore) don't use GetDIBits here to get the colour table.           |
	*---------------------------------------------------------------------------- *)
function Internalgetdib(Bitmap:Hbitmap;Palette:Hpalette;Bitmapinfo:Pbitmapinfo;var Bits;
	Pixelformat:Tpixelformat):Boolean;
var
	Oldpal:Hpalette;
	Dc:Hdc;
begin
	Initializebitmapinfoheader(Bitmap,Bitmapinfo^.Bmiheader,Pixelformat);
	Oldpal:=0;
	Dc:=Createcompatibledc(0);
	try
		if Palette<>0 then begin
			Oldpal:=Selectpalette(Dc,Palette,False);
			Realizepalette(Dc);
		end;
		Result:=Getdibits(Dc,Bitmap,0,Bitmapinfo^.Bmiheader.Biheight,@Bits,Bitmapinfo^,Dib_rgb_colors)<>0;
	finally
		if Oldpal<>0 then Selectpalette(Dc,Oldpal,False);
		Deletedc(Dc);
	end;
end;

(* ----------------------------------------------------------------------------*
	| procedure CreateDIBPalette ()                                              |
	|                                                                            |
	| Create the palette from bitmap info.                                       |
	*---------------------------------------------------------------------------- *)
function Createdibpalette(const Bmi:Tbitmapinfo):Hpalette;
var
	Lppal:Plogpalette;
	I:Integer;
	Numcolors:Integer;
	R:Rgbquad;
begin
	Result:=0;

	Numcolors:=Getbitmapinfonumcolors(Bmi.Bmiheader);

	if Numcolors>0 then begin
		if Numcolors=1 then Result:=Copypalette(Systempalette2)
		else begin
			Getmem(Lppal,Sizeof(Tlogpalette)+Sizeof(Tpaletteentry)*Numcolors);
			try
				Lppal^.Palversion:=$300;
				Lppal^.Palnumentries:=Numcolors;

{$R-}
				for I:=0 to Numcolors-1 do begin
					R:=Bmi.Bmicolors[I];
					Lppal^.Palpalentry[I].Pered:=Bmi.Bmicolors[I].Rgbred;
					Lppal^.Palpalentry[I].Pegreen:=Bmi.Bmicolors[I].Rgbgreen;
					Lppal^.Palpalentry[I].Peblue:=Bmi.Bmicolors[I].Rgbblue;
					Lppal^.Palpalentry[I].Peflags:=0
					// not bmi.bmiColors[i].rgbReserved !!
				end;
{$R+}
				Result:=Createpalette(Lppal^)
			finally Freemem(Lppal)
			end
		end
	end
end;

(* ----------------------------------------------------------------------------*
	| procedure CreateMappedBitmap                                               |
	|                                                                            |
	| Copy a graphic to a DIB bitmap with the specified palette or color         |
	| format, and size.                                                          |
	|                                                                            |
	| If the palette is 0, the returned bitmap's pixelformat is hiPixelFormat    |
	| otherwise the returned bitmap's pixel format is set so it's correct for    |
	| the number of colors in the palette.                                       |
	*---------------------------------------------------------------------------- *)
function Createmappedbitmap(Source:Tgraphic;Palette:Hpalette;Hipixelformat:Tpixelformat;Width,Height:Integer):Tbitmap;
var
	Colorcount:Integer;
begin
	Result:=Tbitmap.Create;
	Result.Width:=Source.Width;
	Result.Height:=Source.Height;

	if Palette<>0 then begin
		Colorcount:=0;
		if Getobject(Palette,Sizeof(Colorcount),@Colorcount)=0 then Raiselastoserror;

		case Colorcount of
			1..2:Result.Pixelformat:=Pf1bit;
			3..16:Result.Pixelformat:=Pf4bit;
			17..256:Result.Pixelformat:=Pf8bit;
		else Result.Pixelformat:=Hipixelformat;
		end;

		Result.Palette:=Copypalette(Palette);

		Result.Canvas.Stretchdraw(Rect(0,0,Width,Height),Source);
	end else begin
		Result.Pixelformat:=Hipixelformat;
		Result.Canvas.Stretchdraw(Rect(0,0,Width,Height),Source);
	end
end;

(* ----------------------------------------------------------------------------*
	| procedure MaskBitmapBits                                                   |
	|                                                                            |
	| Kinda like MaskBlt - but without the bugs.  SLOW.  Maybe I'll revisit this |
	| use bitblt instead...                                                      |
	|                                                                            |
	| But see MSDN PRB: Trouble Using DIBSection as a Monochrome Mask            |
	*---------------------------------------------------------------------------- *)
procedure Maskbitmapbits(Bits:Pchar;Pixelformat:Tpixelformat;Mask:Pchar;Width,Height:Dword;Palette:Hpalette);
var
	Bpscanline,Maskbpscanline:Integer;
	Bitsperpixel,I,J:Integer;
	Maskbp,Bitbp:Byte;
	Maskp,Bitp:Pchar;
	Maskpixel:Boolean;
	Maskbyte:Dword;
	Masku:Uint;
	Maskcolor:Byte;
	Maskcolorbyte:Byte;
begin
	// Get 'black' color index.  This is usually 0
	// but some people play jokes...

	if Palette<>0 then begin
		Masku:=Getnearestpaletteindex(Palette,Rgb(0,0,0));
		if Masku=Clr_invalid then Raiselastoserror;

		Maskcolor:=Masku
	end
	else Maskcolor:=0;

	Bitsperpixel:=Getpixelformatbitcount(Pixelformat);
	if Bitsperpixel=0 then raise Einvalidgraphic.Create(Rstinvalidpixelformat);

	// Get byte count for mask and bitmap
	// scanline.  Can be weird because of padding.

	Bpscanline:=Bytesperscanline(Width,Bitsperpixel,32);
	Maskbpscanline:=Bytesperscanline(Width,1,32);

	Maskbyte:=$FFFFFFFF; // Set constant values for 8bpp masks
	Maskcolorbyte:=Maskcolor;

	for I:=0 to Height-1 do // Go thru each scanline...
	begin

		Maskbp:=0; // Bit offset in current mask byte
		Bitbp:=0; // Bit offset in current bitmap byte
		Maskp:=Mask; // Pointer to current mask byte
		Bitp:=Bits; // Pointer to current bitmap byte;

		for J:=0 to Width-1 do // Go thru each pixel
		begin
			// Pixel should be masked?
			Maskpixel:=(Byte(Maskp^)and($80 shr Maskbp))<>0;
			if Maskpixel then begin
				case Bitsperpixel of
					1,4,8:begin
							case Bitsperpixel of // Calculate bit mask and 'black' color bits
								1:begin
										Maskbyte:=$80 shr Bitbp;
										Maskcolorbyte:=Maskcolor shl (7-Bitbp);
									end;

								4:begin
										Maskbyte:=$F0 shr Bitbp;
										Maskcolorbyte:=Maskcolor shl (4-Bitbp)
									end
							end;
							// Apply the mask
							Bitp^:=Char((Byte(Bitp^)and(not Maskbyte))or Maskcolorbyte);
						end;

					15,16:Pword(Bitp)^:=$0000;

					24:begin
							Pword(Bitp)^:=$0000;
							Pbyte(Bitp+Sizeof(Word))^:=$00
						end;

					32:Pdword(Bitp)^:=$FFFFFFFF;
				end
			end;

			Inc(Maskbp); // Next mask bit
			if Maskbp=8 then begin
				Maskbp:=0;
				Inc(Maskp) // Next mask byte
			end;

			Inc(Bitbp,Bitsperpixel); // Next bitmap bit(s)
			while Bitbp>=8 do begin
				Dec(Bitbp,8);
				Inc(Bitp) // Next bitmap byte
			end
		end;

		Inc(Mask,Maskbpscanline); // Set mask for start of next line
		Inc(Bits,Bpscanline) // Set bits to start of next line
	end
end;

{ TExIconCursor }

(* ----------------------------------------------------------------------------*
	| procedure TExIcon.Assign                                                   |
	|                                                                            |
	| Assign an TExIcon from another graphic.                                    |
	|                                                                            |
	| A bit of a compromise this...                                              |
	|                                                                            |
	| ... if source is a TExIcon then all images get replaced by the source      |
	|     images.                                                                |
	|                                                                            |
	| ...  Otherwise only the CurrentImage gets replaced                         |
	*---------------------------------------------------------------------------- *)
procedure Texiconcursor.Assign(Source:Tpersistent);
var
	I:Integer;
	Src:Texiconcursor;
	Image:Texiconimage;
	Data:Thandle;
begin
	if Source is Texiconcursor then begin // Share all images from the source TExIcon
		Src:=Texiconcursor(Source);
		Ftransparentcolor:=Src.Transparentcolor;

		Releaseimages;
		Setlength(Fimages,Src.Imagecount);

		for I:=0 to Imagecount-1 do begin
			Src.Images[I].Reference;
			Fimages[I]:=Src.Images[I]
		end;

		Fcurrentimage:=Src.Fcurrentimage;
		Changed(Self);
	end else if Source=nil then // Clear the current image.
	begin
		Image:=Texiconimage.Create;
		Image.Fisicon:=Images[Fcurrentimage].Fisicon;
		Image.Fwidth:=Images[Fcurrentimage].Width;
		Image.Fheight:=Images[Fcurrentimage].Height;
		Image.Fpixelformat:=Images[Fcurrentimage].Pixelformat;

		Images[Fcurrentimage].Release;
		Fimages[Fcurrentimage]:=Image;
		Image.Reference;
		Changed(Self);
	end else if Source is Tgraphic then // Copy from other graphic (TBitmap, etc)
			Assignfromgraphic(Tgraphic(Source))
	else if Source is Tclipboard then begin
		Clipboard.Open;
		try
			Data:=Getclipboarddata(Cf_dib);
			Loadfromclipboardformat(Cf_dib,Data,0);
		finally Clipboard.Close
		end;
	end
	else inherited Assign(Source)

end;

(* ----------------------------------------------------------------------------*
	| procedure TExIconCursor.AssignFromGraphic                                  |
	|                                                                            |
	| Assign an TExIcon from another graphic, converting it to our pixel format  |
	| and palette.                                                               |
	|                                                                            |
	| Internal use only!                                                         |
	*---------------------------------------------------------------------------- *)
procedure Texiconcursor.Assignfromgraphic(Source:Tgraphic);
var
	Src,Maskbmp:Tbitmap;
	Offset,Infoheadersize,Imagesize,Maskimagesize:Dword;
	Colorbits,Maskbits:Pchar;
	Image:Texiconimage;
	Info:Pbitmapinfo;
	Maskinfo:Pbitmapinfo;
	Dc:Hdc;
begin
	Src:=nil;
	Maskbmp:=Tbitmap.Create;

	try
		// Get a bitmap with the required format
		Src:=Createmappedbitmap(Source,Palette,Pixelformat,Width,Height);

		if Source is Ticon then begin
			Maskbmp.Width:=Source.Width;
			Maskbmp.Height:=Source.Height;
			Maskbmp.Palette:=Source.Palette;
			Maskbmp.Canvas.Draw(0,0,Source)
		end
		else Maskbmp.Assign(Source);
		// Get mask bitmap - White where the transparent color
		// occurs - otherwise black.

		if Source is Tbitmap then Maskbmp.Mask(Tbitmap(Source).Transparentcolor)
		else if Source is Texiconcursor then Maskbmp.Mask(Texiconcursor(Source).Transparentcolor)
		else Maskbmp.Mask(Clblack);

		// Get size for mask bits buffer
		Maskimagesize:=Bytesperscanline(Width,1,32)*Height;

		// Get size for color bits buffer
		Internalgetdibsizes(Src.Handle,Infoheadersize,Imagesize,Pixelformat);

		// Create a memory stream to assemble the icon image
		Image:=Texiconimage.Create;
		try
			Image.Reference;
			Image.Fmemoryimage:=Tmemorystream.Create;
			Image.Fisicon:=Self is Texicon;

			if Image.Fisicon then Offset:=0
			else Offset:=Sizeof(Dword);

			Image.Fmemoryimage.Size:=Infoheadersize+Imagesize+Maskimagesize+Offset;

			Info:=Pbitmapinfo(Pchar(Image.Fmemoryimage.Memory)+Offset);
			Colorbits:=Pchar(Info)+Infoheadersize;
			Maskbits:=Colorbits+Imagesize;

			Internalgetdib(Src.Handle,Palette,Info,Colorbits^,Pixelformat);
			// Get the bitmap header, palette & bits

			Maskinfo:=nil;
			Dc:=Createcompatibledc(0);
			try
				Getmem(Maskinfo,Sizeof(Tbitmapinfoheader)+2*Sizeof(Rgbquad));
				// Get mask bits

				with Maskinfo^.Bmiheader do
				// Set the 1st six members of info header, according
				begin // to the docs.

					Bisize:=Sizeof(Tbitmapinfoheader);
					Biwidth:=Width;
					Biheight:=Height;
					Bibitcount:=1;
					Biplanes:=1;
					Bicompression:=Bi_rgb;
				end;

				if Getdibits(Dc,Maskbmp.Handle,0,Height,Maskbits,Maskinfo^,Dib_rgb_colors)=0 then Raiselastoserror;
			finally
				Deletedc(Dc);
				Freemem(Maskinfo)
			end;

			Maskbitmapbits(Colorbits,Pixelformat,Maskbits,Width,Height,Palette);

			Image.Fwidth:=Info^.Bmiheader.Biwidth;
			Image.Fheight:=Info^.Bmiheader.Biheight;

			Info^.Bmiheader.Biheight:=Info^.Bmiheader.Biheight*2;
			// Adjust height for funky icon Height thing.

			Image.Fpixelformat:=Src.Pixelformat;

			Image.Fgotpalette:=False; // ie.  we need to get it later if required.

			if Self is Texcursor then Pdword(Image.Fmemoryimage.Memory)^:=Texcursor(Self).Hotspot;

			Images[Fcurrentimage].Release;
			Fimages[Fcurrentimage]:=Image;
			Changed(Self);
		except
			Image.Free;
			raise
		end;
	finally
		Maskbmp.Free;
		Src.Free
	end
end;

(* ----------------------------------------------------------------------------*
	| procedure TExIconCursor.AssignTo                                           |
	|                                                                            |
	| Allow assigning to bitmap                                                  |
	*---------------------------------------------------------------------------- *)
procedure Texiconcursor.Assignto(Dest:Tpersistent);
var
	Bmp:Tbitmap;
begin
	if Dest is Tbitmap then begin
		Bmp:=Tbitmap(Dest);
		Bmp.Assign(nil); // You gotta do this, otherwise transparency goes nuts!
		Bmp.Pixelformat:=Pf24bit;
		// Always assign to 24-bit Bitmap so we don't lose colors

		Bmp.Width:=Width;
		Bmp.Height:=Height;

		Bmp.Transparent:=True;
		Bmp.Transparentcolor:=Transparentcolor;
		Bmp.Canvas.Brush.Color:=Transparentcolor;
		Bmp.Canvas.Fillrect(Rect(0,0,Width,Height));
		Bmp.Canvas.Draw(0,0,Self);
	end
	else inherited Assignto(Dest)
end;

(* ----------------------------------------------------------------------------*
	| constructor TExIconCursor.Create                                           |
	|                                                                            |
	| Constructor for TExICon                                                    |
	*---------------------------------------------------------------------------- *)
constructor Texiconcursor.Create;
begin
	inherited Create;
	Ftransparentcolor:=Rgb($FE,$E6,$F8);
	Setlength(Fimages,1);
	Fimages[0]:=Texiconimage.Create;
	Fimages[0].Fisicon:=Self is Texicon;
	Images[0].Reference;
end;

(* ----------------------------------------------------------------------------*
	| destructor TExIconCursor.Destroy                                           |
	|                                                                            |
	| destructor for TExIconCursor                                               |
	*---------------------------------------------------------------------------- *)
destructor Texiconcursor.Destroy;
begin
	Releaseimages;
	inherited Destroy
end;

(* ----------------------------------------------------------------------------*
	| procedure TExIconCursor.Draw                                               |
	|                                                                            |
	| We should be able to do HandleNeeded/DrawIconEx, however we don't want to  |
	| call 'HandleNeeded' because of NT bugs, so jump through hoops to draw      |
	| direct from the memory image instead.                                      |
	*---------------------------------------------------------------------------- *)
procedure Texiconcursor.Draw(Acanvas:Tcanvas;const Rect:Trect);
var
	Monobmp,Oldmonobmp:Hbitmap;
	Colorbmp,Oldcolorbmp:Hbitmap;
	Colordc,Monodc,Dc:Hdc;
	Bitsoffset,Bitssize:Dword;
	Info:Pbitmapinfo;
	Hdr:Pbitmapinfoheader;
	Monoinfo:Pbitmapinfo;
	Bits:Pchar;

begin
	with Fimages[Fcurrentimage] do
		if Assigned(Fmemoryimage) then begin
			Info:=Getbitmapinfo;
			Hdr:=@Info^.Bmiheader;

			Colorbmp:=0;
			Monobmp:=0;
			Oldcolorbmp:=0;
			Oldmonobmp:=0;
			Monodc:=0;
			Colordc:=0;
			Monoinfo:=nil;

			Dc:=Gdicheck(Getdc(0));
			try
				Hdr^.Biheight:=Hdr^.Biheight div 2;
				// Adjust memory image for funky Icon Height thing.

				Getbitmapinfosizes(Hdr^,Bitsoffset,Bitssize,False);

				// Create Color Bitmap from Color bits & ColorTable
				Colorbmp:=Gdicheck(Createdibitmap(Dc,Info^.Bmiheader,Cbm_init,Pchar(Info)+Bitsoffset,Info^,Dib_rgb_colors));
				Colordc:=Gdicheck(Createcompatibledc(0));
				Oldcolorbmp:=Gdicheck(Selectobject(Colordc,Colorbmp));

				// Create mono bitmap.  For some reason, CreateBitmap
				// creates it upside down if you give it the bits - so
				// you have to do CreateBitmap followed by SetDIBtes

				if Pixelformat<>Pf32bit then begin
					Getmem(Monoinfo,Sizeof(Tbitmapinfoheader)+2*Sizeof(Rgbquad));
					Move(Hdr^,Monoinfo^,Sizeof(Tbitmapinfoheader));
					Monoinfo^.Bmiheader.Bibitcount:=1;
					Monoinfo^.Bmiheader.Bicompression:=0;
					with Prgbquad(Pchar(Monoinfo)+Sizeof(Tbitmapinfoheader)+Sizeof(Rgbquad))^ do begin
						Rgbred:=$FF;
						Rgbgreen:=$FF;
						Rgbblue:=$FF;
						Rgbreserved:=0;
					end;

					Monobmp:=Gdicheck(Createbitmap(Hdr^.Biwidth,Hdr^.Biheight,1,1,nil));
					Bits:=Pchar(Info)+Bitsoffset+Bitssize;
					Monodc:=Gdicheck(Createcompatibledc(0));
					Gdicheck(Setdibits(Monodc,Monobmp,0,Hdr^.Biheight,Bits,Monoinfo^,Dib_rgb_colors));
					Oldmonobmp:=Gdicheck(Selectobject(Monodc,Monobmp));
					// Draw the masked bitmap

					with Rect do
							Transparentstretchblt(Acanvas.Handle,Left,Top,Right-Left,Bottom-Top,Colordc,0,0,Hdr^.Biwidth,
							Hdr^.Biheight,Monodc,0,0);

				end
				else
					with Rect do
							Stretchdibits(Acanvas.Handle,Left,Top,Right-Left,Bottom-Top,0,0,Hdr^.Biwidth,Hdr^.Biheight,
							Pchar(Info)+Bitsoffset,Info^,Dib_rgb_colors,Srccopy);
			finally
				Hdr^.Biheight:=Hdr^.Biheight*2;

				if Oldmonobmp<>0 then Selectobject(Monodc,Oldmonobmp);
				if Monodc<>0 then Deletedc(Monodc);

				if Oldcolorbmp<>0 then Selectobject(Colordc,Oldcolorbmp);
				if Colordc<>0 then Deletedc(Colordc);

				if Colorbmp<>0 then Deleteobject(Colorbmp);
				if Monobmp<>0 then Deleteobject(Monobmp);
				Releasedc(0,Dc);
				if Monoinfo<>nil then Freemem(Monoinfo)
			end
		end else begin

			// If you've fed an HICON in directly to the handle property you'll get here.
			// DrawIconEx seems to work - it's CreateIconFromresourceex that blows up...

			if Handle<>0 then
				with Rect do Drawiconex(Acanvas.Handle,Left,Top,Handle,Right-Left,Bottom-Top,0,0,Di_normal)
		end
end;

(* ----------------------------------------------------------------------------*
	| function TExIconCursor.GetEmpty                                            |
	|                                                                            |
	| Returns true if the TExIconCursor's current image  has neither a handle or |
	| an image                                                                   |
	*---------------------------------------------------------------------------- *)
function Texiconcursor.Getempty:Boolean;
begin
	with Fimages[Fcurrentimage] do Result:=(Fhandle=0)and(Fmemoryimage=nil);
end;

(* ----------------------------------------------------------------------------*
	| function TExIconCursor.GetHandle                                           |
	|                                                                            |
	| Returns the current image's icon handle.  Calls HandleNeeded which may not |
	| be reliable under NT.                                                      |
	*---------------------------------------------------------------------------- *)
function Texiconcursor.Gethandle:Hicon;
begin
	Handleneeded;
	Result:=Images[Fcurrentimage].Handle
end;

(* ----------------------------------------------------------------------------*
	| function TExIconCursor.GetHeight                                           |
	|                                                                            |
	| Returns the current image's height in pixels                               |
	*---------------------------------------------------------------------------- *)
function Texiconcursor.Getheight:Integer;
begin
	Result:=Fimages[Fcurrentimage].Fheight;
end;

(* ----------------------------------------------------------------------------*
	| function TExIconCursor.GetImage                                            |
	|                                                                            |
	| Get the current image TExIconImage instance                                |
	*---------------------------------------------------------------------------- *)
function Texiconcursor.Getimage(Index:Integer):Texiconimage;
begin
	Result:=Fimages[index]
end;

(* ----------------------------------------------------------------------------*
	| function TExIconCursor.GetImageCount                                       |
	|                                                                            |
	| Get the nuber of images in the current icon or cursor                      |
	*---------------------------------------------------------------------------- *)
function Texiconcursor.Getimagecount:Integer;
begin
	Result:=Length(Fimages);
end;

(* ----------------------------------------------------------------------------*
	| function TExIconCursor.GetPalette                                          |
	|                                                                            |
	| Get the palette handle for the current image                               |
	*---------------------------------------------------------------------------- *)
function Texiconcursor.Getpalette:Hpalette;
begin
	Paletteneeded;
	Result:=Fimages[Fcurrentimage].Fpalette;
end;

(* ----------------------------------------------------------------------------*
	| function TExIconCursor.GetPixelFormat : TPixelFormat                       |
	|                                                                            |
	| Get the pixel format for the current image                                 |
	*---------------------------------------------------------------------------- *)
function Texiconcursor.Getpixelformat:Tpixelformat;
begin
	Result:=Fimages[Fcurrentimage].Fpixelformat
end;

(* ----------------------------------------------------------------------------*
	| function TExIconCursor.GetTransparent : boolean                            |
	|                                                                            |
	| Overrides TGraphic method to always return TRUE                            |
	*---------------------------------------------------------------------------- *)
function Texiconcursor.Gettransparent:Boolean;
begin
	Result:=True
end;

(* ----------------------------------------------------------------------------*
	| function TExIconCursor.GetWidth : Integer                                  |
	|                                                                            |
	| Returns the current image's width in pixels                                |
	*---------------------------------------------------------------------------- *)
function Texiconcursor.Getwidth:Integer;
begin
	Result:=Fimages[Fcurrentimage].Fwidth;
end;

(* ----------------------------------------------------------------------------*
	| procedure TExIconCursor.HandleNeeded                                       |
	|                                                                            |
	| Ensure that an HICON handle exists for the current image.  Don't use this  |
	| unless strictly necessary.  It may bugger up in NT4                        |
	*---------------------------------------------------------------------------- *)
procedure Texiconcursor.Handleneeded;
begin
	Fimages[Fcurrentimage].Handleneeded;
end;

(* ----------------------------------------------------------------------------*
	| procedure TExIconCursor.ImageNeeded                                        |
	|                                                                            |
	| Ensure that a memory image exists for the current image.                   |
	*---------------------------------------------------------------------------- *)
procedure Texiconcursor.Imageneeded;
begin
	with Fimages[Fcurrentimage] do Imageneeded;
end;

(* ----------------------------------------------------------------------------*
	| procedure TExIconCursor.LoadFromClipboardFormat                            |
	|                                                                            |
	| Ensure that a memory image exists for the current image.  Affects just the |
	| current image.                                                             |
	*---------------------------------------------------------------------------- *)
procedure Texiconcursor.Loadfromclipboardformat(Aformat:Word;Adata:Thandle;Apalette:Hpalette);
var
	Info:Pbitmapinfo;
	Image:Texiconimage;
	Size:Dword;
	Infoheadersize,Imagesize,Monosize:Dword;
	Mask:Pbyte;
begin
	Size:=Globalsize(Adata);
	if (Size>0)and(Aformat=Cf_dib) then begin

		Image:=Texiconimage.Create;
		Image.Fmemoryimage:=Tmemorystream.Create;
		Image.Reference;

		try
			Info:=Pbitmapinfo(Globallock(Adata));
			try
				Image.Fisicon:=Images[Fcurrentimage].Fisicon;

				Image.Fwidth:=Info^.Bmiheader.Biwidth;
				Image.Fheight:=Info^.Bmiheader.Biheight;
				Image.Fpixelformat:=Getbitmapinfopixelformat(Info^.Bmiheader);

				Getbitmapinfosizes(Info^.Bmiheader,Infoheadersize,Imagesize,False);
				Monosize:=Image.Width*Image.Fheight div 8;

				if Size=Infoheadersize+Imagesize+Monosize then Image.Fmemoryimage.Write(Info^,Infoheadersize+Imagesize+Monosize)
				else begin
					Image.Fmemoryimage.Write(Info^,Infoheadersize+Imagesize);
					Getmem(Mask,Monosize);
					try
						Fillchar(Mask^,Monosize,$00);
						Image.Fmemoryimage.Write(Mask^,Monosize)
					finally Freemem(Mask)
					end
				end;
				Pbitmapinfo(Image.Fmemoryimage.Memory)^.Bmiheader.Biheight:=Info^.Bmiheader.Biheight*2;
			finally Globalunlock(Adata)
			end
		except
			Image.Release;
			raise
		end;

		Fimages[Fcurrentimage].Release;
		Fimages[Fcurrentimage]:=Image
	end
end;

procedure Texiconcursor.Loadfromresourceid(Instance:Thandle;Resid:Integer);
var
	Stream:Tcustommemorystream;
begin
	Stream:=Tresourcestream.Createfromid(Instance,Resid,Rt_icon);
	try Readicon(Instance,Stream,Stream.Size);
	finally Stream.Free;
	end;
end;

procedure Texiconcursor.Loadfromresourcename(Instance:Thandle;const Resname:string);
var
	Stream:Tcustommemorystream;
begin
	Stream:=Tresourcestream.Create(Instance,Resname,Rt_group_icon);
	try Readicon(Instance,Stream,Stream.Size);
	finally Stream.Free;
	end;
end;

(* ----------------------------------------------------------------------------*
	| procedure TExIconCursor.LoadFromStream                                     |
	|                                                                            |
	| Load all images from a stream                                              |
	*---------------------------------------------------------------------------- *)
procedure Texiconcursor.Loadfromstream(Stream:Tstream);
var
	Hdr:Ticonheader;
	Direntry: array of Ticondirentry;
	I:Integer;
	P:Pbitmapinfoheader;
begin
	Stream.Read(Hdr,Sizeof(Hdr));

	if (Self is Texicon)<>(Hdr.Wtype=1) then raise Einvalidgraphic.Create(Rstinvalidicon);

	Releaseimages; // Get rid of existing images

	Setlength(Fimages,Hdr.Wcount);
	Setlength(Direntry,Hdr.Wcount);

	// Create and initialize the ExIconImage classes and read
	// the dirEntry structures from the stream.

	for I:=0 to Hdr.Wcount-1 do begin
		Fimages[I]:=Texiconimage.Create;
		Fimages[I].Fisicon:=Self is Texicon;
		Fimages[I].Fmemoryimage:=Tmemorystream.Create;
		Fimages[I].Reference;

		Stream.Read(Direntry[I],Sizeof(Ticondirentry));
		Fimages[I].Fwidth:=Direntry[I].Bwidth;
		Fimages[I].Fheight:=Direntry[I].Bheight;
	end;

	// Read the icon images into their Memory streams
	for I:=0 to Hdr.Wcount-1 do begin

		Stream.Seek(Direntry[I].Dwimageoffset,Sofrombeginning);

		Fimages[I].Fmemoryimage.Copyfrom(Stream,Direntry[I].Dwbytesinres);

		P:=Fimages[I].Getbitmapinfoheader;
		P^.Bisizeimage:=0;

		Fimages[I].Fpixelformat:=Getbitmapinfopixelformat(P^);
	end;

	Fcurrentimage:=0;
	Changed(Self);
end;

(* ----------------------------------------------------------------------------*
	| procedure TExIconCursor.PaletteNeeded                                      |
	|                                                                            |
	| The palette is needed for the current image                                |
	*---------------------------------------------------------------------------- *)
procedure Texiconcursor.Paletteneeded;
begin
	Fimages[Fcurrentimage].Paletteneeded;
end;

(* ----------------------------------------------------------------------------*
	| procedure TExIconCursor.ReleaseImages                                      |
	|                                                                            |
	| Release images for the icon.  Internal use only - you must set up at least |
	| one new image after calling it.                                            |
	*---------------------------------------------------------------------------- *)
procedure Texiconcursor.Readicon(Instance:Thandle;Stream:Tcustommemorystream;Size:Integer);
var
	Hdr:Ticonheader;
	Resdir:Tresourcedirectory;
	I:Integer;
	Strm1:Tcustommemorystream;
	P:Pbitmapinfoheader;
begin
	Stream.Read(Hdr,Sizeof(Hdr));

	if (Self is Texicon)<>(Hdr.Wtype=1) then raise Einvalidgraphic.Create(Rstinvalidicon);

	Releaseimages; // Get rid of existing images

	Setlength(Fimages,Hdr.Wcount);

	for I:=0 to Hdr.Wcount-1 do begin
		Stream.Read(Resdir,Sizeof(Resdir));

		Strm1:=Tresourcestream.Createfromid(Instance,Resdir.Wnameordinal,Rt_icon);
		try
			Fimages[I]:=Texiconimage.Create;
			Fimages[I].Fisicon:=Self is Texicon;
			Fimages[I].Fmemoryimage:=Tmemorystream.Create;
			Fimages[I].Reference;

			if Self is Texicon then begin
				Fimages[I].Fwidth:=Resdir.Details.Iconwidth;
				Fimages[I].Fheight:=Resdir.Details.Iconheight
			end else begin
				Fimages[I].Fwidth:=Resdir.Details.Cursorwidth;
				Fimages[I].Fheight:=Resdir.Details.Cursorheight
			end;

			Fimages[I].Fmemoryimage.Copyfrom(Strm1,0);
			P:=Fimages[I].Getbitmapinfoheader;
			P^.Bisizeimage:=0;

			Fimages[I].Fpixelformat:=Getbitmapinfopixelformat(P^);
		finally Strm1.Free
		end
	end;

	Fcurrentimage:=0;
	Changed(Self);
end;

function Texiconcursor.Releasehandle:Hicon;
begin
	Handleneeded;
	if Fimages[Fcurrentimage].Refcount>1 then Result:=Copyicon(Fimages[Fcurrentimage].Fhandle)
	else begin
		Result:=Fimages[Fcurrentimage].Fhandle;
		Fimages[Fcurrentimage].Fhandle:=0
	end
end;

procedure Texiconcursor.Releaseimages;
var
	I:Integer;
begin
	for I:=0 to Length(Fimages)-1 do Fimages[I].Release;

	Setlength(Fimages,0)
end;

(* ----------------------------------------------------------------------*
	| TExIconCursor.SaveImageToFile
	|                                                                      |
	*---------------------------------------------------------------------- *)
procedure Texiconcursor.Saveimagetofile(const Filename:string);
// Save current image to 'ico' file
var
	Hdr:Ticonheader;
	Direntry:Ticondirentry;
	Image:Texiconimage;
	Dirsize:Integer;
	Stream:Tstream;
begin
	Hdr.Wreserved:=0;
	if not(Self is Texcursor) then Hdr.Wtype:=1
	else Hdr.Wtype:=2;
	Hdr.Wcount:=1;

	Stream:=Tfilestream.Create(Filename,Fmcreate);
	try
		Stream.Write(Hdr,Sizeof(Hdr));
		Dirsize:=Sizeof(Direntry)+Sizeof(Hdr);

		Imageneeded;
		Image:=Images[Currentimage];

		Fillchar(Direntry,Sizeof(Direntry),0);

		Direntry.Bwidth:=Image.Width;
		Direntry.Bheight:=Image.Height;

		case Image.Pixelformat of
			Pf1bit:begin
					Direntry.Bcolorcount:=2;
					Direntry.Wbitcount:=0;
				end;
			Pf4bit:begin
					Direntry.Bcolorcount:=16;
					Direntry.Wbitcount:=0;
				end;
			Pf8bit:begin
					Direntry.Bcolorcount:=0;
					Direntry.Wbitcount:=8;
				end;
			Pf16bit:begin
					Direntry.Bcolorcount:=0;
					Direntry.Wbitcount:=16;
				end;
			Pf24bit:begin
					Direntry.Bcolorcount:=0;
					Direntry.Wbitcount:=24;
				end;
			Pf32bit:begin
					Direntry.Bcolorcount:=0;
					Direntry.Wbitcount:=32;
				end;
		else raise Einvalidgraphic.Create(Rstinvalidicon);
		end;

		if Hdr.Wtype=2 then begin
			Direntry.Wplanes:=Loword(Texcursor(Self).Hotspot);
			Direntry.Wbitcount:=Hiword(Texcursor(Self).Hotspot)
		end
		else Direntry.Wplanes:=1;
		Direntry.Dwbytesinres:=Image.Fmemoryimage.Size;
		if Hdr.Wtype=2 then begin
			Image.Fmemoryimage.Seek(Sizeof(Dword),Sofrombeginning);
			Dec(Direntry.Dwbytesinres,Sizeof(Dword))
		end
		else Image.Fmemoryimage.Seek(0,Sofrombeginning);

		Direntry.Dwimageoffset:=Dirsize;
		Stream.Write(Direntry,Sizeof(Direntry));
		Stream.Copyfrom(Image.Fmemoryimage,Image.Fmemoryimage.Size-Image.Fmemoryimage.Position);

	finally Stream.Free
	end
end;

(* ----------------------------------------------------------------------------*
	| procedure TExIconCursor.SaveToClipboardFormat                              |
	|                                                                            |
	| Saves the image on the clipboard as a DDB                                  |
	*---------------------------------------------------------------------------- *)
procedure Texiconcursor.Savetoclipboardformat(var Aformat:Word;var Adata:Thandle;var Apalette:Hpalette);
var
	Info:Pbitmapinfo;
	Infoheadersize,Imagesize,Monosize:Dword;
	Buf:Pchar;
begin
	Aformat:=Cf_dib;
	Imageneeded;
	Info:=Images[Fcurrentimage].Getbitmapinfo;
	Info^.Bmiheader.Biheight:=Info^.Bmiheader.Biheight div 2;
	try
		Getbitmapinfosizes(Info^.Bmiheader,Infoheadersize,Imagesize,False);
		Monosize:=Width*Height div 8;

		Adata:=Globalalloc(Gmem_ddeshare,Infoheadersize+Imagesize+Monosize);
		Buf:=Globallock(Adata);
		try Move(Info^,Buf^,Infoheadersize+Imagesize+Monosize);
		finally Globalunlock(Adata)
		end;

		Apalette:=0; // Don't need the palette, cause we've copied the DIB
	finally Info^.Bmiheader.Biheight:=Info^.Bmiheader.Biheight*2
	end;
end;

procedure Texiconcursor.Savetostream(Stream:Tstream);
var
	Hdr:Ticonheader;
	Direntry:Ticondirentry;
	Image:Texiconimage;
	I,Dirsize,Offset:Integer;
	Oldcurrentimage:Integer;
begin
	Hdr.Wreserved:=0;
	if not(Self is Texcursor) then Hdr.Wtype:=1
	else Hdr.Wtype:=2;
	Hdr.Wcount:=Imagecount;

	Stream.Write(Hdr,Sizeof(Hdr));
	Dirsize:=Imagecount*Sizeof(Direntry)+Sizeof(Hdr);

	Oldcurrentimage:=Fcurrentimage;
	try
		Offset:=0;
		for I:=0 to Imagecount-1 do begin
			Fcurrentimage:=I;
			Imageneeded;
			Image:=Images[I];

			Fillchar(Direntry,Sizeof(Direntry),0);

			Direntry.Bwidth:=Image.Width;
			Direntry.Bheight:=Image.Height;

			case Image.Pixelformat of
				Pf1bit:begin
						Direntry.Bcolorcount:=2;
						Direntry.Wbitcount:=0;
					end;
				Pf4bit:begin
						Direntry.Bcolorcount:=16;
						Direntry.Wbitcount:=0;
					end;
				Pf8bit:begin
						Direntry.Bcolorcount:=0;
						Direntry.Wbitcount:=8;
					end;
				Pf16bit:begin
						Direntry.Bcolorcount:=0;
						Direntry.Wbitcount:=16;
					end;
				Pf24bit:begin
						Direntry.Bcolorcount:=0;
						Direntry.Wbitcount:=24;
					end;
				Pf32bit:begin
						Direntry.Bcolorcount:=0;
						Direntry.Wbitcount:=32;
					end;
			else raise Einvalidgraphic.Create(Rstinvalidicon);
			end;

			Direntry.Wplanes:=1;
			Direntry.Dwbytesinres:=Image.Fmemoryimage.Size;
			Direntry.Dwimageoffset:=Dirsize+Offset;

			Stream.Write(Direntry,Sizeof(Direntry));
			Inc(Offset,Direntry.Dwbytesinres);
		end
	finally Fcurrentimage:=Oldcurrentimage
	end;

	for I:=0 to Imagecount-1 do Images[I].Fmemoryimage.Savetostream(Stream);
end;

procedure Texiconcursor.Setcurrentimage(const Value:Integer);
begin
	if Fcurrentimage<>Value then begin
		Fcurrentimage:=Value;
		Changed(Self)
	end
end;

procedure Texiconcursor.Sethandle(const Value:Hicon);
var
	Iconinfo:Ticoninfo;
	Bi:Tbitmapinfoheader;
	Image:Texiconimage;
begin
	if Geticoninfo(Value,Iconinfo) then
		try
			Image:=Texiconimage.Create;
			try
				Initializebitmapinfoheader(Iconinfo.Hbmcolor,Bi,Pfdevice);
				Image.Fisicon:=Self is Texicon;
				Image.Fwidth:=Bi.Biwidth;
				Image.Fheight:=Bi.Biheight;
				Image.Fpixelformat:=Getbitmapinfopixelformat(Bi);
			except
				Image.Free;
				raise
			end;

			Image.Fhandle:=Value;

			Images[Fcurrentimage].Release;
			Fimages[Fcurrentimage]:=Image;
			Image.Reference;
			Changed(Self)
		finally
			Deleteobject(Iconinfo.Hbmmask);
			Deleteobject(Iconinfo.Hbmcolor)
		end
	else Raiselastoserror;
end;

procedure Texiconcursor.Setheight(Value:Integer);
begin
	if Value=Height then Exit;
	Images[Fcurrentimage].Fheight:=Value;
	Assignfromgraphic(Self);
end;

(* ----------------------------------------------------------------------------*
	| procedure TExIconCursor.SetPalette                                         |
	|                                                                            |
	| Modify the icon so it uses a new palette (with maybe a differnt color      |
	| count, hence pixel format...                                               |
	*---------------------------------------------------------------------------- *)
procedure Texiconcursor.Setpalette(Value:Hpalette);
var
	Colorcount:Dword;
	Newpixelformat:Tpixelformat;
begin
	Newpixelformat:=Pfdevice;
	Colorcount:=0;
	if Getobject(Value,Sizeof(Colorcount),@Colorcount)=0 then Raiselastoserror;

	case Colorcount of
		1..2:Newpixelformat:=Pf1bit;
		3..16:Newpixelformat:=Pf4bit;
		17..256:Newpixelformat:=Pf8bit;
	end;

	if Fimages[Fcurrentimage].Fpalette<>0 then Deleteobject(Fimages[Fcurrentimage].Fpalette);

	if Newpixelformat<>Pfdevice then begin
		Fimages[Fcurrentimage].Fpixelformat:=Newpixelformat;

		Fimages[Fcurrentimage].Fpalette:=Copypalette(Value);
		Fimages[Fcurrentimage].Fgotpalette:=Fimages[Fcurrentimage].Fpalette<>0;
		Assignfromgraphic(Self);
	end else begin
		Fimages[Fcurrentimage].Fpalette:=0;
		Fimages[Fcurrentimage].Fgotpalette:=True
	end
end;

(* ----------------------------------------------------------------------------*
	| procedure TExIconCursor.SetPixelFormat                                     |
	|                                                                            |
	| Modify the icon so it uses a new pixel format.  If this pixel format has   |
	| <= 256 colours, apply an appropriate palette.  Could modify this to use    |
	| sophisticated color reduction, but at the moment it uses the 'default'     |
	| 16 color palete, and the 'netscape' 256 color one.                         |
	*---------------------------------------------------------------------------- *)
procedure Texiconcursor.Setpixelformat(const Value:Tpixelformat);
var
	Newpalette:Hpalette;
begin
	if Value=Pixelformat then Exit;

	case Value of
		Pf1bit:Newpalette:=Systempalette2;
		Pf4bit:Newpalette:=Systempalette16;
		Pf8bit:Newpalette:=Systempalette256;
	else Newpalette:=0
	end;

	Fimages[Fcurrentimage].Fpixelformat:=Value;

	if Fimages[Fcurrentimage].Fpalette<>0 then Deleteobject(Fimages[Fcurrentimage].Fpalette);

	if Newpalette<>0 then begin
		Fimages[Fcurrentimage].Fpalette:=Copypalette(Newpalette);
		Fimages[Fcurrentimage].Fgotpalette:=Fimages[Fcurrentimage].Fpalette<>0;
	end else begin
		Fimages[Fcurrentimage].Fpalette:=0;
		Fimages[Fcurrentimage].Fgotpalette:=True
	end;

	Assignfromgraphic(Self)
end;

procedure Texiconcursor.Setwidth(Value:Integer);
begin
	if Value=Width then Exit;

	Images[Fcurrentimage].Fwidth:=Value;
	Assignfromgraphic(Self);
end;

{ TExIconImage }

destructor Texiconimage.Destroy;
begin
	Fmemoryimage.Free;
	inherited // Which calls FreeHandle if necessary
end;

procedure Texiconimage.Freehandle;
begin
	if Fhandle<>0 then Destroyicon(Fhandle);

	if Fpalette<>0 then Deleteobject(Fpalette);
	Fgotpalette:=False;
	Fpalette:=0;
	Fhandle:=0;
end;

function Texiconimage.Getbitmapinfo:Pbitmapinfo;
begin
	if Assigned(Fmemoryimage) then
		if Fisicon then Result:=Pbitmapinfo(Fmemoryimage.Memory)
		else Result:=Pbitmapinfo(Pchar(Fmemoryimage.Memory)+Sizeof(Dword))
	else Result:=nil
end;

function Texiconimage.Getbitmapinfoheader:Pbitmapinfoheader;
begin
	Result:=Pbitmapinfoheader(Getbitmapinfo)
end;

function Texiconimage.Getmemoryimage:Tcustommemorystream;
begin
	Imageneeded;
	Result:=Fmemoryimage
end;

(* ----------------------------------------------------------------------*
	| TExIconImage.HandleNeeded                                            |
	|                                                                      |
	| In general, call this as little as possible.  I don't call it any-   |
	| where in this code - I draw the bitmaps directly, rather than using  |
	| DrawIconEx, etc.                                                     |
	|                                                                      |
	| CreateIconFromResourceEx is very unreliable with icons > 16 colours  |
	*---------------------------------------------------------------------- *)
procedure Texiconimage.Handleneeded;
var
	Info:Pbitmapinfoheader;
	Buff:Pbyte;
begin
	if Handle<>0 then Exit;
	if Fmemoryimage=nil then Exit;

	if Fpalette<>0 then begin
		Deleteobject(Fpalette);
		Fpalette:=0;
		Fgotpalette:=False;
	end;

	if Fmemoryimage.Size>Sizeof(Tbitmapinfoheader)+4 then begin
		Info:=Getbitmapinfoheader;

		// Aaaagh.  I don't believe I'm doing this.  For some reason you cant use 'FMemoryImage.Memory'
		// directly in CreateIconFromResourceEx.  You have to copy it to a (GMEM_MOVEABLE) buffer first.
		//
		// And they call NT an operating system!

		Getmem(Buff,Fmemoryimage.Size);
		try
			Fmemoryimage.Seek(0,Sofrombeginning);
			Move(Fmemoryimage.Memory^,Buff^,Fmemoryimage.Size);

			Fhandle:=Createiconfromresourceex(Buff,Fmemoryimage.Size,Fisicon,$00030000,Info^.Biwidth,Info^.Biheight div 2,
				Lr_defaultcolor);
		finally Freemem(Buff)
		end;

		if Fhandle=0 then raise Einvalidgraphic.Create(Rstinvalidicon);

		Fwidth:=Info^.Biwidth;
		Fheight:=Info^.Biheight div 2;
		Fpixelformat:=Getbitmapinfopixelformat(Info^);

		if Info^.Bibitcount<=8 then Fpalette:=Createdibpalette(Pbitmapinfo(Info)^);

		Fgotpalette:=Fpalette<>0;
	end
end;

(* ----------------------------------------------------------------------*
	| TExIconImage.ImageNeeded
	|                                                                      |
	*---------------------------------------------------------------------- *)
procedure Texiconimage.Imageneeded;
var
	Image:Tmemorystream;
	Iconinfo:Ticoninfo;
	Monoinfosize,Colorinfosize:Dword;
	Monobitssize,Colorbitssize:Dword;
	Monoinfo,Monobits,Colorinfo,Colorbits:Pointer;
begin
	if Fmemoryimage<>nil then Exit;
	if Fhandle=0 then raise Einvalidgraphic.Create(Rstinvalidicon);

	Image:=Tmemorystream.Create;
	try
		Geticoninfo(Handle,Iconinfo);
		try
			Internalgetdibsizes(Iconinfo.Hbmmask,Monoinfosize,Monobitssize,Pf1bit);
			if Iconinfo.Hbmcolor<>0 then Internalgetdibsizes(Iconinfo.Hbmcolor,Colorinfosize,Colorbitssize,Pixelformat);

			Monoinfo:=nil;
			Monobits:=nil;
			Colorinfo:=nil;
			Colorbits:=nil;
			try
				Monoinfo:=Allocmem(Monoinfosize);
				Monobits:=Allocmem(Monobitssize);
				Internalgetdib(Iconinfo.Hbmmask,0,Pbitmapinfo(Monoinfo),Monobits^,Pf1bit);

				if Iconinfo.Hbmcolor<>0 then begin
					Colorinfo:=Allocmem(Colorinfosize);
					Colorbits:=Allocmem(Colorbitssize);

					Internalgetdib(Iconinfo.Hbmcolor,Fpalette,Pbitmapinfo(Colorinfo),Colorbits^,Pixelformat);
					with Pbitmapinfoheader(Colorinfo)^ do Inc(Biheight,Biheight); { color height includes mono bits }
				end;

				if (not Fisicon) then begin
					Image.Write(Iconinfo.Xhotspot,Sizeof(Iconinfo.Xhotspot));
					Image.Write(Iconinfo.Yhotspot,Sizeof(Iconinfo.Yhotspot))
				end;

				if Iconinfo.Hbmcolor<>0 then begin
					Image.Write(Colorinfo^,Colorinfosize);
					Image.Write(Colorbits^,Colorbitssize)
				end
				else Image.Write(Monoinfo^,Monoinfosize);

				Image.Write(Monobits^,Monobitssize);
			finally
				Freemem(Colorinfo,Colorinfosize);
				Freemem(Colorbits,Colorbitssize);
				Freemem(Monoinfo,Monoinfosize);
				Freemem(Monobits,Monobitssize);
			end;
		finally
			if Iconinfo.Hbmcolor<>0 then Deleteobject(Iconinfo.Hbmcolor);
			Deleteobject(Iconinfo.Hbmmask);
		end
	except
		Image.Free;
		raise;
	end;
	Fmemoryimage:=Image
end;

(* ----------------------------------------------------------------------*
	| TExIconImage.PaletteNeeded
	|                                                                      |
	*---------------------------------------------------------------------- *)
procedure Texiconimage.Paletteneeded;
var
	Info:Pbitmapinfoheader;
begin
	if Fgotpalette then Exit;
	if Fmemoryimage=nil then Exit;

	Info:=Getbitmapinfoheader;

	if Fpixelformat in [Pf1bit..Pf8bit] then Fpalette:=Createdibpalette(Pbitmapinfo(Info)^);

	Fgotpalette:=True;
end;

{ TExCursor }

(* ----------------------------------------------------------------------*
	| TExCursor.Create
	|                                                                      |
	*---------------------------------------------------------------------- *)
constructor Texcursor.Create;
begin
	inherited;

	with Fimages[0] do begin
		Fwidth:=Getsystemmetrics(Sm_cxcursor);
		Fheight:=Getsystemmetrics(Sm_cycursor);
		Fpixelformat:=Pf1bit
	end
end;

(* ----------------------------------------------------------------------*
	| TExCursor.GetHotspot
	|                                                                      |
	*---------------------------------------------------------------------- *)
function Texcursor.Gethotspot:Dword;
begin
	Imageneeded;
	Result:=Pdword(Images[Fcurrentimage].Fmemoryimage.Memory)^
end;

(* ----------------------------------------------------------------------*
	| TExCursor.SetHotspot
	|                                                                      |
	*---------------------------------------------------------------------- *)
procedure Texcursor.Loadfromfile(const Filename:string);
var
	Hdr:Ticonheader;
	Direntry: array of Ticondirentry;
	I:Integer;
	P:Pbitmapinfoheader;
	Stream:Tfilestream;
	Hotspot:Dword;
begin
	Stream:=Tfilestream.Create(Filename,Fmopenread or Fmsharedenywrite);
	try
		Stream.Read(Hdr,Sizeof(Hdr));

		if Hdr.Wtype<>2 then raise Einvalidgraphic.Create(Rstinvalidcursor);

		Releaseimages; // Get rid of existing images

		Setlength(Fimages,Hdr.Wcount);
		Setlength(Direntry,Hdr.Wcount);

		// Create and initialize the ExIconImage classes and read
		// the dirEntry structures from the stream.

		for I:=0 to Hdr.Wcount-1 do begin
			Fimages[I]:=Texiconimage.Create;
			Fimages[I].Fisicon:=False;
			Fimages[I].Fmemoryimage:=Tmemorystream.Create;
			Fimages[I].Reference;

			Stream.Read(Direntry[I],Sizeof(Ticondirentry));
			Fimages[I].Fwidth:=Direntry[I].Bwidth;
			Fimages[I].Fheight:=Direntry[I].Bheight;
		end;

		// Read the icon images into their Memory streams
		for I:=0 to Hdr.Wcount-1 do begin
			Hotspot:=Makelong(Direntry[I].Wplanes,Direntry[I].Wbitcount);

			Stream.Seek(Direntry[I].Dwimageoffset,Sofrombeginning);

			Fimages[I].Fmemoryimage.Write(Hotspot,Sizeof(Hotspot));
			Fimages[I].Fmemoryimage.Copyfrom(Stream,Direntry[I].Dwbytesinres);

			P:=Fimages[I].Getbitmapinfoheader;
			P^.Bisizeimage:=0;

			Fimages[I].Fpixelformat:=Getbitmapinfopixelformat(P^);
		end;

		Fcurrentimage:=0;
		Changed(Self)
	finally Stream.Free
	end
end;

procedure Texcursor.Savetofile(const Filename:string);
var
	Hdr:Ticonheader;
	Direntry:Ticondirentry;
	Image:Texiconimage;
	I,Dirsize,Offset:Integer;
	Oldcurrentimage:Integer;
	Stream:Tfilestream;
begin
	Stream:=Tfilestream.Create(Filename,Fmcreate);
	try
		Hdr.Wreserved:=0;
		Hdr.Wtype:=2;
		Hdr.Wcount:=Imagecount;

		Stream.Write(Hdr,Sizeof(Hdr));
		Dirsize:=Imagecount*Sizeof(Direntry)+Sizeof(Hdr);

		Oldcurrentimage:=Fcurrentimage;
		try
			Offset:=0;
			for I:=0 to Imagecount-1 do begin
				Fcurrentimage:=I;
				Imageneeded;
				Image:=Images[I];

				Fillchar(Direntry,Sizeof(Direntry),0);

				Direntry.Bwidth:=Image.Width;
				Direntry.Bheight:=Image.Height;

				case Image.Pixelformat of
					Pf1bit:Direntry.Bcolorcount:=2;
					Pf4bit:Direntry.Bcolorcount:=16;
					Pf8bit:Direntry.Bcolorcount:=0;
					Pf16bit:Direntry.Bcolorcount:=0;
					Pf24bit:Direntry.Bcolorcount:=0;
					Pf32bit:Direntry.Bcolorcount:=0;
				else raise Einvalidgraphic.Create(Rstinvalidicon);
				end;

				Direntry.Wplanes:=Loword(Hotspot);
				Direntry.Wbitcount:=Hiword(Hotspot);

				Direntry.Dwbytesinres:=Image.Fmemoryimage.Size-Sizeof(Dword);
				Direntry.Dwimageoffset:=Dirsize+Offset;

				Stream.Write(Direntry,Sizeof(Direntry));
				Inc(Offset,Direntry.Dwbytesinres);
			end
		finally Fcurrentimage:=Oldcurrentimage
		end;

		for I:=0 to Imagecount-1 do begin
			Fimages[I].Fmemoryimage.Seek(Sizeof(Dword),Sofrombeginning);
			Stream.Copyfrom(Images[I].Fmemoryimage,Images[I].Fmemoryimage.Size-Images[I].Fmemoryimage.Position);
		end
	finally Stream.Free
	end
end;

(* ----------------------------------------------------------------------*
	| TExCursor.SetHotspot                                                 |
	|                                                                      |
	| Set the cursor's hotspot                                             |
	*---------------------------------------------------------------------- *)
procedure Texcursor.Sethotspot(const Value:Dword);
begin
	Imageneeded;
	Pdword(Images[Fcurrentimage].Fmemoryimage.Memory)^:=Value;
end;

{ TExIcon }

(* ----------------------------------------------------------------------*
	| TExIcon.Create
	|                                                                      |
	*---------------------------------------------------------------------- *)
constructor Texicon.Create;
begin
	inherited;
	with Fimages[0] do begin
		Fwidth:=Getsystemmetrics(Sm_cxicon);
		Fheight:=Getsystemmetrics(Sm_cyicon);
		Fpixelformat:=Pf4bit
	end
end;

(* ----------------------------------------------------------------------*
	| WebPalette
	|                                                                      |
	*---------------------------------------------------------------------- *)
function Webpalette:Hpalette;
type
	Tlogwebpalette=packed record
		Palversion:Word;
		Palnumentries:Word;
		Palentries: array [0..5,0..5,0..5] of Tpaletteentry;
		Monoentries: array [0..23] of Tpaletteentry;
		Stdentries: array [0..15] of Tpaletteentry;
	end;
var
	R,G,B:Byte;
	Logwebpalette:Tlogwebpalette;
	Logpalette:Tlogpalette absolute Logwebpalette;
	// Stupid typecast
begin
	with Logwebpalette do begin
		Getpaletteentries(Systempalette16,0,16,Stdentries);
		Palversion:=$0300;
		Palnumentries:=256;

		G:=10;
		for R:=0 to 23 do begin
			Monoentries[R].Pered:=G;
			Monoentries[R].Pegreen:=G;
			Monoentries[R].Peblue:=G;
			Monoentries[R].Peflags:=0;
			Inc(G,10)
		end;

		for R:=0 to 5 do
			for G:=0 to 5 do
				for B:=0 to 5 do begin
					with Palentries[R,G,B] do begin
						Pered:=51*R;
						Pegreen:=51*G;
						Peblue:=51*B;
						Peflags:=0;
					end;
				end;
	end;
	Result:=Createpalette(Logpalette);
end;

(* ----------------------------------------------------------------------*
	| Create2ColorPalette
	|                                                                      |
	*---------------------------------------------------------------------- *)
function Create2colorpalette:Hpalette;
const
	Palcolors2: array [0..1] of Tcolor=($000000,$FFFFFF);
var
	Logpalette:Plogpalette;
	I,C:Integer;

begin
	Getmem(Logpalette,Sizeof(Logpalette)+2*Sizeof(Paletteentry));

	try
		Logpalette^.Palversion:=$300;
		Logpalette^.Palnumentries:=2;
{$R-}
		for I:=0 to 1 do
			with Logpalette^.Palpalentry[I] do begin
				C:=Palcolors2[I];

				Pered:=C and $FF;
				Pegreen:=C shr 8 and $FF;
				Peblue:=C shr 16 and $FF
			end;
{$R+}
		Result:=Createpalette(Logpalette^);
	finally Freemem(Logpalette)
	end
end;

initialization

Systempalette256:=Webpalette;
Systempalette2:=Create2colorpalette;

finalization

Deleteobject(Systempalette2);
Deleteobject(Systempalette256);

end.
