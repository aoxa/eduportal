<#import "/spring.ftl" as spring />
<#assign parent = node.parent />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>${parent.title}</title>

<#include "../../includes/head-includes.ftl" />
    <script src="<@spring.url '/resources/js/node.functions.js' />"></script>

    <link href="<@spring.url '/resources/css/form.css' />" rel="stylesheet">
</head>
<body>

<#include "../../includes/nav-bar.ftl"/>
<#include "../../includes/node.sub-nav-bar.ftl" />

<main class="container">
    <div class="container white row">
        <div class="col-sm-6">
            <h2>${parent.title}</h2>
        </div>
        <div class="col-sm-3"><div><strong>${node.user.username} </strong></div><div>Puntaje ${node.score} / 100</div></div>
        <div class="col-sm-3">Contestado el dia: ${node.creationDate?string["dd/MM/yy"]}</div>
        <div class="col-sm-12">${parent.body}</div>
    </div>
    <div id="elements">
    <#list parent.sortedElements as element>
        <div class="row element" element-name="${element.name}" element-weight="${element.weight}">
            <div class="element-title offset-sm-2 col-sm-4">${element.title}</div>
            <div class="col-sm-5">
                <#if element.type == 'Select'>
                    <#if element.checkBox>
                        <#list element.options as option>
                            <#assign class=selectedClass(element.name, option, node) />
                            <div class="customized-type element-type form-check" element-type="checkbox">
                                <input <#if class?has_content>checked</#if> id="${element.name}-${option.id}" name="${element.name}" value="${option.value}"
                                       type="checkbox" class="form-check-input ${class}" disabled/>
                                <label class="form-check-label"
                                       for="${element.name}-${option.id}">${option.value}</label>
                                <span class="checkmark"></span>
                            </div>
                        </#list>
                    <#elseif element.radioButton>
                        <#list element.options as option>
                            <#assign class=selectedClass(element.name, option, node) />
                            <div class="customized-type form-check element-type" element-type="radio">
                                <input <#if class?has_content>checked</#if> id="${element.name}-${option.id}" name="${element.name}" value="${option.value}"
                                       type="radio" class="${class} form-check-input" disabled/>
                                <label for="${element.name}-${option.id}"
                                       class="form-check-label">${option.value}</label>
                                <span class="radiomark"></span>
                            </div>
                        </#list>
                    <#else>
                        <select element-type="select" class="form-control element-type" name="${element.name}"
                                multiple disabled>
                            <#list element.options as option>
                                <option value="${option.value}" class="${selectedClass(element.name, option, node)}">${option.value}</option>
                            </#list>
                        </select>
                    </#if>
                <#else>
                    <input class="element-type" element-type="input" type="text" name="${element.name}">
                </#if>
            </div>
        </div>
    </#list>
    </div>
</main>
</body>
</html>

<#function selectedClass name option reply>
    <#if wasElementSelected(name, option, reply) >
        <#if option.selected>
            <#return "right">
        <#else>
            <#return "wrong">
        </#if>
    </#if>
    <#return "">
</#function>