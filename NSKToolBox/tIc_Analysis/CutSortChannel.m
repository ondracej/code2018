% [tNew,icNew,tStart]=CutSortChannel(t,indexchannel,tStart,tEnd,outMessage);
% Function purpose : cuts out a peace of a recording between timings tStart
%                    if a neuron does not fire in this piece it is deleted
%
% Function recives :    t - firing timings
%                       ic - indexc channel
%                       tStart - starting time 
%                       tEnd - ending time
%                       outMessage - send out messages
%                
% Function give back :  tNew - new firing timings
%                       icNew - new indexc channel
%                        tStart - the start time of the new sort channel
%
% To show paster plot use : plotraster(tNew,icNew);
% Last updated : 02/03/09

function [tNew,icNew,tStart]=CutSortChannel(t,ic,tStart,tEnd,outMessage)
if nargin<4
    error('Not enough arguments');
elseif nargin==4
    outMessage=true;
end

to_delete=[];
icNew=zeros(size(ic));
icNew(1:2,:)=ic(1:2,:);
tNew=[];
for i=1:size(ic,2),
    tChannel=t(ic(3,i):ic(4,i));
    tCut=tChannel(find(tChannel>tStart & tChannel<tEnd));
    if isempty(tCut),
        if outMessage
            fprintf('\nNeuron %d %d does not fire during selected interval and therfore was deleted',ic(1:2,i));
        end
        to_delete=[to_delete i];
    else
        icNew(3,i)=length(tNew)+1;
        tNew=[tNew, tCut];
        icNew(4,i)=length(tNew);
    end
end
icNew(:,to_delete)=[];
if outMessage
    fprintf('\nPlease remember that cut segment started at time %d in the whole sort Channel\n',tStart);
end
tNew=tNew-tStart;

    