pkg load statistics;
ann = red();
ann_validation=red();
clc();
tic;

## Cantidad de datos de entrenamiento a usar ##
cantDat = 4000;

## Cantidad de clases a usar ##
cantClass = 6;

## Figura a usar ##
## "spirals"
## "radial"
## "pie"
## "horizontal"
## "vertical"
## "curved"
fig = "spirals";

## Entrena la red o solo la prueba ##
train=true;

## Entrena la red desde cero ##
trainZero=true;

## Cantidad de capas requeridas, incluyendo la de entrada ## 
## y la salida, sin contar la capa de error ##
cantCap=4;

## Cantidad de neuronas por capa ##
## Pongase el numero en la posicion del vector segun la capa que se quiera ##
## Cantidad de neuronas de la ultima capa bloqueada a la cantidad de clases ##
neuPorCap=[4,5,4,cantClass];

## Funciones de activacion ##
## 1 - Sigmoide
## 2 - ReLU
## 3 - SoftMax ## Advertencia ## Solo funciona en la ultima capa junto con Cross_Entropy
## 4 - Leaky ReLU
## 5 - Tangente Hiperbolico
## Pongase los numeros en la posicion del vector de la misma posicion de capa ##
funcAct = [1,5,4,3];

## Funciones de Descenso ##
## 1 - Descenso por gradiente estocastico
## 2 - Descenso por Momentum
## 3 - Descenso por Adam
## Pongase los numeros en la posicion del vector de la misma posicion de capa ##
funcDes=[1,2,2,2];

## Funcion de Error ##
## 1 - MSE
## 2 - Cross_Entropy ## Solo usar con Softmax en ultima capa
funcErr = 2;

## Cantidad de elementos por minilote ##
ann.elemPorMin=100;

## Cantidad de epocas a usar ##
ann.cantEpo=400; 

## Parametro Alpha usado ##
ann.alpha=0.01;

[trainData, Y] = create_data(cantDat, cantClass, fig);
[trainData2, Y2] = create_data(cantDat, cantClass, fig);

if(train)
  ann.inputsX=trainData;
  ann.inputsY = Y;
  ann_validation.inputsX=trainData2;
  ann_validation.inputsY = Y2;
  ann.train(cantCap, neuPorCap, columns(trainData), trainZero, funcAct, funcDes, funcErr, ann_validation);
  ann.saveData();
else
  ann.loadData();
endif
ann.hipotesis();
toc