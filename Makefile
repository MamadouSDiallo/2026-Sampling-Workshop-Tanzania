# ===== Quarto + Tailwind course =====

# ---------- Paths / tools ----------
# Cleaned up variable definitions to remove trailing whitespace.
QSRC       ?= course
QOUT       ?= course_site
QHOST      ?= 127.0.0.1
QPORT      ?= 8001
QUARTO     ?= uv run quarto

# Tailwind CSS paths are now explicit based on your project structure.
QCSS_IN    ?= course/assets/styles/input.css
QCSS_OUT   ?= course/assets/styles/output.css

PY          ?= uv run
TW          ?= uv run npx tailwindcss
CONCUR      ?= uv run npx concurrently



# ---------- Helpers ----------
.PHONY: help
help:
	@echo "Quarto course targets:"
	@echo "  make css        - build Tailwind CSS once"
	@echo "  make css-watch  - watch Tailwind CSS (dev)"
	@echo "  make build      - render Quarto -> $(QOUT)"
	@echo "  make serve      - live preview (with Tailwind watch if present)"
	@echo "  make clean      - remove $(QOUT)"
	@echo "  make check      - run 'quarto check'"

# ---------- CSS (Quarto) ----------
# This section now directly checks if the specific input file exists.
# The complex auto-detection logic has been removed for clarity and correctness.
.PHONY: css
css:
ifeq (,$(wildcard $(QCSS_IN)))
	@echo "⚠️  Skipping css (input file not found at '$(QCSS_IN)'))"
else
	@echo "→ Building Tailwind: $(QCSS_IN) -> $(QCSS_OUT)"
	@$(TW) -i "$(QCSS_IN)" -o "$(QCSS_OUT)" --minify
endif

.PHONY: css-watch
css-watch:
ifeq (,$(wildcard $(QCSS_IN)))
	@echo "⚠️  Skipping css-watch (input file not found at '$(QCSS_IN)')"
else
	@echo "→ Watching Tailwind: $(QCSS_IN) -> $(QCSS_OUT)"
	@$(TW) -i "$(QCSS_IN)" -o "$(QCSS_OUT)" --watch
endif

# ---------- Build / Clean ----------
.PHONY: build
build:
	$(QUARTO) render "$(QSRC)" --cache-refresh

.PHONY: clean
clean:
	rm -rf "$(QOUT)"

# ---------- Live server ----------
.PHONY: dev serve
dev:
	$(CONCUR) -k -n css,site \
	  '$(TW) -i "$(QCSS_IN)" -o "$(QCSS_OUT)" --watch' \
	  '$(QUARTO) preview $(QSRC) --host $(QHOST) --port $(QPORT) --no-browser --cache-refresh'

serve: dev

# ---------- Misc helpers ----------
.PHONY: check
check:
	$(QUARTO) check
