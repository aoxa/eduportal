<#import "/spring.ftl" as spring />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>${node.title}</title>

<#include "../includes/head-includes.ftl" />
</head>
<body>

<#include "../includes/nav-bar.ftl"/>
<#include "../includes/node.sub-nav-bar.ftl" />

<main class="container white">
    <div class="row">
        <div class="col-sm-8">
            <h2>${node.title}</h2>
        </div>
        <div class="col-sm-4"><#if node.limitDate??>Entrega: ${node.limitDate?string["dd/MM/yy"]}</#if></div>
        <div class="col-sm-12">${node.description}</div>
    </div>
<#list node.sortedElements as element>
    <div class="row">
        <div class="offset-sm-2 col-sm-4">${element.title}</div>
        <div class="col-sm-6">
            <#if element.type == 'Select'>
                <#if element.checkBox>
                    <#list element.options as option>
                        <div class="form-check">
                            <input id="${element.name}-${option.id}" name="${element.name}" value="${option.value}"
                                   type="checkbox" class="form-check-input"/>
                            <label class="form-check-label" for="${element.name}-${option.id}">${option.value}</label>
                        </div>
                    </#list>
                <#elseif element.radioButton>
                    <#list element.options as option>
                        <div class="form-check">
                            <input id="${element.name}-${option.id}" name="${element.name}" value="${option.value}"
                                   type="radio" class="form-check-input"/>
                            <label for="${element.name}-${option.id}" class="form-check-label">${option.value}</label>
                        </div>
                    </#list>
                <#else>
                    <select class="form-control" name="${element.name}"
                            <#if element.multivalued>multiple</#if>>
                        <#list element.options as option>
                            <option value="${option.value}">${option.value}</option>
                        </#list>
                    </select>
                </#if>
            <#else>
                <input type="text" name="${element.name}">
            </#if>
        </div>
    </div>
</#list>
</main>

<#if canEdit(node)>
<button id="fab-edit" type="button"
        class="btn btn-success bottom-right-floating btn-circle btn-xl">
    <i class="far fa-edit"></i>
</button>
<script>
    $("#fab-edit").click(function () {
        window.location = '<@spring.url '/${node.type?lower_case}/${node.id}/edit' />';
    });
</script>
</#if>

</body>