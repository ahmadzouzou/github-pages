(* ======================================================================*
	| unitResourceGraphics                                                 |
	|                                                                      |
	| Encapsulates graphics in resources (icon, cursor, bitmap)            |
	|                                                                      |
	| Version  Date        By    Description                               |
	| -------  ----------  ----  ------------------------------------------|
	| 1.0      05/01/2001  CPWW  Original                                  |
	*====================================================================== *)

unit unitResourceGraphics;

interface

uses
	Windows,
	Classes,
	Sysutils,
	Graphics,
	Unitexicon,
	Unitresourcedetails;

type

	// ------------------------------------------------------------------------
	// Base class

	Tgraphicsresourcedetails=class(Tresourcedetails)
	protected
		function Getheight:Integer;virtual;abstract;
		function Getpixelformat:Tpixelformat;virtual;abstract;
		function Getwidth:Integer;virtual;abstract;
	public
		procedure Getimage(Picture:Tpicture);virtual;abstract;
		procedure Setimage(Image:Tpicture);virtual;

		property Width:Integer read Getwidth;
		property Height:Integer read Getheight;
		property Pixelformat:Tpixelformat read Getpixelformat;
	end;

	Tgraphicsresourcedetailsclass=class of Tgraphicsresourcedetails;

	// ------------------------------------------------------------------------
	// Bitmap resource details class

	Tbitmapresourcedetails=class(Tgraphicsresourcedetails)
	protected
		function Getheight:Integer;override;
		function Getpixelformat:Tpixelformat;override;
		function Getwidth:Integer;override;
		procedure Initnew;override;
		procedure Internalgetimage(S:Tstream;Picture:Tpicture);
		procedure Internalsetimage(S:Tstream;Image:Tpicture);

	public
		class function Getbasetype:Widestring;override;
		procedure Getimage(Picture:Tpicture);override;
		procedure Setimage(Image:Tpicture);override;
		procedure Loadimage(const Filename:string);
	end;

	// ------------------------------------------------------------------------
	// DIB resource details class
	//
	// Same as RT_BITMAP resources, but they have a TBitmapFileHeader at the start
	// of the resource, before the TBitmapInfoHeader.  See
	// \program files\Microsoft Office\office\1033\outlibr.dll

	Tdibresourcedetails=class(Tbitmapresourcedetails)
	protected
		class function Supportsdata(Size:Integer;Data:Pointer):Boolean;override;
		procedure Initnew;override;
	public
		class function Getbasetype:Widestring;override;
		procedure Getimage(Picture:Tpicture);override;
		procedure Setimage(Image:Tpicture);override;
	end;

	Ticoncursorresourcedetails=class;

	// ------------------------------------------------------------------------
	// Icon / Cursor group resource details class

	Ticoncursorgroupresourcedetails=class(Tresourcedetails)
	private
		Fdeleting:Boolean;
		function Getresourcecount:Integer;
		function Getresourcedetails(Idx:Integer):Ticoncursorresourcedetails;
	protected
		procedure Initnew;override;
	public
		procedure Getimage(Picture:Tpicture);
		property Resourcecount:Integer read Getresourcecount;
		property Resourcedetails[Idx:Integer]:Ticoncursorresourcedetails read Getresourcedetails;
		function Contains(Details:Ticoncursorresourcedetails):Boolean;
		procedure Removefromgroup(Details:Ticoncursorresourcedetails);
		procedure Addtogroup(Details:Ticoncursorresourcedetails);
		procedure Loadimage(const Filename:string);
		procedure Beforedelete;override;
	end;

	// ------------------------------------------------------------------------
	// Icon group resource details class

	Ticongroupresourcedetails=class(Ticoncursorgroupresourcedetails)
	public
		class function Getbasetype:Widestring;override;
	end;

	// ------------------------------------------------------------------------
	// Cursor group resource details class

	Tcursorgroupresourcedetails=class(Ticoncursorgroupresourcedetails)
	public
		class function Getbasetype:Widestring;override;
	end;

	// ------------------------------------------------------------------------
	// Icon / Cursor resource details class

	Ticoncursorresourcedetails=class(Tgraphicsresourcedetails)
	protected
		function Getheight:Integer;override;
		function Getpixelformat:Tpixelformat;override;
		function Getwidth:Integer;override;
	protected
		procedure Initnew;override;
	public
		procedure Beforedelete;override;
		procedure Getimage(Picture:Tpicture);override;
		procedure Setimage(Image:Tpicture);override;
		property Width:Integer read Getwidth;
		property Height:Integer read Getheight;
		property Pixelformat:Tpixelformat read Getpixelformat;
	end;

	// ------------------------------------------------------------------------
	// Icon resource details class

	Ticonresourcedetails=class(Ticoncursorresourcedetails)
	public
		class function Getbasetype:Widestring;override;
	end;

	// ------------------------------------------------------------------------
	// Cursor resource details class

	Tcursorresourcedetails=class(Ticoncursorresourcedetails)
	protected
	public
		class function Getbasetype:Widestring;override;
	end;

const
	Defaulticoncursorwidth:Integer=32;
	Defaulticoncursorheight:Integer=32;
	Defaulticoncursorpixelformat:Tpixelformat=Pf4bit;
	Defaultcursorhotspot:Dword=$00100010;

	Defaultbitmapwidth:Integer=128;
	Defaultbitmapheight:Integer=96;
	Defaultbitmappixelformat:Tpixelformat=Pf24bit;

implementation

type

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

	resourcestring
		Rstcursors='Cursors';
		Rsticons='Icons';

		{ TBitmapResourceDetails }

		(* ----------------------------------------------------------------------*
			| TBitmapResourceDetails.GetBaseType                                   |
			*---------------------------------------------------------------------- *)
		class function Tbitmapresourcedetails.Getbasetype:Widestring;
		begin
			Result:=Inttostr(Integer(Rt_bitmap));
		end;

		(* ----------------------------------------------------------------------*
			| TBitmapResourceDetails.GetHeight                                     |
			*---------------------------------------------------------------------- *)
		function Tbitmapresourcedetails.Getheight:Integer;
		begin
			Result:=Pbitmapinfoheader(Data.Memory)^.Biheight
		end;

		(* ----------------------------------------------------------------------*
			| TBitmapResourceDetails.GetImage                                      |
			*---------------------------------------------------------------------- *)
		procedure Tbitmapresourcedetails.Getimage(Picture:Tpicture);

	var
		S:Tmemorystream;
		Hdr:Tbitmapfileheader;
	begin
		S:=Tmemorystream.Create;
		try
			Hdr.Bftype:=$4D42; // TBitmap.LoadFromStream requires a bitmapfileheader
			Hdr.Bfsize:=Data.Size; // before the data...
			Hdr.Bfreserved1:=0;
			Hdr.Bfreserved2:=0;
			Hdr.Bfoffbits:=Sizeof(Hdr);

			S.Write(Hdr,Sizeof(Hdr));
			Data.Seek(0,Sofrombeginning);
			S.Copyfrom(Data,Data.Size);

			Internalgetimage(S,Picture)
		finally S.Free
		end
	end;

	(* ----------------------------------------------------------------------*
		| TBitmapResourceDetails.GetPixelFormat                                |
		*---------------------------------------------------------------------- *)
	function Tbitmapresourcedetails.Getpixelformat:Tpixelformat;
	begin
		Result:=Getbitmapinfopixelformat(Pbitmapinfoheader(Data.Memory)^);
	end;

	(* ----------------------------------------------------------------------*
		| TBitmapResourceDetails.GetWidth                                      |
		*---------------------------------------------------------------------- *)
	function Tbitmapresourcedetails.Getwidth:Integer;
	begin
		Result:=Pbitmapinfoheader(Data.Memory)^.Biwidth
	end;

	(* ----------------------------------------------------------------------*
		| TBitmapResourceDetails.SetImage                                      |
		*---------------------------------------------------------------------- *)
	procedure Tbitmapresourcedetails.Initnew;

	var
		Bi:Tbitmapinfoheader;
		Imagesize:Dword;
		Bits:Pchar;
	begin
		Bi.Bisize:=Sizeof(Bi);
		Bi.Biwidth:=Defaultbitmapwidth;
		Bi.Biheight:=Defaultbitmapheight;
		Bi.Biplanes:=1;
		Bi.Bibitcount:=Getpixelformatbitcount(Defaultbitmappixelformat);
		Bi.Bicompression:=Bi_rgb;

		Imagesize:=Bytesperscanline(Defaultbitmapwidth,Bi.Bibitcount,32)*Defaultbitmapheight;
		Bi.Bisizeimage:=Imagesize;

		Bi.Bixpelspermeter:=0;
		Bi.Biypelspermeter:=0;

		Bi.Biclrused:=0;
		Bi.Biclrimportant:=0;

		Data.Write(Bi,Sizeof(Bi));

		Bits:=Allocmem(Imagesize);
		try Data.Write(Bits^,Imagesize);
		finally Reallocmem(Bits,0)
		end
	end;

	procedure Tbitmapresourcedetails.Internalgetimage(S:Tstream;Picture:Tpicture);

	var
		Phdr:Pbitmapinfoheader;
		Pal:Hpalette;
		Colors:Dword;
		Hangontopalette:Boolean;
		Newbmp:Tbitmap;
	begin
		S.Seek(0,Sofrombeginning);
		Picture.Bitmap.Ignorepalette:=False;
		Picture.Bitmap.Loadfromstream(S);

		Phdr:=Pbitmapinfoheader(Data.Memory);

		// TBitmap makes all RLE encoded bitmaps into pfDevice
		// ... that's not good enough for us!  At least
		// select the correct pixel format, preserve their carefully set
		// up palette, etc.
		//
		// But revisit this - we probably shouldn't call LoadFromStream
		// at all if this is the case...
		//
		// You can get a couple of RLE bitmaps out of winhlp32.exe

		if Phdr^.Bicompression in [Bi_rle4,Bi_rle8] then begin
			Hangontopalette:=False;
			if Phdr^.Bibitcount in [1,4,8] then begin
				Pal:=Picture.Bitmap.Palette;
				if Pal<>0 then begin
					Colors:=0;
					Getobject(Pal,Sizeof(Colors),@Colors);

					if Colors=1 shl Phdr^.Bibitcount then begin
						Hangontopalette:=True;

						Newbmp:=Tbitmap.Create;
						try
							case Phdr^.Bibitcount of
								1:Newbmp.Pixelformat:=Pf1bit;
								4:Newbmp.Pixelformat:=Pf4bit;
								8:Newbmp.Pixelformat:=Pf8bit;
							end;

							Newbmp.Width:=Picture.Bitmap.Width;
							Newbmp.Height:=Picture.Bitmap.Height;
							Newbmp.Palette:=Copypalette(Pal);
							Newbmp.Canvas.Draw(0,0,Picture.Bitmap);
							Picture.Bitmap.Assign(Newbmp);
						finally Newbmp.Free
						end
					end
				end
			end;

			if not Hangontopalette then
				case Phdr^.Bibitcount of
					1:Picture.Bitmap.Pixelformat:=Pf1bit;
					4:Picture.Bitmap.Pixelformat:=Pf4bit;
					8:Picture.Bitmap.Pixelformat:=Pf8bit;
				else Picture.Bitmap.Pixelformat:=Pf24bit
				end
		end
	end;

	(* ----------------------------------------------------------------------*
		| TBitmapResourceDetails.InternalSetImage                              |
		|                                                                      |
		| Save image 'image' to stream 's' as a bitmap                         |
		|                                                                      |
		| Parameters:                                                          |
		|                                                                      |
		|   s : TStream           The stream to save to                        |
		|   image : TPicture      The image to save                            |
		*---------------------------------------------------------------------- *)
	procedure Tbitmapresourcedetails.Internalsetimage(S:Tstream;Image:Tpicture);

	var
		Bmp:Tbitmap;
	begin
		S.Size:=0;
		Bmp:=Tbitmap.Create;
		try
			Bmp.Assign(Image.Graphic);
			Bmp.Savetostream(S);
		finally Bmp.Free;
		end
	end;

	(* ----------------------------------------------------------------------*
		| TBitmapResourceDetails.SetImage                                      |
		*---------------------------------------------------------------------- *)
	procedure Tbitmapresourcedetails.Loadimage(const Filename:string);

	var
		S:Tmemorystream;
	begin
		S:=Tmemorystream.Create;
		try
			S.Loadfromfile(Filename);
			Data.Clear;
			Data.Write((Pchar(S.Memory)+Sizeof(Tbitmapfileheader))^,S.Size-Sizeof(Tbitmapfileheader));
		finally S.Free;
		end
	end;

	procedure Tbitmapresourcedetails.Setimage(Image:Tpicture);

	var
		S:Tmemorystream;
	begin
		S:=Tmemorystream.Create;
		try
			Internalsetimage(S,Image);
			Data.Clear;
			Data.Write((Pchar(S.Memory)+Sizeof(Tbitmapfileheader))^,S.Size-Sizeof(Tbitmapfileheader));
		finally S.Free;
		end
	end;

	{ TIconGroupResourceDetails }

	(* ----------------------------------------------------------------------*
		| TIconGroupResourceDetails.GetBaseType                                |
		*---------------------------------------------------------------------- *)
	class function Ticongroupresourcedetails.Getbasetype:Widestring;
	begin
		Result:=Inttostr(Integer(Rt_group_icon));
	end;

	{ TCursorGroupResourceDetails }

	(* ----------------------------------------------------------------------*
		| TCursorGroupResourceDetails.GetBaseType                              |
		*---------------------------------------------------------------------- *)
	class function Tcursorgroupresourcedetails.Getbasetype:Widestring;
	begin
		Result:=Inttostr(Integer(Rt_group_cursor));
	end;

	{ TIconResourceDetails }

	(* ----------------------------------------------------------------------*
		| TIconResourceDetails.GetBaseType                                     |
		*---------------------------------------------------------------------- *)
	class function Ticonresourcedetails.Getbasetype:Widestring;
	begin
		Result:=Inttostr(Integer(Rt_icon));
	end;

	{ TCursorResourceDetails }

	(* ----------------------------------------------------------------------*
		| TCursorResourceDetails.GetBaseType                                   |
		*---------------------------------------------------------------------- *)
	class function Tcursorresourcedetails.Getbasetype:Widestring;
	begin
		Result:=Inttostr(Integer(Rt_cursor));
	end;

	{ TGraphicsResourceDetails }

	{ TIconCursorResourceDetails }

	(* ----------------------------------------------------------------------*
		| TIconCursorResourceDetails.GetHeight                                 |
		*---------------------------------------------------------------------- *)
	function Ticoncursorresourcedetails.Getheight:Integer;

	var
		Infoheader:Pbitmapinfoheader;
	begin
		if Self is Tcursorresourcedetails then // Not very 'OOP'.  Sorry
				Infoheader:=Pbitmapinfoheader(Pchar(Data.Memory)+Sizeof(Dword))
		else Infoheader:=Pbitmapinfoheader(Pchar(Data.Memory));

		Result:=Infoheader.Biheight div 2
	end;

	(* ----------------------------------------------------------------------*
		| TIconCursorResourceDetails.GetImage                                  |
		*---------------------------------------------------------------------- *)
	procedure Ticoncursorresourcedetails.Getimage(Picture:Tpicture);

	var
		Iconcursor:Texiconcursor;
		Strm:Tmemorystream;
		Hdr:Ticonheader;
		Direntry:Ticondirentry;
		Infoheader:Pbitmapinfoheader;
	begin
		if Data.Size=0 then Exit;

		Strm:=nil;
		if Self is Tcursorresourcedetails then begin
			Hdr.Wtype:=2;
			Infoheader:=Pbitmapinfoheader(Pchar(Data.Memory)+Sizeof(Dword));
			Iconcursor:=Texcursor.Create
		end else begin
			Hdr.Wtype:=1;
			Infoheader:=Pbitmapinfoheader(Pchar(Data.Memory));
			Iconcursor:=Texicon.Create
		end;

		try
			Strm:=Tmemorystream.Create;
			Hdr.Wreserved:=0;
			Hdr.Wcount:=1;

			Strm.Write(Hdr,Sizeof(Hdr));

			Direntry.Bwidth:=Infoheader^.Biwidth;
			Direntry.Bheight:=Infoheader^.Biheight div 2;
			Direntry.Bcolorcount:=Getbitmapinfonumcolors(Infoheader^);
			Direntry.Breserved:=0;

			Direntry.Wplanes:=Infoheader^.Biplanes;
			Direntry.Wbitcount:=Infoheader^.Bibitcount;

			Direntry.Dwbytesinres:=Data.Size;
			Direntry.Dwimageoffset:=Sizeof(Hdr)+Sizeof(Direntry);

			Strm.Write(Direntry,Sizeof(Direntry));
			Strm.Copyfrom(Data,0);
			Strm.Seek(0,Sofrombeginning);

			Iconcursor.Loadfromstream(Strm);
			Picture.Graphic:=Iconcursor
		finally
			Strm.Free;
			Iconcursor.Free
		end
	end;

	(* ----------------------------------------------------------------------*
		| TIconCursorResourceDetails.SetImage                                  |
		*---------------------------------------------------------------------- *)
	procedure Ticoncursorresourcedetails.Setimage(Image:Tpicture);

	var
		Icon:Texiconcursor;
	begin
		Icon:=Texiconcursor(Image.Graphic);
		Data.Clear;
		Data.Copyfrom(Icon.Images[Icon.Currentimage].Memoryimage,0);
	end;

	(* ----------------------------------------------------------------------*
		| TIconCursorResourceDetails.GetPixelFormat                            |
		*---------------------------------------------------------------------- *)
	function Ticoncursorresourcedetails.Getpixelformat:Tpixelformat;

	var
		Infoheader:Pbitmapinfoheader;
	begin
		if Self is Tcursorresourcedetails then Infoheader:=Pbitmapinfoheader(Pchar(Data.Memory)+Sizeof(Dword))
		else Infoheader:=Pbitmapinfoheader(Pchar(Data.Memory));

		Result:=Getbitmapinfopixelformat(Infoheader^);
	end;

	(* ----------------------------------------------------------------------*
		| TIconCursorResourceDetails.GetWidth                                  |
		*---------------------------------------------------------------------- *)
	function Ticoncursorresourcedetails.Getwidth:Integer;

	var
		Infoheader:Pbitmapinfoheader;
	begin
		if Self is Tcursorresourcedetails then Infoheader:=Pbitmapinfoheader(Pchar(Data.Memory)+Sizeof(Dword))
		else Infoheader:=Pbitmapinfoheader(Pchar(Data.Memory));

		Result:=Infoheader.Biwidth
	end;

	{ TIconCursorGroupResourceDetails }

	(* ----------------------------------------------------------------------*
		| TIconCursorGroupResourceDetails.BeforeDelete
		|                                                                      |
		*---------------------------------------------------------------------- *)
	procedure Ticoncursorgroupresourcedetails.Addtogroup(Details:Ticoncursorresourcedetails);

	var
		Attributes:Presourcedirectory;
		Infoheader:Pbitmapinfoheader;
		Cc:Integer;
	begin
		Data.Size:=Data.Size+Sizeof(Tresourcedirectory);
		Attributes:=Presourcedirectory(Pchar(Data.Memory)+Sizeof(Ticonheader));

		Inc(Attributes,Piconheader(Data.Memory)^.Wcount);

		Attributes^.Wnameordinal:=Strtoint(Details.Resourcename);
		Attributes^.Lbytesinres:=Details.Data.Size;

		if Details is Ticonresourcedetails then begin
			Infoheader:=Pbitmapinfoheader(Pchar(Details.Data.Memory));
			Attributes^.Details.Iconwidth:=Infoheader^.Biwidth;
			Attributes^.Details.Iconheight:=Infoheader^.Biheight div 2;
			Cc:=Getbitmapinfonumcolors(Infoheader^);
			if Cc<256 then Attributes^.Details.Iconcolorcount:=Cc
			else Attributes^.Details.Iconcolorcount:=0;
			Attributes^.Details.Iconreserved:=0
		end else begin
			Infoheader:=Pbitmapinfoheader(Pchar(Details.Data.Memory)+Sizeof(Dword));
			Attributes^.Details.Cursorwidth:=Infoheader^.Biwidth;
			Attributes^.Details.Cursorheight:=Infoheader^.Biheight div 2
		end;

		Attributes^.Wplanes:=Infoheader^.Biplanes;
		Attributes^.Wbitcount:=Infoheader^.Bibitcount;

		Inc(Piconheader(Data.Memory)^.Wcount);
	end;

	procedure Ticoncursorgroupresourcedetails.Beforedelete;
	begin
		Fdeleting:=True;
		try
			while Resourcecount>0 do Parent.Deleteresource(Parent.Indexofresource(Resourcedetails[0]));
		finally Fdeleting:=False
		end
	end;

	(* ----------------------------------------------------------------------*
		| TIconCursorGroupResourceDetails.Contains                             |
		*---------------------------------------------------------------------- *)
	function Ticoncursorgroupresourcedetails.Contains(Details:Ticoncursorresourcedetails):Boolean;

	var
		I,Id:Integer;
		Attributes:Presourcedirectory;
	begin
		Result:=False;
		if Resourcenametoint(Details.Resourcetype)=Resourcenametoint(Resourcetype)-Difference then begin
			Attributes:=Presourcedirectory(Pchar(Data.Memory)+Sizeof(Ticonheader));
			Id:=Resourcenametoint(Details.Resourcename);

			for I:=0 to Piconheader(Data.Memory)^.Wcount-1 do
				if Attributes^.Wnameordinal=Id then begin
					Result:=True;
					Break
				end
				else Inc(Attributes)
		end
	end;

	(* ----------------------------------------------------------------------*
		| TIconCursorGroupResourceDetails.GetImage                             |
		*---------------------------------------------------------------------- *)
	procedure Ticoncursorgroupresourcedetails.Getimage(Picture:Tpicture);

	var
		I,Hdroffset,Imgoffset:Integer;
		Iconcursor:Texiconcursor;
		Strm:Tmemorystream;
		Hdr:Ticonheader;
		Direntry:Ticondirentry;
		Pdirentry:Picondirentry;
		Infoheader:Pbitmapinfoheader;
	begin
		if Data.Size=0 then Exit;

		Strm:=nil;
		if Self is Tcursorgroupresourcedetails then begin
			Hdr.Wtype:=2;
			Hdroffset:=Sizeof(Dword);
			Iconcursor:=Texcursor.Create
		end else begin
			Hdr.Wtype:=1;
			Hdroffset:=0;
			Iconcursor:=Texicon.Create
		end;

		try
			Strm:=Tmemorystream.Create;
			Hdr.Wreserved:=0;
			Hdr.Wcount:=Resourcecount;

			Strm.Write(Hdr,Sizeof(Hdr));

			for I:=0 to Resourcecount-1 do begin
				Infoheader:=Pbitmapinfoheader(Pchar(Resourcedetails[I].Data.Memory)+Hdroffset);
				Direntry.Bwidth:=Infoheader^.Biwidth;
				Direntry.Bheight:=Infoheader^.Biheight div 2;
				Direntry.Wplanes:=Infoheader^.Biplanes;
				Direntry.Bcolorcount:=Getbitmapinfonumcolors(Infoheader^);
				Direntry.Breserved:=0;
				Direntry.Wbitcount:=Infoheader^.Bibitcount;
				Direntry.Dwbytesinres:=Resourcedetails[I].Data.Size;
				Direntry.Dwimageoffset:=0;

				Strm.Write(Direntry,Sizeof(Direntry));
			end;

			for I:=0 to Resourcecount-1 do begin
				Imgoffset:=Strm.Position;
				Pdirentry:=Picondirentry(Pchar(Strm.Memory)+Sizeof(Ticonheader)+I*Sizeof(Ticondirentry));
				Pdirentry^.Dwimageoffset:=Imgoffset;

				Strm.Copyfrom(Resourcedetails[I].Data,0);
			end;

			if Resourcecount>0 then begin
				Strm.Seek(0,Sofrombeginning);
				Iconcursor.Loadfromstream(Strm);
				Picture.Graphic:=Iconcursor
			end
			else Picture.Graphic:=nil
		finally
			Strm.Free;
			Iconcursor.Free
		end
	end;

	(* ----------------------------------------------------------------------*
		| TIconCursorGroupResourceDetails.GetResourceCount                     |
		*---------------------------------------------------------------------- *)
	function Ticoncursorgroupresourcedetails.Getresourcecount:Integer;
	begin
		Result:=Piconheader(Data.Memory)^.Wcount
	end;

	(* ----------------------------------------------------------------------*
		| TIconCursorGroupResourceDetails.GetResourceDetails                   |
		*---------------------------------------------------------------------- *)
	function Ticoncursorgroupresourcedetails.Getresourcedetails(Idx:Integer):Ticoncursorresourcedetails;

	var
		I:Integer;
		Res:Tresourcedetails;
		Attributes:Presourcedirectory;
		Iconcursorresourcetype:string;
	begin
		Result:=nil;
		Attributes:=Presourcedirectory(Pchar(Data.Memory)+Sizeof(Ticonheader));
		Inc(Attributes,Idx);

		// DIFFERENCE (from Windows.pas) is 11.  It's the difference between a 'group
		// resource' and the resource itself.  They called it 'DIFFERENCE' to be annoying.

		Iconcursorresourcetype:=Inttostr(Resourcenametoint(Resourcetype)-Difference);
		for I:=0 to Parent.Resourcecount-1 do begin
			Res:=Parent.Resourcedetails[I];
			if (Res is Ticoncursorresourcedetails)and(Iconcursorresourcetype=Res.Resourcetype)and
				(Attributes.Wnameordinal=Resourcenametoint(Res.Resourcename)) then begin
				Result:=Ticoncursorresourcedetails(Res);
				Break
			end
		end
	end;

	(* ----------------------------------------------------------------------*
		| TIconCursorGroupResourceDetails.InitNew                              |
		*---------------------------------------------------------------------- *)
	procedure Ticoncursorgroupresourcedetails.Initnew;

	var
		Imageresource:Ticoncursorresourcedetails;
		Iconheader:Ticonheader;
		Dir:Tresourcedirectory;
		Nm:string;

	begin
		Iconheader.Wcount:=1;
		Iconheader.Wreserved:=0;

		if Self is Tcursorgroupresourcedetails then begin
			Iconheader.Wtype:=2;
			Nm:=Parent.Getuniqueresourcename(Tcursorresourcedetails.Getbasetype);
			Imageresource:=Tcursorresourcedetails.Createnew(Parent,Resourcelanguage,Nm)
		end else begin
			Iconheader.Wtype:=1;
			Nm:=Parent.Getuniqueresourcename(Ticonresourcedetails.Getbasetype);
			Imageresource:=Ticonresourcedetails.Createnew(Parent,Resourcelanguage,Nm)
		end;

		Data.Write(Iconheader,Sizeof(Iconheader));

		if Self is Ticongroupresourcedetails then begin
			Dir.Details.Iconwidth:=Defaulticoncursorwidth;
			Dir.Details.Iconheight:=Defaulticoncursorheight;
			Dir.Details.Iconcolorcount:=Getpixelformatnumcolors(Defaulticoncursorpixelformat);
			Dir.Details.Iconreserved:=0
		end else begin
			Dir.Details.Cursorwidth:=Defaulticoncursorwidth;
			Dir.Details.Cursorheight:=Defaulticoncursorheight
		end;

		Dir.Wplanes:=1;
		Dir.Wbitcount:=Getpixelformatbitcount(Defaulticoncursorpixelformat);
		Dir.Lbytesinres:=Imageresource.Data.Size;
		Dir.Wnameordinal:=Resourcenametoint(Imageresource.Resourcename);

		Data.Write(Dir,Sizeof(Dir));
	end;

	(* ----------------------------------------------------------------------*
		| TIconCursorResourceDetails.BeforeDelete                              |
		|                                                                      |
		| If we're deleting an icon/curor resource, remove its reference from  |
		| the icon/cursor group resource.                                      |
		*---------------------------------------------------------------------- *)
	procedure Ticoncursorresourcedetails.Beforedelete;

	var
		I:Integer;
		Details:Tresourcedetails;
		Resgroup:Ticoncursorgroupresourcedetails;
	begin
		for I:=0 to Parent.Resourcecount-1 do begin
			Details:=Parent.Resourcedetails[I];
			if (Details.Resourcetype=Inttostr(Resourcenametoint(Resourcetype)+Difference)) then begin
				Resgroup:=Details as Ticoncursorgroupresourcedetails;
				if Resgroup.Contains(Self) then begin
					Resgroup.Removefromgroup(Self);
					Break
				end
			end
		end
	end;

	procedure Ticoncursorgroupresourcedetails.Loadimage(const Filename:string);

	var
		Img:Texiconcursor;
		Hdr:Ticonheader;
		I:Integer;
		Direntry:Tresourcedirectory;
		Res:Ticoncursorresourcedetails;
		Restp:string;
	begin
		Beforedelete; // Make source there are no existing image resources

		if Self is Ticongroupresourcedetails then begin
			Hdr.Wtype:=1;
			Img:=Texicon.Create;
			Restp:=Ticonresourcedetails.Getbasetype;
		end else begin
			Hdr.Wtype:=2;
			Img:=Texcursor.Create;
			Restp:=Tcursorresourcedetails.Getbasetype;
		end;

		Img.Loadfromfile(Filename);

		Hdr.Wreserved:=0;
		Hdr.Wcount:=Img.Imagecount;

		Data.Clear;

		Data.Write(Hdr,Sizeof(Hdr));

		for I:=0 to Img.Imagecount-1 do begin
			if Hdr.Wtype=1 then begin
				Direntry.Details.Iconwidth:=Img.Images[I].Fwidth;
				Direntry.Details.Iconheight:=Img.Images[I].Fheight;
				Direntry.Details.Iconcolorcount:=Getpixelformatnumcolors(Img.Images[I].Fpixelformat);
				Direntry.Details.Iconreserved:=0
			end else begin
				Direntry.Details.Cursorwidth:=Img.Images[I].Fwidth;
				Direntry.Details.Cursorheight:=Img.Images[I].Fheight;
			end;

			Direntry.Wplanes:=1;
			Direntry.Wbitcount:=Getpixelformatbitcount(Img.Images[I].Fpixelformat);

			Direntry.Lbytesinres:=Img.Images[I].Fmemoryimage.Size;

			if Hdr.Wtype=1 then
					Res:=Ticonresourcedetails.Create(Parent,Resourcelanguage,Parent.Getuniqueresourcename(Restp),Restp,
					Img.Images[I].Fmemoryimage.Size,Img.Images[I].Fmemoryimage.Memory)
			else Res:=Tcursorresourcedetails.Create(Parent,Resourcelanguage,Parent.Getuniqueresourcename(Restp),Restp,
					Img.Images[I].Fmemoryimage.Size,Img.Images[I].Fmemoryimage.Memory);
			Parent.Addresource(Res);
			Direntry.Wnameordinal:=Resourcenametoint(Res.Resourcename);

			Data.Write(Direntry,Sizeof(Direntry));
		end
	end;

	(* ----------------------------------------------------------------------*
		| TIconCursorGroupResourceDetails.RemoveFromGroup                      |
		*---------------------------------------------------------------------- *)
	procedure Ticoncursorgroupresourcedetails.Removefromgroup(Details:Ticoncursorresourcedetails);

	var
		I,Id,Count:Integer;
		Attributes,Ap:Presourcedirectory;
	begin
		if Resourcenametoint(Details.Resourcetype)=Resourcenametoint(Resourcetype)-Difference then begin
			Attributes:=Presourcedirectory(Pchar(Data.Memory)+Sizeof(Ticonheader));
			Id:=Resourcenametoint(Details.Resourcename);

			Count:=Piconheader(Data.Memory)^.Wcount;

			for I:=0 to Count-1 do
				if Attributes^.Wnameordinal=Id then begin
					if I<Count-1 then begin
						Ap:=Attributes;
						Inc(Ap);
						Move(Ap^,Attributes^,Sizeof(Tresourcedirectory)*(Count-I-1));
					end;

					Data.Size:=Data.Size-Sizeof(Tresourcedirectory);
					Piconheader(Data.Memory)^.Wcount:=Count-1;
					if (Count=1)and not Fdeleting then Parent.Deleteresource(Parent.Indexofresource(Self));
					Break
				end
				else Inc(Attributes)
		end
	end;

	(* ----------------------------------------------------------------------*
		| TIconCursorResourceDetails.InitNew                                   |
		*---------------------------------------------------------------------- *)
	procedure Ticoncursorresourcedetails.Initnew;

	var
		Hdr:Tbitmapinfoheader;
		Cimagesize:Dword;
		Pal:Hpalette;
		Entries:Ppaletteentry;
		W:Dword;
		P:Pchar;

	begin
		if Self is Tcursorresourcedetails then Data.Write(Defaultcursorhotspot,Sizeof(Defaultcursorhotspot));

		Hdr.Bisize:=Sizeof(Hdr);
		Hdr.Biwidth:=Defaulticoncursorwidth;
		Hdr.Biheight:=Defaulticoncursorheight*2;
		Hdr.Biplanes:=1;
		Hdr.Bibitcount:=Getpixelformatbitcount(Defaulticoncursorpixelformat);

		if Defaulticoncursorpixelformat=Pf16bit then Hdr.Bicompression:=Bi_bitfields
		else Hdr.Bicompression:=Bi_rgb;

		Hdr.Bisizeimage:=0; // See note in unitExIcon

		Hdr.Bixpelspermeter:=0;
		Hdr.Biypelspermeter:=0;

		Hdr.Biclrused:=Getpixelformatnumcolors(Defaulticoncursorpixelformat);
		Hdr.Biclrimportant:=Hdr.Biclrused;

		Data.Write(Hdr,Sizeof(Hdr));

		Pal:=0;
		case Defaulticoncursorpixelformat of
			Pf1bit:Pal:=Systempalette2;
			Pf4bit:Pal:=Systempalette16;
			Pf8bit:Pal:=Systempalette256
		end;

		Entries:=nil;
		try
			if Pal>0 then begin
				Getmem(Entries,Hdr.Biclrused*Sizeof(Paletteentry));
				Getpaletteentries(Pal,0,Hdr.Biclrused,Entries^);

				Data.Write(Entries^,Hdr.Biclrused*Sizeof(Paletteentry))
			end else if Hdr.Bicompression=Bi_bitfields then begin { 5,6,5 bitfield }
				W:=$0F800; // 1111 1000 0000 0000  5 bit R mask
				Data.Write(W,Sizeof(W));
				W:=$07E0; // 0000 0111 1110 0000  6 bit G mask
				Data.Write(W,Sizeof(W));
				W:=$001F; // 0000 0000 0001 1111  5 bit B mask
				Data.Write(W,Sizeof(W))
			end

		finally Reallocmem(Entries,0)
		end;

		// Write dummy image
		Cimagesize:=Bytesperscanline(Hdr.Biwidth,Hdr.Bibitcount,32)*Defaulticoncursorheight;
		P:=Allocmem(Cimagesize);
		try Data.Write(P^,Cimagesize);
		finally Reallocmem(P,0)
		end;

		// Write dummy mask
		Cimagesize:=Defaulticoncursorheight*Defaulticoncursorwidth div 8;

		Getmem(P,Cimagesize);
		Fillchar(P^,Cimagesize,$FF);

		try Data.Write(P^,Cimagesize);
		finally Reallocmem(P,0)
		end;
	end;

	{ TDIBResourceDetails }

	class function Tdibresourcedetails.Getbasetype:Widestring;
	begin
		Result:='DIB';
	end;

	procedure Tdibresourcedetails.Getimage(Picture:Tpicture);
	begin
		Internalgetimage(Data,Picture);
	end;

	procedure Tdibresourcedetails.Initnew;

	var
		Hdr:Tbitmapfileheader;
	begin
		Hdr.Bftype:=$4D42;
		Hdr.Bfsize:=Sizeof(Tbitmapfileheader)+Sizeof(Tbitmapinfoheader);
		Hdr.Bfreserved1:=0;
		Hdr.Bfreserved2:=0;
		Hdr.Bfoffbits:=Hdr.Bfsize;
		Data.Write(Hdr,Sizeof(Hdr));

		inherited;
	end;

	procedure Tdibresourcedetails.Setimage(Image:Tpicture);
	begin
		Internalsetimage(Data,Image);
	end;

	class function Tdibresourcedetails.Supportsdata(Size:Integer;Data:Pointer):Boolean;

	var
		P:Pbitmapfileheader;
		Hdrsize:Dword;
	begin
		Result:=False;
		P:=Pbitmapfileheader(Data);
		if (P^.Bftype=$4D42)and(P^.Bfreserved1=0)and(P^.Bfreserved2=0) then begin
			Hdrsize:=Pdword(Pchar(Data)+Sizeof(Tbitmapfileheader))^;

			case Hdrsize of
				Sizeof(Tbitmapinfoheader):Result:=True;
				Sizeof(Tbitmapv4header):Result:=True;
				Sizeof(Tbitmapv5header):Result:=True
			end
		end
	end;

	{ TGraphicsResourceDetails }

	procedure Tgraphicsresourcedetails.Setimage(Image:Tpicture);
	begin
		Data.Clear;
		Image.Graphic.Savetostream(Data);
	end;

initialization

Tpicture.Registerfileformat('ICO',Rsticons,Texicon);
Tpicture.Registerfileformat('CUR',Rstcursors,Texcursor);
Tpicture.Unregistergraphicclass(Ticon);

Registerresourcedetails(Tbitmapresourcedetails);
Registerresourcedetails(Tdibresourcedetails);
Registerresourcedetails(Ticongroupresourcedetails);
Registerresourcedetails(Tcursorgroupresourcedetails);
Registerresourcedetails(Ticonresourcedetails);
Registerresourcedetails(Tcursorresourcedetails);

finalization

Tpicture.Unregistergraphicclass(Texicon);
Tpicture.Unregistergraphicclass(Texcursor);
Tpicture.Registerfileformat('ICO','Icon',Ticon);
Unregisterresourcedetails(Tcursorresourcedetails);
Unregisterresourcedetails(Ticonresourcedetails);
Unregisterresourcedetails(Tcursorgroupresourcedetails);
Unregisterresourcedetails(Ticongroupresourcedetails);
Unregisterresourcedetails(Tdibresourcedetails);
Unregisterresourcedetails(Tbitmapresourcedetails);

end.
