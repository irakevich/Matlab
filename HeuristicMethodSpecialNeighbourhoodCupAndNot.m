function [V,cWRR, Xwgr,Ewrz,HEwrz]=HeuristicMethodSpecialNeighbourhoodCupAndNot(Xwgr,Ewrz,HEwrz,V,cup,C6wr)


global R
global W
global M
theEnd=0;
cWRR=zeros(W,R,R);%  jasne ze 4(ostatni) z 4(ostatni) nie bedzie mia³ zamiany
krok=0;
wf=1; % % zaczynamy od kolejki [wf:W. Zak³adamy ze od [1:wf)=? meczy sie odby³y ;

while(theEnd~=1)&&(V~=0)
    cWRR = ones(W,R,R-1)*M;
    krok=krok+1;disp(sprintf('krok sn= %g',krok));
    V
    CalculateTheCostOfAllAssignmentVVVVV(Xwgr,Ewrz,HEwrz,C6wr);    

    if cup==1 
        if krok==1
            [wf,C6wr]=SetPunishment(C6wr);
        end;
    end;
    
    [Vwr]=SpecialNeighbourhood(Xwgr,Ewrz,HEwrz,wf,C6wr); % if wf >1 ==> matrix Vwr=[zeros(wf-1,R);Vwr(wf:W,R)]; 
    [cWRR]=CalculateThePenaltyForSpecialNeighbourhood(cWRR,Vwr,Xwgr,Ewrz,HEwrz,C6wr);
    disp(sprintf('Vnew  %g',min(min(min(cWRR)))));
    %cWRR
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
        CalculateTheCostOfAllAssignmentVVVVV(Xwgr,Ewrz,HEwrz,C6wr);   %nie jest potrzebne            
     else
        [Vhm,cWRR, Xwgr,Ewrz,HEwrz]=HeuristicMethodCupAndNot(Xwgr,Ewrz,HEwrz,V,0,wf,0,C6wr);%SN==0,wf,cup=0
        if Vhm<V 
            V=Vhm;
            CalculateTheCostOfAllAssignmentVVVVV(Xwgr,Ewrz,HEwrz,C6wr);  %nie jest potrzebne                  
        else    
            theEnd=1;
        end;
    end;    

    disp(sprintf('Vend sn  %g',V)); 
end;%while