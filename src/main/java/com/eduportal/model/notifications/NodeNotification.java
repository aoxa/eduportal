package com.eduportal.model.notifications;

import com.eduportal.model.Node;

import javax.persistence.*;

@Entity
@DiscriminatorValue("node")
//@Table(indexes = {@Index(columnList = "node", name = "notification_node_hidx")})
public class NodeNotification extends BaseNotification {
    @ManyToOne(cascade = CascadeType.ALL)
    private Node node;

    public Node getNode() {
        return node;
    }

    public void setNode(Node node) {
        this.node = node;
    }
}
