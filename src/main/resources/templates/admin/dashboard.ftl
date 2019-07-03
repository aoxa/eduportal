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

    <!-- Custom styles for this template -->
    <link href="<@spring.url '/resources/css/dashboard.css' />" rel="stylesheet">

    <link href="<@spring.url '/resources/css/admin.css'/> rel="stylesheet">
</head>

<body>
<#include "topbar.ftl" />

<div class="container-fluid">
    <div class="row">
        <nav class="col-md-2 d-none d-md-block bg-light sidebar">
        <#assign active = "dashboard" />
        <#include "sidebar.ftl" />
        </nav>

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 pt-3 px-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pb-2 mb-3 border-bottom">
                <h1 class="h2">Dashboard</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <div class="btn-group mr-2">

                    </div>
                </div>
            </div>
            <form method="post">

                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <div class="form-group">
                    <label for="smtp">SMTP Server</label>
                    <input class="form-control" name="smtp" value="${getSetting("mail.smtp")!""}">
                </div>
                <div class="form-group">
                    <label for="port">Port Number</label>
                    <input class="form-control" name="port" value="${getSetting("mail.port")!""}">
                </div>
                <div class="form-group">
                    <label for="user">Username</label>
                    <input class="form-control" name="user" value="${getSetting("mail.user")!""}">
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input class="form-control" name="password" value="${getSetting("mail.pass")!""}">
                </div>
                <div class="form-check">
                    <input class="form-check-input" name="tls" type="checkbox"
                           <#if getSetting("mail.tls")!"" =="true">checked</#if>>
                    <label for="tls">Use TLS</label>
                </div>
                <button class="btn btn-primary" type="submit">submit</button>
            </form>
        </main>
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

<!-- Graphs -->
</body>
</html>
