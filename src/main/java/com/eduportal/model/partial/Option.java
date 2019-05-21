package com.eduportal.model.partial;

import javax.persistence.Entity;

@Entity
public class Option extends Element {
    private String value;

    private Boolean selected;

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public Boolean getSelected() {
        return selected;
    }

    public void setSelected(Boolean selected) {
        this.selected= selected;
    }
}
