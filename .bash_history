id
exit
pwd
ls -la
mkdir .ssh
cd .ssh/
ls -ltr
touch authorized_keys
chmod 600 authorized_keys 
sudo vi authorized_keys 
cd ..
chmod 700 .ssh
ls -ltra
sudo yum install git make gcc-c++ patch openssl-devel libyaml-devel libffi-devel libicu-devel libxml2 libxslt libxml2-devel libxslt-devel zlib-devel readline-devel mysql mysql-server mysql-devel ImageMagick ImageMagick-devel epel-release
sudo yum install nodejs npm --enablerepo=epel
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source .bash_profile
