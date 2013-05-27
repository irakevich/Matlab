function [Mh,Ma] = ScheduleLeague()
global Z
global W
global G


    
Mh=ones(W/2,G);
Ma=ones(W/2,G);
Zij = eye(Z,Z);

for w=1:W/2 
    tmp = zeros(1,Z); % 0- nie gra³ w kolejce; 1- gra³ w kolejce
    for g = 1:G
        listaMozliwychZesp = find(tmp==0); % listaMozliwychZesp(1)=>2 - drugi zespol;
        z1 = 0;
        wartosci = ones(Z,1)*Z;
        for i = 1:length(listaMozliwychZesp)
            wartosci(listaMozliwychZesp(i)) = length(find(Zij(listaMozliwychZesp(i),:)+tmp==0));
        end;
        if min(wartosci) < 3
           z1Vect = find(wartosci == min(wartosci));
           z1 = z1Vect(1);
        end
        if z1 == 0
            z1Vect = find(tmp==0);
            i1 = ceil(rand(1)*length(z1Vect));
            z1 = z1Vect(i1);
        end;
        tmp(z1)=1;
        
        z2Vect = find(Zij(z1,:)+tmp==0);
        i2 = ceil(rand(1)*length(z2Vect));
        z2 = z2Vect(i2);
        tmp(z2Vect(i2))=1;
        
        Zij(z1,z2) = 1;
        Zij(z2,z1) = 1;
        Mh(w,g)=z1;
        Ma(w,g)=z2;
    end;
end;











for i=1:0  % z komentarzami

for w=1:W/2 
    w
   % Zij
    tmp = zeros(1,Z);
    for g = 1:G
        listaMozliwychZesp = find(tmp==0);
        z1 = 0;
        wartosci = ones(Z,1)*Z;
        for i = 1:length(listaMozliwychZesp)
            wartosci(listaMozliwychZesp(i)) = length(find(Zij(listaMozliwychZesp(i),:)+tmp==0));
        end;
        if min(wartosci) < 3
           z1Vect = find(wartosci == min(wartosci));
           z1 = z1Vect(1);
          disp(sprintf('awaria!!! %g',z1));
        end
        if z1 == 0
            z1Vect = find(tmp==0);
            i1 = ceil(rand(1)*length(z1Vect));
            z1 = z1Vect(i1);
        end;
        tmp(z1)=1;
        disp(sprintf('(%g-...)', z1));
        z2Vect = find(Zij(z1,:)+tmp==0);
        i2 = ceil(rand(1)*length(z2Vect));
        z2 = z2Vect(i2);
        disp(sprintf('(%g-%g)', z1,z2));
        tmp(z2Vect(i2))=1;
        Zij(z1,z2) = 1;
        Zij(z2,z1) = 1;
        Mh(w,g)=z1;
        Ma(w,g)=z2;
    end;
end;

end; %end-for

%    Zij(z1Vect(i1),:)
%    tmp