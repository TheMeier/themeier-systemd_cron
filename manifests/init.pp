# systemd_cron
# ===========================
#

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
