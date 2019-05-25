<#import "/spring.ftl" as spring />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Create an account</title>
    <link href="<@spring.url '/resources/css/bootstrap.min.css' />" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
    <script src="<@spring.url '/resources/js/bootstrap.min.js' />"></script>
</head>

<body>

<#include "nav-bar.ftl" />

<main role="main" class="container">
    <form method="post">
        Nombre <input name="name" type="text">
        Descripcion <input name="desc" type="text">
        <input type="hidden"
               name="${_csrf.parameterName}"
               value="${_csrf.token}"/>
        <button type="submit">Save</button>
    </form>
</main>


</body>
</html>