package com.eduportal.web;

import com.eduportal.auth.model.Role;
import com.eduportal.auth.model.User;
import com.eduportal.model.Course;
import com.eduportal.repository.CourseRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Controller
@RequestMapping("/course")
public class CourseController {
    @Autowired
    private CourseRepository courseRepository;

    @Secured({"user"})
    @GetMapping("/add")
    public String displayAdd(Model model) {
        return "new-course";
    }

    @Secured({"user"})
    @PostMapping("/add")
    public String performAdd(Model model, AddCourseForm form) {
        Course c = new Course();
        c.setDescription(form.desc);
        c.setName(form.name);

        Role role = new Role();
        role.setName(form.getName().toLowerCase().replace(" ", "_"));
        c.setNeededRole(role);

        courseRepository.save(c);

        return "redirect:/course/"+c.getId();
    }

    @GetMapping("{course}")
    public String viewCourse(Model model, @PathVariable Course course) {
        //TODO validate user has role to be here
        model.addAttribute("course", course);

        return "course/view";
    }

    @PostMapping("/{course}/authority/add")
    public String addAuthority(Model model, @PathVariable Course course, @RequestParam("user")User user) {
        model.addAttribute("course", course);

        Set<User> authorities = course.getAuthorities();
        authorities = null == authorities?new HashSet<>() : authorities;
        authorities.add(user);

        courseRepository.save(course);

        return "course/view";
    }

    public class AddCourseForm {
        private String name;
        private String desc;

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getDesc() {
            return desc;
        }

        public void setDesc(String desc) {
            this.desc = desc;
        }
    }
}
