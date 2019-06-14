package com.eduportal.auth.service.score;

import com.eduportal.model.Survey;
import com.eduportal.model.SurveyReply;
import com.eduportal.model.partial.Element;
import com.eduportal.model.partial.Option;
import com.eduportal.model.partial.Select;
import org.springframework.stereotype.Service;

import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class SurveyScoreService {
    public Float calculateScore(Survey survey, SurveyReply surveyReply) {
        final float pointRatio = 100 / (float) survey.getElements().size();

        float result = 0;

        for(Element element : survey.getElements()) {
            Optional<Element> reply = surveyReply.getElements().stream().filter((r) -> element.getName().equals(r.getName()))
                    .findFirst();

            if(reply.isPresent()) {
                if(element instanceof Select) {
                    float ratio = 1;
                    long failed = 0;

                    Select select = (Select)element;

                    if(select.getMultivalued() || select.getCheckBox()) {
                        float count = select.getOptions().stream().filter(option -> option.getSelected()).count();

                        ratio = 1f / count;
                    }

                    Select userReply = (Select) reply.get();

                    long occurrences = select.getOptions().stream()
                            .filter(op -> op.getSelected())
                            .filter(op -> userReply.getOptions().stream().map(Option::getName).collect(Collectors.toList()).contains(op.getName()))
                            .count();

                    failed = userReply.getOptions().size() - occurrences;

                    float incorrectRate = failed * ratio;

                    float elementTotal = occurrences * ratio - incorrectRate;

                    result += pointRatio * ((elementTotal > 0)? elementTotal:0);
                }
            }
        }

        return result;
    }
}
