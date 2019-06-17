<#import "/spring.ftl" as spring />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Crear nuevo articulo</title>

<#include "../includes/head-includes.ftl" />

    <link href='https://cdn.jsdelivr.net/npm/froala-editor@2.9.5/css/froala_editor.min.css' rel='stylesheet'
          type='text/css'/>
    <link href='https://cdn.jsdelivr.net/npm/froala-editor@2.9.5/css/froala_style.min.css' rel='stylesheet'
          type='text/css'/>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">

    <script src='https://cdn.jsdelivr.net/npm/froala-editor@2.9.5/js/froala_editor.min.js'></script>
    <script src="<@spring.url '/resources/js/node.functions.js' />"></script>
</head>
<body>

<#include "../includes/nav-bar.ftl" />
<#include "../includes/node.sub-nav-bar.ftl" />

<main role="main" class="container">
    <h1 class="mt-5">Agregar nuevo articulo</h1>
    <form method="post" action="<@spring.url "" />">
        <div class="row">
            <div class="col-sm-12">
                <h3>Ingrese el titulo de la asignatura</h3>
                <input id="titulo" name="title" type="text" class="form-control" placeholder="Ingrese el titulo aqui"
                       <#if node??>value="${node.title}" </#if>>
            </div>
        </div>

        <div class="row">
            <div class="col-sm-4">
                Breve descripcion del articulo
            </div>
            <div class="col-sm-8">
                <input name="description" id="description" type="text" value="<#if node??>${node.description}</#if>" />
            </div>
        </div>

        <div class="row">
            <div class="col-sm-12">
                <textarea name="body" id="editor"><#if node??>${node.body}</#if></textarea>
            </div>
        </div>
        <input type="hidden"
               name="${_csrf.parameterName}"
               value="${_csrf.token}"/>

        <button id="publish" type="submit" class="btn btn-primary">Publicar</button>
    </form>
</main>
<script>
    $('#editor').froalaEditor({width: '100%', placeholderText: 'Ingrese una descripcion para la asignatura'});
</script>
</body>
</html>