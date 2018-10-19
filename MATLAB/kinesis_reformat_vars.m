close all
clear all

% Ruta del directorio donde se ubican los inputs
path = 'D:/ROMS_SIMULATIONS/ROMS6B_VINCENT_SIMULATION/climatologyM/zlev10/c_0.5/';
files = dir ([path '*.txt']);

for i = 1: size(files,1)
    dat = dlmread ([path files(i).name]);
    save([path files(i).name],'dat','-ascii');
    disp([path files(i).name])
end
%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%
%%%%%% %%%%%% %%%%%% %%%%%%   END OF PROGRAM  %%%%%% %%%%%% %%%%%% %%%%%%