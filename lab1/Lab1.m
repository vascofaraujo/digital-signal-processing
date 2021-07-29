%% PDS Lab 1

%% 1

%Constants
k2 = 1000;
k1 = 0;
F0 = 0;
theta_0 = 0;

samplesPerSecond = 8000;
maxT = 2;

%Create discrete time vector
n = 0:samplesPerSecond*maxT-1;
t = n/samplesPerSecond;

%Create signal
x = cos(2*pi*((1/3)*k2*(t.^3) + 0.5*k1*(t.^2) + F0*t + theta_0));

%instant frequency
fi = 2*pi*(k2*t.^2 + k1*t + F0);
plot(t, fi);
xlabel('Tempo [s]');
ylabel('Frequência [Hz]');
title('Frequência Instantânea');

soundsc(x, 8000);

%% 2 
N=60; 
spectrogram(x, hann(N), 3*N/4, 4*N, 8000, 'yaxis');
title('Espectrograma de x');

%% 3 
t_2 = t*2;
y = cos(2*pi*((1/3)*k2*(t_2.^3) + 0.5*k1*(t_2.^2) + F0*t_2 + theta_0));

soundsc(y, samplesPerSecond/2)
N=60; 
spectrogram(y, hann(N), 3*N/4, 4*N, samplesPerSecond/2, 'yaxis');
title('Espectrograma de x');

%%
freqArray = [1000, 4000, 6000, 160000];
FsArray = [4000, 8000, 20000];

maxT = 1;
%
for i=1:length(freqArray)
    figure();
%     str = sprintf('Freq = %d', freqArray(i));
%     suptitle(str);
    j = 1;
    for Fs=FsArray
        %Create discrete time vector
        n = 0:Fs*maxT-1;
        t = n/Fs;
        
        subplot(3, 1, j);
        j = j+1;

        z = cos(2*pi*freqArray(i)*t);
        length(z)
        plot(t, z);
        xlim([0, 30/freqArray(i)]);
        str = sprintf('Fs = %d', Fs);
        title(str);
    end

end
%% 4 
%Load signal
[x, Fs] = audioread('romanza_pe.wav');

%Play signal
soundsc(x(1:Fs*10), Fs);
%%
%Set up array of possible N values
N_array = [300, 600, 1200, 2400];


%calculate n that correspondes to second 15
n_15s = 15*Fs;


%For loop to iterate through possible N values and plot the corresponding
%spectogram. Can use this to check which N gives better results.
i = 1;
figure();
for N = N_array
    
    %Set up subplot
    subplot(2, 2, i);
    
    %plot spectrogram
    spectrogram(x(1:n_15s), hann(N), 3*N/4, 4*N, Fs, 'yaxis');
    
    title(['N = ' num2str(N)]);
    i = i + 1;
end





%Temos que escolher N tal que seja possível ver a separação das diversas
%linhas. Fazemos para valores diferentes de N e comparamos os resultados.
%Vemos que com valores pequenos de N não há separação nitida entre as
%várias frequências (distorção a nível da frequência), enquanto que com Ns 
%muito elevados começa a haver distorção temporal. Tendo em conta os
%resultados com os vários Ns decidimos usar N = 1200 que foi o valor que
%resultou numa melhor resolução tanto temporal como em frequência.
%% 5
N = 1200;
%Resample signal X with Fs/5, that is, it's as if we sample the signal b
%5 units of discrete time at a time. This way we end up with a signal that
%is the same as if we have sampled the original signal with Fs/5.
t = 1:5:numel(x);
new_x = x(t);

%Plays the resampled signal
soundsc(new_x, Fs/5);

%Plot spectogram
spectrogram(new_x(1:15*Fs/5), hann(N), 3*N/4, 4*N, Fs/5, 'yaxis');

%O que ouvimos foi o que parece ser o sinal original só que distorcido. Tal
%acontece devido à nova frequência de amostragem. Com esta nova frequência
%de amostragem o sinal deixa de seguir o Teorema de Amostragem {mostrar 
%condição} o que leva a que haja sobreposição {mostrar exemplo desta
%sobreposição}, o que resulta num sinal mal reconstruído.
%% 6 

%Filter the signal
xf = filter(fir1(100, 0.2), 1, x);

%Resample the filtered signal with the same logic as in the previous
%section
t = 1:5:numel(xf);
new_xf = xf(t);

%Play the resampled filtered signal
soundsc(new_xf, Fs/5);

%Plot spectrogram
spectrogram(new_xf(1:15*Fs/5), hann(N), 3*N/4, 4*N, Fs/5, 'yaxis');

%Como agora cortamos o sinal impedimos que haja a sobreposição que ocorria
%na alinea anterior. Como podemos observar o sinal reconstruido vai ter
%informação a menos do que o sinal original mas nunca terá informação
%incorreta.
