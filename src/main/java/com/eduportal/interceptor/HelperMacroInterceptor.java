package com.eduportal.interceptor;

import com.eduportal.annotation.Interceptor;
import com.eduportal.auth.repository.UserRepository;
import com.eduportal.auth.service.UserDetailService;
import com.eduportal.model.Setting;
import com.eduportal.repository.SettingRepository;
import com.eduportal.web.SessionMessage;
import freemarker.template.TemplateBooleanModel;
import freemarker.template.TemplateModel;
import freemarker.template.utility.DeepUnwrap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.NoSuchMessageException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;

import javax.annotation.PostConstruct;
import java.util.List;
import java.util.Optional;

@Interceptor
public class HelperMacroInterceptor  extends AbstractMacroInterceptor {
    @Autowired
    private SessionMessage sessionMessage;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    protected MessageSource messageSource;

    @Autowired
    private SettingRepository settingRepository;

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
            Optional<Setting> setting = settingRepository.findById(params.get(0).toString());
            return setting.isPresent()? setting.get().getValue():null;
        });

        macros.put("i18n", (params)-> {
            Object[] args = null;

            if(params.size() > 1) {
                args = ((List) DeepUnwrap.permissiveUnwrap((TemplateModel) params.get(1))).toArray();
            }

            try {
                return messageSource.getMessage(params.get(0).toString(), args, null);
            } catch (NoSuchMessageException ex) {
                return params.get(0).toString();
            }
        });

        macros.put("hasSessionMessage", (params) -> {
                    if(sessionMessage.isPendingDisplay()) {
                        sessionMessage.setPendingDisplay(false);
                        return TemplateBooleanModel.TRUE;
                    }
                    return TemplateBooleanModel.FALSE;

                }
        );

        macros.put("sessionMessage", (params) ->  sessionMessage.getMessage());

    }

}

