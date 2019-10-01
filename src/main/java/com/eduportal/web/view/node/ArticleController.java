package com.eduportal.web.view.node;

import com.eduportal.annotation.Notification;
import com.eduportal.auth.service.SecurityService;
import com.eduportal.model.Article;
import com.eduportal.model.Comment;
import com.eduportal.model.Course;
import com.eduportal.model.Node;
import com.eduportal.repository.CourseRepository;
import com.eduportal.repository.NodeReplyRepository;
import com.eduportal.repository.NodeRepository;
import com.eduportal.service.node.NodeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class ArticleController {
    @Autowired
    private NodeService nodeService;

    @Autowired
    private SecurityService securityService;

    @Autowired
    private CourseRepository courseRepository;

    @Autowired
    private NodeReplyRepository nodeReplyRepository;

    @Notification
    @PostMapping(value = "/{course}/article/add")
    public String add(@PathVariable("course") Course course, Article article) {
        nodeService.saveOrUpdate(article);

        course.getNodes().add(article);

        courseRepository.save(course);

        return "redirect:/node/" + article.getId();
    }

    @PostMapping("{course}/article/{node}/reply")
    public String addReply(@PathVariable Course course, @PathVariable Node node, Comment comment) {
        comment.setParent((Article)node);
        comment.setUser(securityService.findLoggedInUser());

        nodeReplyRepository.save(comment);

        return "redirect:/node/"+node.getId();
    }

}
