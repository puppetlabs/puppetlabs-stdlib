type Stdlib::Cron_schedule = Struct[{
  minute   => Optional[Variant[Integer,Array[Integer]]],
  hour     => Optional[Variant[Integer,Array[Integer]]],
  weekday  => Optional[Variant[Integer,Array[Integer]]],
  month    => Optional[Variant[Integer,Array[Integer]]],
  monthday => Optional[Variant[Integer,Array[Integer]]],
}]
