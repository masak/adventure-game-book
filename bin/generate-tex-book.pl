#! /usr/bin/perl
use 5.010;
use strict;
use warnings;

use constant EXEC_OK => 0;

system("pandoc --version > /dev/null") == EXEC_OK
    or die "Need pandoc to built the .tex file. ",
           "See http://johnmacfarlane.net/pandoc/installing.html\n";

my $OUTFILE_NAME = "output/book.tex";
open my $OUTFILE, ">:encoding(UTF-8)", $OUTFILE_NAME
    or die $!;

print {$OUTFILE} <<'EOT';
\documentclass[11pt,a4paper,oneside]{report}
\usepackage{hyperref}

\begin{document}
EOT

close $OUTFILE;

my $PERFORM_INCLUDES
    = 'print map { "    $_\n" } split /\n/, `cat $1` '
      . 'and $_ = "" if /^%%% include (.*)/';
my $FIX_ENUMERATION = '$_ = $1 if /(\\\\begin{enumerate})/';
my $SECTION_TO_CHAPTER = '$_ = "\\\\chapter{$1}" if /^\\\\section{(.*)}$/';
my $SUBSECTION_TO_SECTION
    = '$_ = "\\\\section*{$1}" if /^\\\\subsection{(.*)}$/';

for my $filename (<chapters/*.md>) {
    system("perl -wple '$PERFORM_INCLUDES' $filename "
           . "| pandoc -f markdown -t latex "
           . "| perl -wple '$FIX_ENUMERATION' "
           . "| perl -wple '$SECTION_TO_CHAPTER' "
           . "| perl -wple '$SUBSECTION_TO_SECTION' "
           . ">> $OUTFILE_NAME") == EXEC_OK
        or die $!;
}

open $OUTFILE, ">>:encoding(UTF-8)", $OUTFILE_NAME
    or die $!;

print {$OUTFILE} <<'EOT';
\end{document}
EOT

close $OUTFILE;
