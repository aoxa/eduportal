package com.eduportal.repository;

import com.eduportal.auth.model.User;
import com.eduportal.model.notifications.BaseNotification;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface NotificationRepository extends JpaRepository<BaseNotification, Long> {
    List<BaseNotification> getAllByUserAndSeenFalse(User user);

    Integer countAllByUserAndSeenFalse(User user);
}
