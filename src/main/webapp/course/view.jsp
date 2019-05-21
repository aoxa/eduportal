<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>${course.name}</title>
    <link href="${contextPath}/resources/css/bootstrap.min.css" rel="stylesheet">
    <link href="${contextPath}/resources/css/common.css" rel="stylesheet">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
    <script src="${contextPath}/resources/js/bootstrap.min.js"></script>
    <style>body{ padding-top:unset}</style>
</head>

<body>
<jsp:include page="../nav-bar.jsp" />
<main role="main" class="container">
    <div class="row">
        <div class="col-sm-8">
            <c:if test="${not empty course}">
                <h2>${course.name}</h2>
                <a href="/${course.id}/survey/add">Agregar nuevo</a>
            </c:if>

            <c:forEach items="${course.nodes}" var="node">
                <div class="row">
                    <a href="/node/${node.id}">${node.title}</a>
                </div>
            </c:forEach>
        </div>
        <div class="col-sm-4">
                <h4>Autoridades del curso</h4>
            <c:forEach items="${course.authorities}" var="authority">
                <div>${authority.username}</div>
            </c:forEach>
        </div>
    </div>
    <div class="row">
    <form method="post" action="/course/${course.id}/authority/add">
        <input name="user">
        <input type="hidden"
               name="${_csrf.parameterName}"
               value="${_csrf.token}"/>
        <button type="submit">save</button>
    </form>
    </div>
</main>

</body>
</html>