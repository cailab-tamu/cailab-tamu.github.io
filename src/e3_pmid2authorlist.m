addpath('pmidoi\');
e0_pmidoilist;

fid=fopen('authorlist.html','w');
fprintf(fid,"<h3>Author List</h3>\n<ol>");
S_AU=[];

for k=1:length(AAv)
    pause(1)
    AAv(k)
    try
    if contains(AAv(k),'/')
        a=webread(sprintf('https://doi.org/%s',AAv(k)));
        a=strtrim(strsplit(a,{'\n','/>'}))';
        a(strlength(a)==0)=[];
        s_au=aaa(a,'citation_author');
        S_AU=[S_AU; s_au];        
    else    
        a = webread(sprintf('https://pubmed.ncbi.nlm.nih.gov/%s/?format=pubmed',AAv(k)));
        b = extractHTMLText(a);
        c = string(strsplit(b,'\n')');
        s_au=c(startsWith(c,'FAU '));
        % s_au = c(startsWith(c,'AU '));
        s_au = strtrim(extractAfter(s_au,6));
        S_AU=[S_AU; s_au];
    end
    catch ME
        disp(ME.message);
    end
end

S_AU=unique(S_AU);



fprintf(fid,"</ol>\n");
fprintf(fid,"<pre>\n");
for k=1:length(S_AU)
    fprintf(fid,"%s\n",S_AU(k));
end
fprintf(fid,"</pre>\n");
fclose(fid);
    

function s=aaa(a,tag)
    s='';
    tag=sprintf('<meta name="%s" content="',tag);
    idx=find(contains(a,tag));
    if isempty(idx), return; end
    %length(idx)
    s=strings(length(idx),1);
    for k=1:length(idx)
        b=a{idx(k)};
        b=b(strfind(b, tag)+strlength(tag):end);
        b=b(1:strfind(b,'"')-1);
        s(k)=b;  
    end
end