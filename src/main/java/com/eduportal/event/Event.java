package com.eduportal.event;

import com.eduportal.auth.model.User;
import com.eduportal.model.base.BaseEntity;

import javax.persistence.*;

@Entity
@Table(name = "eventos")
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name = "type")
public abstract class Event extends BaseEntity {
    @ManyToOne
    private User user;

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}
