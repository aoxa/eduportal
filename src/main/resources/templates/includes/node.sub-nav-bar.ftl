<div class="nav-scroller bg-white box-shadow">
    <nav class="nav nav-underline">
        <#if subNavElements??>
        <#else>
                <a class="nav-link" href="/">Dashboard</a>
                <a class="nav-link" href="<@spring.url '/course/${node.course.id}' />">volver al curso</a>
        </#if>
    </nav>
</div>