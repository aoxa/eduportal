package com.eduportal.web.view.node;

import com.eduportal.annotation.ViewEvent;
import com.eduportal.model.Article;
import com.eduportal.model.Course;
import com.eduportal.model.Node;
import com.eduportal.repository.CourseRepository;
import com.eduportal.repository.NodeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@Controller
public class NodeController {

    @Autowired
    private NodeRepository nodeRepository;

    @Autowired
    private CourseRepository courseRepository;

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

    @PostMapping(value = "/{course}/article/add")
    public String add(@PathVariable("course") Course course, Article article) {
        nodeRepository.save(article);

        course.getNodes().add(article);

        courseRepository.save(course);

        return "redirect:/node/" + article.getId();
    }

    @ViewEvent
    @GetMapping("/node/{node}")
    public String view(Model model, @PathVariable("node") Node node) {
        model.addAttribute("node", node);

        return node.getType().toLowerCase() + "/view";
    }
}
