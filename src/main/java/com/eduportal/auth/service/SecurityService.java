package com.eduportal.auth.service;

import com.eduportal.auth.model.User;

public interface SecurityService {
    String findLoggedInUsername();
    void autoLogin(String username, String password);
    User findLoggedInUser();
}
