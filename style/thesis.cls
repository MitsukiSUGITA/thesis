% クラス名
\ProvidesClass{thesis}

% クラスオプション
\newif\if@bachelor \@bachelorfalse
\newif\if@master \@masterfalse
\newif\if@doctor \@doctorfalse

\newif\if@nodoctorreport \@nodoctorreporttrue

\newif\if@hyperref \@hyperreffalse
\newif\if@printtoc \@printtoctrue
\newif\if@printlof \@printloftrue
\newif\if@printlot \@printlottrue
\newif\if@printlol \@printloltrue

\DeclareOption{bachelor}{\@bachelortrue
 \gdef\@type{卒業}}
\DeclareOption{master}{\@masterfalse
 \gdef\@type{修士}}
\DeclareOption{doctor}{\@doctorfalse
 \gdef\@type{博士}}
\DeclareOption{doctorreport}{\@nodoctorreportfalse
 \gdef\@type{博士}}

\DeclareOption{hyperref}{\@hyperreftrue}
\DeclareOption{notoc}{\@printtocfalse}
\DeclareOption{nolof}{\@printloffalse}
\DeclareOption{nolot}{\@printlotfalse}
\DeclareOption{nolol}{\@printlolfalse}

\ProcessOptions\relax

% 基本設定
\RequirePackage{luatex85,luatexja}
\LoadClass[11pt,a4paper,titlepage,oneside,openany,onecolumn]{ltjsbook}
\if@nodoctorreport
    \IfFileExists{tikzpeople.sty}{%
        \RequirePackage{tikzpeople}
    }{}
\else
    \RequirePackage{titlesec}
    \titleformat{\chapter}[hang]{\LARGE\bfseries\sffamily}{第\thechapter{}章}{1\zw}{}
    \titlespacing*{\chapter}{0pt}{*3}{*9}
\fi
\RequirePackage{geometry}
\RequirePackage{graphicx}
\RequirePackage{listings}
\RequirePackage{etoolbox}
\if@hyperref
    \PassOptionsToPackage{linktocpage=true,breaklinks=true,bookmarksopen=true,bookmarksnumbered=true,pdfpagemode=UseOutlines,unicode=true}{hyperref}
\fi

% \maketitle で使われる変数の定義
\def\@etitle{}
\newcommand{\etitle}[1]{\def\@etitle{#1}}
\def\@jauthor{}
\newcommand{\jauthor}[1]{\def\@jauthor{#1}}
\def\@eauthor{}
\newcommand{\eauthor}[1]{\def\@eauthor{#1}}
\def\@supervisor{}
\newcommand{\supervisor}[1]{\def\@supervisor{#1}}
\def\@studentnumber{}
\newcommand{\studentnumber}[1]{\def\@studentnumber{#1}}
\def\@institute{}
\newcommand{\institute}[1]{\def\@institute{#1}}
\def\@deadline{}
\newcommand{\deadline}[1]{\def\@deadline{#1}}
\def\@absttitlestr{}
\newcommand{\absttitlestr}[1]{\def\@absttitlestr{#1}}
\def\@eabsttitlestr{}
\newcommand{\eabsttitlestr}[1]{\def\@eabsttitlestr{#1}}

% 年度の計算
\newcommand\thisacademicyear{%
    \directlua{%
    local s = string.char(0x25).."d"
    tex.sprint(s:format(\the\year-1))}}
\newcommand\entranceacademicyear{%
    \directlua{%
    local s = "20"..string.char(0x25).."02d"
    tex.sprint(s:format(string.sub(\@studentnumber,1,2)))}}

% 表紙ページ（概要ページ含む）
\renewcommand{\maketitle}{%
\pagenumbering{Roman}
\begin{titlepage}
{%
\thispagestyle{empty}
\if@hyperref
    \if@openright\cleardoublepage\else\clearpage\fi
    \phantomsection
    \pdfbookmark{表紙}{cover}
\fi

\centering

\if@nodoctorreport

    {\huge\@title}

    \vspace{1\zh}

    {\Large\@etitle}

    \vspace{6\zh}

    {\huge\@jauthor}

    {\Large\@eauthor}

    \vspace{4\zh}

    {\Large（\entranceacademicyear{}年度入学，\@studentnumber）}

    %\IfFileExists{face.pdf}{%
    \IfFileExists{figure/face.png}{%
    \begin{figure}[h]
        \centering
        %\includegraphics[height=60mm]{face.pdf}
        \includegraphics[height=60mm]{figure/face.png}
    \end{figure}
    }{%
    \IfFileExists{tikzpeople.sty}{%
        \centering
        \begin{tikzpicture}
        \node[person,minimum size=60mm]{};
        \end{tikzpicture}
    }{\vspace{25\zh}}}

    {\LARGE 指導教員　\@supervisor}

    \vspace{2\zh}

    \if@bachelor
    {\Large 東京農工大学 工学部 \@institute}\\
    \else
    {\Large 東京農工大学 大学院 工学府 \@institute}\\
    \fi
    {\Large \thisacademicyear{}年度\@type{}論文}

    {\Large （\@deadline{}提出）}

\else

    \let\footnotesize\small
    \let\footnoterule\relax
    \let\footnote\thanks
    {\LARGE 特別計画研究　報告書 \\ 「\@title」 \vskip1em \par \textrm{\@etitle} \par}
    \vskip 1em%
    {\LARGE \vskip20em \mbox{}\\}
     {\Large
      \lineskip .75em%
      \begin{tabular}[t]{c}%
        \large \the\year 年\the\month 月　特別計画研究\\ \par \large 東京農工大学 大学院 工学府 \@institute \\ \par \LARGE \mbox{}\\
        \@jauthor \\ \@eauthor \\
      \end{tabular}\par}
    \par
  \@thanks\vfil\null
\fi

% ここから概要ページ
\clearpage

\if@nodoctorreport
    \thispagestyle{empty}
    \if@hyperref
        \if@openright\cleardoublepage\else\clearpage\fi
        \phantomsection
        \pdfbookmark{概要}{abstract}
    \fi

    \vspace*{-6\zh}
    \begin{center}
        \if@bachelor
        {東京農工大学 工学部 \@institute　\thisacademicyear{}年度　\@type{}論文　要旨}\\
        \else
        {東京農工大学 大学院 工学府 \@institute　\thisacademicyear{}年度　\@type{}論文　要旨}\\
        \fi

    \textbf{\Large \@absttitlestr}

    \textbf{\@eabsttitlestr}

    %学籍番号 \@studentnumber\hspace{2\zh}氏名 \@jauthor（\@eauthor）
    学籍番号 \@studentnumber\hspace{2\zh}氏名 \@jauthor（\@eauthor）\hspace{2\zh}山田浩史研究室

    提出日　\@deadline
    %発表日　\@deadline
    \end{center}
    \vspace{\baselineskip}
    \bgroup
     \unvbox\@jabstractbox\par
    \egroup
    \vspace{\baselineskip}
    \bgroup
     \unvbox\@eabstractbox\par
    \egroup
\else
    \thispagestyle{empty}
    \mbox{}\newpage
\fi
}
% ページ番号をi,ii,iii,...に
\frontmatter

% 目次・図目次・表目次
\if@hyperref
    \pdfbookmark{\contentsname}{toc}
\fi
\if@printtoc
    \tableofcontents
\fi

\if@printlof
    \listoffigures
\fi

\if@printlot
    \listoftables
\fi

\if@printlol
    \lstlistoflistings
\fi

% ページ番号を1,2,3,...に
\mainmatter%

% 図，表番号のカウンタをリセット
\setcounter{figure}{0}
\setcounter{table}{0}

\end{titlepage}
}

% 概要ページのためのボックスの定義
\newbox\@jabstractbox
\def\jabstract{\global\setbox\@jabstractbox\vbox\bgroup%
    \ignorespaces}
\def\endjabstract{\egroup}

\newbox\@eabstractbox
\def\eabstract{\global\setbox\@eabstractbox\vbox\bgroup%
    \ignorespaces}
\def\endeabstract{\egroup}

% PDF しおりに目次を追加
\if@hyperref
    \pretocmd{\tableofcontents}{%
        \if@openright\cleardoublepage\else\clearpage\fi
        \phantomsection
        \pdfbookmark[1]{\contentsname}{toc}}{}{}
    \pretocmd{\listoffigures}{%
        \if@openright\cleardoublepage\else\clearpage\fi
        \phantomsection
        \pdfbookmark[1]{\listfigurename}{lof}}{}{}
    \pretocmd{\listoftables}{%
        \if@openright\cleardoublepage\else\clearpage\fi
        \phantomsection
        \pdfbookmark[1]{\listtablename}{lot}}{}{}
    \pretocmd{\lstlistoflistings}{%
        \if@openright\cleardoublepage\else\clearpage\fi
        \phantomsection
        \pdfbookmark[1]{\lstlistlistingname}{lol}}{}{}
\fi

% list of listings の挙動の修正
\addtocontents{lol}{\protect\boolfalse {citerequest}\boolfalse {citetracker}\boolfalse {pagetracker}\boolfalse {backtracker}\relax}
\let\my@chapter\@chapter
\renewcommand*{\@chapter}{%
    \addtocontents{lol}{\protect\addvspace{10\jsc@mpt }}%
    \my@chapter}

% ソースコードを表示する listing 環境の設定
\lstset{%
    numbers=left,
    breaklines=true,
    frame=shadowbox,
    basicstyle={\ttfamily\small},
    numberstyle={\scriptsize},
    lineskip=-0.5ex
}
% コードのキャプション名の設定
\renewcommand{\lstlistingname}{コード}
% コード目次の設定
\renewcommand{\lstlistlistingname}{コード目次}
% 目次に節までを表示する
\setcounter{tocdepth}{2}
% 目次や章の最初のページも他のページと同じデザインにする
\renewcommand{\chapter}{%
  \if@openright\cleardoublepage\else\clearpage\fi
  \global\@topnum\z@
  \secdef\@chapter\@schapter}

% ページ番号設定
\def\ps@plainfoot{%
  \let\@mkboth\@gobbletwo
  \let\@oddhead\@empty
  \def\@oddfoot{\normalfont\hfil\thepage\hfil}%
  \let\@evenhead\@empty
  \let\@evenfoot\@oddfoot}
\let\ps@plain\ps@plainfoot

% 行間設定
\renewcommand{\baselinestretch}{1.1} %本文
\renewcommand{\arraystretch}{0.85} %表

% 余白設定
\if@nodoctorreport
\newgeometry{%
    headheight=0mm,
    headsep=0mm,
    top=72pt,
    % left=94pt,
    footskip=1.5\Cvs,
    marginparsep=0mm,
    marginparwidth=0mm,
    textwidth=44\zw,
    textheight=38\Cvs,
}
\else
\newgeometry{%
    headheight=0mm,
    headsep=0mm,
    top=91pt,
    left=86pt,
    footskip=30pt,
    marginparsep=10pt,
    marginparwidth=98pt,
    textwidth=455pt,
    textheight=645pt,
}
\fi
