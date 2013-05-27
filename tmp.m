Z = 4;
G = 2;
W = 6;
Zij = eye(Z,Z);
for w=1:W/2 
    w
    tmp = zeros(1,Z);
    for g = 1:G
    z1Vect = find(tmp==0);
    z1 = ceil(rand(1)*length(z1Vect));
    tmp(z1Vect(z1))=1;
    disp(sprintf('(%g-...)', z1Vect(z1)));
    z2Vect = find(Zij(z1Vect(z1),:)+tmp==0);

    z2 = ceil(rand(1)*length(z2Vect));
    disp(sprintf('(%g-%g)', z1Vect(z1),z2Vect(z2)));
    tmp(z2Vect(z2))=1;
    Zij(z1Vect(z1),z2Vect(z2)) = 1;
    Zij(z2Vect(z2),z1Vect(z1)) = 1;
    end;
end;


%    Zij(z1Vect(z1),:)
%    tmp