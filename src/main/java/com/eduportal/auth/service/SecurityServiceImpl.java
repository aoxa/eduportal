package com.eduportal.auth.service;

import com.eduportal.auth.model.User;
import com.eduportal.auth.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

@Service
public class SecurityServiceImpl implements SecurityService {
    private final static Logger logger = LoggerFactory.getLogger(SecurityService.class);

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private UserDetailService userDetailService;

    @Autowired
    private UserRepository userRepository;

    @Override
    public String findLoggedInUsername() {
        Object userDetails = SecurityContextHolder.getContext().getAuthentication().getDetails();

        if( userDetails instanceof UserDetails) {
            return ((UserDetails)userDetails).getUsername();
        }

        return null;
    }

    @Override
    public void autoLogin(String username, String password) {
        UserDetails userDetails = userDetailService.loadUserByUsername(username);
        UsernamePasswordAuthenticationToken token =
                new UsernamePasswordAuthenticationToken(userDetails, password, userDetails.getAuthorities());

        authenticationManager.authenticate(token);

        if ( token.isAuthenticated()) {
            SecurityContextHolder.getContext().setAuthentication(token);
            logger.debug(String.format("Auto login %s successful", username));
        }
    }

    @Override
    public User findLoggedInUser() {
        if(null == SecurityContextHolder.getContext() || null == SecurityContextHolder.getContext().getAuthentication()) {
            return null;
        }

        Object userDetails = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if( userDetails instanceof UserDetailService.UserDetailsWrapper) {
            return ((UserDetailService.UserDetailsWrapper)userDetails).getUser();
        } else if( userDetails instanceof UserDetails ) {
            return userRepository.findByUsername(((UserDetails)userDetails).getUsername());
        }

        return null;
    }
}
