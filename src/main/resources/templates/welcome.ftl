<#import "/spring.ftl" as spring />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Create an account</title>
<#include "includes/head-includes.ftl"/>
</head>

<body>

<#include "includes/nav-bar.ftl" />

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
<#if hasAnyAuthority('add-course', 'admin') >
    <div class="container white row">
        <button class="btn btn-info" data-toggle="modal"
                data-target="#add-course-modal">
            <i class="fas fa-folder-plus"></i> Agregar nuevo curso
        </button>
    </div>

    <div id="add-course-modal" class="modal fade" tabindex="-1" role="dialog" aria-hidden="true"
         aria-labelledby="addCourseModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <form method="post" action="<@spring.url "/course/add" />">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addCourseModalLabel">Agregar nuevo curso</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label>Nombre</label>
                            <input class="form-control" name="name" type="text">
                        </div>
                        <div class="form-group">
                            <label>Descripcion</label>
                            <input class="form-control" name="desc" type="text">
                        </div>
                        <input type="hidden"
                               name="${_csrf.parameterName}"
                               value="${_csrf.token}"/>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
                        <button class="btn btn-primary" type="submit">Enviar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</#if>

</main>

</body>
</html>