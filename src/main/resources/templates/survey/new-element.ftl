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

    <script src='https://cdn.jsdelivr.net/npm/froala-editor@2.9.5/js/froala_editor.min.js'></script>
    <script src="<@spring.url '/resources/js/node.functions.js' />"></script>
</head>
<body>
<#assign subNavbar = true />
<#include "../includes/nav-bar.ftl" />

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
                                           value="${option.value}" <#if option.selected>checked</#if>>
                                    <label class="form-check-label">${option.name}</label>
                                </div>
                            </#list>
                        </div>
                    <#elseif element.checkBox>
                        <div class="element-type col-sm-5" element-type="checkbox">
                            <#list element.options as option>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="${element.name}"
                                           value="${option.value}" <#if option.selected>checked</#if>>
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
                    <i class="far fa-edit" data-element="#element-skeleton-${element.id}"
                       data-toggle="modal" data-target="#edit-item-modal"></i>
                    <i class="fa fa-trash" data-element="#element-skeleton-${element.id}"
                       data-toggle="modal" data-target="#element-remove-modal"></i>
                </div>
            </div>
        </#list>
    </#if>
    </div>

    <button id="publish" type="button" class="btn btn-primary"><#if node??>Actualizar<#else>Publicar</#if> asignatura</button>
</main>

<!-- Button trigger modal -->
<button id="fab-add" data-original-title="Agregar nuevo elemento" data-placement="top" type="button"
        class="btn btn-primary bottom-right-floating btn-circle btn-xl"
        data-toggle="modal" data-target="#item-modal">+
</button>

<@modal modalId="element-remove-modal" header="Eliminar elemento"
content="La accion no se puede deshacer, esta seguro?<input type=\"hidden\" id=\"remove-element-id\">"
footerCancel="Cerrar" footerAccept="Eliminar"
/>

<@modal modalId="edit-item-modal" header="Editar elemento"
content="<div id='form-group'><label>Titulo</label><input id='edit-title' class='form-control'>
             <label>Opciones, separadas por punto y coma</label><input class='form-control' id='edit-options'></div>"
footerCancel="Cerrar" footerAccept="Actualizar" />

<@modal modalId="item-modal" header="Agregue un elemento"
content='<label>Tipo de elemento</label>
                <select id="modal-type" class="form-control">
                    <option value="checkbox">Opcion multiple</option>
                    <option value="radio">Opcion unica</option>
                    <option value="select">Opcion unica, desplegable</option>
                    <option value="mselect">Opcion multiple, desplegable</option>
                    <option value="text">Texto</option>
                </select>
                <label>Pregunta/Titulo del elemento</label>
                <input id="modal-title" class="form-control" type="text">
                <label>Tip o ayuda</label>
                <textarea id="modal-tip" class="form-control"></textarea>
                <div id="modal-multi">
                    <label>Agregue las opciones, separadas por punto y coma</label>
                    <textarea id="modal-multi-content" class="form-control"></textarea>
                </div>'
footerAccept="Agregar" footerCancel="Cerrar"/>

<div id="element-skeleton" class="row" style="display:none;">
    <div class="col-sm-1 panel-heading"><i class="fas fa-arrows-alt-v"></i></div>
    <div class="element-title col-sm-5"></div>
    <div class="element-type col-sm-5"></div>
    <div class="col-sm-1">
        <i data-toggle="tooltip" class="far fa-question-circle element-tip" data-original-title=""
           data-placement="right"></i>
        <i class="far fa-edit"  data-element="" data-toggle="modal" data-target="#edit-item-modal"></i>
        <i class="fa fa-trash"  data-element="" data-toggle="modal" data-target="#element-remove-modal"></i>
    </div>
</div>


<script type="application/javascript">
    var updateWeight = function() {
        console.log("bla")
        $('.element', $('#elements')).each(function (index, elem) {
            $(elem).attr("element-weight", index);
        });
    };

    var updateElements = function () {
        $('#elements').sortable({
            handle: '.panel-heading',
            update: updateWeight
        });
    };

    $("#element-remove-modal").on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget);
        var elementId = button.data('element');

        $(this).find("#remove-element-id").val(elementId);
    });

    $("#element-remove-modal .btn-primary").click(function() {
        $("#element-remove-modal").modal("toggle");

        $($("#element-remove-modal #remove-element-id").val()).remove();

        updateWeight();
    });

    $('#edit-item-modal').on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget);
        var elementId = button.data('element');

        $("#edit-title").val($(elementId).find(".element-title").text());

        var etype = $(elementId).find(".element-type").attr("element-type");
        var options = [];
        var name = "";
        switch (etype){
            case "radio":
            case "checkbox":
                $(elementId + " .element-type input").each(function(index,el){
                    name = $(el).attr("name");
                    options.push($(el).val());
                });
                break;
            case "select":
                $(elementId + "select").attr("name");
                $(elementId + " .element-type option").each(function(index,el){
                    options.push($(el).val());
                });
                break;
            default:
                break;
        }

        $("#edit-options").val(options.join(";"));
        $("#edit-options").attr("name", name);
        $("#edit-options").attr("element-type", etype);
        $("#edit-options").attr("element-selector", elementId);

    });

    $('#edit-item-modal .btn-primary').click(function () {
        var $element = $($("#edit-options").attr("element-selector"));
        var etype = $("#edit-options").attr("element-type");
        var multiple = etype === "select" && $element.find("select").attr("multiple") === "multiple";
        $element.find(".element-title").text($("#edit-title").val());
        $element.find(".element-type").empty().append(buildOptions(etype, multiple,$("#edit-options").val()));

        updateElements();

        $("#edit-item-modal").modal("hide");
    });

    $(function () {
        updateElements();

        $("#limite").datepicker({
            dateFormat: "dd/mm/yy",
            minDate: new Date()
        });

        $('#editor').froalaEditor({width: '100%', placeholderText: 'Ingrese una descripcion para la asignatura'});

        $('#fab-add').tooltip();

        $("#publish").click(function () {

            var content = createSurveyContent();

            var xhr = $.ajax({
            <#if node??>
                type: "PUT",
                url: "<@spring.url '/${course.id}/${nodeDescriptor(node).type}/${node.id}' />",
            <#else>
                type: "POST",
                url: "<@spring.url '/${course.id}/${type}/add' />",
            </#if>
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

    var itemId = $("#elements .element").length;

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
        var id = $(element).attr("id") + "-new-" + itemId;

        $(element).find(".fa-edit").attr("data-element", "#"+id);
        $(element).find(".fa-trash").attr("data-element", "#"+id);

        $(element).attr("id", id);
        $(element).addClass("element");
        $(element).attr("element-weight", itemId);
        $(element).removeAttr("style", "");
        $(element).find(".element-title").append($("#modal-title").val());

        itemId++;

        var elementType = $("#modal-type").val();
        var multiple = elementType === "mselect";

        if(multiple) {
            elementType = elementType.substr(1);
        }

        $(element).find(".element-type").append(buildOptions(elementType, multiple, $("#modal-multi-content").val()));

        $(element).find(".element-type").attr('element-type', elementType);

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