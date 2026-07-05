\## 2026-07-05

\- Added missing FK constraint: users.farmer\_code -> farmers.farmer\_code



\## 2026-07-05(2)

\- Migrated milkcollection to use farmer\_id FK instead of farmerCode (surrogate key over natural key)


## 2026-07-05 (3)

\- Removed hardcoded fallback DB credentials from DBConnection.java (security fix)

\- Fixed MilkCollectionDaoImpl insert to use explicit column list + farmer\_id lookup (was broken by farmer\_id migration)

\- Verified milk collection insert works correctly end-to-end

