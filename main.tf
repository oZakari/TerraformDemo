# Creates a resource group
resource "azurerm_resource_group" "terraformrg" {
  name     = "${var.environment_prefix}-rg"
  location = var.region
}

# Create virtual network
resource "azurerm_virtual_network" "terraformnetwork" {
  name                = "${var.environment_prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.region
  resource_group_name = azurerm_resource_group.terraformrg.name

  tags = {
    environment = "PoC"
  }
}

# Create subnet
resource "azurerm_subnet" "terraformsubnet" {
  name                 = "${var.environment_prefix}-subnet"
  resource_group_name  = azurerm_resource_group.terraformrg.name
  virtual_network_name = azurerm_virtual_network.terraformnetwork.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "terraformpublicip" {
  name                = "${var.environment_prefix}-pip"
  location            = var.region
  resource_group_name = azurerm_resource_group.terraformrg.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "PoC"
  }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "terraformnsg" {
  name                = "${var.environment_prefix}-nsg"
  location            = var.region
  resource_group_name = azurerm_resource_group.terraformrg.name

  /*  security_rule {
    }
*/
  tags = {
    environment = "PoC"
  }
}


# Create network interface
resource "azurerm_network_interface" "terraformnic" {
  name                = "${var.environment_prefix}-nic"
  location            = var.region
  resource_group_name = azurerm_resource_group.terraformrg.name

  ip_configuration {
    name                          = "NicConfiguration"
    subnet_id                     = azurerm_subnet.terraformsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.terraformpublicip.id
  }

  tags = {
    environment = "PoC"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.terraformnic.id
  network_security_group_id = azurerm_network_security_group.terraformnsg.id
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.terraformrg.name
  }

  byte_length = 2
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "storageaccount" {
  name                     = join("", [var.environment_prefix, random_id.randomId.hex])
  resource_group_name      = azurerm_resource_group.terraformrg.name
  location                 = var.region
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "PoC"
  }
}

# Create virtual machine
resource "azurerm_virtual_machine" "terraformvm" {
  name                  = "${var.environment_prefix}-vm"
  location              = var.region
  resource_group_name   = azurerm_resource_group.terraformrg.name
  network_interface_ids = [azurerm_network_interface.terraformnic.id]
  vm_size               = var.vm_size

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  os_profile {
    computer_name  = var.computer_name
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }

  storage_os_disk {
    name              = "osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = azurerm_storage_account.storageaccount.primary_blob_endpoint
  }

  tags = {
    environment = "PoC"
  }
}
