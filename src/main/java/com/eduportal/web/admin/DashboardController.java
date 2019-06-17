package com.eduportal.web.admin;

import com.eduportal.auth.model.Group;
import com.eduportal.auth.model.Role;
import com.eduportal.auth.model.User;
import com.eduportal.auth.repository.GroupRepository;
import com.eduportal.auth.repository.RoleRepository;
import com.eduportal.auth.repository.UserRepository;
import com.eduportal.model.Settings;
import com.eduportal.repository.SettingsRepository;
import com.eduportal.service.MailService;
import com.eduportal.web.admin.form.GroupAddForm;
import com.eduportal.web.admin.form.InviteUserForm;
import com.eduportal.web.admin.form.MailConfigForm;
import com.eduportal.web.helper.RequestHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
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

    @PostMapping("/users/invite")
    public @ResponseBody Object invite(Model model, @RequestBody InviteUserForm inviteUserForm, HttpServletRequest request) {
        User user = new User();
        user.setEmail(inviteUserForm.getEmail());

        inviteUserForm.getGroups().stream().map(role->Long.parseLong(role))
                .map(groupId->groupRepository.findById(groupId))
                .filter(optional->optional.isPresent()).map(optional->optional.get())
                .forEach(group->user.getGroups().add(group));

        inviteUserForm.getRoles().stream().map(role->Long.parseLong(role))
                .map(roleId->roleRepository.findById(roleId))
                .filter(optional->optional.isPresent()).map(optional->optional.get())
                .forEach(role->user.getRoles().add(role));

        userRepository.save(user);

        mailService.sendInvitation(RequestHelper.createURL(request, null), user);

        return userRepository.findAll();
    }

    @GetMapping("/groups/remove/{group}")
    public String remove(Model model, @PathVariable Group group) {
        groupRepository.delete(group);
        model.addAttribute("groups", groupRepository.findAll());
        return "admin/tab/partial/group-list";
    }

    @DeleteMapping("/users/{user}")
    public String removeUser(Model model, @PathVariable User user) {
        userRepository.delete(user);

        model.addAttribute("users", userRepository.findAll());

        return "admin/tab/partial/user-list";
    }

    @GetMapping("/users/map")
    public @ResponseBody
    ResponseEntity<String> mapUsers(@RequestParam User user, @RequestParam Group group) {
        user.getGroups().add(group);
        group.getUsers().add(user);
        userRepository.save(user);
        groupRepository.save(group);

        return new ResponseEntity<>(HttpStatus.OK);
    }

    @PostMapping("/users/groups/add")
    public String addGroup(Model model, @RequestBody GroupAddForm content) {
        Group group = groupRepository.findByName(content.getName());

        if(null == group) {
            group = new Group();
            group.setName(content.getName());
        }

        group.setRoles(content.getRoles().stream().map(roleId -> roleRepository.findById(roleId))
                .filter(role -> role != null).map(Optional::get).collect(Collectors.toSet()));

        groupRepository.save(group);

        model.addAttribute("groups", groupRepository.findAll());
        return "admin/tab/partial/group-list";
    }
}
