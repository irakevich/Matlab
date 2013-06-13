function [V,cWRR, Xwgr,Ewrz,HEwrz,WRRG]=HeuristicMethod(Xwgr,Ewrz,HEwrz,V,SN)


global R
global W
global M



theEnd=0;

cWRR=zeros(W,R,R);%  jasne ze 4(ostatni) z 4(ostatni) nie bedzie mia³ zamiany

krok=0;
while(theEnd~=1)&&(V~=0)&& (SN~=1) %SN==1-> raz petla siê wykona³a
    cWRR = ones(W,R,R-1)*M;
    krok=krok+1;
    disp(sprintf('k g %g ',  krok) );
  
    for w=1:W
        for r=1:R
            
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

                        [Vv] = CalculateTheCostOfAllAssignment_V5(Xwgr,Ewrz,HEwrz);
                        cWRR(w,r1,r) = Vv;

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
     disp(sprintf('V= %g Vnew = %g',V,(min(min(min(cWRR))))));
       
    % cWRR
     if min(min(min(cWRR))) <V 
        V=min(min(min(cWRR)));
        [wwn,rr1n,rrn]=find3d(V==cWRR);
        wn=wwn(1);
        r1n=rr1n(1);
        rn=rrn(1);
        WRRG(krok,:)=[wn,r1n,rn];
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
disp(sprintf('Vend General %g',V)); 

end;%while