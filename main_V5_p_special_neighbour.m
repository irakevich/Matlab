function  [V,cWRR, Xwgr,Ewrz,HEwrz,V1R] =main_V5_p_special_neighbour(XwgrOr, EwrzOr,HEwrzOr)

global Z
global R
global W
global G
global VCombination;
global Lr
global Oa
global Oh
global S



Vsl=-100;
V=-100;
Vhm=-100;
if exist('startup','file') ~= 2 
    addpath tomlab
    startup
end;
if exist('glpk','file') ~= 2 
    addpath glpkmex-2.11-src\glpkmex\
end;

SetTheParameters();
s=4;Oa=2;Oh=4;R=34;Lr=zeros(R,1);Lr(3,1)=15;Lr(4,1)=15;Lr(5,1)=15;Lr(6,1)=15;

[VOr]=CalculateTheCostOfAllAssignment_V5(XwgrOr,EwrzOr,HEwrzOr);
 CalculateTheCostOfAllAssignmentVVVVV_V5(XwgrOr,EwrzOr,HEwrzOr);

if (find(squeeze(sum(XwgrOr(:,:,:),3))~=1)>0) 
    squeeze(sum(XwgrOr(:,:,:),3)) 
end;
if (find(squeeze(sum(XwgrOr(:,:,:),2))>1)>0)
    squeeze(sum(XwgrOr(:,:,:),2))
end;    
draw=1;
H=zeros(draw,7);

for j=1:draw



    cWRR = [];
    Xwgr = [];

    [V,cWRR, Xwgr,Ewrz,HEwrz]= HeuristicMethodSpecialNeighbourhood(XwgrOr,EwrzOr,HEwrzOr,VOr);
    llrr=squeeze(sum(sum(Xwgr,2),1))';
    R
    disp(llrr);
    VOr
    V
    [V1R]=CalculateTheCostOfAllAssignmentVVVVV_V5(Xwgr,Ewrz,HEwrz);
    V1R


end;




