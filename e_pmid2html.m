
AAv=[36181835,35892093,35763934,35565312,35510185,35434695,35205415,35187673,35170983,35005773,34815312,34320637,33964465,33462362,33336197,32873716,32840568,32404926,32245959,31861624,31697351,31273215,31127088,29895639,29589560,29577871,29554127,29040376,28853484,28171656,27549615,27536236,27131873,26588844,26535622,25617623,25330172,25309574,25222615,24901238,24398800,24298061,24027418,23851338,23613906,23225993,23150607,23051181,22131218,21300845,21282640,21224255,20978139,20937604,20828396,20718860,20624743,20333184,19455210,19283063,19148272,18841251,18310616,16755356,16714021,15780146,15613317,14675758,12640520,];
%AAv=[35005773];


fid=fopen('publicationlist.html','w');
fprintf(fid,"<h3>Journal Articles</h3>\n<ol>");
        
for k=1:length(AAv)
    AAv(k)
    a=webread(sprintf('https://pubmed.ncbi.nlm.nih.gov/%d/?format=pubmed',AAv(k)));
    b=extractHTMLText(a);
    % c=strtrim(string(strsplit(b,'\n')'));
    c=string(strsplit(b,'\n')');
    s_pmid=c(startsWith(c,'PMID'));
    
    s_so=c(startsWith(c,'SO'));
    if find(startsWith(c,'SO'))<length(c)
        %fprintf('--->%d\n',AAv(k));
        s_so=strcat(s_so, " ", c(end));
    end

    s_au=c(startsWith(c,'AU '));
    s_ti=c(startsWith(c,'TI'));

    if strcmp(extractBefore(c(find(startsWith(c,'TI'))+1),2)," ")
        s_ti=strcat(s_ti,strtrim(c(find(startsWith(c,'TI'))+1)));
    end

    
    s_ti=strtrim(extractAfter(s_ti,6));
    s_pmid=strtrim(extractAfter(s_pmid,6));
    s_so=strtrim(extractAfter(s_so,6));
    s_au=strtrim(extractAfter(s_au,6));
    s_j=extractBefore(s_so,'.');
    s_t = strtrim(extractBefore(extractAfter(s_so,'.'),'.'));
    

    
%     s_d = extractAfter(s_so,'doi: ');
%     s_d=extractBefore(s_d,strlength(s_d));
    
    s_doi=c(contains(c,"[doi]"));
    if ~isempty(s_doi)
        s_doi=strtrim(extractAfter(s_doi,6));
        s_doi=strrep(s_doi," [doi]","");
    end


    fprintf(fid,"\n<li>");
    
    if length(s_au)==1
        fprintf(fid,"%s.\n",s_au);
    else
        fprintf(fid,"%s, ",s_au(1:end-1));
        fprintf(fid,"%s.\n",s_au(end));
    end
    fprintf(fid,"<strong>%s</strong>\n",s_ti);
    fprintf(fid,"<em><u>%s</u></em>.\n",s_j);
    fprintf(fid,"%s.\n",s_t);

    if ~isempty(s_doi)
        fprintf(fid,"doi: <a href=""https://doi.org/%s"">%s</a>.\n",s_doi(1),s_doi(1));
    end

    fprintf(fid,"PMID: <a href=""https://pubmed.ncbi.nlm.nih.gov/%s"">%s</a>.</li>\n",s_pmid,s_pmid);
end
fprintf(fid,"</ol>\n");
fclose(fid);
    


%{

<li>Willis SC, Saenz DE, Wang G, Hollenbeck CM, Portnoy DS, Cai JJ, Winemiller KO.
<strong>Gill transcriptome of the yellow peacock bass (Cichla ocellaris monoculus) exposed to contrasting physicochemical conditions.</strong>
<em><u>Conservation Genet Resour</u></em>
2022 Jul 29;1877-7260.
doi: <a href="https://doi.org/10.1007/s12686-022-01284-1">10.1007/s12686-022-01284-1</a>.</li>


<li>Zhou F, He K., Cai JJ, Davidson L, Chapkin R, Ni Y. 
<strong>A Unified Bayesian Framework for Biclustering Multi-Omic Data via Sparse Matrix Factorization</strong>. 
<em><u>Stat Biosci</u></em>.
2022 Jul 8. 
doi: <a href="https://doi.org/10.1007/s12561-022-09350-w">10.1007/s12561-022-09350-w</a>.</li>

%}
