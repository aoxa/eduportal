package com.eduportal.model;

import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.Lob;

@Entity
@DiscriminatorValue(Article.TYPE)
public class Comment extends NodeReply<Article> {
    @Lob
    private String body;

    public String getBody() {
        return body;
    }

    public void setBody(String body) {
        this.body = body;
    }
}
