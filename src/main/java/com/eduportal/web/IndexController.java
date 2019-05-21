package com.eduportal.web;

import com.eduportal.auth.model.User;
import com.eduportal.auth.service.SecurityService;
import com.eduportal.repository.CourseRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class IndexController {
    @Autowired
    private CourseRepository courseRepository;
    @Autowired
    private SecurityService securityService;

    @GetMapping({"/", "/welcome"})
    public String welcome(Model model) {
        User user = securityService.findLoggedInUser();

        model.addAttribute("courses", courseRepository.findAll());
        return "welcome";
    }
}
