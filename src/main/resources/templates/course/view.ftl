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

<main role="main">
    <div class="container white">
        <div class="row">
            <div class="col-sm-9">
                <h2>${course.name}</h2>
                <div>
                ${course.description}
                </div>
            </div>
            <div class="col-sm-3">
                <strong>Autoridades</strong>
            <#if hasAuthority('admin')>
                <span class="badge badge-info" data-toggle="modal"
                      data-target="#add-authority-modal" style="cursor:pointer"><i class="fa fa-plus"></i> Agregar
                    </span>
            </#if>
            <#list course.authorities as authority>
                <div><i class="fas fa-chalkboard-teacher"></i> ${authority.username}</div>
            </#list>
            </div>
        </div>
    </div>
    <div class="container white">
    <#if !course.nodes?has_content>
        El curso aun no tiene contenido
    </#if>
    <#list course.nodes as node>
        <div class="row">
            <div class="col-sm-1"><@nodeIcon node /></div>
            <div class="col-sm-11">
                <a href="<@spring.url '/node/${node.id}' />">${node.title}</a>
            </div>
        </div>
    </#list>
    </div>
</main>

<#if hasAuthority('admin')>
    <@modal modalId='add-authority-modal' form=true formAction='/course/${course.id}/authority/add'
    footerCancel='Cerrar' footerAccept='Enviar' header='Agregar Autoridad'
    content='<div class="form-group"><label>Ingrese una autoridad del curso</label>
             <input type="hidden" name="user"></div>'></@modal>
</#if>

<script>
    $("#add-authority-modal input[name='user']").select2({
        ajax:{
            url: "<@spring.url "/teacher/list.json"/>",
            data: function (term, page) {
                return {
                    q: term
                };
            },            dataType: "json",
            results: function (data, page) {
                return { results: data };
            }
        },
        width: "100%",
        minimumInputLength: 2,
        theme: "classic"
    })
</script>

</body>
</html>