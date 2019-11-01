package com.eduportal.service;

import com.eduportal.auth.model.User;

public interface MailService {
    void sendInvitation(String host, User user);
}
