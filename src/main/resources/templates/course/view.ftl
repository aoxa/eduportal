<#import "/spring.ftl" as spring />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>${course.name}</title>
    <link href="<@spring.url '/resources/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="<@spring.url '/resources/css/common.css' />" rel="stylesheet">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
    <script src="<@spring.url '/resources/js/bootstrap.min.js' />"></script>
</head>

<body>

<#include "../nav-bar.ftl" />

<main role="main" class="container white">
    <div class="row">
        <div class="col-sm-8">
            <h2>${course.name}</h2>
            <a href="<@spring.url '/${course.id}/survey/add' />">Agregar nuevo</a>

        <#list course.nodes as node>
            <div class="row">
                <a href="<@spring.url '/node/${node.id}' />">${node.title}</a>
            </div>
        </#list>
        </div>
        <div class="col-sm-4">
            <h4>Autoridades del curso</h4>
        <#list course.authorities as authority>
            <div>${authority.username}</div>
        </#list>
        </div>
    </div>
    <div class="row">
    <#if hasAuthority('admin')>
        <form method="post" action="<@spring.url '/course/${course.id}/authority/add' />">
            Ingrese una autoridad del curso
            <input name="user">
            <input type="hidden"
                   name="${_csrf.parameterName}"
                   value="${_csrf.token}"/>
            <button type="submit">save</button>
        </form>
    </#if>
    </div>
</main>

</body>
</html>