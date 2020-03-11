unit UFmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, Datasnap.DBClient, System.Actions, Vcl.ActnList,
  Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    ActionList1: TActionList;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Button1: TButton;
    AcNetstat: TAction;
    AcFilterNetstat: TAction;
    Button2: TButton;
    RadioGroup1: TRadioGroup;
    EditFilter: TEdit;
    Button3: TButton;
    AcCancelFilter: TAction;
    Button4: TButton;
    AcDos: TAction;
    EditCmd: TEdit;
    CheckBox1: TCheckBox;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    procedure AcNetstatExecute(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure AcFilterNetstatExecute(Sender: TObject);
    procedure AcCancelFilterExecute(Sender: TObject);
    procedure AcDosExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    { Private declarations }
    procedure DecodeNetstat(const S: string; ACld: TClientDataSet);
    procedure ShowRecordCount;
    procedure DoOnMouseWheel(Var Msg :TMsg;var Handled:Boolean);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses UDosCommand, UFmARP, UDMARP;

{$R *.dfm}

procedure TForm1.AcCancelFilterExecute(Sender: TObject);
begin
  //CldNetStat.Filtered := False;
  DMARP.CancelFilterNetstat;
  Self.ShowRecordCount;
end;

procedure TForm1.AcDosExecute(Sender: TObject);
var
  S: string;
begin
  S := GetDosOutput(EditCmd.Text);
  ShowMessage(S);
end;

procedure TForm1.AcFilterNetstatExecute(Sender: TObject);
begin
  DMARP.DoFilterNetstat(RadioGroup1.ItemIndex, EditFilter.Text);

  {
  case RadioGroup1.ItemIndex of
    0:
    begin
      CldNetStat.Filtered := False;
      CldNetStat.Filter := 'RemoteAddress=' + QuotedStr(EditFilter.Text);
      CldNetStat.Filtered := True;
    end;

    1:
    begin
      CldNetStat.Filtered := False;
      CldNetStat.Filter := 'LocalPort=' + (EditFilter.Text);
      CldNetStat.Filtered := True;
    end;

    2:
    begin
      CldNetStat.Filtered := False;
      CldNetStat.Filter := 'RemotePort=' + (EditFilter.Text);
      CldNetStat.Filtered := True;
    end;

    3:
    begin
      CldNetStat.Filtered := False;
      CldNetStat.Filter := 'PID=' + QuotedStr(EditFilter.Text);
      CldNetStat.Filtered := True;
    end;

  end;
  }

  Self.ShowRecordCount;
end;

procedure TForm1.AcNetstatExecute(Sender: TObject);
var
  S: string;
begin
  Screen.Cursor := crHourGlass;
  try
//    S := GetDosOutput('Netstat -nao');
//    DecodeNetstat(S, DMARP.CldNetstat);

    DMARP.DoNetstat(CheckBox1.Checked);
    Self.ShowRecordCount;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  FmARP.Show;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  DmARP.UserName := 'abcd';
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  ShowMessage(DMArp.UserName);

end;

procedure TForm1.DBGrid1TitleClick(Column: TColumn);
begin
  DMARP.CldNetStat.IndexFieldNames := Column.FieldName; //点DBGird抬头排序
end;

procedure TForm1.DecodeNetstat(const S: string; ACld: TClientDataSet);
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

    if not CheckBox1.Checked then ACld.Filtered := False; //是否保持之前的过滤状态。如果false则取消过滤。
    

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

procedure TForm1.DoOnMouseWheel(var Msg: TMsg; var Handled: Boolean);
begin
  //为 DBGrid1 添加鼠标滚动，但经过测试，这段代码没用！
  if Msg.message = WM_MouseWheel then
  begin
    if Msg.wParam > 0 then
     begin
       if DBGrid1.Focused then
         SendMessage(DBGrid1.Handle,WM_VSCROLL,SB_PAGEUP,0);
     end
    else
     begin
       if DBGrid1.Focused then
         SendMessage(DBGrid1.Handle,WM_VSCROLL,SB_PAGEDOWN,0);
     end;
    Handled:= True;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 // Application.OnMessage := DoOnMouseWheel; // 截获鼠标滚动事件
end;

procedure TForm1.ShowRecordCount;
var
  i: Integer;
begin
  if DBGrid1.DataSource.DataSet.Active then
  begin
    i := DBGrid1.DataSource.DataSet.RecordCount;

    StatusBar1.Panels[0].Text := '记录数 = ' + IntToStr(i);

    //DBGrid1.UpdateControlState;
    ShowScrollBar(dbgrid1.Handle,SB_BOTH,true);   //这句话让 DBGrid 出现滚动条。否则当过滤后，取消过滤，记录条数大于可显示数，它也不出滚动条。
  end;
end;

end.
