# frozen_string_literal: true
require 'netchk/cli'

describe  Netchk::CLI do
  context 'When config file not found' do
    it 'loads default config' do
      Netchk::CLI::CONFIG_FILES.each do |file|
        allow(File).to receive(:exists?).with(file).and_return(false)
      end

      config = Netchk::CLI.config
      expect(config).to eq(Config.new({}))
    end
  end

  context 'When a config file is found' do
    it 'loads the config file' do
      config_file = Netchk::CLI::CONFIG_FILES.first
      allow(File).to receive(:exists?).with(config_file).and_return(true)

      file_config = { 'test' => 'config' }
      allow(File).to receive(:read).with(config_file).and_return(YAML.dump(file_config))

      config = Netchk::CLI.config
      expect(config).to eq(Config.new(file_config))
    end
  end

  it 'runs the pipeline with the config' do
    config = Config.new({
                          key1: :config,
                          key2: :config
                        })
    verifiers = [
      double('verifier1'),
      double('verifier2'),
      double('verifier3')
    ]
    allow(Netchk::CLI).to receive(:config).and_return(config)
    allow(Netchk::CLI).to receive(:pipeline).and_return(verifiers)
    verifiers.each do |v|
      expect(v).to receive(:verify)
    end

    Netchk::CLI.run
  end
end
