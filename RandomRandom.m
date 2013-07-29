function [Xwgr, Ewrz,HEwrz]=RandomRandom(Hwgz,Awgz)

global Z
global R
global W
global G

%%initialize all variables
%kara
Xwgr=zeros(W,G,R);
Ewrz=zeros(W,R,Z);
HEwrz=zeros(W,R,Z);


for w=1:1:W
    r_perm=randperm(R);
    r_g=r_perm<=G;%binary wektor
    r_g_i=r_perm.*r_g;
    ygr=r_g_i(find(r_g_i~=0));
    Ygr=zeros(G,R);
    for g=1:1:G
       r=ygr(1,g);
       Ygr(g,r)=1;
    end;
    Xwgr(w,:,:) = Ygr;
    for r=1:1:R
        for z=1:1:Z
            Ewrz(w,r,z) = sum( (Hwgz(w,:,z)+Awgz(w,:,z)).*Xwgr(w,:,r)  );
            HEwrz(w,r,z)=sum( (Hwgz(w,:,z)).*Xwgr(w,:,r) );
         end
    end 
end