object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 196
  ClientWidth = 448
  Color = 16774636
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 169
    Height = 196
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 20
    Margins.Bottom = 0
    Align = alLeft
    BevelOuter = bvNone
    BevelWidth = 3
    Color = clSilver
    ParentBackground = False
    TabOrder = 0
    object Label3: TLabel
      Left = 16
      Top = 104
      Width = 24
      Height = 13
      Caption = 'Renk'
    end
    object Label2: TLabel
      Left = 16
      Top = 24
      Width = 31
      Height = 13
      Caption = 'Kal'#305'nl'#305'k'
    end
    object Label4: TLabel
      Left = 16
      Top = 136
      Width = 22
      Height = 13
      Caption = 'Sat'#305'r'
    end
    object Label5: TLabel
      Left = 16
      Top = 168
      Width = 28
      Height = 13
      Caption = 'S'#252'tun'
    end
    object CheckBox1: TCheckBox
      Left = 16
      Top = 48
      Width = 60
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Kenar'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = CheckBox1Click
    end
    object ColorBox1: TColorBox
      Left = 64
      Top = 101
      Width = 89
      Height = 22
      Selected = clRed
      TabOrder = 1
      OnChange = ColorBox1Change
    end
    object SpinEdit1: TSpinEdit
      Left = 64
      Top = 21
      Width = 63
      Height = 22
      MaxValue = 20
      MinValue = 1
      TabOrder = 2
      Value = 1
      OnChange = SpinEdit1Change
    end
    object SpinEdit2: TSpinEdit
      Left = 64
      Top = 133
      Width = 63
      Height = 22
      MaxValue = 20
      MinValue = 1
      TabOrder = 3
      Value = 2
      OnChange = SpinEdit2Change
    end
    object SpinEdit3: TSpinEdit
      Left = 64
      Top = 165
      Width = 63
      Height = 22
      MaxValue = 20
      MinValue = 1
      TabOrder = 4
      Value = 2
      OnChange = SpinEdit3Change
    end
    object CheckBox2: TCheckBox
      Left = 16
      Top = 72
      Width = 60
      Height = 17
      Alignment = taLeftJustify
      Caption = 'K'#246#351'egen'
      Checked = True
      State = cbChecked
      TabOrder = 5
      OnClick = CheckBox2Click
    end
  end
  object IzgaraPanel1: TIzgaraPanel
    Left = 169
    Top = 0
    Width = 279
    Height = 196
    Align = alClient
    object Label1: TLabel
      Left = 136
      Top = 142
      Width = 31
      Height = 13
      Caption = 'Label1'
    end
    object Button2: TButton
      Left = 24
      Top = 13
      Width = 161
      Height = 49
      Caption = 'Button2'
      TabOrder = 2
    end
    object Edit2: TEdit
      Left = 24
      Top = 93
      Width = 185
      Height = 21
      TabOrder = 3
      Text = 'Edit2'
    end
  end
end
