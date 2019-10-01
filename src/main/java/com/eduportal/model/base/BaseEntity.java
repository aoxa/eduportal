package com.eduportal.model.base;

import javax.persistence.*;
import java.util.Date;


@MappedSuperclass
public abstract class BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Date creationDate;

    private Date modificationDate;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Date getCreationDate() {
        return creationDate;
    }

    public void setCreationDate(Date creationDate) {
        this.creationDate = creationDate;
    }

    public Date getModificationDate() {
        return modificationDate;
    }

    public void setModificationDate(Date modificationDate) {
        this.modificationDate = modificationDate;
    }

    @PrePersist
    public void prePersist() {
        this.creationDate = new Date();
        this.modificationDate = new Date();
    }

    @PreUpdate
    public void preUpdate() {
        this.modificationDate = new Date();
    }
}
