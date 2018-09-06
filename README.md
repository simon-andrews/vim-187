vim-187
=======
vim-187 is a Vim plugin for working with projects for [COMPSCI 187: Programming with Data Structures](https://umass-cs-187.github.io/) at [UMass Amherst](https://www.umass.edu/).

Installation
------------
vim-187 may be installed with Vim plugin managers, such as [vim-plug](https://github.com/junegunn/vim-plug). You can also just paste 187.vim from the plugins directory into your own plugins directory, but then you won't get updates.

After you install, you must tel vim-187 where your copy of [JUnit 4](https://junit.org/junit4/) is (JUnit 3 will not work). You can do this by putting
```vimscript
let g:ds_junitlocation="/path/to/your/junit-4.x.jar"
```
in your Vim configuration file. By default, this value will be set to /usr/share/java/junit.jar.

Usage
-----
 * `:DSBuild` to compile your project
 * `:DSTest` to compile your project and show JUnit test results
 * `:DSZip [filename]` to create a ZIP archive of your project for uploading to Gradescope.
