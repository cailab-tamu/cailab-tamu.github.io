function [s]=i_doi2html(s_doi,ishighlighted)

if nargin<2, ishighlighted=false; end

     a=webread(sprintf('https://doi.org/%s',s_doi));
     a=strtrim(strsplit(a,{'\n','/>'}))';
     a(strlength(a)==0)=[];

     
        % a{contains(a,'<meta name="citation_author" content="')}
        % a{contains(a,'<meta name="citation_journal_title" content="')}
        % a{contains(a,'<meta name="citation_journal_abbrev" content="')}
        % a{contains(a,'<meta name="citation_title" content="')}
        % a{contains(a,'<meta name="citation_volume" content="')}
        % a{contains(a,'<meta name="citation_issue" content="')}
        % a{contains(a,'<meta name="citation_publication_date" content="')}        

    
    if ishighlighted
        s="<li class=""highlighted"">";
    else
        s="<li>";
    end    
    
    s_au=aaa(a,'citation_author');
    %s_au
    if length(s_au)==1
        s=sprintf("%s%s.\n",s,s_au);
    else
        sx=sprintf("%s, ",s_au(1:end-1));
        sx=sprintf("%s%s",sx,s_au(end));
        s=sprintf("%s%s.\n",s,sx);        
    end

    s_ti=aaa(a,'citation_title');
    s_j=aaa(a,'citation_journal_abbrev');

    s_j=strrep(s_j,'.','');


    s_t=aaa(a,'citation_publication_date');
    if isempty(s_t)
        s_t=aaa(a,'citation_online_date');        
    end

    s_v=aaa(a,'citation_volume');
    s_i=aaa(a,'citation_issue');

    s_p1=aaa(a,'citation_firstpage');
    s_p2=aaa(a,'citation_lastpage');
    

    s=sprintf("%s<strong>%s.</strong>\n",s,s_ti);
    s=sprintf("%s<em><u>%s</u></em>.\n",s,s_j);
    if ~isempty(s_p1)
        
        s=sprintf("%s%s;%s(%s)%s-%s.\n",s,s_t,s_v,s_i,s_p1,s_p2);
    else
        s=sprintf("%s%s;%s(%s).\n",s,s_t,s_v,s_i);
    end
    
    s=sprintf("%sdoi:<a href=""https://doi.org/%s"">%s</a>.</li>\n",s,s_doi,s_doi);
    %fprintf(fid,"PMID: <a href=""https://pubmed.ncbi.nlm.nih.gov/%s"">%s</a>.</li>\n",s_pmid,s_pmid);
    %s=sprintf("%sPMID: <a href=""https://pubmed.ncbi.nlm.nih.gov/%s"">%s</a>.</li>\n",s,s_pmid,s_pmid);        
    s=sprintf("%s<span class=""__dimensions_badge_embed__"" data-doi=""%s"" data-style=""small_rectangle""></span><br>\n",s,s_doi(1));
    
end


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


%if ~any(contains(a,ta)
%a{contains(a,'<meta name="citation_journal_title" content="')}
%b(strfind(b, tag)+strlength(tag):end)
%end

