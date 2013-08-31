clearvars -except sroa2 sroa3;

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



draw=20;
Vpocz=zeros(draw,6);
SetTheParameters();
[Hwgz,Awgz]=GenerateMatrixes (1); %generate==1
i=1;
while i<=draw 
i

tic
[XwgrOr, EwrzOr,HEwrzOr,CwgrOr,CwrgOr]=AlgorithmConstrctiveAssignmentHeuristic(Hwgz,Awgz);
time=toc;
[VOr]=CalculateTheCostOfAllAssignment_V5(XwgrOr,EwrzOr,HEwrzOr);
Vpocz(i,1)=VOr;
Vpocz(i,2)=time;

tic
  [XwgrOrR, EwrzOrR,HEwrzOrR]=RandomRandom(Hwgz,Awgz);   
time=toc;
[VOrRR]=CalculateTheCostOfAllAssignment_V5(XwgrOrR,EwrzOrR,HEwrzOrR);
Vpocz(i,3)=VOrRR;
Vpocz(i,4)=time;

tic
  [XwgrOrR, EwrzOrR,HEwrzOrR,CwgrOrR,CwrgOrR]=Random(Hwgz,Awgz);   
time=toc;
[VOrR]=CalculateTheCostOfAllAssignment_V5(XwgrOrR,EwrzOrR,HEwrzOrR);
Vpocz(i,5)=VOrR;
Vpocz(i,6)=time;


i=i+1;
end;
 
