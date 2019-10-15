%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Arsclassica Article
% LaTeX Template
% Version 1.1 (10/6/14)
%
% This template has been downloaded from:
% http://www.LaTeXTemplates.com
%
% Original author:
% Lorenzo Pantieri (http://www.lorenzopantieri.net) with extensive
% modifications by: Vel (vel@latextemplates.com)
%
% License:
% CC BY-NC-SA 3.0 (http://creativecommons.org/licenses/by-nc-sa/3.0/)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------------------------------------------------------------------------------
%	PACKAGES AND OTHER DOCUMENT CONFIGURATIONS
%------------------------------------------------------------------------------
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{comparch}[2019/10/14 Used for Computer Architecture reports.]
\LoadClass[
10pt, % Main document font size
letterpaper, % Paper type, use 'letterpaper' for US Letter paper
oneside, % One page layout (no page indentation)
headinclude,footinclude, % Extra spacing for the header and footer
BCOR=5mm, % Binding correction
]{scrartcl}

% Include the structure.tex file which specified the document structure and
% layout
\input{structure.tex}
% Specify custom hyphenation points in words with dashes where you would like
% hyphenation to occur, or alternatively, don't put any dashes in a word to
% stop hyphenation altogether
\hyphenation{Fortran hy-phen-ation}
%------------------------------------------------------------------------------
%	TITLE AND AUTHOR(S)
%------------------------------------------------------------------------------

\let\oldtitle\title
\renewcommand{\title}[1]{\oldtitle{\normalfont\spacedallcaps{#1}}}

\let\oldauthor\author
\renewcommand{\author}[1]{\oldauthor{\spacedallcaps{#1\textsuperscript{1}}}}

%------------------------------------------------------------------------------

%------------------------------------------------------------------------------
%	HEADERS
%------------------------------------------------------------------------------
% The header for all pages (oneside) or for even pages (twoside)
% The header style
\renewcommand{\sectionmark}[1]{\markright{\spacedlowsmallcaps{#1}}}\lehead{\mbox{\llap{\small\thepage\kern1em\color{halfgray}
\vline}\color{halfgray}\hspace{0.5em}\rightmark\hfil}}

\pagestyle{scrheadings} % Enable the headers specified in this block

%------------------------------------------------------------------------------
%	BIBLIOGRAPHY
%------------------------------------------------------------------------------

\renewcommand{\refname}{\spacedlowsmallcaps{References}} % For modifying the bibliography heading

\bibliographystyle{plainnat}

%------------------------------------------------------------------------------
