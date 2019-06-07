<#import "/spring.ftl" as spring />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Create an account</title>

    <link href="<@spring.url '/resources/css/bootstrap.min.css' />" rel="stylesheet">
    <link href="<@spring.url '/resources/css/common.css' />" rel="stylesheet">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
    <script src="<@spring.url '/resources/js/bootstrap.min.js'/>"></script>

</head>

<body>

<div class="container">


    <form method="POST" class="form-signin">
    <@spring.bind "userForm" />
        <h2 class="form-signin-heading">Hola ${userForm.email} cree la cuenta</h2>
    <@spring.formHiddenInput "userForm.id" />
    <@spring.formHiddenInput "userForm.roles" />
    <@spring.formHiddenInput "userForm.groups" />
    <@spring.formHiddenInput "userForm.email" />
        <input type="hidden" id="active" name="active" value="true">

        <div class="form-group ">
            <label>Nombre de usuario</label>
        <@spring.formInput "userForm.username" />
        <@spring.showErrors "" />
        </div>
        <div class="form-group ">
            <label>Nombres</label>
        <@spring.formInput "userForm.name" />
        <@spring.showErrors "" />
        </div>
        <div class="form-group ">
            <label>Apellido</label>
        <@spring.formInput "userForm.lastName" />
        <@spring.showErrors "" />
        </div>
        <div class="form-group ">
            <label>Contrasenia</label>
        <@spring.formPasswordInput "userForm.password" />
        <@spring.showErrors "" />
        </div>
        <div class="form-group ">
            <label>Confirmar Contrasenia</label>
        <@spring.formPasswordInput "userForm.passwordConfirm" />
        <@spring.showErrors "" />
        </div>

        <input type="hidden"
               name="${_csrf.parameterName}"
               value="${_csrf.token}"/>

        <button class="btn btn-lg btn-primary btn-block" type="submit">Submit</button>
    </form>

</div>

</body>
</html>