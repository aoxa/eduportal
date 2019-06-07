package com.eduportal.interceptor;

import com.eduportal.annotation.Interceptor;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Service;

import javax.persistence.Id;

@Service
@Interceptor
public class LocaleChangeInterceptor extends org.springframework.web.servlet.i18n.LocaleChangeInterceptor {
    public LocaleChangeInterceptor() {
        this.setParamName("lang");
    }
}
