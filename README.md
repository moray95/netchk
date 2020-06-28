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

You also can configure how netchk verifies your connections by configuring a `~/.netchk.yaml` or `~/.netchk.yml` file
like below.

```yaml
# Settings to test DNS server connectivity.
dns:
  # Path to resolv.conf file to check presence and connectivity of DNS.
  # Path should be absolute to avoid issues when running netchk
  # from different directories.
  resolv.conf: /etc/resolv.conf

# Settings to test DNS resolution.
resolv:
  # Path to resolv.conf file to use for testing DNS resolution.
  # Path should be absolute to avoid issues when running netchk
  # from different directories. It is advised to be the same
  # as dns.resolv.conf.
  resolv.conf: /etc/resolv.conf
  # The list of domains to test for DNS resolution.
  domains:
    - google.com
    - youtube.com
    - facebook.com 

# Settings to test icmp ping.
icmp:
  # A list of hosts to ping with ICMP. It is advised to use
  # IP addresses instead of domains to rule out any issues with
  # DNS resolution, which is tested separately.
  hosts:
    - 1.1.1.1
    - 8.8.8.8
  # The number of ping to issue each host.
  count: 20
  # The duration in seconds to wait between each ping.
  # Setting this value too low might cause timeouts.
  interval: 0.2
```     

Each value is optional. If one is missing the default value will be used. The file above shows the default values.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/moray95/netchk.
