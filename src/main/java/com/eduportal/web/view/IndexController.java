package com.eduportal.web.view;

import com.eduportal.auth.model.Role;
import com.eduportal.auth.model.User;
import com.eduportal.auth.service.SecurityService;
import com.eduportal.model.Course;
import com.eduportal.repository.CourseRepository;
import com.eduportal.repository.NotificationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Controller
public class IndexController {
    @Autowired
    private CourseRepository courseRepository;
    @Autowired
    private SecurityService securityService;
    @Autowired
    private NotificationRepository notificationRepository;

    @GetMapping({"/", "/welcome"})
    public String welcome(Model model) {
        User user = securityService.findLoggedInUser();

        Set<Role> roles = user.getAllRoles();
        if(!roles.isEmpty()) {
            Optional<List<Course>> userCourses = courseRepository.findAllForUserRoles(roles);

            model.addAttribute("courses", userCourses.orElse(Collections.emptyList()));
        }
        return "welcome";
    }

    @GetMapping("/notification/count.json")
    public @ResponseBody
    Integer getTeacherList() {
        User user = securityService.findLoggedInUser();

        return notificationRepository.countAllByUserAndSeenFalse(user);
    }
}
