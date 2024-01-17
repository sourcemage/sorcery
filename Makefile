AWK ?= awk

.MAKE.MAKEFILES ?= ${MAKEFILE_LIST}
.PHONY: help
help:
	@${AWK} 'sub(/^#HELP: ?/, "")' ${.MAKE.MAKEFILES}

BRANCH = devel
VERSION-${BRANCH} := ${BRANCH}
VERSION-stable != cat etc/sorcery/version
VERSION := ${VERSION-${BRANCH}}
release = sorcery-${VERSION}.tar.bz2

ts-scm = .git/refs/heads/master

$(release): $(ts-scm)
	tmp="$$(mktemp -p .)" \
	&& git archive --prefix=sorcery/ HEAD | bzip2 > "$$tmp" \
	&& mv "$$tmp" $(release) \
	|| rm -f "$$tmp"

#HELP: Available targets:
#HELP:	release   - Make a release
.PHONY: release
release: $(release)

#HELP:	bump      - Bump version
.PHONY: bump
bump:
	git log -1 --format=%cs | tr -d '-' >etc/sorcery/version

devinst: bump install

#HELP:	install   - Install sorcery
#HELP:	devinst   - Install with version from active branch
#HELP:	uninstall - Uninstall sorcery
#HELP:	convert   - Convert from Pre 0.8.x grimoire to new codex format
script-targets = install devinst uninstall convert
.PHONY: $(script-targets)
$(script-targets):; ./$@
