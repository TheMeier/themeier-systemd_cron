# @summary systemd_cron
#   Create systemd timer/service to replace cron jobs
#   You either need to define on_calendar or on_boot_sec
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
# @param additional_timer_params **Deprecated** use `timer_overrides` instead
#   can not be used in combination with `timer_overrides`
#
#   array with lines to append to [Timer] section
#
#   example: `'additional_timer_params'   => [ 'RandomizedDelaySec=10' ]`
# @param additional_service_params **Deprecated** use `service_overrides` instead
#   can not be used in combination with `service_overrides`
#
#   array with lines to append to [Service] section
#
#   example: `'additional_service_params' => [ 'User=bob' ]`
# @param service_overrides override for the`[Service]` section of the service
#   can not be used in combination with `additional_service_params`
#
#   example: `'service_overrides' => { 'Wants' => 'network-online.target' }`
# @param timer_overrides override for the`[Timer]` section of the timer
#   can not be used in combination with `additional_timer_params`
#
#   example: `'timer_overrides' => { 'OnBootSec' => '10' }`
# @param service_unit_overrides override for the`[Unit]` section of the service
#   can not be used in combination with `additional_service_params`
#
#   example: `'service_unit_overrides' => { 'Wants' => 'network-online.target' }`
# @param timer_unit_overrides override for the `[Unit]` section of the timer
#   can not be used in combination with `additional_timer_params`
#
#   example: `'timer_unit_overrides' => { 'Documentation' => 'Very special timer' }`
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
  Optional[Array]                           $additional_timer_params   = undef, # remove in V3
  Optional[Array]                           $additional_service_params = undef, # remove in V3
  Systemd::Unit::Service                    $service_overrides         = {},
  Systemd::Unit::Timer                      $timer_overrides           = {},
  Systemd::Unit::Unit                       $timer_unit_overrides      = {},
  Systemd::Unit::Unit                       $service_unit_overrides    = {},
) {
  if $ensure == true or $ensure == 'present' {
    if ! $on_calendar and ! $on_boot_sec {
      fail("systemd_cron['${title}']: you need to define on_calendar or on_boot_sec")
    }
    if ! $command {
      fail("systemd_cron['${title}']: you need to define command")
    }
  }

  # remove in V3
  if $additional_timer_params and ( $timer_overrides != {} or $timer_unit_overrides != {}) {
    fail("systemd_cron['${title}']: you can't use additional_timer_params and timer_overrides at the same time")
  }
  # remove in V3
  if $additional_service_params and ( $service_overrides != {} or $service_unit_overrides != {}) {
    fail("systemd_cron['${title}']: you can't use additional_service_params and service_overrides at the same time")
  }
  # remove in V3
  if $additional_timer_params {
    warning("Parameter 'additional_timer_params is deprecated. Please use the alternative parameter 'timer_overrides' instead.")
    $_timer_overrides = $additional_timer_params.reduce({}) |Hash $memo, $item| {
      $matches = $item.match(/^(.+)=(.*)$/)
      notice( "matches: ${matches}")
      $memo + { $matches[1] => $matches[2] }
    }
  } else {
    $_timer_overrides = $timer_overrides
  }

  # remove in V3
  if $additional_service_params {
    warning("Parameter 'additional_service_params is deprecated. Please use the alternative parameter 'service_overrides' instead.")
    $_service_overrides = $additional_service_params.reduce({}) |Hash $memo, $item| {
      $matches = $item.match(/^(.+)=(.*)$/)
      notice( "matches: ${matches}")
      $memo + { $matches[1] => $matches[2] }
    }
  } else {
    $_service_overrides = $service_overrides
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

  systemd::manage_unit { "${unit_name}_cron.service":
    ensure        => $file_ensure,
    unit_entry    => delete_undef_values({
        'Description' => $service_description ,
    }) + $service_unit_overrides,
    service_entry => delete_undef_values({
        'ExecStart' => $command, # if ensure present command is defined is checked above
        'User'      => $user, # defaults apply
        'Type'      => $type, # defaults apply
    }) + $_service_overrides,
  }
  systemd::manage_unit { "${unit_name}_cron.timer":
    ensure        => $file_ensure,
    unit_entry    => delete_undef_values({
        'Description' => $timer_description ,
    }) + $timer_unit_overrides,
    timer_entry   => delete_undef_values({
        'OnCalendar'      => $on_calendar,
        'OnBootSec'       => $on_boot_sec,
        'OnUnitActiveSec' => $on_unitactive_sec,
    }) + $_timer_overrides,
    install_entry => {
      'WantedBy' => 'timers.target',
    },
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
