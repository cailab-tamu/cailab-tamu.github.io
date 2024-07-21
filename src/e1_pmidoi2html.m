addpath('pmidoi\');

AAv=["38895424*","38293018*","38464253*","39018178","38918606",...
    "38856220","38750093","38671495","38483513","37798250",...
    "10.1038/s41534-023-00740-6","10.1093/biomet/asad052",...
    "37602516","37246643","36787742","36181835","35892093","35763934",...
    "35565312","35510185","35434695",...
    "10.1007/s12686-022-01284-1","38179127",...
    "35205415","35187673","35170983","35005773","34815312",...
    "34320637","33964465","33462362","33336197","32873716","32840568",...
    "32404926","32245959","31861624","31697351","31273215","31127088",...
    "29895639","29589560","29577871","29554127","29040376","28853484",...
    "28171656","27549615","27536236","27131873","26588844","26535622",...
    "25617623","25330172","25309574","25222615","24901238","24398800",...
    "24298061","24027418","23851338","23613906","23225993","23150607",...
    "23051181","22131218","21300845","21282640","21224255","20978139",...
    "20937604","20828396","20718860","20624743","20333184","19455210",...
    "19283063","19148272","18841251","18310616","16755356","16714021",...
    "15780146","15613317","14675758","12640520"];

assert(length(unique(AAv))==length(AAv))

AAv=strrep(AAv,'*','');

Highlighted=["10.1038/s41534-023-00740-6","37246643","36787742",...
             "35510185","33336197","31861624","31697351","31273215",...
             "25617623","24298061","23150607"];

fid=fopen('publicationlist.html','w');

% fprintf(fid,"<script async src=""https://badge.dimensions.ai/badge.js"" charset=""utf-8""></script>\n");
% fprintf(fid,"<script type=""text/javascript"" src=""https://d1bxh8uas1mnw7.cloudfront.net/assets/embed.js""></script>\n");
% fprintf(fid,"<style>\n");
% fprintf(fid,"li.highlighted{\n");
% fprintf(fid,"    background-color: #FF851B;\n");
% fprintf(fid,"}\n");
% fprintf(fid,"li.even{\n");
% fprintf(fid,"    background-color: #FF4136;\n");
% fprintf(fid,"}\n");
% fprintf(fid,"</style>\n");
%fprintf(fid,"<div class=""container"">\n");
%fprintf(fid,"<div class=""col-xs-12"">\n");


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
