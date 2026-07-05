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



