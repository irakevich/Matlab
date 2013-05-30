function [wf ] = SetPunishment()

global C6wr
global W
global R

wf=W/2-1;
ww=wf+2;

C6wr(ww,:)=[1,0,0,1];
