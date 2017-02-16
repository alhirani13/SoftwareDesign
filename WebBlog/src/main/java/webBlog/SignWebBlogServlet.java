package webBlog;

import static com.googlecode.objectify.ObjectifyService.ofy;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.*;

import java.io.IOException;
import java.util.Date;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SignWebBlogServlet extends HttpServlet {
	static {

        ObjectifyService.register(blogPost.class);

    }
	
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        
        // We have one entity group per Guestbook with all Greetings residing
        // in the same entity group as the Guestbook to which they belong.
        // This lets us run a transactional ancestor query to retrieve all
        // Greetings for a given Guestbook.  However, the write rate to each
        // Guestbook should be limited to ~1/second.

        String webBlogName = req.getParameter("webBlogName");
   //   Key guestbookKey = KeyFactory.createKey("Guestbook", guestbookName);
        String content = req.getParameter("content");
    //  Date date = new Date();
    //  Entity greeting = new Entity("Greeting", guestbookKey);
       
        //greeting.setProperty("user", user);
        //greeting.setProperty("date", date);
        //greeting.setProperty("content", content);

        blogPost post = new blogPost(user, content);
        ofy().save().entity(post).now();
        resp.sendRedirect("/webblog.jsp?webBlogName=" + webBlogName);
    }

}