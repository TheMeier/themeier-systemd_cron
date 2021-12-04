#
# systemd_cron
# Create systemd timer/service to replace cron jobs
# You either need to define on_calendar or on_boot_sec
# @param on_calendar systemd timer OnCalendar= definition when to run the
#   service as defined in https://www.freedesktop.org/software/systemd/man/systemd.time.html
# @param on_boot_sec systemd timer OnBootSec= definition
# @param on_unitactive_sec systemd timer OnUnitActiveSec= definition
# @param command command string for ExecStart= defintion of the service to run
#   as defined in https://www.freedesktop.org/software/systemd/man/systemd.service.html
# @param service_description string for Description= defintion of the service
#   as defined in https://www.freedesktop.org/software/systemd/man/systemd.service.html
# @param ensure removes the instance if set to false or absent
# @param timer_description optional string for Description= defintion of the service
#  as defined in https://www.freedesktop.org/software/systemd/man/systemd.timer.html
# @param type type of service as defined in
#  https://www.freedesktop.org/software/systemd/man/systemd.service.html
# @param user username to run command User= as defined in
#  https://www.freedesktop.org/software/systemd/man/systemd.service.html
# @param additional_timer_params optional array with lines to append to [Timer] section
#
#   example: `'additional_timer_params'   => [ 'RandomizedDelaySec=10' ]`
# @param additional_service_params optional array with lines to append to [Service] section
#
#   example: `'additional_service_params' => [ 'OnFailure=status-email-user@%n.service' ]`
# @example Usage
#   systemd_cron { 'date':
#     on_calendar         => '*:0/10',
#     command             => '/bin/date',
#     service_description => 'Print date',
#     timer_description   => 'Run date.service every 10 minutes',
#   }
define systemd_cron (
  Optional[String]                          $command                   = undef,
  Optional[String]                          $service_description       = undef,
  Optional[String]                          $on_calendar               = undef,
  Optional[Variant[Integer,String]]         $on_boot_sec               = undef,
  Optional[Variant[Integer,String]]         $on_unitactive_sec         = undef,
  String                                    $timer_description         = "timer for ${service_description}",
  Variant[Boolean,Enum['present','absent']] $ensure                    = true,
  String                                    $type                      = 'oneshot',
  String                                    $user                      = 'root',
  Optional[Array]                           $additional_timer_params   = undef,
  Optional[Array]                           $additional_service_params = undef,
) {
  if $ensure == true or $ensure == 'present' {
    if ! $on_calendar and ! $on_boot_sec {
      fail("systemd_cron['${title}']: you need to define on_calendar or on_boot_sec")
    }
    if ! $command {
      fail("systemd_cron['${title}']: you need to define command")
    }
    if ! $service_description {
      fail("systemd_cron['${title}']: you need to define service_description")
    }
  }

  $file_ensure = $ensure ? {
    false    => 'absent',
    'absent' => 'absent',
    default  => 'present'
  }

  $service_ensure = $ensure ? {
    false    => false,
    'absent' => false,
    default  => true,
  }


  $unit_name = regsubst($title, '/' , '_', 'G')

  systemd::unit_file { "${unit_name}_cron.service":
    ensure  => $file_ensure,
    content => epp('systemd_cron/service.epp', {
        'description'       => $service_description,
        'command'           => $command,
        'user'              => $user,
        'type'              => $type,
        'additional_params' => $additional_service_params,
      }
    ),
  }
  systemd::unit_file { "${unit_name}_cron.timer":
    ensure  => $file_ensure,
    content => epp('systemd_cron/timer.epp', {
        'description'       => $timer_description,
        'on_calendar'       => $on_calendar,
        'on_boot_sec'       => $on_boot_sec,
        'on_unitactive_sec' => $on_unitactive_sec,
        'additional_params' => $additional_timer_params,
      }
    ),
  }
  service { "${unit_name}_cron.timer":
    ensure => $service_ensure,
    enable => $service_ensure,
  }

  if $service_ensure {
    Systemd::Unit_file["${unit_name}_cron.service"] -> Systemd::Unit_file["${unit_name}_cron.timer"] -> Service["${unit_name}_cron.timer"]
  } else {
    Service["${unit_name}_cron.timer"] -> Systemd::Unit_file["${unit_name}_cron.timer"] -> Systemd::Unit_file["${unit_name}_cron.service"]
  }
}
