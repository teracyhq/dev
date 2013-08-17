Semantic Versioning
===================

A good software piece must have seamless integration of coupling packages and this relates to
package dependency management. To manage it properly, a consistent semantic version system is
required.


However, specific platforms (like Python, Java, Ruby, PHP, etc. ) has different way of managing and
comparing versions provided by packaging tools. This documentation is used to use semantic version
for Teracy's software more easily and consistently.

There are tons of different version schemas: http://en.wikipedia.org/wiki/Software_versioning.
At Teracy, the ``Base`` semantic version system MUST be extend from http://semver.org/. The current
latest version: http://semver.org/spec/v2.0.0.html.

Note: Never ever increase software version just for ``marketing``, please be **semantic**!

Note: Take into account the way http://nvie.com/posts/a-successful-git-branching-model/ works to see
how semantic version should be applied to production services like.
See related link: http://datasift.github.io/gitflow/Versioning.html.

Base
----

**1. Requirements**

a. Must be compatible with http://semver.org/spec/v2.0.0.html

**2. Specifications**

a. Schema:

Format:
::
    version ::= major'.'minor'.'patch('-'prerelease)?('+'metadata)?
    major ::= digit+
    minor ::= digit+
    patch ::= digit+
    prerelease ::= identifier('.'identifier)+
    metadata ::= identifier('.'identifier)+
    identifier ::= (alpha|digit|'-')
    digit ::= [0..9]
    alpha ::= [a..zA..Z]

b. Prerelease tags:

- ``@`` - "dev" means snapshot version of a in-development branch, where all features must be
worked. When all intended features are complete, move on releasing "a" version.

- ``a`` - "alpha" means feature complete but its usage is not stable enough, still major bugs are
  expected. Continue refactoring to reach better software quality and better software stability.

- ``b`` - "beta" means feature complete, only minor bugs are expected. Avoid refactoring here,
  just fix bugs.

- ``c`` - "rc" means all minor bugs are fixed, the software works stably, and the code will be
  released unless there is a last minute bug found after test campaigns.

c. Example:

- Snapshot version: ``0.1.0-@``

- Precedence: ``0.1.0-@ < 0.1.0-a < 0.1.0-a1 < 0.1.0-a2 < 0.1.0-b < 0.1.0-c < 0.1.0 < 1.0.0``

d. Continuous build metadata

    **//TODO**

Python
------

**1. Requirements**

a. Must extends ``Base``

b. Must be compatible with https://pythonhosted.org/setuptools/setuptools.html#specifying-your-project-s-version

c. Future take note: http://www.python.org/dev/peps/pep-0440/

**2. Specifications**

a. Same with ``Base`` above.

b. Incompatible notes

    **//TODO**


Java
----

**1. Requirements**

a. Must extends ``Base``

b. Must be compatible with Maven version plugin

c. Must be compatible with http://www.osgi.org/download/r5/osgi.core-5.0.0.pdf on ``Version`` part.

d. Note: https://groups.google.com/forum/?fromgroups#!topic/scala-internals/Xtm3-TciwNg

**2. Specifications**

a. Same with ``Base`` above.

b. Incompatible notes

    **//TODO**


Ruby
----

    **//TODO**


PHP
---

    **//TODO**
