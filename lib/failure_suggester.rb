class FailureSuggester
  def initialize(line)
    @line = line
  end

  def suggest
    boundries = detect_breakable_boundries
    "#{@line[0..boundries.first]}#{error}#{@line[boundries.last..-1]}"
  end

  private
  def detect_breakable_boundries
    detect_constant_value || [0, @line.length]
  end

  CONSTANT_ERRORS = ["'1'", 33, true, false, 1.32, Class.new, ['array', 13, :mixed], {hash: 'value'}]
  def error
    {
      constant: CONSTANT_ERRORS.sample
    }[@break_type]
  end

  CONSTANT_REGEX = /[A-Z][A-Z0-9a-z_-]*\s*=\s*/
  def detect_constant_value
    matched = @line.match(CONSTANT_REGEX)
    return unless matched
    constant = matched[0]
    replace_from = @line.index(CONSTANT_REGEX) + constant.length - 1
    replace_until = @line.length
    @break_type = :constant
    [replace_from, replace_until]
  end
end
