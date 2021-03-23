
%Written by Tamzeed

function [csi_streams]=down_sample_func_read_csi(fileName) 
csi_trace = read_bf_file(fileName); %read the binary file of CSI values
[m,n,d]=size(csi_trace) %m = # of packets, n = # of transmitters, d = # of subcarriers
plotCsi=[];
plotCsi_180=[];
plotCsi_270=[];
% get_scaled_csi(csi_entry)
cnt=0;
i=1;
while (i<=m)
% parfor i= 1:m
    
    csi_entry = csi_trace{i};
    if(isempty(csi_entry))
        
        i=i+1;
        continue
        
        
    end
    csi = get_scaled_csi(csi_entry); %given from Intel
    %%%% Ntx×Nrx×30
    [ms,ns,ds]=size(csi); %ms = # of transmitters, ns = # of receivers, ds = # of subcarriers

    B = permute((csi),[3 2 1]); %third index becomes first, first index becomes third
%         size(B);
    B =B(:);  %flattening out, now 1D array
    B=B(1:90);
    plotCsi_180=[plotCsi_180;    B.'];
    i=i+1;

        
end
    

    
% end
cnt

[s_270,m]=size(plotCsi_270)
[s_180,n]=size(plotCsi_180)
if(s_270>s_180)
    plotCsi=plotCsi_270.';
end
if(s_180>s_270)
    plotCsi=plotCsi_180.';
end
csi_streams=plotCsi;

end