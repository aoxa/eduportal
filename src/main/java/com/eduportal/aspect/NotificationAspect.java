package com.eduportal.aspect;

import com.eduportal.auth.model.Role;
import com.eduportal.auth.model.User;
import com.eduportal.auth.repository.UserRepository;
import com.eduportal.model.Node;
import com.eduportal.model.notifications.NodeNotification;
import com.eduportal.repository.NotificationRepository;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

@Aspect
@Component
public class NotificationAspect {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private NotificationRepository notificationRepository;

    @After("execution(* com.eduportal.service.node.NodeService.saveOrUpdate(..))")
    public void handleNotification(JoinPoint joinPoint) {
        Node node = fetchNode(joinPoint.getArgs());
        Role role = node.getCourse().getNeededRole();
        List<User> users = userRepository.findAllByRoles(role);

        for (User user : users) {
            NodeNotification notification = new NodeNotification();
            notification.setNode(node);
            notification.setMessage("Nueva asignatura " + node.getTitle() + " en " + node.getCourse().getName());
            notification.setUser(user);

            notificationRepository.save(notification);
        }

    }

    private Node fetchNode(Object...args) {
        for(Object arg : args) {
            if(arg instanceof Node) {
                return (Node) arg;
            }
        }
        return null;
    }
}
