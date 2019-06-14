<link href="<@spring.url '/resources/css/bootstrap.min.css' />" rel="stylesheet">
<link href="https://use.fontawesome.com/releases/v5.8.2/css/all.css" rel="stylesheet"
      integrity="sha384-oS3vJWv+0UjzBfQzYUhtDYW+Pj2yciDJxpsK1OYPAYjqT085Qq/1cq5FLXAZQ7Ay" crossorigin="anonymous">
<link href="https://select2.github.io/select2/select2-3.5.3/select2.css" rel="stylesheet"/>
<#if admin??>
<link href="<@spring.url '/resources/css/admin.css' />" rel="stylesheet">
<link href="<@spring.url '/resources/css/dashboard.css' />" rel="stylesheet">
<#else>
<link href="<@spring.url '/resources/css/common.css' />" rel="stylesheet">
</#if>


<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script src="<@spring.url '/resources/js/bootstrap.bundle.min.js' />"></script>
<script src="https://select2.github.io/select2/select2-3.5.3/select2.js"></script>

<#include "macros.ftl" />