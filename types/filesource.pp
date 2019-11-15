# Validate the source parameter on file types
type Stdlib::Filesource = Variant[
  Stdlib::Absolutepath,
  Stdlib::HTTPUrl,
  Pattern[
    /\Afile:\/\/\/([^\n\/\0]+(\/)?)+\z/,
    /\Apuppet:\/\/(([\w-]+\.?)+)?\/([^\n\/\0]+(\/)?)+\z/,
  ],
]
