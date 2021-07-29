function [ a ] = LongTermEstimate( x, N )
%LONGTERMESTIMATE Calcula o parâmetro "a" para o modelo de longa duração
%   Partindo do principio que o sinal x tem algum tipo de periodicidade com
%   período N, consegue-se estimar x(n) sabendo o paramêtro "a" e x(n-N).

Y = x(N+1:end);
H = x(1:end-N);
a = (H'*H)\H'*Y;
end

