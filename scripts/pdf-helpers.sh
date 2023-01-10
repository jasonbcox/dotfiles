#!/usr/bin/env bash

alias compresspdf='ps2pdf'

# Convert pdfs in the current directory to text files
alias pdfstotext="find . -maxdepth 1 -name '*.pdf' -exec sh -c 'pdftotext \"{}\"' \\;"
