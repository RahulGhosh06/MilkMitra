package com.milkmitra.model;

import java.time.LocalDate;

public class PaymentSummary {

	private LocalDate cycleStart;
	private LocalDate cycleEnd;

	private double totalMilk;
	private double totalAmount;

	private int totalFarmers;

	private LocalDate collectionDate;

	private String shift;

	private String milkType;

	private double fat;

	private double snf;

	private double ratePerLtr;

	public LocalDate getCycleStart() {
		return cycleStart;
	}

	public void setCycleStart(LocalDate cycleStart) {
		this.cycleStart = cycleStart;
	}

	public LocalDate getCycleEnd() {
		return cycleEnd;
	}

	public void setCycleEnd(LocalDate cycleEnd) {
		this.cycleEnd = cycleEnd;
	}

	public double getTotalMilk() {
		return totalMilk;
	}

	public void setTotalMilk(double totalMilk) {
		this.totalMilk = totalMilk;
	}

	public double getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(double totalAmount) {
		this.totalAmount = totalAmount;
	}

	public int getTotalFarmers() {
		return totalFarmers;
	}

	public void setTotalFarmers(int totalFarmers) {
		this.totalFarmers = totalFarmers;
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

	public double getFat() {
		return fat;
	}

	public void setFat(double fat) {
		this.fat = fat;
	}

	public String getMilkType() {
		return milkType;
	}

	public void setMilkType(String milkType) {
		this.milkType = milkType;
	}

	public double getSnf() {
		return snf;
	}

	public void setSnf(double snf) {
		this.snf = snf;
	}

	public double getRatePerLtr() {
		return ratePerLtr;
	}

	public void setRatePerLtr(double ratePerLtr) {
		this.ratePerLtr = ratePerLtr;
	}

}