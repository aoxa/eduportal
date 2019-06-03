package com.eduportal.web.admin;

import com.eduportal.auth.model.Group;
import com.eduportal.auth.model.Role;
import com.eduportal.auth.repository.GroupRepository;
import com.eduportal.auth.repository.RoleRepository;
import com.eduportal.auth.repository.UserRepository;
import com.eduportal.model.Settings;
import com.eduportal.repository.SettingsRepository;
import com.eduportal.service.MailService;
import com.eduportal.web.admin.form.GroupAddForm;
import com.eduportal.web.admin.form.MailConfigForm;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Controller
@Secured("ROLE_admin")
@RequestMapping("/admin")
public class DashboardController {
    @Autowired
    private GroupRepository groupRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private SettingsRepository settingsRepository;

    @Autowired
    private MailService mailService;

    @GetMapping("/dashboard")
    public String display(Model model) {
        return "admin/dashboard";
    }

    @PostMapping("/dashboard")
    public String save(Model model, MailConfigForm mail) {
        Settings<String> property = new Settings<>();
        property.setName("mail.smtp");
        property.setValue(mail.getSmtp());

        settingsRepository.save(property);

        property = new Settings<>();
        property.setName("mail.port");
        property.setValue(mail.getPort());

        settingsRepository.save(property);

        property = new Settings<>();
        property.setName("mail.user");
        property.setValue(mail.getUser());

        settingsRepository.save(property);

        property = new Settings<>();
        property.setName("mail.pass");
        property.setValue(mail.getPassword());

        settingsRepository.save(property);

        property = new Settings<>();
        property.setName("mail.tls");
        property.setValue(mail.getTls());

        settingsRepository.save(property);

        return "redirect:/admin/dashboard";
    }

    @GetMapping("/users")
    public String displayUsers(Model model) {
        model.addAttribute("users", userRepository.findAll());
        model.addAttribute("groups", groupRepository.findAll());
        model.addAttribute("roles", roleRepository.findAll());
        model.addAttribute("roleNames", roleRepository.findAll().stream().map(Role::getName).collect(Collectors.toList()));

        return "admin/users";
    }

    @GetMapping("/test")
    public @ResponseBody String test() {
        mailService.sendInvitation("pedro.zuppelli@gmail.com");

        return "success";
    }

    @PostMapping("/users/groups/add")
    public String addGroup(@RequestBody GroupAddForm content) {
        Group group = groupRepository.findByName(content.getName());

        if(null == group) {
            group = new Group();
            group.setName(content.getName());
        }

        group.setRoles(content.getRoles().stream().map(roleId -> roleRepository.findById(roleId))
                .filter(role -> role != null).map(Optional::get).collect(Collectors.toSet()));

        groupRepository.save(group);

        return "redirect:/admin/users";
    }
}
