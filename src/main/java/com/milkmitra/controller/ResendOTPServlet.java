package com.milkmitra.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.milkmitra.model.User;
import com.milkmitra.utils.EmailUtil;
import com.milkmitra.utils.OTPUtil;

@WebServlet("/ResendOTP")
public class ResendOTPServlet extends HttpServlet
{
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException
    {
        try
        {
            HttpSession session =
                    request.getSession(false);

            if(session == null)
            {
                response.sendRedirect(
                        "Login.jsp");
                return;
            }

            User user =
                    (User) session.getAttribute(
                            "tempUser");

            String otp =
                    OTPUtil.generateOTP();

            EmailUtil.sendEmail(
                    user.getEmail(),
                    "MilkMitra Login OTP",
                    "Your OTP is : " + otp
            );

            session.setAttribute(
                    "otp",
                    otp);

            session.setAttribute(
                    "otpTime",
                    System.currentTimeMillis()
            );

            session.setAttribute(
                    "otpError",
                    "New OTP Sent Successfully"
            );

            response.sendRedirect(
                    "Otp.jsp");
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
    }
}