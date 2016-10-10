pdf:
	mkdir -p docs/images && cp images/* docs/images
	Rscript --quiet _render.R "bookdown::pdf_book"
	# copy over final tex/images for thesis
	cp docs/plotly_book.tex ../phd-thesis/
	mkdir -p ../phd-thesis/images && cp docs/images/*.pdf ../phd-thesis/images

gitbook:
	mkdir -p docs/images && cp images/* docs/images
	Rscript --quiet _render.R "bookdown::gitbook"

all:
	mkdir -p docs/images && cp images/* docs/images
	Rscript --quiet _render.R "bookdown::gitbook"
