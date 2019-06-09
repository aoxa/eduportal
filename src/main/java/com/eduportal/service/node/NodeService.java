package com.eduportal.service.node;

import com.eduportal.model.Node;
import com.eduportal.repository.NodeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class NodeService {
    @Autowired
    private NodeRepository nodeRepository;

    public Node saveOrUpdate(Node node) {
        nodeRepository.save(node);
        return node;
    }
}
