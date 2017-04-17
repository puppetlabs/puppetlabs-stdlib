# Fact: is_systemd
#
# Purpose: Figure out if we are on systemd or not
#
Facter.add('is_systemd') do
  setcode do
    f = Facter::Core::Execution.exec('/bin/systemctl is-system-running')
    if f == "" or f.nil? then
      false
    else
      true
    end
  end
end
