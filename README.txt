vcprompt
========

vcprompt is a little C program that prints a short string, designed to
be included in your prompt, with barebones information about the current
working directory for various version control systems.  It is designed
to be small and lightweight rather than comprehensive.

Currently, it has varying degrees of recognition for Mercurial, Git,
CVS, and Subversion working copies.

vcprompt has no external dependencies: it does everything with the
standard C library and POSIX calls.  It should work on any
POSIX-compliant system with a C99 compiler.

To compile vcprompt:

  make

To install it:

  make install PREFIX=$HOME

To use it with bash, just call it in PS1:

  PS1='\u@\h:\w $(vcprompt)\$'

To use it with zsh, you need to enable shell option PROMPT_SUBST, and
then do similarly to bash:

  setopt prompt_subst
  PROMPT='[%n@%m] [%~] $(vcprompt)'

vcprompt prints nothing if the current directory is not managed by a
recognized VC system.


Format Strings
==============

You can customize the output of vcprompt using format strings, which can
be specified either on the command line or in the VCPROMPT_FORMAT
environment variable.  For example:

  vcprompt -f "%b"

and

  VCPROMPT_FORMAT="%b" vcprompt

are equivalent.

Format strings use printf-like "%" escape sequences:

  %n  name of the VC system managing the current directory
      (e.g. "cvs", "hg", "git", "svn")
  %b  current branch name
  %r  current revision
  %u  ? if there are any unknown files
  %m  + if there are any uncommitted changes (added, modified, or
      removed files)
  %%  a single % character

All other characters are expanded as-is.

The default format string is

  [%n:%b%m%u]

which is notable because it works with every supported VC system.  In
fact, some features are meaningless with some systems: there is no
single current revision with CVS, for example.  (And there is no good
way to quickly find out if there are any uncommitted changes or unknown
files, for that matter.)


Contributing
============

Patches are welcome.  Please follow these guidelines:

  * Ensure that the tests pass before and after your patch.
    If you cannot run the tests on a POSIX-compliant system,
    that is a bug: please let me know.

  * If at all possible, add a test whenever you fix a bug or implement a
    feature.  If you can write a test that has no dependencies (e.g. no
    need to execute "git" or "hg" or whatever), add it to
    tests/test-simple.  Otherwise, add it to the appropriate VC-specific
    test script, e.g. tests/test-git if it needs to be able to run git.

  * Keep the dependencies minimal: preferably just C99 and POSIX.
    If you need to run an external executable, make sure it makes
    sense: e.g. it's OK to run "git" in a git working directory, but
    *only* if we already know we are in a git working directory.

  * Performance matters!  I wrote vcprompt so that people wouldn't have
    to spawn and initialize and entire Python or Perl interpreter every
    time they execute a new shell command.  Using system() to turn
    around and spawn external commands -- especially ones that involve a
    relatively large runtime penalty like Python scripts -- misses the
    point of vcprompt.

    In fact, you'll find that vcprompt contains hacky little
    reimplementations of select bits and pieces of Mercurial, git,
    Subversion, and CVS precisely in order to avoid running external
    commands.  (And, in the case of Subversion, to avoid depending on a
    large, complex library.)

  * Stick with my coding style:
    - 4 space indents
    - no tabs
    - curly braces on the same line *except* when defining a function
    - C99 comments and variable declarations are OK, at least until
      someone complains that their compiler cannot handle them

  * Feel free to add yourself to the contributors list below.
    (If you don't do it, I'll probably forget.)

  
Author Contact
==============

vcprompt was written by Greg Ward <greg at gerg dot ca>.

The latest version is available from either of my public Mercurial
repositories:

  http://hg.gerg.ca/vcprompt/
  http://bitbucket.org/gward/vcprompt/overview


Other Contributors
==================

In chronological order:

  Daniel Serpell
  Jannis Leidel
  Yuya Nishihara
  KOIE Hidetaka
  Armin Ronacher

Thanks to all!


Copyright & License
===================

Copyright (C) 2009, 2010, Gregory P. Ward and contributors.

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
