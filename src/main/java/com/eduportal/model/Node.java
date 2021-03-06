package com.eduportal.model;

import com.eduportal.model.base.BaseEntity;

import javax.persistence.*;
import java.util.Date;
import java.util.Set;

@Entity
@Table(name = "nodo")
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name = "type")
public class Node<T extends NodeReply> extends BaseEntity {
    @Column(updatable = false, insertable = false)
    private String type;

    @ManyToOne(cascade = CascadeType.ALL)
    private Course course;

    private String title;

    @Lob
    @Column(columnDefinition = "text")
    private String body;

    private String description;

    private Date limitDate;

    @OneToMany(mappedBy = "parent", targetEntity = NodeReply.class)
    private Set<T> children;

    public Course getCourse() {
        return course;
    }

    public void setCourse(Course course) {
        this.course = course;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getBody() {
        return body;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Date getLimitDate() {
        return limitDate;
    }

    public void setLimitDate(Date limitDate) {
        this.limitDate = limitDate;
    }

    public Set<T> getChildren() {
        return children;
    }

    public void setChildren(Set<T> children) {
        this.children = children;
    }
}
