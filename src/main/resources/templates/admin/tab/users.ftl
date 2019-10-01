<h5 class="border-bottom">Invitar usuario</h5>
<div class="section-content">
    <button class="btn btn-info" data-toggle="modal"
            data-target="#invite-user-modal"><i class="fa fa-user-plus"></i> Invitar Usuario
    </button>
</div>

<h5 class="border-bottom">Editar usuario</h5>
<div class="section-content" id="user-listing">
<#include "partial/user-list.ftl" />
</div>
<#assign url><@spring.url "/admin/users/list" /></#assign>
<@pagination id="user-paginator" paginator=users url=url result="user-listing"/>

<h5 class="border-bottom">Asignar grupo</h5>
<div class="section-content">
    <div class="form-group">
        <label>Nombre de usuario</label>
        <input type="hidden" class="user-complete" >
    </div>
    <div class="form-group">
        <label>Nombre del grupo</label>
        <input type="hidden" class="group-complete">
    </div>
    <button id="map-user" class="btn btn-success">Agregar</button>
</div>
<h5 class="border-bottom">Asignar rol</h5>
<div class="section-content">
    <div class="form-group">
        <label>Nombre de usuario</label>
        <input type="hidden" class="user-complete" >
    </div>
    <div class="form-group">
        <label>Nombre del rol</label>
        <input type="hidden" class="role-complete" >
    </div>
    <button id="map-user-rol" class="btn btn-success">Agregar</button>
</div>

<@modal modalId='user-remove-modal' header='' content='Desea eliminar el usuario?' footerAccept='Eliminar'
footerCancel='Cerrar' ></@modal>

<@modal modalId="invite-user-modal" header=""
content='<div class="form-group"><label>E-mail del usuario</label>
                    <input class="form-control" id="user-email"></div>
                <div class="form-group"><label>Grupos del usuario</label>
                    <input type="hidden" id="user-group" multiple></div>
                <div class="form-group"><label>Roles del usuario</label>
                    <input type="hidden" id="user-roles"></div>'
footerAccept="Invitar" footerCancel="Cerrar"
></@modal>

<@modal modalId="user-info-modal" header=''
content='<h6>Grupos del usuario</h6><div id="group-info" class="row"></div>
                <h6>Roles del usuario</h6><div id="role-info" class="row"></div>'
></@modal>

<script>
    $("#invite-user-modal").on('shown.bs.modal', function () {
        $(this).find('.btn-primary').removeAttr("disabled");
    });

    $("#invite-user-modal .btn-primary").click(function () {
        $(this).attr("disabled", "disabled");

        var content = {};

        content.email = $("#user-email").val();

        if($("#user-group").val().trim().length > 0) {
            content.groups = $("#user-group").val().split(",");
        }
        if($("#user-roles").val().trim().length > 0) {
            content.roles = $("#user-roles").val().split(",");
        }

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
            success: function (data, textStatus, request) {
                $("#invite-user-modal").modal('toggle')
            }
        });
    });

    $("#map-user").click(function () {
        var $section = $(this).closest(".section-content");

        var user = $section.find("input.user-complete").val();
        var group = $section.find("input.group-complete").val();

        $.get("<@spring.url "/admin/users/map" />?user=" + user + "&group=" + group);
    });

    $("#map-user-rol").click(function () {
        var $section = $(this).closest(".section-content");

        var user = $section.find("input.user-complete").val();
        var role = $section.find("input.role-complete").val();

        $.get("<@spring.url "/admin/users/map" />?user=" + user + "&role=" + role);
    });

    $("#user-remove-modal .btn-primary").click(function () {
        var userId = $("#user-remove-modal .btn-primary").attr("to-remove");
        $.ajax({
            type: "DELETE",
            url: "<@spring.url '/admin/users' />/" + userId,
            beforeSend: function (xhr) {
                xhr.setRequestHeader('${_csrf.headerName}', "${_csrf.token}");
            },
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            success: function (data, textStatus, request) {
                $("#user-listing").html(data);
                $("#user-remove-modal").modal('toggle')
            }
        });
    });

    $('#user-remove-modal').on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget) // Button that triggered the modal
        var userId = button.data('userid');
        var username = button.data('username');
        $("#user-remove-modal .btn-primary").attr("to-remove", userId);
        $("#user-remove-modal .modal-title").text("Eliminar usuario " + username);
    });

    $('#user-info-modal').on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget) // Button that triggered the modal
        var userId = button.data('userid') // Extract info from data-* attributes
        var username = button.data('username') // Extract info from data-* attributes

        var $modal = $(this);
        $modal.find("#role-info").empty();
        $modal.find("#group-info").empty();
        $modal.find(".modal-title").text("Informacion de " + username);

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

    $(".user-complete").select2({
        ajax: {
            url: "<@spring.url "/admin/user/list.json"/>",
            data: function (term, page) {
                return {
                    q: term
                };
            }, dataType: "json",
            results: function (data, page) {
                return {results: data};
            }
        },
        width: "100%",
        minimumInputLength: 2,
        theme: "classic"
    });

    $(".role-complete").select2({
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
        multiple: false,
        minimumInputLength: 2,
        theme: "classic"
    });

    $("#user-roles").select2({
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

    $("#user-group").select2({
        ajax: {
            url: "<@spring.url "/admin/group/list.json"/>",
            dataType: "json",
            data: function (term, page) {
                return {
                    q: term
                };
            },
            results: function (data, page) {
                return {results: data};
            }
        },
        width: "100%",
        multiple: true,
        minimumInputLength: 2,
        theme: "classic"
    });

    $(".group-complete").select2({
        ajax: {
            url: "<@spring.url "/admin/group/list.json"/>",
            dataType: "json",
            data: function (term, page) {
                return {
                    q: term
                };
            },
            results: function (data, page) {
                return {results: data};
            }
        },
        width: "100%",
        minimumInputLength: 2,
        theme: "classic"
    });
</script>
