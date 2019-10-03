.PHONY: help
help:
	@awk 'sub(/^#HELP: ?/, "")' $(MAKEFILE_LIST) $(.MAKE.MAKEFILES)

BRANCH = stable
release = sorcery-$(BRANCH).tar.bz2

ts-scm = .git/refs/heads/master

$(release): $(ts-scm)
	tmp="$$(mktemp -p .)" \
	&& git archive --prefix=sorcery/ | bzip2 > "$$tmp" \
	&& mv "$$tmp" $(release) \
	|| rm -f "$$tmp"

#HELP: Available targets:
#HELP:	release   - Make a release
.PHONY: release
release: $(release)

#HELP:	bump      - Bump version
.PHONY: bump bump-stable bump-devel
bump-stable:
	git describe --tags | >etc/sorcery/version \
	awk -F'[^0-9]' -vOFS=. '{++$$NF;for(i=1;i<NF;i++)$$i=$$(i+1)}NF--'

bump-devel:
	date -u +%Y%m%d > etc/sorcery/version

bump: bump-$(BRANCH)

#HELP:	install   - Install sorcery
#HELP:	uninstall - Uninstall sorcery
#HELP:	convert   - Convert from Pre 0.8.x grimoire to new codex format
script-targets = install uninstall convert
.PHONY: $(script-targets)
$(script-targets):; ./$@
