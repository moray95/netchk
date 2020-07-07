# frozen_string_literal: true

require 'netchk/resolv_verifier'
require 'resolv'

describe Netchk::ResolvVerifier do
  context 'When resolution succeeds' do
    it 'shows success' do
      dns = double('dns')
      expect(dns).to receive(:getaddress).with(DOMAIN)
      expect(Resolv::DNS).to receive(:open).and_yield(dns)

      out, err, verifier = Netchk::ResolvVerifier.mocked([DOMAIN])

      verifier.verify

      expect(out.string).to_not be_empty
      expect(err.string).to be_empty
    end
  end

  context 'When resolution fails' do
    it 'shows error' do
      dns = double('dns')
      expect(dns).to receive(:getaddress).and_raise(Resolv::ResolvError.new)
      expect(Resolv::DNS).to receive(:open).and_yield(dns)

      out, err, verifier = Netchk::ResolvVerifier.mocked([DOMAIN])

      verifier.verify

      expect(out.string).to be_empty
      expect(err.string).to_not be_empty
    end
  end
end
