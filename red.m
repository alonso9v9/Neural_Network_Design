classdef red < handle
  properties
    ## Capas
    cap={capa(),2;capa(),3};
    ## Entrada de la red 
    inputsX=[];
    inputsX2=[];
    inputsY=[];
    inputsY2=[];
    ## Tasa de aprendizaje
    alpha = 0.01;
    ## Criterio de si se usa softmax
    pruebaSoft = false;
    ## Capa de error
    capErr=capaError();
    ## Elementos en un minilote
    elemPorMin=1;
    ## Cantidad de epocas
    cantEpo=100;
    Error = [];
    ErrorVal=[];
  endproperties
  
  methods
    function s=red()
      s.cap={capa(),2;capa(),3};
      s.inputsX=[];
      s.inputsY=[];
      s.inputsX2=[];
      s.inputsY2=[];
      s,alpha = 0.001;
      s.capErr=capaError();
      s.elemPorMin=1;
      s.cantEpo=100;
      s.pruebaSoft;
      s.Error = [];
      s.ErrorVal=[];
    endfunction
    
    #Crea numCap numero de capas con determinador numNeruons numeros de neuronas
    function creaCapas(s, numCap, numNeurons)
      s.cap={};
      for i=1:numCap
        s.cap=[s.cap;{capa(),numNeurons(i)}];
      endfor
    endfunction
    
    #Crea los pesos asociados a cada capa y los almacena en cada capa
    function creaPesos(s, cantEntr)
      s.cap{1,1}.creaPeso(s.cap{1,2},cantEntr);
      for i=2:rows(s.cap)
        s.cap{i,1}.creaPeso(s.cap{i,2}, s.cap{i-1,2});
      endfor
    endfunction
    
    function cambiaFunAct (s, funAct)
      for i = 1 : rows (s.cap) - 1
        s.cap {i,1}.cambFuncAct(funAct(i));
        if(funAct(i)==3)
          error("No es posible usar SoftMax en capas intermedias");
        endif
      endfor
      s.cap{i+1,1}.cambFuncAct(funAct(i+1));
      if(funAct(i+1) == 3)
        s.pruebaSoft = true;
      endif
    endfunction
    
    function cambiaFunDesc (s, funDesc)
      for i = 1 : rows (s.cap)
        s.cap {i,1}.cambFuncDes(funDesc(i));
      endfor
    endfunction
    
    function cambiaFunErr(s, funErr)
      if(funErr == 2)
        if(!s.pruebaSoft)
          error("No es posible usar Entriopia Cruzada sin Softmax");
        endif
      else
        if(s.pruebaSoft)
          error("No es posible usar Softmax sin Entriopia Cruzada");
        endif
      endif
      
      s.capErr.camFunc(funErr);
    endfunction
    
    #Guarda los pesos actuales creados
    function saveData(s)
      Wtot={s.cap{1,1}.inputsW};
      FuncActTot = {s.cap{1,1}.numFunAct};
      switch(s.cap{1,1}.numDescGra)
        case 1
          FuncDesTot = {{1}};
        case 2
          FuncDesTot = {{2, s.cap{1,1}.funcDes.Vo}};
        case 3
          FuncDesTot = {{3, s.cap{1,1}.funcDes.Vo, s.cap{1,1}.funcDes.So}};
        otherwise
      endswitch
      if(rows(s.cap)>1)
        for i=2:rows(s.cap)
          Wtot=[Wtot,{s.cap{i,1}.inputsW}];
          FuncActTot = [FuncActTot, {s.cap{i,1}.numFunAct}];
          switch(s.cap{i,1}.numDescGra)
            case 1
              FuncDesTot = [FuncDesTot, {{1}}];
            case 2
              FuncDesTot = [FuncDesTot,{{2, s.cap{i,1}.funcDes.Vo}}];
            case 3
              FuncDesTot = [FuncDesTot,{{3, s.cap{i,1}.funcDes.Vo, s.cap{i,1}.funcDes.So}}];
            otherwise
          endswitch
        endfor
      endif
      if(s.pruebaSoft)
        funcErr = 2;
      else
        funcErr = 1;
      endif
      Datos = {Wtot, FuncActTot, FuncDesTot, s.inputsX, s.inputsY, funcErr, s.Error, s.ErrorVal};
      save '-binary' 'data.dat' Datos;
    endfunction
    
    #Carga los pesos guardados anteriormente
    function loadData(s)
      if(exist('data.dat', "file")==2)
        arch=load('-binary', 'data.dat');
        Datos=arch.Datos;
        Wtot = Datos{1};
        FuncActTot = cell2mat(Datos{2});
        FuncDesTot = Datos{3};
        s.inputsX = Datos{4};
        s.inputsY = Datos{5};
        funcErr = Datos{6};
        s.Error = Datos{7};
        s.ErrorVal=Datos{8};
        numNeurons=[];
        for i=1:columns(Wtot)
          numNeurons=[numNeurons, rows(Wtot{1,i})];
        endfor
        s.creaCapas(columns(Wtot), numNeurons);
        for i=1:columns(Wtot)
          s.cap{i,1}.inputsW=Wtot{i};
          s.cap{i,1}.cambFuncDes(FuncDesTot{i}{1});
          if(FuncDesTot{i}{1} == 2)
            s.cap{i,1}.funcDes.Vo = FuncDesTot{i}{2};
          elseif(FuncDesTot{i}{1} == 3)
            s.cap{i,1}.funcDes.Vo = FuncDesTot{i}{2};
            s.cap{i,1}.funcDes.So = FuncDesTot{i}{3};
          endif
        endfor
        s.cambiaFunAct(FuncActTot);
        s.cambiaFunErr(funcErr);
      endif
    endfunction
    
    ## Prueba datos de entrada y crea el mapa de color
    function hipotesis(s)
      figure(1, "name", "Set de entrenamiento");
      hold off;
      plot_data(s.inputsX, s.inputsY);
      hold on;
      figure(2, "name", "Error segun la epoca");
      xlabel("Epoca");
      ylabel("Error");
      hold off;
      plot([1:s.cantEpo], s.ErrorVal, 'r', "linewidth",5);
      hold on;
      plot([1:s.cantEpo], s.Error, 'k', "linewidth",3);
      legend("Datos de Validacion", "Datos de Entrenamiento");
      figure(3, "name", "Set de entramiento con hipotesis");
      hold off;
      y=s.cap{1,1}.forward(s.inputsX);
      for i=2:rows(s.cap)
        y=s.cap{i,1}.forward(y);
      endfor
      y=y';
      [maxprob,maxk]=max(y);
      Y=zeros(rows(s.inputsX), rows(y));
      for i=1:columns(y)
        for h=1:rows(y)
          if(maxk(1,i)==h)
            Y(i,h)=1;
          endif
        endfor
      endfor
      plot_data(s.inputsX,Y);
      hold on;
      x=linspace(-1,1,512);## 256 elementos igualmente espaciados entre -1 y 1
      [GX,GY]=meshgrid(x,x);## GX 256 copias en filas de x, GY 256 copias en columnas de x
      FX = [GX(:) GY(:)];##FX es una matriz de k(clases) columnas 
      ##con la primera con el sesgo(1) y la segunda pos x y tercera pos y
      FZ=s.cap{1,1}.forward(FX);
      for i=2:rows(s.cap)
        FZ=s.cap{i,1}.forward(FZ);
      endfor
      FZ=FZ';
##      FZ = [FZ; ones(1,columns(FZ))-sum(FZ)]; ## Se le agrega la probabilidad de la ultima clase teniendo en cuenta que deben sumar 1
      ## A figure with the winners
      [maxprob,maxk]=max(FZ);## El primero almacena la maxima probabilidad que se presenta para cada
      ## elemento de entrenamiento y el segundo la fila(que seria la clase) para la cual tiene esa probabilidad

      figure(4,"name","Winner classes");
      hold off;

      winner=flip(uint8(reshape(maxk,size(GX))),1);## Todos los datos de prueba que era una matriz de 256, los vuelve a reacomodar en esa matriz
      ## y ademas a cada casilla le asigna la clase a la que pertenece
      cmap = [0,0,0; 1,0,0; 0,1,0; 0,0,1; 0.5,0,0.5; 0,0.5,0.5; 0.5,0.5,0.0];## Mapa de color
      wimg=ind2rgb(winner,cmap);
      imshow(wimg);
      hold on;
      
      figure(5,"name","Weighted winners");
      ccmap = cmap(2:1+columns(Y),:);
      cwimg = ccmap'*FZ;
      redChnl   = reshape(cwimg(1,:),size(GX));
      greenChnl = reshape(cwimg(2,:),size(GX));
      blueChnl  = reshape(cwimg(3,:),size(GX));
      
      mixed = flip(cat(3,redChnl,greenChnl,blueChnl),1);
      imshow(mixed);
      hold off;
      
      figure(6);
      hold off;
      image(x, -x, wimg);
##      imagesc(rot90(flipud(wimg),-1));
      set(gca,'YDir','normal');
      hold on;
##      s.inputsX(:,2) = s.inputsX(:,2)*-1;
      plot_data2(s.inputsX, s.inputsY);
      

      [ConfMat, exhaus,precision,f1,OA] = confusion(Y, s.inputsY);
      disp("Matriz de Confusion:");
      disp(ConfMat);
      disp("Exhaustividad:");
      disp(exhaus);
      disp("Precision:");
      disp(precision);
      disp("Valor F1:");
      disp(f1);
      disp("Precision General");
      disp(OA);
    endfunction
    
    function train(s, cantCap, neuPorCap, cantEntr, trainZero, funAct, funDesc, funcErr, red_val)
      if(trainZero)
        s.creaCapas(cantCap,neuPorCap);
        s.creaPesos(cantEntr);
        s.cambiaFunAct(funAct)
        s.cambiaFunDesc(funDesc);
        s.cambiaFunErr(funcErr);
        red_val.creaCapas(cantCap,neuPorCap);
        red_val.cambiaFunAct(funAct)
        red_val.cambiaFunDesc(funDesc);
        red_val.cambiaFunErr(funcErr);
      else
        s.loadData();
      endif
      if(s.cantEpo < 1)
        error("La cantidad de epocas no es valida");
      endif
      cantLot=ceil(rows(s.inputsX)/s.elemPorMin);
      s.Error=[];
      for h=1:s.cantEpo
        mixInd=randperm(rows(s.inputsX));
        num=0;
        for i=1:cantLot-1
          lotX=s.inputsX(mixInd(num+1:num+s.elemPorMin), :);
          s.capErr.realY=s.inputsY(mixInd(num+1:num+s.elemPorMin), :);
          y=s.cap{1,1}.forward(lotX);
          for i=2:rows(s.cap)
            y=s.cap{i,1}.forward(y);
          endfor
          s.capErr.inputsY=y;
          err=s.capErr.forward();
          y=s.capErr.backward();
          y=s.cap{rows(s.cap),1}.backward(y);
          s.cap{rows(s.cap),1}.recalW(s.alpha);
          for i=rows(s.cap)-1:-1:1
            y=s.cap{i,1}.backward(y);
            s.cap{i,1}.recalW(s.alpha);
          endfor
          num+=s.elemPorMin;
        endfor
        lotX=s.inputsX(mixInd(num+1:rows(s.inputsX)), :);
        s.capErr.realY=s.inputsY(mixInd(num+1:rows(s.inputsY)), :);
        y=s.cap{1,1}.forward(lotX);
        for i=2:rows(s.cap)
          y=s.cap{i,1}.forward(y);
        endfor
        s.capErr.inputsY=y;
        red_val.cap{1,1}.inputsW = s.cap{1,1}.inputsW;
        y=red_val.cap{1,1}.forward(red_val.inputsX);
        for i=2:rows(s.cap)
          red_val.cap{i,1}.inputsW = s.cap{i,1}.inputsW;
          y=red_val.cap{i,1}.forward(y);
        endfor
        red_val.capErr.realY = red_val.inputsY;
        red_val.capErr.inputsY=y;
        err_val = red_val.capErr.forward();
        err=s.capErr.forward();
        y=s.capErr.backward();
        y=s.cap{rows(s.cap),1}.backward(y);
        s.cap{rows(s.cap),1}.recalW(s.alpha);
        for i=rows(s.cap)-1:-1:1
          y=s.cap{i,1}.backward(y);
          s.cap{i,1}.recalW(s.alpha);
        endfor
        s.ErrorVal = [s.ErrorVal, err_val];
        s.Error=[s.Error,err];
      endfor
    endfunction
  endmethods
endclassdef