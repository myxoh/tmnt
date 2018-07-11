require './lib/line_breaker.rb'

describe LineBreaker do
  subject(:line_breaker) { described_class.new(file_path: file, line_number: line_number, contents: contents) }
  let(:file) { 'spec/example/lib/production.rb' }
  let(:line_number) { 3 }
  let(:contents) { File.read(file) }

  describe "#break_line! and #restore_line!" do
    it "modifies a line" do
      original_value = File.read(file).split("\n")[line_number - 1]
      expect(line_breaker).to receive(:suggested_error).and_return("New Line")
      expect { line_breaker.break_line! }.to change { File.read(file).split("\n")[line_number - 1] }.from(original_value).to("New Line")
      expect { line_breaker.restore_line! }.to change { File.read(file).split("\n")[line_number - 1] }.from("New Line").to(original_value)
    end
  end
end
