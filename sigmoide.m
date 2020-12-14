#!/usr/bin/octave-cli

## "Subcapa" sigmoide, que aplica la funcion logistica
classdef sigmoide < handle
  properties    
    ## Resultados despues de la propagacion hacia adelante
    outputs=[];
    ## Resultados despues de la propagacion hacia atras
    gradient=[];
  endproperties

  methods
    ## Constructor ejecuta un forward si se le pasan datos
    function s=sigmoide()
      s.outputs=[];
      s.gradient=[];
    endfunction

    ## Propagación hacia adelante
    function y=forward(s,a)
      s.outputs = logistic(a);
      y=s.outputs;
      s.gradient = [];
    endfunction

    ## Propagación hacia atrás recibe dL/ds de siguientes nodos
    function dlds=backward(s,dLds)
      if (size(dLds)!=size(s.outputs))
        error("backward de sigmoide no compatible con forward previo");
      endif
      localGrad = s.outputs.*(1-s.outputs);
      s.gradient = localGrad.*dLds;
      dlds=s.gradient;
    endfunction
  endmethods
endclassdef
