<h5 class="border-bottom">Invitar usuario</h5>
<div class="section-content">
    <button class="btn btn-info"  data-toggle="modal"
            data-target="#invite-user-modal"><i class="fa fa-user-plus"></i> Invitar Usuario</button>
</div>

<h5 class="border-bottom">Editar usuario</h5>
<div class="section-content">
    <table class="table table-hover">
        <thead>
        <tr>
            <th scope="col">#</th>
            <th scope="col">Username</th>
            <th scope="col">Actions</th>
        </tr>
        </thead>
        <tbody>
        <#list users as user>
        <tr>
            <th scope="row">${user.id}</th>
            <td>${user.username!"not set yet"}</td>
            <td>
                <i class="far fa-edit" style="cursor:pointer" data-whatever="${user.id}" data-toggle="modal"
                   data-target="#user-info-modal"></i>
                <#if !(user.active??) || !user.active>
                    <i class="fa fa-ban" aria-hidden="true"></i>
                </#if>
            </td>
        </tr>
        </#list>

        </tbody>
    </table>
</div>
<h5 class="border-bottom">Asignar grupo</h5>
<div class="section-content">
    <div class="form-group">
        <label>Nombre de usuario</label>
        <input type="hidden" id="user-complete">
    </div>
    <div class="form-group">
        <label>Nombre del grupo</label>
        <input type="hidden" id="group-complete">
    </div>
    <button id="map-user" class="btn btn-success">Agregar</button>
</div>

<div id="invite-user-modal" class="modal fade" tabindex="-1" role="dialog" aria-hidden="true"
     aria-labelledby="inviteUserModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="userInfoModalLabel"></h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label>E-mail del usuario</label>
                    <input class="form-control" id="user-email">
                </div>
                <div class="form-group">
                    <label>Grupos del usuario</label>
                    <input type="hidden" id="user-group" multiple>
                </div>
                <div class="form-group">
                    <label>Roles del usuario</label>
                    <input type="hidden" id="user-roles">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
                <button class="btn btn-primary" type="button">Enviar</button>
            </div>
        </div>
    </div>
</div>

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
    $("#invite-user-modal .btn-primary").click(function(){

        var content = {};
        content.email = $("#user-email").val();
        content.groups = $("#user-group").val().split(",");
        content.roles = $("#user-roles").val().split(",");

        $.ajax({
            type: "POST",
            url: "<@spring.url '/admin/users/invite' />",
            beforeSend: function (xhr) {
                xhr.setRequestHeader('${_csrf.headerName}', "${_csrf.token}");
            },
            data: JSON.stringify(content),
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            success: function(data, textStatus, request) {
            }
        });
    });

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

    $("#user-complete").select2({
        ajax:{
            url: "<@spring.url "/admin/user/list.json"/>",
            data: function (term, page) {
                return {
                    q: term
                };
            },            dataType: "json",
            results: function (data, page) {
                return { results: data };
            }
        },
        width: "100%",
        minimumInputLength: 2,
        theme: "classic"
    });

    $("#user-roles").select2({
        ajax:{
            url: "<@spring.url "/admin/role/list.json"/>",
            data: function (term, page) { // page is the one-based page number tracked by Select2
                return {
                    q: term
                };
            },            dataType: "json",
            results: function (data, page) {
                return { results: data };
            }
        },
        width: "100%",
        multiple: true,
        minimumInputLength: 2,
        theme: "classic"
    });

    $("#user-group").select2({
        ajax:{
            url: "<@spring.url "/admin/group/list.json"/>",
            dataType: "json",
            data: function (term, page) {
                return {
                    q: term
                };
            },
            results: function (data, page) {
                return { results: data };
            }
        },
        width: "100%",
        multiple: true,
        minimumInputLength: 2,
        theme: "classic"
    });

    $("#group-complete").select2({
        ajax:{
            url: "<@spring.url "/admin/group/list.json"/>",
            dataType: "json",
            data: function (term, page) {
                return {
                    q: term
                };
            },
            results: function (data, page) {
                return { results: data };
            }
        },
        width: "100%",
        minimumInputLength: 2,
        theme: "classic"
    });
</script>
