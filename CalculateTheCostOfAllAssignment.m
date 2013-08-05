    function [V]=CalculateTheCostOfAllAssignment(Xwgr,Ewrz,HEwrz,C6wr)
       

global Lr
global Oa
global Oh
global S
global W
global R


 % -- V1
             
    V1 = 0;
    for i = 1:W-1
        V1 = V1+ sum(sum(sum(Ewrz(i,:,:).*sum(Ewrz(i+1:min(i+S-1,W),:,:),1),1),2),3);
        
    end;
     %disp(sprintf('V1%g',V1));
 % -- V2                
    V2 = sum(sum(max(sum(Ewrz, 1) - Oa, 0),2),3);
     %disp(sprintf('V2%g',V2));
 % --V3    

    V3 = sum(sum(max(sum(HEwrz, 1) - Oh, 0),2),3);
    %disp(sprintf('V3%g',V3));
 % --V4
    TMPX11r=sum(sum(Xwgr(:,:,:),1),2);
    TMPXr=TMPX11r(:); %sp³aszczyæ wynik do wektora
    V4=sum(max(Lr(:,1)-TMPXr,0),1);
    %disp(sprintf('V4%g',V4));
 % --V5
    V5=sum(sum(sum( max( Xwgr(1:W/2,:,:)+Xwgr(W/2+1:W,:,:)-1,0),1),2),3);
    %disp(sprintf('V5%g',V5));
 % --V6
    V6=0;
    V6=sum(sum(squeeze(sum(Xwgr,2)).*C6wr *1000,1),2); 
    V = V1+V2+V3+V4+V5+V6;
    
    %disp(sprintf('V=%g %g %g %g %g',V1,V2,V3,V4,V5));
 