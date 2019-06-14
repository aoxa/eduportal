package com.eduportal.aspect;

import com.eduportal.model.base.BaseEntity;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import java.util.Date;

//@Aspect
//s@Component
public class ModelDateUpdateAspect {

    public void updateTime(JoinPoint joinPoint) {
        BaseEntity entity = (BaseEntity) joinPoint.getArgs()[0];
        if(entity.getCreationDate() == null) {
            entity.setCreationDate(new Date());
        }

        entity.setModificationDate(new Date());
    }

    @Before("@annotation(com.eduportal.annotation.DateUpdatableModel) ")
    public void updateTimeAnnotated(JoinPoint joinPoint) {
        updateTime(joinPoint);
    }
}
