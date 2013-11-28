module Rubplayer
  KEYS = {
    0   => '<C-space>',
    1   => '<C-a>',
    2   => '<C-b>',
    3   => '<C-c>',
    4   => '<C-d>',
    5   => '<C-e>',
    6   => '<C-f>',
    7   => '<C-g>',
    8   => '<C-h>',
    9   => '<tab>',
    9   => '<C-i>',
    10  => '<C-j>',
    11  => '<C-k>',
    12  => '<C-l>',
    13  => '<return>',
    # 13  => '<C-m>',
    14  => '<C-n>',
    15  => '<C-o>',
    16  => '<C-p>',
    17  => '<C-q>',
    18  => '<C-r>',
    19  => '<C-s>',
    20  => '<C-t>',
    21  => '<C-u>',
    22  => '<C-v>',
    23  => '<C-w>',
    24  => '<C-x>',
    25  => '<C-y>',
    26  => '<C-z>',
    27  => '<esc>',
    32  => '<space>',
    127 => '<backspace>'
  }

  class KeyMapper
    def initialize(opts={})
      if !opts[:mappings].nil? && !opts[:mappings].is_a?(Hash)
        raise ArgumentError, "opts[:mappings] must be a Hash"
      end

      # TODO: provide validation of given mappings
      @mappings      = opts[:mappings] || {}
      @counter       = nil
      @current_combo = nil
    end

    def map(shortcut, &block)
      if shortcut.match(/^.*\d.*$/)
        raise ArgumentError, "Shortcut cannot contain any number."
      end

      raise ArgumentError, "Block must be given." unless block_given?

      if shortcut.length == 1 || Rubplayer::KEYS.values.include?(shortcut)
        @mappings[shortcut.length == 1 ? shortcut : Rubplayer::KEYS.index(key)] = block
      elsif shortcut.length > 3
        raise ArgumentError, "Cannot map #{shortcut.inspect}"
      else
        old = @mappings[shortcut.split(//).first]
        old.delete unless old.nil?
        @mappings[shortcut] = block
      end
    end

    def trigger(key)
      begin
        key = key.chr
      rescue RangeError
        return undefined(key)
      end

      (add_to_counter(key) && return) if key.match(/^\d$/)

      if waiting_for_key?
        if possible_keys.include?(key)
          @current_combo = "#{@current_combo}#{key}"
          res = @mappings[@current_combo]
          res.is_a?(Proc) ? exec_callback(res) : return
        else
          undefined(key)
        end
      elsif Rubplayer::KEYS.include?(key.ord)
        res = @mappings[Rubplayer::KEYS[key.ord]]
        res.is_a?(Proc) ? exec_callback(res) : undefined(key)
      elsif((res = @mappings[key]) && res.is_a?(Proc))
        exec_callback(res)
      elsif possible_keys.include?(key)
        @current_combo = key
      else
        undefined(key)
      end
    end

    def waiting_for_key?
      !@current_combo.nil?
    end

    def possible_keys
      @mappings.keys.map do |key|
        key.sub(/^#{@current_combo}/, "").split(//).first
      end
    end

    def add_to_counter(n)
      @counter = @counter.nil? ? "#{n}" : "#{n}#{@counter}"
      @counter = @counter.to_i
    end

    def reset_combo
      @counter       = nil
      @current_combo = nil
    end

    def exec_callback(callback)
      n = @counter || 0
      reset_combo

      if callback.arity == 1
        callback.call(n)
      else
        callback.call
      end
    end

    def count_given?
      !@counter.nil?
    end

    def undefined(key)
      reset_combo
      return :undefined_key
    end
  end
end
