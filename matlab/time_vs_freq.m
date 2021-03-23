% clear all;
% pca_comp=3;
% target_len=800; %gesture size
% label = 3;
% folder_name='29-10-18'
% 
% files = dir(strcat('data/',folder_name,'/*.dat'));
% for file = files'
%    
%     str_split=strsplit(file.name,'.')
%     str_split=char(str_split(1))
%     str_split=strsplit(str_split,'_')
%     str_split=char(str_split(2))
%     if(str2num(str_split)~=label)
%         continue
%     end
%     csi_stream_t=func_read_csi(strcat('data/',folder_name,'/',file.name));
%     real_csi=abs(csi_stream_t);
% 
%     figure()
%     plot(abs(real_csi(1,:)))
% 
% 
%     denoised_csi=func_denoise(real_csi.',3,100,6);
%     figure()
%     plot(denoised_csi(:,pca_comp))
% 
%     denoised_csi_high_freq=func_denoise(real_csi.',30,100,6);
%     figure()
%     plot(denoised_csi_high_freq(:,pca_comp))
%     denoised_csi_high_freq=denoised_csi_high_freq(:,pca_comp)
%  
% 
%     diff_csi=diff(denoised_csi(:,pca_comp));
%     diff_csi=diff_csi(500:end-300);
%     figure()
%     plot(abs(diff_csi))
% 
%     denoised_csi_cut=denoised_csi_high_freq(500:end-300);
%     count_gest=0
% 
%     [peak_start,peak_end]=func_peak_detect(abs(diff_csi(1:end)).',.4);
%     [mp,np]=size(peak_start);
%     final_write=[]
%     for i =1:np
%         to_be_aug=denoised_csi_cut(peak_start(i):peak_end(i));
%         if((peak_end(i)-peak_start(i))<400)
%             continue
%         end
%         count_gest=count_gest+1
%         [m,n]=size(to_be_aug);
%         if(m>=target_len)
%             to_write=to_be_aug(1:target_len);
%     %         to_write=to_write.';
%         else
%             to_write=func_augment_csi(to_be_aug,target_len);
%         end
% 
%         final_write=[final_write to_write];
% 
%     end
%     final_write=final_write.';
% 
%     label_column = label(ones(count_gest, 1));
%     final_write=[final_write label_column]
% 
%    
% %     break
% end
% 

figure()
plot(final_write(2,:))
figure()
plot(final_write(4,:))

mix_time_domain=final_write(2,:)+final_write(4,:);
figure()
plot(mix_time_domain)
figure()
mx_spec=spectrogram(mix_time_domain)




s1 = spectrogram(final_write(2,:))
s2 = spectrogram(final_write(4,:))
s3=s1+s2

figure()
plot(s3)




