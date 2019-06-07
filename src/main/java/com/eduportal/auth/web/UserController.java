package com.eduportal.auth.web;

import com.eduportal.auth.model.Group;
import com.eduportal.auth.model.Registration;
import com.eduportal.auth.model.Role;
import com.eduportal.auth.model.User;
import com.eduportal.auth.repository.GroupRepository;
import com.eduportal.auth.repository.RoleRepository;
import com.eduportal.auth.service.SecurityService;
import com.eduportal.auth.service.UserService;
import com.eduportal.auth.validator.UserValidator;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.IOException;
import java.util.Base64;

@Controller
public class UserController {
    @Autowired
    private RoleRepository roleRepository;
    @Autowired
    private GroupRepository groupRepository;
    @Autowired
    private UserService userService;
    @Autowired
    private SecurityService securityService;
    @Autowired
    private UserValidator userValidator;

    @GetMapping("/registration")
    public String registration(Model model, @RequestParam String message){
        String content = new String(Base64.getDecoder().decode(message.getBytes()));

        ObjectMapper objectMapper = new ObjectMapper();
        try {
            Registration registration = objectMapper.readValue(content, Registration.class);
            if (null == userService.findById(registration.getUserId())) {
                return "error";
            }

            User user = userService.findById(registration.getUserId());

            decorate(user, registration);

            model.addAttribute("userForm", user);

        } catch (IOException e) {
            e.printStackTrace();
        }

        return "registration";
    }

    private void decorate(User user, Registration registration) {
        registration.getGroups().stream().map(group->groupRepository.findByName(group))
                .forEach(group->user.getGroups().add(group));
        registration.getRoles().stream().map(role->roleRepository.findByName(role))
                .forEach(role->user.getRoles().add(role));
    }

    @PostMapping("/registration")
    public String registration(@ModelAttribute("userForm") User userForm, BindingResult bindingResult) {
        userValidator.validate(userForm, bindingResult);

        if(bindingResult.hasErrors()) {
            return "registration";
        }

        userService.save(userForm);

        securityService.autoLogin(userForm.getUsername(), userForm.getPasswordConfirm());

        return "redirect:/welcome";
    }

    @GetMapping("/login")
    public String login(Model model, String error, String logout) {
        if (error != null)
            model.addAttribute("error", "Your username and password is invalid.");

        if (logout != null)
            model.addAttribute("message", "You have been logged out successfully.");

        return "login";
    }
}
