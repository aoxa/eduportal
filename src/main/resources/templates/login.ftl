<#import "/spring.ftl" as spring />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title><@spring.message "login.head.title" /></title>

    <#include "includes/head-includes.ftl" />
</head>

<body class="text-center">

<div class="container">
    <form method="POST" action="<@spring.url '/login' />" class="form-signin">
        <h2 class="form-heading"><@spring.message "login.title"/></h2>

        <div class="form-group <#if error??>has-error</#if>">
            <span>${message!''}</span>
            <input name="username" type="text" class="form-control" placeholder="<@spring.message "login.username" />"
                   autofocus="true"/>
            <input name="password" type="password" class="form-control" placeholder="<@spring.message "login.password" />"/>
            <span>${error!''}</span>
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <button class="btn btn-lg btn-primary btn-block" type="submit"><@spring.message "login.submit" /></button>
        </div>
    </form>
</div>

</body>
</html>