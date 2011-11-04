Eddard
------

Fake Web Service that matches input XML to templates and replies with
associated reply XML.

Usage
=====

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

Building and running
====================

- Install the Haskell Platform (installers available for Mac, Linux,
  Windows)
- cabal install
- eddard

Eddard should be running on port 8000

Implementation Notes
====================

Eddard is written in Haskell. It uses the Snap web framework for its
simple HTTP interface and regular expressions for the template
processing.

Eddard is, for now, directed at faking web services using XML. The only
XML-related part is the part where it cleans whitespace from the input
and template documents. (See XmlMatch.hs)
