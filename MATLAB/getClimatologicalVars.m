%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% GET VARIABLES FROM ROMS FILES NEEDED FOR KINESIS MODEL
% aim1 = select and get variables from ROMS files
% aim2 = create a directory to save variables
% aim3 = save variables (.txt) in form [lon lat var]
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
close all
clear variables
clc

%% Directory where the files (ROMS files) are stored
dir = '/run/media/cimobp/JORGE_OLD/ROMS_SIMULATIONS/ROMS6B_VINCENT_SIMULATION/';

%% Create a new directory to store input for Kinesis model
new_dir = 'viejo'; % Name of new directory to store input for Kinesis model
mkdir([dir , new_dir]);
dir2 = [dir, new_dir, '/'];

%% It's only necessary superficial values
N = 32; % Nivel rho que representa la superficie
ZI = -15; % Niveles Z deseado en para obtner las variables

%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% DON'T CHANGE ANYTHIG AFTER HERE
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% Extract climatological variables
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%

for month = 1:12
    % You can add variables if necessary
    nc_file = [dir, new_dir, '_M',num2str(month),'.nc'];
    disp (['Reading ... ' nc_file]); % Display current nc file name
    ncload(nc_file, 'lon_rho','lat_rho','temp','DCHL','u','v','time_step','h');
    lon = reshape(lon_rho',[],1);
    lat = reshape(lat_rho',[],1); 
    time_step = time_step(:,4);
        
    for i = 1:length(time_step)
        %% Transform 4D variable (temp&chl) to 2D variable
        tempr = temp(i,N,:,:); tempr = squeeze(tempr); % Dato de superficie
        DCHLr = DCHL(i,N,:,:); DCHLr = squeeze(DCHLr); % Dato de superficie
        
        %% Convert matrix to vector variable
        tempr = reshape(tempr',[],1);
        DCHLr = reshape(DCHLr',[],1);

        %% Create variable data in form [lon lat var]
        tempr = [lon lat tempr];
        DCHLr = [lon lat DCHLr];
             
        %% Save variable data
        % Year 1
        save([dir2, num2str(2001),'_',num2str(month),'_','t' num2str(i) '.txt'],'tempr','-ascii');
        save([dir2, num2str(2001),'_',num2str(month),'_','c' num2str(i) '.txt'],'DCHLr','-ascii');

        %% Interpolation of u & v en niveles Z
        ur    = u(i,:,:,:); ur = squeeze(ur); ur = u2rho_3d(ur); % Dato en profundidad
        vr    = v(i,:,:,:); vr = squeeze(vr); vr = v2rho_3d(vr); % Dato en profundidad
        
        vtransform = 1; 
        ll=length(ZI);
        zr = zlevs(h,0*h,6,0,10,N,'r',vtransform);

        for iz = 1:ll 
            varu(iz,:,:) = sigmatoz(ur,zr,ZI(iz));
            varv(iz,:,:) = sigmatoz(vr,zr,ZI(iz));
        end;
   
        for j = 1:length(ZI) % Bucle para guardar las corrientes en diferentes niveles Z
            ur = squeeze(varu(j,:,:));
            ur = reshape(ur',[],1);
            ur = [lon lat ur];
            
            vr = squeeze(varv(j,:,:));
            vr = reshape(vr',[],1);
            vr = [lon lat vr];
        
            mkdir([dir , new_dir, '/uv',num2str(abs(ZI(j)))], '/');
            subdir = [dir , new_dir, '/uv',num2str(abs(ZI(j))), '/'];
            % Year 1
            save([subdir,num2str(2001),'_',num2str(month),'_','u' num2str(i) '.txt'],'ur','-ascii');
            save([subdir,num2str(2001),'_',num2str(month),'_','v' num2str(i) '.txt'],'vr','-ascii');
        end    
   end
end

%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%
%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%

