#!/usr/bin/env bash

# Ensure Java 11 for jdtls
export JAVA_HOME="/home/collin/.sdkman/candidates/java/11.0.11-open/"
export PATH="$JAVA_HOME/bin:$PATH"

export CONFIG_PATH="/home/collin/dev/lsp-config_linux"

# Use Arch provided jdtls
#/usr/bin/jdtls "$@"

java \
	-Declipse.application=org.eclipse.jdt.ls.core.id1 \
	-Dosgi.bundles.defaultStartLevel=4 \
	-Declipse.product=org.eclipse.jdt.ls.core.product \
	-Dlog.level=ALL \
	-noverify \
	-Xms1G \
	-Xmx2G \
  -jar /usr/share/java/jdtls/plugins/org.eclipse.equinox.launcher_*.jar \
	-configuration ${CONFIG_PATH} \
	-data "$1" \
	--add-modules=ALL-SYSTEM \
	--add-opens java.base/java.util=ALL-UNNAMED \
	--add-opens java.base/java.lang=ALL-UNNAMED
