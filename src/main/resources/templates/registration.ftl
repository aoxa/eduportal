<#import "/spring.ftl" as spring />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title><@spring.message "registration.head.title" /></title>
    <#include "includes/head-includes.ftl" />
</head>

<body>

<div class="container">

    <form method="POST" class="form-register">
    <@spring.bind "form" />
        <h4 class="form-signin-heading">${i18n("registration.greeting", [form.user.email!""])}</h4>
    <@spring.formHiddenInput "form.user.id" />
    <@spring.formHiddenInput "form.user.roles" />
    <@spring.formHiddenInput "form.user.groups" />
    <@spring.formHiddenInput "form.user.email" />
        <input type="hidden" id="user.active" name="user.active" value="true">

        <div class="form-group row">
            <label class="col-sm-6"><@spring.message "login.username" /></label>
            <div class="col-sm-6">
            <@spring.formInput "form.user.username" "class='form-control'"/>
            <@spring.showErrors "" />
            </div>
        </div>
        <div class="form-group row">
            <label class="col-sm-6"><@spring.message "registration.nombre" /></label>
            <div class="col-sm-6">
            <@spring.formInput "form.user.name" "class='form-control'"/>
            <@spring.showErrors "" />
            </div>
        </div>
        <div class="form-group row">
            <label class="col-sm-6"><@spring.message "registration.lastname" /></label>
            <div class="col-sm-6">
            <@spring.formInput "form.user.lastName" "class='form-control'"/>
            <@spring.showErrors "" />
            </div>
        </div>
        <div class="form-group row">
            <label class="col-sm-6"><@spring.message "registration.password" /></label>
            <div class="col-sm-6">
            <@spring.formPasswordInput "form.user.password" "class='form-control'"/>
            <@spring.showErrors "" />
            </div>
        </div>
        <div class="form-group row">
            <label class="col-sm-6"><@spring.message "registration.repassword" /></label>
            <div class="col-sm-6">
            <@spring.formPasswordInput "form.user.passwordConfirm" "class='form-control'"/>
            <@spring.showErrors "" />
            </div>
        </div>
        <#if isParent>
        <div id="children">
            <#if form.children?has_content>
            <#list form.children as child>
                <div class="child">
                    <div class="form-group row">
                        <label class="col-sm-6"><@spring.message "registration.child.name" /></label>
                        <div class="col-sm-6 input-group">
            <@spring.formInput "form.children[${child?index}].name" "class='form-control'"/>
            <@spring.showErrors "" />
                        <#if child?index == (form.children?size - 1)>
                            <div class="input-group-append">
                                <button id="add-child" class="btn btn-outline-success" type="button">+</button>
                            </div>
                        <#else>
                            <div class="input-group-append">
                                <button class="remove-child btn btn-outline-danger" type="button">-</button>
                            </div>
                        </#if>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-6"><@spring.message "registration.child.email" /></label>
                        <div class="col-sm-6">
            <@spring.formInput "form.children[${child?index}].email" "class='form-control'"/>
            <@spring.showErrors "" />
                        </div>
                    </div>
                </div>
            </#list>
            <#else >
                <div class="child">
                    <div class="form-group row">
                        <label class="col-sm-6"><@spring.message "registration.child.name" /></label>
                        <div class="col-sm-6 input-group">
                        <@spring.formInput "form.children[0].name" "class='form-control'"/>
                            <div class="input-group-append">
                                <button id="add-child" class="btn btn-outline-success" type="button">+</button>
                            </div>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-6"><@spring.message "registration.child.email" /></label>
                        <div class="col-sm-6">
                        <@spring.formInput "form.children[0].email" "class='form-control'"/>
                        </div>
                    </div>
                </div>
            </#if>

        </div>
        </#if>

        <input type="hidden"
               name="${_csrf.parameterName}"
               value="${_csrf.token}"/>

        <button class="btn btn-lg btn-primary btn-block"
                type="submit"><@spring.message "registration.submit" /></button>
    </form>

</div>
<script>
    var index = ${form.children?size};

    $("#add-child").click(function () {
        var $wrapper = $("<div>").addClass("child");
        var $row = $("<div>").addClass("row").addClass("form-group");
        var $label = $("<label>").addClass("col-sm-6");
        var $input = $("<div>").addClass("col-sm-6");
        var $remove = $("<div>").addClass("input-group-append")
                .append($("<button>")
                        .attr("type", "button")
                        .addClass("remove-child")
                        .addClass("btn")
                        .addClass("btn-outline-danger")
                        .text("-"));

        var label = $label.clone().text('<@spring.message "registration.child.email" />');

        var input = $input.clone().append($("<input>").addClass("form-control").attr("name", "children[" + index + "].email"));

        $wrapper.prepend($row.clone().append(label).append(input));


        label = $label.clone().text("<@spring.message "registration.child.name" />");

        input = $input.clone().addClass("input-group").append($("<input>").addClass("form-control")
                .attr("name", "children[" + index + "].name")).append($remove);

        $wrapper.prepend($row.clone().append(label).append(input));

        $("#children").prepend($wrapper);

        index++;

        appendRemoveChildHandlers();

        return false;
    });

    function appendRemoveChildHandlers() {
        $(".remove-child").unbind("click");

        $(".remove-child").click(function () {
            var childName = $(this).closest(".input-group").find("input.form-control");

            var num = childName.attr("name").replace("children[","").replace("].name", "");

            var childEmail = $("input[name='"+childName.attr("name").replace(".name", ".email")+"']");

            $(this).closest(".child").remove();

            console.log(index);

            for(var i = parseInt(num)+1; i < index; i++) {
                var prefix = 'children['+i+'].';
                var updatedPrefix = 'children['+(i-1)+'].';

                $("input[name='"+prefix+"name'").attr("name", updatedPrefix+'name');
                $("input[name='"+prefix+"email'").attr("name", updatedPrefix+'email');
            }

            index -= 1;
        });
    }

</script>

</body>
</html>