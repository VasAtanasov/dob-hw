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