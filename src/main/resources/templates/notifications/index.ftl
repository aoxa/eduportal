<#include "../includes/page/upper.ftl" />

<main role="main" class="col-sm-10 offset-1">
    <div class="container white row">
        <#if ! notifications?has_content>
            No tiene notificaciones
        </#if>
        <#list notifications as noti>
            ${noti.message}
        </#list>
    </div>
</main>

<#include "../includes/page/lower.ftl" />