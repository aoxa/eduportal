<#import "/spring.ftl" as spring />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Create an account</title>
    <link href="<@spring.url '/resources/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="<@spring.url '/resources/css/common.css' />" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
    <script src="<@spring.url '/resources/js/bootstrap.min.js' />"></script>
</head>

<body>

<#include "nav-bar.ftl" />

<main role="main" class="col-sm-10 offset-1">
    <div class="row">
        <div class="container white col-sm-7">
            Bienvenido ${currentUser().username}
        </div>
        <div class="offset-1 container white col-sm-4">
            <h4>Mis cursos</h4>
        <#if !courses?has_content>
            Usted no esta suscripto a ningun curso
        </#if>
        <#list courses as course>
            <p><a href="<@spring.url '/course/${course.id}' />">${course.name}</a><p>
        </#list>

        </div>

    </div>
    <div class="container white row">
        <a href="<@spring.url '/course/add' />">Agregar nuevo curso</a>
    </div>


</main>

</body>
</html>