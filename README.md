# 🌐 S3 Static Website Hosting using Terraform

This project demonstrates how to **host a static website on AWS S3** using **Terraform**. 
It creates an S3 bucket, enables static website hosting, uploads `index.html` and `style.css`, and outputs the public URL of the site.

##  Project Structure
├── index.html # Main HTML page
|
├── style.css # CSS styling for the website
|
├── main.tf # Terraform resources (S3 bucket, objects, policies)
|
├── provider.tf # AWS provider configuration
|
├── output.tf # Outputs (Website URL)
|
└── .gitignore # Ignore .terraform, state files

## 📥 Clone This Repository
### To clone this portfolio on your local system, run:
```
git clone https://github.com/aakansha113/Terraform-s3-bucket-static-website-hosting.git
```

### STEP 1:
Initialize Terraform
```
terraform init
```

### STEP 2:
#### Validate and Plan:
```
terraform validate
terraform plan
```

### STEP 3:
#### Apply the configuration
```
terraform apply -auto-approve
```

### STEP 4:
#### Get the Website URL

##### terraform output website_url-
```
http://my-bucket-xyz.s3-website-us-east-1.amazonaws.com
```

### STEP 5:
```
terraform destroy -auto-approve
```
### ⭐ Show Your Support
#### If you like this portfolio, feel free to ⭐ star the repo!
