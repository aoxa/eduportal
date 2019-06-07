package com.eduportal.interceptor;

import com.eduportal.annotation.Interceptor;
import com.eduportal.auth.model.Role;
import com.eduportal.auth.repository.UserRepository;
import com.eduportal.auth.service.UserDetailService;
import com.eduportal.model.Settings;
import com.eduportal.repository.SettingsRepository;
import com.eduportal.web.view.functions.HasAuthority;
import freemarker.template.TemplateBooleanModel;
import freemarker.template.TemplateMethodModelEx;
import freemarker.template.TemplateModel;
import freemarker.template.utility.DeepUnwrap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

@Component
@Interceptor
public class MacroInterceptor extends HandlerInterceptorAdapter {
    private Map<String, TemplateMethodModelEx> macros = new HashMap<>();

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private SettingsRepository settingsRepository;

    @PostConstruct
    public void startUp() {
        macros.put("hasAuthority", (params) -> {
            String expectedRole = (String) DeepUnwrap.permissiveUnwrap((TemplateModel) params.get(0));

            UserDetailService.UserDetailsWrapper wrapper = (UserDetailService.UserDetailsWrapper) SecurityContextHolder.getContext().getAuthentication().getPrincipal();

            boolean hasRole = false;

            for (Role roles : wrapper.getUser().getRoles()) {
                hasRole |= roles.getName().equals(expectedRole);
            }

            return hasRole ? TemplateBooleanModel.TRUE : TemplateBooleanModel.FALSE;
        });

        macros.put("hasAnyAuthority", (params) -> {
            final UserDetailService.UserDetailsWrapper wrapper = (UserDetailService.UserDetailsWrapper) SecurityContextHolder.getContext().getAuthentication().getPrincipal();

            final Set<String> roleNames = new HashSet<>();

            for(Object param : params) {
                roleNames.add((String) DeepUnwrap.permissiveUnwrap((TemplateModel) param));
            }

            boolean hasRole = false;

            for (Role roles : wrapper.getUser().getRoles()) {
                hasRole |= roleNames.contains(roles.getName());
            }

            return hasRole ? TemplateBooleanModel.TRUE : TemplateBooleanModel.FALSE;
        });

        macros.put("hasAllAuthorities", (params) -> {
            final UserDetailService.UserDetailsWrapper wrapper = (UserDetailService.UserDetailsWrapper) SecurityContextHolder.getContext().getAuthentication().getPrincipal();

            final Set<String> roleNames = new HashSet<>();

            for(Object param : params) {
                roleNames.add((String) DeepUnwrap.permissiveUnwrap((TemplateModel) param));
            }

            boolean hasRole = !wrapper.getUser().getRoles().isEmpty();

            for (Role roles : wrapper.getUser().getRoles()) {
                hasRole &= roleNames.contains(roles.getName());
            }

            return hasRole ? TemplateBooleanModel.TRUE : TemplateBooleanModel.FALSE;
        });

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

    @Override
    public void postHandle(
            HttpServletRequest req,
            HttpServletResponse res,
            Object o,
            ModelAndView model) throws Exception {

        if (isAuthenticated() &&
                model != null) {
            for(Map.Entry<String, TemplateMethodModelEx> entry : this.macros.entrySet()) {
                model.addObject(entry.getKey(), entry.getValue());
            }

        }
    }

    private boolean isAuthenticated() {
        return SecurityContextHolder.getContext().getAuthentication() != null &&
                SecurityContextHolder.getContext().getAuthentication().isAuthenticated();
    }

}
