gitbook:
	mkdir -p docs/images && cp images/* docs/images
	mkdir -p docs/data-raw && cp data-raw/* docs/data-raw
	mkdir -p docs/interactives && cp -r interactives/* docs/interactives
	Rscript --quiet _render.R "bookdown::gitbook"
	cp _redirects docs/
	cp front_cover/crc-cover.png docs/

pdf:
	mkdir -p docs/images && cp images/* docs/images
	Rscript --quiet _render.R "bookdown::pdf_book"
	mv docs/plotly_book.pdf crc/plotly_book.pdf
	mv docs/plotly_book.tex crc/plotly_book.tex

dashboard:
	Rscript -e "rmarkdown::render('flexdashboard/index.Rmd')"
	cp flexdashboard/index.html docs/flexdashboard.html

clean:
	rm -r _bookdown_files/
