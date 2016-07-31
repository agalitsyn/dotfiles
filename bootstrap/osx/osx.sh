# Enable completions from homebrew for OS X
if [ `type -t brew` > /dev/null ] && [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

export PATH=/usr/local/mysql/bin:$PATH
export MYSQL_HOME=/usr/local/mysql
alias mysql-start='sudo $MYSQL_HOME/bin/mysqld_safe -uroot -p87654321'
alias mysql-stop='sudo $MYSQL_HOME/bin/mysqladmin shutdown -uroot -p87654321'
