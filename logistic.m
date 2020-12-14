#!/usr/bin/octave-cli

## Función logística 1/1+exp(-x)
function l=logistic(x)
  l=1./(1+exp(-x));
endfunction
