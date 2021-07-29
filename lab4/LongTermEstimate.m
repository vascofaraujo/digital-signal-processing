function [ a ] = LongTermEstimate( x, N )
%LONGTERMESTIMATE Calcula o par�metro "a" para o modelo de longa dura��o
%   Partindo do principio que o sinal x tem algum tipo de periodicidade com
%   per�odo N, consegue-se estimar x(n) sabendo o param�tro "a" e x(n-N).

Y = x(N+1:end);
H = x(1:end-N);
a = (H'*H)\H'*Y;
end

