-- Added missing FK: users.farmer_code -> farmers.farmer_code
-- Verified no orphaned records before applying
ALTER TABLE users
  ADD CONSTRAINT fk_users_farmer_code
  FOREIGN KEY (farmer_code) REFERENCES farmers(farmer_code)
  ON DELETE SET NULL
  ON UPDATE CASCADE;