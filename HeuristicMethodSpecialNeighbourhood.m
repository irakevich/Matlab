function [V,cWRR, Xwgr,Ewrz,HEwrz]=HeuristicMethodSpecialNeighbourhood(Xwgr,Ewrz,HEwrz,V)


global R
global W
global M
theEnd=0;
cWRR=zeros(W,R,R);%  jasne ze 4(ostatni) z 4(ostatni) nie bedzie mia³ zamiany
krok=0;

disp('----HeuristicMethodSpecialNeighbourhood----');
while(theEnd~=1)&&(V~=0)
    cWRR = ones(W,R,R-1)*M;
    krok=krok+1; disp('krok sn= %g', krok);
    V
    [Vwr]=SpecialNeighbourhood(Xwgr,Ewrz,HEwrz,1); %wf==1
    [cWRR]=CalculateThePenaltyForSpecialNeighbourhood(cWRR,Vwr,Xwgr,Ewrz,HEwrz,C6wr);
    disp(sprintf('Vnew  %g',min(min(min(cWRR)))));
   % cWRR
    if min(min(min(cWRR))) <V
        V=min(min(min(cWRR)));
        [wwn,rr1n,rrn]=find3d(V==cWRR);
        wn=wwn(1);
        r1n=rr1n(1);
        rn=rrn(1);

        tmpX = Xwgr(wn,:,r1n);
        Xwgr(wn,:,r1n) = Xwgr(wn,:,rn);
        Xwgr(wn,:,rn) = tmpX;
        tmpE = Ewrz(wn,rn,:);
        Ewrz(wn,rn,:) = Ewrz(wn,r1n,:);
        Ewrz(wn,r1n,:) = tmpE;
        tmpHE = HEwrz(wn,rn,:);
        HEwrz(wn,rn,:) = HEwrz(wn,r1n,:);
        HEwrz(wn,r1n,:) = tmpHE;
        CalculateTheCostOfAllAssignmentVVVVV(Xwgr,Ewrz,HEwrz);   %nie jest potrzebne            
     else
        [Vhm,cWRR, Xwgr,Ewrz,HEwrz]=HeuristicMethod(Xwgr,Ewrz,HEwrz,V,0);%SN==0
        if Vhm<V 
            V=Vhm;
            CalculateTheCostOfAllAssignmentVVVVV(Xwgr,Ewrz,HEwrz);       %nie jest potrzebne          
        else    
            theEnd=1;
        end;
    end;    

    disp(sprintf('Vend sn  %g',V)); 
end;%while