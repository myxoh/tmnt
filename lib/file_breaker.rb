require './lib/line_breaker.rb'

class FileBreaker
  def initialize(file_name)
    @file_name = file_name
    @contents = ""
  end

  def break_lines(&block)
    begin
      create_backup!
      @contents.each_line.each_with_index do |line, pre_line_number|
        line_number = pre_line_number + 1
        line_breaker = LineBreaker.new(file_name: @file_name, contents: @contents, line_number: line_number)
        line_breaker.break_line!
        block.call(line_breaker.report)
        line_breaker.restore_line!
      end
    rescue => e
      puts e
    ensure
      delete_backup!
    end
  end

  def create_backup!
    read_file!
    File.write(backup_path, @contents)
  end

  def read_file!
    @contents = File.read(@file_name)
  end

  def delete_backup!
    File.delete(backup_path)
  end

  def backup_path
    "#{@file_name}.backup"
  end

  def backup_file
    @backup_file ||= File.new(backup_path)
  end
end
