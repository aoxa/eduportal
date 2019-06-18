package com.eduportal.event;

import com.eduportal.model.event.ViewNodeEvent;
import com.eduportal.repository.event.EventRepository;
import com.eduportal.repository.event.ViewNodeEventRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.event.EventListener;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.Optional;

@Component
public class ViewListener {
    @Autowired
    private ViewNodeEventRepository nodeEventRepository;

    @Async
    @EventListener
    public void nodeViewListener(ViewNodeEvent viewNodeEvent) {
        Optional<ViewNodeEvent> view = nodeEventRepository.findFirstByUserAndNode(viewNodeEvent.getUser(), viewNodeEvent.getNode());
        if(view.isPresent()) {
            viewNodeEvent = view.get();
            viewNodeEvent.setModificationDate(new Date());
        }

        nodeEventRepository.save(viewNodeEvent);
    }
}
