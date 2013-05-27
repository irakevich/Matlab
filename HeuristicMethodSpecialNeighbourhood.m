function [V,cWRR, Xwgr,Ewrz,HEwrz]=HeuristicMethodSpecialNeighbourhood(Xwgr,Ewrz,HEwrz,V)

global Z
global R
global W
global G
global VCombination;
global Lr
global Oa
global Oh
global S
global cWRR
M=100000;

theEnd=0;

cWRR=zeros(W,R,R);%  jasne ze 4(ostatni) z 4(ostatni) nie bedzie mia� zamiany

krok=0;
%disp('Jestem fajnym algorytmem');
while(theEnd~=1)&&(V~=0)
    cWRR = ones(W,R,R-1)*M;
    krok=krok+1;
  %  disp('krok sn=');disp(krok);
  %  V
    [Vwr]=SpecialNeighbourhood(Xwgr,Ewrz,HEwrz);
    V1w=find(sum(Vwr,2)~=0);
    %disp(length(V1w));
    for iw=1:length(V1w);
        w=V1w(iw);
        V1r=find(Vwr(w,:)~=0);
        %disp(length(V1r));
        for ir=1:length(V1r)
            r=V1r(ir);
            
            for r1 = r+1:R
                if r ~= r1
                    if sum(Xwgr(w,:,r),2)+sum(Xwgr(w,:,r1),2) > 0
                        tmpX = Xwgr(w,:,r1);
                        Xwgr(w,:,r1) = Xwgr(w,:,r);
                        Xwgr(w,:,r) = tmpX;
                        tmpE = Ewrz(w,r,:);
                        Ewrz(w,r,:) = Ewrz(w,r1,:);
                        Ewrz(w,r1,:) = tmpE;
                        tmpHE = HEwrz(w,r,:);
                        HEwrz(w,r,:) = HEwrz(w,r1,:);
                        HEwrz(w,r1,:) = tmpHE;

                        [Vnew] = CalculateTheCostOfAllAssignment(Xwgr,Ewrz,HEwrz);
                        cWRR(w,r1,r) = Vnew;

                        Xwgr(w,:,r) = Xwgr(w,:,r1);
                        Xwgr(w,:,r1) = tmpX;
                        Ewrz(w,r1,:) = Ewrz(w,r,:);
                        Ewrz(w,r,:) = tmpE;
                        HEwrz(w,r1,:) = HEwrz(w,r,:);
                        HEwrz(w,r,:) = tmpHE;
                    end
                end
            end
        end
    end
   % disp(sprintf('Vnew  %g',min(min(min(cWRR)))));
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
       CalculateTheCostOfAllAssignment(Xwgr,Ewrz,HEwrz);
         CalculateTheCostOfAllAssignmentVVVVV(Xwgr,Ewrz,HEwrz);               
     else
        [Vhm,cWRR, Xwgr,Ewrz,HEwrz]=HeuristicMethod(Xwgr,Ewrz,HEwrz,V,0);%SN==0
        if Vhm<V 
            V=Vhm;
          %  CalculateTheCostOfAllAssignmentVVVVV(Xwgr,Ewrz,HEwrz);           
        else    
            theEnd=1;
        end;
    end;    

   % disp(sprintf('Vend sn  %g',V)); 
end;%while