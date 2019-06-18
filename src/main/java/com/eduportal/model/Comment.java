package com.eduportal.model;

import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;

@Entity
@DiscriminatorValue(Article.TYPE)
public class Comment extends NodeReply<Article> {
    @Column(columnDefinition = "TEXT")
    private String body;

    public String getBody() {
        return body;
    }

    public void setBody(String body) {
        this.body = body;
    }
}
