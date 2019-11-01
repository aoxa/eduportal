package com.eduportal.web.view;

import com.eduportal.auth.model.User;
import com.eduportal.auth.service.SecurityService;
import com.eduportal.model.notifications.BaseNotification;
import com.eduportal.repository.NotificationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/notifications")
public class NotificationController {
    @Autowired
    private NotificationRepository notificationRepository;
    @Autowired
    private SecurityService securityService;

    @GetMapping("/latest")
    public String getLatest(Model model) {
        User user = securityService.findLoggedInUser();

        List<BaseNotification> notifications = notificationRepository.getAllByUserAndSeenFalse(user, PageRequest.of(0, 5));
        notifications.forEach(not->{not.setSeen(true);notificationRepository.save(not);});
        model.addAttribute("notifications", notifications);

        return "notifications/newest";
    }

    @GetMapping("/all")
    public String getAll(Model model) {
        User user = securityService.findLoggedInUser();

        List<BaseNotification> notifications = notificationRepository.getAllByUser(user, PageRequest.of(0, 5));
        model.addAttribute("notifications", notifications);

        return "notifications/index";
    }
}
