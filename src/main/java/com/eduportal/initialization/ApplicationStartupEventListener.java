package com.eduportal.initialization;

import com.eduportal.auth.model.BuiltinRoles;
import com.eduportal.auth.model.Group;
import com.eduportal.auth.model.Role;
import com.eduportal.auth.model.User;
import com.eduportal.auth.repository.GroupRepository;
import com.eduportal.auth.repository.RoleRepository;
import com.eduportal.auth.repository.UserRepository;
import com.eduportal.service.node.NodeType;
import com.eduportal.service.node.NodeTypeService;
import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.Set;

@Transactional
@Component
public class ApplicationStartupEventListener {
    @Autowired
    private GroupRepository groupRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private NodeTypeService nodeTypeService;

    private final String[] builtins = {BuiltinRoles.admin.toString(), BuiltinRoles.parent.toString(),
            BuiltinRoles.teacher.toString(), BuiltinRoles.pupil.toString()};

    @EventListener
    public void onApplicationEvent(ContextRefreshedEvent event) {
        for(String name : builtins) {
            Group group = groupRepository.findByName(name);
            if(group == null) {
                group = new Group();
                group.setName(name);
            }

            Hibernate.initialize(group);

            decorateRoles(name, group.getRoles());

            groupRepository.save(group);
        }

        User user = userRepository.findByUsername("siteadmin");

        if(null != user) {
            user.getGroups().add(groupRepository.findByName(BuiltinRoles.admin.toString()));
            userRepository.save(user);
        }
    }

    private void decorateRoles(String name, Set<Role> roles) {
        switch (name) {
            case "teacher":
                for(NodeType nodeType : nodeTypeService.getNodeTypes() ) {
                    roles.add(nodeType.getEditRole());
                }
                roles.add(roleRepository.findByName(name));
                break;
            case "pupil":
                for(NodeType nodeType : nodeTypeService.getNodeTypes() ) {
                    roles.add(nodeType.getAnswerRole());
                }
                roles.add(roleRepository.findByName(name));
                break;
            case "parent":
                roles.add(roleRepository.findByName(name));
                break;
        }
    }
}

