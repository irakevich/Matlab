function [Hwgz,Awgz]=GenerateMatrixes ()

global Z
global R
global W
global G
global generate


HwgzTMP=zeros(W/2,G,Z);
AwgzTMP=zeros(W/2,G,Z);
Hwgz=zeros(W,G,Z);
Awgz=zeros(W,G,Z);


if generate==1
    tic
    i=1;
    while i~=10
        try 
            [Mh,Ma] = ScheduleLeague();
            disp(sprintf('ScheduleLeague =>  %g I => %g ',toc, i));
            i=10;
        catch exception
            i=i+1;
        end;   
    end;
    
else
    [Mh,Ma]=UseMatrixes();
end;


for w= 1:1:W/2
    for g= 1:1:G
        HwgzTMP(w,g,Mh(w,g)) = 1;
        AwgzTMP(w,g,Ma(w,g)) = 1;
    end
end

%HwgzTMP = Hwgz;
for t=1:1:Z
    Hwgz(:,:,t) = [HwgzTMP(:,:,t) ; AwgzTMP(:,:,t)];
    Awgz(:,:,t) = [AwgzTMP(:,:,t) ; HwgzTMP(:,:,t)];
end;
%Hwgz = [HwgzTMP , Awgz];
%Awgz = [AwgzTMP, HwgzTMP];