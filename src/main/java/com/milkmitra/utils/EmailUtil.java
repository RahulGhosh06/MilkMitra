package com.milkmitra.utils;

import com.sendgrid.*;
import com.sendgrid.helpers.mail.*;
import com.sendgrid.helpers.mail.objects.*;

public class EmailUtil {

    private static final String FROM_EMAIL   = System.getenv("MAIL_EMAIL") != null
                                               ? System.getenv("MAIL_EMAIL")
                                               : "rahulghosh.med.2004@gmail.com";

    private static final String SENDGRID_KEY = System.getenv("SENDGRID_API_KEY");

    public static void sendEmail(
            String toEmail,
            String subject,
            String messageText)
            throws Exception {

        Email from      = new Email(FROM_EMAIL);
        Email to        = new Email(toEmail);
        Content content = new Content("text/plain", messageText);
        Mail mail       = new Mail(from, subject, to, content);

        SendGrid sg     = new SendGrid(SENDGRID_KEY);
        Request request = new Request();

        request.setMethod(Method.POST);
        request.setEndpoint("mail/send");
        request.setBody(mail.build());

        Response response = sg.api(request);
        System.out.println("Email Status: " + response.getStatusCode());
    }
}