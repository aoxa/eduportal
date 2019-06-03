package com.eduportal.web.admin.form;

import java.util.List;

public class GroupAddForm {
    private String name;
    private List<Long> roles;

    public void setRoles(List<Long> roles) {
        this.roles = roles;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public List<Long> getRoles() {
        return roles;
    }

}
