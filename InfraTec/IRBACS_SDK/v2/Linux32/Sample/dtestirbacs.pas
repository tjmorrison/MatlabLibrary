unit dTestIrbAcs;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls, Grids, StdCtrls, Spin;

type

  { TfrmTestLib }

  TfrmTestLib = class(TForm)
    gbxData: TGroupBox;
    imlMain: TImageList;
    imgIRB: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    lblCalibRange: TLabel;
    lblMax: TLabel;
    lblMin: TLabel;
    lblT: TLabel;
    lblTBB: TLabel;
    opDlg1: TOpenDialog;
    pnlImage: TPanel;
    pnlProps: TPanel;
    SpinFrameNb: TSpinEdit;
    spinX: TSpinEdit;
    spinY: TSpinEdit;
    stbMain: TStatusBar;
    stgProps: TStringGrid;
    tlbMain: TToolBar;
    tbnTest: TToolButton;
    tbnOpen: TToolButton;
    tbnCalib: TToolButton;
    tbnVis: TToolButton;
    tbnAudio: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpinFrameNbChange(Sender: TObject);
    procedure spinXChange(Sender: TObject);
    procedure spinxYChange(Sender: TObject);
    procedure tbnAudioClick(Sender: TObject);
    procedure tbnCalibClick(Sender: TObject);
    procedure tbnTestClick(Sender: TObject);
    procedure tbnOpenClick(Sender: TObject);
    procedure tbnVisClick(Sender: TObject);
  private
    { private declarations }
    FFileName : String;
    FIrbacsHnd : PtrUint;
    FFrameWidth : Integer;
    FFrameHeight : Integer;
    FBlockrecursiveSpinNb : Boolean;
    FBlockRecursiveSpinXY : Boolean;
    procedure CalculateMinMax;
    function CloseIrbFile: Boolean;
    procedure FillIRBPropTable(ihnd: PtrUInt);
    function OpenIrbfile: Boolean;
    procedure ShowIrbBmp;

    procedure SearchMinMaxByte(pData :PByte; iDataSize :Integer; var Min,Max :Single);
    procedure SearchMinMaxWord(pData :PWord; iDataSize :Integer; var Min,Max :Single);
    procedure SearchMinMaxSingle(pData :PSingle; iDataSize :Integer; var Min,Max :Single);


    procedure StatBar(indx: Integer; value: String);
  public
    { public declarations }
  end; 

var
  frmTestLib: TfrmTestLib;

implementation

{$R *.lfm}

uses
  hIRBFil, ldirbacs2, Math;

{ TfrmTestLib }

procedure TfrmTestLib.StatBar( indx : Integer; value : String );
begin
  stbMain.Panels[indx].Text := Value;
end;


procedure TfrmTestLib.tbnTestClick(Sender: TObject);
var
  ver1, ver2 : Integer;
begin
  if InitIRBACS64Library then
  begin
    StatBar(0, IntToStr( _testxxx( 1 ) ));

    if _irbacs64_version( ver1, ver2 ) then
    begin
      StatBar( 1, IntToStr(ver1)+'.'+IntToStr(ver2));
    end;

    FreeIRBACS64Library;
  end;
end;

procedure TfrmTestLib.FormShow(Sender: TObject);
begin
  stgProps.Cells[0, 0] := 'Width';
  stgProps.Cells[0, 1] := 'Height';
  stgProps.Cells[0, 2] := 'Epsilon';
  stgProps.Cells[0, 3] := 'EnvTemp';
  stgProps.Cells[0, 4] := 'Absorption';
  stgProps.Cells[0, 5] := 'Obj.dist';
  stgProps.Cells[0, 6] := 'PathTemp';
  stgProps.Cells[0, 7] := 'DateTime';
  stgProps.Cells[0, 8] := 'MilliSeconds';
  stgProps.Cells[0, 9] := 'Camera';
  stgProps.Cells[0, 10]:= 'Serial Nb.';
  stgProps.Cells[0, 11]:= 'Lens';
end;

procedure TfrmTestLib.FormCreate(Sender: TObject);
begin
  FBlockrecursiveSpinNb := False;
  FBlockRecursiveSpinXY := False;
end;

procedure TfrmTestLib.FillIRBPropTable( ihnd : PtrUInt );
var
  fValue : Single;
  sparam : array[0..255] of AnsiChar;
begin
  _irbacs64_getParam( ihnd, Ord( pavWidth ), fValue );
  FFrameWidth := Round( fValue );
  stgProps.Cells[1, 0] := IntToStr( Round( fValue ) );
  spinX.MinValue := 0;
  spinX.MaxValue := round( fValue )-1;
  spinX.Text := FormatFloat( '0', fValue / 2 );

  _irbacs64_getParam( ihnd, Ord( pavHeight ), fValue );
  FFrameHeight := Round( fValue );
  stgProps.Cells[1, 1] := IntToStr( Round( fValue ) );
  spinY.MinValue := 0;
  spinY.MaxValue := round( fValue )-1;
  spinY.Text := FormatFloat( '0', fValue / 2 );

  spinX.Enabled := True;
  spinY.Enabled := True;

  if _irbacs64_getParam( ihnd, Ord( pavEpsilon ), fValue ) then
    stgProps.Cells[1, 2] := FormatFloat( '0.000',  fValue )
  else
    stgProps.Cells[1, 2] := '---';

  if _irbacs64_getParam( ihnd, Ord( pavEnvTemp ), fValue ) then
    stgProps.Cells[1, 3] := FormatFloat( '0.00 °C',  fValue -273.15 )
  else
    stgProps.Cells[1, 3] := '---';

  if _irbacs64_getParam( ihnd, Ord( pavAbsorption ), fValue ) then
    stgProps.Cells[1, 4] := FormatFloat( '0.000',  fValue )
  else
    stgProps.Cells[1, 4] := '---';

  if _irbacs64_getParam( ihnd, Ord( pavDistance ), fValue ) then
    stgProps.Cells[1, 5] := FormatFloat( '0.00 m',  fValue )
  else
    stgProps.Cells[1, 5] := '---';

  if _irbacs64_getParam( ihnd, Ord( pavPathTemp ), fValue ) then
    stgProps.Cells[1, 6] := FormatFloat( '0.00 °C',  fValue - 273.15 )
  else
    stgProps.Cells[1, 6] := '---';

  if _irbacs64_getParam( ihnd, Ord( pavTimeStamp ), fValue ) then
    stgProps.Cells[1, 7] := FormatDateTime( 'dd.mm hh:nn:ss',  fValue )
  else
    stgProps.Cells[1, 7] := '---';

  if _irbacs64_getParam( ihnd, Ord( pavMilliTime ), fValue ) then
    stgProps.Cells[1, 8] := FormatFloat( '0.00',  fValue )
  else
    stgProps.Cells[1, 8] := '---';

  if _irbacs64_getParam( ihnd, Ord( pavCalibMin ), fValue ) then
  begin
    lblCalibRange.Caption := FormatFloat( '0', fValue - 273.15 );
    if _irbacs64_getParam( ihnd, Ord( pavCalibMax ), fValue ) then
      lblCalibRange.Caption := lblCalibRange.Caption + ' .. ' + FormatFloat( '0 °C', fValue-273.15 );
  end;


  _irbacs64_getParamS( ihnd, Ord( pavKamera ), sparam );
  stgProps.Cells[1, 9] := StrPas( sparam );
  _irbacs64_getParamS( ihnd, Ord( pavKameraSNr ), sparam );
  stgProps.Cells[1, 10] := StrPas( sparam );
  _irbacs64_getParamS( ihnd, Ord( pavLens ), sparam );
  stgProps.Cells[1, 11] := StrPas( sparam );
end;

procedure TfrmTestLib.SpinFrameNbChange(Sender: TObject);
var
  ii : Integer;
begin
  //if not Assigned( FPixelData ) then Exit;
  if FBlockrecursiveSpinNb then
    exit;
  try
    FblockrecursiveSpinNb := True;
    try
      if not TryStrToInt( SpinFrameNb.Text, ii ) then Exit;
      if ( ii >= 0 ) and ( ii <= _irbacs64_getFrameCount( FIrbacsHnd )-1 ) then
        _irbacs64_setFrameNbByArrayIdx( FIrbacsHnd, ii ) // jump to framenumber in a sequence
      else
        SpinFrameNb.Text := IntToStr( _irbacs64_getFrameNbByArrayIdx( FIrbacsHnd ) );

      FillIRBPropTable( FIrbacsHnd );
      ShowIrbBmp;
    finally
      FblockrecursiveSpinNb := False;
    end;
  except
    on E : Exception do
    begin
      stbMain.Panels[2].Text :='Error in SpinFrameNbChange (' + e.ClassName  + ' ' + e.Message + ')';
    end;
  end;

end;

procedure TfrmTestLib.spinXChange(Sender: TObject);
begin

end;

procedure TfrmTestLib.spinXYChange(Sender: TObject);
var
  xval, yval : Integer;
begin
  if spinX.Text = '' then Exit;
  if spinY.Text = '' then Exit;

  try
    if FblockRecursiveSpinXY then Exit;
    try
      FblockRecursiveSpinXY := True;
      // SpinEdit in D7 does not limit the values reliably
      xVal := Max( Min( spinX.Value, spinX.MaxValue), 0 );
      yVal := Max( Min( spinY.Value, spinY.MaxValue), 0 );
      spinX.Value := xVal; // Write back corrected value
      spinY.Value := yVal;
      lblTBB.Caption := FormatFloat( '0.##', _irbacs64_getTempBBXY( FIrbacsHnd, xVal, yVal ) );
      lblT.Caption := FormatFloat( '0.##', _irbacs64_getTempXY( FIrbacsHnd, xVal, yVal ) );
    finally
      FblockRecursiveSpinXY := False;
    end;

  except
    on E : Exception do
    begin
      stbMain.Panels[2].Text :='Error in spinXYChange (' + e.ClassName  + ' ' + e.Message + ')';
    end;
  end;
end;

procedure TfrmTestLib.tbnAudioClick(Sender: TObject);
begin
  if _irbacs64_audioComment( FIrbacsHnd, 'audio.wav' ) then
  begin

  end;
end;

procedure TfrmTestLib.tbnCalibClick(Sender: TObject);
var
  caldata : TIRBCalibData;
  irbhdr101 : TIRBImageData101;
begin
  _irbacs64_getIRBCalibData( FIrbAcsHnd, @caldata );
  StatBar( 2, IntToStr( caldata.Version ));
  if _irbacs64_getIRBHeader( FIrbAcsHnd, @irbhdr101 ) then
  begin
      irbhdr101.objectPars.emissivity:= irbhdr101.objectPars.emissivity - 0.01;
      _irbacs64_SetIRBHeader( FIrbAcsHnd, @irbhdr101 );
  end;

  if _irbacs64_saveSingleFrame( FIrbAcsHnd, 'zzz_0.irb', nil )  then ;
end;

procedure TfrmTestLib.tbnOpenClick(Sender: TObject);
begin
   try
    if tbnOpen.Down then
      OpenIrbfile
    else
      CloseIrbFile;

  except
    on E : Exception do
    begin
      StatBar( 2, 'Error in tbnOpenClick (' + e.ClassName  + ' ' + e.Message + ')' );
    end;
  end;
end;

procedure TfrmTestLib.tbnVisClick(Sender: TObject);
begin
  if _irbacs64_exportVisBitmap( FIrbacsHnd, 'vis.bmp' ) then
  begin

  end;
end;



function TfrmTestLib.OpenIrbfile: Boolean;
var
  countOfFrameIndexes, frno: Integer;
  filenam : array[0..255] of AnsiChar;
  indxarr : TBoundArray;
begin
  Result := False;

  if not InitIRBACS64Library then
    exit;
  try
    if opDlg1.Execute then
    begin
      FFileName := opDlg1.FileName;
      StrPCopy(filenam, FFileName );

      FIrbacsHnd := _irbacs64_loadIRB( filenam );              // load IRB-file with its name
      if FIrbacsHnd = 0 then
      begin
        StatBar( 1, 'Loading IRB-file failed.');
        exit;
      end;
      StatBar( 1, ExtractFileNameOnly( filenam ) );

      countOfFrameIndexes := _irbacs64_getFrameCount( FIrbacsHnd );
      if countOfFrameIndexes < 1 then
      begin
        StatBar( 1, 'No frame found in IRB-file ' + FFileName );
        exit;
      end
      else
      begin
        StatBar( 0, IntToStr( countOfFrameIndexes ) + ' frames.' );
      end;
      // choosing frame by internal IRB-Index
      countOfFrameIndexes := _irbacs64_getIRBIndices( FIrbAcsHnd, PInteger( 0 ) );
      if countOfFrameIndexes > 0 then
        SetLength( indxarr, countOfFrameIndexes );
      countOfFrameIndexes := _irbacs64_getIRBIndices( FIrbAcsHnd, PInteger( @indxarr[0] ) );
      StatBar( 0, IntToStr( indxarr[High(indxarr)]  ) + ' indxl.' );

      {
      GetMem( PidxLst, countOfFrameIndexes * sizeof( Integer ) );
      countOfFrameIndexes := getIRBIndexes( FIrbAcsHnd, PidxLst );
      }

      frno := 0;
      if Length( indxarr ) > 1 then
        frno := Length( indxarr ) div 2;
      _irbacs64_setFrameNumber(  FIrbacsHnd, indxarr[frno] ); // jump to the first frame by setFrameNumber with the first IRB index
      StatBar( 2, IntToStr( _irbacs64_getFrameNumber( FIrbacsHnd ) ) + ' frnr.' );

      // doing the same by taking 0 as a ascending array index
      _irbacs64_setFrameNbByArrayIdx( FIrbacsHnd, 0 );   // jump to first frame in the sequence
      SpinFrameNb.Enabled := True;
      SpinFrameNb.MinValue := 0;
      SpinFrameNb.MaxValue := countOfFrameIndexes- 1;
      SpinFrameNb.Text := '0';

      FillIRBPropTable( FIrbAcsHnd );
      CalculateMinMax;
      ShowIrbBmp;
    end;
    Result := True;
  except
    on E : Exception do
    begin
      stbMain.Panels[2].Text :='Error in OpenIrbfile (' + e.ClassName  + ' ' + e.Message + ')';
    end;
  end;
end;

function TfrmTestLib.CloseIrbFile: Boolean;
begin
  try
    //imgIRFrame.Picture.Bitmap.Width := 0;
    //imgIRFrame.Picture.Bitmap.Width := 0;
    stgProps.Cells[1, 0] := '';
    stgProps.Cells[1, 1] := '';
    stgProps.Cells[1, 2] := '';
    stgProps.Cells[1, 3] := '';
    stgProps.Cells[1, 4] := '';
    stgProps.Cells[1, 5] := '';
    stgProps.Cells[1, 6] := '';
    stgProps.Cells[1, 7] := '';
    stgProps.Cells[1, 8] := '';
    stgProps.Cells[1, 9] := '';
    stgProps.Cells[1,10] := '';
    stgProps.Cells[1,11] := '';
    lblTBB.Caption  := '...';
    lblT.Caption := '...';
    {
    if Assigned(FPixelData) then
    begin
      FreeMem(FPixelData);
      FPixelData := nil;
    end;  }
    _irbacs64_unloadIRB( FIrbacsHnd );
    FIrbacsHnd := 0;


    StatBar( 1, 'empty' );

    FIrbacsHnd := 0;
    spinX.Enabled := False;
    spinX.Text := '0';
    spinY.Enabled := False;
    spinY.Text := '0';
    SpinFrameNb.Text := '0';
    SpinFrameNb.Enabled := False;

    Result := True;
  except
    on E : Exception do
    begin
      Result := False;
      stbMain.Panels[2].Text :='Error in CloseIrbFile (' + e.ClassName  + ' ' + e.Message + ')';
    end;
  end;
end;

// Calculate Min/Max
procedure TfrmTestLib.CalculateMinMax;
var
  x, y, dsize        : Integer;
  fValue,aMin,aMax   : Single;
  pTemperatures, pDb : pDouble;
begin
  try
    dsize := _irbacs64_readPixelData( FIrbacsHnd, nil, Ord(pvTemp) );
    Getmem( pTemperatures, dsize );
    if _irbacs64_readPixelData( FIrbacsHnd, pTemperatures, Ord(pvTemp) ) = 0 then
    begin
      ShowMessage( 'Unable to read temperature values of frame.');
      Exit;
    end;

    if not _irbacs64_getParam( FIrbacsHnd, Ord( pavWidth ), fValue ) then
      exit;
    FFrameWidth := Round( fValue );

    if not _irbacs64_getParam( FIrbacsHnd, Ord( pavHeight ), fValue ) then
      exit;
    FFrameHeight := Round( fValue );

    aMin := pTemperatures^;
    aMax := pTemperatures^;
    pDb := pTemperatures;

    for y:=0 to FFrameHeight -1 do
    begin
      for x:=0 to FFrameWidth-1 do
      begin
         //fValue := PDouble( Integer(pTemperatures) + ( y*FFrameHeight + x) * sizeof( Double ))^;
         if pDb^ < aMin then aMin := pDb^;
         if pDb^ > aMax then aMax := pDb^;
         inc( pDb );
      end;
    end;

    lblMin.Caption := FormatFloat('0.00', aMin);
    lblMax.Caption := FormatFloat('0.00', aMax);

    Freemem( pTemperatures );
  except
    on E : Exception do
    begin
      StatBar( 2, 'Error in CalculateMinMax (' + e.ClassName  + ' ' + e.Message + ')');
    end;
  end;
end;

procedure TfrmTestLib.ShowIrbBmp;
var
  x,y           : Integer;
  pixFromB      : PByte;
  pixFromW      : PWord;
  pixFromS      : PSingle;
  MinVal,MaxVal : Single;
  aBmp          : TBitmap;
  iW,iH         : Integer;
  aIrbData      : PByte;
  PixVal        : Integer;
  coeff         : Single;
  iPixelSize    : Integer;
  fValue        : Single;
  pxlDat        : Pointer;
  dataver, pxf  : Single;

  aStM : TMemoryStream;
begin
  try
    pxldat := nil;
    iPixelSize := _irbacs64_readIRBDataUncompressed( FIrbacsHnd, nil );
    Getmem( pxldat, iPixelSize);                           // get memory pixeldata
    iPixelSize := _irbacs64_readIRBDataUncompressed( FIrbacsHnd, pxldat );       // read pixeldata >>> 3 data types possible Byte, Word and Single

    aIrbData := pxldat;

    if not _irbacs64_getParam( FIrbacsHnd, Ord( pavDataVersion ), dataver ) then
      exit;
    case Round(dataver) of
      101: Inc( aIrbData, 1728 ); //cIRBImageHeaderSize101 );
      else Inc( aIrbData, 644 ); //cIRBImageData );
    end;
    _irbacs64_getParam( FIrbacsHnd, Ord( pavWidth ), fValue );
    iW := Round( fValue );
    _irbacs64_getParam( FIrbacsHnd, Ord( pavHeight ), fValue );
    iH := Round( fValue );

    aBmp := TBitmap.Create;
    try
      aBmp.PixelFormat := pf32Bit;
      aBmp.SetSize( iW, iH );
      //aBmp.BeginUpdate;

      _irbacs64_getParam( FIrbacsHnd, Ord( pavPixelFormat ), pxf );
      //tlbAudio.Enabled := AudioComment( FIrbacsHnd,0 );

      case Round(pxf) of
        1:  // Byte
        begin
          pixFromB := PByte(aIrbData);
          SearchMinMaxByte(pixFromB, iW*iH, MinVal, MaxVal);
          coeff :=  IfThen( MinVal <> MaxVal, Abs( 256 / (maxVal-minVal) ), 0 );
          for y:=0 to aBmp.Height-1 do
          begin
            //pixTo := Bmp.ScanLine[y];
            for x:=0 to aBmp.Width-1 do
            begin
              pixVal := trunc((pixFromB^ - minVal ) * coeff);
              aBmp.Canvas.Pixels[x, y] := x; //((pixVal shl 16) + (pixVal shl 8) + pixVal) and $00ffffff;
              //pixTo^ := ((pixVal shl 16) + (pixVal shl 8) + pixVal) and $00ffffff;
              Inc(pixFromB);
              //Inc(pixTo);
            end;
          end;
        end;

        2: // Word
        begin
          pixFromW := PWord(aIrbData);
          SearchMinMaxWord(pixFromW, iW*iH, MinVal, MaxVal);
          coeff :=  IfThen( MinVal <> MaxVal, Abs( 256 / (maxVal-minVal) ), 0 );
          for y := 0 to aBmp.Height-1 do
          begin
            //pixTo := Bmp.ScanLine[y];
            for x := 0 to aBmp.Width-1 do
            begin
              pixVal := trunc((pixFromW^ - minVal ) * coeff); // * $010101;
              aBmp.Canvas.Pixels[x, y] := ((pixVal shl 16) + (pixVal shl 8) + pixVal) and $00ffffff;
              //imgIRB.Canvas.Pixels[x, y] := pixval; //((pixVal shl 16) + (pixVal shl 8) + pixVal) and $01ffffff;
              //pixTo^ := ((pixVal shl 16) + (pixVal shl 8) + pixVal) and $00ffffff;
              Inc(pixFromW);
              //Inc(pixTo);
            end;
          end;
        end;

        $F084:  // Single
        begin
          pixFromS := PSingle(aIrbData);
          SearchMinMaxSingle(pixFromS, iW*iH, MinVal, MaxVal);
          coeff :=  IfThen( MinVal <> MaxVal, Abs( 256 / (maxVal-minVal) ), 0 );
          for y:=0 to aBmp.Height-1 do
          begin
            //pixTo := Bmp.ScanLine[y];
            for x:=0 to aBmp.Width-1 do
            begin
              pixVal := trunc((pixFromS^ - minVal ) * coeff);
              aBmp.Canvas.Pixels[x, y] := ((pixVal shl 16) + (pixVal shl 8) + pixVal) and $00ffffff;
              //pixTo^ := ((pixVal shl 16) + (pixVal shl 8) + pixVal) and $00ffffff;
              Inc(pixFromS);
              //Inc(pixTo);
            end;
          end;
        end;

        else
          showmessage('Unknown IRB-PixelFormat!')
      end;
      //CalculateMinMax;
      //aBmp.EndUpdate;
      aStM := TMemoryStream.Create;
      aBmp.SaveToStream( aStM );
      aStM.Position:= 0;
      imgIRB.Picture.LoadFromStream(  aStM );
      aStM.Free;
    finally
      if Assigned( aBmp ) then
        aBmp.Free;
    end;
    Freemem( pxldat );
  except
    on E : Exception do
    begin
      //addlog( 'Error in ShowIrbBmp (' + e.ClassName  + ' ' + e.Message + ')', cst_Exception );
    end;
  end;
end;

procedure TfrmTestLib.SearchMinMaxByte(pData: PByte; iDataSize: Integer;
  var Min, Max: Single);
var
  aPB,aPBFin :PByte;
  cnt : Integer;
begin
  try
    aPB    := pData;
    aPBFin := aPB;
    Inc(aPBFin, iDataSize);
    Min := aPB^;
    Max := Min;

    // Min und Max suchen
    cnt := 0;
    while cnt < iDataSize do //LongWord(aPB) < LongWord(aPBFin) do
    begin
      if aPB^ < Min then Min:= aPB^
      else
        if aPB^ > Max then Max:= aPB^;
      Inc( aPB );
      Inc( cnt );
    end;
  except
    on E : Exception do
    begin
      StatBar( 2, 'Error in SearchMinMaxByte (' + e.ClassName  + ' ' + e.Message + ')');
    end;
  end;
end;

procedure TfrmTestLib.SearchMinMaxWord(pData: PWord; iDataSize: Integer;
  var Min, Max: Single);
var
  aPW,aPWFin :PWord;
  cnt : Integer;
begin
  try
    aPW    := pData;
    aPWFin := aPW;
    Inc(aPWFin, iDataSize);
    Min := aPW^;
    Max := Min;

    // Min und Max suchen
    cnt := 0;
    while cnt < iDataSize do //LongWord(aPW) < LongWord(aPWFin) do
    begin
      if aPW^ < Min then Min:= aPW^ else if aPW^ > Max then Max:= aPW^;
      Inc( aPW );
      Inc( cnt );
    end;
  except
    on E : Exception do
    begin
      stbMain.Panels[2].Text :='Error in SearchMinMaxWord (' + e.ClassName  + ' ' + e.Message + ')';
    end;
  end;
end;

procedure TfrmTestLib.SearchMinMaxSingle(pData: PSingle; iDataSize: Integer;
  var Min, Max: Single);
var
  aPS,aPSFin :PSingle;
  cnt : Integer;
begin
  try
    aPS    := pData;
    aPSFin := aPS;
    Inc(aPSFin, iDataSize);
    Min := aPS^;
    Max := Min;

    // Min und Max suchen
    cnt := 0;
    while cnt < iDataSize do //LongWord(aPS) < LongWord(aPSFin) do
    begin
      if aPS^ < Min then Min:= aPS^
      else
        if aPS^ > Max then Max:= aPS^;
      Inc( aPS );
      Inc( cnt );
    end;
  except
    on E : Exception do
    begin
      stbMain.Panels[2].Text :='Error in SearchMinMaxSingle (' + e.ClassName  + ' ' + e.Message + ')';
    end;
  end;
end;

  {Function SafeLoadLibrary(Name : AnsiString) : TLibHandle;
Function LoadLibrary(Name : AnsiString) : TLibHandle;
Function GetProcedureAddress(Lib : TlibHandle; ProcName : AnsiString) : Pointer;
Function UnloadLibrary(Lib : TLibHandle) : Boolean;

SafeLoadLibrary is the same as LoadLibrary but it also disables arithmetic exceptions
which some libraries expect to be off on loading.

Pseudocode of the usage:


var
  MyLibC: TLibHandle;
  MyProc: TMyProc;
begin
  MyLibC := LoadLibrary('libc.' + SharedSuffix);
  if MyLibC = 0 then Exit;
  MyProc := TMyProc(GetProcedureAddress(MyLibC, 'getpt');
  if MyProc = nil then Exit;
end;    }

end.

