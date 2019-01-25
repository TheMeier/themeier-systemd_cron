require 'spec_helper'
require 'rspec-puppet-facts'
include RspecPuppetFacts

describe 'systemd_cron' do
  on_supported_os.each do |os|
    context "on #{os}" do
      context 'test' do
        let :title do
          'date'
        end

        let :facts do
          {
            path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          }
        end
        let :params do
          {
            on_calendar: '*:0/10',
            command: '/bin/date',
            service_description: 'Print date cron',
          }
        end

        it { is_expected.to compile }
        it { is_expected.to contain_file("/etc/systemd/system/#{title}_cron.service").with_content(%r{# Managed by Puppet do not edit!}) }
        it { is_expected.to contain_file("/etc/systemd/system/#{title}_cron.service").with_content(%r{Description=Print date}) }
        it { is_expected.to contain_file("/etc/systemd/system/#{title}_cron.service").with_content(%r{Type=oneshot}) }
        it { is_expected.to contain_file("/etc/systemd/system/#{title}_cron.service").with_content(%r{ExecStart=\/bin\/date}) }
        it { is_expected.to contain_file("/etc/systemd/system/#{title}_cron.service").with_content(%r{User=root}) }

        it { is_expected.to contain_file("/etc/systemd/system/#{title}_cron.timer").with_content(%r{Description=timer for Print date cron}) }
        it { is_expected.to contain_file("/etc/systemd/system/#{title}_cron.timer").with_content(%r{OnCalendar=\*:0\/10}) }
      end

      context 'use ensure present' do
        let :title do
          'date'
        end
        let :facts do
          {
            path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          }
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
        it { is_expected.to contain_file("/etc/systemd/system/#{title}_cron.service").with_content(%r{# Managed by Puppet do not edit!}) }
        it { is_expected.to contain_file("/etc/systemd/system/#{title}_cron.service").with_content(%r{Description=Print date}) }
        it { is_expected.to contain_file("/etc/systemd/system/#{title}_cron.service").with_content(%r{Type=oneshot}) }
        it { is_expected.to contain_file("/etc/systemd/system/#{title}_cron.service").with_content(%r{ExecStart=\/bin\/date}) }
        it { is_expected.to contain_file("/etc/systemd/system/#{title}_cron.service").with_content(%r{User=root}) }
        it { is_expected.to contain_file("/etc/systemd/system/#{title}_cron.timer").with_content(%r{Description=timer for Print date cron}) }
        it { is_expected.to contain_file("/etc/systemd/system/#{title}_cron.timer").with_content(%r{OnCalendar=\*:0\/10}) }
      end

      context 'optional params' do
        let :title do
          'date'
        end

        let :facts do
          {
            path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          }
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
  end
end
