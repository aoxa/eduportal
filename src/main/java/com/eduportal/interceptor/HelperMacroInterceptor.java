package com.eduportal.interceptor;

import com.eduportal.annotation.Interceptor;
import com.eduportal.auth.repository.UserRepository;
import com.eduportal.auth.service.UserDetailService;
import com.eduportal.model.Settings;
import com.eduportal.repository.SettingsRepository;
import freemarker.template.TemplateMethodModelEx;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.annotation.PostConstruct;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Interceptor
public class HelperMacroInterceptor  extends AbstractMacroInterceptor {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private SettingsRepository settingsRepository;

    @PostConstruct
    public void startUp() {
        macros.put("currentUser", (params)->{
            Object userDetails = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

            if( userDetails instanceof UserDetailService.UserDetailsWrapper) {
                return ((UserDetailService.UserDetailsWrapper)userDetails).getUser();
            } else if( userDetails instanceof UserDetails) {
                return userRepository.findByUsername(((UserDetails)userDetails).getUsername());
            }
            else return null;
        });

        macros.put("getSetting", (params) -> {
            Optional<Settings> setting = settingsRepository.findById(params.get(0).toString());
            return setting.isPresent()? setting.get().getValue():null;
        });

    }

}

