type Stdlib::IP::Address::V6::Nosubnet::Compressed = Pattern[
  /\A:(:|(:[[:xdigit:]]{1,4}){1,7})\z/,
  /\A([[:xdigit:]]{1,4}:){1}(:|(:[[:xdigit:]]{1,4}){1,6})\z/,
  /\A([[:xdigit:]]{1,4}:){2}(:|(:[[:xdigit:]]{1,4}){1,5})\z/,
  /\A([[:xdigit:]]{1,4}:){3}(:|(:[[:xdigit:]]{1,4}){1,4})\z/,
  /\A([[:xdigit:]]{1,4}:){4}(:|(:[[:xdigit:]]{1,4}){1,3})\z/,
  /\A([[:xdigit:]]{1,4}:){5}(:|(:[[:xdigit:]]{1,4}){1,2})\z/,
  /\A([[:xdigit:]]{1,4}:){6}(:|(:[[:xdigit:]]{1,4}){1,1})\z/,
  /\A([[:xdigit:]]{1,4}:){7}:\z/,
]
