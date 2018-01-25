gitbook:
	echo Using `pandoc --version | sed -n 1p`
	echo pandoc 2.0 and higher have been known to cause issues
	mkdir -p docs/images && cp images/* docs/images
	Rscript --quiet _render.R "bookdown::gitbook"

pdf:
	mkdir -p docs/images && cp images/* docs/images
	Rscript --quiet _render.R "bookdown::pdf_book"
	# copy over final tex/images for thesis
	cp docs/plotly_book.tex ../phd-thesis/
	mkdir -p ../phd-thesis/images && cp docs/images/*.pdf ../phd-thesis/images

clean:
	rm -r _bookdown_files/
