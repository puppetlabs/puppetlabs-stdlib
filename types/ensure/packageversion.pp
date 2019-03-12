# Same as Stdlib::Ensure::Package, but also allows string versions and SemVer.
#
# The reason for having this as a separate type is so that you can choose a type
# where you always force the package manager to choose (Stdlib::Ensure::Package)
# if you want to.
type Stdlib::Ensure::PackageVersion = Variant[
  Stdlib::Ensure::Package,
  SemVer,
  String[1],
]
