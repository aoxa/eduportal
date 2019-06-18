package com.eduportal.aspect;

import com.eduportal.annotation.ViewEvent;
import com.eduportal.auth.model.User;
import com.eduportal.auth.service.SecurityService;
import com.eduportal.event.Event;
import com.eduportal.event.EventBuilder;
import com.eduportal.event.EventProducer;
import com.eduportal.model.Node;
import com.eduportal.model.event.ViewNodeEvent;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.lang.reflect.Method;

@Aspect
@Component
public class ViewAspect {
    @Autowired
    private EventProducer eventProducer;
    @Autowired
    private SecurityService securityService;

    @After("@annotation(com.eduportal.annotation.ViewEvent) ")
    public void publishViewEvent(JoinPoint joinPoint) throws InstantiationException, IllegalAccessException {
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        Method method = signature.getMethod();
        User user = securityService.findLoggedInUser();
        ViewEvent viewEvent = method.getAnnotation(ViewEvent.class);
        Event event = null;
        switch (viewEvent.pluggedTo()) {
            case NODE:
            default:
                EventBuilder builder = EventBuilder.builder(ViewNodeEvent.class)
                        .node(retrieveNode(joinPoint.getArgs())).user(user);
                eventProducer.publish(builder.build());
        }
    }

    private Node retrieveNode(Object[] args) {
        for(Object arg : args) {
            if(arg instanceof Node) {
                return (Node) arg;
            }
        }
        return null;
    }

}
