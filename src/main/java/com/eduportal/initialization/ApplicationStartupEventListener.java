package com.eduportal.initialization;

import com.eduportal.auth.model.Group;
import com.eduportal.auth.model.User;
import com.eduportal.auth.repository.GroupRepository;
import com.eduportal.auth.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

@Component
public class ApplicationStartupEventListener {
    @Autowired
    private GroupRepository groupRepository;

    @Autowired
    private UserRepository userRepository;

    private final String[] builtins = {"admin", "parent", "teacher", "pupil"};

    @EventListener
    public void onApplicationEvent(ContextRefreshedEvent event) {
        for(String name : builtins) {
            if(groupRepository.findByName(name) == null) {
                Group g = new Group();
                g.setName(name);
                groupRepository.save(g);
            }
        }

        User user = userRepository.findByUsername("siteadmin");

        if(null != user) {
            user.getGroups().add(groupRepository.findByName("admin"));
            userRepository.save(user);
        }
    }
}
