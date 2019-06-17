<h5 class="border-bottom">Grupos</h5>
<div>
    <div id="group-list-content" class="form-group">
    <#include "partial/group-list.ftl" />
    </div>
    <button data-original-title="Agregar nuevo elemento" data-placement="top" type="button"
            class="btn btn-info" id="add-group-button"
            data-toggle="modal" data-target="#group-modal">
        <i class="fas fa-users"></i> Agregar grupo
    </button>
</div>
<h5 class="border-bottom">Roles</h5>
<div>
    <div class="form-group">
    <#if ! roles?has_content>
        No hay roles cargados
    <#else>
        <table class="table table-hover">
            <thead>
            <tr>
                <th scope="col">#</th>
                <th scope="col">Role Name</th>
            </tr>
            </thead>
            <tbody>
                <#list roles as role>
                <tr>
                    <th scope="row">${role.id}</th>
                    <td>${role.name}</td>
                </tr>
                </#list>
            </tbody>
        </table>
    </#if>
    </div>
</div>

<!-- modals -->
<@modal modalId="group-remove-modal" header="Eliminar grupo" content='El grupo sera eliminado. Esta seguro?'
footerCancel="No" footerAccept="Si"
></@modal>

<@modal modalId="group-modal" header="Agregar un grupo"
content='<label>Nombre</label><input class="form-control" name="name" type="text">
             <label>Roles del grupo</label><input type="hidden" id="addGroupRoles" class="awesomplete"/>
                <div id="roles" class="row">
                </div>' footerCancel="Cerrar" footerAccept="Crear"/>

<script>

    var input = document.getElementById("name");

    $("#addGroupRoles").select2({
        ajax: {
            url: "<@spring.url "/admin/role/list.json"/>",
            data: function (term, page) { // page is the one-based page number tracked by Select2
                return {
                    q: term
                };
            }, dataType: "json",
            results: function (data, page) {
                return {results: data};
            }
        },
        width: "100%",
        multiple: true,
        minimumInputLength: 2,
        theme: "classic"
    });

    new Awesomplete(input, {
        list: [
        <#list roles as role>
            {label: "${role.name}", value: "${role.id}"}<#if !role?is_last>,</#if>
        </#list>]
    });

    $("#name").on('awesomplete-selectcomplete', function (e) {
        var item = e.originalEvent.text;

        var element = $("<div>");
        $(element).addClass("col-sm-3");
        $(element).attr("role-id", item.value);
        $(element).text(item.label);
        var icon = $("<i>").addClass("far").addClass("fa-window-close").addClass("float-right");
        $(icon).attr("style", "margin-top: 5px;");
        $(element).append(icon);


        $(".modal-body #roles").append(element);

        $(".far.fa-window-close").click(function () {
            $(this).parent().detach();
        });

        $("#name").val("");
    });

    $('#group-remove-modal').on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget) // Button that triggered the modal
        var groupId = button.data('whatever') // Extract info from data-* attributes

        $("#remove-group").attr("group-to-remove", groupId);
    });

    $("#remove-group").click(function () {
        var groupId = $("#remove-group").attr("group-to-remove");

        var url = "<@spring.url "/admin/groups/remove/" />" + groupId;

        $.get(url, function (data) {
            $("#group-list-content").html(data);
        });

        $("#group-remove-modal").modal('toggle');
    });

    $("#add-group").click(function () {
        var content = {};
        content.name = $("input[name='name']").val();
        content.roles = [];
        $("#roles div").each(function (i, e) {
            content.roles.push($(e).attr("role-id"));
        });

        $("#roles div").detach();
        $("input[name='name']").val("");

        $.ajax({
            type: "POST",
            url: "<@spring.url '/admin/users/groups/add' />",
            data: JSON.stringify(content),
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            beforeSend: function (xhr) {
                xhr.setRequestHeader('${_csrf.headerName}', "${_csrf.token}");
            },
            success: function (data) {
                $("#group-modal").modal('toggle');
                $("#group-list-content").html(data);
            }
        });

        return false;
    })
</script>
