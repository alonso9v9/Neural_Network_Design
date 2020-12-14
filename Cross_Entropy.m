## Subcapa Cross_Entropy que aplica la funcion de entriopia cruzada
classdef Cross_Entropy < handle
  properties
    ## Resultados despues de la propagacion hacia atras
    gradient=[];
  endproperties
  methods
    function s=Cross_Entropy()
      s.gradient=[];
    endfunction
    
    function err=Error(s, realY, Y)
      err=sum(diag(-realY*log(Y')))/rows(Y);
    endfunction
    
    function delta=backward(s, Y, X)
      s.gradient = Y;
      delta = s.gradient;
    endfunction
  endmethods
endclassdef

