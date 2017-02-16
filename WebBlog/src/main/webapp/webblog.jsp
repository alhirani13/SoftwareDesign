
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
   <link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
 </head>
 
  <head>
  </head>
  <body>

<%
    String webblogName = request.getParameter("webblogName");
    if (webblogName == null) {
    	webblogName = "default";
    }
    pageContext.setAttribute("webblogName", webblogName);
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
      pageContext.setAttribute("user", user);
      
%>
<p>Hello, ${fn:escapeXml(user.nickname)}! (You can
<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>

<%
    } else {

%>
<p>Hello!
<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
to include your name with the blog you post.</p>

<%
    }

%>

<%
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    Key webblogKey = KeyFactory.createKey("Webblog", webblogName);

    // Run an ancestor query to ensure we see the most up-to-date
    // view of the Greetings belonging to the selected Guestbook.

    Query query = new Query("blogPost", webblogKey); //.addSort("date", Query.SortDirection.DESCENDING);
    List<Entity> blogPosts = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(5));
    if (blogPosts.isEmpty()) {
        
        %>
        <p>Webblog '${fn:escapeXml(webblogName)}' has no messages.</p>

        <%
    } else {

        %>
        <p>Posts in WebBlog '${fn:escapeXml(webblogName)}'.</p>
        
        <%
        for (Entity blogPost : blogPosts) {
            pageContext.setAttribute("webblog_content", webblog.getProperty("content"));
            if (blogPost.getProperty("user") == null) {

                %>
                <p>An anonymous person wrote:</p>

                <%
            } else {
                pageContext.setAttribute("webblog_user", blogPost.getProperty("user"));

                %>
                <p><b>${fn:escapeXml(webblog_user.nickname)}</b> wrote:</p>

                <%
            }

            %>
            <blockquote>${fn:escapeXml(webblog_content)}</blockquote>

            <%
        }

    }

%>
    <form action="/sign" method="post">
      <div><textarea name="content" rows="3" cols="60"></textarea></div>
      <div><input type="submit" value="Post Blog" /></div>
      <input type="hidden" name="webblogName" value="${fn:escapeXml(webblogName)}"/>

    </form>
  </body>
</html>