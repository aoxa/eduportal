<#import "/spring.ftl" as spring />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Log in with your account</title>

    <link href="<@spring.url '/resources/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="<@spring.url '/resources/css/common.css' />" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
    <script src="<@spring.url '/resources/js/bootstrap.min.js' />"></script>
</head>

<body class="text-center">

<div class="container">
    <form method="POST" action="<@spring.url '/login' />" class="form-signin">
        <h2 class="form-heading">Log in</h2>

        <div class="form-group <#if error??>has-error</#if>">
            <span>${message!''}</span>
            <input name="username" type="text" class="form-control" placeholder="Username"
                   autofocus="true"/>
            <input name="password" type="password" class="form-control" placeholder="Password"/>
            <span>${error!''}</span>
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <button class="btn btn-lg btn-primary btn-block" type="submit">Log In</button>
            <h4 class="text-center"><a href="<@spring.url '/registration' />">Create an account</a></h4>
        </div>
    </form>
</div>


</body>
</html>