function [T] = load_TIR_Tdata(path);

temp = load(strcat(path,'surf_temp1.mat'));
Nx = size(temp,1);
Ny = size(temp,2);
t_quarter = size(temp,3);
T = zeros(Nx,Ny,t_quarter*4);
T(:,:,1:t_quarter) = temp.surf_temp1;
clear temp;

temp = load(strcat(path,'surf_temp2.mat'));
T(:,:,(t_quarter+1):(t_quareter*2)) = temp.surf_temp2;
clear temp;

temp = load(strcat(path,'surf_temp3.mat'));
T(:,:,((t_quarter*2)+1):(t_quareter*3)) = temp.surf_temp;
clear temp;

temp = load(strcat(path,'surf_temp4.mat'));
T(:,:,((t_quarter*3)+1):(t_quareter*4)) = temp.surf_temp;
clear temp;

end