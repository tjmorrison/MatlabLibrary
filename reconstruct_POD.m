function [ u_rec ] = reconstruct_POD( M, phiU, nvector )
fprintf('Begin POD Reconstruction \n')
nsnap = size(M,1);
nperiod = size(M,2);

nvector_size = size(nvector,2);
a = zeros(nsnap,nvector_size);

%Calcluate coefficent
for t = 1:nsnap
    for i=nvector
        a(t,i) = M(t,:)*phiU(:,i);
    end
   
end

%Reconstruct signal
u_rec = zeros(nperiod,nsnap);
for t = 1:nsnap
    for i = nvector
        u_rec(:,t)  = u_rec(:,t)+a(t,i).*phiU(:,i);
    end
end

end

