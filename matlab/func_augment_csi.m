function [aug_csi]=func_augment_csi(o_csi,target_len)
    aug_csi=o_csi;
    [m,n]=size(aug_csi);
    add_len=target_len- m
    add_zeros=zeros(add_len,1);
    size(add_zeros)
    size(aug_csi)
    aug_csi=[aug_csi ;add_zeros];
    
    
    
    
    