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
dir = '/run/media/marissela/JORGE_OLD/ROMS_SIMULATIONS/ROMS6B_VINCENT_SIMULATION/';

%% Create a new directory to store input for Kinesis model
new_dir = 'interanualVerticalMeanUV'; % Name of new directory to store input for Kinesis model
mkdir([dir , new_dir]);
dir2 = [dir, new_dir, '/'];

%% It's only necessary superficial values
N = 32; % Nivel rho que representa la superficie
ZI = [-10 -15 -20]; % Niveles Z deseado en para obtner el promedio de las corrientes

%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% DON'T CHANGE ANYTHIG AFTER HERE
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% Extract interannual variables
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%

for year = 1995:1999
    
    for month = 1:12
        % You can add variables if necessary
        nc_file = [dir,'roms6b_avg.Y',num2str(year),'.M',num2str(month),'.rl1b.nc'];
        disp (['Reading ... ' nc_file]); % Display current nc file name
        ncload(nc_file, 'lon_rho','lat_rho','u','v','time_step','h');
        lon = reshape(lon_rho',[],1); 
        lat = reshape(lat_rho',[],1); 
        time_step = time_step(:,4);
        
        for i = 1:length(time_step)
            %% Interpolation of u & v en niveles Z
            ur    = u(i,:,:,:); ur = squeeze(ur); ur = u2rho_3d(ur);
            vr    = v(i,:,:,:); vr = squeeze(vr); vr = v2rho_3d(vr);
            
            vtransform = 1; 
            ll=length(ZI);
            zr = zlevs(h,0*h,6,0,10,N,'r',vtransform);


            for iz=1:ll 
                varu(:,:,iz) = sigmatoz(ur,zr,ZI(iz));
                varv(:,:,iz) = sigmatoz(vr,zr,ZI(iz));
            end;
            
            ur = nanmean(varu,3);
            vr = nanmean(varv,3);
            
            ur    = reshape(ur',[],1);
            vr    = reshape(vr',[],1);
            
            ur    = [lon lat ur];
            vr    = [lon lat vr];

            save([dir2,num2str(year),'_',num2str(month),'_','u' num2str(i) '.txt'],'ur','-ascii');
            save([dir2,num2str(year),'_',num2str(month),'_','v' num2str(i) '.txt'],'vr','-ascii');

        end
    end
end

%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%
%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%
