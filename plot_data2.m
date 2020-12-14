## Copyright (C) 2020 Pablo Alvarado
##
## Este archivo forma parte del material del Proyecto 1 del curso:
## EL5852 Introducción al Reconocimiento de Patrones
## Escuela de Ingeniería Electrónica
## Tecnológico de Costa Rica


## usage plot_data(X,Y,mono)
##
## This function plots data assuming each row of X has
## a datum and the corresponding class is distributed in the
## rows of Y, i.e. each row of Y is a vector with only one of
## its elements equal to one, and the position of that one in
## the vector indicates the corresponding class.
##
## This plots the data constructed with create_data
##
## X: holds the 2D data, one sample in each row
## Y: holds the class of each sample, in the corresponding row
## mono: if given, the internal color palette is modified
##       [r,g,b]: by the given color 
##       "brighter": by a brighter color
##       "darker": by a darker color
##       "complementary": by the complementary color
function plot_data2(X,Y,mono=[])
  ## Set all the non-zero entries with the corresponding index
  idx=ones(rows(Y),1)*[1:columns(Y)];
  idx.*=Y;
  idx=nonzeros(idx'(:));

  ## Markers and colors a little darker than the ones usually
  ## used to paint the regions
  markers = {'o';'o';'o';'o';'o';'o';'o';'o';'o';'o'};
  colors  = [ 1  ,0  ,0  ;
              0  ,0.7,0  ;
              0  ,0  ,0.8; 
              1  ,0  ,1  ;
              0  ,0.7,0.7;
              0.8,0.6,0.0; 
              0.8,0.5,0.2;
              0.2,0.5,0.3;
              0.6,0.3,0.8;
              0.6,0.1,0.4;
              0.6,0.8,0.3;
              0.1,0.4,0.6;
              0.5,0.5,0.5];
  
  if (ischar(mono))
    if (strcmp(mono,"brighter"))
      colors=0.5*(ones(size(colors))+colors);
    elseif (strcmp(mono,"darker"))
      colors*=0.5;
    elseif (strcmp(mono,"complementary"))
      colors=ones(size(colors))-colors;
    endif
  elseif (length(mono)==3)
    colors=ones(rows(colors),1)*reshape(mono,1,3);
  endif
  for i=[1:columns(Y)]
    ## Select data for the current i-th class
    xx=X(idx==i,1);
    yy=X(idx==i,2);
    
    ## We cannot simply pass the arguments to the plot, so we have
    ## to build a string of the whole plot command and evaluate it
    mk=markers{mod(i-1,length(markers))+1};
    cl=mat2str(colors(mod(i-1,rows(colors))+1,:),3);
    
    plotstr=strcat("plot(xx,yy,'",mk,"',\"markeredgecolor\",'k',\"markerfacecolor\",",cl,",\"markersize\",7)");
    eval(plotstr);    

    hold on;
  endfor

  daspect([1,1]);
  grid;
endfunction
