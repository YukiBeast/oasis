# OASIS: Online App for Survey Interactive Study
This repo contains code and documentation for an app for interactive exploration of survey data.

## Repo structure:
```text
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
│   │   ├── base_plot.R             # Parent class handling global themes, layouts, and Plotly config
│   │   ├── bar_plot.R              # Child class containing univariate bar chart geometry
│   │   └── bivariate_plot.R        # Child class managing cross-tabulated bivariate plotting logic
│   └── tables/                    # R6 classes for localized tabular outputs
│       └── cross_table.R           # Generates dynamic, cross-tabulated HTML or DT tables
├── template_codebook.xlsx         # Mandatory blank template defining column names and variable classes
├── app.R                          # Minimal Shiny UI/Server orchestrator that dynamically sources R/
├── .gitignore                     # Prevents local RStudio settings and history from being committed
└── README.md                      # Deployment instructions and architectural guide for colleagues
```
## Data Contract

## The data
...

### The codebook

The codebook is the bridge between the raw survey data and the OASIS application. Mapping the dataset in this Excel file dictates exactly how the dashboard processes, translates, and visualizes the data without requiring a single modification to the underlying R code.

The template is divided into three functional sheets:

#### 1. Main Sheet (The Mapping)
This is the active sheet filled out for a new project. It maps the raw data to the app's architecture using the following columns:
* **`item`**: The exact column name in the raw dataset (e.g., `AA01`).
* **`label`**: The human-readable question text that will appear in the dashboard's UI (can be split into `label_en` and `label_de` for bilingual support).
* **`class`**: The variable type (`single`, `multiple`, or `numeric`). This determines which S3 extraction class and R6 plotting class the app must instantiate.
* **`scale_en` / `scale_de`**: The categorical scale applied to the variable. This is selected directly from a drop-down menu (e.g., `freq`, `yesno`).
* **`breaks`**: A comma-separated list of numbers (e.g., `12, 19, 30, 60, Inf`) used to automatically bin continuous numeric data into logical age or grouping brackets.

#### 2. settings
This sheet contains the master lists for the `class` and `scale` columns. It powers the drop-down menus on the Main Sheet via Excel Data Validation. This enforces strict data entry and prevents fatal typos (e.g., typing "singel" instead of "single") that would otherwise break the extraction pipeline.

#### 3. scale_reference
A built-in dictionary detailing exactly what each scale name represents. For example, if `freq` is selected from a drop-down, this tab confirms it maps to the exact ordered sequence: *(fast) nie, selten, manchmal, oft, (fast) immer*. 

**What this means for deployment:**
Because of this strict data contract, there is no need to manually reorder factor levels, clean specific strings, or write project-specific filtering logic in R. As long as the raw dataset matches the codebook, the app becomes perfectly plug-and-play.
