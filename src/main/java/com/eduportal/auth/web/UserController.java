package com.eduportal.auth.web;

import com.eduportal.auth.model.Registration;
import com.eduportal.auth.model.User;
import com.eduportal.auth.repository.GroupRepository;
import com.eduportal.auth.repository.RoleRepository;
import com.eduportal.auth.service.SecurityService;
import com.eduportal.auth.service.UserService;
import com.eduportal.auth.validator.RegistrationValidator;
import com.eduportal.auth.web.form.RegistrationForm;
import com.eduportal.service.MailService;
import com.eduportal.web.helper.RequestHelper;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
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
    private RegistrationValidator registrationValidator;
    @Autowired
    private MailService mailService;

    @GetMapping("/registration")
    public String registration(Model model, @RequestParam String message){
        String content = new String(Base64.getDecoder().decode(message.getBytes()));

        ObjectMapper objectMapper = new ObjectMapper();
        try {
            Registration registration = objectMapper.readValue(content, Registration.class);

            User user = userService.findById(registration.getUserId());

            if (null == user) {
                return "error";
            }

            RegistrationForm form = new RegistrationForm();

            decorate(user, registration);

            form.setUser(user);

            boolean isParent = user.getAllRoles().stream().filter(r->r.getName().equals("parent")).count() != 0;

            model.addAttribute("isParent", isParent);

            model.addAttribute("form", form);

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
    public String registration(Model model, @ModelAttribute("form") RegistrationForm registrationForm,
                               BindingResult bindingResult, HttpServletRequest request) {
        registrationValidator.validate(registrationForm, bindingResult);

        User user = registrationForm.getUser();

        boolean isParent = user.getAllRoles().stream().filter(r->r.getName().equals("parent")).count() != 0;

        if(bindingResult.hasErrors()) {
            model.addAttribute("isParent", isParent);

            return "registration";
        }

        userService.save(user);

        if(isParent) {
            for(RegistrationForm.Child child : registrationForm.getChildren()) {
                User newUser = new User();
                newUser.setParent(user);

                newUser.setEmail(child.getEmail());
                newUser.setName(child.getName());
                newUser.setLastName(user.getLastName());
                newUser.getRoles().add(roleRepository.findByName("pupil"));
                newUser.getGroups().add(groupRepository.findByName("pupil"));
                userService.save(newUser);

                mailService.sendInvitation(RequestHelper.createURL(request, null), newUser);
            }
        }

        securityService.autoLogin(user.getUsername(), user.getPasswordConfirm());

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
