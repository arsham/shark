return {
  go_with_testify = [[%E\ %#%f:%l:\ %#,]] -- Multi-line testify errors.
    .. [[%C\ %#Error\ Trace:%#,]] -- We ignore this line.
    .. [[%C\ %#Error:\ %m,]] -- The message is here.
    .. [[%C\ %#expected:\ %m,]] -- We add more if there are any.
    .. [[%C\ %#actual\ %#:\ %m,]] -- We add more if there are any.
    .. [[%C\ %#Messages:\ %m,]] -- We add more if there are any.
    .. [[%C\ %#%.%#,]] -- Any additional text that we don't need.
    .. [[%C\ Test:%.%#,]] -- This is the name of the test, we don't need it.
    .. [[%Z,]]
    .. [[%E%f:%l:\ %m,]] -- Stand alone errors.
    .. [[%Z,]]
    .. [[%-G%.%#]], -- Ignoring everything else.
}
