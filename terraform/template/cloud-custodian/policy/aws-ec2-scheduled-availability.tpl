policies:
  - name: scheduled-availability-stop
    mode:
      type: periodic
      schedule: rate(1 hour)
      role: ${ cloud_custodian_role_arn }
      execution-options:
        metrics_enabled: true
        log_group: /cloud_custodian/scheduled_availability
    resource: ec2
    filters:
      - type: offhour
        offhour: 17
        tag: AvailabilitySchedule
        default_tz: bst
    actions:
      - type: stop
      - type: notify
        slack_template: custodian-slack-ec2-stop-notification-template
        to:
          - ${ cloud_custodian_mailer_slack_hook_url }
        transport:
          type: sqs
          queue: ${ cloud_custodian_mailer_queue_url }

  - name: scheduled-availability-start
    mode:
      type: periodic
      schedule: rate(1 hour)
      role: ${ cloud_custodian_role_arn }
      execution-options:
        metrics_enabled: true
        log_group: /cloud_custodian/scheduled_availability
    resource: ec2
    filters:
      - type: onhour
        onhour: 8
        tag: AvailabilitySchedule
        default_tz: bst
    actions:
      - type: start
      - type: notify
        slack_template: custodian-slack-ec2-start-notification-template
        to:
          - ${ cloud_custodian_mailer_slack_hook_url }
        transport:
          type: sqs
          queue: ${ cloud_custodian_mailer_queue_url }
