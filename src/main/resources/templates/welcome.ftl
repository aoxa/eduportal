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
        <#if !allUserCourses()?has_content>
            Usted no esta suscripto a ningun curso
        </#if>
        <#list enrolledUserCourses() as course>
            <p><i class="fas fa-door-open"></i> <a href="<@spring.url '/course/${course.id}' />">${course.name}</a><p>
        </#list>
        <#list availableUserCourses() as course>
            <p><i class="fas fa-door-closed"></i> <a href="#" data-toggle="modal" data-target="#enroll-course-modal" data-whatever="${course.id}">${course.name}</a><p>
        </#list>

        </div>

    </div>
<#if hasAnyAuthority('add-course', 'admin') >
    <div class="container white row">
        <button class="btn btn-info" data-toggle="modal"
                data-target="#add-course-modal">
            <i class="fas fa-folder-plus"></i> Nuevo curso
        </button>
    </div>

    <@modal modalId="add-course-modal" header="Agregar nuevo curso"
    content='<div class="form-group">
                            <label>Nombre</label>
                            <input class="form-control" name="name" type="text">
                        </div>
                        <div class="form-group">
                            <label>Descripcion</label>
                            <input class="form-control" name="desc" type="text">
                        </div>'
    footerCancel='Cerrar' footerAccept="Enviar" formAction='/course/add' form=true></@modal>

</#if>

<@modal modalId='enroll-course-modal' header='Asosiacion disponible' content='Desea entrar al grupo?' footerAccept='Enviar'
footerCancel='Cerrar' form=true formAction='/course/{C_ID}/enroll'></@modal>
    <script>
        $('#enroll-course-modal').on('show.bs.modal', function (event) {
            var button = $(event.relatedTarget) // Button that triggered the modal
            var courseId = button.data('whatever') // Extract info from data-* attributes
            var $form = $("#enroll-course-modal form");

            $form.attr("action", $form.attr("action").replace("{C_ID}", courseId));
        });

    </script>

</main>

</body>
</html>