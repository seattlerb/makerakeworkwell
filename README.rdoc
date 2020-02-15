= make
= rake
= work
= well

home :: https://github.com/seattlerb/makerakeworkwell
doco :: http://docs.seattlerb.org/makerakeworkwell

== DESCRIPTION:

make/rake/work/well provides two simple modifications to rake that
make working with file tasks cleaner, easier, and faster.

== Rationale:

=== FileTask

After extensive discussion with Jim, I believe we've agreed to
disagree on what rake is and how it should work. To Jim, rake is a
build tool (ie, a make replacement), plain and simple. I think it's
grown past that. To me, rake is a task execution engine with built in
dependency management and a whole lot of helpers to make writing said
tasks clean and easy. Whether there are files involved or not is less
of a concern in my mind, but when there are files involved, they often
seem to be problematic.

As such, make/rake/work/well patches rake to work with files in the
way that works best for my brain. Specifically, I think that every
file should map directly to their own dependencies and targets should
follow the entire tree of dependencies to see if they should rebuild
or not. For example:

    target1 ---> source1 --+--> required1 ---> required2
                           |
    target2 ---> source2 --+

If required2 changes, target1 and target2 should be rebuilt.

Jim would rather see the dependencies modeled in the old-school make
way:

    target1 --+--> source1
              |
              +--> required1
              |
              +--> required2

    target2 --+--> source2
              |
              +--> required1
              |
              +--> required2

This requires a manual expansion of the transitive closure of the
dependencies. This flattens everything, causes a lot of fan-out, and
makes it harder to see how things interrelate.

My patches to rake replace FileTask#needed? and FileTask#timestamp to
cause the scenario described above to work correctly. It uses caching
to prevent a lot of extra fstats from happening and winds up
performing at least fast as rake.

I've been using this for the last 6 months in zenweb for very large
dependency graphs and it has been working great for me.

=== Phony

It also defines a :phony task that you can use as a dependency. Rake
has very strange notions on how file and non-file based tasks should
interact. Specifically, file tasks use the timestamp of their
dependencies to determine whether they should build. Task defines its
timestamp to be the max its dependencies or Time.now if there are
none. That forces a file task depending on a non-file-task to always
build. 

Depending on phony reverses this. This allows file-based tasks
to use non-file-based tasks as prerequisites without forcing them to
rebuild. For example:

    task :isolate => :phony

    file "lib/ruby18_parser.rb" => :isolate
    file "lib/ruby19_parser.rb" => :isolate

I've been using this in ruby_parser for the last 6 months and it
cleaned up a bunch of confusion as to why my files kept rebuilding
over and over.

== REQUIREMENTS:

* rake

== INSTALL:

* sudo gem install makerakeworkwell

== LICENSE:

(The MIT License)

Copyright (c) Ryan Davis, seattle.rb

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
