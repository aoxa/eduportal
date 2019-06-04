<#import "/spring.ftl" as spring />

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" href="../../../../favicon.ico">

    <title>User configurations</title>

    <link rel="canonical" href="https://getbootstrap.com/docs/4.0/examples/dashboard/">

    <!-- Bootstrap core CSS -->
    <link href="<@spring.url '/resources/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="<@spring.url '/resources/css/awesomplete.css' />" rel="stylesheet">

    <link href="https://use.fontawesome.com/releases/v5.8.2/css/all.css" rel="stylesheet"
          integrity="sha384-oS3vJWv+0UjzBfQzYUhtDYW+Pj2yciDJxpsK1OYPAYjqT085Qq/1cq5FLXAZQ7Ay" crossorigin="anonymous">

    <link href="<@spring.url '/resources/css/dashboard.css' />" rel="stylesheet">
    <link href="<@spring.url '/resources/css/admin.css' />" rel="stylesheet">
    <script src="<@spring.url '/resources/js/awesomplete.js' />"></script>

    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="<@spring.url '/resources/js/bootstrap.bundle.min.js' />"></script>
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
                <#include "tab/users.ftl" />
                </div>
                <div class="tab-pane fade" id="nav-groups" role="tabpanel" aria-labelledby="nav-profile-group">
                <#include "tab/groups.ftl" />
                </div>
            </div>
        </main>
    </div>
</div>


<!-- Bootstrap core JavaScript
================================================== -->
<!-- Placed at the end of the document so the pages load faster -->

<!-- Icons -->
<script src="https://unpkg.com/feather-icons/dist/feather.min.js"></script>
<script>
    feather.replace()
</script>

</body>
</html>
