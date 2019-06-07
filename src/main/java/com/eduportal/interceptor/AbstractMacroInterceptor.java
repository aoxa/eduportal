package com.eduportal.interceptor;

import freemarker.template.TemplateMethodModelEx;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;

public class AbstractMacroInterceptor extends HandlerInterceptorAdapter {
    protected Map<String, TemplateMethodModelEx> macros = new HashMap<>();

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
