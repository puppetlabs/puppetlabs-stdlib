# frozen_string_literal: true

Facter.add(:root_home) do
  setcode do
    require 'etc'
  rescue LoadError
  # Unavailable on platforms like Windows
  else
    Etc.getpwnam('root')&.dir
  end
end
