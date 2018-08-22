/* 	C-Header für IRBACS-DLL Version 2
	Einbindung in Matlab
	InfraTec GmbH
	11.10.2013
	ho
*/
       
typedef void* PtrUint;

// Type unsigned char (=Byte) is used for function results of type boolean
typedef unsigned char cbool;

struct TIRBCalibData {
    int   Version;
    int   Count;
    float Values[270];
};


struct TIRB_Header {
    char  hdr101[1728]; // 
};


struct IRBgeomInfo {
	unsigned short pixelFormat;
	unsigned short compression;
	unsigned short imgWidth;
	unsigned short imgHeight;
	unsigned short upperLeftX;
	unsigned short upperLeftY;
	unsigned short firstValidX;
	unsigned short lastValidX;
	unsigned short firstValidY;
	unsigned short lastValidY;
	float position;
};

struct TIRBobjPars {
	float emissivity;
	float objDistance;
	float ambTemp;
	float absoConst;
	float pathTemp;
	int version;
};

struct TIRBCalibPars1 {
	char cbData[1568];
};

struct TIRBImageInfo {
	float level;
	float span;
	double imgTime;
	float imgMilliTime;     // Millisekunden
	unsigned short imgAccu;
	char  imageComment[80];
	float zoom_hor;
	float zoom_vert;
	short imgMilliTimeEx;  // evtl. Mikrosekunden
};

/*
struct TIRBImageData1 {
	TIRB_geomInfo geomInfo;
	TIRB_objPars objectPars;
	TIRB_CalibPars1 calibPars;
	TIRB_ImageInfo imgInfo;
}; */

struct TIRBCorrPars {
   	double epsilon;
    double envTemp;
   	double tau;
    double pathTemp;
   	double lambda;
    double deltaLambda;
};		

// It seems that SYSTEMTIME ist unknown in Matlab internal compiler
// so we declare the structure
struct TSYSTEMTIME {
    short  wYear;
    short  wMonth;
    short  wDayOfWeek;
    short  wDay;
    short  wHour;
    short  wMinute;
    short  wSecond;
    short  wMilliseconds;
};

cbool        _stdcall version( int* mainver, int* subver );
PtrUint      _stdcall loadIRB( const char* strFileName );
void         _stdcall unloadIRB( const PtrUint hndIrbfile );
int          _stdcall getFrameCount( const PtrUint hndIrbfile );
int          _stdcall getIRBIndices( const PtrUint hndIrbfile, const void* irbIdxList );
int          _stdcall getFrameNumber( const PtrUint hndIrbfile );
void         _stdcall setFrameNumber( const PtrUint hndIrbfile, const int frNb );
void         _stdcall setFrameNbByArrayIdx( const PtrUint hndIrbfile, const int frNb );
int          _stdcall getFrameNbByArrayIdx( const PtrUint hndIrbfile );

double       _stdcall getTempBBXY( const PtrUint hndIrbfile, const int xx, const int yy );
double       _stdcall getTempXY( const PtrUint hndIrbfile, const int xx, const int yy );
double       _stdcall getDigValXY( const PtrUint hndIrbfile, const int xx, const int yy );
int          _stdcall readPixelData( const PtrUint hndIrbfile, const void* pData, const int what );
int          _stdcall readIRBData( const PtrUint hndIrbfile, const void* pIRBFrame ) ;
int          _stdcall readIRBDataUncompressed( const PtrUint hndIrbfile, const void* pIRBFrame );
int          _stdcall convertPixelToKelvin( const PtrUint hndIrbfile, void* pData, const int cnt, const void* corrpars );

cbool        _stdcall getParam( const PtrUint hndIrbfile, const int what, double* fValue );
cbool        _stdcall setParam( const PtrUint hndIrbfile, const int what, const double* fValue );
cbool        _stdcall getParamS( const PtrUint hndIrbfile, const int what, char* strValue );
double       _stdcall getMilliTime( const PtrUint hndIrbfile );
cbool        _stdcall getFrameTimeStamp( const PtrUint hndIrbfile, void* ptimestamp );
/*
Matlab does not support nested structures, so this function is not available in Matlab
cbool        _stdcall getIRBCalibData( const PtrUint hndIrbfile, void* pIRBCalibData );
cbool        _stdcall getIRBHeader( const PtrUint hndIrbfile, char* pIRBHeader );
cbool        _stdcall setIRBHeader( const PtrUint hndIrbfile, const char* pIRBHeader );
*/
cbool        _stdcall saveSingleFrame( const PtrUint hndIrbfile, const char* strFileName, const void* pIRBFrame );
cbool        _stdcall exportVisBitmap( const PtrUint hndIrbfile, const char* strFileName );
cbool        _stdcall audioComment( const PtrUint hndIrbfile, const char* strFileName );



