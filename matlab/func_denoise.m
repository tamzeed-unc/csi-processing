function [filterd_csi]=func_denoise(csi_stream,cut_off,sample_rate,order)
    
    pca_x=pca(csi_stream);
    size(pca_x)
    size(csi_stream)
    pca_ret=csi_stream*pca_x;
    fc = cut_off;
    fs = sample_rate;
    % 
%     pca_ret=csi_stream;
 
    [b,a] = butter(order,fc/(fs/2));
    filterd_csi = filter(b,a,pca_ret);
    
end
