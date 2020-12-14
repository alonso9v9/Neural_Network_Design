function [ConfMat, exhaus,precision,f1,OA]=confusion(yp,yt)
  
  ConfMat = yp'*yt;
  
  TFN=sum((yp==0).*yt);
  TFP=sum((yp==0).*(yt==0));
  TTN=sum(yp.*(yt==0));
  TTP=diag(ConfMat);
  
  TTPall=sum(TTP);
  
  
  exhaus=TTPall./(TTPall+TFN);
  precision=TTP'./sum(ConfMat);
  
  
  
  f1=2*((exhaus.*precision)./(exhaus+precision));
  
  OA=sum(TTP')/rows(yt);
  
endfunction
