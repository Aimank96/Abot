class Object
  def self.private_constants(*constants)
    constants.each do |constant|
      private_constant constant
    end
  end
end

module HashHelpers
  refine Hash do
    def deep_fetch(*keys, &block)
      keys.reduce(self) do |hash_object, key|
        hash_object.fetch(key)
      end
    rescue NoMethodError, KeyError
      if block_given?
        block.call
      else
        raise
      end
    end
  end
end
