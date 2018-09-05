" Helper function for finding the root of an Eclipse project. Starts at the
" directory VIM was started from, and recursively moves up the filesystem tree
" searching for an Eclipse .project file.
function! DSFindRootHelper(cd)
  if !empty(glob(a:cd . '/.project'))
    return a:cd
  elseif a:cd == '/' " no letters with cases to care about here so whatever :P
    echoerr 'File is not part of an Eclipse project.'
  else
    return DSFindRootHelper(fnamemodify(a:cd, ':h'))
  endif
endfunction
function! DSFindRoot()
  return DSFindRootHelper(expand('%:p:h'))
endfunction

" Creates a ZIP archive for the current project, ready for uploading to
" GradeScope.
function! DSZip(output)
  execute '!cd ' . DSFindRoot() . '/.. && zip -r ' . fnamemodify(a:output, ':p') . ' ' . fnamemodify(DSFindRoot(), ':t')
endfunction
command DSZip call DSZip('out.zip')
