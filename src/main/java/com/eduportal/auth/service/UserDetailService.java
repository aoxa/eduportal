package com.eduportal.auth.service;

import com.eduportal.auth.model.User;
import com.eduportal.auth.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;


@Service
public class UserDetailService implements UserDetailsService {
    @Autowired
    private UserRepository userRepository;

    @Transactional(readOnly = true)
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByUsername(username);

        if( null == user ) throw new UsernameNotFoundException(username);

        if(!user.getActive()) throw new DisabledException("User not active");

        final Set<GrantedAuthority> grantedAuthorities = new HashSet<GrantedAuthority>();

        user.getRoles().stream()
                .forEach(role ->grantedAuthorities.add(new SimpleGrantedAuthority(role.getName())));

        return new UserDetailsWrapper(
                user,
                grantedAuthorities);
    }

    public static class UserDetailsWrapper extends org.springframework.security.core.userdetails.User {
        private final User user;
        public UserDetailsWrapper(User user,
                    Collection<? extends GrantedAuthority> authorities) {
            super(user.getUsername(), user.getPassword(), true, true, true, true, authorities);
            this.user = user;
        }

        public User getUser() {
            return user;
        }
    }
}
