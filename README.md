vim-187
=======
vim-187 is a Vim plugin for working with projects for [COMPSCI 187: Programming with Data Structures](https://umass-cs-187.github.io/) at [UMass Amherst](https://www.umass.edu/).

**Warning:** vim-187 currently sets *all Java files* to use spaces instead of tabs, because this is how the starter code for COMPSCI 187 projects is. A more clever solution for the tab/space thing will hopefully come out soon.

Installation
------------
vim-187 may be installed with Vim plugin managers, such as [vim-plug](https://github.com/junegunn/vim-plug). You can also just paste 187.vim from the plugins directory into your own plugins directory, but then you won't get automatic updates through Git.

After you install, you must tell vim-187 where your copy of [JUnit 4](https://junit.org/junit4/) is (JUnit 3 will not work). You can do this by putting
```vim
let g:ds_junitlocation="/path/to/your/junit-4.x.jar"
```
in your Vim configuration file. By default, this value will be set to /usr/share/java/junit.jar.

You may also set `g:gs_gradescopeurl` to the URL for your specific course's page (https://www.gradescope.com/courses/XXXXX) so that `:DSOpenGS` will take you directly there instead of to your Gradescope homepage (the default behavior). `:DSOpenGS` requires that Python be installed and available on your path as "python".

Usage
-----
 * `:DSBuild` to compile your project
 * `:DSTest` to compile your project and show JUnit test results
 * `:DSOpenGS` to open Gradescope in your web browser
 * `:DSZip [filename]` to create a ZIP archive of your project for uploading to Gradescope
