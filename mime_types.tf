variable "MIME_types" {
  default = {
    ".html" = "text/html",
    ".css"  = "text/css",
    ".js"   = "application/javascript",
    ".jpg"  = "image/jpeg",
    ".jpeg" = "image/jpeg",
    ".png"  = "image/png",
    ".gif"  = "image/gif",
    ".svg"  = "image/svg+xml",
    ".pdf"  = "application/pdf",
    ".txt"  = "text/plain",
  }
}