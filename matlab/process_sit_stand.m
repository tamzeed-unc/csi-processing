
pca_comp=2;
target_len=800; %gesture size
label = '/sit_stand';
label_num=10;
folder_name='25_march_19'


thr=.02
check_done=2

% if(check_done==0)
    
files = dir(strcat('data/',folder_name,label,'/*.dat'));
for file = files'
  

    csi_stream_t=func_read_csi(strcat('data/',folder_name,label,'/',file.name));
    real_csi=abs(csi_stream_t);

    figure()
    plot(abs(real_csi(1,:)))


    denoised_csi=func_denoise(real_csi.',1,100,6);
    figure()
    plot(denoised_csi(:,pca_comp))

    denoised_csi_high_freq_old=func_denoise(real_csi.',30,100,6);
   
    denoised_csi_high_freq=denoised_csi_high_freq_old(:,pca_comp)
 

    diff_csi_old=diff(denoised_csi(:,pca_comp));
    diff_csi=diff_csi_old(600:end-400);
    figure()
    plot(abs(diff_csi))

    denoised_csi_cut=denoised_csi_high_freq(600:end-400);
    figure()
    plot(denoised_csi_cut)
    count_gest=0

    [peak_start,peak_end]=func_peak_detect(abs(diff_csi(1:end)).',thr);
    [mp,np]=size(peak_start);
    sit_write=[]
    stand_write=[]
    
    stand_count=0;
    sit_count=0;
    for i =1:np
        to_be_aug=denoised_csi_cut(peak_start(i):peak_end(i));
        if((peak_end(i)-peak_start(i))<300)
            continue
        end
        peak_end(i)
        peak_start(i)
        count_gest=count_gest+1
        [m,n]=size(to_be_aug);
        if(m>=target_len)
            to_write=to_be_aug(1:target_len);
    %         to_write=to_write.';
        else
            to_write=func_augment_csi(to_be_aug,target_len);
        end
        
%         if(rem(count_gest,2)==0)
%             stand_count=stand_count+1;
%             stand_write=[stand_write to_write];
%         end
%         if(rem(count_gest,2)~=0)
%             sit_count=sit_count+1;
%             sit_write=[sit_write to_write];
%         end
         sit_write=[sit_write to_write];
         break

    end
if(check_done==1)
%     stand_write=stand_write.';
%     label_num=8
%     label_column = label_num(ones(stand_count, 1));
%     stand_write=[stand_write label_column];
%     label = '/stand';
%     dlmwrite(strcat('output/whole',label,'/stand_segment_gest.csv'),stand_write,'delimiter',',','-append')
%     dlmwrite(strcat('output/whole',label,'/stand_full_gest.csv'),denoised_csi_cut.','delimiter',',','-append')
% 
%     sit_write=sit_write.';
%     label_num=7
%     label_column = label_num(ones(sit_count, 1));
%     sit_write=[sit_write label_column];
%     label = '/sit';
%     dlmwrite(strcat('output/whole',label,'/sit_segment_gest.csv'),sit_write,'delimiter',',','-append')
%     dlmwrite(strcat('output/whole',label,'/sit_full_gest.csv'),denoised_csi_cut.','delimiter',',','-append')

%     sit_write=sit_write.';
%     label_num=10
%     label_column = label_num(ones(sit_count, 1));
%     sit_write=[sit_write label_column];
%     label = '/drink';
%     dlmwrite(strcat('output/whole',label,'/drink_segment_gest.csv'),sit_write,'delimiter',',','-append')
%     dlmwrite(strcat('output/whole',label,'/drink_full_gest.csv'),denoised_csi_cut.','delimiter',',','-append')

end
    
    
% % %     break
end



