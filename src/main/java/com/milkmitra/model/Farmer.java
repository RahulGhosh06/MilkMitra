package com.milkmitra.model;

import java.sql.Date;
import java.time.LocalDate;

public class Farmer
{
	//farmer_id | farmer_code | farmer name | mobile | email | address | account holder name | bank account no | ifsc code
	//bank_name | aadhaar_no | joining_date | is_active | mpp_code
	
	private int farmerId;
	private String mppCode;
	private String farmerCode;
	private String farmerName;
	private String mobile;
	private String email;
	private String address;
	private String accountHolderName;
	private String accountNo;
	private String ifscCode;
	private String bankName;
	private String andharNo;
	private LocalDate joiningDate;
	private boolean isActive;
	//private String mppCode;
	
	public Farmer() {
		// TODO Auto-generated constructor stub
		
	super();
	}
	
	//farmer_code, farmer_name, mobile, joining_date --> Constructor for fetching all farmer details..
	public Farmer(String farmerCode, String farmerName, String mobile, LocalDate joiningDate, boolean isActive)
	{
		this.farmerCode  = farmerCode;
		this.farmerName  = farmerName;
		this.mobile      = mobile;
		this.joiningDate = joiningDate;
		this.isActive    = isActive;
	}
	
	

	


	public int getFarmerId() {
		return farmerId;
	}
	public void setFarmerId(int farmerId) {
		this.farmerId = farmerId;
	}
	public String getMppCode() {
		return mppCode;
	}
	public void setMppCode(String mppCode) {
		this.mppCode = mppCode;
	}
	public String getFarmerCode() {
		return farmerCode;
	}
	public void setFarmerCode(String farmerCode) {
		this.farmerCode = farmerCode;
	}
	public String getFarmerName() {
		return farmerName;
	}
	public void setFarmerName(String farmerName) {
		this.farmerName = farmerName;
	}
	public String getMobile() {
		return mobile;
	}
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	
	public String getAccountHolderName() {
		return accountHolderName;
	}

	public void setAccountHolderName(String accountHolderName)
	{
		this.accountHolderName = accountHolderName;
	}
	public String getIfscCode() {
		return ifscCode;
	}
	public void setIfscCode(String ifscCode) {
		this.ifscCode = ifscCode;
	}
	public String getBankName() {
		return bankName;
	}
	public void setBankName(String bankName) {
		this.bankName = bankName;
	}
	public String getAndharNo() {
		return andharNo;
	}
	public void setAndharNo(String andharNo) {
		this.andharNo = andharNo;
	}
	
	public LocalDate getJoiningDate() {
		return joiningDate;
	}

	public void setJoiningDate(LocalDate joiningDate) {
		this.joiningDate = joiningDate;
	}

	public boolean isActive() {
		return isActive;
	}
	public void setActive(boolean isActive) {
		this.isActive = isActive;
	}

	public String getAccountNo() {
		return accountNo;
	}

	public void setAccountNo(String accountNo) {
		this.accountNo = accountNo;
	}
		
}
