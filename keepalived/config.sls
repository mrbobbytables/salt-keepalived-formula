{% from 'keepalived/map.jinja' import kad with context %}

{% for script in kad.scripts %}
sync-keepalived-script-{{ script.name }}:
  file.managed:
    - name: {{ script.name }}
    - source: {{ script.source }}
    - user: {{ script.user }}
    - group: {{ script.group }}
    - mode: '{{ script.mode }}'
    - makedirs: true
{% endfor %}


config-keepalived:
  file.managed:
    - name: /etc/keepalived/keepalived.conf
    - source: salt://keepalived/templates/keepalived.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644


{% if salt['service.available']('keepalived') %}

{% if salt['test.provider']('service') == 'systemd' %}
keepalived-config-systemd-unit-helper:
  module.wait:
    - name: service.systemctl_reload
    - watch:
      - file: config-keepalived
{% endif %}

keepalived-config-service-reloader:
  service.running:
    - name: keepalived
    - enable: true
    - watch:
      - file: config-keepalived
      
{% endif %}    
