function [Vbest,Xwgrbest,Ewrzbest,HEwrzbest,krok]=HeuristicMethod_V6_SL(Xwgr,Ewrz,HEwrz,V,L,N,wf,C6wr)


global R 
global W

%n=1+ceil(3*rand(1,1));
%N=round(length(L)/n);%round(length(L)/7.2);
i=0;
Vbest=V;
Xwgrbest=Xwgr;
Ewrzbest=Ewrz;
HEwrzbest=HEwrz;
krok=0;
z=0;
disp('-----HeuristicMethod_SL-------');
while (i<N) &&( Vbest~=0) && (krok<500000)
    krok=krok+1;
    %disp(sprintf('while i= %g',i));
    wi=ceil((W-wf+1)*rand(1,1));
    w=wf+wi-1;
    r=ceil(R*rand(1,1));
    r1=ceil((R-1)*rand(1,1));
    if (r==r1)
        r1=r1+1;
    end;
    %disp (sprintf('w %g r %g r1 %g',w,r,r1));
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
        
        [Vv] = CalculateTheCostOfAllAssignment(Xwgr,Ewrz,HEwrz,C6wr);
        %disp (sprintf ('V %g   Vv %g   Vb %g' ,V,Vv,Vbest));
        maxL=max(L);
            
        if Vv>V 
          %  disp('if Vv>V');
           if Vv-V<maxL %zmien delta
                delta=Vv-V;
                idx=find(L==maxL);
                L(idx(1,1))=delta;
                V=Vv;
                z=i;
                i=0;
            else
                i=i+1;
                Xwgr(w,:,r) = Xwgr(w,:,r1);
                Xwgr(w,:,r1) = tmpX;
                Ewrz(w,r1,:) = Ewrz(w,r,:);
                Ewrz(w,r,:) = tmpE;
                HEwrz(w,r1,:) = HEwrz(w,r,:);
                HEwrz(w,r,:) = tmpHE;
            end;    
        else
           % disp('if Vv<=V');
            z=i;
            i=0;
            if Vv<Vbest % nowa wartosc lepsza od poprzedniej
               Vbest=Vv;
               Xwgrbest=Xwgr;
               Ewrzbest=Ewrz;
               HEwrzbest=HEwrz;
                %zapamiêtuje wszystkie wartosc Xwgr,Ewrz,HEwrz...
            end;
            V=Vv;
        end;
        %i
        %L
        
    end;
    
end;%while    
if krok>=500000
    disp('UWAGA !!!!!');disp(krok);
    
end;    
disp(sprintf('V= %g Vbest = %g  krok = %g z = %g i = %g',V,Vbest, krok, z, i));
