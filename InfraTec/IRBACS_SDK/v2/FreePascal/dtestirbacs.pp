unit dTestIrbAcs;

{$mode objfpc}{$H+}

interface


uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls, Grids, StdCtrls, Spin;

type
  TCorrPars = packed record
    epsilon   : Double;
    envTemp   : Double;
    tau       : Double;
    pathTemp  : Double;
    lambda    : Double;
    deltaLambda : Double;
  end;

  TDynArrayOfDouble = array of Double ;
  PDynArrayOfDouble = ^TDynArrayOfDouble ;

  { TfrmTestLib }
  TfrmTestLib = class(TForm)
    gbxData: TGroupBox;
    imgIRB: TImage;
    imlMain: TImageList;
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
    lblMax: TLabel;
    lblMin: TLabel;
    lblT: TLabel;
    lblTBB: TLabel;
    mmoP2K: TMemo;
    opDlgIrb: TOpenDialog;
    pnlImage: TPanel;
    stgProps: TStringGrid;
    svdSaveAudio: TSaveDialog;
    svdVisImg: TSaveDialog;
    svdSaveChangedIRB: TSaveDialog;
    SpinFrameNb: TSpinEdit;
    spinX: TSpinEdit;
    spinY: TSpinEdit;
    stbMain: TStatusBar;
    stgADVals: TStringGrid;
    tbnAudio: TToolButton;
    tbnSaveIRB: TToolButton;
    tbnOpen: TToolButton;
    tbnP2K: TToolButton;
    tbnTest: TToolButton;
    tbnVis: TToolButton;
    tlbMain: TToolBar;
    ToolButton1: TToolButton;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpinFrameNbChange(Sender: TObject);
    procedure spinXYChange(Sender: TObject);
    procedure tbnAudioClick(Sender: TObject);
    procedure tbnSaveIRBClick(Sender: TObject);
    procedure tbnTestClick(Sender: TObject);
    procedure tbnOpenClick(Sender: TObject);
    procedure tbnVisClick(Sender: TObject);
    procedure tbnP2KClick(Sender: TObject);
  private
    { private declarations }
    FFileName : String;
    FIrbacsHnd : PtrUint;
    FFrameWidth : Integer;
    FFrameHeight : Integer;
    FBlockrecursiveSpinNb : Boolean;
    FBlockRecursiveSpinXY : Boolean;
    procedure AddLine(value: String);
    procedure CalculateMinMax;
    function ConvertPixelToKelvin: integer ;
    function CloseIrbFile: Boolean;
    procedure FillIRBPropTable(ihnd: PtrUInt);
    function OpenIrbfile: Boolean;
    procedure ShowIrbBmp;
    procedure SearchMinMaxByte( const pData :Pointer; const iDataSize :Integer; var Min,Max :Single);
    procedure SearchMinMaxWord( const pData :Pointer; const iDataSize :Integer; var Min,Max :Single);
    procedure SearchMinMaxSingle( const pData :Pointer; const iDataSize :Integer; var Min,Max :Single);
    procedure TestConvertAndManipulate ;

    procedure StatBar(indx: Integer; value: String);
  public
    { public declarations }
  end; 

var
  frmTestLib: TfrmTestLib;

implementation

{$R *.lfm}

uses
  ldirbacs2, Math, strUtils;

type
  PWord = ^Word;

{ TfrmTestLib }

procedure TfrmTestLib.StatBar( indx : Integer; value : String );
begin
  stbMain.Panels[indx].Text := Value;
end;


procedure TfrmTestLib.tbnTestClick(Sender: TObject);
var
  ver1, ver2 : Integer;
begin
  if InitIRBACSLibrary then
  begin
    StatBar( 0, IRBACSDLLName + ' ok.' );
    ver1 := 0 ;
    ver2 := 0 ;
    if _irbacs_version( ver1, ver2 ) then
    begin
      StatBar( 2, 'Version: ' + IntToStr(ver1)+'.'+IntToStr(ver2));
    end;
    FreeIRBACSLibrary;
  end
  else
    StatBar( 0, 'Load ' + IRBACSDLLName + ' failed.' );

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
  stgProps.Cells[0, 7] := 'old Timestamp';
  stgProps.Cells[0, 8] := 'MilliSeconds';
  stgProps.Cells[0, 9] := 'Timestamp';
  stgProps.Cells[0, 10] := 'Camera';
  stgProps.Cells[0, 11]:= 'Serial Nb.';
  stgProps.Cells[0, 12]:= 'Lens';
  stgProps.Cells[0, 13]:= 'CalibRange';

  stgADVals.Cells[0, 0] := 'TSens';
  stgADVals.Cells[0, 1] := 'AD1';
  stgADVals.Cells[0, 2] := 'Dig';
end;

procedure TfrmTestLib.FormCreate(Sender: TObject);
begin
  StatBar( 1, 'No irb-file loaded.' );
  FBlockrecursiveSpinNb := False;
  FBlockRecursiveSpinXY := False;
  FIrbacsHnd := 0;
  tbnSaveIRB.Enabled := false ;
  tbnVis.Enabled := false;
  tbnAudio.Enabled := false;
  tbnP2K.Enabled:=false;
  self.width := self.Constraints.MinWidth ;
end;

procedure TfrmTestLib.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree ;
  CloseIrbFile ;
  FreeIRBACSLibrary ;
end;

procedure TfrmTestLib.FillIRBPropTable( ihnd : PtrUInt );
var
  fValue, fMinValue : Double;
  sparam : array[0..255] of AnsiChar;
  timeStamp : TSystemTime=(  wYear:0; wMonth:0; wDayOfWeek:0; wDay:0; wHour:0; wMinute:0; wSecond:0; wMilliseconds:0 ) ;

begin
  fValue := 0.0 ;
  _irbacs_getParam( ihnd, Ord( pavWidth ), fValue );
  FFrameWidth := Round( fValue );
  stgProps.Cells[1, 0] := IntToStr( Round( fValue ) );
  spinX.MinValue := 0;
  spinX.MaxValue := round( fValue )-1;
  spinX.Text := FormatFloat( '0', fValue / 2 );

  _irbacs_getParam( ihnd, Ord( pavHeight ), fValue );
  FFrameHeight := Round( fValue );
  stgProps.Cells[1, 1] := IntToStr( Round( fValue ) );
  spinY.MinValue := 0;
  spinY.MaxValue := round( fValue )-1;
  spinY.Text := FormatFloat( '0', fValue / 2 );

  spinX.Enabled := True;
  spinY.Enabled := True;

  if _irbacs_getParam( ihnd, Ord( pavEpsilon ), fValue ) then
    stgProps.Cells[1, 2] := FormatFloat( '0.000',  RoundTo( fValue, -3 ) )
  else
    stgProps.Cells[1, 2] := '---';

  if _irbacs_getParam( ihnd, Ord( pavEnvTemp ), fValue ) then
    stgProps.Cells[1, 3] := FormatFloat( '0.00 °C', RoundTo( fValue -273.15, -2 ) )
  else
    stgProps.Cells[1, 3] := '---';

  if _irbacs_getParam( ihnd, Ord( pavAbsorption ), fValue ) then
    stgProps.Cells[1, 4] := FormatFloat( '0.000',  RoundTo( fValue, -3 ) )
  else
    stgProps.Cells[1, 4] := '---';

  if _irbacs_getParam( ihnd, Ord( pavDistance ), fValue ) then
    stgProps.Cells[1, 5] := FormatFloat( '0.00 m',  RoundTo( fValue, -2 ) )
  else
    stgProps.Cells[1, 5] := '---';

  if _irbacs_getParam( ihnd, Ord( pavPathTemp ), fValue ) then
    stgProps.Cells[1, 6] := FormatFloat( '0.00 °C', RoundTo( fValue - 273.15, -2 )  )
  else
    stgProps.Cells[1, 6] := '---';

  // obsolate, -  only for compatibility here
  if _irbacs_getParam( ihnd, Ord( pavTimeStamp ), fValue ) then
    stgProps.Cells[1, 7] := FormatDateTime( 'dd.mm.yy hh:nn:ss.nnn',  fValue )
  else
    stgProps.Cells[1, 7] := '---';

  if _irbacs_getParam( ihnd, Ord( pavMilliTime ), fValue ) then
    stgProps.Cells[1, 8] := FormatFloat( '0.00',  RoundTo( fValue, -2 ) )
  else
    stgProps.Cells[1, 8] := '---';

  if _irbacs_getParam( ihnd, Ord( pavCalibMin ), fMinValue ) then
  begin
    if _irbacs_getParam( ihnd, Ord( pavCalibMax ), fValue ) then
      stgProps.Cells[1, 13] := FormatFloat( '0', fMinValue-273.15 ) + ' .. ' + FormatFloat( '0 °C', fValue-273.15 );
  end;

  if _irbacs_getFrameTimeStamp( FIrbacsHnd, timeStamp ) then
  begin
    stgProps.Cells[1, 9] := FormatFloat( '00', timeStamp.wDay ) + '.' + FormatFloat( '00', timeStamp.wMonth ) + '.' + FormatFloat( '00', timeStamp.wYear )
                             + ' ' + FormatFloat( '00', timeStamp.wHour )+ ':' + FormatFloat( '00', timeStamp.wMinute )+ ':' + FormatFloat( '00', timeStamp.wSecond )
                             + ',' + FormatFloat( '000', timeStamp.wMilliseconds ) ;
  end ;
  _irbacs_getParamS( ihnd, Ord( pavKamera ), sparam );
  stgProps.Cells[1, 10] := StrPas( sparam );
  _irbacs_getParamS( ihnd, Ord( pavKameraSNr ), sparam );
  stgProps.Cells[1, 11] := StrPas( sparam );
  _irbacs_getParamS( ihnd, Ord( pavLens ), sparam );
  stgProps.Cells[1, 12] := StrPas( sparam );

  if _irbacs_getParam( ihnd, Ord( pavSensorTemp ), fValue ) then
    stgADVals.Cells[1, 0] := FormatFloat( '0.###',  RoundTo( fValue, -3 ) )
  else
    stgADVals.Cells[1, 0] := '---';

  if _irbacs_getParam( ihnd, Ord( pavAD1 ), fValue ) then
    stgADVals.Cells[1, 1] := FormatFloat( '0.###',  RoundTo( fValue, -3 ) )
  else
    stgADVals.Cells[1, 1] := '---';

  if _irbacs_getParam( ihnd, Ord( pavDigVals ), fValue ) then
    stgADVals.Cells[1, 2] := FormatFloat( '0', fValue )
  else
    stgADVals.Cells[1, 2] := '---';

  if tbnP2K.Down then
    TestConvertAndManipulate ;
end;

procedure TfrmTestLib.SpinFrameNbChange(Sender: TObject);
var
  ii : Integer;
begin
  //if not Assigned( FPixelData ) then Exit;
  if FBlockrecursiveSpinNb or (FIrbacsHnd=0) then
    exit;
  try
    FblockrecursiveSpinNb := True;
    try
      if not TryStrToInt( SpinFrameNb.Text, ii ) then Exit;
      if ( ii >= 0 ) and ( ii <= _irbacs_getFrameCount( FIrbacsHnd )-1 ) then
        _irbacs_setFrameNbByArrayIdx( FIrbacsHnd, ii ) // jump to framenumber in a sequence
      else
        SpinFrameNb.Text := IntToStr( _irbacs_getFrameNbByArrayIdx( FIrbacsHnd ) );

      FillIRBPropTable( FIrbacsHnd );
      ShowIrbBmp;
      spinXYChange(nil) ;
    finally
      FblockrecursiveSpinNb := False;
    end;
  except
    on E : Exception do
    begin
      StatBar( 2, 'Error in SpinFrameNbChange (' + e.ClassName  + ' ' + e.Message + ')' );
    end;
  end;

end;


procedure TfrmTestLib.spinXYChange(Sender: TObject);
var
  xval, yval : Integer;
begin
  if (Length( spinX.Text ) = 0) or (Length( spinY.Text ) = 0 ) then Exit;

  try
    if FblockRecursiveSpinXY or (FIrbacsHnd=0) then Exit;
    try
      FblockRecursiveSpinXY := True;
      // SpinEdit in D7 does not limit the values reliably
      xVal := Max( Min( spinX.Value, spinX.MaxValue), 0 );
      yVal := Max( Min( spinY.Value, spinY.MaxValue), 0 );
      spinX.Value := xVal; // Write back corrected value
      spinY.Value := yVal;
      lblTBB.Caption := FormatFloat( '0.##', _irbacs_getTempBBXY( FIrbacsHnd, xVal, yVal ) );
      lblT.Caption := FormatFloat( '0.##', _irbacs_getTempXY( FIrbacsHnd, xVal, yVal ) );
      if tbnP2K.Down then
         TestConvertAndManipulate ;
    finally
      FblockRecursiveSpinXY := False;
    end;

  except
    on E : Exception do
    begin
      StatBar( 2, 'Error in spinXYChange (' + e.ClassName  + ' ' + e.Message + ')' );
    end;
  end;
end;


procedure TfrmTestLib.tbnSaveIRBClick(Sender: TObject);
var
  caldata : TIRBCalibData;
  irbhdr101 : TIRBImageData1;
begin
  // Example, how to get IRB-Version and how to get, manipulate and save header of IRB frames
  _irbacs_getIRBCalibData( FIrbAcsHnd, @caldata );
  StatBar( 2, IntToStr( caldata.Version ));
  if _irbacs_getIRBHeader( FIrbAcsHnd, @irbhdr101 ) then
  begin
    irbhdr101.objectPars.emissivity:= irbhdr101.objectPars.emissivity - 0.01;
    _irbacs_SetIRBHeader( FIrbAcsHnd, @irbhdr101 );
  end
  else
  begin
     StatBar( 2, 'getIRBHeader failed' );
     exit;
  end;
  if svdSaveChangedIRB.Execute then
  begin
    if _irbacs_saveSingleFrame( FIrbAcsHnd, PChar( svdSaveChangedIRB.FileName ), nil )  then
      StatBar( 2, 'IRB-frame saved: ' + svdSaveChangedIRB.FileName )
    else
      StatBar( 2, 'saveSingleframe failed' );
  end;
end;


function TfrmTestLib.ConvertPixelToKelvin : integer ;
var
  ii, iPixelSize : Integer;
  kelvdat : Pointer;
  pDoub : PDouble;
  corrpars : TCorrPars;
begin
  Result := 0 ;
  try
    iPixelSize := _irbacs_readPixelData( FIrbacsHnd, nil, cReadPixelData_RawValues_Double );     //  Determine needed memory size
    Getmem( kelvdat, iPixelSize );
    iPixelSize := _irbacs_readPixelData( FIrbacsHnd, kelvdat, cReadPixelData_RawValues_Double ); // get raw values

    // example how to get corrected temperature from raw values ( im Double-Format )
    pDoub := PDouble( kelvdat );
    For ii := 0 to iPixelsize div 8 -1 do  // Double = 8 byte
    Begin
      pDoub^ := pDoub^ - 10;
      Inc( pDoub);
    end;

    Corrpars.epsilon    := 0.95;
    Corrpars.envtemp    := 293.15; // in K
    Corrpars.tau        := 0.8;
    Corrpars.pathtemp   := 283.15; // in K
    Corrpars.lambda             := 0;  // Nutzung des Standardwertes
    Corrpars.deltaLambda    := 0;  // Nutzung des Standardwertes

    Result := _irbacs_convertPixelToKelvin( FIrbacsHnd, kelvdat, iPixelSize, @corrpars );

  except
    on E : Exception do
    begin
      StatBar( 2, 'Error inconvertPixelToKelvin (' + e.ClassName  + ' ' + e.Message + ')' );
    end;
  end;
end;


procedure TfrmTestLib.tbnOpenClick(Sender: TObject);
begin
   try
     CloseIrbFile;
     OpenIrbfile ;
  except
    on E : Exception do
    begin
      StatBar( 2, 'Error in tbnOpenClick (' + e.ClassName  + ' ' + e.Message + ')' );
    end;
  end;
end;


procedure TfrmTestLib.tbnVisClick(Sender: TObject);
begin
  if svdVisImg.Execute then
  begin
    // Enter only filename, file extension will change automatically according to the file type (e.g. to filename.jpg)
    // if there is no visual image for the actual frame, then the function returns false
    if _irbacs_exportVisBitmap( FIrbacsHnd, PChar( svdVisImg.FileName ) ) then
      StatBar( 2, 'Visual image saved : svdVisImg.FileName' + svdVisImg.FileName )
    else
      StatBar( 2, 'There is no visual frame.' );
  end;
end;

procedure TfrmTestLib.tbnAudioClick(Sender: TObject);
begin
  if svdSaveAudio.Execute then
  begin
    // Enter only filename, file extension will change automatically according to the file type (e.g. to filename.jpg)
    // if there is no audio comment for the actual frame, then the function returns false
    if _irbacs_audioComment( FIrbacsHnd, PChar( svdSaveAudio.FileName ) ) then
      StatBar( 2, 'Audio comment saved.' + svdSaveAudio.FileName )
    else
      StatBar( 2, 'There is no audio comment.' ) ;
  end ;
end;


procedure TfrmTestLib.AddLine( value: String );
begin
  mmoP2K.Lines.Add( value );
end;


procedure  TfrmTestLib.TestConvertAndManipulate ;
var
  DataBuffer : TDynArrayOfDouble ;
  pDataBuffer, pElement : PDouble;
  spalte, zeile : Integer;
  sz, pixCnt : integer ;
  allLines : double ;
  XYStr : String;

begin
  try
    // depending on camera type frames can have some lines more than the usable framesize
    // so either ask for real count of lines this way way
   allLines := 0.0 ;
    _irbacs_getParam( FIrbacsHnd, ord( pavHeightWithHdr ), allLines ) ;
    sz := FFrameWidth * round( allLines ) * sizeOf( Double ) ;
    // or call readPixelData with nil to determine needed buffer size
    sz := _irbacs_readPixelData( FIrbacsHnd, nil, cReadPixelData_Temp_Double ) ;
    pixCnt := FFrameWidth * FFrameHeight ;  // usable framesize
    setLength( DataBuffer, round( allLines ) * FFrameWidth ) ; // allocate buffer for framesize + camera specific header data
    spalte := spinx.Value;
    zeile  := spiny.Value;
    XYStr := IntToStr(spalte)+'/'+ IntToStr(zeile) ;
    pDataBuffer := @DataBuffer[0];
    pElement := @DataBuffer[ zeile * FFrameWidth + spalte ] ;
    mmoP2K.Clear;

    AddLine( 'Convert pixel to kelvin              : ' + ifthen( ConvertPixelToKelvin = pixCnt , 'ok', 'failed') );

    AddLine( ' ' );
    AddLine( 'Read array as temperature value  : ' + ifthen( _irbacs_readPixelData( FIrbacsHnd, pDataBuffer, cReadPixelData_Temp_Double ) = sz, 'ok', 'failed') );
    AddLine( 'Temp value at '+XYStr+' is          : ' + FormatFloat( '0.000',  pElement^ ) );

    AddLine( ' ' );
    AddLine( 'Read array as raw Data            : ' + ifthen( _irbacs_readPixelData( FIrbacsHnd, pDataBuffer, cReadPixelData_RawValues_Double ) = sz, 'ok', 'failed') );
    AddLine( 'Raw  value at '+XYStr+' is          : ' + FormatFloat( '0.000', pElement^ ) );
    AddLine( 'Convert array to temperatures     : ' + ifthen( _irbacs_convertPixelToKelvin( FIrbacsHnd, pDataBuffer, sz, nil ) = pixCnt , 'ok', 'failed') );
    AddLine( 'Temp value at '+XYStr+' is          : ' + FormatFloat( '0.000', pElement^ ) );
    AddLine( ' ' );

    AddLine( 'Read array as raw data            : ' +  ifthen( _irbacs_readPixelData( FIrbacsHnd, pDataBuffer, cReadPixelData_RawValues_Double ) = sz, 'ok', 'failed') );
    AddLine( 'Manipulate raw value with +126.0' );
    pElement^ := pElement^ + 126.0;
    AddLine( 'Raw  value at '+XYStr+' is          : ' + FormatFloat( '0.000', pElement^ ) );
    AddLine( 'Convert array to temperatures     : ' +  ifthen( _irbacs_convertPixelToKelvin( FIrbacsHnd, pDataBuffer, sz, nil ) = pixCnt, 'ok', 'failed') );
    AddLine( 'Temp value at '+XYStr+' is          : ' + FormatFloat( '0.000', pElement^ ) );
    AddLine( ' ' );

    AddLine( 'Read array as raw data            : ' +  ifthen( _irbacs_readPixelData( FIrbacsHnd, pDataBuffer, cReadPixelData_RawValues_Double ) = sz, 'ok', 'failed') );
    AddLine( 'Manipulate raw value with +127.0' );
    pElement^ := pElement^ +127.0;
    AddLine( 'Raw  value at '+XYStr+' is          : ' + FormatFloat( '0.000', pElement^ ) );
    AddLine( 'Convert array to temperatures     : ' +  ifthen( _irbacs_convertPixelToKelvin( FIrbacsHnd, pDataBuffer, sz, nil ) = pixCnt, 'ok', 'failed') );
    AddLine( 'Temp value at '+XYStr+' is          : ' + FormatFloat( '0.000', pElement^ ) );
    AddLine( ' ' );

    AddLine( 'Read array as raw data            : ' +  ifthen( _irbacs_readPixelData( FIrbacsHnd, pDataBuffer, cReadPixelData_RawValues_Double ) = sz, 'ok', 'failed') );
    AddLine( 'Manipulate raw value with +0.1 ' );
    pElement^ := pElement^ + 0.1;
    AddLine( 'Raw  value at '+XYStr+' is          : ' + FormatFloat( '0.000', pElement^ ) );
    AddLine( 'Convert array to temperatures     : ' + ifthen( _irbacs_convertPixelToKelvin( FIrbacsHnd, pDataBuffer, sz, nil ) = pixCnt, 'ok', 'failed') );
    AddLine( 'Temp value at '+XYStr+' is          : ' + FormatFloat( '0.000', pElement^ ) );
    AddLine( ' ' );

    setLength( DataBuffer, 0 ) ;

  except
    on E : Exception do
    begin
      StatBar( 2, 'Error in TestConvertAndManipulate (' + e.ClassName  + ' ' + e.Message + ')' );
    end;
  end;
end ;


procedure TfrmTestLib.tbnP2KClick(Sender: TObject);
begin
  if tbnP2K.Down then
  begin
     TestConvertAndManipulate ;
     self.width := self.width + 268 ;
  end
  else
  begin
    self.width := self.width - 268 ;
  end;
  mmoP2K.Visible := tbnP2K.Down ;
end;



function TfrmTestLib.OpenIrbfile: Boolean;
var
  countOfFrameIndexes: Integer;
  filename : array[0..255] of AnsiChar;
  indxarr : TBoundArray;
begin
  Result := False;

  if not InitIRBACSLibrary then
    exit;
  try
    StatBar( 0, IRBACSDLLName + ' loaded.' );
    if not opDlgIrb.Execute then Exit ;
    FFileName := opDlgIrb.FileName;
    if length( FFilename ) = 0 then Exit ;
    StrPCopy(filename, FFileName );

    FIrbacsHnd := _irbacs_loadIRB( filename );              // load IRB-file with its name
    if FIrbacsHnd = 0 then
    begin
      StatBar( 1, 'Loading IRB-file failed.');
      exit;
    end;
    StatBar( 1, ExtractFileNameOnly( filename ) );
    tbnSaveIRB.Enabled := true ;
    tbnVis.Enabled := true ;
    tbnAudio.Enabled := true ;
    tbnP2K.Enabled:=true;

    countOfFrameIndexes := _irbacs_getFrameCount( FIrbacsHnd );
    if countOfFrameIndexes < 1 then
    begin
      StatBar( 1, 'No frame found in IRB-file ' + FFileName );
      exit;
    end
    else
    begin
      StatBar( 1, IntToStr( countOfFrameIndexes ) + ' frames.' );
    end;
    // choosing frame by internal IRB-Index
    countOfFrameIndexes := _irbacs_getIRBIndices( FIrbAcsHnd, PInteger( 0 ) );
    if countOfFrameIndexes > 0 then
      SetLength( indxarr, countOfFrameIndexes );
    countOfFrameIndexes := _irbacs_getIRBIndices( FIrbAcsHnd, PInteger( @indxarr[0] ) );
    if Length( indxarr ) > 0 then
    begin
      _irbacs_setFrameNumber(  FIrbacsHnd, indxarr[0] ); // jump to the first frame by setFrameNumber with the first IRB index
      StatBar( 2, ' 1. frame has IRB index ' + IntToStr( _irbacs_getFrameNumber( FIrbacsHnd ) )  );

      // example for doing the same by taking 0 as a ascending array index
      _irbacs_setFrameNbByArrayIdx( FIrbacsHnd, 0 );   // jump to first frame in the sequence
      SpinFrameNb.Enabled := True;
      SpinFrameNb.MinValue := 0;
      SpinFrameNb.MaxValue := countOfFrameIndexes- 1;
      SpinFrameNb.Text := '0';

      FillIRBPropTable( FIrbAcsHnd );
      CalculateMinMax;
      ShowIrbBmp;
      SpinFrameNbChange(nil) ;
    end ;
    Result := True;
  except
    on E : Exception do
    begin
     Result := False ;
     StatBar( 1, 'Error in OpenIrbfile (' + e.ClassName  + ' ' + e.Message + ')' );
    end;
  end;
end;

function TfrmTestLib.CloseIrbFile: Boolean;
var
   ii : integer ;
begin
  try
    spinX.Text := '0';
    spinY.Enabled := False;
    spinY.Text := '0';
    SpinFrameNb.Text := '0';

    for ii := 0 to 13 do
      stgProps.Cells[1, ii] := '';
    for ii := 0 to 2 do
        stgADVals.Cells[1,ii] := '' ;
    lblTBB.Caption  := '...';
    lblT.Caption := '...';
    lblMax.Caption := '...' ;
    lblMin.Caption := '...' ;
    imgIRB.Canvas.Clear ;
    if FIrbacsHnd > 0 then
      _irbacs_unloadIRB( FIrbacsHnd );
    FIrbacsHnd := 0;

    tbnSaveIRB.Enabled := false ;
    tbnVis.Enabled := false ;
    tbnAudio.Enabled := false ;
    tbnP2K.Enabled:= false ;
    spinX.Enabled := False;
    SpinFrameNb.Enabled := False;

    StatBar( 1, 'No irb-file loaded.' );
    Result := True;
  except
    on E : Exception do
    begin
      Result := False;
      StatBar( 1, 'Error in CloseIrbFile (' + e.ClassName  + ' ' + e.Message + ')' );
    end;
  end;
end;

// Calculate Min/Max
procedure TfrmTestLib.CalculateMinMax;
var
  x, y, dsize        : Integer;
  fValue,aMin,aMax   : Double;
  pTemperatures, pDb : pDouble;
begin
  try
    dsize := _irbacs_readPixelData( FIrbacsHnd, nil, Ord(pvTemp) );
    Getmem( pTemperatures, dsize );
    if _irbacs_readPixelData( FIrbacsHnd, pTemperatures, Ord(pvTemp) ) = 0 then
    begin
      ShowMessage( 'Unable to read temperature values of frame.');
      Exit;
    end;
    fValue := 0 ;
    if not _irbacs_getParam( FIrbacsHnd, Ord( pavWidth ), fValue ) then
      exit;
    FFrameWidth := Round( fValue );

    if not _irbacs_getParam( FIrbacsHnd, Ord( pavHeight ), fValue ) then
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
  fValue        : Double;
  pxlDat        : Pointer;
  dataver, pxf  : Double;

  aMemStrm : TMemoryStream;
begin
  try
    pxldat := nil;
    MaxVal := 0.0 ;
    MinVal :=0.0 ;
    iPixelSize := _irbacs_readIRBDataUncompressed( FIrbacsHnd, nil );
    Getmem( pxldat, iPixelSize);                                               // alloc memory for pixeldata
    iPixelSize := _irbacs_readIRBDataUncompressed( FIrbacsHnd, pxldat );       // pixels can be one of following three types - Byte, Word or Single

    aIrbData := pxldat;
    dataver := 0.0 ;
    if not _irbacs_getParam( FIrbacsHnd, Ord( pavDataVersion ), dataver ) then
      exit;
    case Round(dataver) of
      101: Inc( aIrbData, 1728 ); //cIRBImageHeaderSize101 );
      else Inc( aIrbData, 644 ); //cIRBImageData );
    end;
    fvalue := 0.0 ;
    _irbacs_getParam( FIrbacsHnd, Ord( pavWidth ), fValue );
    iW := Round( fValue );
    _irbacs_getParam( FIrbacsHnd, Ord( pavHeight ), fValue );
    iH := Round( fValue );

    aBmp := TBitmap.Create;
    try
      aBmp.PixelFormat := pf32Bit;
      aBmp.SetSize( iW, iH );
      pxf := 0.0 ;
      _irbacs_getParam( FIrbacsHnd, Ord( pavPixelFormat ), pxf );              // get the type of pixel (Byte, Word or Single)
      case Round(pxf) of
        1:  // Byte
        begin
          pixFromB := PByte(aIrbData);
          SearchMinMaxByte(pixFromB, iW*iH, MinVal, MaxVal);
          coeff :=  IfThen( MinVal <> MaxVal, Abs( 256 / (maxVal-minVal) ), 0 );
          for y:=0 to aBmp.Height-1 do
          begin
            for x:=0 to aBmp.Width-1 do
            begin
              pixVal := trunc((pixFromB^ - minVal ) * coeff);
              aBmp.Canvas.Pixels[x, y] := x;
              Inc(pixFromB);
            end;
          end;
        end;

        2: // Word
        begin
          SearchMinMaxWord( aIrbData, iW*iH, MinVal, MaxVal);
          if maxval = minval then
            maxval := minval + 1;
          coeff :=  IfThen( MinVal <> MaxVal, Abs( 256 / (maxVal-minVal) ), 0 );

          pixFromW := PWord( aIrbData );
          for y := 0 to aBmp.Height-1 do
          begin
            for x := 0 to aBmp.Width-1 do
            begin
              pixVal := trunc((pixFromW^ - minVal ) * coeff);
              aBmp.Canvas.Pixels[x, y] := ((pixVal shl 16) + (pixVal shl 8) + pixVal) and $00ffffff;
              Inc(pixFromW);
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
            for x:=0 to aBmp.Width-1 do
            begin
              pixVal := trunc((pixFromS^ - minVal ) * coeff);
              aBmp.Canvas.Pixels[x, y] := ((pixVal shl 16) + (pixVal shl 8) + pixVal) and $00ffffff;
              Inc(pixFromS);
            end;
          end;
        end;

        else
          showmessage('Unknown IRB-PixelFormat!')
      end;
      aMemStrm := TMemoryStream.Create;
      aBmp.SaveToStream( aMemStrm );
      aMemStrm.Position:= 0;
      imgIRB.Picture.LoadFromStream(  aMemStrm );
      aMemStrm.Free;
    finally
      if Assigned( aBmp ) then
        aBmp.Free;
    end;
    Freemem( pxldat );
    FillIRBPropTable( FIrbAcsHnd );
    CalculateMinMax;
    spinXYChange(nil) ;
  except
    on E : Exception do
    begin
      StatBar( 2, 'Error in ShowIrbBmp (' + e.ClassName  + ' ' + e.Message + ')');
    end;
  end;
end;

procedure TfrmTestLib.SearchMinMaxByte( const pData: Pointer; const iDataSize: Integer;
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

    // Find Min and Max
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

procedure TfrmTestLib.SearchMinMaxWord( const pData: Pointer; const iDataSize: Integer;
  var Min, Max: Single);
var
  aPW,aPWFin :PWord;
  cnt : Integer;
begin
  try
    aPW    := PWord( pData );
    aPWFin := aPW;
    Inc(aPWFin, iDataSize);
    Min := aPW^;
    Max := Min;

    // Find Min and Max
    cnt := 0;
    while cnt < iDataSize do //LongWord(aPW) < LongWord(aPWFin) do
    begin
      if aPW^ < Min then
        Min:= aPW^
      else
        if aPW^ > Max then Max:= aPW^;
      Inc( aPW );
      Inc( cnt );
    end;
  except
    on E : Exception do
    begin
      StatBar( 2, 'Error in SearchMinMaxWord (' + e.ClassName  + ' ' + e.Message + ')' );
    end;
  end;
end;

procedure TfrmTestLib.SearchMinMaxSingle( const pData: Pointer; const iDataSize: Integer;
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

    // Find Min and Max
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
      StatBar( 2, 'Error in SearchMinMaxSingle (' + e.ClassName  + ' ' + e.Message + ')' );
    end;
  end;
end;

end.

