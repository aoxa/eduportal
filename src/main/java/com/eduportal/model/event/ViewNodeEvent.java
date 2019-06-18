package com.eduportal.model.event;

import com.eduportal.event.Event;
import com.eduportal.model.Node;

import javax.persistence.*;

@Entity
@DiscriminatorValue("view-node")
public class ViewNodeEvent extends Event {
    @OneToOne
    private Node node;

    public Node getNode() {
        return node;
    }

    public void setNode(Node node) {
        this.node = node;
    }
}
