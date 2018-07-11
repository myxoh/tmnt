class Production
  def string_with_coverage
    string = "Hello"
    return string  + " world"
  end

  def integer_with_coverage
    integer = 15
    case integer
    when 15
      return true
    else
      return "False"
    end
  end

  CONSTANT = "magic string"
  def constant
    CONSTANT
  end

  def comparisons
    Time.now > 10.days.ago
  end

  def empty_array
    if(comparisons)
      ["Champions league"] #NO coverage
    else
      []
    end
  end

  def hash_key(value)
    {the_key: value}
  end

  def default_value_for_method(value = "here")
    return value
  end
end