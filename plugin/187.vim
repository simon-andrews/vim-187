let g:ds_junitlocation = get(g:, 'ds_junitlocation', '/usr/share/java/junit.jar')

" Helper function for finding the root of an Eclipse project. Starts at the
" directory VIM was started from, and recursively moves up the filesystem tree
" searching for an Eclipse .project file.
function! s:DSFindRootHelper(cd)
  if !empty(glob(a:cd . '/.project'))
    return a:cd
  elseif a:cd == '/' " no letters with cases to care about here so whatever :P
    echoerr 'File is not part of an Eclipse project.'
  else
    return s:DSFindRootHelper(fnamemodify(a:cd, ':h'))
  endif
endfunction
function! s:DSFindRoot()
  return s:DSFindRootHelper(expand('%:p:h'))
endfunction

function! s:DSGetProjectName()
  return fnamemodify(s:DSFindRoot(), ':t')
endfunction

function! s:DSFindCode(subdir)
  return globpath(s:DSFindRoot() . '/' . a:subdir, '**/*.java')
endfunction

function DSBuild()
  echo 'Compiling...'
  call system('javac -d ' . s:DSFindRoot() . '/bin -cp ' . g:ds_junitlocation . ' ' . s:DSFindCode('src') . ' ' . s:DSFindCode('test'))
  echon "\r\r"
  echon 'Done!'
endfunction
command! DSBuild call DSBuild()

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

function! DSTest()
  call DSBuild()
  execute '!java -cp ' . g:ds_junitlocation . ':' . s:DSFindRoot() . '/bin org.junit.runner.JUnitCore ' . s:DSBuildTestClassList(s:DSFindRoot() . '/bin')
endfunction
command! DSTest call DSTest()

" Creates a ZIP archive for the current project, ready for uploading to
" GradeScope.
function! DSZip(output)
  execute '!cd ' . s:DSFindRoot() . '/.. && zip -r ' . fnamemodify(a:output, ':p') . ' ' . s:DSGetProjectName()
endfunction
command! -nargs=1 DSZip call DSZip(<q-args>)

" Opens Gradescope in a web browser for easy uploading
function! DSOpenGS()
  let gs_url = get(g:, 'ds_gradescopeurl', 'https://www.gradescope.com/')
  call system('python -m webbrowser -t ' . gs_url)
endfunction
command! DSOpenGS call DSOpenGS()
