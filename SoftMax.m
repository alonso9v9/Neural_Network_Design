#!/usr/bin/octave-cli

## "Capa" sigmoide, que aplica la función logística
classdef SoftMax < handle
  properties    
    ## Resultados después de la propagación hacia adelante
    outputs=[];
    ## Resultados después de la propagación hacia atrás
    gradient=[];
  endproperties

  methods
    ## Constructor ejecuta un forward si se le pasan datos
    function s=SoftMax()
      s.outputs=[];
      s.gradient=[];
    endfunction

    ## Propagación hacia adelante
    function y=forward(s,a)
      s.outputs = logsoft(a);
      y=s.outputs;
      s.gradient = [];
    endfunction

    ## Propagación hacia atrás recibe dL/ds de siguientes nodos
    function dlds = backward(s,dLds)
      if (size(dLds)!=size(s.outputs))
        error("backward de sigmoide no compatible con forward previo");
      endif
      ## s.gradient = h - (((h)*ones(columns(h),1))*ones(1,rows(h)))*s.outputs;
      s.gradient = s.outputs - dLds;
      dlds=s.gradient;
    endfunction
  endmethods
endclassdef
