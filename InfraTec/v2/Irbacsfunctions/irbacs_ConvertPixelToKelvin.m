function result=irbacs_ConvertPixelToKelvin( irbfileHandle, cnt, pCorr ) 
result=calllib('irbacslib', 'convertPixelToKelvin', irbfileHandle, cnt, pCorr ) ;
