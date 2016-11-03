quiet = "--quiet" %in% commandArgs(FALSE)
formats = commandArgs(TRUE)
travis = !is.na(Sys.getenv('CI', NA))
library("methods")

# provide default formats if necessary
if (length(formats) == 0) formats = c(
  'bookdown::pdf_book', 'bookdown::epub_book', 'bookdown::gitbook'
)
# render the book to all formats unless they are specified via command-line args
for (fmt in formats) {
  cmd = sprintf("bookdown::render_book('index.Rmd', '%s', quiet = %s, clean = FALSE)", fmt, quiet)
  res = bookdown:::Rscript(c('-e', shQuote(cmd)))
  if (res != 0) stop('Failed to compile the book to ', fmt)
  if (!travis && fmt == 'bookdown::epub_book')
    bookdown::calibre('_book/bookdown.epub', 'mobi')
}

# insert google analytics
ga <- readLines("includes/ga.html")
for (f in list.files('docs', '[.]html$', full.names = TRUE)) {
  x <- readLines(f)
  n <- length(x)
  i <- grep('^\\s*</body>\\s*$', x)
  writeLines(
    c(x[seq.int(1, i-1)], ga, x[seq.int(i, n)]),
    f
  )
}