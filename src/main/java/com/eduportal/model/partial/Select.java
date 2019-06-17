package com.eduportal.model.partial;

import javax.persistence.*;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Entity
public class Select extends Element {
    @Column(columnDefinition = "BOOLEAN")
    private Boolean checkBox = Boolean.FALSE;
    @Column(columnDefinition = "BOOLEAN")
    private Boolean radioButton = Boolean.FALSE;
    @Column(columnDefinition = "BOOLEAN")
    private Boolean multivalued = Boolean.FALSE;

    @OneToMany(cascade = CascadeType.ALL)
    private Set<Option> options = new HashSet<>();

    public Set<Option> getOptions() {
        return options;
    }

    public void setOptions(Set<Option> options) {
        this.options = options;
    }

    public Boolean getCheckBox() {
        return checkBox;
    }

    public void setCheckBox(Boolean checkBox) {
        this.checkBox = checkBox;
    }

    public Boolean getRadioButton() {
        return radioButton;
    }

    public void setRadioButton(Boolean radioButton) {
        this.radioButton = radioButton;
    }

    public Boolean getMultivalued() {
        return multivalued;
    }

    public void setMultivalued(Boolean multivalued) {
        this.multivalued = multivalued;
    }
}
