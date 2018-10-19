ncload ('G:/Ascat_clim/newperush_grd.nc', 'lon_rho', 'lat_rho')
load 'C:/Users/ASUS/Desktop/LineIndex.txt'

% Tranformar u/v to rho viento diario
dir = 'G:/Ascat_daily/frc/';
lonlat = zeros(size(LineIndex,1), 2);

for year = 2008:2012
    nc_file = [dir, 'newperush_frc_ascatdaily_', num2str(year) , '.nc'];
    disp(nc_file)

    ncload(nc_file, 'sustr', 'svstr');
    
    userie = zeros(size(LineIndex,1), size(sustr,1));
    vserie = zeros(size(LineIndex,1), size(sustr,1));
    
    for i = 1:size(sustr, 1)
        u =sustr(i,:,:); u =squeeze(u); u =u2rho_2d(u);% u =reshape(u,[],1);
        v =svstr(i,:,:); v =squeeze(v); v =v2rho_2d(v);% v =reshape(v,[],1);
        
        for j = 1:size(LineIndex,1)
            userie(j,i) = u(LineIndex(j,2) , LineIndex(j,1));
            vserie(j,i) = v(LineIndex(j,2) , LineIndex(j,1));
            
            if(i == 1 && year == 2008)
               lonlat(j,2) = lon_rho(LineIndex(j,2), LineIndex(j,1)) - 360;
               lonlat(j,1) = lat_rho(LineIndex(j,2), LineIndex(j,1));
            end
        end 
    end
    save([dir, 'sustr', num2str(year), '.txt'], 'userie', '-ascii');
    save([dir, 'svstr', num2str(year), '.txt'], 'vserie', '-ascii');
end
save([dir, 'lonlat', '.txt'], 'lonlat', '-ascii');

% Tranformar u/v to rho viento climatologico
dir = 'G:/Ascat_clim/frc/';
nc_file = [dir, 'newperush_frc_ascatclim_2008_2012.nc'];
ncload(nc_file, 'sustr', 'svstr');
disp(nc_file)

userie = zeros(size(LineIndex,1), size(sustr,1));
vserie = zeros(size(LineIndex,1), size(sustr,1));

lonlat = zeros(size(LineIndex,1), 2);

for i = 1:size(sustr, 1)
    u =sustr(i,:,:); u =squeeze(u); u =u2rho_2d(u);% u =reshape(u,[],1);
    v =svstr(i,:,:); v =squeeze(v); v =v2rho_2d(v);% v =reshape(v,[],1);
    
    for j = 1:size(LineIndex,1)
        userie(j,i) = u(LineIndex(j,2) , LineIndex(j,1));
        vserie(j,i) = v(LineIndex(j,2) , LineIndex(j,1));
        
        if(i == 1)
           lonlat(j,2) = lon_rho(LineIndex(j,2), LineIndex(j,1)) - 360;
           lonlat(j,1) = lat_rho(LineIndex(j,2), LineIndex(j,1));
        end
    end 
end

save([dir, 'sustr', '.txt'], 'userie', '-ascii');
save([dir, 'svstr', '.txt'], 'vserie', '-ascii');
save([dir, 'lonlat', '.txt'], 'lonlat', '-ascii');
