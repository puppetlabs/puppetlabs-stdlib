# A type for a MAC address
type Stdlib::MAC = Pattern[
  /^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$/,
  /^([0-9A-Fa-f]{2}[:-]){19}([0-9A-Fa-f]{2})$/
]
