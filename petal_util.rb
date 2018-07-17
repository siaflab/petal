module PetalLang
  module Util
    extend self
    @@verbose = false
    def dbg(str)
      puts(str) if @@verbose
    end
  end
end
