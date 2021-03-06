package com.eduportal.auth.repository;

import com.eduportal.auth.model.Group;
import org.springframework.data.jpa.repository.JpaRepository;

import javax.annotation.PostConstruct;
import java.util.List;

public interface GroupRepository extends JpaRepository<Group, Long> {
    Group findByName(String name);

    List<Group> findAllByNameIsLike(String name);
}
