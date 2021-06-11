class Machine
  attr_reader :hostname, :name, :ip, :groups, :hostvars, :raw_data

  def initialize(machine_name, machine_data)
    @raw_data = machine_data
    @name = machine_name
    @hostname = machine_data['hostname']
    @ip = "#{machine_data['network']['private']['address']}"
    @groups = []
    @hostvars = {
      ansible_ssh_host: "#{@ip}",
      ansible_host: "#{@ip}",
    }
  end

  def forwarded_port
    if @raw_data.include? 'forwarded_port'
      return @raw_data['forwarded_port']
    end
    return []
  end

  def scripts
    return @raw_data['common_scripts'] + @raw_data['scripts']
  end 

  def synced_folder
    return @raw_data['synced_folder']
  end

  def box
    return @raw_data['box']
  end

  def memory
    return @raw_data['memory']
  end

  def cpu
    return @raw_data['cpu']
  end

  def vram
    return @raw_data['vram']
  end

end