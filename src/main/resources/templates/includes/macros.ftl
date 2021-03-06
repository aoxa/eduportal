<#macro modal modalId header content footerAccept='' footerCancel='' form=false formAction=''>
<div id="${modalId}" class="modal fade" tabindex="-1" role="dialog" aria-hidden="true"
     aria-labelledby="${modalId}Label">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <#if form>
            <form method="post" action="<@spring.url formAction />">
            </#if>
            <div class="modal-header">
                <h5 class="modal-title" id="${modalId}Label">${header}</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
            ${content}
            </div>

            <div class="modal-footer">
                <#if footerCancel?has_content>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">${footerCancel}</button>
                </#if>
                <#if footerAccept?has_content>
                    <button class="btn btn-primary" type="submit">${footerAccept}</button>
                </#if>
            </div>
            <#if form>
                <input type="hidden"
                       name="${_csrf.parameterName}"
                       value="${_csrf.token}"/>
            </form>
            </#if>
        </div>
    </div>
</div>
</#macro>

<#macro nodeIcon node>
    <#switch node.type>
    <#case "article">
    <i class="far fa-newspaper"></i>
    <#break >
    <#case "survey">
    <i class="fas fa-question"></i>
    <#break>
    <#default>
    <i class="fas fa-question"></i>
    </#switch>
</#macro>