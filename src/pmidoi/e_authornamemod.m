function [s_au]=e_authornamemod(s_au)

    % "Romero, Selim"
    % "Gupta, Shreyan"
    % "Gatlin, Victoria"
    % "Chapkin, Robert S."
    % "Cai, James J."
for k = 1:length(s_au)
    idx = strfind(s_au(k),',');
    surnm = extractBefore(s_au(k), idx);
    fstnm = strtrim(extractAfter(s_au(k), strfind(s_au(k),',')));
    fstin = regexp(fstnm, '[A-Z]', 'match');
    fstin = strjoin(fstin,'');
    s_au(k) = surnm+" "+fstin; 
end