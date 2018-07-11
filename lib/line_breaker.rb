require './lib/failure_suggester.rb'

class LineBreaker
  def initialize(file_path:, line_number:, contents: )
    @contents = contents.split("\n")
    @line_number = line_number - 1
    @old_line = line
    @file_path = file_path
  end

  def break_line!
    set_line suggested_error
    write_file!
  end

  def restore_line!
    set_line @old_line
    write_file!
  end

  def write_file!
    File.write(@file_path, @contents.join("\n"))
  end

  def report
    { line: human_friendly_line_number }
  end

  def human_friendly_line_number
    @line_number + 1
  end

  private
  def line
    @contents[@line_number]
  end

  def set_line(value)
    @contents[@line_number]=value
  end

  def suggested_error
    FailureSuggester.new(line).suggest
  end
end
