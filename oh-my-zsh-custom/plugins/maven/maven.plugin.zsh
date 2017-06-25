# see all the maven oh-my-zsh plugin called 'mvn'

# aliases
alias mci="mvn clean install"
alias mcv="mvn clean verify"
alias mcist="mvn clean install -DskipTests"
alias m="mvn clean install"

# sdkman defines mvn, set M2_HOME from that
export M2_HOME=$MAVEN_HOME
