package com.eduportal.repository.event;

import com.eduportal.auth.model.User;
import com.eduportal.event.Event;
import com.eduportal.model.Node;
import com.eduportal.model.event.ViewNodeEvent;
import org.springframework.data.domain.Example;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface EventRepository  extends JpaRepository<Event, Long> {
    List<Event> findAllByUser(User user);
}
