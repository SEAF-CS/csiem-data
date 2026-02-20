# CSIEM environmental data management repository

This repository supports compatibility, interoperability, and comparison of CSIEM environmental data assets for Cockburn Sound assessments.

The full CSIEM data ecosystem contains approximately 165 GB of data, but the large raw and ingested stores are managed outside this GitHub repository.

## Repository structure

```
csiem-data/
├── code/             import and processing pipelines (MATLAB + Python)
├── data-governance/  variable keys, site keys, and catalogue workbooks
├── data-mapping/     data mapping resources
├── summary-images/   public summary plots and examples
├── data-lake/        raw data (not tracked in GitHub)
└── data-warehouse/   standardized outputs (not tracked in GitHub)
```

## Reference storage footprint

Approximate size snapshot used by the project:

```
171M    ./code
18M     ./data-governance
31M     ./data-mapping
165M    ./summary-images
98G     ./data-lake          ! Raw data not included in this GitHub repository : see access for further information.
65G     ./data-warehouse     ! Ingested (standardised) data not included in this GitHub repository : see access for further information.
TOTAL = 165G
```

## Operational references

- Import pipeline catalogue and ingest status: [`code/README.md`](code/README.md)
- Governance workflows and keys: [`data-governance/`](data-governance)
- Example compiled data products: [`summary-images/`](summary-images)

## Wiki and documentation

- Project wiki: <https://github.com/SEAF-CS/csiem-data/wiki>
- CSIEM science manual: <https://aquaticecodynamics.github.io/csiem-science/index.html>
