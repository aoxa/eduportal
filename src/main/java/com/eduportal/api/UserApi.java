package com.eduportal.api;

import com.eduportal.auth.model.User;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping(value = "/api/users", produces = "application/json")
public class UserApi {
    @GetMapping("/{id}.json")
    public @ResponseBody User getUser(@PathVariable("id") User id) {
        return id;
    }
}
