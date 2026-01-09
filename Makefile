# Makefile for rendering bioRxiv documents in different formats
# Automatically detects the .qmd file in the current directory
#
# Usage:
#   make           - Render two-column format (default)
#   make twocolumn - Render two-column format
#   make onecolumn - Render single-column format (no line numbers)
#   make submit    - Render submission format (single-column with line numbers)
#   make all       - Render all three formats
#   make clean     - Remove generated PDFs
#   make help      - Show this help message

# Auto-detect the .qmd source file (first .qmd file found)
SRC := $(firstword $(wildcard *.qmd))

# Check if source file exists
ifeq ($(SRC),)
$(error No .qmd file found in current directory)
endif

# Base name for output files
BASENAME = $(basename $(SRC))

# Output files
TWOCOL_PDF = $(BASENAME)-twocolumn.pdf
ONECOL_PDF = $(BASENAME)-onecolumn.pdf
SUBMIT_PDF = $(BASENAME)-submit.pdf

# Default target
.PHONY: default twocolumn onecolumn submit all clean help
default: twocolumn

# Two-column format (default bioRxiv preprint)
twocolumn: $(TWOCOL_PDF)

$(TWOCOL_PDF): $(SRC)
	@echo "Rendering two-column format from $(SRC)..."
	quarto render $< --to biorxiv-pdf -o $@

# One-column format (no line numbers)
onecolumn: $(ONECOL_PDF)

$(ONECOL_PDF): $(SRC)
	@echo "Rendering one-column format from $(SRC)..."
	quarto render $< --to biorxiv-pdf -M classoption:onecolumn -o $@

# Submit format (single-column with line numbers)
submit: $(SUBMIT_PDF)

$(SUBMIT_PDF): $(SRC)
	@echo "Rendering submit format from $(SRC)..."
	quarto render $< --to biorxiv-pdf -M classoption:submit -o $@

# Build all formats
all: twocolumn onecolumn submit
	@echo "All formats rendered successfully!"

# Clean generated files
clean:
	@echo "Cleaning generated files..."
	rm -f $(TWOCOL_PDF) $(ONECOL_PDF) $(SUBMIT_PDF)
	rm -f $(BASENAME).tex $(BASENAME).pdf
	rm -f *.aux *.bbl *.blg *.log *.out
	@echo "Clean complete."

help:
	@echo "bioRxiv Quarto Makefile"
	@echo "Source file: $(SRC)"
	@echo ""
	@echo "Usage:"
	@echo "  make           - Render two-column format (default)"
	@echo "  make twocolumn - Render two-column format"
	@echo "  make onecolumn - Render single-column format"
	@echo "  make submit    - Render submission format (with line numbers)"
	@echo "  make all       - Render all three formats"
	@echo "  make clean     - Remove generated PDFs"
	@echo "  make help      - Show this message"
	@echo ""
	@echo "Output files:"
	@echo "  $(TWOCOL_PDF) - Two-column preprint"
	@echo "  $(ONECOL_PDF) - Single-column"
	@echo "  $(SUBMIT_PDF) - Submission format with line numbers"
