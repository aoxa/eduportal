package com.eduportal.service.node;

import com.eduportal.auth.model.Role;
import com.eduportal.auth.repository.RoleRepository;
import com.eduportal.model.Survey;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.util.Arrays;

@Component
public class SurveyType extends NodeType {

    @PostConstruct
    public void init() {
        super.init();
    }

    public String getEditRoleName() {
        return "edit_" + getType();
    }

    public String getAnswerRoleName() {
        return "answer_" + getType();
    }

    @Override
    public Class<Survey> nodeClass() {
        return Survey.class;
    }

    @Override
    public String getType() {
        return Survey.TYPE;
    }

    @Override
    public String getName() {
        return messageSource.getMessage(String.format("node.type.%s.name", Survey.TYPE), null, null);
    }

}
