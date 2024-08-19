addpath('pmidoi\');
e0_pmidoilist;

fid=fopen('publication.html','w');
fprintf(fid,"<h3>Journal Articles</h3>\n<ol>");
for k=1:length(AAv)
    AAv(k)
    pause(1)
    ishighlighted=ismember(AAv(k),Highlighted);

    if contains(AAv(k),'/')
        s=i_doi2html(AAv(k),ishighlighted);
    else
        s=i_pmid2html(AAv(k),ishighlighted);
    end
   fprintf(fid,"%s",s);
end
fprintf(fid,"</ol>\n");
fclose(fid);


fid=fopen('selectpublications.html','w');
fprintf(fid,"<h3>Select Publications</h3>\n<ol>");
for k=1:length(Highlighted)
    Highlighted(k)
    pause(1)
    ishighlighted = ~ismember(Highlighted(k),Highlighted);
    if contains(Highlighted(k),'/')
        s=i_doi2html(Highlighted(k), ishighlighted);
    else
        s=i_pmid2html(Highlighted(k), ishighlighted);
    end
   fprintf(fid,"%s",s);
end
fprintf(fid,"</ol>\n");
fclose(fid);


