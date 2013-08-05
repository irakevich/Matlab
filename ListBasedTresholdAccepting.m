function [L]=ListBasedTresholdAccepting(Xwgr,Ewrz,HEwrz,l)

global W
global R
global G
a=round(W*G*R/3);
%if W*G*R<a
 %   a=W*G*R;
%end;   
%l=a/2;%960%a+ceil(a/2*rand(1,1));%720
L=zeros(1,l);


for i=1:l
        
[V] = CalculateTheCostOfAllAssignment_V5(Xwgr,Ewrz,HEwrz);
delta=0;
while delta<=0
    w=ceil(W*rand(1,1));
    %g=ceil(G*rand(1,1));
    %r1=find(squeeze(Xwgr(w,g,:))==1); 
    r1=ceil(R*rand(1,1));
    r2=ceil((R-1)*rand(1,1));
    if (r2==r1)
        r2=r2+1;
    end;
    %disp (sprintf('w %g r1 %g r2 %g',w,r1,r2));
    if sum(Xwgr(w,:,r2),2)+sum(Xwgr(w,:,r1),2) > 0
        tmpX = Xwgr(w,:,r1);
        Xwgr(w,:,r1) = Xwgr(w,:,r2);
        Xwgr(w,:,r2) = tmpX;
        tmpE = Ewrz(w,r2,:);
        Ewrz(w,r2,:) = Ewrz(w,r1,:);
        Ewrz(w,r1,:) = tmpE;
        tmpHE = HEwrz(w,r2,:);
        HEwrz(w,r2,:) = HEwrz(w,r1,:);
        HEwrz(w,r1,:) = tmpHE;
        
        [Vv] = CalculateTheCostOfAllAssignment_V5(Xwgr,Ewrz,HEwrz);
        %disp (sprintf ('V %g Vv %g' ,V,Vv));
        
        Xwgr(w,:,r2) = Xwgr(w,:,r1);
        Xwgr(w,:,r1) = tmpX;
        Ewrz(w,r1,:) = Ewrz(w,r2,:);
        Ewrz(w,r2,:) = tmpE;
        HEwrz(w,r1,:) = HEwrz(w,r2,:);
        HEwrz(w,r2,:) = tmpHE;
       
        if V<Vv
            delta=Vv-V;
            L(1,i)=delta; 
        end;    
    end;   
end;
end;%for
    
