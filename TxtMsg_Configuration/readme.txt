Sample Chumby Configuration Widget for use with FlashDevelop

With this file, you can create a Chumby configuration widget using the free
FlashDevelop tools which you can find out about here:

http://wiki.chumby.com/mediawiki/index.php/FlashDevelop

The templates by Raffaele Sena mentioned at the bottom of the page are a
great way to get started quickly.

Many of the sample files on the Chumby site such as the sample banner here:

http://wiki.chumby.com/mediawiki/index.php/Sample_Banner_Widget

are geared for the $700 Adobe Flash tools. You can get a free 30 day trial of the
Flash Tools here (http://www.adobe.com/products/flash/), but if you would prefer
to use the free FlashDevelop, please join me in sharing Chumby example code that
doesn't require it.

Some of the code below originally came from the Flash Sample Banner code and I
reworked it heavily. I'm not sure of the licence rights of the parts I started
with, but you're certainly free to use my work for whatever purpose: 

I attempted to make this widget work from the development debugging environment.
This is a challenge due to the need to access your Chumby URL from Chumby's
channel configuration web site. That variable doesn't exist in your debugging
environment. So I made the widget display the URL so you can get at it and stick
it into your code for debugging.

1. Install FlashDevelop, Raff's templates, and this file.
2. Compile the /bin/*.swf file using the Test Movie (F5) command. The first time
   you may have to make the /bin subdirectory by hand.
3. Go to the Chumby widget upload site at http://www.chumby.com/widgets/upload
4. Upload the swf file just created to the config slot. You'll also need
   a dummy widget file (perhaps the same one) and a logo file.
5. Run the config widget by going here http://www.chumby.com/widgets/channels
   and hitting configure.
6. Copy the value of the Chumby URL (spread over two lines)
7. Paste the URL into the line of code below just after **HERE** below

Now when the routine runs in the debugger, it will use this hard coded URL
but when it runs on the Chumby site, it will fetch the URL from the web site
environment.

Now after all that, I still could not get this to work reliably in the test
environment. It seems to work all the time on the Chumby site. Sometimes I
can type in configuration parameters on the debug site and they will show
up on the Chumby site and vice versa, but I can't seem to make changes made
on the debug version show up on the next invocation of the debug version.
Perhaps someone smarter than I can figure out why. 

Its worth trying to make this work because you can see the output of the
trace commands in your debug environment. I don't know if that's possible
when your widget is running on Chumby's site.

The major difficulty in the code below is fighting with the scoping
problems related to passing callback functions around. Through a lot
of experimentation, I found a set of static and non-static functions
that work, although they make the code ugly as sin. Also, because
class-wide variables cannot be seen by these callback functions, I used
a lot of global variables. I'm not proud of that, but they are more
understandable to me than the Delegate.create functions that some
people use to try to finesses these problems. For more on scoping
problems, see http://timotheegroleau.com/Flash/articles/scope_chain.htm

If you make improvements to this template please post it back to the
Chumby site and drop me a line at john@tanner.com

John Tanner