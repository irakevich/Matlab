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

draw=5;
Vhistory=zeros(draw,5);
VhistoryR=zeros(draw,5);
i=1;
while i<=draw 
    i
%disp('--------------------- start  -----------------------------');
%disp('--------------------------------------------------------------');

SetTheParameters();
[Hwgz,Awgz]=GenerateMatrixes (); 

%disp('------------------------not random--------------------------');

[XwgrOr, EwrzOr,HEwrzOr,CwgrOr,CwrgOr]=AlgorithmConstrctiveAssignmentHeuristic(Hwgz,Awgz);
[VOr]=CalculateTheCostOfAllAssignment_V5(XwgrOr,EwrzOr,HEwrzOr);

    tic
     [Vhm,cWRRhm, Xwgrhm,Ewrzhm,HEwrzhm]=HeuristicMethod(XwgrOr,EwrzOr,HEwrzOr,VOr,2);%SN=2
    time=toc;
   
    Vhistory(i,2)=Vhm;
    Vhistory(i,3)=time;

 Vhistory(i,1)=VOr;
tic 
 [V,cWRR, Xwgr,Ewrz,HEwrz]= HeuristicMethodSpecialNeighbourhood(XwgrOr,EwrzOr,HEwrzOr,VOr);  
time=toc;
Vhistory (i,4)=V;
Vhistory(i,5)=time;



disp('-------------random -------------------------------------------------');
[XwgrR, EwrzR,HEwrzR,CwgrR,CwrgR]=Random(Hwgz,Awgz);
[VorR]=CalculateTheCostOfAllAssignment_V5(XwgrR,EwrzR,HEwrzR)

    disp('-------------1 ------------');
    tic
    
    [VhmR,cWRRhm, Xwgrhm,Ewrzhm,HEwrzhm]=HeuristicMethod(XwgrR,EwrzR,HEwrzR,VorR,2);%SN=2
    time=toc;
    VhmR
    
    VhistoryR(i,2)=VhmR;
    VhistoryR(i,3)=time;

VhistoryR(i,1)=VorR;
disp('-------------2 ------------');
tic 

 [V,cWRR, Xwgr,Ewrz,HEwrz]= HeuristicMethodSpecialNeighbourhood(XwgrR,EwrzR,HEwrzR,VorR);  
time=toc;
V
VhistoryR (i,4)=V;
VhistoryR(i,5)=time;


i=i+1;
end;
    

