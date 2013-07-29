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
[Hwgz,Awgz]=GenerateMatrixes (1); %generate==1

tic
   [XwgrOr, EwrzOr,HEwrzOr,CwgrOr,CwrgOr]=AlgorithmConstrctiveAssignmentHeuristic(Hwgz,Awgz);
   % [XwgrOr, EwrzOr,HEwrzOr,CwgrOr,CwrgOr]=Random(Hwgz,Awgz);
   [VOr]=CalculateTheCostOfAllAssignment_V5(XwgrOr,EwrzOr,HEwrzOr);
   squeeze(sum(XwgrOr(:,:,:),3))
toc

tic
    [Vhm,cWRRhm, Xwgrhm,Ewrzhm,HEwrzhm,WRRG]=HeuristicMethod(XwgrOr,EwrzOr,HEwrzOr,VOr,2);%SN=2
    squeeze(sum(Xwgrhm(:,:,:),3))
toc

tic 
    [V,cWRR, Xwgr,Ewrz,HEwrz,WRRS]= HeuristicMethodSpecialNeighbourhood(XwgrOr,EwrzOr,HEwrzOr,VOr);  
    squeeze(sum(Xwgr(:,:,:),3))
toc

VOr
Vhm
CalculateTheCostOfAllAssignmentVVVVV_V5(Xwgrhm,Ewrzhm,HEwrzhm)
size(WRRG)
V
CalculateTheCostOfAllAssignmentVVVVV_V5(Xwgr,Ewrz,HEwrz)
size(WRRS)

