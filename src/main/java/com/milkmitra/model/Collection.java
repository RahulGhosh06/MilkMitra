package com.milkmitra.model;


import java.sql.Timestamp;
import java.time.LocalDate;

public class Collection
{
	//collectionId | farmerCode | collectionDate | shift | milkType
	//quantity | fat | snf | amount | ratePerLtr
	//isActive | createdAt
	
	private int collectionId;
	private String farmerCode;
	private LocalDate collectionDate;
	private String shift;
	private String milkType;
	private double quantity;
	private double fat;
	private double snf;
	private double amount;
	private double ratePerLtr;
	private boolean isActive;
	private Timestamp createdAt;
	
	
	public Collection()
	{
		
	}


	public int getCollectionId() {
		return collectionId;
	}


	public void setCollectionId(int collectionId) {
		this.collectionId = collectionId;
	}


	public String getFarmerCode() {
		return farmerCode;
	}


	public void setFarmerCode(String farmerCode) {
		this.farmerCode = farmerCode;
	}


	public LocalDate getCollectionDate() {
		return collectionDate;
	}


	public void setCollectionDate(LocalDate collectionDate) {
		this.collectionDate = collectionDate;
	}


	public String getShift() {
		return shift;
	}


	public void setShift(String shift) {
		this.shift = shift;
	}


	public String getMilkType() {
		return milkType;
	}


	public void setMilkType(String milkType) {
		this.milkType = milkType;
	}


	public double getQuantity() {
		return quantity;
	}


	public void setQuantity(double quantity) {
		this.quantity = quantity;
	}


	public double getFat() {
		return fat;
	}


	public void setFat(double fat) {
		this.fat = fat;
	}


	public double getSnf() {
		return snf;
	}


	public void setSnf(double snf) {
		this.snf = snf;
	}


	public double getAmount() {
		return amount;
	}


	public void setAmount(double amount) {
		this.amount = amount;
	}


	public double getRatePerLtr() {
		return ratePerLtr;
	}


	public void setRatePerLtr(double ratePerLtr) {
		this.ratePerLtr = ratePerLtr;
	}


	public boolean isActive() {
		return isActive;
	}


	public void setActive(boolean isActive) {
		this.isActive = isActive;
	}

	public Timestamp getCreatedAt() {
	    return createdAt;
	}

	public void setCreatedAt(Timestamp createdAt) {
	    this.createdAt = createdAt;
	}
	
}
