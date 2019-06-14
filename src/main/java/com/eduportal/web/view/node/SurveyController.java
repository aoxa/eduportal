package com.eduportal.web.view.node;

import com.eduportal.auth.service.SecurityService;
import com.eduportal.auth.service.score.SurveyScoreService;
import com.eduportal.model.*;
import com.eduportal.repository.CourseRepository;
import com.eduportal.repository.NodeReplyRepository;
import com.eduportal.service.node.NodeService;
import com.eduportal.web.helper.RequestHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Controller
public class SurveyController {

    @Autowired
    private NodeService nodeService;

    @Autowired
    private SecurityService securityService;

    @Autowired
    private CourseRepository courseRepository;

    @Autowired
    private NodeReplyRepository<SurveyReply> surveyReplyRepository;

    @Autowired
    private SurveyScoreService surveyScoreService;

    @PostMapping(value = "/{course}/survey/add")
    public @ResponseBody
    ResponseEntity<String> addSurvey(Model model, @PathVariable("course") Course course, @RequestBody Survey survey,
                                     HttpServletRequest request, HttpServletResponse response) {
        survey.setCourse(course);

        course.getNodes().add(survey);

        nodeService.saveOrUpdate(survey);

        courseRepository.save(course);

        response.setHeader("location", RequestHelper.createURL(request, "/node/" + survey.getId()));

        return new ResponseEntity<String>(String.format("Node '%s' created", survey.getTitle()), HttpStatus.CREATED);
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

        surveyReply.setParent((Survey) node);

        surveyReply.setScore(surveyScoreService.calculateScore((Survey) node, surveyReply));

        surveyReplyRepository.save(surveyReply);

        return node.getType().toLowerCase() + "/view";
    }

    @GetMapping("/{course}/survey/{node}/reply/{reply}")
    public String viewReply(Model model, @PathVariable("course") Course course,
                        @PathVariable("node") Node node, @PathVariable("reply") NodeReply<Survey> surveyReply) {
        model.addAttribute("node", surveyReply);
        return node.getType().toLowerCase() + "/reply/view";
    }
}