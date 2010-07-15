class Object

  unless defined? blank?

    def blank?
      respond_to?(:empty?) ? empty? : !self
    end

    def present?
      !blank?
    end

  end

end

class Array
  def sum
    inject(&:+)
  end
end

class Hash
  # As taken from ActiveSupport::CoreExtensions::Hash::Except

  def except(*keys)
    clone.except!(*keys)
  end unless respond_to?(:except)

  def except!(*keys)
    keys.map! { |key| convert_key(key) } if respond_to?(:convert_key)
    keys.each { |key| delete(key) }
    self
  end
end