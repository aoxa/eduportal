package com.eduportal.web;

import com.eduportal.auth.service.SecurityService;
import com.eduportal.model.Course;
import com.eduportal.model.Node;
import com.eduportal.model.Survey;
import com.eduportal.model.SurveyReply;
import com.eduportal.model.partial.Element;
import com.eduportal.model.partial.Option;
import com.eduportal.model.partial.Select;
import com.eduportal.repository.CourseRepository;
import com.eduportal.repository.NodeReplyRepository;
import com.eduportal.repository.NodeRepository;
import com.eduportal.repository.SurveyReplyRepository;
import com.eduportal.service.node.NodeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.context.request.RequestContextHolder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashSet;
import java.util.List;

@Controller
public class NodeController {

    @Autowired
    private NodeService nodeService;

    @Autowired
    private CourseRepository courseRepository;

    @Autowired
    private SecurityService securityService;

    @Autowired
    private NodeReplyRepository<SurveyReply> surveyReplyRepository;

    @GetMapping("/{course}/{type}/add")
    public String displayAdd(Model model, @PathVariable("course") Course course,
                             @PathVariable("type") String type) {
        model.addAttribute("course", course);
        model.addAttribute("type", type);

        return type + "/new-element";
    }

    @GetMapping("/{type}/{node}/edit")
    public String displayEdit(Model model, @PathVariable("node") Node node,
                             @PathVariable("type") String type) {
        model.addAttribute("node", node);
        model.addAttribute("course", node.getCourse());
        model.addAttribute("type", type);

        return type + "/new-element";
    }

    @GetMapping("/node/{node}")
    public String view(Model model, @PathVariable("node") Node node) {
        model.addAttribute("node", node);

        return node.getType().toLowerCase() + "/view";
    }

    @PostMapping(value = "/{course}/survey/add")
    public String addSurvey(Model model, @PathVariable("course") Course course, @RequestBody Survey survey,
                            HttpServletRequest request, HttpServletResponse response) {
        survey.setCourse(course);

        course.getNodes().add(survey);

        nodeService.saveOrUpdate(survey);

        courseRepository.save(course);

        response.setHeader("location", createURL(request, "/node/"+survey.getId()));

        model.addAttribute("node", survey);
        model.addAttribute("type", "survey");

        return "survey/new-element";
    }

    @PostMapping("/{course}/survey/{node}")
    public String edit(Model model, @PathVariable("node") Survey node) {
        model.addAttribute("node", node);

        return node.getType().toLowerCase() + "/view";
    }

    @PutMapping("/{course}/survey/{node}")
    public String reply(Model model, @PathVariable("course") Course course,
                        @PathVariable("node") Node node, @RequestBody SurveyReply surveyReply) {
        model.addAttribute("node", node);

        surveyReply.setUser(securityService.findLoggedInUser());

        surveyReply.setParent((Survey)node);

        surveyReplyRepository.save(surveyReply);

        return node.getType().toLowerCase() + "/view";
    }

    protected static String createURL(HttpServletRequest request, String resourcePath) {

        int port = request.getServerPort();
        StringBuilder result = new StringBuilder();
        result.append(request.getScheme())
                .append("://")
                .append(request.getServerName());

        if ( (request.getScheme().equals("http") && port != 80) || (request.getScheme().equals("https") && port != 443) ) {
            result.append(':')
                    .append(port);
        }

        result.append(request.getContextPath());

        if(resourcePath != null && resourcePath.length() > 0) {
            if( ! resourcePath.startsWith("/")) {
                result.append("/");
            }
            result.append(resourcePath);
        }

        return result.toString();

    }
}
