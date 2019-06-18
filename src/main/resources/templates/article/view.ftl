<#import "/spring.ftl" as spring />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>${node.title}</title>

<#include "../includes/head-includes.ftl" />
    <script src="<@spring.url '/resources/js/node.functions.js' />"></script>
    <script src='https://cdn.jsdelivr.net/npm/froala-editor@2.9.5/js/froala_editor.min.js'></script>

    <link href="<@spring.url '/resources/css/form.css' />" rel="stylesheet">
    <link href='https://cdn.jsdelivr.net/npm/froala-editor@2.9.5/css/froala_editor.min.css' rel='stylesheet'
          type='text/css'/>
    <link href='https://cdn.jsdelivr.net/npm/froala-editor@2.9.5/css/froala_style.min.css' rel='stylesheet'
          type='text/css'/>
</head>
<body>

<#include "../includes/nav-bar.ftl"/>
<#include "../includes/node.sub-nav-bar.ftl" />

<main class="container">
    <div class="container white row">
        <div class="col-sm-12">
            <h2>${node.title}</h2>
        </div>
        <div class="col-sm-12">${node.body}</div>
    </div>
<#if node.children?has_content>
    <div class="container white row">
        <#list node.children as child>
            <div class="col-sm-12 comment-container">
                <div class="comment-header"><span class="user">${child.user.username}</span>${child.creationDate?string["dd/MM/yy"]} </div>
                <div class="comment-content">${child.body}</div>
            </div>
        </#list>
    </div>
</#if>
    <button id="fab-add" data-original-title="Agregar Comentario" data-placement="top" type="button"
            class="btn btn-primary bottom-right-floating btn-circle btn-xl"
            data-toggle="modal" data-target="#add-comment-modal">+
    </button>
<@modal modalId="add-comment-modal" header="Agregar Comentario"
content='<div class="form-group"><label>Comentario</label>
<textarea id="comment-body" name="body"></textarea></div>'
form=true formAction="/${node.course.id}/${node.type}/${node.id}/reply"
footerAccept="Comentar" footerCancel="cerrar" />
</main>
</body>
<script>
    $("#comment-body").froalaEditor({width: '100%', placeholderText: 'Ingrese el comentario'});
</script>
</html>