<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="com.googlecode.objectify.*" %>
<%@ page import="com.googlecode.objectify.Objectify" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%@ page import="webBlog.blogPost" %>
<%@ page import="java.util.*" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
	

<html>
<head>
   <link type="text/css" rel="stylesheet" href="/stylesheets/blog.css" />
 </head>
 
  <head>
  </head>
  <body>

<%
    String webBlogName = request.getParameter("webBlogName");
    if (webBlogName == null) {
    	webBlogName = "default";
    }
    pageContext.setAttribute("webBlogName", webBlogName);
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
to include your name with your post.</p>

<%
    }

%>

<%
	ObjectifyService.register(blogPost.class); 

	List<blogPost> posts = ObjectifyService.ofy().load().type(blogPost.class).list();   

	Collections.sort(posts); 
	if (posts.isEmpty()) {
        
        %>
        <p>Blog Post '${fn:escapeXml(webBlogName)}' has no messages.</p>

        <%
    } else {

        %>
        <p>Messages in Web Blog '${fn:escapeXml(webBlogName)}'.</p>
        
        <%
        for (blogPost post : posts) {
            pageContext.setAttribute("blogPost_content", post.getContent());
            if (post.getUser() == null) {

                %>
                <p>An anonymous person wrote:</p>

                <%
            } else {
                pageContext.setAttribute("blogPost_user", post.getUser());

                %>
                <p><b>${fn:escapeXml(blogPost_user.nickname)}</b> wrote:</p>

                <%
            }

            %>
            <blockquote>${fn:escapeXml(blogPost_content)}</blockquote>

            <%
        }

    }

%>
    <form action="/ofysign" method="post">
      <div><textarea name="content" rows="3" cols="60"></textarea></div>
      <div><input type="submit" value="Post Greeting" /></div>
      <input type="hidden" name="guestbookName" value="${fn:escapeXml(webBlogName)}"/>

    </form>
  </body>
</html>