package com.eduportal.service;

import com.eduportal.auth.model.Registration;
import com.eduportal.model.Settings;
import com.eduportal.repository.SettingsRepository;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Base64;
import java.util.Date;
import java.util.Properties;

@Service
public class MailService {
    @Autowired
    private SettingsRepository settingsRepository;

    public void sendInvitation(String email) {
        final Settings<String> username = settingsRepository.findById("mail.user").get();
        final Settings<String> password = settingsRepository.findById("mail.pass").get();
        final Settings<String> smtp = settingsRepository.findById("mail.smtp").get();
        final Settings<String> port = settingsRepository.findById("mail.port").get();
        final Settings<Boolean> tls = settingsRepository.findById("mail.tls").get();


        Properties prop = new Properties();
        prop.put("mail.smtp.host", smtp.getValue());
        prop.put("mail.smtp.port", port.getValue());
        prop.put("mail.smtp.starttls.enable", tls.getValue());
        prop.put("mail.smtp.auth", "true");
        prop.put("mail.smtp.socketFactory.port", port.getValue());
        prop.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");

        Session session = Session.getInstance(
                prop, new javax.mail.Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(username.getValue(), password.getValue());
                    }
                }
        );

        try {
            Registration registration = new Registration();
            registration.getRoles().add("padre");
            registration.setEmail(email);
            registration.setExpireDate(new Date());

            ObjectMapper mapper = new ObjectMapper();
            String jsonString = "";
            try {
                jsonString = Base64.getEncoder()
                        .encodeToString(mapper.writeValueAsString(registration).getBytes());
            } catch (JsonProcessingException e) {
                e.printStackTrace();
            }

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress("from@gmail.com"));
            message.setRecipients(
                    Message.RecipientType.TO,
                    InternetAddress.parse(email)
            );
            message.setSubject("Testing Gmail SSL");
            message.setText("Dear Mail Crawler,"
                    + "\n\n http://localhost:8080/registration?message=" + jsonString);

            Transport.send(message);

        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}
