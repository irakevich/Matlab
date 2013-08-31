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

draw=1;
Vhistory=zeros(draw,6);
VhistoryR=zeros(draw,5);
i=1;

SetTheParameters();
%s=4;Oa=2;Oh=4;R=34;Lr=ones(R,1)*6;Lr(3,1)=15;Lr(4,1)=15;Lr(5,1)=12;Lr(6,1)=12;Lr(7,1)=12;
s=4;Oa=2;Oh=4;R=34;Lr=ones(R,1)*5;Lr(3,1)=15;Lr(4,1)=15;Lr(5,1)=15;Lr(6,1)=15;Lr(7,1)=10;Lr(8,1)=10;Lr(2,1)=10;Lr(1,1)=10;

while i<=draw 
    [Hwgz,Awgz]=GenerateMatrixes (1); 
    %R=R+8;Lr=ones(R,1).*9;
    
%disp('------------------------not random--------------------------');
[XwgrOr, EwrzOr,HEwrzOr,CwgrOr,CwrgOr]=AlgorithmConstrctiveAssignmentHeuristic(Hwgz,Awgz);
[VOr]=CalculateTheCostOfAllAssignment_V5(XwgrOr,EwrzOr,HEwrzOr);

%tic
 %   [Vhm,cWRRhm, Xwgrhm,Ewrzhm,HEwrzhm,WRRG]=HeuristicMethod(XwgrOr,EwrzOr,HEwrzOr,VOr,2);%SN=2
%time=toc;
%Vhistory(i,2)=Vhm;
%Vhistory(i,3)=time;
Vhistory(i,1)=VOr;
Vhistory(i,6)=Oa;

tic 
    [V,cWRR, Xwgr,Ewrz,HEwrz]= HeuristicMethodSpecialNeighbourhood(XwgrOr,EwrzOr,HEwrzOr,VOr);  
    llrr=squeeze(sum(sum(Xwgr,2),1))';
    R
    disp(llrr);
    VOr
    V
    [V1R]=CalculateTheCostOfAllAssignmentVVVVV_V5(Xwgr,Ewrz,HEwrz);
    
time=toc;
Vhistory (i,4)=V;
Vhistory(i,5)=time;

for j=1:0
%disp('-------------random -------------------------------------------------');
[XwgrR, EwrzR,HEwrzR,CwgrR,CwrgR]=Random(Hwgz,Awgz);
[VorR]=CalculateTheCostOfAllAssignment_V5(XwgrR,EwrzR,HEwrzR);
tic
    [VhmR,cWRRhm, Xwgrhm,Ewrzhm,HEwrzhm,WRRG]=HeuristicMethod(XwgrR,EwrzR,HEwrzR,VorR,2);%SN=2
time=toc;
VhistoryR(i,2)=VhmR;
VhistoryR(i,3)=time;
VhistoryR(i,1)=VorR;

tic 
    [V,cWRR, Xwgr,Ewrz,HEwrz]= HeuristicMethodSpecialNeighbourhood(XwgrR,EwrzR,HEwrzR,VorR);  
time=toc;
VhistoryR (i,4)=V;
VhistoryR(i,5)=time;
end;

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



