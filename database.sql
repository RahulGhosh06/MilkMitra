CREATE DATABASE IF NOT EXISTS milkmitra;
USE milkmitra;

-- Roles
CREATE TABLE roles(
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(50) NOT NULL UNIQUE
);

-- Users
CREATE TABLE users(
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role_id INT,
    email VARCHAR(100),
    FOREIGN KEY(role_id) REFERENCES roles(role_id)
);

-- Farmers
CREATE TABLE farmers(
    farmer_id INT PRIMARY KEY AUTO_INCREMENT,
    mpp_code VARCHAR(20),
    farmer_code VARCHAR(20) UNIQUE,
    farmer_name VARCHAR(100),
    mobile VARCHAR(15),
    email VARCHAR(100),
    address VARCHAR(255),
    account_holder_name VARCHAR(100),
    bank_account_no VARCHAR(30),
    ifsc_code VARCHAR(20),
    bank_name VARCHAR(100),
    andhar_number VARCHAR(20),
    joining_date DATE,
    is_active BOOLEAN DEFAULT TRUE
);

-- Milk Collection
CREATE TABLE milkCollection(
    collectionId INT PRIMARY KEY AUTO_INCREMENT,
    farmerCode VARCHAR(20),
    collectionDate DATE,
    shift VARCHAR(20),
    milkType VARCHAR(10),
    quantity DOUBLE,
    fat DOUBLE,
    snf DOUBLE,
    amount DOUBLE,
    ratePerLtr DOUBLE,
    isActive BOOLEAN DEFAULT TRUE,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(farmerCode) REFERENCES farmers(farmer_code)
);