% Post-processing data results from .tb document in real-time
% rafael sanabria 2019
% clear memory
clear all; clc; close all;

ft = 3.0;
E = 30000;
Gf = 0.135;
h = sqrt(2*50*50); % linear element
c1 = 3;
c2 = 6.93;
epsc = ft/E;
epsu = 5.136*Gf/(ft*h); 
eps = (0:0.0001:epsu);
eps_total = epsc + eps;
eps_total_ult = eps_total(end);
crackwidth = (epsu-epsc)*50;

sigma = ft*((1+(c1.*eps/epsu).^3).*exp(-c2.*eps/epsu)-eps/epsu.*(1+c1^3).*exp(-c2));

for step = 1:1
    
t = timer('TimerFcn', 'stat=false; disp(''update!'')',... 
                 'StartDelay',1);
start(t)

stat=true;
while(stat==true)
  disp('.')
  pause(1)
end

output = strcat('Eknn','.tb'); 

FileInfo = dir(output) ;
TimeStamp = FileInfo.date;
% Get individual components of date & time in 1 Sec resolution
[Y, M, D, H, MN, S] = datevec(FileInfo.datenum);

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
            lineloc=strfind(readline,'1');
            if isempty(lineloc)==0
                %stores line number
                srcline(j,1)=i;
                line = regexp(readline,'\s','split');
                aux = line(~cellfun('isempty',line));
                if strcmp(aux{:,1},'1') == 1
                Eknn(k) =  str2double(aux{3});
                k = k + 1;
                end
            end
            i=i+1;
       end
 fclose(fid);
 
 output_2 = strcat('Sknn','.tb');  
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
            lineloc=strfind(readline,'1');
            if isempty(lineloc)==0
                %stores line number
                srcline(j,1)=i;
                line = regexp(readline,'\s','split');
                aux = line(~cellfun('isempty',line));
                if strcmp(aux{:,1},'1') == 1
                  Sknn(k) =  str2double(aux{3});
                   k = k + 1;
                end
               
            end
            i=i+1;
       end
 fclose(fid);

 
  output_3 = strcat('SYY','.tb');  
 fid = fopen(output_3);      
        i = 1;
        j = 1;
        k = 1;
        flag=0;
        
       while flag==0 
            readline=fgetl(fid);
            if readline==-1
                flag=1;
            end
            lineloc=strfind(readline,'1');
            if isempty(lineloc)==0
                %stores line number
                srcline(j,1)=i;
                line = regexp(readline,'\s','split');
                aux = line(~cellfun('isempty',line));
                if strcmp(aux{:,1},'1') == 1
                  SYY(k) =  str2double(aux{3});
                   k = k + 1;
                end
               
            end
            i=i+1;
       end
 fclose(fid);
 
 output_4 = strcat('EYY','.tb');  
 fid = fopen(output_4);      
        i = 1;
        j = 1;
        k = 1;
        flag=0;
        
       while flag==0 
            readline=fgetl(fid);
            if readline==-1
                flag=1;
            end
            lineloc=strfind(readline,'1');
            if isempty(lineloc)==0
                %stores line number
                srcline(j,1)=i;
                line = regexp(readline,'\s','split');
                aux = line(~cellfun('isempty',line));
                if strcmp(aux{:,1},'1') == 1
                  EYY(k) =  str2double(aux{3});
                   k = k + 1;
                end
               
            end
            i=i+1;
       end
 fclose(fid); 
 
 
hold on
plot( [0, sigma/E + eps],[0, sigma],'r-');
plot(Eknn + Sknn/E,Sknn,'k-')
plot(EYY,SYY,'b.-')
title('Uniaxial tensile')
xlabel('Eknn') 
ylabel('Sknn') 
step = step + 1;

 fig = gcf;
 fig.PaperPositionMode = 'auto'
 fig_pos = fig.PaperPosition;
 fig.PaperSize = [fig_pos(3) fig_pos(4)];
 print(fig,'Hordijk','-dpdf')


end
delete(t) 
