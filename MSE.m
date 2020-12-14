## Subcapa MSE que aplica la funcion de error minimos cuadrados ordinarios
classdef MSE < handle
  properties
    ## Resultados despues de la propagacion hacia atras
    gradient=[];
  endproperties
  methods
    function s=MSE()
      s.gradient=[];
    endfunction
    
    function err=Error(s, realY, Y)
      err=(1/2)*sum(vecnorm((realY-Y)').^2)/rows(N);
    endfunction
    
    function delta=backward(s, Y, X)
      s.gradient = X-Y;
      delta=s.gradient;
    endfunction
  endmethods
endclassdef