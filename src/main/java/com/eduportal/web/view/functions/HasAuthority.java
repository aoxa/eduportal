package com.eduportal.web.view.functions;

import com.eduportal.auth.model.Role;
import com.eduportal.auth.repository.UserRepository;
import com.eduportal.auth.service.UserDetailService;
import freemarker.template.TemplateBooleanModel;
import freemarker.template.TemplateMethodModelEx;
import freemarker.template.TemplateModel;
import freemarker.template.TemplateModelException;
import freemarker.template.utility.DeepUnwrap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class HasAuthority implements TemplateMethodModelEx {

    @Autowired
    private UserRepository userRepository;

    @Override
    public Object exec(List params) throws TemplateModelException {
        return null;
    }

}
