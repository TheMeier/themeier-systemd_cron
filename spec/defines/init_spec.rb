require 'spec_helper'
require 'rspec-puppet-facts'
include RspecPuppetFacts

describe 'systemd_cron' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts.merge(
          path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        )
      end

      context 'test' do
        let :title do
          'date'
        end

        let :params do
          {
            on_calendar: '*:0/10',
            command: '/bin/date',
            service_description: 'Print date cron',
          }
        end

        it { is_expected.to compile }
        it {
          is_expected.to contain_file("/etc/systemd/system/#{title}_cron.service")
            .with_content(%r{# Deployed with puppet})
            .with_content(%r{Description=Print date})
            .with_content(%r{Type=oneshot})
            .with_content(%r{ExecStart=\/bin\/date})
            .with_content(%r{Type=oneshot})
            .with_content(%r{User=root})
        }

        it {
          is_expected.to contain_file("/etc/systemd/system/#{title}_cron.timer")
            .with_content(%r{Description=timer for Print date cron})
            .with_content(%r{WantedBy=timers.target})
        }
        it {
          is_expected.to contain_file("/etc/systemd/system/#{title}_cron.timer")
            .with_content(%r{OnCalendar=\*:0\/10})
        }
        it {
          is_expected.to contain_Systemd__Unit_file("#{title}_cron.service")
            .that_comes_before("Systemd::Unit_file[#{title}_cron.timer]")
        }
        it {
          is_expected.to contain_Systemd__Unit_file("#{title}_cron.timer")
            .that_comes_before("Service[#{title}_cron.timer]")
        }
      end

      context 'use ensure present' do
        let :title do
          'date'
        end

        let :params do
          {
            on_calendar: '*:0/10',
            command: '/bin/date',
            service_description: 'Print date cron',
            ensure: 'present',
          }
        end

        it { is_expected.to compile }
        it {
          is_expected.to contain_file("/etc/systemd/system/#{title}_cron.service")
            .with_content(%r{# Deployed with puppet})
        }
        it {
          is_expected.to contain_file("/etc/systemd/system/#{title}_cron.service")
            .with_content(%r{Description=Print date})
        }
        it {
          is_expected.to contain_file("/etc/systemd/system/#{title}_cron.service")
            .with_content(%r{Type=oneshot})
        }
        it {
          is_expected.to contain_file("/etc/systemd/system/#{title}_cron.service")
            .with_content(%r{ExecStart=\/bin\/date})
        }
        it {
          is_expected.to contain_file("/etc/systemd/system/#{title}_cron.service")
            .with_content(%r{User=root})
        }
        it {
          is_expected.to contain_file("/etc/systemd/system/#{title}_cron.timer")
            .with_content(%r{Description=timer for Print date cron})
        }
        it {
          is_expected.to contain_file("/etc/systemd/system/#{title}_cron.timer")
            .with_content(%r{OnCalendar=\*:0\/10})
        }
      end

      context 'ensure absent' do
        let :title do
          'date'
        end

        let :params do
          {
            ensure: 'absent',
          }
        end

        it {
          is_expected.to contain_Systemd__Manage_unit('date_cron.timer')
          is_expected.to contain_Systemd__Manage_unit('date_cron.service')
          is_expected.to contain_Service("#{title}_cron.timer")
            .that_comes_before("Systemd::Unit_file[#{title}_cron.timer]")
          is_expected.to contain_Systemd__Unit_file("#{title}_cron.timer")
            .that_comes_before("Systemd::Unit_file[#{title}_cron.service]")
        }
      end
      context 'optional params' do
        let :title do
          'date'
        end

        let :params do
          {
            on_calendar: '*:0/10',
            command: '/usr/bin/date',
            service_description: 'Print date',
            timer_description: 'Run date.service every 10 minutes',
            additional_timer_params: ['RandomizedDelaySec=10'],
            additional_service_params: ['User=bob'],
          }
        end

        it {
          is_expected.to compile
          is_expected.to contain_file("/etc/systemd/system/#{title}_cron.service")
            .with_content(%r{User=bob})
          is_expected.to contain_file("/etc/systemd/system/#{title}_cron.timer")
            .with_content(%r{RandomizedDelaySec=10})
        }
      end
      context 'failue when not passing on_calendar or on_boot_sec' do
        let :title do
          'date'
        end

        let :params do
          {
            command: '/usr/bin/date',
            service_description: 'Print date',
          }
        end

        it {
          is_expected.to compile.and_raise_error(%r{you need to define on_calendar or on_boot_sec})
        }
      end
      context 'with on_boot_sec' do
        let :title do
          'date'
        end

        let :params do
          {
            on_boot_sec: 100,
            on_unitactive_sec: 100,
            command: '/usr/bin/date',
            service_description: 'Print date',
            timer_description: 'Run date.service 100 seconds after boot',
          }
        end

        it {
          is_expected.to compile
          is_expected.to contain_file("/etc/systemd/system/#{title}_cron.timer")
            .with_content(%r{OnBootSec=100})
          is_expected.to contain_file("/etc/systemd/system/#{title}_cron.timer")
            .with_content(%r{OnUnitActiveSec=100})
        }
      end
      context 'with / in title' do
        let :title do
          't/i/t/l/e'
        end
        let :params do
          {
            on_calendar: '*:0/10',
            command: '/bin/true',
            service_description: 'do nothing !',
          }
        end

        it {
          is_expected.to compile
          is_expected.to contain_file('/etc/systemd/system/t_i_t_l_e_cron.timer')
          is_expected.to contain_systemd__manage_unit('t_i_t_l_e_cron.timer')
          is_expected.to contain_systemd__unit_file('t_i_t_l_e_cron.timer')
          is_expected.to contain_file('/etc/systemd/system/t_i_t_l_e_cron.service')
          is_expected.to contain_systemd__manage_unit('t_i_t_l_e_cron.service')
          is_expected.to contain_systemd__unit_file('t_i_t_l_e_cron.service')
          is_expected.to contain_service('t_i_t_l_e_cron.timer')
        }
      end
      context 'without command' do
        let :title do
          'date'
        end

        let :params do
          {
            on_boot_sec: 100,
            service_description: 'Print date',
            timer_description: 'Run date.service 100 seconds after boot',
          }
        end

        it { is_expected.to compile.and_raise_error(%r{you need to define command}) }
      end
      context 'fails with additional_service_params and service_overrides set' do
        let :title do
          'date'
        end

        let :params do
          {
            command: 'date',
            timer_description: 'Run date.service 100 seconds after boot',
            service_description: 'Print date',
            additional_service_params: ['OnFailure=status-email-user@%n.service'],
            service_overrides: { 'User' => 'root' },
            on_boot_sec: 100,
          }
        end

        it { is_expected.to compile.and_raise_error(%r{you can't use additional_service_params and service_overrides at the same time}) }
      end
      context 'fails with additional_timer_params and timer_overrides set' do
        let :title do
          'date'
        end

        let :params do
          {
            command: 'date',
            timer_description: 'Run date.service 100 seconds after boot',
            service_description: 'Print date',
            additional_timer_params: ['RandomizedDelaySec=10'],
            timer_overrides: { 'OnBootSec' => '60' },
            on_boot_sec: 100,
          }
        end

        it { is_expected.to compile.and_raise_error(%r{you can't use additional_timer_params and timer_overrides at the same time}) }
      end
      context 'applies service_overrides' do
        let :title do
          'date'
        end

        let :params do
          {
            command: 'date',
            service_overrides: { 'Group' => 'bob' },
            on_boot_sec: 100,
          }
        end

        it {
          is_expected.to contain_file("/etc/systemd/system/#{title}_cron.service")
            .with_content(%r{Group=bob})
        }
      end

      context 'applies service_unit_overrides' do
        let :title do
          'date'
        end

        let :params do
          {
            command: 'date',
            service_unit_overrides: { 'Wants' => 'network-online.target' },
            on_boot_sec: 100,
          }
        end

        it {
          is_expected.to contain_file("/etc/systemd/system/#{title}_cron.service")
            .with_content(%r{Wants=network-online.target})
        }
      end

      context 'applies timer_overrides' do
        let :title do
          'date'
        end

        let :params do
          {
            command: 'date',
            timer_overrides: { 'OnBootSec' => '200' },
            on_boot_sec: 100,
          }
        end

        it {
          is_expected.to contain_file("/etc/systemd/system/#{title}_cron.timer")
            .with_content(%r{OnBootSec=200})
        }
      end

      context 'applies timer_unit_overrides' do
        let :title do
          'date'
        end

        let :params do
          {
            command: 'date',
            timer_unit_overrides: { 'Wants' => 'network-online.target' },
            on_boot_sec: 100,
          }
        end

        it {
          is_expected.to contain_file("/etc/systemd/system/#{title}_cron.timer")
            .with_content(%r{Wants=network-online.target})
        }
      end
    end
  end
end
