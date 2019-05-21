package com.eduportal.model.partial;

import javax.persistence.Entity;

@Entity
public class InputText extends Element{
    private String value;

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }
}
