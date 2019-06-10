package com.eduportal.aspect;

import com.eduportal.auth.model.Group;
import com.eduportal.auth.model.Role;
import com.eduportal.auth.repository.GroupRepository;
import com.eduportal.model.Course;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Aspect
@Component
public class AdminRolesAspect {
    @Autowired
    private GroupRepository groupRepository;

    @After("execution(* com.eduportal.auth.repository.RoleRepository.save(..))")
    public void updateAdminRoles(JoinPoint joinPoint) {
        Role role = (Role)joinPoint.getArgs()[0];

        addRoleToAdmin(role);
    }

    @After("execution(* com.eduportal.repository.CourseRepository.save(..))")
    public void updateAdminCourseRoles(JoinPoint joinPoint) {
        Course course = (Course)joinPoint.getArgs()[0];

        addRoleToAdmin(course.getNeededRole());
    }

    private void addRoleToAdmin(Role role) {
        Group group = groupRepository.findByName("admin");

        if(null != group && ! group.getRoles().contains(role)) {
            group.getRoles().add(role);
            groupRepository.save(group);
        }
    }
}
