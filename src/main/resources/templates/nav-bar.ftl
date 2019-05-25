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
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="http://example.com" id="dropdown04" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Dropdown</a>
                <div class="dropdown-menu dropdown-menu-right" aria-labelledby="dropdown04">
                    <a class="dropdown-item" onclick="document.forms['logoutForm'].submit()">Logout</a>
                </div>
            </li>
        </ul>
    </div>
</nav>
<form id="logoutForm" method="POST" action="<@spring.url '/logout' />">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
</form>