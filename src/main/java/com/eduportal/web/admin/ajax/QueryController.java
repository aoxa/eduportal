package com.eduportal.web.admin.ajax;

import com.eduportal.auth.repository.GroupRepository;
import com.eduportal.auth.repository.RoleRepository;
import com.eduportal.auth.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestAttribute;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
public class QueryController {
    @Autowired
    private GroupRepository groupRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private UserRepository userRepository;

    @GetMapping("/admin/group/list.json")
    public @ResponseBody
    List<Object> getGroupList(@RequestAttribute String q) {
        return groupRepository.findAllByNameIsLike("%"+q+"%").stream()
                .map(e -> new Entry<>(e.getName(), e.getId()))
                .collect(Collectors.toList());
    }

    @GetMapping("/admin/role/list.json")
    public @ResponseBody
    List<Object> getRoleList(String q) {
        return roleRepository.findAllByNameIsLike("%"+q+"%").stream()
                .map(e -> new Entry<>(e.getName(), e.getId()))
                .collect(Collectors.toList());
    }

    @GetMapping("/admin/user/list.json")
    public @ResponseBody
    List<Object> getUserList(String q) {
        return userRepository.findAllByUsernameIsLike("%"+q+"%").stream()
                .map(e -> new Entry<>(e.getUsername(), e.getId()))
                .collect(Collectors.toList());
    }

    @GetMapping("/teacher/list.json")
    public @ResponseBody
    List<Object> getTeacherList(String q) {
        return groupRepository.findByName("teacher").getUsers().stream()
                .filter(e->e.getUsername() != null).map(e -> new Entry<>(e.getUsername(), e.getId()))
                .collect(Collectors.toList());
    }

    public static class Entry<T> {
        String text;
        T id;

        public Entry(String text, T id) {
            this.text = text;
            this.id = id;
        }

        public String getText() {
            return text;
        }

        public T getId() {
            return id;
        }
    }
}
