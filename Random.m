function [Xwgr, Ewrz,HEwrz,Cwgr,Cwrg]=Random(Hwgz,Awgz)

global Z
global R
global W
global G
global Lr
global Oa
global Oh
global S
%%initialize all variables
%kara
Crg=zeros(R,G); 
Xwgr=zeros(W,G,R);
Ewrz=zeros(W,R,Z);
HEwrz=zeros(W,R,Z);
%min sum i=1..R j=1..G Crg*Yrg
%sum j=1..G Arg*Yrg<=Br , r=1..R
%sum r=1..R Yrg=1, g=1..G
Arg=ones(R,G);
Br=ones(R,1);
Ygr=zeros(G,R);
%disp(Hwgz+Awgz);

for w=1:1:W
%        disp('---w -------');disp(w);
    % -- 2.2 Find an optimal assignment for the current stage 
    [c, y_L, y_U, b_L, b_U, a, sos1] = abc2gap( Arg', Br, Crg', true);
    b_L(isinf(b_L))=0;
    b_U(isinf(b_U))=0;
    % min f'*y    subject to:   A*y <= b         
    A = [a; -a];
    b = [b_U; -b_L];
%        disp(full(A));
%        disp(full(b));
    %%%%%%[y, fVal]  = linprog(c, A, b, [], [], y_L, y_U);
    ctype = '';
    for j=1:1:(R+G)*2
        ctype = strcat(ctype, 'U');
    end;
    vartype = '';
    for k=1:1:G*R
        vartype = strcat(vartype, 'I');
    end;
    [y,fopt,status,extra]=glpk(c,A,b,y_L,y_U,ctype,vartype,1);
%        disp(y);
    %Yrg=zeros(R,G);
    Ygr=zeros(G,R);
    p=0;
    for r=1:1:R
        for g=1:1:G
          p=p+1;  
          %Yrg(r,g)=y(p,1);
          Ygr(g,r)=y(p,1);
        end;
    end;

    % --2.3 Update all variables regarding the current stage
    Xwgr(w,:,:) = Ygr;
    Cwrg(w,:,:)=  Crg;
    Cwgr(w,:,:)= Crg';
    
    %---2.3.1 Calculate Ewrz HEwrz
    for r=1:1:R
        for z=1:1:Z
            Ewrz(w,r,z) = sum( (Hwgz(w,:,z)+Awgz(w,:,z)).*Xwgr(w,:,r)  );
            HEwrz(w,r,z)=sum( (Hwgz(w,:,z)).*Xwgr(w,:,r) );
         end
    end 
end