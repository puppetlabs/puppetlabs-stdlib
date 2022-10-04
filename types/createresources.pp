# @summary A type description used for the create_resources function
#
# @example As a class parameter
#   class myclass (
#     Stdlib::CreateResources $myresources = {},
#   ) {
#     # Using create_resources
#     create_resources('myresource', $myresources)
#
#     # Using iteration
#     $myresources.each |$myresource_name, $myresource_attrs| {
#       myresource { $myresource_name:
#         * => $myresource_attrs,
#       }
#     }
#   }
type Stdlib::CreateResources = Hash[String[1], Hash[String[1], Any]]
