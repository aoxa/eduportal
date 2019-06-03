<#import "/spring.ftl" as spring />

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" href="../../../../favicon.ico">

    <title>Dashboard Template for Bootstrap</title>

    <link rel="canonical" href="https://getbootstrap.com/docs/4.0/examples/dashboard/">

    <!-- Bootstrap core CSS -->
    <link href="<@spring.url '/resources/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="<@spring.url '/resources/css/awesomplete.css' />" rel="stylesheet">

    <link href="https://use.fontawesome.com/releases/v5.8.2/css/all.css" rel="stylesheet"
          integrity="sha384-oS3vJWv+0UjzBfQzYUhtDYW+Pj2yciDJxpsK1OYPAYjqT085Qq/1cq5FLXAZQ7Ay" crossorigin="anonymous">

    <link href="<@spring.url '/resources/css/dashboard.css' />" rel="stylesheet">
    <script src="<@spring.url '/resources/js/awesomplete.js' />"></script>
</head>

<body>
<#include "topbar.ftl" />

<div class="container-fluid">
    <div class="row">
        <nav class="col-md-2 d-none d-md-block bg-light sidebar">
        <#assign active = "users" />
        <#include "sidebar.ftl" />
        </nav>

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 pt-3 px-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pb-2 mb-3 border-bottom">
                <h1 class="h2">Users</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <div class="btn-group mr-2">
                    </div>
                </div>
            </div>

            <nav>
                <div class="nav nav-tabs" id="nav-tab" role="tablist">
                    <a class="nav-item nav-link active" id="nav-home-tab" data-toggle="tab" href="#nav-users" role="tab"
                       aria-controls="nav-users" aria-selected="true">Usuarios</a>
                    <a class="nav-item nav-link" id="nav-profile-tab" data-toggle="tab" href="#nav-groups" role="tab"
                       aria-controls="nav-groups" aria-selected="false">Grupos</a>
                </div>
            </nav>
            <div class="tab-content" id="nav-tabContent">
                <div class="tab-pane fade show active" id="nav-users" role="tabpanel" aria-labelledby="nav-home-users">
                    <h5 class="border-bottom">Invitar usuario</h5>
                <#list users as user>
                    <div>${user.username}</div>
                </#list>
                    <h5 class="border-bottom">Asignar grupo</h5>
                    <input id="user-complete">
                    <input id="group-complete">

                </div>
                <div class="tab-pane fade" id="nav-groups" role="tabpanel" aria-labelledby="nav-profile-group">
                <#include "tab/groups.ftl" />
                </div>
            </div>
        </main>
    </div>
</div>


<!-- modals -->
<div class="modal fade" id="group-modal" tabindex="-1" role="dialog" aria-hidden="true"
     aria-labelledby="groupModalLabel" >
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


<!-- Bootstrap core JavaScript
================================================== -->
<!-- Placed at the end of the document so the pages load faster -->
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="<@spring.url '/resources/js/bootstrap.bundle.min.js' />"></script>

<!-- Icons -->
<script src="https://unpkg.com/feather-icons/dist/feather.min.js"></script>
<script>
    feather.replace()
</script>


<script>
    var input = document.getElementById("name");

    $("#add-group").click(function(){

    });

    new Awesomplete(input, {
        list: [
        <#list roles as role>
            {label: "${role.name}", value: "${role.id}"}<#if !role?is_last>,</#if>
        </#list>]
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
    var index = 0;
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

        $(".far.fa-window-close").click(function(){
            $(this).parent().detach();
        });

        $("#name").val("");
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
            }
        });

        return false;
    })
</script>

</body>
</html>
