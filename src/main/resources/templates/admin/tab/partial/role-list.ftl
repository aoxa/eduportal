<table class="table table-hover">
    <thead>
    <tr>
        <th scope="col">#</th>
        <th scope="col">Role Name</th>
    </tr>
    </thead>
    <tbody>
        <#list roles.content as role>
        <tr>
            <th scope="row">${role.id}</th>
            <td>${role.name}</td>
        </tr>
        </#list>
    </tbody>
</table>