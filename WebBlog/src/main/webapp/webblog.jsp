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
   	<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <meta name="description" content="Pokemon Web Blog">
    <meta name="author" content="Al Hirani and Dylan Keeton">
    <link rel="icon" href="../../favicon.ico">

    <title>Pokémon Master Blog</title>
   
 </head>
 
  <body>
 
 	<link rel="stylesheet" type="text/css" href="blog.css">
 	<!-- Latest compiled and minified CSS -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">

	<!-- Optional theme -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">

	<!-- Latest compiled and minified JavaScript -->
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
   
   
	<font color="#0e3677">
	<h1 style = "text-align:center"><b> The Pokémon Master Blog</b></h1>
	<h4 style ="text-align:center"> THE ULTIMATE BLOG FOR THOSE WHO WANT TO BE THE VERY BEST</h4>
	</font>
  	
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
    } 
   	else {
%>
			<p>Hello!
			<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
			to write a blog post.</p>
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
        
        <div class="blog-post">
            
            
          
        
        <%
        
        for (blogPost post : posts) {
            pageContext.setAttribute("blogPost_content", post.getContent());
            pageContext.setAttribute("blogPost_title", post.getTitle());
            pageContext.setAttribute("blogPost_date", post.getDate());
            if (post.getUser() == null) {

                %>
                <h3 class="blog-post-title">${fn:escapeXml(blogPost_title)}</h3>
                <p class="blog-post-meta">${fn:escapeXml(blogPost_date)} by an anonymous person wrote:</p>

                <%
            } else {
                pageContext.setAttribute("blogPost_user", post.getUser());

                %>
                <h3 class="blog-post-title">${fn:escapeXml(blogPost_title)}</h3>
                <p class="blog-post-meta">${fn:escapeXml(blogPost_date)} by <a href="#"><b>${fn:escapeXml(blogPost_user.nickname)}</b></a></p>

                <%
            }

            %>
            <blockquote>
              ${fn:escapeXml(blogPost_content)}</blockquote>
		</div><!-- /.blog-post -->
            <%
        }

    }

	
%>


<%	if(user != null)
	{
	
	 
	%>
    <form action="/ofysign" method="post">
      <h4><b>Title</b></h4>
  	  <div><textarea name="title" rows="1.75" cols="60"></textarea></div>
  	  <h4><b>Blog Post Content</b></h4>
      <div><textarea name="content" rows="3" cols="60"></textarea></div>
      <div><input type="submit" value="Post Blog" /></div>
      <input type="hidden" name="webBlogName" value="${fn:escapeXml(webBlogName)}"/>
    </form>
    
    <%
    }
    %>
  </body>
</html>