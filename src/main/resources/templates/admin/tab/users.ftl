<h5 class="border-bottom">Invitar usuario</h5>
<#list users as user>
<div>${user.username} <i class="far fa-edit" data-whatever="${user.id}" data-toggle="modal"
                         data-target="#user-info-modal"></i></div>
</#list>
<h5 class="border-bottom">Asignar grupo</h5>
<div class="form-group">
    <label>Nombre de usuario</label>
    <input class="form-control" id="user-complete">
</div>
<div class="form-group">
    <label>Nombre del grupo</label>
    <input class="form-control" id="group-complete">
</div>
<button id="map-user" class="btn btn-success">Agregar</button>


<div id="user-info-modal" class="modal fade" tabindex="-1" role="dialog" aria-hidden="true"
     aria-labelledby="userInfoModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="userInfoModalLabel"></h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <h6>Grupos del usuario</h6>
                <div id="group-info" class="row">
                </div>
                <h6>Roles del usuario</h6>
                <div id="role-info" class="row">
                </div>
            </div>
            <div class="modal-footer">
            </div>
        </div>
    </div>
</div>

<script>
    $("#map-user").click(function () {
        var user = $("#user-complete").val();
        var group = $("#group-complete").val();
        $.get("<@spring.url "/admin/users/map" />?user=" + user + "&group=" + group);
    });

    $('#user-info-modal').on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget) // Button that triggered the modal
        var userId = button.data('whatever') // Extract info from data-* attributes

        var $modal = $(this);
        $modal.find("#role-info").empty();
        $modal.find("#group-info").empty();

        $.get("<@spring.url "/api/users/" />" + userId + ".json", function (data) {
            $modal.find("#userInfoModalLabel").text(data.username);
            var roles = new Set();
            console.log(data.groups);
            for (var i = 0; i < data.groups.length; i++) {
                var group = data.groups[i];

                var $element = $("<div>");
                $element.addClass("col-sm-4");
                $element.text(group.name);
                for (var j = 0; j < group.roles.length; j++) {
                    var role = group.roles[j];
                    roles.add(role.name);
                }
                $modal.find("#group-info").append($element);
            }

            for (var i = 0; i < data.roles.length; i++) {
                roles.add(data.roles[i].name);
            }

            roles.forEach(function (role) {
                var $element = $("<div>");
                $element.addClass("col-sm-4");
                $element.text(role);
                $modal.find("#role-info").append($element);
            });
        });
    });

    input = document.getElementById("user-complete");

    new Awesomplete(input, {
        list: [
        <#list users as user>
            {label: "${user.username}", value: "${user.id}"}<#if !user?is_last>,</#if>
        </#list>]
    });

    input = document.getElementById("group-complete");

    new Awesomplete(input, {
        list: [
        <#list groups as group>
            {label: "${group.name}", value: "${group.id}"}<#if !group?is_last>,</#if>
        </#list>]
    });
</script>
