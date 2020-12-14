classdef Normal < handle 
  properties 
  endproperties
  methods
    function s = Normal ()
    endfunction
    function w = desc(s, dW, W, a)
      w = W-a*dW;
    endfunction
  endmethods
endclassdef