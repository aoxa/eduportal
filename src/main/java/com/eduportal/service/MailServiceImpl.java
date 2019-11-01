package com.eduportal.service;

import com.eduportal.auth.model.Group;
import com.eduportal.auth.model.Registration;
import com.eduportal.auth.model.Role;
import com.eduportal.auth.model.User;
import com.eduportal.model.Setting;
import com.eduportal.repository.SettingRepository;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.simplejavamail.email.EmailBuilder;
import org.simplejavamail.mailer.Mailer;
import org.simplejavamail.mailer.MailerBuilder;
import org.simplejavamail.mailer.config.TransportStrategy;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import javax.mail.*;
import java.util.Base64;
import java.util.Date;
import java.util.Properties;

@Slf4j
@Service
public class MailServiceImpl implements MailService {
    @Autowired
    private SettingRepository settingRepository;

    Mailer mailer;

    @PostConstruct
    private void init() {
        if (!settingRepository.findById("mail.smtp").isPresent())
            return;
        final Setting<String> smtp = settingRepository.findById("mail.smtp").get();
        final Setting<String> port = settingRepository.findById("mail.port").get();
        final Setting<Boolean> tls = settingRepository.findById("mail.tls").get();
        final Setting<String> username = settingRepository.findById("mail.user").get();
        final Setting<String> password = settingRepository.findById("mail.pass").get();

        mailer = MailerBuilder
                .withSMTPServer(smtp.getValue(), Integer.parseInt(port.getValue()), username.getValue(), password.getValue())
                .withTransportStrategy(tls.getValue() ? TransportStrategy.SMTP_TLS : TransportStrategy.SMTPS)
                .withSessionTimeout(10 * 1000)
                .clearEmailAddressCriteria() // turns off email validation
                .withProperty("mail.smtp.sendpartial", "true")
                .withDebugLogging(true)
                .buildMailer();

    }

    public void sendInvitation(String host, User user) {
        if(mailer == null ) init();
        if(mailer == null) return;

        log.info("Sending invitation to user {}", user.getEmail());
        Registration registration = new Registration();
        user.getRoles().stream().map(Role::getName).forEach(role -> registration.getRoles().add(role));
        user.getGroups().stream().map(Group::getName).forEach(group -> registration.getGroups().add(group));

        registration.setUserId(user.getId());

        registration.setExpireDate(new Date());

        ObjectMapper mapper = new ObjectMapper();
        String jsonString = "";
        try {
            jsonString = Base64.getEncoder()
                    .encodeToString(mapper.writeValueAsBytes(registration));
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }

        org.simplejavamail.email.Email email = EmailBuilder.startingBlank().to(user.getEmail())
                .withHTMLText("Usted fue invitado a participar,"
                        + "\n\n por favor siga el <a href='" + host + "/registration?message=" + jsonString + "'>link</a> para registrarse")
                .from("no_reply@eduportal.com")
                .withSubject("Invitacion a participar")
                .buildEmail();

        mailer.sendMail(email);
    }

    private Session buildSession() {
        final Setting<String> username = settingRepository.findById("mail.user").get();
        final Setting<String> password = settingRepository.findById("mail.pass").get();

        Properties prop = buildProperties();

        return Session.getInstance(
                prop, new Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(username.getValue(), password.getValue());
                    }
                }
        );
    }

    private Properties buildProperties() {
        final Setting<String> smtp = settingRepository.findById("mail.smtp").get();
        final Setting<String> port = settingRepository.findById("mail.port").get();
        final Setting<Boolean> tls = settingRepository.findById("mail.tls").get();

        Properties prop = new Properties();
        prop.put("mail.smtp.host", smtp.getValue());
        prop.put("mail.smtp.port", port.getValue());
        prop.put("mail.smtp.starttls.enable", tls.getValue());
        prop.put("mail.smtp.auth", "true");
        prop.put("mail.smtp.socketFactory.port", port.getValue());
        prop.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        return prop;
    }
}
