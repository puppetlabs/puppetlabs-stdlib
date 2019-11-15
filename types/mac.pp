# A type for a MAC address
type Stdlib::MAC = Pattern[
  /\A([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})\z/,
  /\A([0-9A-Fa-f]{2}[:-]){19}([0-9A-Fa-f]{2})\z/
]
