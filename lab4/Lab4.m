%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Quarto trabalho de laborat�rio de PDS
%                   2020/2021
%               
%             Turno de 3�feira 14h
%                 
%                 Grupo 38
%             Jo�o Silva 90803
%            Vasco Ara�jo 90817
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear;
%% P1
%% 1a
type('LongTermEstimate');
%% 
% Coment�rio
% Este � um problema no qual queremos minimizar norm(Y-H*a)^2, ou seja � um
% problema de Least Squares. A solu��o para a estimativa de "a" � conhecida
% e � dada por a = inv(H'*H)*H'*Y. Assim, para estimar o valor de "a"
% apenas temos que construir a matriz H e o vetor Y com base no sinal x e
% no delay N. Analisando a matriz H dada nas aulas te�ricas pode-se ver que
% este � um caso particular do apresentado nos slides, em que em vez de
% termos acesso aos �ltimos N elementos para estimar o atual, usa-se apenas
% x(n-N) para calcular x(n). Assim, Y vai do instante N+1 at� ao final do
% sinal (parte de N+1 pois � o primeiro instante para o qual temos
% informa��o do que sucedeu a N instantes atr�s). A matriz H vai ser apenas
% um vetor com os valores de x, desde a primeira amostra at� � ultima-N
% amostra, uma vez que esta � a �ltima amostra que tem N amostras � frente,
% ou seja, � a �ltima amostra que vai ser usada para estimar x(n-N), no
% caso em que n = end (comprimento do vetor x). Para obter a fazemos apenas
% o c�lculo matricial.
%% 1b

N = 96;

%Faz load do sinal de teste
load('energy_train.mat');

%Calcula o par�metro a
a = LongTermEstimate(x_train, N);

%Cria��o da estima��o
x_est = a*x_train(1:end-N);

%Residuo � o sinal original menos a estimativa
res = x_train(N+1:end)-x_est;

%Fazer os plots
figure();
hold on;

plot(1:length(x_train), x_train);
plot(N+1:length(x_train), x_est);
legend('Original', 'Estimado');
title('Compara��o entre o training data e a estima��o');
xlabel('Amostra');
ylabel('Amplitude');

figure
plot(abs(res));
title('Residuo');
xlabel('Amostra');
ylabel('Amplitude');

figure
hold on
plot(1:length(x_train), x_train);
plot(N+1:length(x_train), x_est);
plot(N+1:length(x_train), abs(res));
legend('Original', 'Estimado', 'Res�duo');
title('Compara��o entre o training data e a estima��o com res�duo');
xlabel('Amostra');
ylabel('Amplitude');
%% 
% Coment�rio
% Como se pode observar apenas h� estimativa a partir da amostra N (96
% neste caso), uma vez que � necess�rio ter acesso � amostra (n-N) para
% estimar o instante n.
% Observando os plots obtidos conseguimos ver que em geral a estimativa
% segue a realidade, sendo confirmado pelo facto do valor absoluto dos 
% res�duos ter uma amplitude reduzida (0.02 a 0.06). No entanto, h� zonas
% onde a estimativa n�o � boa, o que se reflete na amplitude dos res�duos.
% Quando h� irregularidades no sinal, N amostras � frente vai haver um erro
% de estima��o o que leva a este aumento no res�duo. Para demonstrar este
% fen�meno considera-se por exemplo o tro�o do sinal entre a amostra 60 e
% 70. Este tro�o tem um pico que parece n�o seguir o andamento normal do
% sinal, e estre pico n�o aparece no sinal real N amostrar � frente. No
% entanto, como a nossa estimativa para o sinal no instante n � apenas o
% sinal no instante n-N vezes um coeficiente, a estimativa N amostras �
% frente do tro�o irregular vai ser tamb�m um pico, o que causa um aumento
% na amplitude do res�duo nesse instante.
%% 1c
fprintf('Coeficiente: %f\n', a);
fprintf('Energia do resiudo: %f\n', sum(res.^2));
fprintf('Energia do residuo por amostra %f\n', sum(res.^2)/length(res));
%% 
% Coment�rio
% Como se pode ver o coeficiente "a" � bastante pr�ximo de 1. Isto � de
% esperar uma vez que se considerou que o sinal � periodico, com per�odo N,
% querendo dizer que no sinal perfeito x(n) = x(n-N). Como � dito no
% enunciado o sinal representa a produ��o de energia de um painel solar
% residencial, sendo �bvio assim que se espera que o sinal tenha valores
% muito semelhantes desfazados de 1 dia (N=96).
% A energia do res�duo � obtida fazendo a soma do quadrado do sinal,
% resultando no valor de 0.347831. Dividindo pelo n�mero de amostras do
% res�duo consegue-se obter a energia por amostra (0.000302).
%% 1d
type('ShortTermEstimate.m');

%%
% Coment�rio
% O c�lculo dos parametros � feito de um modo semelhante ao feito na alinea
% 1a, sendo que agora n�o utilizamos apenas a amostra N instantes atr�s,
% usando antes as �ltimas P amostras para estimar a amostra atual do
% res�duo. O vetor Y passa a ser assim o sinal r da amostra p+1 at� �
% ultima. A matriz H agora � constru�da de maneira a que cada linha possua
% as amostras necess�rias para estimar um dado valor de r. Com p = 6, para
% estimar o instante 7 � necess�rio 6 amostras, a linha de H correspondente 
% a n=7 vai ser [x(1) x(2) x(3) x(4) x(5) x(6)]. Constru�ndo a matriz H
% deste modo � poss�vel depois realizar o mesmo c�lculo que na primeira
% alinea, resultando em p coeficientes a partir dos quais conseguimos
% estimar qualquer instante.
%% 1e
p = 6;
a = ShortTermEstimate(res, p);
res_est = zeros(length(res)-p, 1);
for i=p+1:length(res)-p
    for j=1:p
        res_est(i-p) = res_est(i-p) + a(j)*res(i-j);
    end
end

%Fazer os plots
figure();
hold on;
plot(res(p+1:end));
plot(res_est);
legend('Original', 'Estimado');
title('Compara��o entre o res�duo original e o estimado');
xlabel('Amostra');
ylabel('Amplitude');

figure
hold on;
plot(x_train(N+1:end));
plot(x_est+res_est(end-p-1));
legend('Original', 'Estimado');
title('Compara��o entre o training data e a estima��o com modelo1+modelo2');
xlabel('Amostra');
ylabel('Amplitude');
%%
% Coment�rios
% Analisando a primeira figura consegue-se ver que a estimativa do res�duo
% segue o sinal real bem. 
% Na segunda figura consegue-se observar a combina��o dos dois modelos num
% s�, isto � usa-se a estimativa do res�duo obtida para melhorar a
% estimativa do sinal de energia x. Como se pode observar isto resulta numa
% melhor estimativa do sinal x, ou seja o novo residuo (diferen�a entre
% sinal real e nova estimativa) vai ter uma menor amplitude.
%% 1f
e = res(p+1:end)-res_est;
fprintf('Coeficientes:\n');
disp(a');
fprintf('Energia do resiudo: %f\n', sum(e.^2));
fprintf('Energia do residuo por amostra %f\n', sum(e.^2)/length(e));
%% 
% Coment�rio
% Como se pode ver, ao contr�rio do que acontecia com o coeficiente na
% alinea 1b, os coeficientes que relacionam o sinal com o residuo N
% amostras � frente n�o s�o todos pr�ximos de 1. Como vemos tamb�m, h�
% amostras com maior peso que outras, por exemplo a(1) � muito maior que
% a(3), o que resulta na amostra r(n-1) tem mais influ�ncia na estimativa
% do que r(n-3). Assim se apenas fosse poss�vel ter acesso a algumas
% amostras em vez de 6, poderiam ser descartadas r(n-3) e r(n-5) que a
% estimativa final n�o diferia muito uma vez que estes coeficientes est�o
% muito pr�ximos de 0 comparando com os restantes.
% Quanto � energia do novo res�udo, comparando com a do res�duo original
% vemos que diminuiu para cerca de um ter�o da original, o que faz sentido 
% uma vez que com a combina��o dos dois modelos se tem uma melhor
% estimativa do sinal. A energia por amostra obviamente diminui tamb�m.


%% 2a
type('AnomaliesDetector.m');

%%
% Coment�rio
% De modo a detectar anomalias entre o vetor de tempo e as previs�es passadas 
% necess�rio computar qual a varia��o entre os dois. Uma maneira eficaz de 
% detectar essa diferen�a � atrav�s do desvio m�dio absoluto, ou seja, computar
% a diferen�a entre a amplitude do vetor de tempo e a previs�o a cada instante 
% de tempo e, se for maior que o desvio m�dio absoluto, marcar aquele instante 
% de tempo como uma anomalia.

%% 2b
load('energy_train.mat');


N = 96;
a_long = LongTermEstimate(x_train, N);
x_est = a_long*x_train(1:end-N);

anomaliesLong = AnomaliesDetector(x_train(N+1:length(x_est)), x_est);

num_long = 0;
for i=1:length(anomaliesLong)
  if anomaliesLong(i) == 1
    num_long = num_long+1;
  end
end

figure;
plot(anomaliesLong);
title('Anomalias entre training data e estima��o');
xlabel('Amostra');
ylabel('Anomalia');

load('energy_test.mat');

p = 6;
res = x_train(N+1:end)-x_est;

a_short = ShortTermEstimate(res, p);

res_est = zeros(length(res)-p, 1);
for i=p+1:length(res)-p
    for j=1:p
        res_est(i-p) = res_est(i-p) + a_short(j)*res(i-j);
    end
end

anomaliesShort = AnomaliesDetector(res(p+1:length(res_est)), res_est);

num_short= 0;
for i=1:length(anomaliesShort)
  if anomaliesShort(i) == 1
    num_short = num_short+1;
  end
end

%%
% Coment�rio
% V�-se claramente uma diferen�a entre os dois modelos. Usando o modelo short 
% detectaram-se 116 anomalias enquanto que usando o modelo long apenas se 
% detectaram 18. Isto faz sentido, pois o modelo short apenas usa os dados mais
% pr�ximos no tempo enquanto o que faz com o modelo responda mais agressivamente
% a varia��es. Isto faz com que, apesar de poder seguir mais fielmente o plot 
% real, fica mais sens�vel a outliers nos dados e portanto ir� ter mais anomalias.

%% 2c
%%
% Coment�rio
% Uma poss�vel solu��o seria interpolar os dados com anomalias usando informa��o  
% do passado.