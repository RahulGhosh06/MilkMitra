package com.milkmitra.model;

public class Dashboard
{
    private int todayEntries;
    private int morningEntries;
    private int eveningEntries;

    private double todayTotalLtr;
    private double todayCowLtr;
    private double todayBufLtr;

    private double todayValue;
    private double avgFat;
    private double avgSnf;

    private int totalFarmers;
    private int activeFarmers;
    private int inactiveFarmers;
    
    public Dashboard()
    {
    }
    
    
	public int getTodayEntries() {
		return todayEntries;
	}
	public void setTodayEntries(int todayEntries) {
		this.todayEntries = todayEntries;
	}
	public int getMorningEntries() {
		return morningEntries;
	}
	public void setMorningEntries(int morningEntries) {
		this.morningEntries = morningEntries;
	}
	public int getEveningEntries() {
		return eveningEntries;
	}
	public void setEveningEntries(int eveningEntries) {
		this.eveningEntries = eveningEntries;
	}
	public double getTodayTotalLtr() {
		return todayTotalLtr;
	}
	public void setTodayTotalLtr(double todayTotalLtr) {
		this.todayTotalLtr = todayTotalLtr;
	}
	public double getTodayCowLtr() {
		return todayCowLtr;
	}
	public void setTodayCowLtr(double todayCowLtr) {
		this.todayCowLtr = todayCowLtr;
	}
	public double getTodayBufLtr() {
		return todayBufLtr;
	}
	public void setTodayBufLtr(double todayBufLtr) {
		this.todayBufLtr = todayBufLtr;
	}
	public double getTodayValue() {
		return todayValue;
	}
	public void setTodayValue(double todayValue) {
		this.todayValue = todayValue;
	}
	public double getAvgFat() {
		return avgFat;
	}
	public void setAvgFat(double avgFat) {
		this.avgFat = avgFat;
	}
	public double getAvgSnf() {
		return avgSnf;
	}
	public void setAvgSnf(double avgSnf) {
		this.avgSnf = avgSnf;
	}
	public int getTotalFarmers() {
		return totalFarmers;
	}
	public void setTotalFarmers(int totalFarmers) {
		this.totalFarmers = totalFarmers;
	}
	public int getActiveFarmers() {
		return activeFarmers;
	}
	public void setActiveFarmers(int activeFarmers) {
		this.activeFarmers = activeFarmers;
	}
	public int getInactiveFarmers() {
		return inactiveFarmers;
	}
	public void setInactiveFarmers(int inactiveFarmers) {
		this.inactiveFarmers = inactiveFarmers;
	}

    // getters setters
    
    
}