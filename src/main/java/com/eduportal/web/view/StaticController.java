package com.eduportal.web.view;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class StaticController {
    @GetMapping("/error/403")
    public String forbidden() {
        return "/error/403";
    }
}
