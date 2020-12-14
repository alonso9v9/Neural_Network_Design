function l=logsoft(x)
  x=x.-max(x')';
  a=exp(x);
  if (columns(x)==1)
     l=a./sum(a);
  else
     l=a./sum(a,2);
  endif
  
endfunction