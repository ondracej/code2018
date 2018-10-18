recordingFile='D:\PostDoc\Experiments\test example\MCDTest.mcd';
MCR=MCRackRecording(recordingFile);

M=MCR.getData(MCR.channelNumbers,0,10000);
M=MCR.getData(MCR.channelNumbers,0,1000);

profile on;[Mout]=spikeDetection(M,10e3,1e3);profile off;
profile viewer;