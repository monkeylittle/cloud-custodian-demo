policies:
  - name: ebs-copy-instance-tags
    mode:
      type: periodic
      schedule: rate(1 hour)
      role: ${ cloud_custodian_role_arn }
      execution-options:
        metrics_enabled: true
        log_group: /cloud_custodian/ebs_copy_instance_tags
    resource: ebs
    filters:
      - type: value
        key: "Attachments[0].Device"
        value: not-null
    actions:
      - type: copy-instance-tags
        tags:
          - Customer
          - Environment
