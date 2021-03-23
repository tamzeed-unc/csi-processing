% clear all;
%%create steering matrix
aoa=0;
M=3; %number of antennas
A=[];%steering matrix
P=2; %number of signals
A=[A;1];
for i=2:M
    pCoff=(i-1)*pi*cos(aoa);
    append=exp(-1j*pCoff);
    A=[A;append];
end
%%% A=Mx1

%%%%
% csi_stream_t=func_read_csi('data/lab/jun20/c_nuc_h_r_aoa_p45.dat');
csi_stream_single_pack=csi_stream_t(:,1);
sample_csi_trace = csi_stream_single_pack(1:90);
X=[sample_csi_trace(1);sample_csi_trace(31);sample_csi_trace(61)];
% X=sample_csi_trace;
% corrX=X*X';
% corrX=corrcoef(corrX);
% [N,V]=eig(corrX); %Find the eigenvalues and eigenvectors of R
% 
% NN=N(:,1:M-P); %Estimate noise subspace

[Utmp,D] = eig(X*X');
D = abs(D);
[Dtmp,I] = sort(diag(D), 'descend');
D = diag(Dtmp);
U = Utmp(:,I);
minMP = 2;
useMDL = 0;
useDiffMaxVal = 0; % Default value is 1. If set to 1, it considers only those eignevalues who are above a certain threshold when compared to the maximum eigenvalue

% % % MDL criterion based
MDL = [];
lambdaTot = diag(D);
subarraySize = size(X,1);
nSegments = size(X,2);
maxMultipath = length(lambdaTot)
for k = 1:maxMultipath
    MDL(k) = -nSegments*(subarraySize-(k-1))*log(geomean(lambdaTot(k:end))/mean(lambdaTot(k:end))) + 0.5*(k-1)*(2*subarraySize-k+1)*log(nSegments);
end
% % Another attempt to take the number of multipath as minimum of MDL
[~, SignalEndIdxTmp] = min(MDL)







