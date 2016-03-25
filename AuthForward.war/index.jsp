<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="java.util.Date"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Secure App</title>
</head>
<body>

	Start <% out.println(new Date().toString() );%> <br />
	Hello <%=request.getUserPrincipal().getName().toString()%>!<br />

	Ende <br />
	
</body>
</html>
