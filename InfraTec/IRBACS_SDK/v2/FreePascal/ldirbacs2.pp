unit ldirbacs2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

const
  cIRBImageHeaderSize101 = 1728 ;
  cIRBImageData = 744 ;
  cMaxParamString = 256 ;

const cReadPixelData_BB_Temp_Double : integer = 0 ; // in K
const cReadPixelData_Temp_Double : integer = 1 ; // in K
const cReadPixelData_RawValues_Double : integer = 2 ; // in K
const cReadPixelData_Temp_Single : integer = 3 ; // in K (buffer with temperature values of type single)

type

  TPixelValue = ( pvTempBB, pvTemp, pvDigVal, pvTempBBSi );

  TCorrPars = packed record
    epsilon   : Double;
    envTemp   : Double;
    tau       : Double;
    pathTemp  : Double;
    lambda    : Double;
    deltaLambda : Double;
  end;

  TParamValue = (   {0}pavWidth, pavHeight, pavLevel, pavSpan, pavEpsilon,
                    {5}pavDistance, pavPathTemp, pavEnvTemp, pavAbsorption, pavDataVersion,
                    {10}pavZoom, pavKamera, pavKameraSNr, pavLens, pavPixelFormat,
                    {15}pavTransmission, pavLambda, pavDeltaLambda, pavMilliTime, pavTimeStamp,
                    {20}pavCalibMin, pavCalibMax, pavTriggered, pavIntegtime, pavHFOV,
                    {25}pavVFOV, pavSmooth, pavCamTemp, pavSensorTemp, pavDigVals,
                    {30}pavAD1, pavAD2, pavAD3, pavAD4, pavAD5, pavHeightWithHdr   );

  TIRBCalibData = packed record
    Version :Integer;
    Count   :Integer;
    Values  :array [0..269] of Single;
  end;

  TIRBCalibPars101 = packed record
    cbData : array[0..1567] of byte;
  end;

  TIRBCalibPars = packed record
      cbData : array[0..583] of byte;
  end ;

  TIRBImageInfo = packed record
    level	     : Single;
    span	     : Single;
    imgTime	     : TDateTime;
    imgMilliTime   : Single;     // Milliseconds
    imgAccu	     : Word;
    imageComment   : array[0..79] of Char;
    zoom_hor	     : Single;
    zoom_vert	     : Single;
    imgMilliTimeEx : SmallInt;  // evtl. Microseconds
  end;

  TIRBgeomInfo = packed record
    pixelFormat	  : Word;
    compression   : Word;
    imgWidth	  : Word;
    imgHeight	  : Word;
    upperLeftX	  : Word;
    upperLeftY	  : Word;
    firstValidX	  : Word;
    lastValidX	  : Word;
    firstValidY	  : Word;
    lastValidY	  : Word;
    position	  : Single;
  end;

  TIRBobjPars = packed record
    emissivity	  : Single;
    objDistance	  : Single;
    ambTemp	  : Single;
    absoConst	  : Single;
    pathTemp	  : Single;
    version      	 : LongInt;
  end;

  TIRBImageData1 = packed record
    geomInfo       : TIRBgeomInfo;
    objectPars     : TIRBobjPars;
    calibPars      : TIRBCalibPars101;
    imgInfo	     : TIRBImageInfo;
  end;

  TIRBImageData0 = packed record
    geomInfo   : TIRBgeomInfo;
    objectPars : TIRBobjPars;
    calibPars  : TIRBCalibPars;
    imgInfo	 : TIRBImageInfo;
  end;


  T_testxxx                        = function( value: Integer ): Integer; stdcall;
  T_irbacs_version                 = function( var mainver, subver : Integer ): Boolean; stdcall;

  T_irbacs_loadIRB                 = function( const fn: PAnsiChar ): PtrUInt;  stdcall;
  T_irbacs_unloadIRB               = procedure( const aHandle : PtrUInt );  stdcall;
  T_irbacs_getFrameCount           = function(  const aHandle: PtrUInt ): Integer; stdcall;
  T_irbacs_getIRBIndices           = function(  const ahandle : PtrUInt; const irbIdxList : PInteger ): Integer; stdcall;
  T_irbacs_getFrameNumber          = function(  const aHandle : PtrUInt ) : Integer; stdcall;
  T_irbacs_setFrameNumber          = procedure( const aHandle : PtrUInt; const frno : Integer ); stdcall;
  T_irbacs_setFrameNbByArrayIdx    = procedure( const aHandle: PtrUInt; const frno : Integer ); stdcall;
  T_irbacs_getFrameNbByArrayIdx    = function( const aHandle : PtrUInt ) : Integer ; stdcall;


  T_irbacs_getTempBBXY             = function( const aHandle : PtrUInt; const xx, yy : Integer ): Double; stdcall;
  T_irbacs_getTempXY               = function( const aHandle : PtrUInt; const xx, yy : Integer ): Double; stdcall;
  T_irbacs_getDigValXY             = function( const aHandle : PtrUInt; const xx, yy : Integer ): Double; stdcall;
  T_irbacs_readPixelData           = function( const aHandle : PtrUInt; const where: Pointer; const what : Integer ): Integer; stdcall;
  T_irbacs_readIRBData             = function( const aHandle : PtrUInt; const where: Pointer): Integer; stdcall;
  T_irbacs_readIRBDataUncompressed = function( const aHandle : PtrUInt; const where: Pointer): Integer; stdcall;
  T_irbacs_convertPixelToKelvin    = function( const aHandle : PtrUInt; const where: Pointer; const cnt: Integer; const corrpars : Pointer ): Integer; stdcall;

  T_irbacs_getParam                = function( const aHandle : PtrUInt; const what :Integer; var Value :Double): Boolean; stdcall;
  T_irbacs_setParam                = function( const aHandle : PtrUInt; const what :Integer; const Value :Double): Boolean; stdcall;
  T_irbacs_getParamS               = function( const aHandle : PtrUInt; const what :Integer; const Value : PAnsiChar ): Boolean; stdcall;
  T_irbacs_getMilliTime            = function( const aHandle : PtrUInt ): Double; stdcall;
  T_irbacs_getFrameTimeStamp       = function( const aHandle : PtrUInt; var timeStamp : TSystemTime ): Boolean; stdcall;

  T_irbacs_getIRBCalibData         = function( const aHandle : PtrUInt; const IRBCalibData : Pointer {TIRBCalibData}): Boolean; stdcall;
  T_irbacs_getIRBHeader            = function( const aHandle : PtrUInt; const IRBHeader : Pointer ): Boolean; stdcall;
  T_irbacs_setIRBHeader            = function( const aHandle : PtrUInt; const IRBHeader : Pointer ): Boolean; stdcall;

  T_irbacs_saveSingleFrame         = function( const aHandle : PtrUInt; const fn : PAnsiChar; const from : Pointer ): Boolean; stdcall;
  T_irbacs_exportVisBitmap         = function( const aHandle : PtrUInt; const fn : PAnsiChar ): Boolean; stdcall;
  T_irbacs_audioComment            = function( const aHandle : PtrUInt; const fn : PAnsiChar ): Boolean; stdcall;


var
  _testxxx                          : T_testxxx;
  _irbacs_version                 : T_irbacs_version;

  _irbacs_loadIRB                 : T_irbacs_loadIRB;
  _irbacs_unloadIRB               : T_irbacs_unloadIRB;
  _irbacs_getFrameCount           : T_irbacs_getFrameCount;
  _irbacs_getIRBIndices           : T_irbacs_getIRBIndices;
  _irbacs_getFrameNumber          : T_irbacs_getFrameNumber;
  _irbacs_setFrameNumber          : T_irbacs_setFrameNumber;
  _irbacs_setFrameNbByArrayIdx    : T_irbacs_setFrameNbByArrayIdx;
  _irbacs_getFrameNbByArrayIdx    : T_irbacs_getFrameNbByArrayIdx;

  _irbacs_getTempBBXY             : T_irbacs_getTempBBXY;
  _irbacs_getTempXY               : T_irbacs_getTempXY;
  _irbacs_getDigValXY             : T_irbacs_getDigValXY;
  _irbacs_readPixelData           : T_irbacs_readPixelData;
  _irbacs_readIRBData             : T_irbacs_readIRBData;
  _irbacs_readIRBDataUncompressed : T_irbacs_readIRBDataUncompressed;
  _irbacs_convertPixelToKelvin    : T_irbacs_convertPixelToKelvin;

  _irbacs_getParam                : T_irbacs_getParam;
  _irbacs_setParam                : T_irbacs_setParam;
  _irbacs_getParamS               : T_irbacs_getParamS;
  _irbacs_getMilliTime            : T_irbacs_getMilliTime;
  _irbacs_getFrameTimeStamp       : T_irbacs_getFrameTimeStamp;

  _irbacs_getIRBCalibData         : T_irbacs_getIRBCalibData;
  _irbacs_getIRBHeader            : T_irbacs_getIRBHeader;
  _irbacs_setIRBHeader            : T_irbacs_setIRBHeader;

  _irbacs_saveSingleFrame         : T_irbacs_saveSingleFrame;
  _irbacs_exportVisBitmap         : T_irbacs_exportVisBitmap;
  _irbacs_audioComment            : T_irbacs_audioComment;


var
  IRBACSDLLFound : Boolean = false;
  IRBACSDLLName : string ;

function  InitIRBACSLibrary: Boolean;
procedure FreeIRBACSLibrary;

implementation

uses
  dynlibs;

var
  DLLHandle : TLibHandle;

function InitIRBACSLibrary: Boolean;
var
  //ss  : string ;
  res : boolean ;

begin
  Result := False;
  try
    {$IFDEF WINDOWS}
      {$IFDEF WIN32}
      IRBACSDLLName := 'irbacs_w32.dll' ;
      {$ENDIF}
      {$IFDEF WIN64}
      IRBACSDLLName := 'irbacs_w64.dll' ;
      {$ENDIF}
    {$ELSE}
      {$IFDEF WIN32}
      IRBACSDLLName := './irbacs32.so' ;
      {$ELSE}
      IRBACSDLLName := './irbacs64.so' ;
      {$ENDIF}
    {$ENDIF}
    DLLHandle := SafeLoadLibrary( IRBACSDLLName );
    //ss := GetLoadErrorStr;
  except
    on Exception do
      DLLHandle := 0;
  end;
  if DLLHandle < 32 then exit;

  //FLibHandle := LoadLibrary( './libtest.so');
  _testxxx := T_testxxx( GetProcedureAddress( DLLHandle, 'testxxx'));
  res := Assigned( _testxxx ) ;
  _irbacs_version                 := T_irbacs_version( GetProcedureAddress(   DLLHandle, 'version'));
  res := res and Assigned( _irbacs_version );
  _irbacs_loadIRB                 := T_irbacs_loadIRB( GetProcedureAddress(   DLLHandle, 'loadIRB'));
  res := res and Assigned( _irbacs_loadIRB );
  _irbacs_unloadIRB               := T_irbacs_unloadIRB( GetProcedureAddress( DLLHandle, 'unloadIRB'));
  res := res and Assigned( _irbacs_unloadIRB );
  _irbacs_getFrameCount           := T_irbacs_getFrameCount( GetProcAddress(  DLLHandle, 'getFrameCount'));
  res := res and Assigned( _irbacs_getFrameCount );
  _irbacs_getIRBIndices           := T_irbacs_getIRBIndices( GetProcAddress(  DLLHandle, 'getIRBIndices'));
  res := res and Assigned( _irbacs_getIRBIndices );
  _irbacs_getFrameNumber          := T_irbacs_getFrameNumber( GetProcAddress( DLLHandle, 'getFrameNumber'));
  res := res and Assigned( _irbacs_getFrameNumber );
  _irbacs_setFrameNumber          := T_irbacs_setFrameNumber( GetProcAddress( DLLHandle, 'setFrameNumber'));
  res := res and Assigned( _irbacs_setFrameNumber );
  _irbacs_setFrameNbByArrayIdx    := T_irbacs_setFrameNbByArrayIdx( GetProcAddress( DLLHandle, 'setFrameNbByArrayIdx'));
  res := res and Assigned( _irbacs_setFrameNbByArrayIdx );
  _irbacs_getFrameNbByArrayIdx    := T_irbacs_getFrameNbByArrayIdx( GetProcAddress( DLLHandle, 'getFrameNbByArrayIdx'));
  res := res and Assigned( _irbacs_getFrameNbByArrayIdx );

  _irbacs_getTempBBXY             := T_irbacs_getTempBBXY( GetProcAddress( DLLHandle, 'getTempBBXY' ));
  res := res and Assigned( _irbacs_getTempBBXY );
  _irbacs_getTempXY               := T_irbacs_getTempXY( GetProcAddress( DLLHandle,   'getTempXY' ));
  res := res and Assigned( _irbacs_getTempXY );
  _irbacs_getDigValXY             := T_irbacs_getDigValXY( GetProcAddress( DLLHandle, 'getDigValXY' ));
  res := res and Assigned( _irbacs_getDigValXY );
  _irbacs_readPixelData           := T_irbacs_readPixelData( GetProcAddress( DLLHandle, 'readPixelData'));
  res := res and Assigned( _irbacs_readPixelData );
  _irbacs_readIRBData             := T_irbacs_readIRBData( GetProcAddress( DLLHandle, 'readIRBData' ));
  res := res and Assigned( _irbacs_readIRBData );
  _irbacs_readIRBDataUncompressed := T_irbacs_readIRBDataUncompressed( GetProcAddress( DLLHandle, 'readIRBDataUncompressed' ) );
  res := res and Assigned( _irbacs_readIRBDataUncompressed );
  _irbacs_convertPixelToKelvin    := T_irbacs_convertPixelToKelvin( GetProcAddress( DLLHandle, 'convertPixelToKelvin' ) );
  res := res and Assigned( _irbacs_convertPixelToKelvin );

  _irbacs_getParam                := T_irbacs_getParam( GetProcAddress( DLLHandle, 'getParam'));
  res := res and Assigned( _irbacs_getParam );
  _irbacs_setParam                := T_irbacs_setParam( GetProcAddress( DLLHandle, 'setParam'));
  res := res and Assigned( _irbacs_setParam );
  _irbacs_getParamS               := T_irbacs_getParamS( GetProcAddress( DLLHandle, 'getParamS'));
  res := res and Assigned( _irbacs_getParamS );
  _irbacs_getMilliTime            := T_irbacs_getMilliTime( GetProcAddress( DLLHandle, 'getMilliTime'));
  res := res and Assigned( _irbacs_getMilliTime );
  _irbacs_getFrameTimeStamp       := T_irbacs_getFrameTimeStamp( GetProcAddress( DLLHandle, 'getFrameTimeStamp'));
  res := res and Assigned( _irbacs_getFrameTimeStamp );

  _irbacs_getIRBCalibData         := T_irbacs_getIRBCalibData( GetProcAddress( DLLHandle, 'getIRBCalibData'));
  res := res and Assigned( _irbacs_getIRBCalibData );
  _irbacs_getIRBHeader            := T_irbacs_getIRBHeader( GetProcAddress( DLLHandle, 'getIRBHeader'));
  res := res and Assigned( _irbacs_getIRBHeader );
  _irbacs_setIRBHeader            := T_irbacs_setIRBHeader( GetProcAddress( DLLHandle, 'setIRBHeader'));
  res := res and Assigned( _irbacs_setIRBHeader );

  _irbacs_saveSingleFrame         := T_irbacs_saveSingleFrame( GetProcAddress( DLLHandle, 'saveSingleFrame'));
  res := res and Assigned( _irbacs_saveSingleFrame );
  _irbacs_exportVisBitmap         := T_irbacs_exportVisBitmap( GetProcAddress( DLLHandle, 'exportVisBitmap'));
  res := res and Assigned( _irbacs_exportVisBitmap );
  _irbacs_audioComment            := T_irbacs_audioComment( GetProcAddress( DLLHandle, 'audioComment'));
  res := res and Assigned( _irbacs_audioComment );

  IRBACSDLLFound  := res;
  Result := IRBACSDLLFound ;
end;

procedure FreeIRBACSLibrary;
begin
  if DLLHandle < 32 then exit;
  UnloadLibrary( DLLHandle );
end;

end.

