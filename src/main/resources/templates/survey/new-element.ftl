<#import "/spring.ftl" as spring />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Crear nueva asignatura</title>

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

    <h1 class="mt-5">Agregar nueva asignatura</h1>

    <div class="row">
        <div class="col-sm-9">
            <h3>Ingrese el titulo de la asignatura</h3>
            <input id="titulo" type="text" class="form-control" placeholder="Ingrese el titulo aqui"
                   <#if node??>value="${node.title}" </#if>>
        </div>
        <div class="col-sm-3">
            <label>Fecha de entrega</label>
            <input id="limite" type="text" class="form-control">
        </div>
    </div>

    <div class="row">
        <textarea id="editor">
        <#if node??>${node.body}</#if>
        </textarea>
    </div>


    <div id="elements" <#if !node??>style="display:none"</#if>>
    <#if node??>
        <#list node.sortedElements as element>
            <div id="element-skeleton-${element.id}" class="row element" element-weight="${element.weight}">
                <div class="col-sm-1 panel-heading ui-sortable-handle">
                    <i class="fas fa-arrows-alt-v"></i>
                </div>
                <div class="element-title col-sm-5">${element.title}</div>
                <#if element.type == "Select">
                    <#if element.radioButton>
                        <div class="element-type col-sm-5" element-type="radio">
                            <#list element.options as option>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="${element.name}"
                                           value="${option.value}">
                                    <label class="form-check-label">${option.name}</label>
                                </div>
                            </#list>
                        </div>
                    <#elseif element.checkBox>
                        <div class="element-type col-sm-5" element-type="checkbox">
                            <#list element.options as option>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="${element.name}"
                                           value="${option.value}">
                                    <label class="form-check-label">${option.name}</label>
                                </div>
                            </#list>
                        </div>
                    <#else>
                        <div class="element-type col-sm-5" element-type="select">
                            <select class="form-control" <#if element.multivalued>multiple</#if>>
                                <#list element.options as option>
                                    <option value="${option.value}">${option.name}</option>
                                </#list>
                            </select>
                        </div>
                    </#if>
                <#else>
                    <div class="element-type col-sm-5" element-type="input">
                        <div class="form-check">
                            <input class="form-check-input" type="input" name="${element.name}" value="contenido">
                        </div>
                    </div>
                </#if>

                <div class="col-sm-1">
                    <i data-toggle="tooltip" class="far fa-question-circle element-tip"
                       data-original-title="${element.tip}" data-placement="right"></i>
                    <a class="edit-element" href="#"><i class="far fa-edit"></i></a>
                </div>
            </div>
        </#list>
    </#if>
    </div>
    <input type="hidden"
           name="${_csrf.parameterName}"
           value="${_csrf.token}"/>
    <button id="publish" type="button" class="btn btn-primary">Publicar asignatura</button>
</main>
<!-- Button trigger modal -->

<button id="fab-add" data-original-title="Agregar nuevo elemento" data-placement="top" type="button"
        class="btn btn-primary bottom-right-floating btn-circle btn-xl"
        data-toggle="modal" data-target="#item-modal">+
</button>

<!-- Modal -->
<div class="modal fade" id="item-modal" tabindex="-1" role="dialog"
     aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Agregue un elemento</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <label>Tipo de elemento</label>
                <select id="modal-type" class="form-control">
                    <option value="cb">Check box</option>
                    <option value="rb">Radio button</option>
                    <option value="sel">Select</option>
                    <option value="msel">Multi Select</option>
                    <option value="txt">Text</option>
                </select>
                <label>Pregunta/Titulo del elemento</label>
                <input id="modal-title" class="form-control" type="text">
                <label>Tip o ayuda</label>
                <textarea id="modal-tip" class="form-control"></textarea>
                <div id="modal-multi">
                    <label>Agregue las opciones, separadas por punto y coma</label>
                    <textarea id="modal-multi-content" class="form-control"></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary">Save changes</button>
            </div>
        </div>
    </div>
</div>
<div id="element-skeleton" class="row" style="display:none;">
    <div class="col-sm-1 panel-heading"><i class="fas fa-arrows-alt-v"></i></div>
    <div class="element-title col-sm-5"></div>
    <div class="element-type col-sm-5"></div>
    <div class="col-sm-1">
        <i data-toggle="tooltip" class="far fa-question-circle element-tip" data-original-title=""
           data-placement="right"></i>
    </div>
</div>
<script type="application/javascript">
    updateElements = function () {
        var panelList = $('#elements');
        panelList.sortable({
            handle: '.panel-heading',
            update: function (event, ui) {
                $('.element', panelList).each(function (index, elem) {
                    $(elem).attr("element-weight", index);
                });
            }
        });
    };

    $(function () {
        $("#limite").datepicker({
            dateFormat: "dd/mm/yy",
            minDate: new Date()
        });

            $('#editor').froalaEditor({width: '100%', placeholderText: 'Ingrese una descripcion para la asignatura'});

        $('#fab-add').tooltip();

        $("#publish").click(function () {

            var content = createSurveyContent();

            var xhr = $.ajax({
                type: "POST",
                url: "<@spring.url '/${course.id}/${type}/add' />",
                beforeSend: function (xhr) {
                    xhr.setRequestHeader('${_csrf.headerName}', "${_csrf.token}");
                },
                data: JSON.stringify(content),
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json'
                },
                statusCode: {
                    201: function (data, textStatus, jqXHR) {
                        window.location = xhr.getResponseHeader('location');
                    }
                }
            });

        });
    });

    var itemId = 0;
    $("#modal-type").change(function () {
        $("#modal-multi-content").val("");
        if ($(this).val() === "txt") {
            $("#modal-multi").hide();
        } else {
            $("#modal-multi").show();
        }
    });

    $("#item-modal .btn-primary").click(function () {

        var element = $("#element-skeleton").clone();
        $(element).attr("id", $(element).attr("id") + "-" + itemId);
        $(element).addClass("element");
        $(element).attr("element-weight", itemId);
        $(element).removeAttr("style", "");
        $(element).find(".element-title").append($("#modal-title").val());

        itemId++;

        switch ($("#modal-type").val()) {
            case "msel":
            case "sel":
                var el = $("<select class=\"form-control\">");
                if ($("#modal-type").val() === "msel") {
                    $(el).attr('multiple', 'multiple');
                }
                var contenido = $("#modal-multi-content").val();

                contenido.split(";").forEach(function (e, i) {
                    var option = $("<option>");
                    $(option).val(e.trim());
                    $(option).text(e.trim());
                    $(el).append(option);
                });

                $(element).find(".element-type").attr('element-type', 'select').append(el);
                break;
            case "cb":
                var contenido = $("#modal-multi-content").val();
                var name = $("#modal-title").val().trim().replace(" ", "_");

                contenido.split(";").forEach(function (e, i) {
                    var container = $("<div class=\"form-check\">");

                    var label = $("<label class=\"form-check-label\">");
                    $(label).text(e);
                    var option = $("<input class=\"form-check-input\" type=\"checkbox\" >");
                    $(option).attr("name", name);
                    $(option).val(e.trim());

                    $(container).append(option);
                    $(container).append(label);

                    $(element).find(".element-type").attr('element-type', 'checkbox').append(container);
                });

                break;
            case "rb":
                var contenido = $("#modal-multi-content").val();
                var name = $("#modal-title").val().trim().replace(" ", "_");

                contenido.split(";").forEach(function (e, i) {
                    var container = $("<div class=\"form-check\">");

                    var label = $("<label class=\"form-check-label radio\">");
                    $(label).text(e);
                    var option = $("<input class=\"form-check-input\" type=\"radio\" >");
                    var id = "rb-" + $(element).attr("element-weight") + i;
                    $(option).attr("name", name);
                    $(option).attr("id", id);
                    $(label).attr("for", id);
                    $(option).val(e.trim());

                    $(container).append(option);
                    $(container).append(label);

                    $(element).find(".element-type").attr('element-type', 'radio').append(container);
                });

                break;
            case "txt":
            default:
                var el = $("<input type='text' class=\"form-control\" disabled>");
                $(element).find(".element-type").attr('element-type', 'text').append(el);
        }

        $(element).find('.element-tip').attr('data-original-title', $('#modal-tip').val());

        $(element).find('[data-toggle="tooltip"]').tooltip();

        $("#elements").show();

        $("#elements").append(element);

        $("#modal-title").val("");

        $('#modal-tip').val("");

        $("#modal-multi-content").val("");

        updateElements();

        $("#item-modal").modal("hide");
    })
</script>
</body>
</html>