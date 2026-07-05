-- Migrated milkcollection from string-based farmerCode FK to proper farmer_id FK
-- Steps: added farmer_id column, backfilled from farmers table, verified no NULLs,
-- added NOT NULL + FK constraint, dropped old farmerCode FK, updated unique index

ALTER TABLE milkcollection
  ADD COLUMN farmer_id INT NULL AFTER farmerCode;

UPDATE milkcollection mc
JOIN farmers f ON mc.farmerCode = f.farmer_code
SET mc.farmer_id = f.farmer_id;

ALTER TABLE milkcollection
  MODIFY farmer_id INT NOT NULL;

ALTER TABLE milkcollection
  ADD CONSTRAINT fk_milkcollection_farmer_id
  FOREIGN KEY (farmer_id) REFERENCES farmers(farmer_id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;

ALTER TABLE milkcollection
  DROP FOREIGN KEY milkcollection_ibfk_1;

ALTER TABLE milkcollection
  DROP INDEX farmerCode;

ALTER TABLE milkcollection
  ADD UNIQUE KEY uq_collection_natural (farmer_id, collectionDate, shift, milkType);