# see all the maven oh-my-zsh plugin called 'mvn'

# aliases
alias mci="mvn clean install"
alias mcist="mvn clean install -DskipTests"
alias mciflex="mvn --projects :intouchV2-flex-parent,:intouchV3-flex-parent,:intouch-distribution -amd clean install"
alias mcil='cd ~/code/i/intouch; mvn clean install --projects :intouch-flex-resources,:intouch-distribution; cd -' 
alias m="mvn clean install"
alias ms="mvn clean install -DskipTests"
alias mj="mvn clean install -rf java"
alias msj="mvn clean install -rf java -DskipTests"

# Override the mvn command with the colorized one.
alias mvn="mvn-color"
