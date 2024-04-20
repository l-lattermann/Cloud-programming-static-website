# IU - Cloud programming project
This is a litte project written in Terraform, that deployes an AWS S3-Bucket with a AWS Cloudfront distribution and host a html template in the bucket. It can easily be used to host a more complex static website. 

#### If you want to use your own website:
Paste it into the "website" folder. Make sure that you include all the file extentions used in your project in the lookup table in the "mime_type.tf" file. Otherwise you might run into issues displaying the content correctly.

## Usage

**Make sure to download and install [Terraform](https://developer.hashicorp.com/terraform/downloads)**

**Clone or Copy the Module**

   Clone the directory from GitHub using the Git Bash.
Therefore navigate to directory you want to clone the project at and enter:
````cmd
git clone https://github.com/l-lattermann/Static-website-with-AWS-and-Terraform.git
````

Or download the .zip file from GitHub.

## Installation
1. Move the project folder to the desired directory. 

2. You will need to provide your AWS credentials now. Therefore open the credentials.txt file in the project folder, enter your username and your keys. Save the file and move it to:

Windows:
```cmd
 C:\Users\<USERNAME>\.aws\
```

Linux/MacOS:
```cmd
 ~/.aws/
```

3. Copy the path of the credentials.txt file. You will later have to paste it during execution of the terraform skript


## Execution
1. Open a shell or terminal in the project directory

2. Run 
   ````cmd
   terraform init
   ````
   to initialize your configuration.

3. Run 
   ````cmd
   terraform plan
   ````
    to check out the changes that will be made to your AWS.

5. Run 
   ````cmd
   terraform apply
   ````
    to create the AWS resources.
    #

6. Terraform will ask you to enter your AWS Region. Enter your region code, i.e.:
   ````cmd
   eu-north-1
   ````
6. Terraform will ask you to enter the bucket name. Enter a disered name (Must only contain lowercase alphanumeric characters and hyphens), i.e.:
   ````cmd
   this-is-my-test-bucket
   ````
   Terrafrom will add an UUID at the end of the bucket name to ensure it is unique.
   
7. Terraform will ask you to enter the path to your credentials.txt file. Paste the path you copied earlier, make sure to remove any quotation marks, i.e.:

   Windows:
   ````cmd
   C:\Users\<USERNAME>\.aws\credentials.txt
   ````
   Linux/MacOS:
   ````cmd
   ~/.aws/credentials.txt
   ````
8. Terraform will ask you to enter the user name under which the credentials in the credentials.txt file are listed.

   credentials.txt:
   ```
   [<User_name>]
   aws_access_key_id = **************
   aws_secret_access_key = **************************
   ````

   Enter the user name.

9. Terraform should now have all information needed to build the project into your AWS. If any of the inputs were faulty you will be prompted an error message.