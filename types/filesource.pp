# Validate the source parameter on file types
type Stdlib::Filesource = Variant[
  Stdlib::Absolutepath,
  Stdlib::HTTPUrl,
  Pattern[
    /^file:\/\/\/([^\/\0]+(\/)?)+$/,
    /^puppet:\/\/(([\w-]+\.?)+)?\/([^\/\0]+(\/)?)+$/,
  ],
]
