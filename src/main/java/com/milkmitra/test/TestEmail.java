package com.milkmitra.test;

import com.milkmitra.utils.EmailUtil;

public class TestEmail
{
    public static void main(String[] args)
    {
        try
        {
            EmailUtil.sendEmail(
                    "rahulghosh.med.2004@gmail.com",
                    "MilkMitra Test",
                    "Email Sending Working Successfully"
            );
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
    }
}