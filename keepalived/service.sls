
{% if salt['test.provider']('service') == 'systemd' %}

keepalived-systemd-unit-helper:
  module.wait:
    - name: service.systemctl_reload


keepalived-systemd-enable-service:
  service.running:
    - name: keepalived.service
    - enable: true
    - init_delay: 5


{% else %}

keepalived-enable-service:
  service.running:
    - name: keepalived
    - enable: true
    - init_delay: 5

{% endif %}
