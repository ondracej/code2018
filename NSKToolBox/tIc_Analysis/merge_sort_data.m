ch=[01 18 24 40 46 47 49 51];

eval(['load sort_data_n0',num2str(ch(1))]);
tn=t;
icn=indexchannel;

for i=2:length(ch)
    eval(['load sort_data_n',num2str(ch(i))]);
    eval(['t',num2str(ch(i)),'=t;']);
    eval(['ic',num2str(ch(i)),'=indexchannel;']);
    eval(['[tn,icn]=InsertSortChannel(tn,icn,t',num2str(ch(i)),',ic',num2str(ch(i)),');']);
end
t=tn;
indexchannel=icn;