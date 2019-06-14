package com.eduportal.web;

import com.eduportal.auth.model.User;
import com.eduportal.auth.repository.RoleRepository;
import com.eduportal.auth.repository.UserRepository;
import com.eduportal.auth.service.SecurityService;
import com.eduportal.model.Course;
import com.eduportal.repository.CourseRepository;
import com.eduportal.web.view.functions.HasAuthority;
import freemarker.core.Environment;
import freemarker.ext.beans.BeanModel;
import freemarker.template.*;
import freemarker.template.utility.DeepUnwrap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
public class IndexController {
    @Autowired
    private CourseRepository courseRepository;
    @Autowired
    private SecurityService securityService;
    @Autowired
    private HasAuthority hasAuthority;

    @GetMapping({"/", "/welcome"})
    public String welcome(Model model) {
        User user = securityService.findLoggedInUser();

        Optional<List<Course>> userCourses = courseRepository.findAllForUserRoles(user.getAllRoles());

        model.addAttribute("courses", userCourses.orElse(Collections.emptyList()));

        return "welcome";
    }
}
