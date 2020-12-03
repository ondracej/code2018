function x=wind(fs,wds,x);
% fs in Hz, gate duration in s, vector.
npts=length(x);
f=1/(2*wds);
t=0:1/fs:2*wds-1/fs;
m=(1+sin(2*pi*t*f-pi/2))/2;
mpts=length(m);
if mpts>npts,
   error('window too long for this stimulus!');
end

x(1:floor(mpts/2))=x(1:floor(mpts/2)).*m(1:floor(mpts/2));
x(npts-ceil(mpts/2):npts)=x(npts-ceil(mpts/2):npts).*m(mpts-ceil(mpts/2):mpts);
