<#import "/spring.ftl" as spring />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title><@spring.message "registration.head.title" /></title>
    <#include "includes/head-includes.ftl" />
</head>

<body>

<div class="container">

    <form method="POST" class="form-register">
    <@spring.bind "form" />
        <h4 class="form-signin-heading">${i18n("registration.greeting", [form.user.email!""])}</h4>
    <@spring.formHiddenInput "form.user.id" />
    <@spring.formHiddenInput "form.user.roles" />
    <@spring.formHiddenInput "form.user.groups" />
    <@spring.formHiddenInput "form.user.email" />
        <input type="hidden" id="user.active" name="user.active" value="true">

        <div class="form-group row">
            <label class="col-sm-6"><@spring.message "login.username" /></label>
            <div class="col-sm-6">
            <@spring.formInput "form.user.username" "class='form-control'"/>
            <@spring.showErrors "" />
            </div>
        </div>
        <div class="form-group row">
            <label class="col-sm-6"><@spring.message "registration.nombre" /></label>
            <div class="col-sm-6">
            <@spring.formInput "form.user.name" "class='form-control'"/>
            <@spring.showErrors "" />
            </div>
        </div>
        <div class="form-group row">
            <label class="col-sm-6"><@spring.message "registration.lastname" /></label>
            <div class="col-sm-6">
            <@spring.formInput "form.user.lastName" "class='form-control'"/>
            <@spring.showErrors "" />
            </div>
        </div>
        <div class="form-group row">
            <label class="col-sm-6"><@spring.message "registration.password" /></label>
            <div class="col-sm-6">
            <@spring.formPasswordInput "form.user.password" "class='form-control'"/>
            <@spring.showErrors "" />
            </div>
        </div>
        <div class="form-group row">
            <label class="col-sm-6"><@spring.message "registration.repassword" /></label>
            <div class="col-sm-6">
            <@spring.formPasswordInput "form.user.passwordConfirm" "class='form-control'"/>
            <@spring.showErrors "" />
            </div>
        </div>
        <#if isParent>
        <div class="form-group row">
            <label class="col-sm-6"><@spring.message "registration.child.name" /></label>
            <div class="col-sm-6">
            <@spring.formInput "form.childName" "class='form-control'"/>
            <@spring.showErrors "" />
            </div>
        </div>
        <div class="form-group row">
            <label class="col-sm-6"><@spring.message "registration.child.email" /></label>
            <div class="col-sm-6">
            <@spring.formInput "form.childEmail" "class='form-control'"/>
            <@spring.showErrors "" />
            </div>
        </div>
        </#if>

        <input type="hidden"
               name="${_csrf.parameterName}"
               value="${_csrf.token}"/>

        <button class="btn btn-lg btn-primary btn-block" type="submit"><@spring.message "registration.submit" /></button>
    </form>

</div>

</body>
</html>