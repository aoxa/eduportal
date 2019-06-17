<#import "/spring.ftl" as spring />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>${node.title}</title>

<#include "../includes/head-includes.ftl" />
    <script src="<@spring.url '/resources/js/node.functions.js' />"></script>
    <link href="<@spring.url '/resources/css/form.css' />" rel="stylesheet">
</head>
<body>

<#include "../includes/nav-bar.ftl"/>
<#include "../includes/node.sub-nav-bar.ftl" />

<main class="container">
    <div class="container white row">
        <div class="col-sm-12">
            <h2>${node.title}</h2>
        </div>
        <div class="col-sm-12">${node.body}</div>
    </div>
</main>
</body>
</html>