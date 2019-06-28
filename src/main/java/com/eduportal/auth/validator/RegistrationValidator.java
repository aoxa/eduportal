package com.eduportal.auth.validator;

import com.eduportal.auth.model.User;
import com.eduportal.auth.web.form.RegistrationForm;
import org.hibernate.validator.internal.constraintvalidators.bv.EmailValidator;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import javax.validation.Validation;
import javax.validation.ValidatorFactory;

@Component
public class RegistrationValidator implements Validator {

    public boolean supports(Class<?> clazz) {
        return RegistrationForm.class.equals(clazz);
    }

    public void validate(Object o, Errors errors) {

        RegistrationForm form = (RegistrationForm) o;

        EmailValidator emailValidator = new EmailValidator();

        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "user.username", "NotEmpty");

        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "user.name", "NotEmpty");

        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "user.email", "NotEmpty");

        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "user.lastName", "NotEmpty");

        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "user.password", "NotEmpty");

        User user = form.getUser();

        if(emailValidator.isValid(form.getUser().getUsername(), null)) {
            errors.rejectValue("user.username", "Email.userForm.username.email");
        }

        if(form.getUser().getUsername().equals(form.getUser().getEmail())) {
            errors.rejectValue("user.username", "Email.userForm.username.email.equal");
        }

        boolean isParent = user.getRoles().stream().filter(r->r.getName().equals("parent")).count() != 0;

        if(isParent) {
            /*
            ValidationUtils.rejectIfEmptyOrWhitespace(errors, "childName", "NotEmpty");

            ValidationUtils.rejectIfEmptyOrWhitespace(errors, "childEmail", "NotEmpty");
            if(!emailValidator.isValid(form.getChildEmail(), null)) {
                errors.rejectValue("childEmail", "Email.userForm.childEmail.not.email");
            }
            */
        }

    }
}
