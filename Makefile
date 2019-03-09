gitbook:
	mkdir -p docs/images && cp images/* docs/images
	Rscript --quiet _render.R "bookdown::gitbook"
	cp _redirects docs/

pdf:
	mkdir -p docs/images && cp images/* docs/images
	Rscript --quiet _render.R "bookdown::pdf_book"

clean:
	rm -r _bookdown_files/
