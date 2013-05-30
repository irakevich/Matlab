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
global C6wr
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
[Vhm,cWRRhm, Xwgrhm,Ewrzhm,HEwrzhm]=HeuristicMethod(XwgrOr,EwrzOr,HEwrzOr,VOr,2);%SN=2
C6wr=zeros(W,R);
[Vhm1,cWRRhm, Xwgrhm,Ewrzhm,HEwrzhm]=HeuristicMethodCup(XwgrOr,EwrzOr,HEwrzOr,VOr,2,1,0);%SN=2 %wf=1 <-zaczynamy od kolejki 1,puchar=1
C6wr=zeros(W,R);
[Vhm2,cWRRhm, Xwgrhm,Ewrzhm,HEwrzhm]=HeuristicMethodCupAndNot(XwgrOr,EwrzOr,HEwrzOr,VOr,2,1,0);%SN=2 %wf=1 <-zaczynamy od kolejki 1,puchar=1
%toc
disp('--------------------------------------------------------------');
disp('--------------------------------------------------------------');
disp('--------------------------------------------------------------');
%tic 
%[V,cWRR, Xwgr,Ewrz,HEwrz]= HeuristicMethodSpecialNeighbourhood(XwgrOr,EwrzOr,HEwrzOr,VOr);  
%[V,cWRR, Xwgr,Ewrz,HEwrz]= HeuristicMethodSpecialNeighbourhoodCup(XwgrOr,EwrzOr,HEwrzOr,VOr,1); % puchar=1;
%[V,cWRR, Xwgr,Ewrz,HEwrz]= HeuristicMethodSpecialNeighbourhoodCupAndNot(XwgrOr,EwrzOr,HEwrzOr,VOr,1); % puchar=1;

%toc

V
Vhm
Vhm1
Vhm2
