package com.milkmitra.model;

public class FarmerDashboard {

    // Current Year Summary
    private int totalActiveDaysThisYear;
    private double totalMilkThisYear;
    private double totalEarningThisYear;

    // Current Payment Cycle Summary
    private double totalMilkThisCycle;
    private double totalEarningThisCycle;

    // Today's Summary
    private double todayMilk;
    private double todayEarning;

 // Morning Shift — Cow
    private double morningCowQty;
    private double morningCowFat;
    private double morningCowSnf;
    private double morningCowAmount;

    // Morning Shift — Buffalo
    private double morningBufQty;
    private double morningBufFat;
    private double morningBufSnf;
    private double morningBufAmount;

    // Evening Shift — Cow
    private double eveningCowQty;
    private double eveningCowFat;
    private double eveningCowSnf;
    private double eveningCowAmount;

    // Evening Shift — Buffalo
    private double eveningBufQty;
    private double eveningBufFat;
    private double eveningBufSnf;
    private double eveningBufAmount;
    public FarmerDashboard() {
    }

    public int getTotalActiveDaysThisYear() {
        return totalActiveDaysThisYear;
    }

    public void setTotalActiveDaysThisYear(int totalActiveDaysThisYear) {
        this.totalActiveDaysThisYear = totalActiveDaysThisYear;
    }

    public double getTotalMilkThisYear() {
        return totalMilkThisYear;
    }

    public void setTotalMilkThisYear(double totalMilkThisYear) {
        this.totalMilkThisYear = totalMilkThisYear;
    }

    public double getTotalEarningThisYear() {
        return totalEarningThisYear;
    }

    public void setTotalEarningThisYear(double totalEarningThisYear) {
        this.totalEarningThisYear = totalEarningThisYear;
    }

    public double getTotalMilkThisCycle() {
        return totalMilkThisCycle;
    }

    public void setTotalMilkThisCycle(double totalMilkThisCycle) {
        this.totalMilkThisCycle = totalMilkThisCycle;
    }

    public double getTotalEarningThisCycle() {
        return totalEarningThisCycle;
    }

    public void setTotalEarningThisCycle(double totalEarningThisCycle) {
        this.totalEarningThisCycle = totalEarningThisCycle;
    }

    public double getTodayMilk() {
        return todayMilk;
    }

    public double getMorningCowQty() {
		return morningCowQty;
	}

	public void setMorningCowQty(double morningCowQty) {
		this.morningCowQty = morningCowQty;
	}

	public double getMorningCowFat() {
		return morningCowFat;
	}

	public void setMorningCowFat(double morningCowFat) {
		this.morningCowFat = morningCowFat;
	}

	public double getMorningCowSnf() {
		return morningCowSnf;
	}

	public void setMorningCowSnf(double morningCowSnf) {
		this.morningCowSnf = morningCowSnf;
	}

	public double getMorningCowAmount() {
		return morningCowAmount;
	}

	public void setMorningCowAmount(double morningCowAmount) {
		this.morningCowAmount = morningCowAmount;
	}

	public double getMorningBufQty() {
		return morningBufQty;
	}

	public void setMorningBufQty(double morningBufQty) {
		this.morningBufQty = morningBufQty;
	}

	public double getMorningBufFat() {
		return morningBufFat;
	}

	public void setMorningBufFat(double morningBufFat) {
		this.morningBufFat = morningBufFat;
	}

	public double getMorningBufSnf() {
		return morningBufSnf;
	}

	public void setMorningBufSnf(double morningBufSnf) {
		this.morningBufSnf = morningBufSnf;
	}

	public double getMorningBufAmount() {
		return morningBufAmount;
	}

	public void setMorningBufAmount(double morningBufAmount) {
		this.morningBufAmount = morningBufAmount;
	}

	public double getEveningCowQty() {
		return eveningCowQty;
	}

	public void setEveningCowQty(double eveningCowQty) {
		this.eveningCowQty = eveningCowQty;
	}

	public double getEveningCowFat() {
		return eveningCowFat;
	}

	public void setEveningCowFat(double eveningCowFat) {
		this.eveningCowFat = eveningCowFat;
	}

	public double getEveningCowSnf() {
		return eveningCowSnf;
	}

	public void setEveningCowSnf(double eveningCowSnf) {
		this.eveningCowSnf = eveningCowSnf;
	}

	public double getEveningCowAmount() {
		return eveningCowAmount;
	}

	public void setEveningCowAmount(double eveningCowAmount) {
		this.eveningCowAmount = eveningCowAmount;
	}

	public double getEveningBufQty() {
		return eveningBufQty;
	}

	public void setEveningBufQty(double eveningBufQty) {
		this.eveningBufQty = eveningBufQty;
	}

	public double getEveningBufFat() {
		return eveningBufFat;
	}

	public void setEveningBufFat(double eveningBufFat) {
		this.eveningBufFat = eveningBufFat;
	}

	public double getEveningBufSnf() {
		return eveningBufSnf;
	}

	public void setEveningBufSnf(double eveningBufSnf) {
		this.eveningBufSnf = eveningBufSnf;
	}

	public double getEveningBufAmount() {
		return eveningBufAmount;
	}

	public void setEveningBufAmount(double eveningBufAmount) {
		this.eveningBufAmount = eveningBufAmount;
	}

	public void setTodayMilk(double todayMilk) {
        this.todayMilk = todayMilk;
    }

    public double getTodayEarning() {
        return todayEarning;
    }

    public void setTodayEarning(double todayEarning) {
        this.todayEarning = todayEarning;
    }

    
}