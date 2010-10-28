class Object
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end

  def present?
    !blank?
  end
end

class Symbol
  def to_proc
    Proc.new { |obj, *args| obj.send(self, *args) }
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