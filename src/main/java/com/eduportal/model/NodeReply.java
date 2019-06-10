package com.eduportal.model;

import com.eduportal.auth.model.User;
import com.eduportal.model.base.BaseEntity;
import com.eduportal.model.partial.Element;
import com.eduportal.service.node.NodeType;

import javax.persistence.*;
import java.util.Set;

@Entity
@Table(name = "respuesta")
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name = "type")
public class NodeReply<T extends Node> extends BaseEntity {
    @OneToOne
    private User user;

    @ManyToOne(targetEntity = Node.class)
    private T parent;

    public User getUser() {
        return user;
    }

    @Column(updatable = false, insertable = false)
    private String type;

    public void setUser(User user) {
        this.user = user;
    }

    public T getParent() {
        return parent;
    }

    public void setParent(T parent) {
        this.parent = parent;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
}
