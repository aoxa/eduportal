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
<#assign admin=true />
<#include "../includes/head-includes.ftl"/>
    <link href="<@spring.url '/resources/css/awesomplete.css' />" rel="stylesheet">
    <script src="<@spring.url '/resources/js/awesomplete.js' />"></script>
</head>

<body>
<#include "topbar.ftl" />

<div class="container-fluid">
    <div class="row">
        <nav class="col-md-2 d-none d-md-block bg-light sidebar">
        <#assign active = "groups" />
        <#include "sidebar.ftl" />
        </nav>

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 pt-3 px-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pb-2 mb-3 border-bottom">
                <h1 class="h2">Groups</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <div class="btn-group mr-2">
                    </div>
                </div>
            </div>

            <#include "tab/groups.ftl" />
        </main>
    </div>
</div>


<!-- Icons -->
<script src="https://unpkg.com/feather-icons/dist/feather.min.js"></script>
<script>
    feather.replace()
</script>

</body>
</html>
