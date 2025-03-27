unit NewStringGrid;

interface

uses Windows,Messages,SysUtils,Classes,Controls,Graphics,Grids;

type
  TGetEditStyleEvent=procedure(TSender: TObject; ACol,ARow: integer;
    var EditStyle: TEditStyle)of object;

  TSG=class(TStringGrid)
  private
    FDropdownRowCount: integer;
    FOnEditButtonClick: TNotifyEvent;
    FOnGetEditStyle: TGetEditStyleEvent;
    FOnGetPickListItems: TOnGetPickListItems;
    procedure SetDropdownRowCount(value: integer);
    procedure SetOnEditButtonClick(value: TNotifyEvent);
    procedure SetOnGetPicklistItems(value: TOnGetPickListItems);
  protected
    function CreateEditor: TInplaceEdit; override;
    function GetEditStyle(ACol,ARow: integer): TEditStyle; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property DropdownRowCount: integer read FDropdownRowCount write SetDropdownRowCount
      default 8;
    property OnEditButtonClick: TNotifyEvent read FOnEditButtonClick
      write SetOnEditButtonClick;
    property OnGetEditStyle: TGetEditStyleEvent read FOnGetEditStyle write FOnGetEditStyle;
    property OnGetPickListItems: TOnGetPickListItems read FOnGetPickListItems
      write SetOnGetPicklistItems;
  end;

  // procedure Register;

implementation

constructor TSG.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDropdownRowCount:=8;
end;

function TSG.CreateEditor: TInplaceEdit;
begin
  result:=TInplaceEditList.Create(self);
  with TInplaceEditList(result)do begin
    DropdownRows:=FDropdownRowCount;
    OnGetPickListItems:=FOnGetPickListItems;
    OnEditButtonClick:=FOnEditButtonClick;
  end;
end;

function TSG.GetEditStyle(ACol,ARow: integer): TEditStyle;
begin
  result:=esSimple;
  if Assigned(FOnGetEditStyle)then
    FOnGetEditStyle(self,ACol,ARow,result);
end;

procedure TSG.SetDropdownRowCount(value: integer);
begin
  FDropdownRowCount:=value;
  if Assigned(InplaceEditor)then
    TInplaceEditList(InplaceEditor).DropdownRows:=value;
end;

procedure TSG.SetOnEditButtonClick(value: TNotifyEvent);
begin
  FOnEditButtonClick:=value;
  if Assigned(InplaceEditor)then
    TInplaceEditList(InplaceEditor).OnEditButtonClick:=value;
end;

procedure TSG.SetOnGetPicklistItems(value: TOnGetPickListItems);
begin
  FOnGetPickListItems:=value;
  if Assigned(InplaceEditor)then
    TInplaceEditList(InplaceEditor).OnGetPickListItems:=value;
end;

{ procedure Register;
  begin
  RegisterComponents('Additional',[TSG]);
  end; }

end.
