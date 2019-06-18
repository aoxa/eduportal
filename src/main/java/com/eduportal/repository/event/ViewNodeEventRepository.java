package com.eduportal.repository.event;

import com.eduportal.auth.model.User;
import com.eduportal.model.Node;
import com.eduportal.model.event.ViewNodeEvent;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ViewNodeEventRepository extends JpaRepository<ViewNodeEvent, Long> {
    Optional<ViewNodeEvent> findFirstByUserAndNode(User user, Node node);
}

