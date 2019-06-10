package com.eduportal.interceptor;

import com.eduportal.annotation.Interceptor;
import com.eduportal.auth.model.Role;
import com.eduportal.auth.model.User;
import com.eduportal.auth.repository.UserRepository;
import com.eduportal.auth.service.SecurityService;
import com.eduportal.auth.service.UserDetailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

@Component
@Interceptor
public class RoleUpdateInterceptor  extends HandlerInterceptorAdapter {
    private final Set<User> users = Collections.synchronizedSet(new HashSet<>());

    @Autowired
    private SecurityService securityService;

    @Autowired
    private UserRepository userRepository;

    public void addUser(User user) {
        users.add(user);
    }

    @Override
    public void postHandle(
            HttpServletRequest req,
            HttpServletResponse res,
            Object o,
            ModelAndView model) throws Exception {
        final User currentUser = securityService.findLoggedInUser();
        if(null != currentUser &&
                users.contains(currentUser)) {
            users.remove(currentUser);
            updateRoles(SecurityContextHolder.getContext().getAuthentication(),
                    userRepository.findById(currentUser.getId()).get());
        }
    }

    private void updateRoles(Authentication auth, User current) {


        List<GrantedAuthority> updatedAuthorities = new ArrayList<>();

        for (Role role : current.getAllRoles()) {
            updatedAuthorities.add(new SimpleGrantedAuthority(role.getName()));
        }

        Authentication newAuth = new UsernamePasswordAuthenticationToken(new UserDetailService.UserDetailsWrapper(
                current,
                updatedAuthorities), auth.getCredentials(),
                updatedAuthorities);

        SecurityContextHolder.getContext().setAuthentication(newAuth);
    }
}

