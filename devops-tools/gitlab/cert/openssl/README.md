Step1: Generate certificate key pair for Gitlab server FQDN

mkdir ssl
cd ssl/

cat sslcert.conf 
[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no
[req_distinguished_name]
C = IN
ST = MH
L = Mumbai
O = stack
OU = devops
CN = gitserver.stack.com
[v3_req]
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth, clientAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = gitserver.stack.com
DNS.2 = gitrunner.stack.com

openssl req -x509 -nodes -days 730 -newkey rsa:2048 -keyout gitserver.stack.com.key -out gitserver.stack.com.crt -config sslcert.conf -extensions 'v3_req'
Generating a RSA private key


Step2: Edit the external_url in /etc/gitlab/gitlab.rb

sudo cat /etc/gitlab/gitlab.rb | grep external_url
##! For more details on configuring external_url see:
external_url 'https://gitserver.stack.com'

Step3: Create the /etc/gitlab/ssl directory and copy your key and certificate
sudo mkdir -p /etc/gitlab/ssl
sudo chmod 755 /etc/gitlab/ssl
sudo cp gitserver.stack.com.key gitserver.stack.com.crt /etc/gitlab/ssl/

Step4: Reconfigure Gitlab
sudo gitlab-ctl reconfigure


Step5: Validate the Gitlab SSL setup
openssl s_client -connect gitserver.stack.com:443












