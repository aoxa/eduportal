package com.eduportal.aspect;

import com.eduportal.auth.model.Group;
import com.eduportal.auth.model.User;
import com.eduportal.auth.repository.UserRepository;
import com.eduportal.interceptor.RoleUpdateInterceptor;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Aspect
@Component
public class UserRefreshRoleAspect {
    @Autowired
    private RoleUpdateInterceptor roleUpdateInterceptor;

    @After("execution(* com.eduportal.auth.repository.UserRepository.save(..))")
    public void updateUser(JoinPoint joinPoint) {
        roleUpdateInterceptor.addUser((User) joinPoint.getArgs()[0]);
    }

    @After("execution(* com.eduportal.auth.repository.GroupRepository.save(..))")
    public void updateGroupUsers(JoinPoint joinPoint) {
        Group group = (Group) joinPoint.getArgs()[0];
        for (User user : group.getUsers())
            roleUpdateInterceptor.addUser(user);
    }

}
