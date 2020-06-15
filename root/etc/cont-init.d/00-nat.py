#!/usr/bin/env python3

from ipaddress import ip_address, ip_network
from os import environ
from socket import AddressFamily
from subprocess import run
from sys import stderr
from typing import Any, Dict, List

from psutil import net_if_addrs


def main() -> None:
  mac_lf = environ["VIRT_MACVTAP_IF"]
  if_addrs = net_if_addrs()

  net_fam = {AddressFamily.AF_INET, AddressFamily.AF_INET6}
  addresses = (addr for addr in if_addrs[mac_lf]
               if addr.family == AddressFamily.AF_INET)
  address = next(addresses)
  if address:
    addr = address.address
    mask = address.netmask
    network = ip_network(f"{addr}/{mask}", False)

    prefix = network.prefixlen
    int_addr = int(ip_address(addr))
    complement = int_addr ^ (1 << (32 - prefix))

    new_mask = prefix - 1
    new_ip = ip_address(complement)
    new_network = ip_network(f"{new_ip}/{new_mask}", False)

    print(new_network)
  else:
    print(f"ERROR! -- No IPv4 addr for {mac_lf}", file=stderr)
    exit(1)


main()

