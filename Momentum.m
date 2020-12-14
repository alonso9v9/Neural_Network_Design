classdef Momentum < handle 
  properties 
    Bo = 0.9;
    Vo = [];
  endproperties
  methods
    function s = Momentum ()
      s.Bo = 0.9;
      s.Vo = [];
    endfunction
    function w = desc(s, dW, W, a)
      s.Vo = s.Bo*s.Vo + (1-s.Bo)*dW;
      w = W-a*s.Vo;
    endfunction
  endmethods
endclassdef