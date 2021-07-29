%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Quinto trabalho de laborat�rio de PDS
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

%% 1a
% Em anexo no pdf est�o as dedu��es para cada uma das distribui��es.
%% 1b
load('sar_image.mat');
figure;
imagesc(I);
% getrect()
%% 1c

%Sec��es com apenas gelo e com apenas �gua
zona_gelo = [1    90    73   395];
zona_agua = [602     1   203    93];
I_gelo = imcrop(I, zona_gelo);
I_agua = imcrop(I, zona_agua);

%Resize de matriz para vetor
I_gelo = reshape(I_gelo,1,[]);
I_agua = reshape(I_agua,1,[]);

%Calcula os par�metros para as distribui��es diferentes
%Exponencial
gelo_exp = mle(I_gelo, 'distribution','Exponential');
agua_exp = mle(I_agua, 'distribution','Exponential');

%Rayleigh
gelo_ray = mle(I_gelo, 'distribution','Rayleigh');
agua_ray = mle(I_agua, 'distribution','Rayleigh');

%Normal
gelo_norm = mle(I_gelo, 'distribution','Normal');
agua_norm = mle(I_agua, 'distribution','Normal');

%% 
% Usando a fun��o "mle" do Matlab obtivemos os mesmos resultados do que
% fazendo as contas com as express�es obtidas em 1a, como seria de esperar.
%% 1d

%�gua
%plot do histograma 
figure;
histogram(I_agua, 'Normalization', 'pdf');
x = 0:1:4*10^4;
hold on;
plot(x, exppdf(x, agua_exp),'LineWidth',2);
plot(x, raylpdf(x, agua_ray), 'LineWidth',2);
plot(x, normpdf(x, agua_norm(1), agua_norm(2)), 'LineWidth',2);
legend('Real', 'Exponencial', 'Rayleigh', 'Normal');

figure;
histogram(I_gelo, 'Normalization', 'pdf');
x = 0:1:4.5*10^5;
hold on;
plot(x, exppdf(x, gelo_exp), 'LineWidth',2);
plot(x, raylpdf(x, gelo_ray), 'LineWidth',2);
plot(x, normpdf(x, gelo_norm(1), gelo_norm(2)), 'LineWidth',2);
legend('Real', 'Exponencial', 'Rayleigh', 'Normal');

%% 
% Observando as curvas obtidas com as v�rias distribui��es, consegue-se
% chegar � conclus�o que a distribui��o que melhor descreve este conjunto �
% a de Rayleigh.

%% 2a
%Using the Rayleigh distribution
I_segmented = I;

thresh = raylpdf(I, agua_ray) - raylpdf(I, gelo_ray);

I_segmented(thresh>=0) = 0; %� agua
I_segmented(thresh<0) = 1; %� gelo

figure;
imagesc(I);
hold on;
imcontour(I_segmented, 'r');

figure;
x = 0:1:200000;
plot(x, raylpdf(x, gelo_ray), x, raylpdf(x, agua_ray), 'LineWidth',2);
title('Distribui��es da �gua e gelo');
legend('Gelo', '�gua');
%% 
% Vamos agora � imagem original e para cada pixel verificamos se tem um
% valor maior com a distribui��o do gelo ou com a distribui��o da �gua. O
% que for maior assumimos que esse pixel pertence a essa zona. Vemos na
% imagem o resultado desta opera��o, em que 0 corresponde a �gua e 255
% corresponde a uma zona de gelo. Fazendo o plot das 2 distribui��es v�-se
% que a mudan�a entre dizer que um dado pixel � de uma zona de gelo ou de
% uma zona de �gua acontece quando esse pixel tem valor de 10000. Abaixo
% disso dizemos que o pixel � de uma zona de �gua, acima dizemos que � de
% uma zona de gelo. Como se pode ver as sec��es de �gua e gelo est�o bem
% definidos, sendo que h� no entanto bastantes falsos positivos (sec��es
% mal divididas).

%% 2b

kernel = [5,5];
I_conv = conv2(I,kernel,'same');

figure;
imagesc(I_conv);

thresh = raylpdf(I_conv, agua_ray) - raylpdf(I_conv, gelo_ray);

I_conv(thresh>=0) = 0; %� agua
I_conv(thresh<0) = 1; %� gelo


figure;
imagesc(I);
hold on;
imcontour(I_conv, 'r');

%% 
% Ao passar a imagem por um filtro antes de fazer o mesmo processo que na
% alinea anterior vemos que muitos dos falsos positivos s�o eliminados. No
% entanto, como a imagem cont�m poucas sec��es de apenas �gua, o resultado
% desta alinea apresenta muito menos zonas, sendo que as zonas delimitadas
% que apresenta s�o quase guarantidamente apenas de um tipo (apenas �gua ou
% apenas gelo).
%% 2c

figure;
subplot(1,2,1);
imcontour(I_segmented);
title('2a');

subplot(1,2,2);
imcontour(I_conv);
title('2b');

%alinea 2a
correct_2a_agua = 0;
correct_2a_gelo = 0;

I_gelo = imcrop(I_segmented, zona_gelo);
I_agua = imcrop(I_segmented, zona_agua);

correct_2a_agua = correct_2a_agua + sum(sum(I_agua==0));
correct_2a_gelo = correct_2a_gelo + sum(sum(I_gelo==1));

total_a_agua = correct_2a_agua/(size(I_agua,1)*size(I_agua,2));
total_a_gelo = correct_2a_gelo/(size(I_gelo,1)*size(I_gelo,2));


%alinea 2b
correct_2b_agua = 0;
correct_2b_gelo = 0;

I_gelo = imcrop(I_conv, zona_gelo);
I_agua = imcrop(I_conv, zona_agua);

correct_2b_agua = correct_2b_agua + sum(sum(I_agua==0));
correct_2b_gelo = correct_2b_gelo + sum(sum(I_gelo==1));

total_b_agua = correct_2b_agua/(size(I_agua,1)*size(I_agua,2));
total_b_gelo = correct_2b_gelo/(size(I_gelo,1)*size(I_gelo,2));

Acertos = {'�gua'; 'Gelo'};
Metodo1 = [total_a_agua; total_a_gelo];
Metodo2 = [total_b_agua; total_b_gelo];

T = table(Acertos, Metodo1, Metodo2)

%% 
% Como se pode ver pelo rate de escolhas correctas, ambos os m�todos s�o
% bastante bons a estimar as duas zonas da imagem. No entanto o m�todo da
% alinea 2a d� resultados significativamente melhores no rate das escolhas
% correctas relativas � zona de �gua. Isto � devido ao facto que a zona
% original escolhida n�o possu� apenas �gua, contendo tamb�m gelo que �
% apenas detetado depois de passar a imagem pelo filtro da alinea 2b. Foi
% assim escolhida uma nova zona e repetida esta alinea abaixo.

%%
%alinea 2a
correct_2a_agua = 0;
correct_2a_gelo = 0;

I_gelo = imcrop(I_segmented, zona_gelo);
I_agua = imcrop(I_segmented, [262   372    44    78]);

correct_2a_agua = correct_2a_agua + sum(sum(I_agua==0));
correct_2a_gelo = correct_2a_gelo + sum(sum(I_gelo==1));

total_a_agua = correct_2a_agua/(size(I_agua,1)*size(I_agua,2));
total_a_gelo = correct_2a_gelo/(size(I_gelo,1)*size(I_gelo,2));


%alinea 2b
correct_2b_agua = 0;
correct_2b_gelo = 0;

I_gelo = imcrop(I_conv, zona_gelo);
I_agua = imcrop(I_conv, [262   372    44    78]);

correct_2b_agua = correct_2b_agua + sum(sum(I_agua==0));
correct_2b_gelo = correct_2b_gelo + sum(sum(I_gelo==1));

total_b_agua = correct_2b_agua/(size(I_agua,1)*size(I_agua,2));
total_b_gelo = correct_2b_gelo/(size(I_gelo,1)*size(I_gelo,2));

Acertos = {'�gua'; 'Gelo'};
Metodo1 = [total_a_agua; total_a_gelo];
Metodo2 = [total_b_agua; total_b_gelo];

T = table(Acertos, Metodo1, Metodo2)
%% 
% Como se pode ver, com a zona de �gua escolhida corretamente os valores
% obtidos com o m�todo da alinea b melhora significativamente. Assim
% determinamos que para o segundo m�todo � mais importante obter uma clara
% divis�o entre as v�rias zonas na imagem original. Em geral ambos os
% m�todos deram resultados aceit�veis.

