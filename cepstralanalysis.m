[y,fs]=audioread("https://www.voiptroubleshooter.com/open_speech/american/OSR_us_000_0010_8k.wav");
a = [abs(max(y)) abs(min(y))];
x=y./(1.01*(max(a)));         %normalization
y0=x(3901:(3900+fs*25/1000)); %segment of 25ms
N=fs*25/1000;                  
w=hann(N);                    %using hann window
y1=y0.*w;
y2=fft(y1);                   %fourier transfrom
y3=log(abs(y2));              %taking log of magnitude of transform
y4=ifft(y3);                  %taking inverse fourier transform
%APPLICATIONS
%1>Seperation of excitation and vocal characteristics using liftering

%sepration of vocal characteristic using Low time liftering        
L=zeros(1,length(y4));        %array for liftering window
L(1:20)=1;                    %creation of window
L=L';
yL=y4.*L;                     %using window to create low time lifted cepstrum

%seperation of excitation characteristic using high time liftering
H=zeros(1,length(y4));        %array for liftering window
H(20:length(H))=1;            %creation of window
H=H';
yH=y4.*H;                     %using window to create high time lifted cepstrum
%2>Formant Analysis
yl=yL(1:20);
ylo=fft(yl,8000);
ylo=real(ylo);
k=1;
o=1;
for i=2:length(ylo)-1
    if ylo(i-1)<ylo(i) && ylo(i+1)<ylo(i)
        o = o+1
    else
        continue;
    end
end
formant_val=zeros(1,o);   %gives value of all peaks
formant=zeros(1,o);       %gives location of peaks
for i=2:length(ylo)-1
    if ylo(i-1)<ylo(i) && ylo(i+1)<ylo(i)
        formant_val(k) = ylo(i)+formant_val(k)
        formant(k) = i+formant(k)
        k = k+1
    else
        continue;
    end
end
figure(1)
subplot(4,1,1);
plot(y4);
title("cepstrum");
xlabel quefrency;
ylabel amplitude;
subplot(4,1,2);
plot(yL);
title("Low-time liftered");
xlabel quefrency;
ylabel amplitude;
subplot(4,1,3);
plot(yH);
title("High-time liftered");
xlabel quefrency;
ylabel amplitude;
subplot(4,1,4);
plot(ylo);

title("extracted formant");
xlabel quefrency;
ylabel "logspectrum";
%3>Pitch Estimation
[pfrequency,pperiod] = getpitch(yH,fs)
function [pfrequency,pperiod] = getpitch(yH,fs)
    peak=max(yH);
    que=find(yH==peak);
    pperiod=que;
    pfrequency=(1/pperiod)*fs;
end



