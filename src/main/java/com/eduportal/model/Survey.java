package com.eduportal.model;

import com.eduportal.model.partial.Element;

import javax.persistence.*;
import java.util.*;

@Entity
@DiscriminatorValue(Survey.TYPE)
public class Survey extends Node {
    public final static String TYPE = "survey";

    @OneToMany(mappedBy = "parent")
    private Set<SurveyReply> replies;

    @OneToMany(cascade = CascadeType.ALL)
    private Set<Element> elements = new HashSet<>();

    @Transient
    public List<Element> getSortedElements() {
        List<Element> result = new ArrayList<>(this.elements);
        result.sort(Comparator.comparing(Element::getWeight));

        return result;
    }

    public Set<Element> getElements() {
        return elements;
    }

    public void setElements(Set<Element> elements) {
        this.elements = elements;
    }

    public Set<SurveyReply> getReplies() {
        return replies;
    }

    public void setReplies(Set<SurveyReply> replies) {
        this.replies = replies;
    }
}
