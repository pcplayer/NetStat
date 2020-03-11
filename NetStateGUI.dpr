program NetStateGUI;

uses
  Vcl.Forms,
  UFmMain in 'UFmMain.pas' {Form1},
  UDosCommand in 'UDosCommand.pas',
  UARP in 'UARP.pas',
  UFmARP in 'UFmARP.pas' {FmARP},
  UDMARP in 'UDMARP.pas' {DMARP: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFmARP, FmARP);
  Application.CreateForm(TDMARP, DMARP);
  Application.Run;
end.
