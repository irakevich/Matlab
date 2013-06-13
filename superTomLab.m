%%function [ A, b_L, b_U, c, y_L, y_U] = superTomLab(Crg)
function [c, y_L, y_U, b_L, b_U, a] = superTomLab(Crg)    
global G
global R
% G = size(Crg,2)
% R = size(Crg,1)
   
    y_L = zeros(G*R,1);
    y_U = ones(G*R,1);
    b_L = ones(G+R,1);
    b_L(1:G,:) = 0;
    b_U = ones(G+R,1);
    
    tmp = Crg';
    c = tmp(:);
    A1 = zeros(G,R*G);
    A2 = [];
    for i=1:R
        A1(i,((i-1)*G+1:i*G)) = 1;
        A2= [A2 eye(G)];
    end
    a = [A1; A2];
end