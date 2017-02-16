package webBlog;

import java.util.Date;

import com.google.appengine.api.users.User;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

@Entity
public class blogPost implements Comparable<blogPost> {
    @Id Long id;
    User user;
    String content;
    Date date;
    
    private blogPost() {}
    
    public blogPost(User user, String content) {
        this.user = user;
        this.content = content;
        date = new Date();
    }

    public User getUser() {
        return user;
    }

    public String getContent() {
        return content;
    }

    @Override
    public int compareTo(blogPost other) {
        if (date.after(other.date)) {
            return 1;
        } else if (date.before(other.date)) {
            return -1;
        }
        return 0;
    }

}