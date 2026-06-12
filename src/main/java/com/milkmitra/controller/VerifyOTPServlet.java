package com.milkmitra.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.milkmitra.model.User;

@WebServlet("/VerifyOTP")
public class VerifyOTPServlet extends HttpServlet
{
	protected void doPost(HttpServletRequest request,
	        HttpServletResponse response)
	        throws ServletException, IOException
	{
	    String enteredOTP =
	            request.getParameter("otp");

	    HttpSession session =
	            request.getSession(false);

	    if(session == null)
	    {
	        response.sendRedirect("Login.jsp");
	        return;
	    }

	    String actualOTP =
	            (String) session.getAttribute("otp");

	    Long otpTime =
	            (Long) session.getAttribute("otpTime");

	    Integer attempts =
	            (Integer) session.getAttribute("otpAttempts");

	    if(attempts == null)
	    {
	        attempts = 0;
	    }

	    long currentTime =
	            System.currentTimeMillis();

	    if(otpTime == null ||
	    		   currentTime - otpTime > 300000)
	    		{
	    		    session.removeAttribute("otp");
	    		    session.removeAttribute("otpTime");
	    		    session.removeAttribute("tempUser");
	    		    session.removeAttribute("otpAttempts");

	    		    session.setAttribute(
	    		            "errorMsg",
	    		            "OTP Expired. Please login again."
	    		    );

	    		    response.sendRedirect("Login.jsp");

	    		    return;
	    		}

	    User user =
	            (User) session.getAttribute("tempUser");

	    if(actualOTP != null &&
	       actualOTP.equals(enteredOTP))
	    {
	        session.removeAttribute("otp");
	        session.removeAttribute("otpTime");
	        session.removeAttribute("tempUser");
	        session.removeAttribute("otpAttempts");
	        session.removeAttribute("otpLockedUntil");

	        session.setAttribute(
	                "userId",
	                user.getUserId());

	        session.setAttribute(
	                "username",
	                user.getUsername());

	        session.setAttribute(
	                "role",
	                user.getRoleName());

	        if("ADMIN".equals(user.getRoleName()))
	        {
	            response.sendRedirect(
	                    "AdminDashboard.jsp");
	        }
	        else if("FARMER".equals(user.getRoleName()))
	        {
	            response.sendRedirect(
	                    "farmer/dashboard.jsp");
	        }
	    }
	    else
	    {
	        attempts++;

	        session.setAttribute(
	                "otpAttempts",
	                attempts);

	        if(attempts >= 3)
	        {
	            session.setAttribute(
	                    "otpLockedUntil",
	                    System.currentTimeMillis() + 30000
	            );

	            session.removeAttribute("otp");
	            session.removeAttribute("otpTime");
	            session.removeAttribute("tempUser");
	            session.removeAttribute("otpAttempts");

	            session.setAttribute(
	                    "errorMsg",
	                    "Too many OTP failures. Try again after 5 minutes."
	            );

	            response.sendRedirect("Login.jsp");

	            return;
	        }

	        session.setAttribute(
	                "otpError",
	                "Invalid OTP. Attempts Left : "
	                + (3 - attempts));

	        response.sendRedirect(
	                "Otp.jsp");
	    }
	}
	
}