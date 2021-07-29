%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Terceiro trabalho de laborat�rio de PDS
%                   2020/2021
%               
%             Turno de 3�feira 14h
%                 
%                 Grupo 38
%             Jo�o Silva 90803
%            Vasco Ara�jo 90817
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
close all;
clearvars;

%% Parte 1
%% Quest�o a)
[x, Fs] = audioread('fugee.wav');

soundsc(x);

%% 
% Reproduzindo o sinal podemos ouvir uma m�sica com bastante ru�do, sendo
% o mais aud�vel uma crepita��o constante. Isto � algo comum em discos
% de vinil e � causado por acumula��o est�tica ou riscos no disco.

%% Quest�o b)

x_length = length(x);
x1 = round(x_length/4);
x2 = round(x_length/2);
x3 = round(3*x_length/4);


figure(1);
plot(x(1:x1));
title('First quarter of the signal');
xlabel('n'); 
ylabel('Amplitude [V]');

figure(2);
plot(x(x1+1:x2));
title('Second quarter of the signal');
xlabel('n'); 
ylabel('Amplitude [V]');

figure(3);
plot(x(x2+1:x3));
title('Third quarter of the signal');
xlabel('n'); 
ylabel('Amplitude [V]');

figure(4);
plot(x(x3+1:x_length));
title('Fourth quarter of the signal');
xlabel('n'); 
ylabel('Amplitude [V]');

%% 
% Olhando para o plot podemos claramente ver o ru�do, observando
% picos de amplitude pela can��o inteira. Podemos tamb�m reparar numa
% 'parede' de ru�do, de -0.4 a 0.4V e que come�a quando a bateria entra na
% m�sica.



%% Quest�o c)
X = fft(x);
XShift = fftshift(X);

P = abs(XShift);   
f = ((-x_length/2):1:(x_length/2)-1)*Fs/x_length;


figure(6);
semilogy(f, P);
title('Magnitude spectrum');
xlabel('Frequency [Hz]');
ylabel('dB');

%% 
% Podemos verificar que a magnitude est� espelhada sobre o eixo das
% ordenadas. Existe uma componente DC acentuada e verifica-se
% que � medida que a frequ�ncia vai aumentando a magnitude diminui.
%% Parte 2

%% Quest�o a)
[B, A] = butter(10, (pi/2)/pi);

[H,W] = freqz(B,A);

figure(6);
freqz(B,A);
title('Magnitude of Butterworth filter');

figure(7);
plot(W, abs(H));
title('Linear magnitude plot of Butterworth filter');
xlabel('Frequency [Hz]');
ylabel('Amplitude');

%% 
% Podemos ver que o filtro de Butterworth se comporta como espect�vel de um
% filtro passa-baixo. O filtro n�o afecta as baixas frequ�ncias, apenas
% come�ando a atenua��o nos 0.5*pi Hz. A atenua��o � progressiva, ou seja,
% quanto mais a frequ�ncia aumenta mais o filtro corta o sinal. A mesma
% informa��o pode ser observada no plot linear, em que a frequ�ncia pi/2 
% corresponde ao valor sqrt(2)/2, que � o mesmo que dizer -3dB, que � o valor 
% no qual se mede a frequ�ncia de corte. Confirma-se assim o funcionamento do 
% filtro.

%% Quest�o b)
x = audioread('fugee.wav');
x_length = length(x);


y = filter(B,A, x);

%% 
% Para Fs = 8000, a frequ�ncia de cut-off � de f = pi/2 * (Fs/(2*pi)) <=> f = Fs/4 = 2 kHz.
% A difere�a entre tempo cont�nuo e discreto � que um ponto em cont�nuo
% correspondente a Fs/2 � mapeado para pi/2 em tempo discreto, e por 
% isso existe varia��o na frequ�ncia de cut-off. 


%% Quest�o c)
figure(8);
plot(x); hold on;
plot(y);
title('Original and filtered signals');
legend('Original', 'Filtered');
xlabel('n');
ylabel('Amplitude [V]');

figure(9);
plot(x(1205500:1205500+400)); hold on;
plot(y(1205500:1205500+400));
title('Original and filtered signals zoomed in');
legend('Original', 'Filtered');
xlabel('n');
ylabel('Amplitude [V]');

%% 
% Observando a Figura 8 podemos ver que a maioria do sinal original foi atenuado 
% no sinal filtrado. Todos os picos de amplitude tiveram a sua amplitude diminu�da.
% Na Figura 9 podemos confirmar isto. Por exemplo, no sinal original pode-se
% ver um claro pico de amplitude que foi bastante reduzido no sinal filtrado.


%% Quest�o d)
X = fft(x);
XShift = fftshift(X );
PX = abs(XShift);   
fx = ((-x_length/2):1:(x_length/2)-1)*Fs/x_length;

Y = fft(y);
YShift = fftshift(Y);
PY = abs(YShift);   
fy = ((-x_length/2):1:(x_length/2)-1)*Fs/x_length;

figure(10);
semilogy(fx, PX); hold on;
semilogy(fy, PY);
title('Magnitude spectra of original and filtered signals');
legend('Original', 'Filtered');
xlabel('n');
ylabel('Amplitude [V]');

%% 
% Uma vez que o espectro � espelhado podemo-nos focar apenas na parte
% positiva do espectro. Para baixas frequ�ncias o espectro n�o foi
% alterado, no entanto para frequ�ncia altas o espectro foi bastante
% atenuado, como seria espect�vel de um filtro passa-baixo.

%%
% Quest�o e)

soundsc(y);

%% 
% Ouvindo o sinal filtrado y podemos observar tr�s coisas:
% 1) o barulho de clique foi reduzido, pois a frequ�ncia alta do sinal foi
% atenuada, deixando apenas o ru�do de baixa frequ�ncia
% 2) os instrumentos de baixa frequ�ncia est�o mais aud�veis, tais como a
% bateria ou o baixo
% 3) o som no geral perdeu qualidade pois o filtro n�o opera apenas no
% ru�do mas sim no sinal inteiro. Por isso, as componentes de alta
% frequ�ncia da m�sica tamb�m foram afectadas



%% Quest�o f)
[B2, A2] = butter(10, (pi/16)/pi);
y2 = filter(B2,A2, x);

[B3, A3] = butter(10, (9*pi/10)/pi);
y3 = filter(B3,A3, x);

Y2 = fft(y2);
Y2Shift = fftshift(Y2);
PY2 = abs(Y2Shift);   
fy2 = ((-x_length/2):1:(x_length/2)-1)*Fs/x_length;

Y3 = fft(y3);
Y3Shift = fftshift(Y3);
PY3 = abs(Y3Shift);   
fy3 = ((-x_length/2):1:(x_length/2)-1)*Fs/x_length;

soundsc(y2);
soundsc(y3);

figure(11);
semilogy(fy2, PY2); hold on;
semilogy(fy3, PY3);
title('Magnitude spectra of y2 and y3');
legend('y2', 'y3');figure(10);
semilogy(fx, PX); hold on;
semilogy(fy, PY);
title('Magnitude spectra of original and filtered signals');
legend('Original', 'Filtered');
xlabel('n');
ylabel('Amplitude [V]');


%% 
% Ouvindo o sinal y2, obtido com frequ�ncia de cut-off em pi/16, podemos
% ver que a m�sica foi bastante alterada. Devido � frequ�ncia de cut-off
% ser t�o baixa, os �nicos sons que n�o foram filtrados s�o os de muito
% baixa frequ�ncia. Logo quase s� se ouve o baixo e a bateria.
% O sinal y3 � o oposto. Com uma frequ�ncia de cut-off de 0.9pi, o ru�do na
% m�sica aumentou, mas tamb�m aumentou a qualidade do som no geral. Isto
% pois existe um trade-off em que quanto mais alta for a frequ�ncia de
% cut-off, maior qualidade ter� a m�sica, mas menos vai filtrar o ru�do.

%% Parte3
%% Quest�o a)
% Este filtro � n�o causal, � est�vel, � n�o linear, e � invariante no
% tempo.
% Em termos de causalidade, � f�cil de mostrar que este filtro n�o � causal
% uma vez que requere informa��o de instantes futuros para calcular a sa�da
% no instante atual. Tomando por exemplo o filtro de ordem 3, para calcular
% a sa�da no instante 2 � necess�rio fazer a mediana dos instantes 1, 2 e 3
% (y[2] = median(x[1], x[2], x[3])).
% No que toca � estabilidade, esta classe de filtros � est�vel uma vez que
% a sa�da apenas tende para valores infinitos se o input for tamb�m para
% infinito. Uma vez que a sa�da � sempre um dos valores de entrada, logo �
% sempre limitada pelos valores da entrada.
% Para provar que o filtro n�o � linear basta demonstrar que n�o possui a
% propriedade da sobreposi��o, isto �, se y1 = medfilt1(x1) e y2 =
% medfilt1(x2) ent�o y1+y2 = medfilt1(x1+x2). Assumindo que estamos a usar
% um filtro de ordem 3 e que x1 = [1, 2, 3] e que x2 = [5, 4, 6] vem que y1
% = 2 e y2 = 5. Assim y1+y2 deveria ser igual a medfilt1(x1+x2) =
% medfilt1([6, 6, 9]) = 6, enquanto que y1+y2 = 7. A propriedade da
% sobreposi��o n�o � satisfeita uma vez que h� um passo de ordena��o nestes
% filtros e esse passo � n�o linear.
% Quanto � invari�ncia no tempo, � f�cil de demonstrar que � invariante no
% tempo. Um sistema diz-se invariante no tempo se y[n] = H(x[n]) e y[n-1] =
% H(x[n-1]). Utilizando um filtro de ordem 3 para o exemplo, sabe-se que 
% y[n] = median(x[n-1], x[n], x[n+1]). Substituindo n por n-1 obtem-se
% median(x[n-2], x[n-1], x[n]) que � igual a y[n-1], confirmando assim esta
% propriedade.

%% Quest�o b)

%Calculo do sinal filtrado 
x_f = medfilt1(x, 3);

plot(x);
hold on;
plot(x_f);

xlabel('Tempo');
ylabel('Amplitude');
title('Compara��o do sinal original e do filtrado');
legend('original', 'filtrado');

figure();
%Agora zoomed in
M = 400;
T = 1205500;
plot((T:T+M), x(T:T+M));
hold on
plot((T:T+M), x_f(T:T+M));

xlabel('Tempo');
ylabel('Amplitude');
title('Compara��o do sinal original e do filtrado zoom-in');
legend('original', 'filtrado');

%% 
% Como acontecia na sec��o 2, o plot do sinal completo n�o � f�cil de
% analizar, usando para esse efeito o segundo plot que se foca numa �rea
% muito mais restrita onde apenas se tem 1 perturba��o. Como se pode ver,
% no sinal filtrado a perturba��o � completamente eliminada. No entanto, �
% tamb�m poss�vel verificar a perda de detalhe que ocorre devido ao tipo de
% filtro usado. Quando maior a ordem do filtro menos detalhe � preservado.
%% Quest�o c)
%Calcula a fft do sinal filtrado
X_f = fft(x_f);
X_f = fftshift(X_f);
freq = (-x_length/2:x_length/2-1)*Fs/x_length;

figure();
semilogy(freq, P);
hold on;
semilogy(freq, abs(X_f));
xlabel('Frequ�ncia (log) [Hz]');
ylabel('Magnitude');
title('Compara��o da magnitude do sinal original e filtrado');
legend('Original', 'Filtrado');

%% 
% Ao analizar este plot pode-se ver que, ao contr�rio do que sucedia na
% sec��o 2, n�o h� um corte completo na amplitude a altas frequ�ncias. Isto
% resulta num sinal menos perturbado pelo processo de filtragem, sendo que
% nas baixas frequ�ncias o sinal filtrado � basicamente igual ao original e
% nas altas frequ�ncias h� apenas uma pequena atenua��o da magnitude.
%% Quest�o d)

soundsc(x_f);

%% 
% Ao ouvir o sinal consegue-se perceber que, ao contr�rio do que acontecia
% com o filtro passa-baixo, as perturba��es foram eliminadas completamente.
% No entanto, o sinal filtrado parece ter mais ru�do comparando com o
% original. Isto vai ao encontro do resultado obtido em 3b, em que o sinal
% filtrado perdia detalhe, resultando no ru�do que se ouve.
%% Quest�o e)

%Calculo do sinal filtrado
x_f = medfilt1(x, 9);
soundsc(x_f);

figure();
%Agora zoomed in
M = 400;
T = 1205500;
plot((T:T+M), x(T:T+M));
hold on
plot((T:T+M), x_f(T:T+M));

xlabel('Tempo');
ylabel('Amplitude');
title('Compara��o do sinal original e do filtrado zoom-in');
legend('original', 'filtrado');

X_f = fft(x_f);
X_f = fftshift(X_f);
freq = (-x_length/2:x_length/2-1)*Fs/x_length;

figure();
semilogy(freq, P);
hold on;
semilogy(freq, abs(X_f));
xlabel('Frequ�ncia (log) [Hz]');
ylabel('Magnitude');
title('Compara��o da magnitude do sinal original e filtrado');
legend('Original', 'Filtrado');

%% 
% Experimentando filtros de ordem superior a 3 confirmamos que quanto maior
% a ordem maior ser� o ru�do no sinal filtrado, como seria de esperar. Com
% ordens menores que 3 (ordem 2) este tipo de perturba��o n�o � eliminado 
% uma vez que para cada instante da sa�da � feita a m�dia do sinal de
% entrada nesse instante com o sinal de entrada no instante anterior. Assim
% os "picos" de amplitude n�o seriam eliminados, seriam apenas atenuados.
% O filtro de terceira ordem � assim o que funciona melhor para
% eliminar as perturba��es deste sinal. Comparando o sinal filtrado com o
% original no dominio do tempo confirmamos que quanto maior a ordem do filtro 
% maior a perda de detalhe no sinal resultante. Comparando o plot obtido com 
% ordem 9 com o obtido com ordem 3 consegue-se ver que o de ordem 3 segue mais 
% fielmente o sinal original. Comparando tamb�m as respostas em frequ�ncias 
% observa-se que n�o houve uma altera��o not�vel para ordens diferentes, o 
% que faz sentido uma vez que este tipo de filtros n�o opera no dominio da 
% frequ�ncia, operando nas amostras do sinal em si.

%% Quest�o f)
% Para remover este tipo de ru�do cheg�mos � conclus�o que o filtro da
% mediana � o melhor, face ao filtro passa-baixo. Comparando os sinais
% resultantes do processo de filtragem para cada um, pode-se confirmar que
% no do filtro passa-baixo ainda se ouvem as perturba��es e o sinal perde
% qualidade, enquanto que no filtro da mediana o ru�do � eliminado havendo
% apenas uma pequena, quase impercet�vel para o filtro de ordem 3, descida
% na qualidade do sinal. Uma das causas que pensamos que contribui para
% isto � o facto do filtro passa-baixo operar no dominio da frequ�ncia,
% enquanto que o filtro da mediana opera sobre o sinal original em si. Este
% �ltimo (usando ordem 3 para exemplificar), para cada instante de tempo
% usa 3 amostras do sinal e ordena-as, escolhendo depois o valor central
% como valor final. Como as perturba��es s�o valores muito mais elevados em
% valor absoluto que o sinal e s�o pontuais (ocupam apenas 1 instante de tempo),
% isto garante que est�o sempre nas extremidades das 3 amostras escolhidas,
% sendo assim completamente eliminadas. Por outro lado, o filtro
% passa-baixo opera sobre a frequ�ncia, diminuindo a magnitude das
% componentes acima da frequ�ncia de corte. Analisando o plot do sinal
% filtrado da sec��o 2 confirmamos que tal acontece, as perturba��es t�m
% amplitude menor do que no sinal original. No entanto n�o s�o eliminadas e
% surge o problema adicional de as componentes de alta frequ�ncia serem
% perdidas. Em suma, para este tipo de perturba��es, o filtro da mediana �
% melhor do que o filtro passa-baixo.
