package com.eduportal.model;

import com.eduportal.model.partial.Element;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.OneToMany;
import javax.persistence.Transient;
import java.util.*;

@Entity
public class Survey extends Node {
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
}
