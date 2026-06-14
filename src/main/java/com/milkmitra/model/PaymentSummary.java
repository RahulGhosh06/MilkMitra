package com.milkmitra.model;

import java.time.LocalDate;

public class PaymentSummary {

    private LocalDate cycleStart;
    private LocalDate cycleEnd;
    

    private double totalMilk;
    private double totalAmount;
    
    private int totalFarmers;

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
}