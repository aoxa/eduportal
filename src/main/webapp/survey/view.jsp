<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>${node.title}</title>

    <link href="${contextPath}/resources/css/bootstrap.min.css" rel="stylesheet">
    <link href="${contextPath}/resources/css/common.css" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
    <style>
        .container {
            margin-top: 30px;
            background-color: white;
            border-radius: .3rem;
            webkit-box-shadow: 0 1px 3px rgba(0, 0, 0, .12), 0 1px 1px 1px rgba(0, 0, 0, .16);
            -moz-box-shadow: 0 1px 3px rgba(0, 0, 0, .12), 0 1px 1px 1px rgba(0, 0, 0, .16);
            box-shadow: 0 1px 3px rgba(0, 0, 0, .12), 0 1px 1px 1px rgba(0, 0, 0, .16);
            padding: 30px;
        }
    </style>
</head>
<body>
<jsp:include page="../nav-bar.jsp"/>
<div class="nav-scroller bg-white box-shadow">
    <nav class="nav nav-underline">
        <a class="nav-link" href="/">Dashboard</a>
        <a class="nav-link" href="/course/${node.course.id}">volver al curso</a>

    </nav>
</div>
<main class="container">
    <h2>${node.title}</h2>
    <div>${node.description}</div>
    <c:forEach items="${node.sortedElements}" var="element">
        <div class="row">
            <div class="offset-sm-2 col-sm-4">${element.title}</div>
            <div class="col-sm-6">
                <c:if test="${element.type == 'Select'}">
                    <c:choose>
                        <c:when test="${element.checkBox}">
                            <c:forEach items="${element.options}" var="option">
                                <div class="form-check">
                                    <input id="${element.name}-${option.id}" name="${element.name}" value="${option.value}"
                                           type="checkbox" class="form-check-input"/>
                                    <label class="form-check-label" for="${element.name}-${option.id}">${option.value}</label>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:when test="${element.radioButton}">
                            <c:forEach items="${element.options}" var="option">
                                <div class="form-check">
                                    <input id="${element.name}-${option.id}" name="${element.name}" value="${option.value}"
                                           type="radio" class="form-check-input"/>
                                    <label for="${element.name}-${option.id}" class="form-check-label">${option.value}</label>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <select class="form-control" name="${element.name}"
                                    <c:if test="${element.multivalued}">multiple</c:if>>
                                <c:forEach items="${element.options}" var="option">
                                    <option value="${option.value}">${option.value}</option>
                                </c:forEach>
                            </select>
                        </c:otherwise>
                    </c:choose>
                </c:if>
                <c:if test="${element.type != 'Select'}">
                    <input type="text" name="${element.name}">
                </c:if>
            </div>
        </div>
    </c:forEach>
</main>
</body>

