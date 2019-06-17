package com.eduportal.service.node;

import com.eduportal.auth.model.Role;
import com.eduportal.auth.repository.RoleRepository;
import com.eduportal.model.Node;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;

public abstract class NodeType {
    @Autowired
    protected MessageSource messageSource;

    @Autowired
    private NodeTypeService nodeTypeService;

    @Autowired
    private RoleRepository roleRepository;

    private Role editRole;
    private Role answerRole;

    public abstract Class<? extends Node> nodeClass();
    public abstract String getType();
    public abstract String getName();
    public abstract String getEditRoleName();
    public abstract String getAnswerRoleName();

    public final Role getEditRole() {
        return editRole;
    }

    public final Role getAnswerRole(){
        return answerRole;
    }


    protected void init() {
        nodeTypeService.register(this);

        editRole = roleRepository.findByName(getEditRoleName());
        if(null == editRole) {
            editRole = buildRole(getEditRoleName());
        }

        answerRole = roleRepository.findByName(getAnswerRoleName());
        if(null == answerRole) {
            answerRole = buildRole(getAnswerRoleName());
        }
    }

    protected final Role buildRole(String roleName) {
        Role role = new Role();
        role.setName(roleName);
        role.setType(Role.Type.node);

        roleRepository.save(role);

        return role;
    }
}
