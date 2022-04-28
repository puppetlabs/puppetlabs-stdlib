# @summary Validate a Windows path
type Stdlib::Windowspath = Pattern[/\A(([a-zA-Z]:[\\\/])|([\\\/][\\\/][^\\\/]+[\\\/][^\\\/]+)|([\\\/][\\\/]\?[\\\/][^\\\/]+)).*\z/]
