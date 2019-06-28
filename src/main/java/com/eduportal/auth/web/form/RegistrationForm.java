package com.eduportal.auth.web.form;

import com.eduportal.auth.model.User;

import javax.validation.constraints.Email;
import javax.validation.constraints.Min;
import java.util.ArrayList;
import java.util.List;

public class RegistrationForm {
    private User user;

    private List<Child> children = new ArrayList<>();

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public List<Child> getChildren() {
        return children;
    }

    public void setChildren(List<Child> children) {
        this.children = children;
    }

    public static class Child {
        @Email
        private String email;
        private String name;

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }

    }
}
