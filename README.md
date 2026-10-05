# OASIS: Online App for Survey Interactive Study
This repo contains code and documentation for an app for interactive exploration of survey data.

## Repo structure:
```text
├── .github/
│   └── workflows/
│       └── deploy.yml                # CI/CD script to compile and deploy app to Shinylive WebAssembly
├── www/
│   ├── custom.css                    # Global CSS overrides for UI elements not covered by bslib
│   └── logo.png                      # Client or consulting unit branding image
├── R/
│   ├── config.R                      # Global settings (colors, titles); the only file consultants edit
│   ├── translations.R                # Centralized dictionary and tr() function for EN/DE bilingual UI
│   ├── load_data.R                   # Ingestion utility & data cleaner that applies the codebook contract safely
│   ├── extract/
│   │   ├── create_deck.R             # Assembles survey metadata deck
│   │   ├── extract_generic.R         # S3 generic: extract()
│   │   ├── extract_default.R         # S3 method: extract.default()
│   │   └── extract_multiple_choice.R # S3 method: extract.multiple_choice()
│   ├── models/
│   │   ├── user_data.R               # R6: Ingests raw data & codebook
│   │   ├── user_choice.R             # R6: Holds & validates UI parameter state
│   │   └── plot_payload.R            # R6: Validated DTO (data, meta, settings)
│   ├── pipeline/
│   │   └── resolve_payload.R         # Functional bridge: resolves to PlotPayload
│   ├── plots/
│   │   ├── base_plot.R               # R6 abstract parent: themes, scales, labels
│   │   ├── bar_plot.R                # R6 concrete child: geometry & rendering
│   │   └── plot_factory.R            # R6 / service: instantiates plot classes
│   └── tables/
│       └── cross_table.R             # Generates dynamic, cross-tabulated HTML or DT tables
├── test/
│   └── testthat/
│       ├── test-extract.R            # S3 extraction tests
│       ├── test-user_data.R          # UserData tests
│       ├── test-user_choice.R        # UserChoice tests
│       ├── test-plot_payload.R       # PlotPayload schema & boundary tests
│       ├── test-resolve_payload.R    # Orchestration pipeline tests
│       ├── test-base_plot.R          # Abstract plot methods & styling tests
│       ├── test-bar_plot.R           # Geometry rendering tests
│       └── test-plot_factory.R       # Factory dispatch tests
├── template_codebook.xlsx            # Mandatory blank template defining column names and variable classes
├── app.R                             # Minimal Shiny UI/Server orchestrator that dynamically sources R/
├── .gitignore                        # Prevents local RStudio settings and history from being committed
└── README.md                         # Deployment instructions and architectural guide for colleagues## Data Contract

### The data
To ensure seamless integration with the codebook and the automated extraction pipeline, the raw survey dataset must adhere to a strict wide-format structure. The application expects the data to be prepared with the following specifications:

- Wide Format Configuration: Each row must represent a single respondent, and each column must represent a distinct variable or data point.

- Single-Choice & Numeric Questions: Represented by a single column per question (e.g., AA01), containing the selected response or continuous value.

- Multiple-Choice Questions (MCQ): Spread across multiple distinct columns, with one column dedicated to every possible answer option for that specific question (e.g., BB02_01, BB02_02, BB02_03).

- Mandatory `id` Column: A unique identifier required for every respondent in the dataset to ensure accurate cross-tabulation and tracking.

- Mandatory `missing` Column: A calculated numeric column indicating the overall percentage of missing answers for each respondent, used for quality control and filtering within the dashboard.

What this means for deployment:
Formatting the dataset in this exact manner guarantees that the load_data.R script and the underlying extraction classes (extract.single and extract.multiple) can automatically reshape, pivot, and evaluate the data without requiring custom pre-processing scripts or manual data wrangling prior to launch.
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
