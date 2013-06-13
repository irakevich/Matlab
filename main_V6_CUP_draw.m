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
 Vhm=-100; VhmCup=-100;V=-100;VCup=-100;
if exist('startup','file') ~= 2 
    addpath tomlab
    startup
end;
if exist('glpk','file') ~= 2 
    addpath glpkmex-2.11-src\glpkmex\
end;


draw=1;
VhistoryG=zeros(draw,6);
VhistoryS=zeros(draw,6);
i=1;
SetTheParameters();
while i<=draw 
i
[Hwgz,Awgz]=GenerateMatrixes (1); 
C6wr=zeros(W,R);
[XwgrOr, EwrzOr,HEwrzOr,CwgrOr,CwrgOr]=AlgorithmConstrctiveAssignmentHeuristic(Hwgz,Awgz);
%[XwgrOr, EwrzOr,HEwrzOr,CwgrOr,CwrgOr]=Random(Hwgz,Awgz);
[VOr]=CalculateTheCostOfAllAssignment(XwgrOr,EwrzOr,HEwrzOr,C6wr);

%disp ('-----HeuristicMethodNew----');
wf=1; C6wr=zeros(W,R);
[Vhm,cWRRhm, Xwgrhm,Ewrzhm,HEwrzhm]=HeuristicMethodNew(XwgrOr,EwrzOr,HEwrzOr,VOr,2,wf,C6wr);%SN=2, %wf=1 <-zaczynamy od kolejki 1

%disp ('-----HeuristicMethodSpecialNeighbourhoodNew----');
wf=1; C6wr=zeros(W,R);
[V,cWRR, Xwgr,Ewrz,HEwrz]= HeuristicMethodSpecialNeighbourhoodNew(XwgrOr,EwrzOr,HEwrzOr,VOr,wf,C6wr); % puchar=1;

cup=1;
if (cup==1)
        disp('----------------- Set the punishment CUP ---------------------------------------------');
        [wf,C6wr]=SetPunishment();

        disp ('-----HeuristicMethodNew----');
        [VhmCup]=CalculateTheCostOfAllAssignment(Xwgrhm,Ewrzhm,HEwrzhm,C6wr);
        [VhmAfterCup,cWRRhm, Xwgrhm,Ewrzhm,HEwrzhm]=HeuristicMethodNew(Xwgrhm,Ewrzhm,HEwrzhm,VhmCup,2,wf,C6wr);%SN=2,%wf=1 <-zaczynamy od kolejki 1

        disp ('-----HeuristicMethodSpecialNeighbourhoodNew----');
        [VCup]=CalculateTheCostOfAllAssignment(Xwgr,Ewrz,HEwrz,C6wr);
        [VAfterCup,cWRR, Xwgr,Ewrz,HEwrz]= HeuristicMethodSpecialNeighbourhoodNew(Xwgr,Ewrz,HEwrz,VCup,wf,C6wr); % puchar=1;

        disp('----------------- Poczatkowe rozwiazanie+ with the punishment CUP ---------------------------------------------');
        [VOrCup]=CalculateTheCostOfAllAssignment(XwgrOr,EwrzOr,HEwrzOr,C6wr);
        disp ('-----HeuristicMethodNew----');
        [VhmSCup,cWRRhm, Xwgrhm,Ewrzhm,HEwrzhm]=HeuristicMethodNew(XwgrOr,EwrzOr,HEwrzOr,VOrCup,2,wf,C6wr);%SN=2, %wf=1 <-zaczynamy od kolejki 1
        disp ('-----HeuristicMethodSpecialNeighbourhoodNew----');
        [VSCup,cWRR, XwgrC,EwrzC,HEwrzC]= HeuristicMethodSpecialNeighbourhoodNew(XwgrOr,EwrzOr,HEwrzOr,VOrCup,wf,C6wr); % puchar=1;

        disp(sprintf('!!!!!VOr, Vhm,  VhmCup, VhmAfterCup,VOrCup,VhmSCup %g %g %g %g %g %g ',VOr,Vhm,  VhmCup, VhmAfterCup,VOrCup,VhmSCup)); 
        disp(sprintf('!!!!!V ,VCup, VAfterCup ,VOrCup,VSCup %g %g %g %g %g ',V ,VCup, VAfterCup ,VOrCup,VSCup ));
        VhistoryG(i,1)=VOr;
        VhistoryG(i,2)=Vhm;
        VhistoryG(i,3)=VhmCup;
        VhistoryG(i,4)=VhmAfterCup;
        VhistoryG(i,5)=VOrCup;
        VhistoryG(i,6)=VhmSCup;
        
        
        VhistoryS(i,1)=VOr;
        VhistoryS(i,2)=V;
        VhistoryS(i,3)=VCup;
        VhistoryS(i,4)=VAfterCup;
        VhistoryS(i,5)=VOrCup;
        VhistoryS(i,6)=VSCup;
end;   
i=i+1;
end;

for i=1:0

disp('------------------------CUP and NOT--------------------------------------');
wf=1; C6wr=zeros(W,R);
[Vhm2,cWRRhm, Xwgrhm,Ewrzhm,HEwrzhm]=HeuristicMethodCupAndNot(XwgrOr,EwrzOr,HEwrzOr,VOr,2,1,1,C6wr);%SN=2 %wf=1 <-zaczynamy od kolejki 1,puchar=1
disp('--------------------------------------------------------------');
wf=1; C6wr=zeros(W,R);
[V2,cWRR, Xwgr,Ewrz,HEwrz]=HeuristicMethodSpecialNeighbourhoodCupAndNot(XwgrOr,EwrzOr,HEwrzOr,VOr,1,C6wr); % puchar=1;
disp(sprintf('!!!! Vhm2= V2= %g %g',Vhm2, V2));

end;