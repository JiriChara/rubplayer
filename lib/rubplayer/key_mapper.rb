module Rubplayer
  class KeyMapper
    def initialize(opts={})
      @player   = opts[:player]
      @parent   = opts[:parent]
      @mappings = opts[:mappings] || {}
    end

    def map(key, &block)
      @mappings[key] = block
    end

    def trigger(key)
      return undefined(key) if @mappings[key].nil?

      return @mappings[key].call
    end

    def undefined(key)
      return :undefined_key
    end

    def active?
      @active
    end

    def activate!
      @active = true
      @parent && @parent.deactivate!
    end

    def deactivate!
      @active = false
      @parent && @parent.activate!
    end
  end
end
