<#import "/spring.ftl" as spring />

<nav class="navbar navbar-expand-md navbar-dark bg-dark">
    <a class="navbar-brand" href="<@spring.url "/" />">Mi sitio</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarsExample04" aria-controls="navbarsExample04" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>

    <form class="form-inline my-2 my-md-0">
        <input class="form-control" type="text" placeholder="Search">
    </form>

    <div class="navbar-nav flex-row ml-md-auto d-none d-md-flex" id="navbarsExample04">
        <ul class="navbar-nav mr-auto">
        <#if nodeTypes?? && isAuthority>
            <li class="nav-item">
                <div class="btn-group" role="group">
                    <button id="create-node-btn" type="button" class="btn btn-secondary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        Crear nuevo
                    </button>
                    <div class="dropdown-menu" aria-labelledby="create-node-btn">
                        <#list nodeTypes as nodeType>
                            <a class="dropdown-item" href="<@spring.url "/${course.id}/${nodeType.type}/add" />">${nodeType.name}</a>
                        </#list>
                    </div>
                </div>
            </li>
        </#if>
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" id="menu-user" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">${currentUser().username}</a>
                <div class="dropdown-menu dropdown-menu-right" aria-labelledby="menu-user">
                    <a class="dropdown-item" onclick="document.forms['logoutForm'].submit()">Logout</a>
                <#if hasAuthority('admin')><a class="dropdown-item" href="<@spring.url '/admin/dashboard' />">Admin</a></#if>
                </div>
            </li>
        </ul>
    </div>
</nav>
<form id="logoutForm" method="POST" action="<@spring.url '/logout' />">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
</form>

<#if subNavbar??>
    <#include "node.sub-nav-bar.ftl" />
</#if>

<#include "session-message.ftl" />