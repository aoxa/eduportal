<div class="nav-scroller bg-white box-shadow">
    <nav class="nav nav-underline">
        <#if subNavElements??>
        <#else>
                <a class="nav-link" href="/">Dashboard</a>
                <#if node??>
                    <a class="nav-link" href="<@spring.url '/course/${node.course.id}' />">volver al curso</a>
                <#elseif course??>
                    <a class="nav-link" href="<@spring.url '/course/${course.id}' />">volver al curso</a>
                </#if>

        </#if>
    </nav>
</div>