package com.eduportal.interceptor;

import com.eduportal.annotation.Interceptor;
import com.eduportal.auth.model.User;
import com.eduportal.auth.service.SecurityService;
import com.eduportal.model.NodeReply;
import com.eduportal.model.Survey;
import com.eduportal.model.SurveyReply;
import com.eduportal.model.partial.Element;
import com.eduportal.model.partial.Option;
import com.eduportal.model.partial.Select;
import com.eduportal.repository.NodeReplyRepository;
import freemarker.template.TemplateBooleanModel;
import freemarker.template.TemplateModel;
import freemarker.template.utility.DeepUnwrap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.annotation.PostConstruct;
import java.util.Optional;

@Interceptor
public class SurveyMacroInterceptor extends AbstractMacroInterceptor {
    @Autowired
    private NodeReplyRepository<SurveyReply> replyRepository;

    @Autowired
    private SecurityService securityService;

    @PostConstruct
    public void startUp() {
        macros.put("wasElementSelected", (params) -> {
            String elementName = (String) DeepUnwrap.permissiveUnwrap((TemplateModel) params.get(0));
            Option currentElement = (Option) DeepUnwrap.permissiveUnwrap((TemplateModel) params.get(1));
            SurveyReply reply = (SurveyReply) DeepUnwrap.permissiveUnwrap((TemplateModel) params.get(2));

            Optional<Element> replyElement = reply.getElements().stream().filter(el->el.getName().equals(elementName))
                    .findFirst();

            if(!replyElement.isPresent()) return TemplateBooleanModel.FALSE;

            Optional<Option> replyOption = ((Select)replyElement.get()).getOptions().stream()
                    .filter(option -> option.getName().equals(currentElement.getName())).findFirst();

            return replyOption.isPresent()? TemplateBooleanModel.TRUE : TemplateBooleanModel.FALSE;
        });

        macros.put("alreadyAnswered", (params) -> {
            Survey survey = (Survey) DeepUnwrap.permissiveUnwrap((TemplateModel) params.get(0));
            User user = securityService.findLoggedInUser();

            return replyRepository.findAllByUserAndParent(user, survey).iterator().hasNext();
        });
    }
}
