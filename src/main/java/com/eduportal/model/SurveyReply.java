package com.eduportal.model;

import com.eduportal.model.partial.Element;

import javax.persistence.CascadeType;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.OneToMany;
import java.util.HashSet;
import java.util.Set;

@Entity
@DiscriminatorValue(Survey.TYPE)
public class SurveyReply extends NodeReply<Survey> {

    @OneToMany(cascade = CascadeType.ALL)
    private Set<Element> elements = new HashSet<>();

    public Set<Element> getElements() {
        return elements;
    }

    public void setElements(Set<Element> elements) {
        this.elements = elements;
    }

}
