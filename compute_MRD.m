function [D,a,b] = compute_MRD (a,b,M,Mx)

for ims=0:M-Mx  
  ms=M-ims;
  l=2.^ms;
  nw=(2.^M)./l;
  sumab=0.;

  
  for i=1:nw 
    k=(i-1)*l+1; za=a(k); zb=b(k);
    for j=k+1:k+l-1
      za=za+a(j); zb=zb+b(j);
    end
    za=za/l; zb=zb/l; sumab=sumab+za*zb;
    for j=k:i*l
      a(j)=a(j)-za; b(j)=b(j)-zb;
    end
  end
  if(nw>1), D(ms+1)=(sumab/nw); end;

end

 
