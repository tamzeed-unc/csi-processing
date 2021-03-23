% % clear;
% % sample CSI trace is a 90x1 vector where first 30 elements correspond to subcarriers for first rx antenna, second 30 correspond to CSI from next 30 subcarriers and so on.
% % % replace sample_csi_trace with CSI from Intel 5300 converted to 90x1 vector
clear all;
csi_stream_t=func_read_csi('data/lab/jul12/antenna_or/backface.dat');
aoa1=[];
aoa2=[];
tof1=[];
phase_pack=[];
phase_pack2=[];
phase_pack3=[];
phase_san=[];
phase_san2=[];
phase_san3=[];
for i=1:50
    csi_stream_single_pack=csi_stream_t(:,i);
% % % % % % %     sample_csi_traceTmp = load('sample_csi_trace');
    sample_csi_trace = csi_stream_single_pack(1:90);

%     fc = 2.4e9;; % center frequency
%     fc = 2.4e9;; % center frequency
    fc = 5.63e9; % center frequency


    M = 3;    % number of rx antennas
    fs = 40e6; % channel bandwidth
    c = 3e8;  % speed of light
    d = 2.6e-2;  % distance between adjacent antennas in the linear antenna array
    dTx = 2.6e-2; 
    SubCarrInd = [-58,-54,-50,-46,-42,-38,-34,-30,-26,-22,-18,-14,-10,-6,-2,2,6,10,14,18,22,26,30,34,38,42,46,50,54,58]; % WiFi subcarrier indices at which CSI is available
    N = length(SubCarrInd); % number of subcarriers
    subCarrSize = 128;  % total number fo
    fgap = 312.5e3; % frequency gap in Hz between successive subcarriers in WiFi
    lambda = c/fc;  % wavelength
    T = 1; % number of transmitter antennas

% % % % %     MUSIC algorithm requires estimating MUSIC spectrum in a grid. paramRange captures parameters for this grid
% % % % %     For the following example, MUSIC spectrum is caluclated for 101 ToF (Time of flight) values spaced equally between -25 ns and 25 ns. MUSIC spectrum is calculated for for 101 AoA (Angle of Arrival) values between -90 and 90 degrees.
    paramRange = struct;
    paramRange.GridPts = [101 101 1]; % number of grid points in the format [number of grid points for ToF (Time of flight), number of grid points for angle of arrival (AoA), 1]
    paramRange.delayRange = [-50 50]*1e-9; % lowest and highest values to consider for ToF grid. 
    paramRange.angleRange = 90*[-1 1]; % lowest and values to consider for AoA grid.
    do_second_iter = 0;
    paramRange.seconditerGridPts = [1 51 21 21];
    paramRange.K = floor(M/2)+1; % parameter related to smoothing.  
    paramRange.L = floor(N/2); % parameter related to smoothing.  
    paramRange.T = 1;
    paramRange.deltaRange = [0 0]; 

    maxRapIters = Inf;
    useNoise = 0;
    paramRange.generateAtot = 2;

% %     ToF sanitization code (Algorithm 1 in SpotFi paper)
    csi_plot = reshape(sample_csi_trace, N, M);
% % % %     figure(100)
% % % %     plot(unwrap(angle(csi_plot)))
    
% % % %     subcarriers are they same for 2.4 and 5 ghz?
    
    [PhsSlope, PhsCons] = removePhsSlope(csi_plot,M,SubCarrInd,N);
    ToMult = exp(1i* (-PhsSlope*repmat(SubCarrInd(:),1,M) - PhsCons*ones(N,M) ));
    csi_plot = csi_plot.*ToMult;
    relChannel_noSlope = reshape(csi_plot, N, M, T);
    sample_csi_trace_sanitized = relChannel_noSlope(:);
    
%     figure()
%     plot(angle(sample_csi_trace_sanitized))
%     phase_pack=[phase_pack;angle(sample_csi_trace(1:1))];
%     phase_san=[phase_san;sample_csi_trace_sanitized(1:1)];
%     
%     phase_pack2=[phase_pack2;angle(sample_csi_trace(31:31))];
%     phase_san2=[phase_san2;sample_csi_trace_sanitized(31:31)];
%     
%     phase_pack3=[phase_pack3;angle(sample_csi_trace(61:61))];
%     phase_san3=[phase_san3;sample_csi_trace_sanitized(61:61)];

% %     sample_csi_trace_sanitized=sample_csi_trace;
    % % % % % % % % 
%     index=linspace(1,30,30);
%     figure()
%     plot(index,unwrap(angle(sample_csi_trace(1:30))),'b',index,unwrap(angle(sample_csi_trace(31:60))),'r',index,unwrap(angle(sample_csi_trace(61:90))),'k')
%     figure()
%     plot(index,(angle(sample_csi_trace_sanitized(1:30))),'b',index,(angle(sample_csi_trace_sanitized(31:60))),'r',index,(angle(sample_csi_trace_sanitized(61:90))),'k')
%     % % % % % % % % % 
% % % 
% % %     MUSIC algorithm for estimating angle of arrival
% % %     aoaEstimateMatrix is (nComps x 5) matrix where nComps is the number of paths in the environment. First column is ToF in ns and second column is AoA in degrees as defined in SpotFi paper
    aoaEstimateMatrix = backscatterEstimationMusic(sample_csi_trace_sanitized, M, N, c, fc,...
                        T, fgap, SubCarrInd, d, paramRange, maxRapIters, useNoise, do_second_iter, ones(5))  ; 
    tofEstimate = aoaEstimateMatrix(:,1); % ToF in nanoseconds% % figure()
% plot((phase_pack));
% figure()
% plot((angle(phase_san)));
% figure()
% plot((phase_pack2));
% figure()
% plot((angle(phase_san2)));
% figure()
% plot((phase_pack3));
% figure()
% plot((angle(phase_san3)));

    aoaEstomate = aoaEstimateMatrix(:,2) % AoA in degrees
    aoa1=[aoa1;aoaEstomate(:)];
    tof1=[tof1;tofEstimate(:)];
% % %     aoa2=[aoa2;aoaEstomate(2)];
end
figure()
plot(aoa1,tof1,'k*','MarkerSize',5);
n_cluster=5;
X=[aoa1.';tof1.'];
X=X.';

idx = kmeans(X,n_cluster)

figure;
gscatter(X(:,1),X(:,2),idx);
% figure()
% hist(aoa1)
X=[X.';idx.'];

X=X.';
[m,n]=size(X)
total_count=[];
total_tof=[];
total_var_aoa=[];
total_var_tof=[];
mean_aoa=[];
for i=1:n_cluster
    n_count=0;
    n_tof=0;
    n_var_aoa=[];
    n_var_tof=[];
    
    for j=1:m
        if(X(j,3)==i)
            n_count=n_count+1;
            n_tof=n_tof+(X(j,2)+50);
            n_var_aoa=[n_var_aoa;X(j,1)];
            n_var_tof=[n_var_tof;X(j,2)];
    
        end
    end
    total_count=[total_count;    n_count];
    n_tof=n_tof/n_count;
    total_tof=[total_tof;n_tof];
    total_var_aoa=[total_var_aoa;   var(n_var_aoa)];
    total_var_tof=[total_var_tof; var(n_var_tof)];
    mean_aoa=[mean_aoa;mean(n_var_aoa)];
    
    
%     break;
    
end
total_count=total_count/max(total_count)
total_tof=total_tof/max(total_tof)
total_var_aoa=total_var_aoa/max(total_var_aoa)
total_var_tof=total_var_tof/max(total_var_tof)

score=[];
for i=1:n_cluster
    score(i)=5*total_count(i)-2*abs(total_tof(i))-total_var_aoa(i)-(total_var_tof(i));
    
end
[val, idx] = max(score)
mean_aoa(idx)
mean_aoa
% dlmwrite('x.csv',X)




