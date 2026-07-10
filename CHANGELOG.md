
\## 2026-07-10 (3)
- Fixed a JavaScript syntax error in the embedded Milk Collection view
  caused by an unescaped line break inside a string literal, which was
  silently breaking the entire script block (farmer lookup, live
  badge/rate calculation, greeting, and shift subtitle all failed as
  a result).
- Added specific handling for duplicate collection entries
  (SQLIntegrityConstraintViolationException) with a user-friendly
  error message instead of a raw HTTP 500.

\## 2026-07-10 (2)

\- Integrated Milk Collection into the unified admin dashboard shell

&#x20; instead of a standalone page

\- Root cause: milkcollection.jsp was a fully separate page with no

&#x20; sidebar/topbar, breaking the consistent nav shell every other admin

&#x20; screen (addFarmer, farmerList, payments, etc.) already used

\- Fix: added a `milkCollection` case to AdminDashboardServlet's view

&#x20; switch, added the matching view block + CSS + JS (farmer lookup,

&#x20; live shift/milk-type/rate calculator) to AdminDashboard.jsp

\- Also fixed MilkCollectionServlet, which had 10 hardcoded redirects

&#x20; back to the old standalone milkcollection.jsp (on both the success

&#x20; path and every validation error) — these now redirect to

&#x20; AdminDashboardServlet?view=milkCollection so saving a collection

&#x20; keeps the admin inside the dashboard shell instead of kicking them

&#x20; back out to the old page



\## 2026-07-10

\- Fixed farmer dashboard showing stale/zeroed data after navigating from

&#x20; Payment History back to Dashboard/Home

\- Root cause: Dashboard and Home nav links only did a client-side JS

&#x20; toggle (navTo()) instead of a real request, so they reused whatever

&#x20; HTML was already rendered by the last real page load (e.g. Payment

&#x20; History, which never populates the `dashboard` attribute) — every

&#x20; dashboard field silently fell back to its zero/null default

\- Fix: Dashboard (drawer) and Home (bottom nav) now navigate to

&#x20; FarmerDashboardServlet directly, same pattern already used by Payment,

&#x20; guaranteeing fresh data on every click regardless of which screen

&#x20; was previously shown



\## 2026-07-06 (3)

\- Fixed critical bug: "today's" data queries used SQL curdate(), which

&#x20; reads the DB server's own clock (UTC on Railway) instead of the actual

&#x20; IST date. This caused newly-saved entries to be invisible in reports/

&#x20; dashboard for \~5.5 hours around midnight IST, even though they were

&#x20; saved correctly (confirmed by duplicate-entry check firing correctly)

\- Fixed in AdminDashboardDaoImpl (3 queries) and MilkCollectionReportDaoImpl

&#x20; (2 queries) — now pass an explicit Asia/Kolkata date as a bind parameter

&#x20; instead of relying on curdate()



\## 2026-07-06 (2)

\- Fixed timezone bug: date/time displays used server default timezone

&#x20; instead of explicit Asia/Kolkata, causing wrong dates/times to show

&#x20; on cloud (UTC server) while working correctly on local (IST machine)

\- Fixed in AdminDashboard.jsp, milkcollectionReport.jsp, FarmerCollectionDetails.jsp



\## 2026-07-06

\- Replaced single shared static DB connection with HikariCP connection pool

\- Root cause fixed: concurrent requests were closing each other's shared connection

\- Converted all 7 DAOs (UserDaoImpl, FarmerDaoImpl, MilkCollectionDaoImpl,

&#x20; MilkCollectionReportDaoImpl, PaymentDaoImpl, AdminDashboardDaoImpl,

&#x20; FarmerDashboardDaoImpl) to borrow a pooled connection per method call

&#x20; instead of holding one connection for the DAO's entire lifetime

\- Removed now-unreachable try/catch(SQLException) blocks in servlets

&#x20; calling dao.cleanUp(), since cleanUp() is now a no-op

\- Verified app end-to-end: login, farmers, dashboard, milk collection,

&#x20; reports, payments all working correctly with pooled connections



\## 2026-07-05 (3)

\- Removed hardcoded fallback DB credentials from DBConnection.java (security fix)

\- Fixed MilkCollectionDaoImpl insert to use explicit column list + farmer\_id lookup (was broken by farmer\_id migration)

\- Verified milk collection insert works correctly end-to-end



\## 2026-07-05(2)

\- Migrated milkcollection to use farmer\_id FK instead of farmerCode (surrogate key over natural key)





## 2026-07-05

\- Added missing FK constraint: users.farmer\_code -> farmers.farmer\_code

