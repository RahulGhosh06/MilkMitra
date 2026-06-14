package com.milkmitra.controller;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.milkmitra.dao.IUserDao;
import com.milkmitra.dao.UserDaoImpl;
import com.milkmitra.model.User;
import com.milkmitra.utils.EmailUtil;
import com.milkmitra.utils.OTPUtil;

/**
 * Servlet implementation class LogoutSevlet
 */
@WebServlet("/Login")
public class LoginServlet extends HttpServlet
{
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		
	    	System.out.println("Login Servlet Called");
	    	response.setContentType("text/html");
	    	
	        String username = request.getParameter("username");
	        String password = request.getParameter("password");
	        
	        IUserDao dao = null;
	        
	        try
	        {
	              dao = new UserDaoImpl();

	            User user = dao.authenticate(username, password);
	            
//	            if(user != null)
//	            {
//	                System.out.println(user.getEmail());
//	            }
	            
	            
	            	
	            if(user != null)
	            {
	            	if("FARMER".equalsIgnoreCase(user.getRoleName()))
	            	{
	            	    HttpSession session =
	            	            request.getSession();

	            	    session.setAttribute(
	            	            "username",
	            	            user.getUsername());

	            	    session.setAttribute(
	            	            "farmerCode",
	            	            user.getFarmerCode());

	            	    session.setAttribute(
	            	            "role",
	            	            "FARMER");

	            	    response.sendRedirect(
	            	            "FarmerDashboardServlet");

	            	    return;
	            	}
	                HttpSession session =
	                        request.getSession();

	                Long lockedUntil =
	                        (Long) session.getAttribute(
	                                "otpLockedUntil"
	                        );

	                if(lockedUntil != null &&
	                   System.currentTimeMillis() < lockedUntil)
	                {
	                    session.setAttribute(
	                            "errorMsg",
	                            "Too many OTP failures. Try again after 5 minutes."
	                    );

	                    response.sendRedirect("Login.jsp");
	                    return;
	                }
	                
	                else if(lockedUntil != null)
	                {
	                    session.removeAttribute("otpLockedUntil");
	                }

	                String otp = OTPUtil.generateOTP();

	                	EmailUtil.sendEmail(
	                        user.getEmail(),
	                        "MilkMitra Login OTP",
                        "Your OTP is : " + otp
	                );
	                
	               // System.out.println("OTP = " + otp);

	                session.setAttribute("otp", otp);

	                session.setAttribute(
	                        "otpTime",
	                        System.currentTimeMillis()
	                );

	                session.setAttribute(
	                        "otpAttempts",
	                        0
	                );

	                session.setAttribute(
	                        "tempUser",
	                        user
	                );

	                response.sendRedirect("Otp.jsp");
	            }
	            else
	            {
	            	HttpSession session = request.getSession();
	            	session.setAttribute("errorMsg", "Invalid Username or Password");
	            	response.sendRedirect("Login.jsp");
	            }
	        }
		    catch(Exception e)
		    {
		        e.printStackTrace();
		    }
	        
		    finally // ← ALWAYS runs, success or failure
		    {
		        if(dao != null)
		        {
		            try
		            {
		               dao.cleanUp();
		            }
		                
		            catch(SQLException e) 
		            { 
		               e.printStackTrace(); 
		            }
		         }
		            
		     }
		
		}
}	
		
		


