package com.eduportal.model.notifications;

import com.eduportal.auth.model.User;
import com.eduportal.model.base.BaseEntity;

import javax.persistence.*;

@Entity
@Table(name = "notification")
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name = "type")
public abstract class BaseNotification extends BaseEntity {
    @OneToOne
    private User user;
    private String message;
    private Boolean seen = Boolean.FALSE;

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Boolean getSeen() {
        return seen;
    }

    public void setSeen(Boolean seen) {
        this.seen = seen;
    }
}
