Semantic Versioning
===================

A good software piece must have seamless integration of coupling packages and this relates to
package dependency management. To manage it properly, a consistent semantic version system is
required.


However, specific platforms (like Python, Java, Ruby, PHP, etc. ) have different ways of managing and
comparing versions provided by packaging tools. This documentation is used to have rules how to use
semantic version for Teracy's software more easily and consistently.

There are tons of different version schemas: http://en.wikipedia.org/wiki/Software_versioning.
At Teracy, the ``Base`` semantic version system MUST be extended from http://semver.org/. The current
latest version: http://semver.org/spec/v2.0.0.html.

.. note::
   - Never increase software version just for ``marketing``, please be **semantic**!

   - Take into account the way http://nvie.com/posts/a-successful-git-branching-model/ works to see
      how semantic version should be applied to production services like.


See related link: http://datasift.github.io/gitflow/Versioning.html.

Base
----

**1. Requirements**

- Must be compatible with http://semver.org/spec/v2.0.0.html

- All time for meta data must be GMT+0.

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

- ``a`` - "alpha" means features completed but its usage is not stable enough, still major bugs
  are expected. Continue refactoring to reach better software quality and stability.

- ``b`` - "beta" means features completed, only minor bugs are expected. Avoid refactoring here,
  just fix bugs.

- ``c`` - "rc" means all minor bugs are fixed, the software works stably, and the code will be
  released unless there is a last minute bug found after test campaigns.

c. Example:

- Snapshot version: ``0.1.0-@``

- Precedence: ``0.1.0-@ < 0.1.0-a < 0.1.0-a1 < 0.1.0-a2 < 0.1.0-b < 0.1.0-c < 0.1.0 < 1.0.0``

d. Continuous build metadata

    **//TODO(hoatle): specify this**

Python
------

**1. Requirements**

- Must extends ``Base``

- Must be compatible with
  https://pythonhosted.org/setuptools/setuptools.html#specifying-your-project-s-version

- Future take note: http://www.python.org/dev/peps/pep-0440/ and
   http://www.python.org/dev/peps/pep-0426/

**2. Specifications**

a. Schema

  Format:
  ::

      version ::= major'.'minor'.'patch('-'prerelease)?('-'postrelease)?
      major ::= digit+
      minor ::= digit+
      patch ::= digit+
      prerelease ::= identifier('-'identifier)+
      postrelease ::= identifier('-'identifier)+
      identifier ::= (alpha|digit|'-')
      digit ::= [0..9]
      alpha ::= [a..zA..Z]

b. Prerelease tags

- The Same as `Base`_.

c. Example

- Snapshot version: ``0.1.0-dev0``

- Precedence: ``0.1.0-dev0 < 0.1.0-dev-20130826.174530 < 0.1.0-a-dev0 < 0.1.0-a < 0.1.0-a1 < 0.1.0-a2
  < 0.1.0-b < 0.1.0-c < 0.1.0 < 1.0.0``

d. Continuous build metadata

  Format:
  ::

      version ::= major'.'minor'.'patch('-'prerelese)?'-dev-'YYYYMMDD.hhmmss('-'buildnumber)?
      buildnumber ::= digit+

- Precedence: ``0.1.0-dev0 < 0.1.0-dev-20150826 < 0.1.0-dev-20150826.101010
  < 0.1.0-dev-20150826.101010-5 < 0.1.0-a-dev < 0.1.0-a-dev-20150926.101010``

.. note::
  - The format here learns from maven snapshot build to make it consistent.

  - There is a nightly build provided by ``setuptools`` but it does not do what we want here.

e. Jenkins rules

- Always set developing branch with: ``-dev0`` affix.

- Snapshot build: replace ``-dev0`` with ``-dev-YYYYMMDD.hhmmss-buildnumber``.

 For example:  ``0.1.0-dev-20130914.101010-15``.

- Staging build when there is no ``-dev0`` affix, add ``-YYYYMMDD.hhmmss-buildnumber``.

For example: ``0.1.0-20130915-102030-2``

.. note::
    - ``setuptools`` considers this as 'post-release'

    - ``pip`` considers this as 'pre-release'.

We must specify the right staging version for ``pip`` to install.
  This should be improved, expected that
  ``pip install -i http://pypi.teracy.org/teracy/public-staging/+simple/ package-name`` should
  install the latest staging version of a specified package name.

- Final release includes only final version, for example: ``0.1.0``, ``0.2.0-a``, ``1.0.0``.

Java
----

**1. Requirements**

a. Must extends `Base`_

b. Must be compatible with Maven version plugin

- http://maven.apache.org/ref/3.1.0/maven-artifact/xref/org/apache/maven/artifact/versioning/DefaultArtifactVersion.html

- http://docs.codehaus.org/display/MAVEN/Versioning

c. Must be compatible with http://www.osgi.org/download/r5/osgi.core-5.0.0.pdf on the ``Version`` part.

d. Note:

- https://groups.google.com/forum/?fromgroups#!topic/scala-internals/Xtm3-TciwNg

- https://github.com/paulp/version-investigator

- https://github.com/ngrobisa/artifactory-plugin/blob/3f5d791d2c18620142539d53f700fa8757fa6be1/src/main/java/org/jfrog/hudson/util/GenericArtifactVersion.java

**2. Specifications**

a. Schema

Format:
::

    version ::= major'.'minor'.'path('-'prerelease)('-'postrelease)?
    major ::= digit+
    minor ::= digit+
    patch ::= digit+
    prerelease ::= identifier('-'identifier)+
    postrelease ::= identifier('-'identifier)+
    identifier ::= (alpha|digit|'-')
    digit ::= [0..9]
    alpha ::= [a..zA..Z]

b. Prerelease tags

- Same as `Base`_.

c. Example

- Snapshot version: ``0.1.0-SNAPSHOT``

- Precedence: ``0.1.0-SNAPSHOT < 0.1.0-20130826.174530-1 < 0.1.0-a-SNAPSHOT <
  0.1.0-a-20130827.123421-5 < 0.1.0-a < 0.1.0-a1 < 0.1.0-a2 < 0.1.0-b < 0.1.0-c < 0.1.0 < 1.0.0``

d. Continuous build metadata

Format:
::

    version ::= major'.'minor'.'patch('-'prerelease)?-YYYYMMDD.hhmmss('-'buildnumber)?
    buildnumber ::= digit+

- Precedence: ``0.1.0-SNAPSHOT < 0.1.0-20150826 < 0.1.0-20150826.101010 < 0.1.0-20150826.101010-5
  < 0.1.0-a-SNAPSHOT < 0.1.0-a-20150926.101010 < 0.1.0``


Ruby
----

    **//TODO(hoatle): specify this**


PHP
---

    **//TODO(hoatle): specify this**
