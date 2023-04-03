%RICIAN1
clearvars; close all; clc;

%simulation parameters
%shared params
simtime = 2;
sampleRate = 2e4;
MDs = 200; %max Doppler shift [Hz]
EbNo = 4;
sSeed = 1;
noiseRate = 1/2e4;
%exclusive params
Kfac = 15;
rayDelay = [0]; %[0] %[0 5] %[5 2 8 9]
rayGain = [-3]; %[10]
%simulation launch
out=sim('Fading_Rician.slx');
pause(1);
%histogram(out.noNoise);
%histogram(out.withNoise);
noNoise = out.noNoise(:);

rician00 = noNoise;

%figure(1);histogram(rician00);title('120k samples'); xlabel('Amplitude'); ylabel('number of samples');

%__________________________________________________________________________

%RAYLEIGH1
clearvars -except rician00 simtime sampleRate MDs EbNo sSeed noiseRate; clc;

%simulation parameters
rayDelay = [0]; %[0] %[0 5] %[5 2 8 9]
rayGain = [0]; %[10]
%simulation launch
out=sim('Fading_Rayleigh.slx');
pause(1);
%histogram(out.noNoise);
%histogram(out.withNoise);
noNoise = out.noNoise(:);

rayleigh07 = noNoise;

%figure(2);histogram(rayleigh07);title('120k samples'); xlabel('Amplitude'); ylabel('number of samples');

%RICIAN2
clearvars -except rician00 rayleigh07 simtime sampleRate MDs EbNo sSeed noiseRate; clc;

%exclusive params
Kfac = 3;
rayDelay = [0]; %[0] %[0 5] %[5 2 8 9]
rayGain = [-7]; %[10]
%simulation launch
out=sim('Fading_Rician.slx');
pause(1);
%histogram(out.noNoise);
%histogram(out.withNoise);
noNoise = out.noNoise(:);

rician14 = noNoise;

%figure(3);histogram(rician14);title('120k samples'); xlabel('Amplitude'); ylabel('number of samples');

%__________________________________________________________________________

%RAYLEIGH2
clearvars -except rician00 rayleigh07 rician14 simtime sampleRate MDs EbNo sSeed; clc;

%simulation parameters
rayDelay = [0]; %[0] %[0 5] %[5 2 8 9]
rayGain = [-18]; %[10]
%simulation launch
out=sim('Fading_Rayleigh.slx');
pause(1);
%histogram(out.noNoise);
%histogram(out.withNoise);
noNoise = out.noNoise(:);

rayleigh21 = noNoise;

%figure(4);histogram(rayleigh21);title('120k samples'); xlabel('Amplitude'); ylabel('number of samples');

%{
[N,edges] = histcounts(rician00);
edges = edges(2:end) - (edges(2)-edges(1))/2;
[N2,edges2] = histcounts(rayleigh07);
edges2 = edges2(2:end) - (edges2(2)-edges2(1))/2;
[N3,edges3] = histcounts(rician14);
edges3 = edges3(2:end) - (edges3(2)-edges3(1))/2;
[N4,edges4] = histcounts(rayleigh21);
edges4 = edges4(2:end) - (edges4(2)-edges4(1))/2;
figure(5);hold on;
plot(edges, N,'b','LineWidth',1);
plot(edges2,N2,'r','LineWidth',1);
plot(edges3,N3,'LineWidth',1);
plot(edges4,N4,'LineWidth',1);
hold off;
%}
















%{
M=183;
V = ones([length(noNoise),M]);
for i = 0:length(noNoise)-1
    V(i+1,1:M)=V(i+1,1:M)*noNoise(i+1);
end

cutWithNoise = awgn(V,12,'measured');
averagedWithNoise = mean(cutWithNoise,2);
figure(1);histogram(noNoise);title('without noise');
figure(2);histogram(averagedWithNoise);title('averaged with noise');
figure(3);hold on; plot(noNoise,'b'); plot(averagedWithNoise,'r'); hold off;
%}

%_________________________________________________________________________________
%sampledNoNoise = noNoise(293:586:end);

%cutWithNoise = reshape(withNoise(1:numel(withNoise)-rem(numel(withNoise),586)), [586, (numel(withNoise)-rem(numel(withNoise),586))/586]);
%%cut data into samples of 568 symbols (without the last sample that is not
%%a full packet of 568 symbols
%averagedWithNoise = mean(cutWithNoise,1);
%averagedWithNoise = averagedWithNoise';

%figure(1);histogram(sampledNoNoise);title('without noise');
%figure(2);histogram(averagedWithNoise);title('averaged with noise');
%___________________________________________________