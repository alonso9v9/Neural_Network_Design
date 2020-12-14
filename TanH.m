#!/usr/bin/octave-cli

## "Capa" tangentehiperbolico
classdef TanH< handle
  properties    
    ## Resultados después de la propagación hacia adelante
    outputs=[];
    ## Resultados después de la propagación hacia atrás
    gradient=[];
  endproperties

  methods
    ## Constructor ejecuta un forward si se le pasan datos
    function s=TanH()
      s.outputs=[];
      s.gradient=[];
    endfunction

    ## Propagación hacia adelante
    function y=forward(s,a)
      s.outputs = ((exp(a)-exp(-a))./(exp(a)+exp(-a)));
      y=s.outputs;
      s.gradient = [];
    endfunction

    ## Propagación hacia atrás recibe dL/ds de siguientes nodos
    function dlds = backward(s,dLds)
      if (size(dLds)!=size(s.outputs))
        error("backward de sigmoide no compatible con forward previo");
      endif
      localGrad = (1-s.outputs.^2);
      s.gradient = localGrad.*dLds;
      dlds = s.gradient;
    endfunction
  endmethods
endclassdef