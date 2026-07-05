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
import com.milkmitra.model.Farmer;

/**
 * Servlet implementation class EditFarmerServlet
 */
@WebServlet("/EditFarmerServlet")
public class EditFarmerServlet extends HttpServlet
{
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		System.out.println("EditFarmerServlet Servlet Called");
    	response.setContentType("text/html");
    	HttpSession session = request.getSession();
    	
    	String farmerName = request.getParameter("farmerName");
    	String mobile = request.getParameter("mobile");
    	String email = request.getParameter("email");
    	String address = request.getParameter("address");
    	String accountHolderName = request.getParameter("accountHolderName");
    	String bankAccountNo = request.getParameter("bankAccountNo");
    	String ifscCode = request.getParameter("ifscCode");
    	String bankName = request.getParameter("bankName");
    	String andharNo = request.getParameter("andharNo");
    	String farmerCode = request.getParameter("farmerCode");
    	
    	IFarmerDao dao = null;
    	
    	try
    	{
    		dao = new FarmerDaoImpl();
    		
    		Farmer farmer = new Farmer();

    		farmer.setFarmerName(farmerName);
    		farmer.setMobile(mobile);
    		farmer.setEmail(email);
    		farmer.setAddress(address);
    		farmer.setAccountHolderName(accountHolderName);
    		farmer.setAccountNo(bankAccountNo);
    		farmer.setIfscCode(ifscCode);
    		farmer.setBankName(bankName);
    		farmer.setAndharNo(andharNo);
    		farmer.setFarmerCode(farmerCode);
    		
    		int count = dao.editFarmerDetails(farmer);
    		
    		if(count  == 1)
    		{
    			session.setAttribute(
    			        "successMsg",
    			        "Farmer details updated successfully."
    			    );

    			    response.sendRedirect(
    			        "ViewFarmerServlet?farmerCode=" + farmerCode
    			    );

    			    return;
    		}
    		else
    		{
    			session.setAttribute(
    		            "errorMsg",
    		            "Unable to update farmer details."
    		        );

    		        response.sendRedirect(
    		            "ViewFarmerServlet?farmerCode=" + farmerCode
    		        );
    		        
    		        return;
    		}
    		
    		
    	}
    	catch(Exception e)
    	{
    		e.printStackTrace();
	        session.setAttribute("errorMsg", e.getMessage());
    	}
    	finally
    	{
    		if(dao != null)
    		{
    			((FarmerDaoImpl) dao).cleanUp();
       		}
    	}
    	
	}
}


