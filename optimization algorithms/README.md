# Optimization Algorithms (Educational Repository)

This repository is an **educational collection of optimization algorithms** (mainly metaheuristics) organized in a consistent, readable structure.

It is designed to be used as a **separate algorithms repository** that can be integrated into an external benchmarking / comparison framework (for example, as a *Git submodule*). The goal is to make algorithms easy to:
- study and compare,
- run inside a benchmarking pipeline,
- cite correctly (paper/DOI, authors, year),
- trace code provenance (MathWorks/File Exchange, GitHub, etc.).

## Who is this for?
- Students learning optimization and metaheuristics
- Researchers who want a clean “library-like” layout (without pretending to be a perfect library)
- Anyone building a benchmarking framework and wanting a **reproducible algorithm source**

## Maintainer
- **Maintainer / Curator:** Mohammad Mahdi  
  (Replace/extend with your preferred name/handle/contact.)

## Author / Curator

- **Creator:** Mohammad Mahdi Hashemi (محمدمهدی هاشمی)
- **Role:** Repository author and curator (educational collection & organization)

### Contact
- **Email:** osonhast@gmail.com
- **LinkedIn:** https://www.linkedin.com/in/smmh1999/
- **GitHub:** https://github.com/SMMH1999
- **Google Scholar:** https://scholar.google.com/citations?user=p8tRD_EAAAAJ&hl=en

## Reference / Main Framework

This algorithms repository is intended to be used (e.g., as a Git submodule) by the main benchmarking framework:

- **Base Optimization Framework:** https://github.com/SMMH1999/Base-Optimization-Framework


## Repository structure

Algorithms are grouped by **high-level categories**. Each algorithm lives in its own folder.

Recommended pattern:

```
<category>/
  <Algorithm Full Name (ACRONYM)>/
    Algorithm.m                 # main implementation (or a folder of .m files)
    README.md                   # algorithm-level documentation
    CITATION.md                 # paper + DOI and how to cite
    METADATA.json               # machine-readable metadata (authors/year/source links)
    LICENSE.txt                 # optional: if upstream code has its own license
    assets/                     # optional: figures, diagrams, parameter tables
```

### Category naming
Keep categories few and meaningful. Examples:
- `1_Animal_and_Plant_Based`
- `2_Evolutionary_Based`
- `3_Physics_and_Math_Based`
- `4_Human_Activity_Based`
- `Multiobjective`
- `Real_World_Problems`
- `Hybrid_and_Improved`

### Algorithm folder naming
Use **Title Case** for the full algorithm name, and put the acronym in parentheses:

- `Golden Eagle Optimizer (GEO)`
- `Harris Hawks Optimization (HHO)`
- `Differential Evolution (DE)`

> Folder names should be stable because external frameworks may reference them.

---

## Template Algorithm (TA)

A reusable template is provided at:

- `Template Algorithm (TA)/`

Use it to add new algorithms with consistent documentation and metadata.

### How to add a new algorithm
1. Copy the template folder:
   - Duplicate `Template Algorithm (TA)` into the proper category folder.
2. Rename it to:
   - `<Full Name (ACRONYM)>`
3. Replace placeholders inside:
   - `README_ALGORITHM.md` (or rename to `README.md`)
   - `CITATION.md`
   - `METADATA.json`
4. Add the algorithm implementation file(s):
   - `Algorithm.m` (or multiple `.m` files)
5. Include the **source/provenance link**:
   - e.g., MathWorks File Exchange page, GitHub repo, or an archived link

### Required fields (minimum)
Every algorithm folder should contain:
- **Paper title + DOI (or official publisher link)**
- **Authors** (paper authors / algorithm proposers)
- **Year**
- **Code source link** (where the code was obtained)
- **Notes about modifications** (if you adapted the code)

---

## Provenance and licenses
Many algorithm implementations are adapted from public sources (e.g., MathWorks File Exchange, authors’ code, GitHub).
- Always include the original link(s) in `METADATA.json`.
- If upstream code has a specific license, place it inside the algorithm folder as `LICENSE.txt` (or reference it clearly).

---

## Contribution guidelines
Contributions are welcome, but consistency matters.

Please ensure:
- Folder name follows: `Full Name (ACRONYM)`
- Template fields are fully filled
- Links are valid
- No hard-coded paths
- The algorithm runs with a clean MATLAB path (no missing dependencies)

---

## Disclaimer
This repository is for **educational and research** purposes. It is not a guaranteed “production-grade” library. Use and verify algorithms carefully for your specific application.
