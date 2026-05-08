require_relative '../lib/jefferies_tube/coverage'

RSpec.describe JefferiesTube::Coverage do
  describe '.print_report' do
    let(:group) do
      instance_double('SimpleCov::FileList', size: 5, covered_percent: covered_percent)
    end
    let(:result) { instance_double('SimpleCov::Result', groups: {'Models' => group}) }

    before do
      allow(described_class).to receive(:puts)
      described_class.required_coverage = nil
    end

    context 'when coverage meets the required threshold' do
      let(:covered_percent) { 100.0 }

      it 'returns false' do
        expect(described_class.print_report(result)).to eq(false)
      end
    end

    context 'when coverage is below the required threshold' do
      let(:covered_percent) { 50.0 }

      it 'returns true' do
        expect(described_class.print_report(result)).to eq(true)
      end
    end

    context 'when coverage meets required but is below default' do
      let(:covered_percent) { 80.0 }

      before do
        described_class.required_coverage = {'Models' => 75}
      end

      it 'returns false' do
        expect(described_class.print_report(result)).to eq(false)
      end
    end

    context 'when group has zero files' do
      let(:empty_group) { instance_double('SimpleCov::FileList', size: 0) }
      let(:result) { instance_double('SimpleCov::Result', groups: {'Models' => empty_group}) }

      it 'skips the group and returns false' do
        expect(described_class.print_report(result)).to eq(false)
      end
    end
  end
end
