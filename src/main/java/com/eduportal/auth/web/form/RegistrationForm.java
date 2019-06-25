package com.eduportal.auth.web.form;

import com.eduportal.auth.model.User;

import javax.validation.constraints.Email;
import javax.validation.constraints.Min;

public class RegistrationForm {
    private User user;
    @Email
    private String childEmail;
    private String childName;

    public String getChildName() {
        return childName;
    }

    public void setChildName(String childName) {
        this.childName = childName;
    }

    public String getChildEmail() {
        return childEmail;
    }

    public void setChildEmail(String childEmail) {
        this.childEmail = childEmail;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}
