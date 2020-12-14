## Subcapa LeakyReLU que aplica la funcion de activacion max
classdef LeakyReLU < handle
  properties
    ## Resultados despues de la propagacion hacia adelante
    outputs=[];
    ## Resultados despues de la propagacion hacia atras
    gradient=[];
  endproperties
  methods
    function s=LeakyReLU()
      s.outputs=[];
      s.gradient=[];
    endfunction
    
    function y=forward(s,X)
      s.outputs = max(X/10,X);
      y=s.outputs;
      s.gradient = [];
    endfunction
    
    function dlds=backward(s,dLds)
      if (size(dLds)!=size(s.outputs))
        error("backward de LeakyReLU no compatible con forward previo");
      endif
      localGrad = (1+9*+(s.outputs>0))/10;
      s.gradient = localGrad.*dLds;
      dlds=s.gradient;
    endfunction
  endmethods
endclassdef