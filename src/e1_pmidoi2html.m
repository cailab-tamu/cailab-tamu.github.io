addpath('pmidoi\');
e0_pmidoilist;

wavefilev = matlab.lang.makeValidName(AAv);

fid=fopen('publications.html','w');
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
   fprintf(fid,"\n%s",s);
   if exist(sprintf('../wav/%s.wav', wavefilev(k)),'file')
       fprintf(fid,"<audio controls src=""wav/%s.wav"" style=""height: 30px;""></audio>\n", wavefilev(k));
       % fprintf(fid,"<audio controls style=""width: 200px; height: 30px;""><source src=""wav/%s.wav"" type=""audio/wave""></audio>\n", wavefilev(k));
   end
end
fprintf(fid,"</ol>\n");
fclose(fid);


fid=fopen('selectpublications.html','w');
fprintf(fid,"<h3>Select Publications</h3>\n<ol>");
for k=1:length(Highlighted)
    Highlighted(k)
    pause(1)
    ishighlighted = ~ismember(Highlighted(k),Highlighted);
    try
        if contains(Highlighted(k),'/')
            s=i_doi2html(Highlighted(k), ishighlighted);
        else
            s=i_pmid2html(Highlighted(k), ishighlighted);
        end
    catch ME
        disp(ME.message);
        pause(5)
        if contains(Highlighted(k),'/')
            s=i_doi2html(Highlighted(k), ishighlighted);
        else
            s=i_pmid2html(Highlighted(k), ishighlighted);
        end
    end
   fprintf(fid,"%s",s);
end
fprintf(fid,"</ol>\n");
fclose(fid);


