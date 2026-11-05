%E1E_GROUPED_PAGES Write the Selected, By Year and By Topic publications pages.
%   publications_selected.html lists only the Highlighted papers (e0_pmidoilist),
%   split into preprints and journal articles like the All view.
%   Regroups the papers in ids.txt by publication year and by research topic,
%   using the entries cached in paperhtml/ (run e1d_pmidoi2html_writemerge
%   first so every paper is cached). Topics and their order come from the
%   shared paper_topics.txt in cailab-uga-private/src, the same file the UGA
%   site uses; papers not listed there go under "Other" with a warning.
%
%   The pages reuse the head, navigation and footer of index_template.html,
%   and the book chapters listed there, so they track the home page.

e0_pmidoilist;

tpl = string(fileread('index_template.html'));
chapters = extractBookChapters(tpl);

sel = ismember(AAv, Highlighted);
selected = [makeSection("Preprints", "preprints", AAv(sel & ispreprint)), ...
            makeSection("Journal Articles", "journal-articles", AAv(sel & ~ispreprint))];
selected = selected(arrayfun(@(x) strlength(x.html) > 0, selected));

writeGroupedPage('../publications_selected.html', "selected", selected, "", tpl);
writeGroupedPage('../publications_by_year.html', "year", groupByYear(AAv), chapters, tpl);
writeGroupedPage('../publications_by_topic.html', "topic", groupByTopic(AAv), chapters, tpl);


function writeGroupedPage(filename, view, sections, chapters, tpl)
    switch view
        case "selected", heading = "Selected Publications";
        case "year",     heading = "Publications by Year";
        otherwise,       heading = "Publications by Topic";
    end

    % View switcher styled like the Research filter buttons (ol.type in
    % style.css). Not wrapped in ul.cat: main.js hijacks clicks on .cat a.
    views = ["index.html#restaurant-menu", "All", "all"; ...
             "publications_selected.html", "Selected", "selected"; ...
             "publications_by_year.html", "By Year", "year"; ...
             "publications_by_topic.html", "By Topic", "topic"];
    buttons = strings(size(views, 1), 1);
    for k = 1:size(views, 1)
        cls = "";
        if views(k, 3) == view, cls = " class=""active"""; end
        buttons(k) = "        <li><a href=""" + views(k, 1) + """" + cls + ">" + views(k, 2) + "</a></li>";
    end

    jumps = arrayfun(@(x) "<a href=""#" + x.anchor + """>" + x.name + "</a>", sections);
    jumpLine = "    <p class=""pub-jump"">Jump to: " + join(jumps, " &middot; ") + "</p>";
    if view == "selected", jumpLine = ""; end
    body = [
"  <div id=""restaurant-menu"" class=""pub-grouped"">"
"    <div class=""section-title text-center center"">"
"      <div class=""overlay"">"
"        <h2>" + heading + "</h2>"
"        <hr>"
"      </div>"
"    </div>"
""
"<div class=""container"">"
"  <div class=""col-xs-12"">"
"    <div class=""categories pub-views"">"
"      <ol class=""type"">"
buttons
"      </ol>"
"    </div>"
jumpLine
""
];
    for k = 1:numel(sections)
        body = [body
"    <div class=""pub-group"" id=""" + sections(k).anchor + """>"
"    <h3>" + sections(k).name + " <span class=""pub-count"">" + count(sections(k).html, "<li") + "</span></h3>"
"<ol>"
strip(sections(k).html)
"</ol>"
"    </div>"
""]; %#ok<AGROW>
    end
    if strlength(chapters) > 0
        body = [body
"    <div class=""pub-group"" id=""book-chapters"">"
"    <h3>Book Chapters</h3>"
chapters
"    </div>"]; %#ok<AGROW>
    end
    body = [body
"  </div>"
"</div>"
"  </div>"
""];

    % Head and navigation from the template, pointed back at index.html.
    head = extractBefore(tpl, "  <!-- Header -->");
    head = replace(head, "<title>Cai Lab</title>", "<title>" + heading + " &mdash; Cai Lab</title>");
    head = replace(head, "href=""#page-top""", "href=""index.html""");
    head = replace(head, "href=""#", "href=""index.html#");
    head = replace(head, " class=""page-scroll""", "");
    head = replace(head, "</head>", ...
        "  <style>" + newline + ...
        "    #menu.navbar-default { background-color: #262626; padding: 10px 0; }" + newline + ...
        "    #restaurant-menu.pub-grouped { padding-top: 70px; }" + newline + ...
        "    .pub-jump { margin: 0 0 20px; line-height: 2; }" + newline + ...
        "    #restaurant-menu.pub-grouped div[id] { scroll-margin-top: 80px; }" + newline + ...
        "    .pub-group { margin-top: 50px; }" + newline + ...
        "    #restaurant-menu .pub-group > h3 { margin: 0 0 20px; padding: 10px 16px;" + newline + ...
        "      background: #f4f4f4; border-left: 6px solid #8eb640; border-bottom: 2px solid #8eb640; }" + newline + ...
        "    .pub-count { float: right; font-size: 14px; font-weight: 600; color: #fff;" + newline + ...
        "      background: #8eb640; border-radius: 12px; padding: 3px 11px; margin-top: 3px; }" + newline + ...
        "  </style>" + newline + "</head>");
    foot = "  <div id=""footer"">" + extractAfter(tpl, "  <div id=""footer"">");

    fid = fopen(filename, 'w', 'n', 'UTF-8');
    cleanupObj = onCleanup(@() fclose(fid));
    fprintf(fid, '%s', head + join(body, newline) + newline + foot);
end


function s = extractBookChapters(tpl)
%EXTRACTBOOKCHAPTERS The hand-written <ul> under "Book Chapters" in the template.
    s = "";
    rest = extractAfter(tpl, "<h3>Book Chapters</h3>");
    if ismissing(rest), return; end
    i1 = strfind(rest, "<ul>");
    i2 = strfind(rest, "</ul>");
    if isempty(i1) || isempty(i2), return; end
    s = "      " + extractBetween(rest, i1(1), i2(1) + 4);
end


function sections = groupByYear(ids)
%GROUPBYYEAR One section per publication year, newest first.
    years = arrayfun(@paperYear, ids);
    unknown = isnan(years);
    sections = struct('name', {}, 'anchor', {}, 'html', {});
    for y = flip(unique(years(~unknown)))'
        sections(end+1) = makeSection(string(y), "y" + y, ids(years == y)); %#ok<AGROW>
    end
    if any(unknown)
        warning('No year found for: %s', join(ids(unknown), ", "));
        sections(end+1) = makeSection("Year unknown", "y-unknown", ids(unknown));
    end
end


function sections = groupByTopic(ids)
%GROUPBYTOPIC One section per topic in paper_topics.txt, in file order; newest first within.
    [topics, topicOf] = readPaperTopics();
    years = arrayfun(@paperYear, ids);
    years(isnan(years)) = 0;
    [~, order] = sort(years, 'descend');   % stable: keeps ids.txt order within a year
    ids = ids(order);

    assigned = isKey(topicOf, ids);
    sections = struct('name', {}, 'anchor', {}, 'html', {});
    for t = topics'
        inTopic = ids(assigned);
        inTopic = inTopic(topicOf(inTopic) == t);
        if ~isempty(inTopic)
            anchor = "t-" + lower(regexprep(t, '[^A-Za-z0-9]+', '-'));
            sections(end+1) = makeSection(t, anchor, inTopic); %#ok<AGROW>
        end
    end
    if any(~assigned)
        warning('Not in paper_topics.txt, listed under "Other": %s', join(ids(~assigned), ", "));
        sections(end+1) = makeSection("Other", "t-other", ids(~assigned));
    end
end


function sec = makeSection(name, anchor, ids)
    html = "";
    for k = 1:numel(ids)
        html = html + readPaperHtml(ids(k));
    end
    % Highlighting marks selected papers on the home page only; the grouped
    % views list every paper the same way.
    html = replace(html, "<li class=""highlighted"">", "<li>");
    sec = struct('name', name, 'anchor', anchor, 'html', html);
end


function s = readPaperHtml(id)
    fname = fullfile("paperhtml", matlab.lang.makeValidName(id));
    s = "";
    if exist(fname, "file")
        s = string(fileread(fname));
    else
        warning('Not cached, skipped (run e1d_pmidoi2html_writemerge): %s', id);
    end
end


function y = paperYear(id)
%PAPERYEAR Publication year: the first year after the journal name; NaN if none.
    tok = regexp(readPaperHtml(id), '</em>\.?\s*((?:19|20)\d\d)', 'tokens', 'once');
    if isempty(tok)
        y = NaN;
    else
        y = str2double(tok{1});
    end
end


function [topics, topicOf] = readPaperTopics()
%READPAPERTOPICS Parse paper_topics.txt: "## Topic" headings, then one id per line.
    topics = strings(0, 1);
    topicOf = dictionary(string.empty, string.empty);
    f = fullfile('..', '..', 'cailab-uga-private', 'src', 'paper_topics.txt');
    if ~isfile(f)
        warning('%s not found; every paper is listed under "Other".', f);
        return
    end
    current = "";
    for line = strip(readlines(f))'
        if startsWith(line, "##")
            current = strip(extractAfter(line, "##"));
            topics(end+1, 1) = current; %#ok<AGROW>
        elseif ~startsWith(line, "#") && line ~= ""
            id = strip(extractBefore(line + "#", "#"));
            if current == ""
                warning('paper_topics.txt: %s is not under a ## topic heading.', id);
            elseif isKey(topicOf, id)
                warning('paper_topics.txt: %s is listed under two topics.', id);
            else
                topicOf(id) = current;
            end
        end
    end
end
