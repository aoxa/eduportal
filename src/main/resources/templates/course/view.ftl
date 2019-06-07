<#import "/spring.ftl" as spring />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>${course.name}</title>
<#include '../includes/head-includes.ftl'/>
</head>

<body>

<#include "../includes/nav-bar.ftl" />

<main role="main" class="container white">
    <div class="row">
        <div class="col-sm-8">
            <h2>${course.name}</h2>

        <#list course.nodes as node>
            <div class="row">
                <a href="<@spring.url '/node/${node.id}' />">${node.title}</a>
            </div>
        </#list>
        </div>
        <div class="col-sm-4">
            <h4>Autoridades del curso
            <#if hasAuthority('admin')>
                <button class="btn btn-info" data-toggle="modal"
                        data-target="#add-authority-modal"><i class="fa fa-plus"></i> Agregar
                </button>
            </#if>
            </h4>
        <#list course.authorities as authority>
            <div>${authority.username}</div>
        </#list>
        </div>
    </div>

<#if hasAuthority('admin')>
    <div id="add-authority-modal" class="modal fade" tabindex="-1" role="dialog" aria-hidden="true"
         aria-labelledby="addAuthModalLabel">

        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <form method="post" action="<@spring.url '/course/${course.id}/authority/add' />">
                    <div class="modal-header">
                        <h5 id="addAuthModalLabel">Agregar autoridad</h5>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label>Ingrese una autoridad del curso</label>

                            <input class="form-control" name="user">
                        </div>
                        <div class="form-group">
                            <input type="hidden"
                                   name="${_csrf.parameterName}"
                                   value="${_csrf.token}"/>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
                            <button class="btn btn-primary" type="submit">Enviar</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</#if>
</main>

</body>
</html>