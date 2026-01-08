# bioRxiv Quarto Format

A Quarto extension that provides a bioRxiv-style preprint format for scientific manuscripts.

This is a port of the [quantixed/manuscript-templates](https://github.com/quantixed/manuscript-templates) LaTeX template to Quarto.

## Installation

To use this extension in your project, run:

```bash
quarto add ja-mf/quarto-biorxiv
```

This will install the extension under the `_extensions` subdirectory and provide a template file that you can use as a starting point for your article.

## Usage

After installation, use the format in your document:

```yaml
---
title: "Your Paper Title"
shorttitle: "Running title"
leadauthor: "LastName"
format:
  biorxiv-pdf: default
author:
  - name: First Author
    affiliations:
      - ref: univ-a
    orcid: 0000-0001-0000-0000
  - name: Second Author
    affiliations:
      - ref: inst-b
    corresponding: true
affiliations:
  - id: univ-a
    name: University Name, City, Country
  - id: inst-b
    name: Institute Name, City, Country
abstract: |
  Your abstract goes here.
keywords:
  - keyword1
  - keyword2
corresponding-email: "author@email.com"
bibliography: references.bib
---
```

## Format Options

Two formats are available:

| Format | Description |
|--------|-------------|
| `biorxiv-pdf` | Two-column bioRxiv preprint style (default) |
| `biorxiv-submit` | Single-column submission style with line numbers |

### Additional Class Options

You can pass additional LaTeX class options:

```yaml
format:
  biorxiv-pdf:
    classoption: [twocolumn, watermark]
```

Available class options:

| Option | Description |
|--------|-------------|
| `twocolumn` | Two-column layout (default for pdf format) |
| `submit` | Single-column with line numbers (used by submit format) |
| `watermark` | Adds DRAFT watermark to pages |
| `rmabstract` | Non-bold abstract text |
| `bibskip` | Add space between bibliography entries |

## Features

- Two-column bioRxiv preprint style
- Single-column submission style with line numbers
- ORCID integration
- Author affiliations with superscript numbering
- Corresponding author indication (marked with ✉)
- Keywords and abstract formatting
- natbib citation support (author-year style)
- bioRxiv logo in footer
- Proper SI units support via siunitx

## Template Files

- `template.qmd` - Example manuscript document with all options documented
- `references.bib` - Example bibliography
- `Figures/` - Place figures here

## Credits

This Quarto extension is a port of the [quantixed/manuscript-templates](https://github.com/quantixed/manuscript-templates) LaTeX template, which was originally forked from RoyleLab-StyleBioRxiv and zHenriquesLab-StyleBioRxiv.

## License

This project is licensed under the same terms as the original manuscript-templates repository.
