<table class="table table-hover">
    <thead>
    <tr>
        <th scope="col">#</th>
        <th scope="col">Nombre de usuario</th>
        <th scope="col">Acciones</th>
    </tr>
    </thead>
    <tbody>
    <#list users.content as user>
    <tr>
        <th scope="row">${user.id}</th>
        <td>${user.username!"not set yet"}</td>
        <td>
            <i class="far fa-edit" style="cursor:pointer" data-username="${user.username!"not set yet"}" data-userid="${user.id}" data-toggle="modal"
               data-target="#user-info-modal"></i>
            <#if !(user.active??) || !user.active>
                <i class="fa fa-ban" aria-hidden="true"></i>
            </#if>
            <i class="fa fa-trash" style="cursor:pointer" data-username="${user.username!"not set yet"}" data-userid="${user.id}" data-toggle="modal"
               data-target="#user-remove-modal"></i>
        </td>
    </tr>
    </#list>

    </tbody>
</table>