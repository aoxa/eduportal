package com.eduportal.model;

import javax.persistence.*;
import java.io.Serializable;

@Entity
public class Settings<T extends Serializable> {

    @Id
    @Column(unique = true)
    private String name;

    @Lob
    private Serializable value;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public T getValue() {
        return (T) value;
    }

    public void setValue(Serializable value) {
        this.value = value;
    }

}
