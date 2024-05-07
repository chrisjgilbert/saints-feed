module Scrapers
  class << self
    def lookup(name)
      name.to_s.camelize.to_s.constantize
    end
  end
end
