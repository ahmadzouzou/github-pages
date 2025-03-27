unit UIRibbonLib;

interface

uses
	System.SysUtils;

const
	ApplicationMenuOpened=0;
	RibbonMinimized=1;
	RibbonExpanded=2;
	ApplicationModeSwitched=3;
	TabActivated=4;
	MenuOpened=5;
	CommandExecuted=6;
	TooltipShown=7;
	Ribon=0;
	QAT=1;
	ApplicationMenu=2;
	ContextPopup=3;

type

	TEventType=0..7;
	TEventLocation=0..3; // Define actual locations as needed

	TEVENTPARAMS=record
		CommandId:Cardinal;
		CommandName:PWideChar; // Pointer to wide string
		ParentCommandID:Cardinal;
		ParentCommandName:PWideChar; // Pointer to wide string
		SelectionIndex:Cardinal;
		Location:TEventLocation;
	end;

	TEventParameters=record
		// AMD1: array [0..15] OF Byte;
		AM1:Integer;
		AM2:Integer;
		AM3:Integer;
		AM4:Integer;
		case EventType:TEventType of
			ApplicationModeSwitched:(Modes:Integer);
			ApplicationMenuOpened,RibbonMinimized,RibbonExpanded,TabActivated,MenuOpened,CommandExecuted,TooltipShown:
				(Params:TEVENTPARAMS;);
	end;

	{ TEventParameters=record
		AM1:Integer;
		AM2:Integer;
		AM3:Integer;
		AM4:Integer;
		EventType:TEventType;
		case Byte of
		3:(Modes:Integer);
		0,1,2,4,5,6,7:(Params:TEVENTPARAMS)
		end; }

	IUIEventLogger=interface(IUnknown)
		['{ec3e1034-dbf4-41a1-95d5-03e0f1026e05}']
		function OnUIEvent(pEventParams:TEventParameters):HResult;stdcall;

	end;

	IUIEventingManager=interface(IUnknown)
		['{3BE6EA7F-9A9B-4198-9368-9B0F923BD534}']
		function SetEventLogger(eventLogger:IUIEventLogger):HResult;stdcall;

	end;

	/// <summary>
	/// The EventArgs of EventLogger
	/// </summary>
	TEventLoggerEventArgs=class
	private
		FEventType:TEventType;
		FModes:Integer;
		FCommandID:Cardinal;
		FCommandName:string;
		FParentCommandID:Cardinal;
		FParentCommandName:string;
		FSelectionIndex:Cardinal;
		FLocation:TEventLocation;
		FEventParams:TEventParameters;
	public
		constructor Create(var pEventParams:TEventParameters);
		property EventParams:TEventParameters read FEventParams;
		property EventType:TEventType read FEventType;
		property Modes:Integer read FModes;
		property CommandId:Cardinal read FCommandID;
		property CommandName:string read FCommandName;
		property ParentCommandID:Cardinal read FParentCommandID;
		property ParentCommandName:string read FParentCommandName;
		property SelectionIndex:Cardinal read FSelectionIndex;
		property Location:TEventLocation read FLocation;
	private
		procedure CopyAndMarshal(var pEventParams:TEventParameters);
	end;

	TRibbonOnUIEvent=procedure(Sender:TObject;pEventParams:TEventLoggerEventArgs) of object;

	[ComVisible(true)]
	[Guid('0406D872-D9E9-4D6D-A053-B12ECFC22C35')]
	TEventLogger=class(TInterfacedObject,IUIEventLogger)
	private
		FEventingManager:IUIEventingManager;
		FAttached:Boolean;
		FLogEvent:TRibbonOnUIEvent;
	public
		constructor Create(AEventingManager:IUIEventingManager);
		procedure Attach;
		procedure Detach;
		function OnUIEvent(pEventParams:TEventParameters):HResult;stdcall;
		procedure Destroy;
		property OnLogEvent:TRibbonOnUIEvent read FLogEvent write FLogEvent;
	end;

implementation

constructor TEventLoggerEventArgs.Create(var pEventParams:TEventParameters);
begin
	FEventParams:=pEventParams;
	FEventType:=pEventParams.EventType;
	case pEventParams.EventType of
		// ApplicationModeSwitched:FModes:=pEventParams.Modes;
		ApplicationMenuOpened,RibbonMinimized,RibbonExpanded,CommandExecuted,TooltipShown,MenuOpened:
			CopyAndMarshal(pEventParams);
	end;
end;

procedure TEventLoggerEventArgs.CopyAndMarshal(var pEventParams:TEventParameters);
begin
	FCommandID:=pEventParams.Params.CommandId;
	FCommandName:=WideCharToString(pEventParams.Params.CommandName); // PCWStr
	FParentCommandID:=pEventParams.Params.ParentCommandID;
	FParentCommandName:=WideCharToString(pEventParams.Params.ParentCommandName); // PCWStr
	FSelectionIndex:=pEventParams.Params.SelectionIndex;
	FLocation:=pEventParams.Params.Location;
end;

constructor TEventLogger.Create(AEventingManager:IUIEventingManager);
begin
	FEventingManager:=AEventingManager;
	FAttached:=False;
end;

procedure TEventLogger.Attach;
begin
	if not FAttached then begin
		FEventingManager.SetEventLogger(Self);
		FAttached:=true;
	end;
end;

procedure TEventLogger.Detach;
begin
	FEventingManager.SetEventLogger(nil);
	FAttached:=False;
end;

function TEventLogger.OnUIEvent(pEventParams:TEventParameters):HResult;stdcall;
begin
	if Assigned(FLogEvent) then FLogEvent(Self,TEventLoggerEventArgs.Create(pEventParams));
	Result:=S_FALSE;
end;

procedure TEventLogger.Destroy;
begin
	if FAttached then Detach;
	FEventingManager:=nil;
end;

end.
