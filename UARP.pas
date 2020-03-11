unit UARP;
{-------------------------------------------------------------------------------
  通过 DOS 命令行，执行 arp -a 命令，获得 ARP 的 MAC 地址列表。然后解析出来。

  pcplayer 2013-8-21
-------------------------------------------------------------------------------}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  UDosCommand;

type
  TARPCmd = class(TComponent)
  private
    FARPStr: string;  //
    FARPList: TStringList;  //分解后的 IP - MAC 列表

    procedure GetIPMAC(const S: string; var IP, MAC: string); overload;
    procedure GetIPMacList;
    function GetMACCount: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure RefreshARP;
    procedure GetIPMAC(const Index: Integer; var IP, MAC: string); overload;

    property MacCount: Integer read GetMACCount;
  end;

implementation

{ TARPCmd }

constructor TARPCmd.Create(AOwner: TComponent);
begin
  inherited;
  FARPList := TStringList.Create;
end;

destructor TARPCmd.Destroy;
begin
  FARPList.Free;
  inherited;
end;

procedure TARPCmd.GetIPMAC(const S: string; var IP, MAC: string);
var
  i: Integer;
begin
{---------------------------------------------------------------------
  将一条 224.11.11.11          01-00-5e-0b-0b-0b     静态  分解为 IP 和 MAC
---------------------------------------------------------------------}
  //S := TrimLeft(S);
  MAC := S;
  MAC := TrimLeft(MAC);

  i := POS(' ', MAC);
  IP := Copy(MAC, 1, i -1);


  Delete(MAC, 1, i); //去掉前面的 IP 部分
  MAC := TrimLeft(MAC);

  i := POS(' ', MAC);
  MAC := Copy(MAC, 1, i -1);


  IP := Trim(IP);
  MAC := Trim(MAC);
end;

procedure TARPCmd.GetIPMAC(const Index: Integer; var IP, MAC: string);
var
  S: string;
begin
  S := FARPList[Index];
  GetIPMAC(S, IP, MAC);
end;

procedure TARPCmd.GetIPMacList;
var
  i: Integer;
  S: string;
begin
{---------------------------------------------------------------------
  去掉ARP 命令返回文本里非 IP-MAC 的部分。
---------------------------------------------------------------------}
  FARPList.Text := FARPStr;

  for i := FARPList.Count -1 downto 0 do
  begin
    //检查如果不是 192.168.0.1           20-4e-7f-2f-50-04     动态  这种格式的，就删除掉。
    S := FARPList.Strings[i];

    if S = '' then
    begin
      FARPList.Delete(i);
      Continue;
    end;

    if S[1] <> ' ' then
    begin
      FARPList.Delete(i); //前面没空格的，删除掉。
      Continue;
    end;

    if not (S[3] in ['0'..'9']) then
    begin
      FARPList.Delete(i);  //前面第一位不是数字的，删除。
    end;
  end;
end;

function TARPCmd.GetMACCount: Integer;
begin
  Result := FARPList.Count;
end;

procedure TARPCmd.RefreshARP;
begin
  FARPStr := GetDosOutput('arp -a');

  Self.GetIPMacList;
end;

end.
