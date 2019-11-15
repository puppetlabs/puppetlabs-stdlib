# See `man chmod.1` for the regular expression for symbolic mode
type Stdlib::Filemode = Pattern[/\A(([0-7]{1,4})|(([ugoa]*([-+=]([rwxXst]*|[ugo]))+|[-+=][0-7]+)(,([ugoa]*([-+=]([rwxXst]*|[ugo]))+|[-+=][0-7]+))*))\z/]
