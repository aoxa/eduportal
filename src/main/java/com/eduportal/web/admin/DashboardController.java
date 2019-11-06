package com.eduportal.web.admin;

import com.eduportal.auth.model.Group;
import com.eduportal.auth.model.Role;
import com.eduportal.auth.model.User;
import com.eduportal.auth.repository.GroupRepository;
import com.eduportal.auth.repository.RoleRepository;
import com.eduportal.auth.repository.UserRepository;
import com.eduportal.auth.service.UserService;
import com.eduportal.model.Setting;
import com.eduportal.repository.SettingRepository;
import com.eduportal.service.MailService;
import com.eduportal.web.admin.form.GroupAddForm;
import com.eduportal.web.admin.form.InviteUserForm;
import com.eduportal.web.admin.form.MailConfigForm;
import com.eduportal.web.helper.RequestHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.Optional;
import java.util.stream.Collectors;

@Controller
@PreAuthorize("hasRole('ADMIN')")
@RequestMapping("/admin")
public class DashboardController {
    public static final int PAGE_SIZE = 5;
    public static final int INITIAL_PAGE = 0;
    @Autowired
    private GroupRepository groupRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserService userService;

    @Autowired
    private SettingRepository settingRepository;

    @Autowired
    private MailService mailService;

    @GetMapping("/dashboard")
    public String display(Model model) {
        return "admin/dashboard";
    }

    @GetMapping("/users")
    public String displayUsers(Model model) {
        model.addAttribute("users", userRepository.findAll(PageRequest.of(INITIAL_PAGE, PAGE_SIZE)));
        model.addAttribute("roles", roleRepository.findAll(PageRequest.of(INITIAL_PAGE, PAGE_SIZE)));

        return "admin/users";
    }

    @GetMapping("/groups")
    public String displayGroups(Model model) {
        model.addAttribute("roles", roleRepository.findAll(PageRequest.of(INITIAL_PAGE, PAGE_SIZE)));
        model.addAttribute("groups", groupRepository.findAll(PageRequest.of(INITIAL_PAGE, PAGE_SIZE)));

        return "admin/groups";
    }

    @PostMapping("/users/{user}/reset")
    public @ResponseBody String reset(@PathVariable User user, String password) {
        user.setPassword(password);
        userService.save(user);

        return "tru";
    }

    @GetMapping("/groups/remove/{group}")
    public String remove(Model model, @PathVariable Group group) {
        groupRepository.delete(group);
        model.addAttribute("groups", groupRepository.findAll());
        return "admin/tab/partial/group-list";
    }

    @GetMapping("/users/map")
    public @ResponseBody
    ResponseEntity<String> mapUsers(@RequestParam User user, @RequestParam(required = false) Group group,
                                    @RequestParam(required = false) Role role) {
        if (null != group) {
            user.getGroups().add(group);
            group.getUsers().add(user);
            groupRepository.save(group);
        }

        if (null != role) {
            user.getRoles().add(role);
        }

        userRepository.save(user);

        return new ResponseEntity<>(HttpStatus.OK);
    }

    @GetMapping("/users/list")
    public String getRoleList(Model model, Integer page) {
        model.addAttribute("users", userRepository.findAll(PageRequest.of(page, PAGE_SIZE)));

        return "admin/tab/partial/user-list";
    }

    @GetMapping("/users/role/list")
    public String getUserList(Model model, Integer page) {
        model.addAttribute("roles", roleRepository.findAll(PageRequest.of(page, PAGE_SIZE)));

        return "admin/tab/partial/role-list";
    }

    @GetMapping("/users/group/list")
    public String getGroupList(Model model, Integer page) {
        model.addAttribute("groups", groupRepository.findAll(PageRequest.of(page, PAGE_SIZE)));

        return "admin/tab/partial/group-list";
    }

    @PostMapping("/dashboard")
    public String save(Model model, MailConfigForm mail) {
        Setting<String> property = new Setting<>();
        property.setName("mail.smtp");
        property.setValue(mail.getSmtp());

        settingRepository.save(property);

        property = new Setting<>();
        property.setName("mail.port");
        property.setValue(mail.getPort());

        settingRepository.save(property);

        property = new Setting<>();
        property.setName("mail.user");
        property.setValue(mail.getUser());

        settingRepository.save(property);

        property = new Setting<>();
        property.setName("mail.pass");
        property.setValue(mail.getPassword());

        settingRepository.save(property);

        property = new Setting<>();
        property.setName("mail.tls");
        property.setValue(mail.getTls());

        settingRepository.save(property);

        return "redirect:/admin/dashboard";
    }

    @PostMapping("/users/invite")
    public @ResponseBody Object invite(Model model, @RequestBody InviteUserForm inviteUserForm, HttpServletRequest request) {
        User user = new User();
        user.setEmail(inviteUserForm.getEmail());
        user.setUsername(inviteUserForm.getEmail());

        if(null != inviteUserForm.getGroups()) {
            inviteUserForm.getGroups().stream().map(role -> Long.parseLong(role))
                    .map(groupId -> groupRepository.findById(groupId))
                    .filter(optional -> optional.isPresent()).map(optional -> optional.get())
                    .forEach(group -> user.getGroups().add(group));
        }

        if(null != inviteUserForm.getRoles()) {
            inviteUserForm.getRoles().stream().map(role -> Long.parseLong(role))
                    .map(roleId -> roleRepository.findById(roleId))
                    .filter(optional -> optional.isPresent()).map(optional -> optional.get())
                    .forEach(role -> user.getRoles().add(role));
        }
        userRepository.save(user);

        mailService.sendInvitation(RequestHelper.createURL(request, null), user);

        return userRepository.findAll();
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

        model.addAttribute("groups", groupRepository.findAll(PageRequest.of(INITIAL_PAGE, PAGE_SIZE)));
        return "admin/tab/partial/group-list";
    }

    @DeleteMapping("/users/{user}")
    public String removeUser(Model model, @PathVariable User user) {
        userRepository.delete(user);

        model.addAttribute("users", userRepository.findAll(PageRequest.of(INITIAL_PAGE, PAGE_SIZE)));

        return "admin/tab/partial/user-list";
    }
}
