# Variable for alert email
variable "alert_email" {
  description = "Email address for cost and health alerts"
  type        = string
  default     = "robinpeeters1401@gmail.com"
}

# Variable for TeamSpeak Docker image tag
variable "image_tag" {
  description = "Docker image tag for TeamSpeak container"
  type        = string
  default     = "latest"
}