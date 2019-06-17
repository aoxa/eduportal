package com.eduportal.repository;

import com.eduportal.annotation.DateUpdatableModel;
import com.eduportal.model.Course;
import com.eduportal.model.Node;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;


public interface NodeRepository extends JpaRepository<Node, Long> {
    @DateUpdatableModel
    Node save(Node node);

    List<Node> findAllByCourse(Course course);
}
