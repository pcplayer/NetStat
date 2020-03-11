unit UFmARP;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.DBGrids, Data.DB,
  Datasnap.DBClient, Vcl.ExtCtrls, UARP, Vcl.StdCtrls;

type
  TFmARP = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    DataSource1: TDataSource;
    CldARP: TClientDataSet;
    DBGrid1: TDBGrid;
    CldARPIP: TStringField;
    CldARPMAC: TStringField;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FARP: TARPCmd;

    procedure RefreshMAC;
  public
    { Public declarations }
  end;

var
  FmARP: TFmARP;

implementation

{$R *.dfm}

procedure TFmARP.Button1Click(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    RefreshMAC;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFmARP.FormCreate(Sender: TObject);
begin
  FARP := TARPCmd.Create(Self);
end;

procedure TFmARP.RefreshMAC;
var
  i: Integer;
  IP, MAC: string;
begin
  FARP.RefreshARP;
  CldARP.EmptyDataSet;

  for i := 0 to FARP.MacCount -1 do
  begin
    FARP.GetIPMAC(i, IP, MAC);
    CldARP.Insert;
    CldARP.FieldByName('IP').Value := IP;
    CldARP.FieldByName('MAC').Value := MAC;
    CldARP.Post;
  end;
end;

end.
