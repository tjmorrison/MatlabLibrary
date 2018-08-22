function result=irbacs_ExportVisBitmap( irbfileHandle, pFilename ) 
result=calllib('irbacslib', 'exportVisBitmap', irbfileHandle, pFilename );
