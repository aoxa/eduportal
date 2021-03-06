<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Crear nueva asignatura</title>

    <link href="${contextPath}/resources/css/bootstrap.min.css" rel="stylesheet">
    <link href="${contextPath}/resources/css/common.css" rel="stylesheet">
    <link href="https://use.fontawesome.com/releases/v5.8.2/css/all.css" rel="stylesheet"
          integrity="sha384-oS3vJWv+0UjzBfQzYUhtDYW+Pj2yciDJxpsK1OYPAYjqT085Qq/1cq5FLXAZQ7Ay" crossorigin="anonymous">
    <link href='https://cdn.jsdelivr.net/npm/froala-editor@2.9.5/css/froala_editor.min.css' rel='stylesheet'
          type='text/css'/>
    <link href='https://cdn.jsdelivr.net/npm/froala-editor@2.9.5/css/froala_style.min.css' rel='stylesheet'
          type='text/css'/>

    <script src="https://code.jquery.com/jquery-2.2.0.js"></script>
    <script src="https://code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
    <script src="${contextPath}/resources/js/bootstrap.bundle.min.js"></script>
    <script src='https://cdn.jsdelivr.net/npm/froala-editor@2.9.5/js/froala_editor.min.js'></script>

    <style>
        #elements {
            background-color: white;
            border-radius: .3rem;
            webkit-box-shadow: 0 1px 3px rgba(0, 0, 0, .12), 0 1px 1px 1px rgba(0, 0, 0, .16);
            -moz-box-shadow: 0 1px 3px rgba(0, 0, 0, .12), 0 1px 1px 1px rgba(0, 0, 0, .16);
            box-shadow: 0 1px 3px rgba(0, 0, 0, .12), 0 1px 1px 1px rgba(0, 0, 0, .16);
        }

        .element {
            padding: 10px 0 10px;
        }
    </style>
</head>
<body>
<jsp:include page="../nav-bar.jsp"/>
<main role="main" class="container">

    <h1 class="mt-5">Agregar nueva asignatura</h1>

    <div class="row">
        <h3>Ingrese el titulo de la asignatura</h3>
        <input id="titulo" type="text" class="form-control" placeholder="Ingrese el titulo aqui">
    </div>
    <div class="row">
        <textarea id="editor"></textarea>
    </div>
    <div id="elements" style="display: none;">

    </div>
    <input type="hidden"
           name="${_csrf.parameterName}"
           value="${_csrf.token}"/>
    <button id="publish" type="button" class="btn btn-primary">Publicar asignatura</button>
</main>
<!-- Button trigger modal -->

<button id="fab-add" data-original-title="Agregar nuevo elemento" data-placement="top" type="button"
        class="btn btn-primary btn-circle btn-xl"
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
<script>
    updateElements = function () {
        var panelList = $('#elements');
        panelList.sortable({
            // Only make the .panel-heading child elements support dragging.
            // Omit this to make then entire <li>...</li> draggable.
            handle: '.panel-heading',
            update: function (event, ui) {
                $('.element', panelList).each(function (index, elem) {
                    $(elem).attr("element-weight", index);
                });
            }
        });
    };

    var createElement = function (e, nombre) {
        var nombre = Math.random().toString(36).replace(/[^a-z]+/g, '').substr(0, 9) + '-';
        var element = new Object();
        element.weight = parseInt($(e).attr('element-weight'));
        element.name = nombre + $(e).attr('element-weight');
        element.title = $(e).find(".element-title").text();
        element.tip = $(e).find('.element-tip').attr('data-original-title');
        element.options = [];

        var elementType = $(e).find(".element-type").attr('element-type');

        switch (elementType) {
            case 'radio':
                element.type = 'select';
                element.radioButton = true;
                $(e).find('input[type=radio]').each(function (i, e) {
                    var value = {};
                    value.type = "option"
                    value.name = $(e).val();
                    value.title = $(e).val();
                    value.value = $(e).val();
                    value.selected = $(e).is(':checked');
                    element.options.push(value);
                });
                break;
            case 'checkbox':
                element.type = 'select';
                element.checkBox = true;

                $(e).find('input[type=checkbox]').each(function (i, e) {
                    var value = {};
                    value.type = "option";
                    value.name = $(e).val();
                    value.title = $(e).val();
                    value.value = $(e).val();
                    value.selected = $(e).is(':checked');
                    element.options.push(value);
                });
                break;
            case 'select':
                element.type = 'select';
                var attr = $(e).find("select").attr('multiple')
                element.multivalued = (typeof attr !== typeof undefined)

                $(e).find('option').each(function (i, option) {
                    var value = {};
                    value.type = "option";
                    value.name = $(option).val();
                    value.title = $(option).val();
                    value.value = $(option).val();
                    value.selected = $(option).is(':selected');
                    element.options.push(value);
                });
                break;
        }

        return element;
    };

    $(function () {
        $('#editor').froalaEditor({width: '100%', placeholderText: 'Ingrese una descripcion para la asignatura'});
        $('#fab-add').tooltip();
        $("#publish").click(function () {

            var content = {};

            content.body = $("#editor").val();
            content.description = $("#editor").val();
            content.title = $("#titulo").val();
            content.elements = [];
            $("#elements .row").each(function (indice, e) {
                content.elements.push(createElement(e));
            });

            $.ajax({
                type: "POST",
                url: "/${course.id}/${type}/add",
                beforeSend: function (xhr) {
                    xhr.setRequestHeader('${_csrf.headerName}', "${_csrf.token}");
                },
                data: JSON.stringify(content),
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json'
                },
                success: function(data, textStatus, request) {
                    window.location = request.getResponseHeader('location');
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