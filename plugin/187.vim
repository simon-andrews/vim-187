let g:ds_junitlocation = get(g:, 'ds_junitlocation', '/usr/share/java/junit.jar')

" Helper function for finding the root of an Eclipse project. Starts at the
" directory VIM was started from, and recursively moves up the filesystem tree
" searching for an Eclipse .project file.
function s:DSFindRootHelper(cd)
  if !empty(glob(a:cd . '/.project'))
    return a:cd
  elseif a:cd == '/' " no letters with cases to care about here so whatever :P
    echoerr 'File is not part of an Eclipse project.'
  else
    return s:DSFindRootHelper(fnamemodify(a:cd, ':h'))
  endif
endfunction
function s:DSFindRoot()
  return s:DSFindRootHelper(expand('%:p:h'))
endfunction

function s:DSGetProjectName()
  return fnamemodify(s:DSFindRoot(), ':t')
endfunction

function s:DSFindCodeFiles(subdir)
  return substitute(globpath(s:DSFindRoot() . '/' . a:subdir, '**/*.java'), '\n', ' ', '')
endfunction

function s:DSBuild()
  echo 'Compiling...'
  let cmd = 'javac -d ' . s:DSFindRoot() . '/bin -cp ' . g:ds_junitlocation . ' ' . s:DSFindCodeFiles('src') . ' ' . s:DSFindCodeFiles('test')
  let javac_out = system(cmd)
  if v:shell_error != 0
    echoerr javac_out
  else
    echon "\r\r"
    echon 'Done!'
  end
endfunction
command! DSBuild call s:DSBuild()

function s:DSBuildTestClassList(binDir)
  let classes = []
  for class in split(globpath(s:DSFindRoot() . '/bin', '**/*Test.class'))
    let class = substitute(class, '.*bin/',  '',   '') " remove stuff before bin/, inclusive
    let class = substitute(class, '\.class', '',   '') " remove .class extension
    let class = substitute(class, '/',       '\.', '') " / -> .
    let classes += [class]
  endfor
  let classes = join(classes)
  return classes
endfunction

function s:DSTest()
  call s:DSBuild()
  if v:shell_error == 0
    execute '!java -cp ' . g:ds_junitlocation . ':' . s:DSFindRoot() . '/bin org.junit.runner.JUnitCore ' . s:DSBuildTestClassList(s:DSFindRoot() . '/bin') . ' | less'
  end
endfunction
command! DSTest call s:DSTest()

" Creates a ZIP archive for the current project, ready for uploading to
" GradeScope.
function s:DSZip(output)
  execute '!cd ' . s:DSFindRoot() . '/.. && zip -r ' . fnamemodify(a:output, ':p') . ' ' . s:DSGetProjectName()
endfunction
command! -nargs=1 DSZip call s:DSZip(<q-args>)

" Opens Gradescope in a web browser for easy uploading
function s:DSOpenGS()
  let gs_url = get(g:, 'ds_gradescopeurl', 'https://www.gradescope.com/')
  call system('python -m webbrowser -t ' . gs_url)
endfunction
command! DSOpenGS call s:DSOpenGS()

" Currently does this for all Java files. Not good! Should only work for 187
" files.
if get(g:, "ds_tabsforjava", 1)
  autocmd Filetype java set noexpandtab 
endif
