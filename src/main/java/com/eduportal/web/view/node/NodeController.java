package com.eduportal.web.view.node;

import com.eduportal.model.Course;
import com.eduportal.model.Node;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@Controller
public class NodeController {

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
}
