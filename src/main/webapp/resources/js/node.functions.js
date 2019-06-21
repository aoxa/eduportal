var createSurveyContent = function() {
    var content = {};

    content.body = $("#editor").val();
    content.title = $("#titulo").val();
    content.limitDate = $("#limite").datepicker( "getDate" );
    content.elements = [];
    $("#elements .row").each(function (indice, e) {
        content.elements.push(createElement(e));
    });

    return content;
}

buildOptions = function(elementType, multiple, content, name) {
    if(name === undefined) {
        name = Math.random().toString(36).replace(/[^a-z]+/g, '').substr(0, 9) + '-';
    }
    var options = [];

    switch (elementType) {
        case "select":
            var el = $("<select class=\"form-control\">");
            if (multiple) {
                $(el).attr('multiple', 'multiple');
            }

            el.attr("name", name);

            content.split(";").forEach(function (e, i) {
                var option = $("<option>");
                $(option).val(e.trim());
                $(option).text(e.trim());
                $(el).append(option);
            });

            options.push(el);
            break;
        case "checkbox":
            content.split(";").forEach(function (e, i) {
                var container = $("<div class=\"form-check\">");

                var label = $("<label class=\"form-check-label\">");
                var option = $("<input class=\"form-check-input\" type=\"checkbox\" >");
                var id = "cb-" + name + i;

                $(label).text(e);
                $(label).attr("for", id);
                $(option).attr("id", id);
                $(option).attr("name", name);
                $(option).val(e.trim());

                $(container).append(option);
                $(container).append(label);

                options.push(container);
            });

            break;
        case "radio":
            content.split(";").forEach(function (e, i) {
                var container = $("<div class=\"form-check\">");

                var label = $("<label class=\"form-check-label radio\">");
                $(label).text(e);
                var option = $("<input class=\"form-check-input\" type=\"radio\" >");
                var id = "rb-" + name + i;
                $(option).attr("name", name);
                $(option).attr("id", id);
                $(label).attr("for", id);
                $(option).val(e.trim());

                $(container).append(option);
                $(container).append(label);

                options.push(container);
            });

            break;
        case "text":
        default:
            var el = $("<input type='text' class=\"form-control\" disabled>");
            options.push(el);
    }

    return options;
};

//noinspection JSAnnotator
function createElement(e, nombre, includeEmpty=true) {
    if(nombre === undefined) {
        nombre = Math.random().toString(36).replace(/[^a-z]+/g, '').substr(0, 9) + '-' + $(e).attr('element-weight');;
    }
    var element = new Object();
    element.weight = parseInt($(e).attr('element-weight'));
    element.name = nombre;
    element.title = $(e).find(".element-title").text();
    element.tip = $(e).find('.element-tip').attr('data-original-title');
    element.options = [];

    var elementType = $(e).find(".element-type").attr('element-type');

    switch (elementType) {
        case 'radio':
            element.type = 'select';
            element.radioButton = true;
            $(e).find('input[type=radio]').each(function (i, e) {
                var isChecked = $(e).is(':checked');
                if(isChecked){
                    var value = {};
                    value.type = "option"
                    value.name = $(e).val();
                    value.title = $(e).val();
                    value.value = $(e).val();
                    value.selected = true;
                    element.options.push(value);
                }
                if( includeEmpty && !isChecked) {
                    var value = {};
                    value.type = "option"
                    value.name = $(e).val();
                    value.title = $(e).val();
                    value.value = $(e).val();
                    value.selected = false;
                    element.options.push(value);
                }
            });
            break;
        case 'checkbox':
            element.type = 'select';
            element.checkBox = true;

            $(e).find('input[type=checkbox]').each(function (i, e) {
                var isChecked = $(e).is(':checked');
                if(isChecked){
                    var value = {};
                    value.type = "option"
                    value.name = $(e).val();
                    value.title = $(e).val();
                    value.value = $(e).val();
                    value.selected = true;
                    element.options.push(value);
                }
                if( includeEmpty && !isChecked) {
                    var value = {};
                    value.type = "option"
                    value.name = $(e).val();
                    value.title = $(e).val();
                    value.value = $(e).val();
                    value.selected = false;
                    element.options.push(value);
                }
            });
            break;
        case 'select':
            element.type = 'select';
            var attr = $(e).find("select").attr('multiple')
            element.multivalued = (typeof attr !== typeof undefined)

            $(e).find('option').each(function (i, option) {
                if($(option).is(':selected')){
                    var value = {};
                    value.type = "option"
                    value.name = $(option).val();
                    value.title = $(option).val();
                    value.value = $(option).val();
                    value.selected = true;
                    element.options.push(value);
                } else if( includeEmpty) {
                    var value = {};
                    value.type = "option"
                    value.name = $(option).val();
                    value.title = $(option).val();
                    value.value = $(option).val();
                    value.selected = false;
                    element.options.push(value);
                }

            });
            break;
    }

    return element;
};

