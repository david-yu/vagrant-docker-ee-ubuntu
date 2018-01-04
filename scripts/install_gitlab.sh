#!/bin/bash
# see https://about.gitlab.com/downloads/#ubuntu1604
# see https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/README.md
# see https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/doc/settings/nginx.md#enable-https

set -eux

domain=$(hostname --fqdn)
testing=true

apt-get update

apt-get install -y --no-install-recommends httpie

# Install vim.
apt-get install -y --no-install-recommends vim
cat>/etc/vim/vimrc.local<<'EOF'
syntax on
set background=dark
set esckeys
set ruler
set laststatus=2
set nobackup
autocmd BufNewFile,BufRead Vagrantfile set ft=ruby
EOF

# Set the initial shell history.
cat >~/.bash_history <<'EOF'
tail -f /var/log/gitlab/gitlab-rails/*.log
gitlab-ctl reconfigure
vim /etc/gitlab/gitlab.rb
vim /etc/hosts
netstat -antp
EOF

# Install the gitlab deb repository.
apt-get install -y --no-install-recommends curl
wget -qO- https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | bash -ex

# Install gitlab with the omnibus package.
apt-get install -y --no-install-recommends gitlab-ce

# Create a self-signed certificate and add it to the global trusted list.
pushd /etc/ssl/private
openssl genrsa \
    -out $domain-keypair.pem \
    2048 \
    2>/dev/null
chmod 400 $domain-keypair.pem
openssl req -new \
    -sha256 \
    -subj "/CN=$domain" \
    -reqexts a \
    -config <(cat /etc/ssl/openssl.cnf
        echo "[a]
        subjectAltName=DNS:$domain
        ") \
    -key $domain-keypair.pem \
    -out $domain-csr.pem
openssl x509 -req -sha256 \
    -signkey $domain-keypair.pem \
    -extensions a \
    -extfile <(echo "[a]
        subjectAltName=DNS:$domain
        extendedKeyUsage=serverAuth
        ") \
    -days 365 \
    -in  $domain-csr.pem \
    -out $domain-crt.pem
cp $domain-crt.pem /usr/local/share/ca-certificates/$domain.crt
update-ca-certificates --verbose
popd

# Configure gitlab to use it.
install -m 700 -o root -g root -d /etc/gitlab/ssl
ln -s /etc/ssl/private/$domain-keypair.pem /etc/gitlab/ssl/$domain.key
ln -s /etc/ssl/private/$domain-crt.pem /etc/gitlab/ssl/$domain.crt
sed -i -E "s,^(external_url\s+).+,\1'https://$domain'," /etc/gitlab/gitlab.rb
sed -i -E "s,^(\s*#\s*)?(nginx\['redirect_http_to_https'\]\s+).+,\2= true," /etc/gitlab/gitlab.rb

# Configure gitlab.
gitlab-ctl reconfigure

# Set the gitlab root user password.
gitlab-rails console production <<'EOF'
u = User.first
u.password_automatically_set = false
u.password = 'dockeradmin'
u.password_confirmation = 'dockeradmin'
u.save!
EOF

# Set the gitlab sign in page title and description.
gitlab-rails console production <<'EOF'
a = Appearance.first_or_initialize
a.title = 'Docker EE Gitlab'
a.description = 'Sign in on the right or [explore the public projects](/explore/projects).'
a.save!
EOF

# See the gitlab services status.
gitlab-ctl status

# Show software versions.
dpkg-query --showformat '${Package} ${Version}\n' --show gitlab-ce
/opt/gitlab/embedded/bin/git --version
/opt/gitlab/embedded/bin/ruby -v
gitlab-rails --version
gitlab-psql --version
/opt/gitlab/embedded/bin/redis-server --version
/opt/gitlab/embedded/sbin/nginx -v
