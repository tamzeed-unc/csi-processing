N = 1024;
n = 0:N-1;

w0 = 30
x = sin(w0*n)+10*sin(2*w0*n);
s = spectrogram(x);
plot(s(3,:))
[m,n]=size(s(30,:))
