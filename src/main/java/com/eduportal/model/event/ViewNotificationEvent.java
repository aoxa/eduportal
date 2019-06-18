package com.eduportal.model.event;

import com.eduportal.event.Event;

import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;

@Entity
@DiscriminatorValue("view-notification")
public class ViewNotificationEvent extends Event {
}
