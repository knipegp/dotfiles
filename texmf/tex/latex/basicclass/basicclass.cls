\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{basicclass}[2019/10/02 Basic class used for reports.]

\LoadClass{article}

\RequirePackage[utf8]{inputenc}
\RequirePackage[margin=1.0in]{geometry}
\RequirePackage{url}
\RequirePackage{booktabs}
\RequirePackage{amsfonts}

\RequirePackage{graphicx}
\graphicspath{{img/}}

\RequirePackage[dvipsnames]{xcolor}

% From: https://en.wikibooks.org/wiki/LaTeX/Colors#Predefined_colors
\definecolor{light-gray}{gray}{0.9}

\newcommand{\inline}[1] {
    {\color{red}{\colorbox{light-gray}{#1}}}
}

\RequirePackage{mathtools}

\RequirePackage{listings}
% From: https://tex.stackexchange.com/a/218450
\lstnewenvironment{pseudo}[1][] %defines the algorithm listing environment
{
    \lstset{ % this is the stype
        mathescape=true,
        numbers=left,
        numberstyle=\tiny,
        keywordstyle=\bfseries\em,
        % add the keywords you want, or load a language as Rubens explains in his
        % comment above.
        keywords={
			input,
			output,
			return,
            datatype,
            function,
            in,
            from,
            if,
            else,
            foreach,
            for,
            while,
            begin,
            end,
            break
        }
        numbers=left,
        xleftmargin=.04\textwidth,
        #1
        % this is to add specific settings to an usage of this environment
        % (for instnce, the caption and referable label)
    }
}
{}
\bibliographystyle{ieeetr}

\RequirePackage{tikz}
\usetikzlibrary{trees, arrows}
