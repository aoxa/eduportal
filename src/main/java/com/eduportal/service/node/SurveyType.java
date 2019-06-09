package com.eduportal.service.node;

import com.eduportal.auth.model.Role;
import com.eduportal.auth.repository.RoleRepository;
import com.eduportal.model.Survey;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.util.Arrays;

@Component
public class SurveyType implements NodeType {
    private Role editRole;
    private Role answerRole;

    @Autowired
    private MessageSource messageSource;

    @Autowired
    private NodeTypeService nodeTypeService;

    @Autowired
    private RoleRepository roleRepository;

    @PostConstruct
    public void init() {
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

    private Role buildRole(String roleName) {
        Role role = new Role();
        role.setName(roleName);
        role.setType(Role.Type.node);

        roleRepository.save(role);

        return role;
    }

    private String getEditRoleName() {
        return "edit_" + getType();
    }

    private String getAnswerRoleName() {
        return "answer_" + getType();
    }

    @Override
    public Class<Survey> nodeClass() {
        return Survey.class;
    }

    @Override
    public String getType() {
        return Survey.TYPE;
    }

    @Override
    public String getName() {
        return messageSource.getMessage(String.format("node.type.%s.name", Survey.TYPE), null, null);
    }

    @Override
    public Role getEditRole() {
        return editRole;
    }

    @Override
    public Role getAnswerRole() {
        return editRole;
    }
}
