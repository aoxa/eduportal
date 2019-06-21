package com.eduportal.web.view;

import com.eduportal.auth.model.Role;
import com.eduportal.auth.model.User;
import com.eduportal.auth.service.SecurityService;
import com.eduportal.model.Course;
import com.eduportal.repository.CourseRepository;
import com.eduportal.repository.NodeRepository;
import com.eduportal.service.node.NodeTypeService;
import com.eduportal.web.view.form.AddCourseForm;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Controller
@RequestMapping("/course")
public class CourseController {
    @Autowired
    private CourseRepository courseRepository;

    @Autowired
    private SecurityService securityService;

    @Autowired
    private NodeTypeService nodeTypeService;

    @Autowired
    private NodeRepository nodeRepository;

    @GetMapping("/add")
    public String displayAdd(Model model) {
        return "new-course";
    }

    @PostMapping("/add")
    public String performAdd(Model model, AddCourseForm form) {
        Course c = new Course();
        c.setDescription(form.getDesc());
        c.setName(form.getName());

        Role role = new Role();
        role.setName(form.getName().toLowerCase().replace(" ", "_"));
        role.setType(Role.Type.course);
        c.setNeededRole(role);

        courseRepository.save(c);

        return "redirect:/course/"+c.getId();
    }

    @GetMapping("{course}")
    public String viewCourse(Model model, @PathVariable Course course) {
        //TODO validate user has role to be here
        User user = securityService.findLoggedInUser();
        model.addAttribute("isAuthority", course.getAuthorities().contains(user));
        model.addAttribute("course", course);
        model.addAttribute("nodes", nodeRepository.findAllByCourse(course));
        model.addAttribute("nodeTypes", nodeTypeService.getNodeTypes());

        return "course/view";
    }

    @PostMapping("/{course}/authority/add")
    public String addAuthority(Model model, @PathVariable Course course, @RequestParam("user")User user) {
        model.addAttribute("course", course);

        Set<User> authorities = course.getAuthorities();
        authorities = null == authorities?new HashSet<>() : authorities;
        authorities.add(user);

        courseRepository.save(course);

        return "redirect:/course/"+course.getId();
    }

    @PostMapping("/{course}/enroll")
    public String enroll(@PathVariable Course course, HttpServletResponse response) {
        final User user = securityService.findLoggedInUser();
        course.getEnrolled().add(user);

        courseRepository.save(course);

        return "redirect:/course/"+course.getId();
    }
}
