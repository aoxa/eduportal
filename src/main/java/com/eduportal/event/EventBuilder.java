package com.eduportal.event;

import com.eduportal.auth.model.User;
import com.eduportal.model.Node;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public final class EventBuilder {
    private Event event;

    private EventBuilder(){}

    public static EventBuilder builder(Class<? extends Event> clazz) throws IllegalAccessException, InstantiationException {
        EventBuilder builder = new EventBuilder();
        builder.event = clazz.newInstance();
        return builder;
    }

    public EventBuilder user(User user) {
        this.event.setUser(user);
        return this;
    }

    public EventBuilder node(Node node) {
        Method method = null;
        try {
            method = event.getClass().getMethod("setNode", Node.class);
            method.invoke(event, node);
        } catch (NoSuchMethodException | IllegalAccessException | InvocationTargetException e) {
            ;
        }
        return this;
    }

    public Event build() {
        return event;
    }
}
