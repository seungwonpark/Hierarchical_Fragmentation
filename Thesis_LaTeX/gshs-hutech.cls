% -*- TeX:UTF-8 -*-

\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{gshs-hutech}%
       [2014/09/02 v0.1 Standard GSHS hutech document class, ko.TeX version]
       

%% 12pt,a4paper,onecolumn,oneside 옵션으로 report 클래스 불러오기
\LoadClass[11pt, a4paper, onecolumn, oneside]{report}


%%들여쓰기
\usepackage{indentfirst}
\setlength\parindent{2.0em}

\RequirePackage{ifthen}       % 추가 패키지 설정
\RequirePackage{tabu}

%%%% Hangul-ucs preamble.......
\RequirePackage[nonfrench]{kotex}
%\RequirePackage[default]{dhucs-interword}

%수학 패키지
\RequirePackage{amsmath, amsthm, amsfonts, dsfont, amssymb}
\RequirePackage{graphicx,xcolor}

%% for compatability to HLaTeX
\let\gt\sffamily
\DeclareTextFontCommand{\textgt}{\gt}
%%%% end of Hangul-ucs preamble

%% 편집용지 설정
\usepackage[left=25mm,right=25mm,top=30mm,bottom=30mm]{geometry}
%\usepackage{geometry}
\usepackage{setspace}

%% 줄간격 설정
%\renewcommand{\baselinestretch}{1.3}
\linespread{2}


%% pagestyle 
\def\ps@gshs{\let\@mkboth\@gobbletwo
     \let\@oddhead\@empty
     \def\@oddfoot{\reset@font\hfil--\ \thepage\ --
     \hfil}%
     \let\@evenhead\@empty\let\@evenfoot\@oddfoot
}

\pagestyle{gshs}


\renewenvironment{abstract}{%
%    \pagenumbering{roman}                        % 로마자 페이지 시작
    \thispagestyle{plain}%
    \begin{center} \textbf{Abstract} \end{center}      % 초록명 -> Abstract
}

%%
%% \part 재정의 - 아예 쓰지 못하게 막아버림. 이 명령을 호출하면 에러 발생.
%%
\renewcommand\part{%
    \secdef\@part\@spart}
\def\@part[#1]#2{%
    \ClassError{gshs}{The use of \protect\part\space is prohibited.
        \MessageBreak Consider the use of \protect\chapter\space instead}{}
}
\def\@spart#1{%
    \ClassError{gshs}{The use of \protect\part\space is prohibited.
        \MessageBreak Consider the use of \protect\chapter\space instead}{}
}

%%
%% \chapter 재정의 - report 클래스로부터 복사하여 일부 수정
%%
\renewcommand\chapter{%
\renewcommand{\thechapter}{\Roman{chapter}}%
    \global\@topnum\z@
    \@afterindentfalse
    \secdef\@chapter\@schapter}
\def\@chapter[#1]#2{%
    \ifnum \c@secnumdepth >\m@ne
        \refstepcounter{chapter}%
        \typeout{\@chapapp\space\thechapter.}%
    \else
    \fi
    \chaptermark{#1}%
    \if@twocolumn
        \@topnewpage[\@makechapterhead{#2}]%
    \else
        \@makechapterhead{#2}%
        \@afterheading%
    \fi
}
\def\@makechapterhead#1{% <-- 전체 변경
     {\vskip 2pc \bfseries
        {\noindent\thechapter.\hspace{1.4ex}}
    #1\par}
    \vspace*{20\p@}
}
\def\@schapter#1{%
    \if@twocolumn
        \@topnewpage[\@makeschapterhead{#1}]%
    \else
        \@makeschapterhead{#1}%
        \@afterheading
    \fi}
\def\@makeschapterhead#1{% <-- 전체 변경
    \vspace*{10\p@}
    {\centering \parindent\z@ \LARGE\bfseries #1\par}
    \vspace*{20\p@}
}

%%
%%
%%

\renewcommand \thesection {\@arabic{\c@chapter}.\@arabic\c@section}
\renewcommand \thesubsection   {\thesection.\@arabic\c@subsection}
\renewcommand \thesubsubsection{\thesubsection.\@arabic\c@subsubsection}
\renewcommand \theparagraph    {\thesubsubsection.\@arabic\c@paragraph}
\renewcommand \thesubparagraph {\theparagraph.\@arabic\c@subparagraph}
\renewcommand \thefigure {\@arabic\c@figure}
\renewcommand \thetable {\@arabic\c@table}
%\def\fnum@table{\thetable}
%\def\fnum@figure{\thefigure}

\renewcommand\figurename{Figure}%{\sf Fig.}
\renewcommand\tablename{Table}%{\sf Tab.}
%\def\fnum@figure{\figurename\nobreakspace\thefigure}
%\def\fnum@table{\tablename\nobreakspace\thetable}


%%
%% thebibliography 환경 재정의 - report 클래스로부터 복사하여 일부 수정
%%
\renewenvironment{thebibliography}[1]{%
    \chapter{\bibname}%
    \@mkboth{\MakeUppercase\bibname}{\MakeUppercase\bibname}%
%    \if@PDFdoc\phantomsection\fi\addcontentsline{toc}{chapter}{\bibname}%
    \list{\@biblabel{\@arabic\c@enumiv}}%
        {\settowidth\labelwidth{\@biblabel{#1}}%
         \leftmargin\labelwidth
         \advance\leftmargin\labelsep
         \@openbib@code
         \usecounter{enumiv}%
         \let\p@enumiv\@empty
         \renewcommand\theenumiv{\@arabic\c@enumiv}}%
    \sloppy
    \clubpenalty4000
    \@clubpenalty \clubpenalty
    \widowpenalty4000%
    \sfcode`\.\@m%
}{  \label{paperlastpagelabel}     % <-- 추가 부분: 마지막 페이지 위치 지정
    \def\@noitemerr{\@latex@warning{Empty `thebibliography' environment}}%
    \endlist
}

\long\def\@makecaption#1#2{%
  \vskip\abovecaptionskip
  \sbox\@tempboxa{#1. #2}%
  \ifdim \wd\@tempboxa >\hsize
    #1. #2\par
  \else
    \global \@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip\belowcaptionskip}
