require_relative  'inventory'
require_relative  'machine'

def generate_machines(inventory_machines)
  machines = []
  inventory_machines.each do |machine_name, data|  
    machine = Machine.new(machine_name, data)
    machines.push(machine)
  end

  return machines
end

def get_inventory(inventory_machines)
 

  inventory = Inventory.new(inventory_machines)

  groups = {}
  hostvars = {}

  return inventory

end

def generate_inventory(machines, inventory_file)
  # create empty inventory file
  File.open("#{inventory_file}" ,'w') do | f |
    f.write ""
  end

  machines.each do |machine|
    File.open("#{inventory_file}" ,'a') do | f |
      hostvars = machine.hostvars.map{|k,v| "#{k}=#{v}"}.join(' ')
      f.write "#{machine.name} #{hostvars}\n"
    end
  end

  File.open("#{inventory_file}" ,'a') do | f |
    f.write "\n"
  end

end