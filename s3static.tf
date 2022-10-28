provider "aws" {
    region = "us-east-1"
  
}

resource "aws_s3_bucket" "bucket" {
    bucket = "fatihstaticbucket"   # bucket ismi
    acl = "public-read"  # dış dünyaya açtık

    provisioner "local-exec" {  # burada websitemiz için klasör oluşturup senk.ediyoruz.
        command = "aws s3 sync static/ s3://${aws_s3_bucket.bucket.bucket} --acl public-read --delete"
      
    }

    website {
        index_document = "index.html"  # index.html yolunu belirtiyoruz.
    }
  
}

output "website_endpoint" {
    value = aws_s3_bucket.bucket.website_endpoint  # static web sayfanın url ini output olarak vermesini istedik
  
}