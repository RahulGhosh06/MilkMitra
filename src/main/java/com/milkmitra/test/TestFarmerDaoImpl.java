package com.milkmitra.test;

import java.util.List;
import java.util.Scanner;

import com.milkmitra.dao.FarmerDaoImpl;
import com.milkmitra.model.Farmer;

public class TestFarmerDaoImpl {
	
	 public static void main(String[] args) {
	        FarmerDaoImpl dao = null;

	        try {
	            dao = new FarmerDaoImpl();
//
//	            Farmer farmer = new Farmer();
//
//	            farmer.setMppCode("MPP01");
//	            farmer.setFarmerName("Rohit");
//	            farmer.setMobile("6297710241");
//	            farmer.setEmail("rohit@gmail.com");
//	            farmer.setAddress("Fulberia");
//	            farmer.setAccountHolderName("Rohit Ghosh");
//	            farmer.setAccountNo("458963258");
//	            farmer.setIfscCode("SBIN0001234");
//	            farmer.setBankName("SBI");
//	            farmer.setAndharNo("123412342254");
//	            farmer.setJoiningDate(java.time.LocalDate.now());
//	            farmer.setActive(true);
//
//	            String farmerCode = dao.addFarmer(farmer);
//
//	            System.out.println("Generated Farmer Code = " + farmerCode);
	            
//	            
	            List<Farmer> farmers = dao.getAllFarmers();

	            for(Farmer f : farmers)
	            {
	                System.out.printf(f.getFarmerCode(), f.getFarmerName());
	            }
	            
	        }
	        
	        catch (Exception e)
	        {
	            e.printStackTrace();
	        } finally {
	            try {
	                if (dao != null)
	                    dao.cleanUp();
	            } catch (Exception e) {
	                e.printStackTrace();
	            }
	        }
	    }
	}

