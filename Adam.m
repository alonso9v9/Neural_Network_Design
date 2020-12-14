classdef Adam < handle 
  properties 
    Bo = 0.9;
    Bi = 0.99;
    Vo = [];
    So = [];
    Delta = 0.0001;
  endproperties
  methods
    function s = Adam ()
      s.Bo = 0.9;
      s.Bi = 0.99;
      s.Vo = [];
      s.So = [];
      s.Delta = 0.001;
    endfunction
    function w = desc(s, dW, W, a)
      s.Vo = s.Bo*s.Vo + (1-s.Bo)*dW;
      s.So = s.Bi*s.So + (1-s.Bi)*(dW).^(2);
      w = W-a*s.Vo./sqrt(s.So + s.Delta);
    endfunction
  endmethods
endclassdef
