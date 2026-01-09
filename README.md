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
shorttitle: "Running title"  # Optional, defaults to title
leadauthor: "LastName"        # Optional, defaults to first author's last name
format:
  biorxiv-pdf: default
author:
  # Simple format (name as single string)
  - name: First Author
    affiliations:
      - ref: univ-a
    orcid: 0000-0001-0000-0000
  # OR structured format (separate given/family names)
  - name:
      given: Jane
      family: Smith
    email: jane.smith@example.com
    affiliations:
      - ref: inst-b
    corresponding: true
    orcid: 0000-0002-0000-0000
affiliations:
  - id: univ-a
    name: University Name, City, Country
  - id: inst-b
    name: Institute Name, City, Country
keywords:
  - keyword1
  - keyword2
corresponding-email: "author@email.com"  # Or use corresponding: true in author
bibliography: references.bib
---

#### Abstract

Your abstract text goes here. In two-column mode, this will automatically span both columns.

#### Author Summary

Optional author summary text. This section is also recognized and formatted appropriately.

## Introduction

Your manuscript content starts here...
```

### Abstract Placement

The extension uses a Lua filter to parse `#### Abstract` and `#### Author Summary` sections from your document body (not YAML). This provides better control over formatting and allows the abstract to span both columns in two-column mode.

To control abstract placement:

```yaml
format:
  biorxiv-pdf:
    abstract-span: true   # Default: abstract spans both columns in two-column mode
    # abstract-span: false  # Places abstract in left column only
```

Note: The `abstract` field in YAML is ignored in favor of the `#### Abstract` section in the document body.

## Format Options

Three formats are available:

| Format | Description |
|--------|-------------|
| `biorxiv-pdf` | Two-column bioRxiv preprint style (default) |
| `biorxiv-onecol` | Single-column bioRxiv preprint style (no line numbers) |
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

### Footer Options

The footer displays the lead author, bioRxiv logo, date, and page range by default. You can hide the logo or date:

```yaml
format:
  biorxiv-pdf:
    hide-logo: true   # Hides the bioRxiv logo from the footer
    hide-date: true   # Hides the date from the footer
```

## Features

- Two-column bioRxiv preprint style
- Single-column submission style with line numbers
- Column-spanning figures with `fig-env="figure*"`
- ORCID integration
- Author affiliations with superscript numbering
- Corresponding author indication (marked with ✉)
- Keywords and abstract formatting
- natbib citation support (author-year style)
- bioRxiv logo in footer
- Proper SI units support via siunitx

### Column-Spanning Figures

In two-column mode, figures normally fit within a single column. To make a figure span both columns, add `fig-env="figure*"` to the figure attributes:

```markdown
![Your caption here](path/to/image.png){#fig-id fig-env="figure*"}
```

This attribute is LaTeX-specific and will be ignored when rendering to HTML or DOCX, so your document remains compatible with all output formats.

## Template Files

- `template.qmd` - Example manuscript document with all options documented
- `references.bib` - Example bibliography
- `Figures/` - Place figures here

## Credits

This Quarto extension is a port of the [quantixed/manuscript-templates](https://github.com/quantixed/manuscript-templates) LaTeX template, which was originally forked from RoyleLab-StyleBioRxiv and zHenriquesLab-StyleBioRxiv.

## License

This project is licensed under the same terms as the original manuscript-templates repository.
