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

draw=5;
Vhistory=zeros(draw,5);
VhistoryR=zeros(draw,5);
i=1;
while i<=draw 
    i
%disp('--------------------- start  -----------------------------');
SetTheParameters();
[Hwgz,Awgz]=GenerateMatrixes (1); 

%disp('------------------------not random--------------------------');

[XwgrOr, EwrzOr,HEwrzOr,CwgrOr,CwrgOr]=AlgorithmConstrctiveAssignmentHeuristic(Hwgz,Awgz);
C6wr=zeros(W,R);[VOr]=CalculateTheCostOfAllAssignment(XwgrOr,EwrzOr,HEwrzOr,C6wr);

tic
    wf=1; C6wr=zeros(W,R);
    [Vhm,cWRRhm, Xwgrhm,Ewrzhm,HEwrzhm]=HeuristicMethodNew(XwgrOr,EwrzOr,HEwrzOr,VOr,2,wf,C6wr);%SN=2, %wf=1 <-zaczynamy od kolejki 1
time=toc;
Vhistory(i,2)=Vhm;
Vhistory(i,3)=time;
Vhistory(i,1)=VOr;

tic 
    wf=1; C6wr=zeros(W,R);
    [V,cWRR, Xwgr,Ewrz,HEwrz]= HeuristicMethodSpecialNeighbourhoodNew(XwgrOr,EwrzOr,HEwrzOr,VOr,C6wr);  
time=toc;
Vhistory (i,4)=V;
Vhistory(i,5)=time;



%disp('-------------random -------------------------------------------------');
[XwgrR, EwrzR,HEwrzR,CwgrR,CwrgR]=Random(Hwgz,Awgz);
C6wr=zeros(W,R);[VorR]=CalculateTheCostOfAllAssignment(XwgrR,EwrzR,HEwrzR,C6wr);
tic
    wf=1; C6wr=zeros(W,R);
    [VhmR,cWRRhmR, XwgrhmR,EwrzhmR,HEwrzhmR]=HeuristicMethodNew(XwgrR,EwrzR,HEwrzR,VorR,2,wf,C6wr);%SN=2
time=toc;
VhistoryR(i,2)=VhmR;
VhistoryR(i,3)=time;
VhistoryR(i,1)=VorR;

tic 
    wf=1; C6wr=zeros(W,R);
    [V,cWRR, Xwgr,Ewrz,HEwrz]= HeuristicMethodSpecialNeighbourhoodNew(XwgrR,EwrzR,HEwrzR,VorR,C6wr);  
time=toc;
VhistoryR (i,4)=V;
VhistoryR(i,5)=time;


i=i+1;
end;
    





for i=1:0
figure;
hold on;stairs(Vhistory(1:draw,1), '-.k');xlabel('probki');ylabel('V');
hold on;plot(Vhistory(1:draw,2),'-r'); %Vhm
hold on;plot(Vhistory(1:draw,4),'-k'); %V
%hold on;stairs(VhistoryR(1:draw,1), '-.g');
hold on;plot(VhistoryR(1:draw,2),'-b'); %Vhm
hold on;plot(VhistoryR(1:draw,4),'-g'); %V
figure;
hold on;plot(Vhistory(1:draw,3), '-r');xlabel('probki');ylabel('czas t (sec)');
hold on;plot(Vhistory(1:draw,5),'-k')
hold on;plot(VhistoryR(1:draw,3),'-b')
hold on;plot(VhistoryR(1:draw,5),'-g')
end;
