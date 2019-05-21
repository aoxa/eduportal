<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Create an account</title>
    <link href="${contextPath}/resources/css/bootstrap.min.css" rel="stylesheet">
    <link href="${contextPath}/resources/css/common.css" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
    <script src="${contextPath}/resources/js/bootstrap.min.js"></script>
</head>

<body>
<jsp:include page="nav-bar.jsp" />
<main role="main" class="container">
    <div class="row">
        <div class="col-sm-7">
            <c:if test="${pageContext.request.userPrincipal.name != null}">
                <h2>Welcome ${pageContext.request.userPrincipal.name}</h2>
            </c:if>
        </div>
        <div class="col-sm-5">
            <h4>Mis cursos</h4>
            <c:forEach items = "${courses}" var = "course">
                <c:if test="${not empty course.neededRole}">
                    <sec:authorize access="hasAuthority(${course.neededRole.name})">
                    <p><a href="/course/${course.id}"><c:out value = "${course.name}"/></a><p>
                    </sec:authorize>
                </c:if>
                <c:if test="${empty course.neededRole}">
                    <p><a href="/course/${course.id}"><c:out value = "${course.name}"/></a><p>
                </c:if>
            </c:forEach>
        </div>

    </div>
    <a href="/course/add">Agregar nuevo curso</a>

</main>





</body>
</html>