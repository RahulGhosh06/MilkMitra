package com.milkmitra.utils;

import java.util.Properties;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailUtil {

    // Read from environment variables
    private static final String FROM_EMAIL    = System.getenv("MAIL_EMAIL")    != null
                                                ? System.getenv("MAIL_EMAIL")
                                                : "rahulghosh.med.2004@gmail.com"; // fallback for local

    private static final String APP_PASSWORD  = System.getenv("MAIL_PASSWORD") != null
                                                ? System.getenv("MAIL_PASSWORD")
                                                : "nwqkheoorzlxbtsh";                              // fallback for local

    public static void sendEmail(
            String toEmail,
            String subject,
            String messageText)
            throws Exception {

    	Properties props = new Properties();
    	props.put("mail.smtp.host", "smtp.gmail.com");
    	props.put("mail.smtp.port", "465");
    	props.put("mail.smtp.auth", "true");
    	props.put("mail.smtp.socketFactory.port", "465");
    	props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
    	props.put("mail.smtp.socketFactory.fallback", "false");

        Session session = Session.getInstance(
                props,
                new Authenticator() {
                    @Override
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(
                                FROM_EMAIL,
                                APP_PASSWORD
                        );
                    }
                });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(FROM_EMAIL));
        message.setRecipients(
                Message.RecipientType.TO,
                InternetAddress.parse(toEmail)
        );
        message.setSubject(subject);
        message.setText(messageText);

        Transport.send(message);
        System.out.println("Email Sent Successfully");
    }
}