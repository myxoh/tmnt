require './lib/file_breaker.rb'

describe FileBreaker do
  subject(:file_breaker) { described_class.new(file_path) }
  let(:file_path) { 'spec/example/lib/production.rb' }
  let(:backup_path) { 'spec/example/lib/production.rb.backup' }

  it "can run a block for each line" do
    changed_lines = []

    file_breaker.break_lines do |line_change|
      changed_lines << line_change[:line]
    end

    expect(changed_lines).to eq (1..41).to_a
  end

  describe '#create_backup!' do
    it "creates a backup file with the same contents as the original file" do
      file_breaker.create_backup!

      expect(File.exists?(backup_path)).to be true
      expect(File.read(backup_path)).to eq File.read(file_path)
    end
  end

  describe '#break_lines' do
    subject(:break_lines) { file_breaker.break_lines { |_| } }

    context "if the process doesn't fail" do
      it "does not change the file after the process is done" do
        expect { break_lines }.not_to change { File.read(file_path) }
      end

      it 'creates and deletes backup' do
        expect(file_breaker).to receive(:create_backup!)
        expect(file_breaker).to receive(:delete_backup!)
        break_lines
      end

      it "does not maintain a backup file after the process is done" do
        break_lines
        expect(File.exists?(backup_path)).to be false
      end
    end

    context "if the process fails" do
      before do
        allow_any_instance_of(LineBreaker).to receive(:break_line!).and_raise("an error")
      end

      it "does not maintain a backup file after the process fails" do
        break_lines
        expect(File.exists?(backup_path)).to be false
      end
    end
  end
end
