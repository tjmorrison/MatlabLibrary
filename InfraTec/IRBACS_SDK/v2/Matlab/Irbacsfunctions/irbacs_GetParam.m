function [result, resValue]=irbacs_GetParam( irbfileHandle, whatParam ) 
floatValue=double(0);
pfloatValue = libpointer( 'doublePtr', floatValue) ;
result=calllib('irbacslib', 'getParam', irbfileHandle, whatParam, pfloatValue );
resValue=pfloatValue.Value;
