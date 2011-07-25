PDFLATEX = pdflatex
GENERATE_TEX_BOOK = bin/generate-tex-book.pl

all : output/book.pdf

output/book.pdf : output/book.tex
	$(PDFLATEX) -output-directory=output output/book.tex

output/book.tex : chapters/*.md $(GENERATE_TEX_BOOK)
	$(GENERATE_TEX_BOOK)
