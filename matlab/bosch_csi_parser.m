clear all;
csi_stream_t=func_read_csi('data/lab/jul2/pixel/munir_tamzeed/aoam20_static.dat');
[mt,nt]=size(csi_stream_t)
filename='munir_tamzeed_aoam20_static.csv';
 write_to_file=[];
for i=1:nt
    csi_stream_single_pack=csi_stream_t(:,i);
% % % % % % %     sample_csi_traceTmp = load('sample_csi_trace');
    sample_csi_trace = csi_stream_single_pack(1:90);
    write_to_file_t=[real(sample_csi_trace);imag(sample_csi_trace)];
    write_to_file=[write_to_file;write_to_file_t.'];
%     dlmwrite(filename,write_to_file,'-append');
end
dlmwrite(filename,write_to_file);