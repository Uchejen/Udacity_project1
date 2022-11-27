data "azurerm_resource_group" "project1" {
  name = "${var.prefix}-resources"
}

data "azurerm_platform_image" "ubutuImage" {
  location  = data.azurerm_resource_group.project1.location
  publisher = "Canonical"
  offer     = "UbuntuServer"
  sku       = "18.04-LTS"
}
resource "azurerm_virtual_network" "project1" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.project1.location
  resource_group_name = data.azurerm_resource_group.project1.name
  tags                = var.tagname
}

resource "azurerm_subnet" "project1" {
  name                 = "internal"
  resource_group_name  = data.azurerm_resource_group.project1.name
  virtual_network_name = azurerm_virtual_network.project1.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "project1" {
  name                = "${var.prefix}-nsg"
  resource_group_name = data.azurerm_resource_group.project1.name
  location            = data.azurerm_resource_group.project1.location
  tags                = var.tagname
}

resource "azurerm_public_ip" "project1" {
  name                = "ip_public"
  resource_group_name = data.azurerm_resource_group.project1.name
  location            = data.azurerm_resource_group.project1.location
  allocation_method   = "Static"
  tags                = var.tagname
}

resource "azurerm_network_interface" "project1" {
  name                = "${var.prefix}-nic"
  resource_group_name = data.azurerm_resource_group.project1.name
  location            = data.azurerm_resource_group.project1.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.project1.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tagname
}

resource "azurerm_lb" "project1" {
  name                = "load_balancer"
  resource_group_name = data.azurerm_resource_group.project1.name
  location            = data.azurerm_resource_group.project1.location
  sku                 = "Basic"


  frontend_ip_configuration {
    name                 = "front_end"
    public_ip_address_id = azurerm_public_ip.project1.id
  }

  tags = var.tagname
}

resource "azurerm_lb_backend_address_pool" "project1" {
  name            = "backend"
  loadbalancer_id = azurerm_lb.project1.id
}


resource "azurerm_availability_set" "project1" {
  name                         = "availability"
  resource_group_name          = data.azurerm_resource_group.project1.name
  location                     = data.azurerm_resource_group.project1.location
  platform_fault_domain_count  = var.vmnumber
  platform_update_domain_count = var.vmnumber
  depends_on = [
    data.azurerm_resource_group.project1
  ]
  tags = var.tagname
}

resource "azurerm_linux_virtual_machine" "project1" {
  name                            = "${var.prefix}-vm"
  resource_group_name             = data.azurerm_resource_group.project1.name
  location                        = data.azurerm_resource_group.project1.location
  size                            = "Standard_D2s_v3"
  admin_username                  = var.username
  admin_password                  = var.password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.project1.id
  ]

  source_image_reference {
    publisher = data.azurerm_platform_image.ubutuImage.publisher
    offer     = data.azurerm_platform_image.ubutuImage.offer
    sku       = data.azurerm_platform_image.ubutuImage.sku
    version   = data.azurerm_platform_image.ubutuImage.version
  }
  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  tags = var.tagname
}

resource "azurerm_managed_disk" "project1" {
  count                = var.vmnumber
  name                 = "managed_disks"
  resource_group_name  = data.azurerm_resource_group.project1.name
  location             = data.azurerm_resource_group.project1.location
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1023"
  tags                 = var.tagname
}
