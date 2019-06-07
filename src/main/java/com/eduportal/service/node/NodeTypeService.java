package com.eduportal.service.node;

import com.eduportal.model.Node;
import org.springframework.stereotype.Component;

import java.util.*;

@Component
public class NodeTypeService {
    private final Map<Class<? extends Node>, NodeType> nodeTypes = new HashMap<>();

    public Collection<NodeType> getNodeTypes() {
        return nodeTypes.values();
    }

    public void register(NodeType nodeType) {
        this.nodeTypes.put(nodeType.nodeClass(), nodeType);
    }

    public NodeType getNodeTypeService(Class<? extends Node> clazz) {
        return nodeTypes.get(clazz);
    }
}
