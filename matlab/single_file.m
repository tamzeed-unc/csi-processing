clear all;
pca_comp=3;
target_len=1300; %gesture size
label = '/rub';
label_num=14;
folder_name='26_march_19'
file_count=0;
% files = dir(strcat('data/',folder_name,label,'/*.dat'));


csi_stream_t=func_read_csi('data/plot1.dat');
real_csi=abs(csi_stream_t);

figure()
plot(abs(real_csi(1,:)))


denoised_csi=func_denoise(real_csi.',10,500,6);
figure()
plot(denoised_csi(:,pca_comp))

denoised_csi_high_freq=func_denoise(real_csi.',100,500,6);
figure()
plot(denoised_csi_high_freq(:,pca_comp))
denoised_csi_high_freq=denoised_csi_high_freq(:,pca_comp)


diff_csi=diff(denoised_csi(:,pca_comp));
diff_csi=diff_csi(1000:end-1000);
figure()
plot(abs(diff_csi))

denoised_csi_cut=denoised_csi_high_freq(1000:end-1000);
count_gest=0

[peak_start,peak_end]=func_peak_detect(abs(diff_csi(1:end)).',.5);
[mp,np]=size(peak_start);
final_write=[]
for i =1:np
    to_be_aug=denoised_csi_cut(peak_start(i):peak_end(i));
    if((peak_end(i)-peak_start(i))<550)
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

    final_write=[final_write to_write];

end
final_write=final_write.';

label_column = label_num(ones(count_gest, 1));
final_write=[final_write label_column];
