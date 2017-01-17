systemd_cron
===========================

Create systemd timer/service to replace cron jobs

Parameters
----------

* `ensure`
boolean defaults to true, removes the instance if set to false

* `user`
username to run command User= as defined in
https://www.freedesktop.org/software/systemd/man/systemd.service.html
defaults to `root`

* `on_calendar`
systemd timer OnCalendar= definition when to run the service as defined in
https://www.freedesktop.org/software/systemd/man/systemd.time.html
 
* `timer_description`
optional string for Description= defintion of the service as defined in
https://www.freedesktop.org/software/systemd/man/systemd.timer.html
  
* `command`
command string for ExecStart= defintion of the service to run as defined in 
https://www.freedesktop.org/software/systemd/man/systemd.service.html

* `service_description`
string for Description= defintion of the service as defined in 
https://www.freedesktop.org/software/systemd/man/systemd.service.html

* `additional_timer_params`
optional array with lines to append to [Timer] section
```
'additional_timer_params'   => [ 'RandomizedDelaySec=10' ]
```

* `additional_service_params`
optional array with lines to append to [Service] section
```
'additional_service_params' => [ 'OnFailure=status-email-user@%n.service' ],
```

Examples
--------

```
   systemd_cron { 'date':
     on_calendar         => '*:0/10',
     command             => '/bin/date',
     service_description => 'Print date',
     timer_description   => 'Run date.service every 10 minutes',
   }
```

