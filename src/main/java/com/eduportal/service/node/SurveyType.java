package com.eduportal.service.node;

import com.eduportal.auth.model.Role;
import com.eduportal.auth.repository.RoleRepository;
import com.eduportal.model.Survey;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;

@Component
public class SurveyType implements NodeType {
    private Role editRole;

    @Autowired
    private MessageSource messageSource;

    @Autowired
    private NodeTypeService nodeTypeService;

    @Autowired
    private RoleRepository roleRepository;

    @PostConstruct
    public void init() {
        nodeTypeService.register(this);
        editRole = roleRepository.findByName(getRoleName());
        if(null == editRole) {
            editRole = new Role();
            editRole.setName(getRoleName());
            editRole.setType(Role.Type.node);

            roleRepository.save(editRole);
        }

    }

    private String getRoleName() {
        return "edit_" + getType();
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
}
