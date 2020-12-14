classdef capaError < handle
  properties
    ## Valores verdaderos
    realY=[];
    ## Entrada de valores en la propagacion hacia adelante
    inputsY=[];
    ## Tipo de funcion de activacion
    funcAct=MSE();
    ## Resultados despues de la propagación hacia atrás
    gradientX=[];
  endproperties
  
  methods
    ## Constructor inicializa todo vaci�o
    function s=capaError()
      realY=[];
      s.inputsY=[];
      s.gradientX=[];
      s.funcAct=MSE();
    endfunction

    ## Cambia la funcion de activacion de ser requerido
    function camFunc(s,num)
      switch(num)
        case 1
          s.funcAct=MSE();
        case 2
          s.funcAct=Cross_Entropy();
        otherwise
      endswitch
    endfunction

    function err=forward(s)
      err=s.funcAct.Error(s.realY,s.inputsY);
    endfunction
    
    ## Propagacion hacia atras recibe dL/ds de siguientes nodos
    function dlds=backward(s,dLds=1)
      s.gradientX=s.funcAct.backward(s.realY,s.inputsY);
      dlds=s.gradientX;
    endfunction
    
  endmethods
endclassdef
