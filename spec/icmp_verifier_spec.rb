# frozen_string_literal: true
require 'netchk/icmp_verifier'

describe Netchk::ICMPVerifier do
  context 'When pings succeeds' do
    it 'calculates durations properly' do
      durations = [
        0.2,
        0.1,
        0.6,
        1.2,
        6.4,
        12,
        123
      ]
      ping = double(:ping)
      allow(ping).to receive(:ping).and_return(true)
      allow(ping).to receive(:duration).and_return(*durations)
      allow(Netchk::ICMPVerifier::ICMP).to receive(:new).with(DOMAIN, nil, 1).and_return(ping)

      verifier = Netchk::ICMPVerifier.new
      stats = verifier.send(:ping, DOMAIN, durations.count)

      expect(stats[:durations]).to eq(durations)
      expect(stats[:failures]).to eq(0)
      expect(stats[:count]).to eq(durations.count)
    end

    it 'shows overall and per-host stats' do
      duration = 0.2
      ping = double(:ping)
      allow(ping).to receive(:ping).and_return(true)
      allow(ping).to receive(:duration).and_return(duration)
      allow(Netchk::ICMPVerifier::ICMP).to receive(:new).with(DOMAIN, nil, 1).and_return(ping)

      out, err, verifier = Netchk::ICMPVerifier.mocked([DOMAIN], 1)
      verifier.verify

      expect(out.string).to include("Stats for #{DOMAIN}")
      expect(out.string).to include('Overall stats for ping')
      expect(err.string).to be_empty
    end
  end

  context 'When ping fails' do
    it 'shows an error and overall stats' do
      ping = double(:ping)
      allow(ping).to receive(:ping).and_return(false)
      allow(ping).to receive(:exception).and_return(nil)
      allow(Netchk::ICMPVerifier::ICMP).to receive(:new).with(DOMAIN, nil, 1).and_return(ping)

      out, err, verifier = Netchk::ICMPVerifier.mocked([DOMAIN], 1)
      verifier.verify

      expect(err.string).to include('failed')
      expect(out.string).to include('Overall stats for ping')
    end
  end
end

