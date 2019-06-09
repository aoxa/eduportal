package com.eduportal.service.node;

import com.eduportal.auth.model.Role;
import com.eduportal.model.Node;

public interface NodeType {
    Class<? extends Node> nodeClass();
    String getType();
    String getName();
    Role getEditRole();
    Role getAnswerRole();
}
