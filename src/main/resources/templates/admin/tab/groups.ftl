<h5 class="border-bottom">Grupos</h5>
<div>
<#if ! groups?has_content>
    No hay groupos cargados
</#if>
<#list groups as group>
    <div>${group.name} <i class="far fa-edit"></i></div>
</#list>
    <button data-original-title="Agregar nuevo elemento" data-placement="top" type="button"
            class="btn btn-primary" id="add-group"
            data-toggle="modal" data-target="#group-modal">
        Agregar nuevo
    </button>
</div>
<h5 class="border-bottom">Roles</h5>
<div>
<#if ! roles?has_content>
    No hay groupos cargados
</#if>
<#list roles as role>
    <div>${role.name}</div>
</#list>

</div>