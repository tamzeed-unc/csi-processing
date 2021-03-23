function [target]=func_aoam(csi_stream)
    max(abs(csi_stream))
%     csi_scale=csi_stream/(max(abs(csi_stream)));
%     csi_scale=csi_stream;
    csi_scale=(csi_stream-mean(csi_stream))/std(csi_stream);
% %     dirname='profiles/csi_04_26/ori/';
    dirname='aoa_profiles/';

    dir_temp=strcat(dirname,'*.csv');
    dir1 = dir(dir_temp);
    min_n=intmin;
    intmin
    label=-1;
    target=-1;
    ind=-1;
    sig=[];
    for f1 = dir1'
        file_n=strcat(dirname,f1.name);
        
       
        if(strcmp(f1.name,'tamzeed.csv'))
            label=3;
        end
        if(strcmp(f1.name,'bashima.csv'))
            label=4;
        end
        M = csvread(file_n);
        [mm,nm]=size(M);
        for i=1:mm
            temp=M(i,:);
            temp= temp(find(temp,1,'first'):find(temp,1,'last'));
%             ttt=temp;
%             temp=temp/(max(abs(temp)));
            temp=(temp-mean(temp))/std(temp);
%             f1.name
%             dist=dtw(temp,csi_scale);
             dist=max(xcorr(csi_scale,temp));
% 
%             if(label==4)
%                 dist
%                 
%             end
            if(dist>min_n)
%                 dist
               
                ind=i;
                min_n=dist;
                target=label;
                sig=temp;
%                 figure()
%                 plot(temp)
            end
        end
        

%         break;

ind
min_n
target
% sig=(sig-mean(sig))/std(sig);
% figure(20)
% plot(sig)
% figure()
% dtw(csi_scale,sig)

end