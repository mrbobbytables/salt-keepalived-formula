==========
Keepalived
==========

Formula for managing keepalived

Tested with the following platforms:

- Centos 7
- Fedora 22
- Fedora 23
- Oracle Linux 7
- Ubuntu 12.04 (Precise)
- Ubuntu 14.04 (Trusty)

----

.. contents::

States
======

``keepalived``
----------

**Pillar Example:**

::

  keepalived:
    lookup:
      non_local_bind: true
      scripts:
        - name: /opt/scripts/test_1.sh
          source: salt://test-data/script_1.sh
        - name: /opt/scripts/test_2.sh
          source: salt://test-data/script_2.sh
          user: vagrant
          group: vagrant
          mode: 777

      config:
        global_defs:
          notification_email: 
           - test@test.test
          notification_email_from: test@test2.test
          smtp_server: smtp.test.test
          smtp_connect_timeout: 30
        vrrp_scripts:
          chk_test_1:
            script: /opt/scripts/test_1.sh
            interval: 1
            weight: 1
          chk_test_2:
            script: /opt/scripts/test_2.sh
            interval: 2
            weight: 2
        vrrp_instances:
          MAIN:
            state: MASTER
            interface: eth0
            virtual_router_id: 1
            authentication:
              auth_type: PASS
              auth_pass: derp
            vrrp_unicast_bind: 192.168.0.2
            vrrp_unicast_peer:
              - 192.168.0.3
              - 192.168.0.4
            virtual_ipaddresses:
              - 192.168.0.22/24 dev eth0
              - 192.168.0.23/24 dev eth0
            track_script:
              - chk_test_1
              - chk_test_2

----
