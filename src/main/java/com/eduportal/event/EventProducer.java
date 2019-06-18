package com.eduportal.event;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Component;


@Component
public class EventProducer {
    @Autowired
    private ApplicationEventPublisher applicationEventPublisher;

    public void publish(Event event) {
        applicationEventPublisher.publishEvent(event);
    }


}
