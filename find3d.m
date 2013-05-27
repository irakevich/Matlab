function [ x,y,z] = find3d( A )
[x, Y]=find(A);
y = mod(Y-1, size(A,2))+1;
z = ceil(Y/size(A,2));


end
