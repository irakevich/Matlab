function [V,cWRR, Xwgr,Ewrz,HEwrz]=HeuristicMethodNew(Xwgr,Ewrz,HEwrz,V,SN,wf,C6wr)

global Z
global R
global W
global G
global VCombination;
global Lr
global Oa
global Oh
global S
global M


theEnd=0;
cWRR=zeros(W,R,R);%  jasne ze 4(ostatni) z 4(ostatni) nie bedzie mia³ zamiany
krok=0;

while(theEnd~=1)&&(V~=0)&& (SN~=1) %SN==1-> raz petla siê wykona³a
    cWRR = ones(W,R,R-1)*M;
    krok=krok+1;
   % -- disp(sprintf('krok general= %g',krok));
   % -- V
    CalculateTheCostOfAllAssignmentVVVVV(Xwgr,Ewrz,HEwrz,C6wr);  
    [cWRR]= CalculateThePenaltyForNeighbourhood(cWRR,Xwgr,Ewrz,HEwrz,wf,C6wr);       

   %-- disp('Vnew');disp(min(min(min(cWRR))));
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
                          
    else
        theEnd=1;
    end;    
SN=SN+1; %SN==1-> raz petla siê wykona³a
%--disp(sprintf('Vend general %g',V)); 

end;%while