clear all;

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
V=-100;
Vhm=-100;Vhm1=-100;Vhm2=-100;
if exist('startup','file') ~= 2 
    addpath tomlab
    startup
end;
if exist('glpk','file') ~= 2 
    addpath glpkmex-2.11-src\glpkmex\
end;

SetTheParameters();

[Hwgz,Awgz]=GenerateMatrixes (1); 
[XwgrOr, EwrzOr,HEwrzOr,CwgrOr,CwrgOr]=AlgorithmConstrctiveAssignmentHeuristic(Hwgz,Awgz);
%[XwgrOr, EwrzOr,HEwrzOr,CwgrOr,CwrgOr]=Random(Hwgz,Awgz);
[VOr]=CalculateTheCostOfAllAssignment_V5(XwgrOr,EwrzOr,HEwrzOr);

if (find(squeeze(sum(XwgrOr(:,:,:),3))~=1)>0) 
    squeeze(sum(XwgrOr(:,:,:),3)) 
end;
if (find(squeeze(sum(XwgrOr(:,:,:),2))>1)>0)
    squeeze(sum(XwgrOr(:,:,:),2))
end;    
draw=5;
H=zeros(draw,7);
for j=1:draw

H(j,3)=VOr;
%tic
    [L]=ListBasedTresholdAccepting(XwgrOr,EwrzOr,HEwrzOr);
    disp(sprintf('length(L) %g',length(L)));
    [Vsl,Xwgrsl,Ewrzsl,HEwrzsl,N]=HeuristicMethod_V5_SL(XwgrOr,EwrzOr,HEwrzOr,VOr,L);
    if (find(squeeze(sum(Xwgrsl(:,:,:),3))~=1)>0) 
        squeeze(sum(Xwgrsl(:,:,:),3)) 
    end;
    if (find(squeeze(sum(Xwgrsl(:,:,:),2))>1)>0)
        squeeze(sum(Xwgrsl(:,:,:),2))
    end;   
    H(j,4)=Vsl;
    H(j,5)=length(L);
    H(j,6)=N;
    
time=toc;
    H(j,7)=time;

%tic
    [Vhm,cWRRhm, Xwgrhm,Ewrzhm,HEwrzhm,WRRG]=HeuristicMethod(XwgrOr,EwrzOr,HEwrzOr,VOr,2);%SN=2
    if (find(squeeze(sum(Xwgrhm(:,:,:),3))~=1)>0) 
        squeeze(sum(Xwgrhm(:,:,:),3)) 
    end;
    if (find(squeeze(sum(Xwgrhm(:,:,:),2))>1)>0)
        squeeze(sum(Xwgrhm(:,:,:),2))
    end;   
    H(j,1)=Vhm;
%toc

%tic 
    [V,cWRR, Xwgr,Ewrz,HEwrz,WRRS]= HeuristicMethodSpecialNeighbourhood(XwgrOr,EwrzOr,HEwrzOr,VOr);
    if (find(squeeze(sum(Xwgr(:,:,:),3))~=1)>0) 
        squeeze(sum(Xwgr(:,:,:),3)) 
    end;
    if (find(squeeze(sum(Xwgr(:,:,:),2))>1)>0)
        squeeze(sum(Xwgr(:,:,:),2))
    end;   
    H(j,2)=V;
%toc


end;

