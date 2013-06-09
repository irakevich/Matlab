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
Vhm=-100;Vhm1=-100;Vhm2=-100;
if exist('startup','file') ~= 2 
    addpath tomlab
    startup
end;
if exist('glpk','file') ~= 2 
    addpath glpkmex-2.11-src\glpkmex\
end;

SetTheParameters();
[Hwgz,Awgz]=GenerateMatrixes (); 
C6wr=zeros(W,R);

tic
[XwgrOr, EwrzOr,HEwrzOr,CwgrOr,CwrgOr]=AlgorithmConstrctiveAssignmentHeuristic(Hwgz,Awgz);
%[XwgrOr, EwrzOr,HEwrzOr,CwgrOr,CwrgOr]=Random(Hwgz,Awgz);
C6wr=zeros(W,R);[VOr]=CalculateTheCostOfAllAssignment(XwgrOr,EwrzOr,HEwrzOr,C6wr)
toc
%tic
%[Xwgr, Ewrz,HEwrz,Cwgr,Cwrg]=Copy_of_AlgorithmConstrctiveAssignmentHeuristic(Hwgz,Awgz);
%[VIra]=CalculateTheCostOfAllAssignment(Xwgr,Ewrz,HEwrz)
%toc




%tic
wf=1;C6wr=zeros(W,R);
[Vhm,cWRRhm, Xwgrhm,Ewrzhm,HEwrzhm]=HeuristicMethodNew(XwgrOr,EwrzOr,HEwrzOr,VOr,2,wf,C6wr);%SN=2
%toc
disp('--------------------------------------------------------------');
disp('--------------------------------------------------------------');
disp('--------------------------------------------------------------');
%tic 
wf=1;C6wr=zeros(W,R);
[V,cWRR, Xwgr,Ewrz,HEwrz]= HeuristicMethodSpecialNeighbourhoodNew(XwgrOr,EwrzOr,HEwrzOr,VOr,C6wr);  
%toc

VOr
Vhm
V

