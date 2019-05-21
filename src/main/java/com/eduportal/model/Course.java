package com.eduportal.model;

import com.eduportal.auth.model.Role;
import com.eduportal.auth.model.User;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "curso")
public class Course {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    private String description;

    @OneToOne(cascade = CascadeType.ALL)
    private Role neededRole;

    @OneToMany
    private Set<User> authorities = new HashSet<>();

    @OneToMany
    private Set<User> enrolled = new HashSet<>();

    @OneToMany(cascade = CascadeType.ALL)
    private Set<Node> nodes = new HashSet<>();

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Set<User> getAuthorities() {
        return authorities;
    }

    public void setAuthorities(Set<User> authorities) {
        this.authorities = authorities;
    }

    public Set<User> getEnrolled() {
        return enrolled;
    }

    public void setEnrolled(Set<User> enrolled) {
        this.enrolled = enrolled;
    }

    public Set<Node> getNodes() {
        return nodes;
    }

    public void setNodes(Set<Node> nodes) {
        this.nodes = nodes;
    }

    public Role getNeededRole() {
        return neededRole;
    }

    public void setNeededRole(Role neededRole) {
        this.neededRole = neededRole;
    }
}
