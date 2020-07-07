# frozen_string_literal: true
require 'netchk/ip_verifier'
require 'socket'

describe Netchk::IpVerifier do
  context 'When one ip is found' do
    it 'shows no errors' do
      allow(Socket).to receive(:ip_address_list).and_return([DEFAULT_IP])

      out, err, verifier = Netchk::IpVerifier.mocked
      verifier.verify

      expect(out.string).not_to be_empty
      expect(err.string).to be_empty
    end
  end

  context 'When no ip is found' do
    it 'shows an error' do
      allow(Socket).to receive(:ip_address_list).and_return([])

      out, err, verifier = Netchk::IpVerifier.mocked
      verifier.verify

      expect(out.string).to be_empty
      expect(err.string).not_to be_empty
    end
  end

  context 'When only loopback ip is found' do
    it 'shows an error' do
      allow(Socket).to receive(:ip_address_list).and_return([LOOPBACK_IP])

      out, err, verifier = Netchk::IpVerifier.mocked
      verifier.verify

      expect(out.string).to be_empty
      expect(err.string).not_to be_empty
    end
  end
end
