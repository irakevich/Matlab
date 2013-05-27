function [Xwgr, Ewrz,HEwrz,Cwgr,Cwrg]=AlgorithmConstrctiveAssignmentHeuristic(Hwgz,Awgz)

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
% --  2.1 Calculate the cost of asigment for each referee and game
 %--- 2.1.2 Calculate the V
    % -- V1
    minId = max(1, w-(S+1)); %interesuje nas wycinek o dlugosci s, gdzie ostatni element to potencjalna decyzja, wiec w-(s+1)
    for r = 1:1:R
%                disp('--- r ---');disp(r);
        TMPTeamXRef_wz = Ewrz(minId:w,r,:); %zespoly/druzyny sedziowane przez sedziego r w S-1 -ostatnich kolejkach
        % disp('TMPTeamXRef_wz');% disp(TMPTeamXRef_wz);
        TeamXRef_wz = TMPTeamXRef_wz(:,:);
        TeamXRefCount = sum(TeamXRef_wz, 1)+1; % dla poszczególnych zespolow ile razy sedziowal ten sam sedzie 
        %V1Tomek = sum(TeamXRefCount.*TeamInGame_z);
        %dla kazdego zespolu policz V1
        % !!!!!  disp(length(TeamXrefCount));disp(Z);
        for zz=1:Z
            if TeamXRefCount(1,zz)>1 %ma byæ dodatni factorial
                combination(zz)=factorial(TeamXRefCount(1,zz))/(factorial(2)*factorial(TeamXRefCount(1,zz)-2));
            else
                combination(zz)=0; %nie =TeamXRefCount(1,zz), bo zawsze bêdzie 1 dla potencjalnego przydzia³u i jest to ok
            end;
        end;
        TMPw1z = Ewrz(:,r,:);
        TMPwz = TMPw1z(:,:);  %splaszczyc wynik do macierzy
        HTMPw1z = HEwrz(:,r,:);
        HTMPwz = HTMPw1z(:,:); %splaszczyc wynik do macierzy
        
        for g= 1:1:G
%                disp('     --- g ---');disp(g);  
            TMPTeamInGame_z = Hwgz(w,g,:)+Awgz(w,g,:);
            TeamInGame_z= TMPTeamInGame_z(1,:); %splaszczyc wynik do wektora
            %disp('TeamInGame_z');disp(TeamInGame_z);
            TMPHostInGame_z = Hwgz(w,g,:);
            HomeInGame_z= TMPHostInGame_z(1,:); %splaszczyc wynik do wektora


            V1Ira= sum( combination.*TeamInGame_z);
            %disp('V1Ira');disp(V1Ira);
            %Crg(r,g) = V1Ira;

        % -- V2                

            V2 = sum(max(sum(TMPwz, 1).*TeamInGame_z+1 - Oa, 0));
            %disp('V2');disp(V2);
            %Crg(r,g) = V2;
        % --V3    
            V3 = sum(max(sum(HTMPwz, 1).*HomeInGame_z+1 - Oh, 0));
            %disp('V3');disp(V3);
            %Crg(r,g) = V3;

            %disp('V4');disp(V4);
            %Crg(r,g) = V4;
         % --V5
            V5=0;
            if (w>W/2)
                V5=Xwgr(w-W/2,g,r);%to samo co V5=max(Xwgr(w-W/2,g,r)+1-1,0);%zak³adamy iz Xwgr(w,g,r)=1 
            %else
                %V5=max(1+Xwgr(w+W/2,g,r)-1,0); % To nie ma sensu gdy¿ dla w+.. zawsze jest zero
            end;
            %disp('V5');disp(V5);
            %Crg(r,g) = V4 ;

            Crg(r,g)=V1Ira+V2+V3+V5;
        end
         % --V4
        V4=max(Lr(r,1)-(sum(sum(Xwgr(:,:,r),1),2)+1),0);
        for r1=1:1:R 
            if r1 ~= r
                V4 = V4 + max(Lr(r1,1)-(sum(sum(Xwgr(:,:,r1),1),2)),0);
            end;
        end 
        Crg(r,:)=Crg(r,:)+V4;
    end

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