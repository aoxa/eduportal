<#import "/spring.ftl" as spring />

<div class="sidebar-sticky">
    <ul class="nav flex-column">
        <li class="nav-item">
            <a class="nav-link <#if active == "dashboard">active</#if>" href="<@spring.url '/admin/dashboard' />">
                <span data-feather="home"></span>
                Dashboard <span class="sr-only">(current)</span>
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link <#if active == "users">active</#if>" href="<@spring.url '/admin/users' />">
                <span data-feather="users"></span>
                Usuarios
            </a>
        </li>

    </ul>
</div>