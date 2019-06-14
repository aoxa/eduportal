<div class="nav-scroller bg-white box-shadow">
    <nav class="nav nav-underline">
        <#if subNavElements??>
        <#else>
                <a class="nav-link" href="/">Dashboard</a>
                <#if parent??>
                    <a class="nav-link" href="<@spring.url '/course/${parent.course.id}' />">volver al curso</a>
                    <a class="nav-link" href="<@spring.url '/node/${parent.id}' />">${parent.title}</a>
                <#elseif node?? && node.course??>
                    <a class="nav-link" href="<@spring.url '/course/${node.course.id}' />">volver al curso</a>
                <#elseif course??>
                    <a class="nav-link" href="<@spring.url '/course/${course.id}' />">volver al curso</a>
                </#if>

        </#if>
    </nav>
</div>