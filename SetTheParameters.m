function SetTheParameters()

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
global M
M=2147483647;

generate=1; %1 -czy generowac SheduleLeague czy 0 -u¿yc sta³ego grafiku
Z=16;%Z - number of teams
R=18;%R - number of referees
Lr=zeros(R,1);
%Lr(1,1)=17;Lr(2)=17;%Lr(3)=17;Lr(4)=17;
S=4; %odleglosc (w kolejkach) miedzy dwoma meczami  
Oa=2; 
Oh=1;





%W- number of stages
if mod(Z,2)==0
    W=(Z-1)*2;
else
    W=Z*2;
end;
G=floor(Z/2); % G - number of games in each stage

C6wr=zeros(W,R);

VCombination=zeros(W);
for n=2:W
    %k=2
    Vcombination(n)=factorial(n)/(factorial(2)*factorial(n-2));
end;  