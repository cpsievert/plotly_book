gitbook:
	echo Using `pandoc --version | sed -n 1p`
	echo pandoc 2.0 and higher have been known to cause issues
	mkdir -p docs/images && cp images/* docs/images
	Rscript --quiet _render.R "bookdown::gitbook"

pdf:
	mkdir -p docs/images && cp images/* docs/images
	Rscript --quiet _render.R "bookdown::pdf_book"

clean:
	rm -r _bookdown_files/
