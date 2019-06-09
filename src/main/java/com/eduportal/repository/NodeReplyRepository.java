package com.eduportal.repository;

import com.eduportal.model.NodeReply;
import org.springframework.data.jpa.repository.JpaRepository;

public interface NodeReplyRepository<T extends NodeReply> extends JpaRepository<T, Long> {
}
