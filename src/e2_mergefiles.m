
C0=i_readtxt('index_template.html');
C1=i_readtxt('news.html');
C2=i_readtxt('publication.html');
C3=i_readtxt('people.html');

i1=find(strcmp('<<<1>>>',C0));
C0=[C0(1:i1-1); C1; C0(i1+1:end)];

i2=find(strcmp('<<<2>>>',C0));
C0=[C0(1:i2-1); C2; C0(i2+1:end)];

i3=find(strcmp('<<<3>>>',C0));
C0=[C0(1:i3-1); C3; C0(i3+1:end)];

writecell(C0,'../index.html','FileType','text','QuoteStrings','none');


function C=i_readtxt(filename)
fileID = fopen(filename);
C=textscan(fileID,'%s','Delimiter','\n','whitespace', '');
%C=textscan(fileID,'%s','Delimiter','\n');
C=C{1};
fclose(fileID);
end

