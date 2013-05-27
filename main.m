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
global generate

global cWRR
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
[Hwgz,Awgz]=GenerateMatrixes (); 


tic
[XwgrOr, EwrzOr,HEwrzOr,CwgrOr,CwrgOr]=AlgorithmConstrctiveAssignmentHeuristic(Hwgz,Awgz);
%[XwgrOr, EwrzOr,HEwrzOr,CwgrOr,CwrgOr]=Random(Hwgz,Awgz);
[VOr]=CalculateTheCostOfAllAssignment(XwgrOr,EwrzOr,HEwrzOr)
toc
%tic
%[Xwgr, Ewrz,HEwrz,Cwgr,Cwrg]=Copy_of_AlgorithmConstrctiveAssignmentHeuristic(Hwgz,Awgz);
%[VIra]=CalculateTheCostOfAllAssignment(Xwgr,Ewrz,HEwrz)
%toc




%tic
%[Vhm,cWRRhm, Xwgrhm,Ewrzhm,HEwrzhm]=HeuristicMethod(XwgrOr,EwrzOr,HEwrzOr,VOr,2);%SN=2
%toc
disp('--------------------------------------------------------------');
disp('--------------------------------------------------------------');
disp('--------------------------------------------------------------');
tic 
[V,cWRR, Xwgr,Ewrz,HEwrz]= HeuristicMethodSpecialNeighbourhood(XwgrOr,EwrzOr,HEwrzOr,VOr);  
toc

V
Vhm
