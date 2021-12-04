require 'spec_helper'
require 'rspec-puppet-facts'
include RspecPuppetFacts

describe 'systemd_cron' do
  let :facts do
    {
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }
  end

  on_supported_os.each do |os|
    context "on #{os}" do
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
            .with_content(%r{# Managed by Puppet do not edit!})
            .with_content(%r{Description=Print date})
            .with_content(%r{Type=oneshot})
            .with_content(%r{ExecStart=\/bin\/date})
            .with_content(%r{Type=oneshot})
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
            .with_content(%r{# Managed by Puppet do not edit!})
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
            on_calendar: '*:0/10',
            command: '/bin/date',
            service_description: 'Print date cron',
            ensure: 'absent',
          }
        end

        it {
          is_expected.to contain_Service("#{title}_cron.timer")
            .that_comes_before("Systemd::Unit_file[#{title}_cron.timer]")
        }
        it {
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
            additional_service_params: ['OnFailure=status-email-user@%n.service'],
          }
        end

        it { is_expected.to compile }
        it { is_expected.to contain_file("/etc/systemd/system/#{title}_cron.service").with_content(%r{OnFailure=status-email-user@%n.service}) }

        it { is_expected.to contain_file("/etc/systemd/system/#{title}_cron.timer").with_content(%r{RandomizedDelaySec=10}) }
      end
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

      it { is_expected.to compile }
      it { is_expected.to contain_file("/etc/systemd/system/#{title}_cron.timer").with_content(%r{OnBootSec=100}) }
      it { is_expected.to contain_file("/etc/systemd/system/#{title}_cron.timer").with_content(%r{OnUnitActiveSec=100}) }
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

      it { is_expected.to compile }
      it { is_expected.to contain_file('/etc/systemd/system/t_i_t_l_e_cron.timer') }
      it { is_expected.to contain_file('/etc/systemd/system/t_i_t_l_e_cron.service') }
    end
  end
end
