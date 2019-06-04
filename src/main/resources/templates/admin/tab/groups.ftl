<h5 class="border-bottom">Grupos</h5>
<div>
    <div class="form-group">
    <#if ! groups?has_content>
        No hay groupos cargados
    </#if>
    <#list groups as group>
        <div>${group.name} <i class="far fa-edit"></i></div>
    </#list>
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
    </#if>
    <#list roles as role>
        <div>${role.name}</div>
    </#list>
    </div>
</div>

<!-- modals -->
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

    $("#add-group").click(function () {
        console.log("click");
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
            }
        });

        return false;
    })
</script>
