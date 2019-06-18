package com.eduportal.web.view.node;

import com.eduportal.auth.service.SecurityService;
import com.eduportal.model.Article;
import com.eduportal.model.Comment;
import com.eduportal.model.Course;
import com.eduportal.model.Node;
import com.eduportal.repository.NodeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class ArticleController {
    @Autowired
    private NodeRepository nodeRepository;

    @Autowired
    private SecurityService securityService;

    @PostMapping("{course}/article/{node}/reply")
    public String addReply(@PathVariable Course course, @PathVariable Node node, Comment comment) {
        node.getChildren().add(comment);
        comment.setParent((Article)node);
        comment.setUser(securityService.findLoggedInUser());

        nodeRepository.save(node);

        return "redirect:/node/"+node.getId();
    }

}
