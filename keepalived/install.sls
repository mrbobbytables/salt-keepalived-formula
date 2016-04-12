{% from 'keepalived/map.jinja' import kad with context %}

{% if kad.non_local_bind %}

enable-non-local-bind:
  sysctl.present:
    - name: net.ipv4.ip_nonlocal_bind
      value: 1

{% endif %}

install-keepalived-package:
  pkg.installed:
    - name: keepalived
