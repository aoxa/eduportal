package com.eduportal.repository;

import com.eduportal.auth.model.Role;
import com.eduportal.model.Course;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Set;

public interface CourseRepository extends JpaRepository<Course, Long> {
    @Query("from Course c where c.neededRole in (?1)")
    List<Course> findAllForUserRoles(Set<Role> roles);

    List<Course> findCoursesByNeededRoleIn(List<Role> userRoles);
}
