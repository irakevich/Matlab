function [cWRR] = main_V5_p (XwgrOr, EwrzOr,HEwrzOr)

global Z
global R
global W
global G
global VCombination;
global Lr
global Oa
global Oh
global S
global generate



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
%[Hwgz,Awgz]=GenerateMatrixes (); 

tic
 %   [XwgrOr, EwrzOr,HEwrzOr,CwgrOr,CwrgOr]=AlgorithmConstrctiveAssignmentHeuristic(Hwgz,Awgz);
    %[XwgrOr, EwrzOr,HEwrzOr,CwgrOr,CwrgOr]=Random(Hwgz,Awgz);
    [VOr]=CalculateTheCostOfAllAssignment_V5(XwgrOr,EwrzOr,HEwrzOr)
toc

tic
    [Vhm,cWRRhm, Xwgrhm,Ewrzhm,HEwrzhm,WRRG]=HeuristicMethod(XwgrOr,EwrzOr,HEwrzOr,VOr,2);%SN=2
    
toc
cWRR = [];
tic 
    [V,cWRR, Xwgr,Ewrz,HEwrz,WRRS]= HeuristicMethodSpecialNeighbourhood(XwgrOr,EwrzOr,HEwrzOr,VOr);  
    
toc

VOr
Vhm
CalculateTheCostOfAllAssignmentVVVVV_V5(Xwgrhm,Ewrzhm,HEwrzhm)
WRRG
V
CalculateTheCostOfAllAssignmentVVVVV_V5(Xwgr,Ewrz,HEwrz)
WRRS

