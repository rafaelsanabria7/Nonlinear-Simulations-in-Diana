% Post-processing data results from .tb document in real-time
% rafael sanabria 2019
% clear memory
clear all; clc; close all;

ft = 3.0;
E = 30000;
Gf = 0.135;
Gc = 33.75; 
fc = 30;
h = sqrt(2*50*50); %linear element

% characteristic strains
alpha_c3 = -1/3*fc/E;
alpha_c = 5*alpha_c3;
alpha_u = alpha_c - 3/2*Gc/(h*fc);

% intervals
alpha_j1 = (0:-0.00001:alpha_c3);
alpha_j2 = (alpha_c3:-0.0001:alpha_c);
alpha_j3 = (alpha_c:-0.0001:alpha_u);

f1 =  -fc*1/3*alpha_j1/alpha_c3;

f2 =  -fc*1/3*(1 +4*((alpha_j2-alpha_c3)/(alpha_c-alpha_c3)) - 2*((alpha_j2-alpha_c3)/(alpha_c-alpha_c3)).^2);

f3 =  -fc*(1 -((alpha_j3-alpha_c)/(alpha_u-alpha_c)).^2);

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
plot(EYY,SYY,'b.-')
title('Compression tensile')
xlabel('Eknn') 
ylabel('Sknn') 

plot(alpha_j1,f1)
plot(alpha_j2,f2)
plot(alpha_j3,f3)

step = step + 1;


end
delete(t) 
