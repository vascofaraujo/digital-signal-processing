function [ a ] = ShortTermEstimate(r, p)
%SHORTTERMESTIMATE Summary of this function goes here
%   Detailed explanation goes here

x_ = r(p+1:end);
H = zeros(length(r)-p, p);
%Construir a matriz H
for i=1:p
    for j=1:length(r)-p
        H(j, i) = r(p-i+1 + j-1);
    end
end

a = (H'*H)\H'*x_;
end

