# frozen_string_literal: true
require 'netchk/dns_verifier'

describe Netchk::DNSVerifier do
  context 'When no DNS found' do
    it 'shows an error' do
      out, err, verifier = Netchk::DNSVerifier.mocked

      dns = Resolv::DNS.mocked([])
      allow(Resolv::DNS).to receive(:open).and_yield(dns)

      verifier.verify

      expect(out.string).to be_empty
      expect(err.string).to_not be_empty
    end
  end

  context 'When working DNS found' do
    it 'shows success' do
      out, err, verifier = Netchk::DNSVerifier.mocked

      dns = Resolv::DNS.mocked([DEFAULT_DNS])
      allow(Resolv::DNS).to receive(:open).and_yield(dns)

      expect_any_instance_of(Net::Ping::TCP).to receive(:ping?).and_return(true)
      verifier.verify

      expect(out.string).to_not be_empty
      expect(err.string).to be_empty
    end
  end

  context 'When non-working DNS found' do
    it 'shows error' do
      _, err, verifier = Netchk::DNSVerifier.mocked

      dns = Resolv::DNS.mocked([DEFAULT_DNS])
      allow(Resolv::DNS).to receive(:open).and_yield(dns)

      expect_any_instance_of(Net::Ping::TCP).to receive(:ping?).and_return(false)
      verifier.verify

      expect(err.string).to_not be_empty
    end
  end
end
