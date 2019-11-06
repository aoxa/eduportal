package com.eduportal;


import com.eduportal.annotation.Interceptor;
import com.eduportal.auth.service.UserDetailService;
import com.eduportal.interceptor.SecurityMacroInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import java.util.Locale;

@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class WebSecurityConfig extends WebSecurityConfigurerAdapter implements WebMvcConfigurer {
    @Autowired
    private UserDetailService userDetailsService;

    @Bean
    public BCryptPasswordEncoder bCryptPasswordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Autowired
    SecurityMacroInterceptor macroInterceptor;

    @Autowired
    private ApplicationContext applicationContext;

    public void addInterceptors(InterceptorRegistry registry) {
        applicationContext.getBeansWithAnnotation(Interceptor.class).values().stream()
                .filter(o -> o instanceof HandlerInterceptor)
                .map(o -> (HandlerInterceptor)o )
                .forEach(bean ->registry.addInterceptor(bean));
    }

    @Bean
    public LocaleResolver localeResolver() {
        SessionLocaleResolver slr = new SessionLocaleResolver();
        slr.setDefaultLocale(Locale.forLanguageTag("es"));
        return slr;
    }

    protected void configure(HttpSecurity http) throws Exception {
        http.authorizeRequests()
                .antMatchers("/webapp/resources/**", "/resources/**", "/registration").permitAll()
                .anyRequest().authenticated().and()
                .formLogin()
                .loginPage("/login")
                .permitAll().and()
                .logout()
                .deleteCookies("JSESSIONID")
                .logoutSuccessUrl("/login")
                .permitAll()
                .and()
                .exceptionHandling().accessDeniedPage("/error/403");

    }

    @Bean
    public AuthenticationManager customAuthenticationManager() throws Exception {
        return authenticationManager();
    }

    @Autowired
    public void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(userDetailsService).passwordEncoder(bCryptPasswordEncoder());
    }
}
