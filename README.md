State University Salaries
=======================

CLI tool for scraping florida state university employee salary data.

#### Setup

SUS is distributed as a ruby gem and can be installed on your system from github:

    git clone git://github.com/TertiumQuid/state_university_salaries.git
    cd state_university_salaries
    rake gem
    gem install state_university_salaries*.gem

#### Usage

After installation the `sus` command should be available in your ruby gems binary path.  

    sus request -o=~/Desktop/flsalaries.sqlite