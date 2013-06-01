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
global M

V=-100;
 Vhm=-100; VhmCup=-100;V=-100;VCup=-100;
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
[VOr]=CalculateTheCostOfAllAssignment(XwgrOr,EwrzOr,HEwrzOr,C6wr)
toc

disp ('-----HeuristicMethodNew----');
wf=1; C6wr=zeros(W,R);
[Vhm,cWRRhm, Xwgrhm,Ewrzhm,HEwrzhm]=HeuristicMethodNew(XwgrOr,EwrzOr,HEwrzOr,VOr,2,wf,C6wr);%SN=2, %wf=1 <-zaczynamy od kolejki 1

cup=1;
if (cup==1)
    disp('----------------- Set the punishment CUP ---------------------------------------------');
    [wf,C6wr]=SetPunishment();
    
    disp ('-----HeuristicMethodNew----');
    [VhmCup]=CalculateTheCostOfAllAssignment(Xwgrhm,Ewrzhm,HEwrzhm,C6wr);
    [VhmAfterCup,cWRRhm, Xwgrhm,Ewrzhm,HEwrzhm]=HeuristicMethodNew(Xwgrhm,Ewrzhm,HEwrzhm,VhmCup,2,wf,C6wr);%SN=2,%wf=1 <-zaczynamy od kolejki 1
     
    disp('----------------- Start with the punishment CUP ---------------------------------------------');
    [VOrCup]=CalculateTheCostOfAllAssignment(XwgrOr,EwrzOr,HEwrzOr,C6wr);
    disp ('-----HeuristicMethodNew----');
    [VhmSCup,cWRRhm, Xwgrhm,Ewrzhm,HEwrzhm]=HeuristicMethodNew(XwgrOr,EwrzOr,HEwrzOr,VOrCup,2,wf,C6wr);%SN=2, %wf=1 <-zaczynamy od kolejki 1
    [v]=CalculateTheCostOfAllAssignment(Xwgrhm,Ewrzhm,HEwrzhm,C6wr)
    disp(sprintf('!!!!! VOr, Vhm,  VhmCup, VhmAfterCup,VOrCup,VhmSCup %g %g %g %g %g %g ',VOr,Vhm,  VhmCup, VhmAfterCup,VOrCup,VhmSCup)); 
  %  disp(sprintf('!!!!!V ,VCup, VAfterCup ,VOrCup,VSCup %g %g %g %g %g ',V ,VCup, VAfterCup ,VOrCup,VSCup ));
end;   


