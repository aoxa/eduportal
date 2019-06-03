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
        model.addAttribute("userForm", new User());
        String content = new String(Base64.getDecoder().decode(message.getBytes()));

        ObjectMapper objectMapper = new ObjectMapper();
        try {
            Registration registration = objectMapper.readValue(content, Registration.class);
            if (null != userService.findByEmail(registration.getEmail())) {
                return "error";
            }

            User user = new User();
            user.setEmail(registration.getEmail());
            user.setUsername(registration.getEmail());
            for(String roleName : registration.getRoles()) {
                Role role = roleRepository.findByName(roleName);
                if(null != role) {
                    user.getRoles().add(role);
                }
            }
            for(String groupName : registration.getGroups()) {
                Group group = groupRepository.findByName(groupName);
                if(null != group) {
                    user.getGroups().add(group);
                }
            }
            user.setPassword("pass");

            userService.save(user);

        } catch (IOException e) {
            e.printStackTrace();
        }


        return "registration";
    }

    @PostMapping("/registration")
    public String registration(@ModelAttribute("userForm") User userForm, BindingResult bindingResult) {
        userValidator.validate(userForm, bindingResult);

        if(bindingResult.hasErrors()) {
            return "registration";
        }

        userService.save(userForm);

        securityService.autoLogin(userForm.getUsername(), userForm.getPassword());

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
