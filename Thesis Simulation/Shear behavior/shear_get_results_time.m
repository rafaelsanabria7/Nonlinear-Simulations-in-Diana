% Post-processing data results from .tb document in real-time
% rafael sanabria 2019
% clear memory
clear all; clc; close all;

ft = 3.0;
E = 30000;
v = 0.2;
G = E/(2*(1+v));
fc = 30;


for step = 1:1
    
t = timer('TimerFcn', 'stat=false; disp(''update!'')',... 
                 'StartDelay',1);
start(t)

stat=true;
while(stat==true)
  disp('.')
  pause(1)
end

output = strcat('Sknt','.tb'); 

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
                Sknt(k) =  str2double(aux{4});
                k = k + 1;
                end
            end
            i=i+1;
       end
 fclose(fid);
 
 output_2 = strcat('Gknt','.tb');  
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
                  Gknt(k) =  str2double(aux{3});
                   k = k + 1;
                end
               
            end
            i=i+1;
       end
 fclose(fid);

 
  output_3 = strcat('SXY','.tb');  
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
                  SXY(k) =  str2double(aux{3});
                   k = k + 1;
                end
               
            end
            i=i+1;
       end
 fclose(fid);
 
 output_4 = strcat('GXY','.tb');  
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
                  GXY(k) =  str2double(aux{3});
                   k = k + 1;
                end
               
            end
            i=i+1;
       end
 fclose(fid); 
 
 
output_5 = strcat('Eknn','.tb');  
 fid = fopen(output_5);      
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

end
delete(t) 

hold on
%plot(Sknt,Gknt,'b.-')
plot(-Gknt,(Sknt./Gknt)/G,'b.-')
title('Shear behavior')
xlabel('Gknt') 
ylabel('beta') 
ylim([0 1])

figure
hold off
plot(-GXY,SXY,'r.-')
title('Shear behavior')
xlabel('GXY') 
ylabel('SXY') 
