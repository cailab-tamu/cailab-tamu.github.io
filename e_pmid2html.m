a=webread('https://pubmed.ncbi.nlm.nih.gov/35510185/?format=pubmed');
b=extractHTMLText(a);
c=strtrim(string(strsplit(b,'\n')'));
c(startsWith(c,'PMID'))
c(startsWith(c,'SO'))
c(startsWith(c,'AU'))
