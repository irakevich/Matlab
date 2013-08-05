clearvars -except sroa2old sroa3old;

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

draw=100;
Vhistory=zeros(draw,6);
VhistoryR=zeros(draw,5);
i=1;
SetTheParameters();
S=1;
while i<=draw 
   
    if (i==51)
       Oa=3;
    end;    
    S=S+1;
  
   if (mod(i,10)==1)
        S=1;
        %disp('--------------------- start  -----------------------------');
        [Hwgz,Awgz]=GenerateMatrixes (1); 
        
    end;
    i
    S
%disp('------------------------not random--------------------------');
[XwgrOr, EwrzOr,HEwrzOr,CwgrOr,CwrgOr]=AlgorithmConstrctiveAssignmentHeuristic(Hwgz,Awgz);
[VOr]=CalculateTheCostOfAllAssignment_V5(XwgrOr,EwrzOr,HEwrzOr);
%tic
 %   [Vhm,cWRRhm, Xwgrhm,Ewrzhm,HEwrzhm,WRRG]=HeuristicMethod(XwgrOr,EwrzOr,HEwrzOr,VOr,2);%SN=2
%time=toc;
%Vhistory(i,2)=Vhm;
%Vhistory(i,3)=time;
Vhistory(i,1)=VOr;
Vhistory(i,6)=S;

tic 
    [V,cWRR, Xwgr,Ewrz,HEwrz]= HeuristicMethodSpecialNeighbourhood(XwgrOr,EwrzOr,HEwrzOr,VOr);  
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



