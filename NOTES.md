# Networking

### Networking information that needs to be shared across domains

| Information | Required by | Depends on |
| -- | -- | -- |
| VLANs | RouterOS, NixOS | - |
| IPv4 subnets | RouterOS | VLANs |
| IPv6 ULA | RouterOS, NixOS | - |
| Static management addresses | ~RouterOS, ~NixOS, DNS (NixOS) | VLANs, IPv6 ULA |
| Host FQDNs | RouterOS, NixOS, DNS | - |



| Data | - |
| - | - |


RouterOS identity = Domain

RouterOS VLANs = VLANs
RouterOS ULA pool = Root ULA + VLANs
RouterOS interface IPv6 address = Root ULA + VLANs
RouterOS ND = Root ULA + VLANs

RouterOS interface IPv4 address = Root IPv4 + VLANs
RouterOS IPv4 DHCP pools = Root IPv4 + VLAN


NixOS identity = Domain
NixOS server interface IPv6 address = Root ULA + VLANs
NixOS server virtual networking = VLANs

DNS address = Root ULA + VLANs
DNS static records = Static host names + per host static address



DDNS is nice in theory but letting hosts modify DNS records isn't a good practice security wise. DDNS might be suitable for a kubernetes cluster
DNS records require that the *flake* contains a mapping from service/host name to address. This might require VLAN information as well?


ULA can be stored as "aaaa:bbbb:cccc:dddd" with a prefix property. 
- RouterOS renders as "${x.ula.raw}::/${x.ula.bits}"
- DNS record source renders as "<fqdn>" = "${x.ula.raw}::${builtins.substring 0 16 (builtins.hashString "sha256" "<fqdn-prefix>")}/${x.ula.bits}"

Gotta think more like a Nix engineer. Modules!

new NixOS module: foo.dsn."<fqdn>".AAAA = "<some-address>"

could be pretty cool.


But do I need a module?

Things that need static address:

| Device | FQDN |
| - | -|
| CCR2004 | router.infra |
| CRS305 | aggr.infra |
| CRS310 | patch.infra |
| WAX220 | wifi.infra |
| nwbox | nwbox.infra |
| hybrid | hybrid.infra |
| storage | storage |


Who is responsible for defining static addresses?

- Hosts (NixOS, RouterOS)
- Flake



----
Hold, I need to look at the bigger picture.

IPv4 is purely handled by RouterOS and DHCP. It's there for backup and legacy.

IPv6 should only be handled by NixOS when a static address is required.

*I don't need to stress about IPv4 address arithmatic, because that can be handled by IaC*

Instead of defining one big "networking" config with functionality I should pass everything in with lib or a custom extra argument
