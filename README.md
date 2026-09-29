# OASIS: Online App for Survey Interactive Study

This repo contains code and documentation for an app for interactive exploration of survey data.

## Repo structure:
├── .github/
│   └── workflows/
│       └── deploy.yml             # CI/CD script to compile and deploy app to Shinylive WebAssembly
├── www/
│   ├── custom.css                 # Global CSS overrides for UI elements not covered by bslib
│   └── logo.png                   # Client or consulting unit branding image
├── R/
│   ├── config.R                   # Global settings (colors, titles); the only file consultants edit
│   ├── translations.R             # Centralized dictionary and tr() function for EN/DE bilingual UI
│   ├── load_data.R                # Universal data cleaner that applies the codebook contract safely
│   ├── extract/                   # S3 classes handling data shaping and transformation
│   │   ├── create_deck.R          # Constructor that maps codebook variables to their S3 classes
│   │   ├── extract_generics.R     # Defines the base extract() generic function
│   │   ├── extract_single.R       # Logic to pull and format single-choice and numeric data
│   │   └── extract_multiple.R     # Logic to pivot and aggregate multiple-choice checkbox arrays
│   ├── plots/                     # R6 classes managing visualization state and rendering
│   │   ├── BasePlot.R             # Parent class handling global themes, layouts, and Plotly config
│   │   ├── BarPlot.R              # Child class containing univariate bar chart geometry
│   │   └── BivariatePlot.R        # Child class managing cross-tabulated bivariate plotting logic
│   └── tables/                    # R6 classes for localized tabular outputs
│       └── CrossTable.R           # Generates dynamic, cross-tabulated HTML or DT tables
├── template_codebook.xlsx         # Mandatory blank template defining column names and variable classes
├── app.R                          # Minimal Shiny UI/Server orchestrator that dynamically sources R/
├── .gitignore                     # Prevents local RStudio settings and history from being committed
└── README.md                      # Deployment instructions and architectural guide for colleagues
