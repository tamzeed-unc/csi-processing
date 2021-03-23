function [csi_streams1,csi_streams2]=func_reader_music(fileName)
csi_trace = read_bf_file(fileName);
[m,n,d]=size(csi_trace)
plotCsi1=[];
plotCsi2=[];
% get_scaled_csi(csi_entry)
cnt=0;
for i= 1:m
    csi_entry = csi_trace{i};
    csi = get_scaled_csi(csi_entry);
    %%%% Ntx×Nrx×30
    [ms,ns,ds]=size(csi);
    if(ms==1)
        cnt=cnt+1;
    else
%         B = permute(abs(csi),[3 2 1]);
%         size(B)
%         B =B(:);
% 
%         i;
%         
%         [m,n]=size( B.');
% %         size(plotCsi)
%         if(n==120)
%             plotCsi=[plotCsi;    B.'];
%         end

       rcv1=csi(1,1,:);
       plotCsi1=[plotCsi1;    rcv1(:).'];
       rcv2=csi(1,2,:);
       plotCsi2=[plotCsi2;    rcv2(:).'];
%        [mr,nr]=size(rcv1)
%        break;
    end
    

    
end
cnt

size(plotCsi1)
csi_streams1=plotCsi1.';
csi_streams2=plotCsi2.';
end