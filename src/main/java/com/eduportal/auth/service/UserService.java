package com.eduportal.auth.service;

import com.eduportal.auth.model.User;

public interface UserService {
    void save(User user);

    User findByUsername(String username);
    User findByEmail(String email);
}
