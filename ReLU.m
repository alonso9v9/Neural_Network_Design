## Subcapa ReLU que aplica la funcion de activacion max
classdef ReLU < handle
  properties
    ## Resultados despues de la propagacion hacia adelante
    outputs=[];
    ## Resultados despues de la propagacion hacia atras
    gradient=[];
  endproperties
  methods
    function s=ReLU()
      s.outputs=[];
      s.gradient=[];
    endfunction
    
    function y=forward(s,X)
      s.outputs = max(0,X);
      y=s.outputs;
      s.gradient = [];
    endfunction
    
    function dlds=backward(s,dLds)
      if (size(dLds)!=size(s.outputs))
        error("backward de ReLU no compatible con forward previo");
      endif
      localGrad = +(s.outputs>0);
      s.gradient = localGrad.*dLds;
      dlds=s.gradient;
    endfunction
  endmethods
endclassdef
