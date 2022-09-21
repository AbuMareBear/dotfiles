alias r='bundle exec rails'
alias rspec='bundle exec rspec'

alias rt='rails test'
alias rtp='rails test test/policies'
alias rti='rails test:integration'
alias rtc='rails test:controllers'
alias rts='rails test:system'
alias rtf='annotate && brakeman -q && standardrb && rails test:system test'
alias rtm='annotate && brakeman -q && standardrb && rails test'

alias rspec='bin/rspec --exclude-pattern "spec/features/*_spec.rb"'
