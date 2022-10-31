#!/usr/bin/env bash

# Java 17 required for jdtls
export JAVA_HOME="/home/collin/.sdkman/candidates/java/17.0.4-tem/"
export PATH="$JAVA_HOME/bin:$PATH"

export JDTLS_HOME="$HOME/.local/share/nvim/mason/packages/jdtls"
export CONFIG_PATH="$JDTLS_HOME/config_linux"

# fake yarn & webpack out for insight-brain
function yarn() {
  echo 'skipping yarn, beware of gremlins'
}
function webpack() {
  echo 'skipping webpack, beware of gremlins'
}
export -f yarn
export -f webpack

# Use Arch provided jdtls
java \
  -Declipse.application=org.eclipse.jdt.ls.core.id1 \
  -Dosgi.bundles.defaultStartLevel=4 \
  -Declipse.product=org.eclipse.jdt.ls.core.product \
  -Dlog.protocol=true \
  -Dlog.level=ALL \
  -Xms1G \
  -Xmx2G \
  --add-modules=ALL-SYSTEM \
  --add-opens java.base/java.util=ALL-UNNAMED \
  --add-opens java.base/java.lang=ALL-UNNAMED \
  -jar ${JDTLS_HOME}/plugins/org.eclipse.equinox.launcher_*.jar \
  -configuration ${CONFIG_PATH} \
  -data "$1" 
