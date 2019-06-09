<#import "/spring.ftl" as spring />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>${node.title}</title>

<#include "../includes/head-includes.ftl" />
    <script src="<@spring.url '/resources/js/node.functions.js' />"></script>
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
    <div id="elements">


    <#list node.sortedElements as element>
        <div class="row" element-name="${element.name}" element-weight="${element.weight}">
            <div class="element-title offset-sm-2 col-sm-4">${element.title}</div>
            <div class="col-sm-5">
                <#if element.type == 'Select'>
                    <#if element.checkBox>
                        <#list element.options as option>
                            <div class="element-type form-check" element-type="checkbox">
                                <input id="${element.name}-${option.id}" name="${element.name}" value="${option.value}"
                                       type="checkbox" class="form-check-input"/>
                                <label class="form-check-label"
                                       for="${element.name}-${option.id}">${option.value}</label>
                            </div>
                        </#list>
                    <#elseif element.radioButton>
                        <#list element.options as option>
                            <div class="form-check element-type" element-type="radio">
                                <input id="${element.name}-${option.id}" name="${element.name}" value="${option.value}"
                                       type="radio" class="form-check-input"/>
                                <label for="${element.name}-${option.id}"
                                       class="form-check-label">${option.value}</label>
                            </div>
                        </#list>
                    <#else>
                        <select element-type="select" class="form-control element-type" name="${element.name}"
                                <#if element.multivalued>multiple</#if>>
                            <#list element.options as option>
                                <option value="${option.value}">${option.value}</option>
                            </#list>
                        </select>
                    </#if>
                <#else>
                    <input class="element-type" element-type="input" type="text" name="${element.name}">
                </#if>
            </div>
            <div class="col-sm-1">
                <i data-toggle="tooltip" class="far fa-question-circle element-tip" data-original-title="${element.tip}"
                   data-placement="right"></i>
            </div>
        </div>
    </#list>
    </div>
    <div>
        <button id="answer" class="btn btn-success">Contestar</button>
    </div>
    <script>
        $("#answer").click(function () {
            var content = {};

            content.elements = new Array();

            $("#elements .row").each(function (indice, e) {
                content.elements.push(createElement(e,$(e).attr("element-name"), false));
            });

            $.ajax({
                type: "PUT",
                url: "<@spring.url '/${node.course.id}/${nodeDescriptor(node).type}/${node.id}' />",
                beforeSend: function (xhr) {
                    xhr.setRequestHeader('${_csrf.headerName}', "${_csrf.token}");
                },
                data: JSON.stringify(content),
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json'
                },
                success: function(data, textStatus, request) {
                    //window.location = request.getResponseHeader('location');
                }
            });

            console.log(JSON.stringify(content));
        })
    </script>
<#if canAnswer(node)>

</#if>
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