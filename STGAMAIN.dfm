object SSTGA: TSSTGA
  AlignWithMargins = True
  Left = 0
  Top = 0
  Anchors = [akLeft, akTop, akRight, akBottom]
  Caption = 'SSTGA'
  ClientHeight = 900
  ClientWidth = 744
  Color = clBtnFace
  Font.Charset = ARABIC_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial Narrow'
  Font.Style = []
  TextHeight = 15
  object GroupBox1: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 738
    Height = 288
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'INFO'
    DockSite = True
    TabOrder = 0
    object StaticText1: TStaticText
      AlignWithMargins = True
      Left = 576
      Top = 40
      Width = 62
      Height = 19
      Cursor = crHandPoint
      Alignment = taCenter
      Caption = 'StaticText1'
      FocusControl = StaticText1
      Font.Charset = ARABIC_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Arial Narrow'
      Font.Style = [fsUnderline]
      ParentFont = False
      TabOrder = 0
      OnClick = StaticText1Click
    end
    object LinkLabel1: TLinkLabel
      Left = 576
      Top = 80
      Width = 60
      Height = 19
      Caption = 'LinkLabel1'
      TabOrder = 1
      UseVisualStyle = True
      OnClick = LinkLabel1Click
    end
    object ButtonedEdit1: TButtonedEdit
      AlignWithMargins = True
      Left = 515
      Top = 144
      Width = 121
      Height = 23
      Images = AMDF.Amd
      RightButton.ImageIndex = 9
      RightButton.Visible = True
      TabOrder = 2
      Text = 'ButtonedEdit1'
    end
    object LabeledEdit1: TLabeledEdit
      AlignWithMargins = True
      Left = 125
      Top = 60
      Width = 196
      Height = 23
      Alignment = taCenter
      EditLabel.Width = 92
      EditLabel.Height = 23
      EditLabel.Caption = 'Customer Name'
      LabelPosition = lpLeft
      LabelSpacing = 5
      TabOrder = 3
      Text = ''
      StyleName = 'Windows'
    end
    object LabeledEdit2: TLabeledEdit
      AlignWithMargins = True
      Left = 125
      Top = 31
      Width = 95
      Height = 23
      Alignment = taCenter
      EditLabel.Width = 105
      EditLabel.Height = 23
      EditLabel.Caption = 'Document Number'
      LabelPosition = lpLeft
      LabelSpacing = 5
      NumbersOnly = True
      ReadOnly = True
      TabOrder = 4
      Text = ''
      StyleName = 'Windows'
    end
    object SearchBox1: TSearchBox
      Left = 226
      Top = 31
      Width = 95
      Height = 23
      Alignment = taCenter
      TabOrder = 5
    end
  end
  object SJ1: TSJ
    AlignWithMargins = True
    Left = 3
    Top = 297
    Width = 738
    Height = 250
    DragImagesCount = 0
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    Bidimode = bdLeftToRight
    Colcount = 10
    RowCount = 10
    GridLineWidth = 4
    Options = [GoFixedVertLine, GoFixedHorzLine, GoVertLine, GoHorzLine, GoRangeSelect, GoTabs, GoThumbTracking, GoFixedColClick, GoFixedRowClick, GoFixedHotTrack]
    ParentBidimode = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    FixedCellsFont.Charset = DEFAULT_CHARSET
    FixedCellsFont.Color = clWindowText
    FixedCellsFont.Height = -12
    FixedCellsFont.Name = 'Segoe UI'
    FixedCellsFont.Style = [fsBold]
    FixedCellsSelectedFont.Charset = ARABIC_CHARSET
    FixedCellsSelectedFont.Color = clRed
    FixedCellsSelectedFont.Height = -15
    FixedCellsSelectedFont.Name = 'Segoe UI'
    FixedCellsSelectedFont.Style = [fsBold]
    EnableOnChanges = True
    EnableOnGetCell = False
  end
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 553
    Width = 738
    Height = 49
    Align = alTop
    AutoSize = True
    TabOrder = 2
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 608
    Width = 738
    Height = 32
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoSize = True
    TabOrder = 3
  end
  object Panel3: TPanel
    Left = 0
    Top = 643
    Width = 744
    Height = 41
    Align = alTop
    AutoSize = True
    TabOrder = 4
  end
  object Panel4: TPanel
    Left = 0
    Top = 684
    Width = 744
    Height = 51
    Align = alTop
    AutoSize = True
    TabOrder = 5
  end
  object StatusBar1: TStatusBar
    AlignWithMargins = True
    Left = 3
    Top = 872
    Width = 738
    Height = 25
    AutoHint = True
    Panels = <>
    ParentColor = True
    ParentFont = True
    ParentShowHint = False
    ShowHint = True
    UseSystemFont = False
  end
  object StatusBar2: TStatusBar
    Left = 0
    Top = 840
    Width = 744
    Height = 29
    AutoHint = True
    Anchors = [akLeft, akTop, akRight, akBottom]
    Panels = <>
    ParentColor = True
    ParentFont = True
    SimplePanel = True
    UseSystemFont = False
  end
end
