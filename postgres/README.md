# Rulebook to PostgreSQL Script Generation Report

**Schema:** `public`
**Database:** `demo`
**Timestamp:** 2026-08-24 18:24:17 UTC

## Parsing Rulebook

Found **8** tables in rulebook


  - **SiteSettings** (10 fields, 1 records)
  - **BioVariants** (6 fields, 6 records)
  - **HowIWorkSections** (6 fields, 7 records)
  - **ProofPoints** (11 fields, 8 records)
  - **JobEntries** (16 fields, 16 records)
  - **ResumeVariants** (6 fields, 2 records)
  - **ResumeListItems** (5 fields, 16 records)
  - **EducationEntries** (7 fields, 1 records)

Generated **8** table definitions with **59** raw fields (mode=check-add)
Generated **8** calculation functions
Generated **8** views
Enabled RLS on **8** tables
Generated insert statements for **57** records
## Script Generation Complete

Generated files:
- `00-bootstrap.sql` - Bootstrap (overwrite Never); includes commented-out drop-all script
- `01-drop-and-create-tables.sql` - Drop and recreate tables with raw fields and FK indexes
- `02-create-functions.sql` - Create calculation functions
- `03-create-views.sql` - Create views with calculated fields
- `04-create-policies.sql` - Create RLS policies
- `05-insert-data.sql` - Insert data from rulebook
- `99-fk-constraints.sql` - FK constraints (skipped unless EFFORTLESS_ENFORCE_FKS=true)
- `init-db.sh` - Database initialization script

