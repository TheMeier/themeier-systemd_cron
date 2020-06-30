require 'spec_helper_acceptance'

describe 'basic test' do
  context 'applies the manifest twice with no stderr and creates files' do
    pp = <<-EOS
      systemd_cron { 'date':
        on_calendar         => '*:0/10',
        command             => '/bin/date',
        service_description => 'Print date',
        timer_description   => 'Run date.service every 10 minutes',
      }
    EOS

    idempotent_apply(pp)
    describe file('/etc/systemd/system/date_cron.service') do
      it { is_expected.to be_file }
    end
    describe file('/etc/systemd/system/date_cron.timer') do
      it { is_expected.to be_file }
    end
    describe service('date_cron.timer') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end
  end
end
