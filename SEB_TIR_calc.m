function [ q_air, q_soil, E_soil ] = SEB_TIR_calc( tau_soil, dt, Cp_soil, dz, mu_s ,T_deepsoil,T, Net_Radiation)
% Heat flux calculator - 
%Iterates through time

%local Variables
t_rad=1; Nx = size(T,1);Ny = size(T,2);Nt = size(T,3);
numAVG_windows = tau_soil/dt; %thermal time [s]
Navg = floor(Nt/numAVG_windows);
index_5minVars =300/tau_soil; %MUST BE 5 minutes based on tau soil

%allocate memory
q_air = zeros(Nx,Ny,Navg);
q_soil = zeros(Nx,Ny,Navg);
E_soil = zeros(Nx,Ny,Navg);


tic
%Iterate through time chunks
for tavg = 1:1:Navg 
    %counter
    if mod(tavg,100) == 0
       tavg 
    end
    for x = 1:Nx
        for y = 1:Ny
            if T(x,y,tavg) == 'NaN'
                q_air(x,y,tavg) = NaN;
            elseif T(x,y,tavg) ~= 'NaN'
                tAVG_start = numAVG_windows*(tavg-1)+1;
                tAVG_end = numAVG_windows*tavg;
                
                %averaging over our window for smoothing
                dTdt_total = 0;
                q_soil_total = 0;
                
                %smoothing loop 
                for avg_index = tAVG_start:1:tAVG_end-1
                    dTdt_total = dTdt_total + ddz(T(x,y,avg_index),T(x,y,avg_index+1),dt);
                    q_soil_total= q_soil_total + mu_s*(T(x,y,avg_index)-T_deepsoil);
                end
                
                %Filtered camera dependent variables
                smoothed_dTdt = dTdt_total / (tAVG_end - tAVG_start);
                q_soil(x,y,tavg) = q_soil_total / (tAVG_end - tAVG_start);
          
                %find energy stoarge term: E_soil=rho_s*C_s*dz*dT/dt
                E_soil(x,y,tavg) = Cp_soil * dz * smoothed_dTdt;
                
                %find q'' into air: q''_air=R-q''_s-E_s
                q_air(x,y,tavg) = Net_Radiation(x,y)-q_soil(x,y,tavg)-E_soil(x,y,tavg);
                
            end
        end
    end         
    %indexing the 5 min values 
%     if rem(tavg,index_5minVars)==0
%                 t_rad=t_rad+1;
%     end
    
end


end

