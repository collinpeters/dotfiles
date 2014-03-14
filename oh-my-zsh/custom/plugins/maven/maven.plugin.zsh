# see all the maven oh-my-zsh plugin called 'mvn'

# aliases
alias mci="mvn clean install"
alias mcist="mvn clean install -DskipTests"
alias mciflex="mvn --projects :intouchV2-flex-parent,:intouchV3-flex-parent -amd clean install"

# Override the mvn command with the colorized one.
alias mvn="mvn-color"
