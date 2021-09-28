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
dir = 'G:/ROMS_SIMULATIONS/ROMS6B_VINCENT_SIMULATION/';

%% Create a new directory to store input for Kinesis model
new_dir = 'climatologyM'; % Name of new directory to store input for Kinesis model
mkdir([dir , new_dir]);
dir2 = [dir, new_dir, '/'];

%% It's only necessary superficial values
N = 32; % Nivel rho que representa la superficie
ZI = -10; % Niveles Z deseado para obtener las variables

%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% DON'T CHANGE ANYTHING AFTER HERE
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%
% Extract climatological variables
%%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%% %%%%%%

for month = 1:12
    % You can add variables if necessary
    nc_file = [dir, new_dir,num2str(month),'.nc'];
    disp (['Reading ... ' nc_file]); % Display current nc file name
    ncload(nc_file, 'lon_rho','lat_rho','temp','DCHL','u','v','time_step','h','ZOO','MESO');
    lon = reshape(lon_rho',[],1);
    lat = reshape(lat_rho',[],1); 
    time_step = time_step(:,4);
        
    for i = 1:length(time_step)
        %% Interpolation of variables en niveles Z
        tempr = temp(i,:,:,:) ; tempr = squeeze(tempr);
        DCHLr = DCHL(i,:,:,:) ; DCHLr = squeeze(DCHLr);
        ur    = u(i,:,:,:)    ; ur = squeeze(ur); ur = u2rho_3d(ur);
        vr    = v(i,:,:,:)    ; vr = squeeze(vr); vr = v2rho_3d(vr);
        zr    = ZOO(i,:,:,:)  ; zr = squeeze(zr);
        mr    = MESO(i,:,:,:) ; mr = squeeze(mr);
            
        vtransform = 1; 
        ll = length(ZI);
        zl = zlevs(h,0*h,6,0,10,N,'r',vtransform);

        for iz = 1:ll
            vart(iz,:,:) = sigmatoz(tempr,zl,ZI(iz));
            varc(iz,:,:) = sigmatoz(DCHLr,zl,ZI(iz));
            varu(iz,:,:) = sigmatoz(ur,zl,ZI(iz));
            varv(iz,:,:) = sigmatoz(vr,zl,ZI(iz));
            varz(iz,:,:) = sigmatoz(zr,zl,ZI(iz));
            varm(iz,:,:) = sigmatoz(mr,zl,ZI(iz));
        end;
            
        for j = 1:length(ZI)
            tempr = squeeze(vart(j,:,:));
            DCHLr = squeeze(varc(j,:,:));
            ur    = squeeze(varu(j,:,:));
            vr    = squeeze(varv(j,:,:));
            zr    = squeeze(varz(j,:,:));
            mr    = squeeze(varm(j,:,:));
                
            tempr = reshape(tempr',[],1);
            DCHLr = reshape(DCHLr',[],1);
            ur    = reshape(ur',[],1);
            vr    = reshape(vr',[],1);
            zr    = reshape(zr',[],1);
            mr    = reshape(mr',[],1);
                
            tempr = [lon lat tempr];
            DCHLr = [lon lat DCHLr];
            ur    = [lon lat ur];
            vr    = [lon lat vr];
            zr    = [lon lat zr];
            mr    = [lon lat mr];
 
            mkdir([dir , new_dir, '/zlev',num2str(abs(ZI(j)))], '/');
            subdir = [dir , new_dir, '/zlev',num2str(abs(ZI(j))), '/'];

            save([subdir,num2str(2000),'_',num2str(month),'_','t' num2str(i) '.txt'],'tempr','-ascii');
            save([subdir,num2str(2000),'_',num2str(month),'_','c' num2str(i) '.txt'],'DCHLr','-ascii');
            save([subdir,num2str(2000),'_',num2str(month),'_','u' num2str(i) '.txt'],'ur','-ascii');
            save([subdir,num2str(2000),'_',num2str(month),'_','v' num2str(i) '.txt'],'vr','-ascii');
            save([subdir,num2str(2000),'_',num2str(month),'_','z' num2str(i) '.txt'],'zr','-ascii');
            save([subdir,num2str(2000),'_',num2str(month),'_','m' num2str(i) '.txt'],'mr','-ascii');
        end
   end    
end
%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%
%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%