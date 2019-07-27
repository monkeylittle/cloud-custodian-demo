policies:
  - name: scheduled-availability-stop
    mode:
      type: periodic
      schedule: rate(1 hour)
      role: ${ cloud_custodian_role_arn }
      execution-options:
        metrics_enabled: true
        log_group: /cloud_custodian/scheduled_availability
    resource: asg
    filters:
      - type: offhour
        offhour: 17
        tag: AvailabilitySchedule
        default_tz: bst
    actions:
      - type: suspend
      - type: notify
        slack_template: custodian-slack-asg-suspend-notification-template
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
    resource: asg
    filters:
      - type: onhour
        onhour: 8
        tag: AvailabilitySchedule
        default_tz: bst
    actions:
      - type: resume
      - type: notify
        slack_template: custodian-slack-asg-resume-notification-template
        to:
          - ${ cloud_custodian_mailer_slack_hook_url }
        transport:
          type: sqs
          queue: ${ cloud_custodian_mailer_queue_url }
