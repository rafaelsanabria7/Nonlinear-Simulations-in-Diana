% Post-processing data results from .tb document in real-time
% rafael sanabria 2019
% clear memory
clear all; clc; close all;

LR_A_exp = load('LR_A.txt');    
LR_C_exp = load('LR_C.txt'); 

n_sample = 31;
for step = 31:n_sample
output = strcat('LR_',num2str(step),'_FORCE','.tb'); 
% Open model
fid = fopen(output);

        i = 1;
        j = 1;
        k = 1;
        flag=0;
        
       while flag==0
            readline=fgetl(fid);
            if readline==-1
                flag=1;
            end
            lineloc=strfind(readline,'5253');
            if isempty(lineloc)==0
                %stores line number
                srcline(j,1)=i;
                line = regexp(readline,'\s','split');
                aux = line(~cellfun('isempty',line));
                if strcmp(aux{:,1},'5253') == 1
                force_1(k) =  str2double(aux{2});
                k = k + 1;
                end
            end
            i=i+1;
       end
 fclose(fid);
 
 output_2 = strcat('LR_',num2str(step),'_DISP','.tb');  
 fid = fopen(output_2);      
        i = 1;
        j = 1;
        k = 1;
        flag=0;
        
       while flag==0 
            readline=fgetl(fid);
            if readline==-1
                flag=1;
            end
            lineloc=strfind(readline,'5253');
            if isempty(lineloc)==0
                %stores line number
                srcline(j,1)=i;
                line = regexp(readline,'\s','split');
                aux = line(~cellfun('isempty',line));
                if strcmp(aux{:,1},'5253') == 1
                   disp_1(k) =  str2double(aux{2});
                   k = k + 1;
                end
               
            end
            i=i+1;
       end
 fclose(fid);

%Load at specific displacement values
specific_disp = LR_C_exp(100:20:end,2);
A = [unique(disp_1(1:end-1)); unique(force_1(1:end-1)*4/1000)]'; 
% interpolation of P values for the speciifc displacement:
P_values(step,:) = interp1(A(:,1),A(:,2),specific_disp);
P_values(isnan(P_values))=0;


hold on
plot(disp_1, force_1*4/1000,'.-')
%plot(LR_C_exp(100:20:end,2), LR_C_exp(100:20:end,1),'k.-')
plot(LR_C_exp(:,2), LR_C_exp(:,1),'r.-')
title('LR Machine Learning')
ylim([0 300])
xlim([0 30])
xlabel('Displacement [mm]') 
ylabel('Load [kN]') 

% figure
% peaks(step) = max(force_1*4/1000);
% convergence(step) = sum(peaks)./step;
% plot(convergence,'r.-')

disp_1 = [];
force_1 = [];
end

%print new .txt file
save('load_values.txt', 'P_values', '-ascii', '-tabs')



% inputname = 'load_values';
% fid = fopen([inputname,'.txt'], 'w');
% for step = 1:n_sample
%     fprintf(fid,'%3.3f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f\n', P_values(step,:)');
% end
% fclose('all');

