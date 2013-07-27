Lobbying Disclosure Act
=======================

CLI Tool for scraping legislative data around the US Lobbying Disclosure Act and other public records sources.

#### Setup

LDA is distributed as a ruby gem and can be installed on your system from github:

    git clone git://github.com/TertiumQuid/state_university_salaries.git
    cd state_university_salaries
    rake gem
    gem install state_university_salaries*.gem

#### Usage

After installation the `lda` command should be available in your ruby gems binary path.  

    lda request -s=tx -o=~/Desktop/