classdef capa < handle
  properties
    ## Entrada de parametros en la propagacion hacia adelante
    inputsW=[];
    ## Entrada de valores en la propagacion hacia adelante
    inputsX=[];
    ## Tipo de funcion de activacion
    funcAct=sigmoide();
    ## Resultados despues de la propagacion hacia adelante
    outputs=[];
    ## Resultados despues de la propagación hacia atrás
    gradientW=[];
    gradientX=[];
    funcDes=Normal();
    numFunAct = 1;
    numDescGra = 1;
  endproperties
  
  methods
    ## Constructor inicializa todo vaci�o
    function s=capa()
      s.inputsX=[];
      s.inputsW=[];
      s.outputs=[];
      s.gradientX=[];
      s.gradientW=[];
      s.funcAct=sigmoide();
      s.funcDes=Normal();
      s.numFunAct = 1;
      s.numDescGra = 1;
    endfunction

    ## Cambia la funcion de activacion de ser requerido
    function cambFuncAct(s,num)
      switch(num)
        case 1
          s.funcAct=sigmoide();
        case 2
          s.funcAct=ReLU();
        case 3
          s.funcAct=SoftMax();
        case 4  
          s.funcAct = LeakyReLU();
        case 5
          s.funcAct = TanH();
        otherwise
      endswitch 
      s.numFunAct = num;
    endfunction
    
    function cambFuncDes(s, num)
      switch(num)
        case 1
          s.funcDes = Normal();
        case 2
          s.funcDes = Momentum();
          s.funcDes.Vo = zeros(size(s.inputsW));
        case 3
          s.funcDes = Adam();
          s.funcDes.Vo = zeros(size(s.inputsW));
          s.funcDes.So = zeros(size(s.inputsW));
        otherwise
      endswitch
      s.numDescGra = num;   
    endfunction    
    
    #Crea el peso aleatoriamente de esta capa dado numNeurons numero de neuronas
    function creaPeso(s, cantNeuAct, cantNeuAnt)
      s.inputsW=[];
      for i=1:cantNeuAct
        s.inputsW=[s.inputsW;-rand(1,cantNeuAnt+1)+rand(1,cantNeuAnt+1)];
      endfor
    endfunction
    
    ## Propagacion hacia adelante realiza W*x
    function y=forward(s,X)
      if (isreal(X) && ismatrix(X))
        s.inputsX=X;
        if (columns(X)==1) 
          val = s.inputsW*[ones(rows(X),1),X];
        else
          val = [ones(rows(X),1), X]*s.inputsW';
        endif
        s.outputs = s.funcAct.forward(val);
        y=s.outputs;
##        s.gradientX = [];
##        s.gradientW = [];
      else
        error("fullyconnected espera matriz y vector de reales");
      endif
    endfunction

    ## Propagacion hacia atras recibe dL/ds de siguientes nodos
    function dlds=backward(s,dLds)
      if (columns(dLds)==1)
        s.gradientW = (s.funcAct.backward(dLds))*[ones(rows(s.inputsX),1),s.inputsX]';
        s.gradientX = s.inputsW(:,2:columns(s.inputsW))'*(s.funcAct.backward(dLds));
      else
        s.gradientW = (s.funcAct.backward(dLds))'*[ones(rows(s.inputsX),1),s.inputsX];
        s.gradientX = (s.funcAct.backward(dLds))*s.inputsW(:,2:columns(s.inputsW));
      endif
      dlds=s.gradientX;
    endfunction
    
    ## Recalcula los pesos luego de la propagacion hacia atras
    function recalW(s, alpha)
      s.inputsW=s.funcDes.desc(s.gradientW, s.inputsW, alpha);
    endfunction
  endmethods
endclassdef
