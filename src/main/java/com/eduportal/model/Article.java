package com.eduportal.model;

import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;

@Entity
@DiscriminatorValue(Article.TYPE)
public class Article extends Node {
    public static final String TYPE = "article";

}
