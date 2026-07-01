require_relative '../lib/jefferies_tube/layout_args'

RSpec.describe JefferiesTube::LayoutArgs do
  let(:lookup_context) { Object.new }
  let(:formats) { [:html] }

  def build(parameters)
    described_class.for(parameters, lookup_context: lookup_context, formats: formats)
  end

  context "Rails 8+ signature: _layout(lookup_context, formats, keys)" do
    let(:parameters) { [[:req, :lookup_context], [:req, :formats], [:req, :keys]] }

    it "returns three args in declared order" do
      expect(build(parameters)).to eq([lookup_context, formats, []])
    end
  end

  context "Rails 5.1–7 signature: _layout(formats, keys)" do
    let(:parameters) { [[:req, :formats], [:req, :keys]] }

    it "returns formats and keys, without lookup_context" do
      expect(build(parameters)).to eq([formats, []])
    end
  end

  context "unknown parameter name" do
    let(:parameters) { [[:req, :something_new]] }

    it "falls back to formats so the call still receives a sensible value" do
      expect(build(parameters)).to eq([formats])
    end
  end

  it "matches the number of arguments to the method's arity" do
    [
      [[:req, :lookup_context], [:req, :formats], [:req, :keys]],
      [[:req, :formats], [:req, :keys]]
    ].each do |params|
      expect(build(params).size).to eq(params.size)
    end
  end
end
