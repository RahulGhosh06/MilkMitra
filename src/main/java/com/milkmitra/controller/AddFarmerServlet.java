package com.milkmitra.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.milkmitra.dao.FarmerDaoImpl;
import com.milkmitra.dao.IFarmerDao;
import com.milkmitra.dao.IUserDao;
import com.milkmitra.dao.UserDaoImpl;
import com.milkmitra.model.Farmer;

/**
 * Servlet implementation class AddFarmerServlet
 */
@WebServlet("/AddFarmerServlet")
public class AddFarmerServlet extends HttpServlet {
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("AddFarmerServlet Servlet Called");
    	response.setContentType("text/html");
    	HttpSession session = request.getSession();
    	
    	//farmer_id | farmer_code | farmer name | mobile | email | address | account holder name | bank account no | ifsc code
    	//bank_name | aadhaar_no | joining_date | is_active | mpp_code
    	String mppCode = "MPP01"; // TODO: Get mppCode from logged-in admin session
    	//String farmerCode = request.getParameter("farmerCode");
    	String farmerName = request.getParameter("farmerName");
    	String mobile = request.getParameter("mobile");
    	String email = request.getParameter("email");
    	String address = request.getParameter("address");
    	String accountHolderName = request.getParameter("accountHolderName");
    	String bankAccountNo = request.getParameter("bankAccountNo");
    	String ifscCode = request.getParameter("ifscCode");
    	String bankName = request.getParameter("bankName");
    	String andharNo = request.getParameter("andharNo");
    	//LocalDate joiningDate = request.getParameter("");
    	//boolean isActi
    	
    	IFarmerDao dao = null;
    	IUserDao userDao = null;
    	
    	try {
    		
    		dao = new FarmerDaoImpl();
    		
    		Farmer farmer = new Farmer();

    		farmer.setMppCode(mppCode);
    		farmer.setFarmerName(farmerName);
    		farmer.setMobile(mobile);
    		farmer.setEmail(email);
    		farmer.setAddress(address);
    		farmer.setAccountHolderName(accountHolderName);
    		farmer.setAccountNo(bankAccountNo);
    		farmer.setIfscCode(ifscCode);
    		farmer.setBankName(bankName);
    		farmer.setAndharNo(andharNo);
    		farmer.setJoiningDate(LocalDate.now());
    		farmer.setActive(true);
    		
    		String farmerCode = dao.addFarmer(farmer);
    		
    		if(farmerCode != null)
    		{
    			userDao = new UserDaoImpl();
    			
    			System.out.println("Mobile = " + farmer.getMobile());
    			System.out.println("Farmer Code = " + farmer.getFarmerCode());
    			System.out.println("Email = " + farmer.getEmail());
    			
    			userDao.createFarmerLogin(
    			        farmer.getMobile(),
    			        farmer.getFarmerCode(),
    			        farmer.getEmail()
    			);
    			
    			session.setAttribute(
    			    "successMsg",
    			    "Farmer Added Successfully. Code : " + farmerCode
    			);

    			response.sendRedirect("AddFarmer.jsp");
    			return;
    		}
    		
    		else {
            	session.setAttribute("errorMsg", "Farmer Not added or Already exists!!");
            	response.sendRedirect("AddFarmer.jsp");
            	return;
    		}
    		
    	}
    	catch(SQLException e)
    	{
    	    e.printStackTrace();

    	    String error = e.getMessage();

    	    if(error.contains("mobile"))
    	    {
    	        session.setAttribute(
    	            "errorMsg",
    	            mobile + " belongs to another farmer. Please enter a different mobile number."
    	        );
    	    }
    	    else if(error.contains("andhar_number"))
    	    {
    	        session.setAttribute(
    	            "errorMsg",
    	            andharNo + " is already registered with another farmer."
    	        );
    	    }
    	    else if(error.contains("bank_account_no"))
    	    {
    	        session.setAttribute(
    	            "errorMsg",
    	            "Bank account number already belongs to another farmer."
    	        );
    	    }
    	    else if(error.contains("email"))
    	    {
    	        session.setAttribute(
    	            "errorMsg",
    	            "Email address already belongs to another farmer."
    	        );
    	    }
    	    else
    	    {
    	        session.setAttribute(
    	            "errorMsg",
    	            "Database Error : " + error
    	        );
    	    }

    	    response.sendRedirect("AddFarmer.jsp");
    	    return;
    	}
    	catch(Exception e)
    	{
    	    e.printStackTrace();

    	    session.setAttribute(
    	        "errorMsg",
    	        "System Error : " + e.getMessage()
    	    );

    	    response.sendRedirect("AddFarmer.jsp");
    	    return;
    	}
        
	    finally // ← ALWAYS runs, success or failure
	    {
	        if(dao != null)
	        {
	            try
	            {
	            	((FarmerDaoImpl) dao).cleanUp(); 
	            }
	                
	            catch(SQLException e) 
	            { 
	               e.printStackTrace(); 
	            }
	         }
	            
	     }
    	
	}

}
