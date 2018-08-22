unit ldirbacs2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TIRBCalibData = packed record
    Version :Integer;
    Count   :Integer;
    Values  :array [0..269] of Single;
  end;

  {
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
                    {30}pavAD1, pavAD2, pavAD3, pavAD4, pavAD5   );  }
type
  TDecodedTime = packed record
    wYear     : Word;
    wMonth    : Word;
    wDay      : Word;
    wHour     : Word;
    wMinute   : Word;
    wSecond   : Word;
    wMilliSec : Word;
  end;

type
  T_testxxx = function( value: Integer ): Integer; stdcall;

  T_irbacs64_version                 = function( var mainver, subver : Integer ): Boolean; stdcall;

  T_irbacs64_loadIRB                 = function( const fn: PAnsiChar ): PtrUInt;  stdcall;
  T_irbacs64_unloadIRB               = procedure( const aHandle : PtrUInt );  stdcall;
  T_irbacs64_getFrameCount           = function(  const aHandle: PtrUInt ): Integer; stdcall;
  T_irbacs64_getIRBIndices           = function(  const ahandle : PtrUInt; const irbIdxList : PInteger ): Integer; stdcall;
  T_irbacs64_getFrameNumber          = function(  const aHandle : PtrUInt ) : Integer; stdcall;
  T_irbacs64_setFrameNumber          = procedure( const aHandle : PtrUInt; const frno : Integer ); stdcall;
  T_irbacs64_setFrameNbByArrayIdx    = procedure( const aHandle: PtrUInt; const frno : Integer ); stdcall;
  T_irbacs64_getFrameNbByArrayIdx    = function( const aHandle : PtrUInt ) : Integer ; stdcall;


  T_irbacs64_getTempBBXY             = function( const aHandle : PtrUInt; const xx, yy : Integer ): Double; stdcall;
  T_irbacs64_getTempXY               = function( const aHandle : PtrUInt; const xx, yy : Integer ): Double; stdcall;
  T_irbacs64_getDigValXY             = function( const aHandle : PtrUInt; const xx, yy : Integer ): Double; stdcall;
  T_irbacs64_readPixelData           = function( const aHandle : PtrUInt; const where: Pointer; const what : Integer ): Integer; stdcall;
  T_irbacs64_readIRBData             = function( const aHandle : PtrUInt; const where: Pointer): Integer; stdcall;
  T_irbacs64_readIRBDataUncompressed = function( const aHandle : PtrUInt; const where: Pointer): Integer; stdcall;
  T_irbacs64_convertPixelToKelvin    = function( const aHandle : PtrUInt; const where: Pointer; const cnt: Integer; corrpars : Pointer ): Integer; stdcall;

  T_irbacs64_getParam                = function( const aHandle : PtrUInt; const what :Integer; var Value: Double): Boolean; stdcall;
  T_irbacs64_setParam                = function( const aHandle : PtrUInt; const what :Integer; const Value :Double): Boolean; stdcall;
  T_irbacs64_getParamS               = function( const aHandle : PtrUInt; const what :Integer; const Value : PAnsiChar ): Boolean; stdcall;
  T_irbacs64_getMilliTime            = function( const aHandle : PtrUInt ): Double; stdcall;
  T_irbacs64_getFrameTimeStamp       = function( const aHandle : PtrUInt ): TDecodedTime; stdcall;

  T_irbacs64_getIRBCalibData         = function( const aHandle : PtrUInt; const IRBCalibData : Pointer {TIRBCalibData}): Boolean; stdcall;
  T_irbacs64_getIRBHeader            = function( const aHandle : PtrUInt; const IRBHeader : Pointer ): Boolean; stdcall;
  T_irbacs64_setIRBHeader            = function( const aHandle : PtrUInt; const IRBHeader : Pointer ): Boolean; stdcall;

  T_irbacs64_saveSingleFrame         = function( const aHandle : PtrUInt; const fn : PAnsiChar; const from : Pointer ): Boolean; stdcall;
  T_irbacs64_exportVisBitmap         = function( const aHandle : PtrUInt; const fn : PAnsiChar ): Boolean; stdcall;
  T_irbacs64_audioComment            = function( const aHandle : PtrUInt; const fn : PAnsiChar ): Boolean; stdcall;


var
  _testxxx : T_testxxx;

  _irbacs64_version                 : T_irbacs64_version;

  _irbacs64_loadIRB                 : T_irbacs64_loadIRB;
  _irbacs64_unloadIRB               : T_irbacs64_unloadIRB;
  _irbacs64_getFrameCount           : T_irbacs64_getFrameCount;
  _irbacs64_getIRBIndices           : T_irbacs64_getIRBIndices;
  _irbacs64_getFrameNumber          : T_irbacs64_getFrameNumber;
  _irbacs64_setFrameNumber          : T_irbacs64_setFrameNumber;
  _irbacs64_setFrameNbByArrayIdx    : T_irbacs64_setFrameNbByArrayIdx;
  _irbacs64_getFrameNbByArrayIdx    : T_irbacs64_getFrameNbByArrayIdx;

  _irbacs64_getTempBBXY             : T_irbacs64_getTempBBXY;
  _irbacs64_getTempXY               : T_irbacs64_getTempXY;
  _irbacs64_getDigValXY             : T_irbacs64_getDigValXY;
  _irbacs64_readPixelData           : T_irbacs64_readPixelData;
  _irbacs64_readIRBData             : T_irbacs64_readIRBData;
  _irbacs64_readIRBDataUncompressed : T_irbacs64_readIRBDataUncompressed;
  _irbacs64_convertPixelToKelvin    : T_irbacs64_convertPixelToKelvin;

  _irbacs64_getParam                : T_irbacs64_getParam;
  _irbacs64_setParam                : T_irbacs64_setParam;
  _irbacs64_getParamS               : T_irbacs64_getParamS;
  _irbacs64_getMilliTime            : T_irbacs64_getMilliTime;
  _irbacs64_getFrameTimeStamp       : T_irbacs64_getFrameTimeStamp;

  _irbacs64_getIRBCalibData         : T_irbacs64_getIRBCalibData;
  _irbacs64_getIRBHeader            : T_irbacs64_getIRBHeader;
  _irbacs64_setIRBHeader            : T_irbacs64_setIRBHeader;

  _irbacs64_saveSingleFrame         : T_irbacs64_saveSingleFrame;
  _irbacs64_exportVisBitmap         : T_irbacs64_exportVisBitmap;
  _irbacs64_audioComment            : T_irbacs64_audioComment;


var
  IRBACS64DLLFound : Boolean = false;

function  InitIRBACS64Library: Boolean;
procedure FreeIRBACS64Library;

implementation

uses
  dynlibs;

var
  DLLHandle : TLibHandle;

function InitIRBACS64Library: Boolean;
var
  ss : String;
begin
  Result := False;
  try
    {$IFDEF WINDOWS}
      {$IFDEF WIN32}
      DLLHandle := SafeLoadLibrary( 'irbacs_w32.dll');
      {$ELSE}
      DLLHandle := SafeLoadLibrary( 'irbacs_w64.dll');
      {$ENDIF}
    {$ELSE}
      {$IFDEF WIN32}
      DLLHandle := SafeLoadLibrary( './libirbacs_l32.so');
      {$ELSE}
      DLLHandle := SafeLoadLibrary( './libirbacs_l64.so');
      {$ENDIF}
    {$ENDIF}
    ss := GetLoadErrorStr;
  except
    on Exception do
      DLLHandle := 0;
  end;
  if DLLHandle < 32 then exit;

  //FLibHandle := LoadLibrary( './libtest.so');
  _testxxx := T_testxxx( GetProcedureAddress( DLLHandle, 'testxxx'));

  _irbacs64_version                 := T_irbacs64_version( GetProcedureAddress(   DLLHandle, 'version'));

  _irbacs64_loadIRB                 := T_irbacs64_loadIRB( GetProcedureAddress(   DLLHandle, 'loadIRB'));
  _irbacs64_unloadIRB               := T_irbacs64_unloadIRB( GetProcedureAddress( DLLHandle, 'unloadIRB'));
  _irbacs64_getFrameCount           := T_irbacs64_getFrameCount( GetProcAddress(  DLLHandle, 'getFrameCount'));
  _irbacs64_getIRBIndices           := T_irbacs64_getIRBIndices( GetProcAddress(  DLLHandle, 'getIRBIndices'));
  _irbacs64_getFrameNumber          := T_irbacs64_getFrameNumber( GetProcAddress( DLLHandle, 'getFrameNumber'));
  _irbacs64_setFrameNumber          := T_irbacs64_setFrameNumber( GetProcAddress( DLLHandle, 'setFrameNumber'));
  _irbacs64_setFrameNbByArrayIdx    := T_irbacs64_setFrameNbByArrayIdx( GetProcAddress( DLLHandle, 'setFrameNbByArrayIdx'));
  _irbacs64_getFrameNbByArrayIdx    := T_irbacs64_getFrameNbByArrayIdx( GetProcAddress( DLLHandle, 'getFrameNbByArrayIdx'));

  _irbacs64_getTempBBXY             := T_irbacs64_getTempBBXY( GetProcAddress( DLLHandle, 'getTempBBXY' ));
  _irbacs64_getTempXY               := T_irbacs64_getTempXY( GetProcAddress( DLLHandle,   'getTempXY' ));
  _irbacs64_getDigValXY             := T_irbacs64_getDigValXY( GetProcAddress( DLLHandle, 'getDigValXY' ));
  _irbacs64_readPixelData           := T_irbacs64_readPixelData( GetProcAddress( DLLHandle, 'readPixelData'));
  _irbacs64_readIRBData             := T_irbacs64_readIRBData( GetProcAddress( DLLHandle, 'readIRBData' ));
  _irbacs64_readIRBDataUncompressed := T_irbacs64_readIRBDataUncompressed( GetProcAddress( DLLHandle, 'readIRBDataUncompressed' ) );
  _irbacs64_convertPixelToKelvin    := T_irbacs64_convertPixelToKelvin( GetProcAddress( DLLHandle, 'convertPixelToKelvin' ) );

  _irbacs64_getParam                := T_irbacs64_getParam( GetProcAddress( DLLHandle, 'getParam'));
  _irbacs64_setParam                := T_irbacs64_setParam( GetProcAddress( DLLHandle, 'setParam'));
  _irbacs64_getParamS               := T_irbacs64_getParamS( GetProcAddress( DLLHandle, 'getParamS'));
  _irbacs64_getMilliTime            := T_irbacs64_getMilliTime( GetProcAddress( DLLHandle, 'getMilliTime'));
  _irbacs64_getFrameTimeStamp       := T_irbacs64_getFrameTimeStamp( GetProcAddress( DLLHandle, 'getFrameTimeStamp'));

  _irbacs64_getIRBCalibData         := T_irbacs64_getIRBCalibData( GetProcAddress( DLLHandle, 'getIRBCalibData'));
  _irbacs64_getIRBHeader            := T_irbacs64_getIRBHeader( GetProcAddress( DLLHandle, 'getIRBHeader'));
  _irbacs64_setIRBHeader            := T_irbacs64_setIRBHeader( GetProcAddress( DLLHandle, 'setIRBHeader'));

  _irbacs64_saveSingleFrame         := T_irbacs64_saveSingleFrame( GetProcAddress( DLLHandle, 'saveSingleFrame'));
  _irbacs64_exportVisBitmap         := T_irbacs64_exportVisBitmap( GetProcAddress( DLLHandle, 'exportVisBitmap'));
  _irbacs64_audioComment            := T_irbacs64_audioComment( GetProcAddress( DLLHandle, 'audioComment'));



  //StatBar(0, IntToStr( _testxxx( 1 ) ));

  IRBACS64DLLFound  := True;
  //Result := Assigned( _irbacs64_loadIRB );
  Result := Assigned( _testxxx );
end;

procedure FreeIRBACS64Library;
begin
  if DLLHandle < 32 then exit;
  UnloadLibrary( DLLHandle );
end;

end.
