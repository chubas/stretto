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