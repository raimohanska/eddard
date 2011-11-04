Eddard
------

Fake Web Service that matches input XML to templates and replies with
associated reply XML.

Eddard reads templates and replies from the current working directory.
All files containing the word "template" are included. Eddard associates
each template with a reply that's found in the corresponding reply file.
For instance, in the Git repo, there's a single template-response pair:

File: example-template.xml

~~~
<login>
  <username>{username}</username>
  <password>{password}</password>
</login>
~~~

File: example-reply

~~~
<login-reply>
  <ok/>
  <id>{id}</id>
</login-reply>
~~~

Start Eddard in this directory. Then try it with `curl`:

~~~
w164:eddard jpaanane$ curl -d "<login><username>juha</username><password>secret</password></login>" localhost:8000/
<login-reply><ok/><id>7677a7a1-2dfe-49bb-8659-88c4160a98fd</id></login-reply>
~~~

You should notice a few things:

- Eddard replies with the content of the associated reply file
- Eddard replaces the {id} tag with a generated unique ID
- Eddard saves the template variables in a new file

File: 7677a7a1-2dfe-49bb-8659-88c4160a98fd.values:

~~~
[("username","juha"),("password","secret")]
~~~
