unit UDMARP;
{-----------------------------------------------------------------------------
  用户存放 ARP 解析出来的 MAC 表。

  pcplayer. 2013-9-23
-----------------------------------------------------------------------------}
interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient, MidasLib;

type
  TDMARP = class(TDataModule)
    CldNetstat: TClientDataSet;
    CldNetstatProtocol: TStringField;
    CldNetstatLocalAddress: TStringField;
    CldNetstatLocalPort: TIntegerField;
    CldNetstatRemoteAddress: TStringField;
    CldNetstatRemotePort: TIntegerField;
    CldNetstatStatus: TStringField;
    CldNetstatPID: TStringField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FUserName: string;

    procedure DecodeNetstat(const S: string; const KeepFilter: Boolean; ACld: TClientDataSet);
    procedure SetUserName(const Value: string);
    function GetUserName: string;
  public
    { Public declarations }
    procedure DoFilterNetstat(const FilterIndex: Integer; const FilterStr: string);
    procedure CancelFilterNetstat;
    procedure DoNetstat(const KeepFilter: Boolean);

    property UserName: string read GetUserName write SetUserName;
  end;

var
  DMARP: TDMARP;

implementation

uses UDosCommand;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDMARP }

procedure TDMARP.CancelFilterNetstat;
begin
  CldNetStat.Filtered := False;
end;

procedure TDMARP.DataModuleCreate(Sender: TObject);
begin
  FUserName := '33333';
end;

procedure TDMARP.DecodeNetstat(const S: string; const KeepFilter: Boolean; ACld: TClientDataSet);
var
  SL, ALine: TStringList;
  SJ, SIP, SPort: string; //连接
  i,j: Integer;
begin
  //将 Netstat 返回的字符串分析出来格式并填入 ClientDataSet 里面。
  if not ACld.Active then raise Exception.Create('给的 ClientDataSet 没有打开！');

  SL := TStringList.Create;
  ALine := TStringList.Create;
  try
    SL.Text := S;
    if SL.Count < 2 then Exit;

    SL.Delete(0);
    SL.Delete(0); //先删除前面2行。

    ACld.First;
    while not ACld.Eof do ACld.Delete;
    ACld.MergeChangeLog;

    if not KeepFilter then ACld.Filtered := False; //是否保持之前的过滤状态。如果false则取消过滤。


    //开始分析字符串。
    for I := 0 to SL.Count -1 do
    begin
      SJ := SL.Strings[i];

      ALine.Delimiter := Char(20);
      ALine.DelimitedText := SJ;

      if Pos(':', SJ) = 0 then Continue; //没有冒号的，不是连接描述字符串。


      if ALine.Count = 5 then
      begin
        With ACld do
        begin
          try
            Insert;

            Fields[0].Value := ALine.Strings[0];
            SPort := ALine.Strings[1]; //192.168.90.5:3388
            SIP := Copy(SPort, 1, Pos(':', SPort) -1);
            SPort := Copy(SPort, Pos(':', SPort) + 1, Length(SPort) - (Pos(':', SPort)));
            Fields[1].Value := SIP;
            Fields[2].Value := StrToInt(SPort);

            SPort := ALine.Strings[2];
            SIP := Copy(SPort, 1, Pos(':', SPort)-1);
            SPort := Copy(SPort, Pos(':', SPort) + 1, Length(SPort) - (Pos(':', SPort)));
            Fields[3].Value := SIP;
            Fields[4].Value := StrToInt(SPort);

            Fields[5].Value := ALine.Strings[3];
            Fields[6].Value := ALine.Strings[4];

            Post;
          except
            Cancel;
            Continue;
          end;
        end;
      end;
    end;

    ACld.MergeChangeLog;
  finally
    SL.Free;
    ALine.Free;
  end;
end;

procedure TDMARP.DoFilterNetstat(const FilterIndex: Integer;
  const FilterStr: string);
begin
  case FilterIndex of
    0:
    begin
      CldNetStat.Filtered := False;
      CldNetStat.Filter := 'RemoteAddress=' + QuotedStr(FilterStr);
      CldNetStat.Filtered := True;
    end;

    1:
    begin
      CldNetStat.Filtered := False;
      CldNetStat.Filter := 'LocalPort=' + QuotedStr(FilterStr);
      CldNetStat.Filtered := True;
    end;

    2:
    begin
      CldNetStat.Filtered := False;
      CldNetStat.Filter := 'RemotePort=' + QuotedStr(FilterStr);
      CldNetStat.Filtered := True;
    end;

    3:
    begin
      CldNetStat.Filtered := False;
      CldNetStat.Filter := 'PID=' + QuotedStr(FilterStr);
      CldNetStat.Filtered := True;
    end;
  end;
end;

procedure TDMARP.DoNetstat(const KeepFilter: Boolean);
var
  S: string;
begin
  S := GetDosOutput('Netstat -nao');
  Self.DecodeNetstat(S, KeepFilter, Self.CldNetstat);
end;

function TDMARP.GetUserName: string;
begin
  Result := FUserName;
end;

procedure TDMARP.SetUserName(const Value: string);
begin
//
  FUserName := Value;

  //
end;

end.
