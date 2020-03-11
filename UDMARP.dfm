object DMARP: TDMARP
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 150
  Width = 215
  object CldNetstat: TClientDataSet
    PersistDataPacket.Data = {
      D20000009619E0BD010000001800000007000000000003000000D2000850726F
      746F636F6C01004900000001000557494454480200020006000C4C6F63616C41
      6464726573730100490000000100055749445448020002001400094C6F63616C
      506F727404000100000000000D52656D6F746541646472657373010049000000
      01000557494454480200020014000A52656D6F7465506F727404000100000000
      0006537461747573010049000000010005574944544802000200100003504944
      01004900000001000557494454480200020008000000}
    Active = True
    Aggregates = <>
    Params = <>
    Left = 127
    Top = 30
    object CldNetstatProtocol: TStringField
      DisplayLabel = #21327#35758
      FieldName = 'Protocol'
      Size = 6
    end
    object CldNetstatLocalAddress: TStringField
      DisplayLabel = #26412#22320#22320#22336
      FieldName = 'LocalAddress'
    end
    object CldNetstatLocalPort: TIntegerField
      DisplayLabel = #26412#22320#31471#21475
      FieldName = 'LocalPort'
    end
    object CldNetstatRemoteAddress: TStringField
      DisplayLabel = #36828#31243#22320#22336
      FieldName = 'RemoteAddress'
    end
    object CldNetstatRemotePort: TIntegerField
      DisplayLabel = #36828#31243#31471#21475
      FieldName = 'RemotePort'
    end
    object CldNetstatStatus: TStringField
      DisplayLabel = #29366#24577
      DisplayWidth = 16
      FieldName = 'Status'
      Size = 16
    end
    object CldNetstatPID: TStringField
      FieldName = 'PID'
      Size = 8
    end
  end
end
