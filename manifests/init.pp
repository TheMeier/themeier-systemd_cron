#
# systemd_cron
# Create systemd timer/service to replace cron jobs
# @param on_calendar systemd timer OnCalendar= definition when to run the 
#   service as defined in https://www.freedesktop.org/software/systemd/man/systemd.time.html
# @param command command string for ExecStart= defintion of the service to run
#   as defined in https://www.freedesktop.org/software/systemd/man/systemd.service.html
# @param service_description string for Description= defintion of the service
#   as defined in https://www.freedesktop.org/software/systemd/man/systemd.service.html
# @param ensure removes the instance if set to false
# @param timer_description optional string for Description= defintion of the service
#  as defined in https://www.freedesktop.org/software/systemd/man/systemd.timer.html
# @param user username to run command User= as defined in 
#  https://www.freedesktop.org/software/systemd/man/systemd.service.html
# @param additional_timer_params optional array with lines to append to [Timer] section
#
#   example: `'additional_timer_params'   => [ 'RandomizedDelaySec=10' ]`
# @param additional_service_params optional array with lines to append to [Service] section
#
#   example: `'additional_service_params' => [ 'OnFailure=status-email-user@%n.service' ]`
# @example Usage
#   `systemd_cron { 'date':
#     on_calendar         => '*:0/10',
#     command             => '/bin/date',
#     service_description => 'Print date',
#     timer_description   => 'Run date.service every 10 minutes',
#   }`
define systemd_cron (
  String            $on_calendar,
  String            $command,
  String            $service_description,
  String            $timer_description = "timer for ${service_description}",
  Boolean           $ensure = true,
  String            $user = 'root',
  Optional[Array]   $additional_timer_params   = undef,
  Optional[Array]   $additional_service_params = undef,
) {

  $file_ensure = $ensure ? {
    false   => 'absent',
    default => 'present'
  }

  $service_ensure = $ensure ? {
    false   => 'stopped',
    default => 'running'
  }

  systemd::unit_file { "${title}_cron.service":
    ensure  => $file_ensure,
    content => epp('systemd_cron/service.epp', {
      'description'       => $service_description,
      'command'           => $command,
      'user'              => $user,
      'additional_params' => $additional_service_params,
      }
    ),
  }
  ->
  systemd::unit_file { "${title}_cron.timer":
    ensure  => $file_ensure,
    content => epp('systemd_cron/timer.epp', {
      'description'       => $timer_description,
      'on_calendar'       => $on_calendar,
      'additional_params' => $additional_timer_params,
      }
    ),
  }
  ->
  service { "${title}_cron.timer":
    ensure => $service_ensure,
    enable => $ensure,
  }

}
