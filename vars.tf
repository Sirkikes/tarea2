variable "location" {
  type = string
  description = "Región de Azure donde crearemos la infraestructura"
  default = "West Europe"
}

variable "vms_size" {
  description = "Tamaño de las máquinas virtuales"
  type = list(string)
  default = ["Standard_B2s", "Standard_B1ms", "Standard_B1ms"]
}

variable "vms_name" {
  description = "Nombre de las máquinas virtuales"
  type = list(string)
  default = ["master", "nfs", "worker01"]
}

variable "storage_account" {
  type = string
  description = "Nombre para la storage account"
  default = "saoggcp2"
}

variable "public_key_path" {
  type = string
  description = "Ruta para la clave pública de acceso a las instancias"
  default = "C:\\Users\\Lordkikes\\.ssh\\id_rsa.pub" # o la ruta correspondiente
  
}

variable "ssh_user" {
  type = string
  description = "Usuario para hacer ssh"
  default = "enrique"
}