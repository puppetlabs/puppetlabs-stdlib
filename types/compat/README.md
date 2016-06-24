# Compatibility Type Aliases

This directory/namespace contains compatibility type aliases for all `is_` and `validate_` functions in stdlib. They are meant as a bridge to start using Puppet 4 features and improvements, without leaving your existing code in the dust. In case there was no exact translation possible, it is noted in the comments of the respective alias.

If you do not need to remain backwards compatible to support existing users of your code, please do use puppet's core types directly, or have a look at voxpupuli's collection of extended types at https://github.com/voxpupuli/puppet-tea.

## Examples

Before:
```
class ntp (
  $broadcastclient,
  $config,
  $keys,
  $minpoll         = undef,
  #...
) {
  validate_bool($broadcastclient)
  validate_absolute_path($config)
  validate_array($keys)
  if $minpoll { validate_numeric($minpoll, 16, 3) }
}
```


After:
```
class ntp (
  Stdlib::Compat::Bool              $broadcastclient,
  Stdlib::Compat::Absolute_path     $config,
  Stdlib::Compat::Array             $keys,
  Optional[Stdlib::Compat::Numeric] $minpoll         = undef,
  #...
) {
  assert_type(Array[String], $keys) |$expected, $actual| {
    warning("The keys parameter for the ntp class has type ${actual}, but should be ${expected}.")
  }
  if $minpoll {
    validate_numeric($minpoll, 16, 3)
    assert_type(Integer[3, 16], $minpoll) |$expected, $actual| {
      warning("The minpoll parameter for the ntp class has type ${actual}, but should be ${expected}.")
    }
  }
}
```

Note how `$keys` and `$minpoll` have additional code to restrict the passed value further. To keep development moving forward, without having to change all code on a flag day, the example also shows how to mark parameters for future increases in strictness without breaking immediately. Looking out for the warnings in puppet's output, logs, and reports will enable you to identify sloppy users of your code and fix them before tightening down the interface.

## Reference

### Stdlib::Compat::Absolute_path

Emulate the is_absolute_path and validate_absolute_path functions.

### Stdlib::Compat::Array

Emulate the is_array and validate_array functions.

### Stdlib::Compat::Bool

Emulate the is_bool and validate_bool functions.

### Stdlib::Compat::Numeric

Emulate the is_numeric and validate_numeric functions.

`validate_numeric` also allows range checking, which cannot be mapped to the string parsing inside the function.
For full backwards compatibility, you will need to keep the validate_numeric call around to catch everything.
To keep your development moving forward, you can also add a deprecation warning using the Integer type:

```
class example($value) { validate_numeric($value, 10, 0) }
```

would turn into

```
class example(Stdlib::Compat::Numeric $value) {
 validate_numeric($value, 10, 0)
 assert_type(Integer[0, 10], $value) |$expected, $actual| {
   warning("The 'value' parameter for the 'ntp' class has type ${actual}, but should be ${expected}.")
 }
}
```

> Note that you need to use Variant[Integer[0, 10], Float[0, 10]] if you want to match both integers and floating point numbers.
This allows you to find all places where a consumers of your code call it with unexpected values.

### Stdlib::Compat::Re

The type alias for validate_re does not exist. `validate_re(value, re)` translates to `Pattern[re]`, which is not directly mappable as a type alias, but can be specified as `Pattern[re]`. Therefore this needs to be translated directly.

### Stdlib::Compat::String

Emulate the is_string and validate_string functions.
