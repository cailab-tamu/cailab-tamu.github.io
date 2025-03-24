addpath('pmidoi\');
e0_pmidoilist;


fid=fopen('publications.html','w');

fprintf(fid,"<h3>Preprints</h3>\n<ol>");
in_loopthrough(AAv(ispreprint), fid, Highlighted);
fprintf(fid,"</ol>\n");

fprintf(fid,"<h3>Journal Articles</h3>\n<ol>");
in_loopthrough(AAv(~ispreprint), fid, Highlighted);

    fidx=fopen('publications_old.html','r');
    a=textscan(fidx,'%s','Delimiter','\n');
    a=a{1};
    fclose(fidx);
    for k=1:length(a)
        fprintf(fid, '%s\n', a{k});
    end

fprintf(fid,"</ol>\n");
fclose(fid);
copyfile("publications.html","../publications.html");



fid=fopen('selectpublications.html','w');
fprintf(fid,"<h3>Select Publications</h3>\n<ol>");
for k=1:length(Highlighted)
    Highlighted(k)
    pause(1)
    ishighlighted = ~ismember(Highlighted(k), Highlighted);
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



function in_loopthrough(AAv, fid, Highlighted)
    wavefilev = matlab.lang.makeValidName(AAv);
    for k=1:length(AAv)
        % AAv(k)
        pause(1)
        ishighlighted = ismember(AAv(k), Highlighted);
    
        try
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
        catch ME
            warning(ME.identifier, '%s', ME.message);
        end  
    end
end
