package com.eduportal.repository;

import com.eduportal.annotation.DateUpdatableModel;
import com.eduportal.auth.model.User;
import com.eduportal.model.Node;
import com.eduportal.model.NodeReply;
import org.springframework.data.domain.Example;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;


public interface NodeReplyRepository<T extends NodeReply> extends JpaRepository<T, Long> {
    @DateUpdatableModel
    NodeReply save(NodeReply entity);

    Iterable<T> findAllByUserAndParent(User user, Node parent);
}
