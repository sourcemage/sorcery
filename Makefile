AWK ?= awk

.MAKE.MAKEFILES ?= ${MAKEFILE_LIST}
.PHONY: help
help:
	@${AWK} 'sub(/^#HELP: ?/, "")' ${.MAKE.MAKEFILES}

BRANCH = devel
release = sorcery-$(BRANCH).tar.bz2

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
	git describe --tags | >etc/sorcery/version ${AWK} -f bump.awk

devinst: bump install

#HELP:	install   - Install sorcery
#HELP:	devinst   - Install with version from active branch
#HELP:	uninstall - Uninstall sorcery
#HELP:	convert   - Convert from Pre 0.8.x grimoire to new codex format
script-targets = install devinst uninstall convert
.PHONY: $(script-targets)
$(script-targets):; ./$@