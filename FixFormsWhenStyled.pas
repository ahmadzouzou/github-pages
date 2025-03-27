unit FixFormsWhenStyled;

interface

Uses
    Messages,
    Forms;

type
    TFixedFormStyleHook = class(TFormStyleHook)
    strict protected
        procedure WndProc(var Message: TMessage); override;
    end;

implementation

Uses
    SysUtils,
    Windows,
    Vcl.Themes,
    Vcl.Styles;

{ TFixedFormStyleHook }

procedure TFixedFormStyleHook.WndProc(var Message: TMessage);
var
    ncParams: NCCALCSIZE_PARAMS;
    newMsg: TMessage;
begin
    if (Message.Msg = WM_NCCALCSIZE)
    AND (Message.WParam = 0)
    then begin
            // Convert message to format with WPARAM == TRUE due to VCL styles
            // failure to handle it when WPARAM == FALSE.
            Message.WParam := 1;
            inherited WndProc(Message);
    end else begin
        inherited;
    end;
end;

Initialization

    TCustomStyleEngine.RegisterStyleHook(TForm, TFixedFormStyleHook);
    TCustomStyleEngine.RegisterStyleHook(TCustomForm, TFixedFormStyleHook);

end.
