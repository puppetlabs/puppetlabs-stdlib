# @summary Validate a file content attribute
type Stdlib::File::Content = Variant[String, Sensitive[String], Deferred[String], Binary]
