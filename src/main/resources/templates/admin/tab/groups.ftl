<h5 class="border-bottom">Grupos</h5>
<div>
    <div id="group-list-content" class="form-group">
    <#include "partial/group-list.ftl" />
    </div>
    <button data-original-title="Agregar nuevo elemento" data-placement="top" type="button"
            class="btn btn-primary" id="add-group-button"
            data-toggle="modal" data-target="#group-modal">
        Agregar nuevo
    </button>
</div>
<h5 class="border-bottom">Roles</h5>
<div>
    <div class="form-group">
    <#if ! roles?has_content>
        No hay groupos cargados
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
<div id="group-remove-modal" class="modal fade" tabindex="-1" role="dialog" aria-hidden="true"
     aria-labelledby="groupModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="groupModalLabel">Eliminar grupo</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                El grupo sera eliminado. Esta seguro?
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
                <button id="remove-group" class="btn btn-primary" type="button">Si</button>
            </div>
        </div>
    </div>
</div>

<div id="group-modal" class="modal fade" tabindex="-1" role="dialog" aria-hidden="true"
     aria-labelledby="groupModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">

                <h5 class="modal-title" id="groupModalLabel">Agregue un grupo</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <label>Elija un nombre</label>
                <input class="form-control" name="name" type="text">
                <label>Agregue los roles del grupo</label>
                <input class="form-control" id="name" class="awesomplete"/>
                <div id="roles" class="row">

                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                <button id="add-group" class="btn btn-primary" type="button">Submit</button>
            </div>
        </div>
    </div>
</div>

<script>
    var input = document.getElementById("name");

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
