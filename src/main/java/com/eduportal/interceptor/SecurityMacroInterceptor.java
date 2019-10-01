package com.eduportal.interceptor;

import com.eduportal.annotation.Interceptor;
import com.eduportal.auth.model.Role;
import com.eduportal.auth.model.User;
import com.eduportal.auth.service.UserDetailService;
import com.eduportal.model.Course;
import freemarker.template.TemplateBooleanModel;
import freemarker.template.TemplateModel;
import freemarker.template.utility.DeepUnwrap;
import org.springframework.security.core.context.SecurityContextHolder;

import javax.annotation.PostConstruct;
import java.util.HashSet;
import java.util.Set;

@Interceptor
public class SecurityMacroInterceptor extends AbstractMacroInterceptor {

    @PostConstruct
    public void startUp() {
        macros.put("currentUser", (params) -> {
            if(null !=SecurityContextHolder.getContext().getAuthentication()) {
                UserDetailService.UserDetailsWrapper wrapper = (UserDetailService.UserDetailsWrapper) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
                return wrapper.getUser();
            }
            return null;
        });

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

        macros.put("isCourseAuthority", (params)->{
            if(! SecurityContextHolder.getContext().getAuthentication().isAuthenticated()) return TemplateBooleanModel.FALSE;

            final User user = ((UserDetailService.UserDetailsWrapper) SecurityContextHolder.getContext().getAuthentication().getPrincipal()).getUser();

            Course course = (Course) DeepUnwrap.permissiveUnwrap((TemplateModel) params.get(0));

            return course.getAuthorities().contains(user) ? TemplateBooleanModel.TRUE : TemplateBooleanModel.FALSE;
        });
    }


}
