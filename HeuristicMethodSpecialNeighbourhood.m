function [V,cWRR, Xwgr,Ewrz,HEwrz,WRRS]=HeuristicMethodSpecialNeighbourhood(Xwgr,Ewrz,HEwrz,V)


global R
global W
global M
%WRRS=zeros(1,3);
theEnd=0;
cWRR=zeros(W,R,R);%  jasne ze 4(ostatni) z 4(ostatni) nie bedzie mia³ zamiany
krok=0;
p=1;
disp('----HeuristicMethodSpecialNeighbourhood----');
while(theEnd~=1)&&(V~=0)
    cWRR = ones(W,R,R)*M;%ones(W,R,R-1)*M;
    krok=krok+1;
    %disp(sprintf('k sn %g', krok) );
    [Vwr, V1wr,V2wr, V3wr, V4wr, V5wr]=SpecialNeighbourhood_V5(Xwgr,Ewrz,HEwrz); %wf==1
    V1w=find(sum(Vwr,2)~=0);  %disp(sprintf('length(V1w) %g',length(V1w)));
    for iw=1:length(V1w);
        w=V1w(iw);
        V1r=find(Vwr(w,:)~=0); %disp(sprintf('length(V1r) %g',length(V1r)));
        for ir=1:length(V1r)
            r=V1r(ir);
            for r1 = 1:R%r+1:R
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

                        [Vnew] = CalculateTheCostOfAllAssignment_V5(Xwgr,Ewrz,HEwrz);
                        if r1 < r
                            cWRR(w,r,r1) = Vnew;
                        else
                            cWRR(w,r1,r) = Vnew;
                        end

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
    % disp(sprintf('V= %g Vnew = %g',V,(min(min(min(cWRR))))));
 
    %cWRR
    
    if min(min(min(cWRR))) <V %&& krok<=12
        V=min(min(min(cWRR)));
        [wwn,rr1n,rrn]=find3d(V==cWRR);
        wn=wwn(1);
        r1n=rr1n(1);
        rn=rrn(1);
       %  disp(sprintf('%g %g %g',wwn(1),rr1n(1),rrn(1)));
          WRRS(krok,:)=[wn,r1n,rn];
        tmpX = Xwgr(wn,:,r1n);
        Xwgr(wn,:,r1n) = Xwgr(wn,:,rn);
        Xwgr(wn,:,rn) = tmpX;
        tmpE = Ewrz(wn,rn,:);
        Ewrz(wn,rn,:) = Ewrz(wn,r1n,:);
        Ewrz(wn,r1n,:) = tmpE;
        tmpHE = HEwrz(wn,rn,:);
        HEwrz(wn,rn,:) = HEwrz(wn,r1n,:);
        HEwrz(wn,r1n,:) = tmpHE;
              
    else%if krok>12
        
        %CalculateTheCostOfAllAssignmentVVVVV_V5(Xwgr,Ewrz,HEwrz);   %nie jest potrzebne    
        
     %   [Vhm,cWRR, Xwgr,Ewrz,HEwrz]=HeuristicMethod(Xwgr,Ewrz,HEwrz,V,0);%SN==0
      %  if Vhm<V 
       %     V=Vhm;
        %    CalculateTheCostOfAllAssignmentVVVVV_V5(Xwgr,Ewrz,HEwrz);       %nie jest potrzebne          
        %else    
            theEnd=1;
        %end;
    end;    

  %  disp(sprintf('Vend sn=  %g',V)); 
end;%while