function [T] = load_TIR_Tdata(path,num_chunks)
%num chunks of 15 minute data to load
switch num_chunks
    case 1 
        temp = load(strcat(path,'surf_temp1.mat'));
        Nx = size(temp.surf_temp1,1);
        Ny = size(temp.surf_temp1,2);
        t_quarter = size(temp.surf_temp1,3);
        T = zeros(Nx,Ny,t_quarter*num_chunks);
        T(:,:,1:t_quarter) = temp.surf_temp1;
        clear temp;
    case 2 
        temp = load(strcat(path,'surf_temp1.mat'));
        Nx = size(temp.surf_temp1,1);
        Ny = size(temp.surf_temp1,2);
        t_quarter = size(temp.surf_temp1,3);
        T = zeros(Nx,Ny,t_quarter*num_chunks);
        T(:,:,1:t_quarter) = temp.surf_temp1;
        clear temp;
        
        temp = load(strcat(path,'surf_temp2.mat'));
        T(:,:,(t_quarter+1):(t_quarter*2)) = temp.surf_temp2;
        clear temp;

    case 3 
        temp = load(strcat(path,'surf_temp1.mat'));
        Nx = size(temp.surf_temp1,1);
        Ny = size(temp.surf_temp1,2);
        t_quarter = size(temp.surf_temp1,3);
        T = zeros(Nx,Ny,t_quarter*num_chunks);
        T(:,:,1:t_quarter) = temp.surf_temp1;
        clear temp;
        
        temp = load(strcat(path,'surf_temp2.mat'));
        T(:,:,(t_quarter+1):(t_quarter*2)) = temp.surf_temp2;
        clear temp;
        
        temp = load(strcat(path,'surf_temp3.mat'));
        T(:,:,((t_quarter*2)+1):(t_quarter*3)) = temp.surf_temp;
        clear temp;
    case 4
         temp = load(strcat(path,'surf_temp1.mat'));
        Nx = size(temp.surf_temp1,1);
        Ny = size(temp.surf_temp1,2);
        t_quarter = size(temp.surf_temp1,3);
        T = zeros(Nx,Ny,t_quarter*num_chunks);
        T(:,:,1:t_quarter) = temp.surf_temp1;
        clear temp;
        
        temp = load(strcat(path,'surf_temp2.mat'));
        T(:,:,(t_quarter+1):(t_quarter*2)) = temp.surf_temp2;
        clear temp;
        
        temp = load(strcat(path,'surf_temp3.mat'));
        T(:,:,((t_quarter*2)+1):(t_quarter*3)) = temp.surf_temp;
        clear temp;
        
        temp = load(strcat(path,'surf_temp4.mat'));
        T(:,:,((t_quarter*3)+1):(t_quarter*4)) = temp.surf_temp;
        clear temp;
end

end