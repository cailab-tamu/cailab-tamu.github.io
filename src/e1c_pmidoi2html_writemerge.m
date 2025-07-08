addpath('pmidoi\');
e0_pmidoilist;

fid=fopen('publications.html','w');

S1 = in_loopthrough(AAv(ispreprint), Highlighted);
fprintf(fid,"<h3>Preprints</h3>\n<ol>");
fprintf(fid,"\n%s\n", S1);
fprintf(fid,"</ol>\n");

S2 = in_loopthrough(AAv(~ispreprint), Highlighted);
fprintf(fid,"<h3>Journal Articles</h3>\n<ol>");
fprintf(fid,"\n%s\n", S2);
fprintf(fid,"</ol>\n");
fclose(fid);
copyfile("publications.html","../publications.html");

function [s] = in_loopthrough(AAv, Highlighted)
    wavefilev = matlab.lang.makeValidName(AAv);
    for k=1:length(AAv)
        fname = fullfile("paperhtml", matlab.lang.makeValidName(AAv(k)));
        if ~exist(fname,"file")
            pause(1)
            ishighlighted = ismember(AAv(k), Highlighted);        
            try
                if contains(AAv(k),'/')
                    s1=i_doi2html(AAv(k),ishighlighted);
                else
                    s1=i_pmid2html(AAv(k),ishighlighted);
                end
                writelines(s1, fname);
               if exist(sprintf('../wav/%s.wav', wavefilev(k)),'file')
                   s2 = sprintf("<audio controls src=""wav/%s.wav"" style=""height: 30px;""></audio>\n", wavefilev(k));
                   writelines(s2, fname, WriteMode="append");
               end
            catch ME
                % warning(ME.identifier, '%s', ME.message);
                AAv(k)
            end
        end
    end
    s = "";
    for k=1:length(AAv)
        fname = fullfile("paperhtml", matlab.lang.makeValidName(AAv(k)));
        if exist(fname,"file")
            fileContent = fileread(fname);
            s = s + string(fileContent);
        end
    end

end


