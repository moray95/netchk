# Netchk

Simple tool to troubleshoot internet connectivity issues. This tool verifies:

- your computer has at least one IP address
- you have at least one DNS configured
- you can reach the configured nameservers
- the nameservers can resolve hosts

Finally, some ICMP ping statistics are presented with average durations and error rates. 

## Installation

```sh
gem install netchk
```

## Usage

Just run `netchk` from your terminal and basic diagnosis will start showing you progress and
any error if present.

Note: On Linux system, this gem requires `sudo` to perform the ICMP ping operations. On macOS, this is not needed.  

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/moray95/netchk.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
