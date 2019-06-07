<#if ! groups?has_content>
No hay groupos cargados
<#else>
<table class="table table-hover">
    <thead>
    <tr>
        <th scope="col">#</th>
        <th scope="col">Group Name</th>
        <th scope="col">Actions</th>
    </tr>
    </thead>
    <tbody>
    <#list groups as group>
    <tr>
        <th scope="row">${group.id}</th>
        <td>${group.name}</td>
        <td>
            <i class="far fa-edit" style="cursor:pointer" data-whatever="${group.id}" data-toggle="modal"
               data-target="#group-edit-modal"></i>
            <i class="fa fa-trash" style="cursor:pointer" data-whatever="${group.id}" data-toggle="modal"
               data-target="#group-remove-modal"></i>
        </td>
    </tr>
    </#list>

    </tbody>
</table>
</#if>