# @summary Validate a file mode
# See `man chmod.1` for the regular expression for symbolic mode
# lint:ignore:140chars
type Stdlib::File::Mode = Pattern[/\A(([0-7]{1,4})|(([ugoa]*([-+=]([rwxXst]*|[ugo]))+|[-+=][0-7]+)(,([ugoa]*([-+=]([rwxXst]*|[ugo]))+|[-+=][0-7]+))*))\z/]
# lint:endignore
