package com.eduportal.aspect;

import com.eduportal.model.base.BaseEntity;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import java.util.Date;

@Aspect
@Component
public class ModelDateUpdateAspect {

    @Before("execution(* com.eduportal.repository.NodeRepository.save(..))")
    public void updateTime(JoinPoint joinPoint) {
        BaseEntity entity = (BaseEntity) joinPoint.getArgs()[0];
        if(entity.getCreationDate() != null) {
            entity.setCreationDate(new Date());
        }

        entity.setModificationDate(new Date());
    }
}
