package com.eduportal.web;

import com.eduportal.model.Course;
import com.eduportal.model.Node;
import com.eduportal.model.Survey;
import com.eduportal.model.partial.Element;
import com.eduportal.model.partial.Option;
import com.eduportal.model.partial.Select;
import com.eduportal.repository.CourseRepository;
import com.eduportal.repository.NodeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.context.request.RequestContextHolder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashSet;
import java.util.List;

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

        nodeRepository.save(survey);

        courseRepository.save(course);

        response.setHeader("location", createURL(request, "/node/"+survey.getId()));

        model.addAttribute("node", survey);
        model.addAttribute("type", "survey");

        return "survey/new-element";
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
    /*
    public String addSurvey(@PathVariable("course") Course course, @RequestBody ContentDTO content) {
        Survey survey = new Survey();
        survey.setDescription(content.getDescription());
        survey.setTitle(content.getTitle());
        survey.setCourse(course);
        survey.setElements(new HashSet<Element>());
        content.getElements().forEach(el -> {
            Element element = null;
            switch (el.getType()) {
                case "checkbox":
                    Select sel = new Select();
                    sel.setCheckBox(true);
                    sel.setOptions(new HashSet<>());
                    el.getValues().forEach( val -> {
                        Option op = new Option();
                        op.setName(val.value);
                        op.setBoolValue(val.valid);
                        op.setValue(val.valid.toString());
                        sel.getOptions().add(op);
                            });
                    element = sel;

                    break;
                case "radio":
                    Select s = new Select();
                    s.setRadioButton(true);
                    s.setOptions(new HashSet<>());
                    el.getValues().forEach( val -> {
                        Option op = new Option();
                        op.setName(val.value);
                        op.setBoolValue(val.valid);
                        op.setValue(val.valid.toString());
                        s.getOptions().add(op);
                            });
                    element = s;
                    break;
            }
            survey.getElements().add(element);
        });

        nodeRepository.save(survey);

        return "survey/new-element";
    }
    */

    public static class ContentDTO {
        private String description;
        private String title;
        private List<ElementDTO> elements;

        public String getDescription() {
            return description;
        }

        public void setDescription(String description) {
            this.description = description;
        }

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public List<ElementDTO> getElements() {
            return elements;
        }

        public void setElements(List<ElementDTO> elements) {
            this.elements = elements;
        }
    }

    public static class ElementDTO {
        private String weight;
        private String name;
        private String title;
        private String type;
        private String tip;
        private List<ValueDTO> values;

        public String getWeight() {
            return weight;
        }

        public void setWeight(String weight) {
            this.weight = weight;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public String getType() {
            return type;
        }

        public void setType(String type) {
            this.type = type;
        }

        public String getTip() {
            return tip;
        }

        public void setTip(String tip) {
            this.tip = tip;
        }

        public List<ValueDTO> getValues() {
            return values;
        }

        public void setValues(List<ValueDTO> values) {
            this.values = values;
        }
    }

    public static class ValueDTO {
        private String value;
        private Boolean valid;

        public String getValue() {
            return value;
        }

        public void setValue(String value) {
            this.value = value;
        }

        public Boolean getValid() {
            return valid;
        }

        public void setValid(Boolean valid) {
            this.valid = valid;
        }
    }
}
