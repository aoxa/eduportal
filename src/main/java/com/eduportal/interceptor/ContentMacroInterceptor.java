package com.eduportal.interceptor;

import com.eduportal.annotation.Interceptor;
import com.eduportal.auth.model.User;
import com.eduportal.auth.service.UserDetailService;
import com.eduportal.model.Node;
import com.eduportal.service.node.NodeType;
import com.eduportal.service.node.NodeTypeService;
import freemarker.template.TemplateBooleanModel;
import freemarker.template.TemplateMethodModelEx;
import freemarker.template.TemplateModel;
import freemarker.template.utility.DeepUnwrap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.annotation.PostConstruct;
import java.util.HashMap;
import java.util.Map;

@Interceptor
@Component
public class ContentMacroInterceptor  extends AbstractMacroInterceptor {

    @Autowired
    private NodeTypeService nodeTypeService;

    @PostConstruct
    public void startUp() {
        macros.put("canEdit", (params)-> {
            if(! SecurityContextHolder.getContext().getAuthentication().isAuthenticated()) return TemplateBooleanModel.FALSE;

            final User user = ((UserDetailService.UserDetailsWrapper) SecurityContextHolder.getContext().getAuthentication().getPrincipal()).getUser();

            Node node = (Node) DeepUnwrap.permissiveUnwrap((TemplateModel) params.get(0));
            NodeType nodeType = nodeTypeService.getNodeTypeService(node.getClass());

            boolean userHasRole = node.getCourse().getAuthorities().contains(user) &&
                    user.getAllRoles().contains(nodeType.getEditRole());

            return userHasRole ? TemplateBooleanModel.TRUE : TemplateBooleanModel.FALSE;
        });

        macros.put("nodeDescriptor", (params)-> {
            Node node = (Node) DeepUnwrap.permissiveUnwrap((TemplateModel) params.get(0));
            return nodeTypeService.getNodeTypeService(node.getClass());
        });
    }
}