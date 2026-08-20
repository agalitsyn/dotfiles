# Language conventions

Go, then TypeScript and typed Python. Read the section for the language you are editing before
rewriting any doc comment: most languages have a first-line or prefix rule, and violating it costs
a lint failure — a worse outcome than the bloated comment you set out to fix.

- [Is this a directive or is it prose?](#is-this-a-directive-or-is-it-prose)
- [Go](#go)
- [TypeScript](#typescript)
- [Python](#python)
- [Other languages](#other-languages)
- [Comment-shaped things that are not comments](#comment-shaped-things-that-are-not-comments)

## Is this a directive or is it prose?

Directives wear comment syntax but have compile-time or tool-time meaning. Deleting one changes
behaviour; so does *re-spacing* one. Rather than matching against a list you might not have
memorised, use Go's own predicate, from `go/ast.isDirective`:

> A `//` comment is a **directive** when the text after `//` begins `line `, `extern `, or
> `export `, **or** matches `[a-z0-9]+:[a-z0-9]` — no space after `//`, none around the colon.

So `//go:build`, `//nolint:gosec`, `//easyjson:json` and `//sys` are directives; `// TODO: fix` is
not (space after `//`). Two consequences that matter more than any list:

- **Never insert a space.** `// go:build linux` is silently ignored — the file compiles on every
  platform, `go build` and `go vet` both exit 0, and only `gocheckcompilerdirectives` reports it.
  `gofmt` will not fix it. Normalising directive spacing is one of the few edits in this pass that
  can change behaviour without any error.
- **Never reorder a stacked directive.** `# type: ignore  # noqa: ABC123` requires `type: ignore`
  first; tidying the order silently disables one tool.

The predicate has known exceptions that use the **space** form, so they must be recognised by name:
`// +build`, `// +kubebuilder:*`, `// +k8s:*`, `// swagger:*`.

## Go

### Doc comments

**Must begin with the identifier's name.** `// Parse reads …`, not `// This function reads …`.
Breaking this trips revive's `exported` rule and staticcheck's `ST1020` (funcs), `ST1021` (types),
`ST1022` (vars and consts), and `ST1000` (package comments). Note what does *not* break: `go doc`
renders a non-conforming comment fine. The cost is lint, not documentation. (`golint` is deprecated;
`stylecheck` was folded into `staticcheck` in golangci-lint v2, where ST-checks must be enabled by
name — `checks: ["all"]` does not include them.)

**A doc comment tightened down to only `// Deprecated: …` counts as no comment at all** to revive,
which then reports "should have comment or be unexported". Compression has a floor: keep one
sentence of substance alongside the notice.

**`Deprecated:` must begin its own paragraph**, preceded by a bare `//` line. It is machine-read by
staticcheck's `SA1019`, gopls and pkg.go.dev. Joining paragraphs to compress a doc comment silently
destroys the deprecation notice — a specific and easy mistake for this pass to make.

The **exported/unexported asymmetry** drives most decisions. On an exported identifier, prefer
tightening a weak doc comment to deleting it — deletion is a lint regression. On an unexported one a
comment is needed only when the behaviour is non-obvious, so `// helper does the thing` above a
private func is straightforwardly deletable.

Keep, because none of it is in the signature: the error contract (`returns ErrNotFound when …`),
nil behaviour, concurrency safety, aliasing and ownership (`the returned slice aliases internal
state`, `closes the reader`), and context behaviour.

Delete: `// Error handling`, `// Struct definition`, `// Constructor`, per-field comments restating
field names, `// TODO: add tests`, and anything restating an `if err != nil` block.

Go 1.19+ doc syntax is meaningful formatting: tab-indented code blocks, `[Name]` doc links,
`# ` headings, and numbered lists (list items hold paragraphs only — no nested lists or code
blocks). Preserve it.

**After editing Go comments, run `gofmt -l` on the touched files.** gofmt reformats doc-comment
*structure* since 1.19 — it inserts blank `//` lines around list items — so a hand-shaped comment it
disagrees with will fail a `gofmt -l`/`gofumpt` gate even though you changed nothing executable.

### Go directives

| Family | Directives |
|---|---|
| Build & codegen | `//go:generate`, `//go:build`, `// +build` (legacy — gofmt keeps it paired with `//go:build`; never delete one alone), `//go:embed` (requires `import _ "embed"`, which looks like a dead import but is load-bearing) |
| Lint suppression | `//nolint`, `//nolint:all`, `//lint:ignore`, `//lint:file-ignore`, `//revive:disable`, `//revive:disable-next-line`, `//revive:enable` |
| Compiler & runtime | `//go:noinline`, `//go:noescape`, `//go:nosplit`, `//go:norace`, `//go:linkname`, `//go:uintptrescapes`, `//go:uintptrkeepalive`, `//go:nocheckptr`, `//go:systemstack`, `//go:registerparams`, `//go:wasmimport`, `//go:wasmexport`, `//go:debug`, `//go:fix`, `//line` |
| cgo | the **preamble** (see below), `//export Name`, `//go:cgo_import_dynamic`, `//go:cgo_import_static`, `//go:cgo_export_static`, `//go:cgo_export_dynamic`, `//go:cgo_ldflag`, `//go:cgo_unsafe_args`, `//extern` |
| Syscall generation | `//sys`, `//sysnb` |
| Kubernetes / CRD (space form) | `// +kubebuilder:*`, `// +k8s:deepcopy-gen=`, `// +genclient`, `// +optional`, `// +groupName=`, `// +listType=` |
| API spec (space form) | `// swagger:meta|route|model|parameters|response|operation|strfmt|allOf|discriminated|ignore` |
| Third-party codegen | `//counterfeiter:generate`, `//easyjson:json`, `//easyjson:skip`, `//msgp:ignore`, `//msgp:tuple`, `//msgp:shim` |
| Licence | `// SPDX-License-Identifier:`, copyright headers |

Four of these carry hazards worth stating outright:

- **The cgo preamble.** The `/* … */` block immediately above `import "C"` is C source code, plus
  `#cgo CFLAGS:` / `CPPFLAGS:` / `CXXFLAGS:` / `FFLAGS:` / `LDFLAGS:` / `pkg-config:` / `noescape` /
  `nocallback` lines. It looks exactly like a big block comment ripe for trimming. Editing it is a
  build failure or, worse, silently wrong link flags. Never touch it.
- **`// swagger:*` claims the rest of the block.** Once go-swagger's parser sees a known tag, the
  remainder of the comment block is spec input. "Tightening the doc comment" on an annotated handler
  changes the emitted OpenAPI spec. Leave annotated blocks alone entirely.
- **`// +kubebuilder:*` and `// +k8s:*` fail silently.** Deleting one changes the generated CRD
  schema with no build error at all.
- **`//lint:ignore` requires its reason.** The syntax is `//lint:ignore Check1[,Check2] reason` and
  the reason is a required field — stripping it breaks the directive rather than merely
  under-documenting it. For `//nolint`, the trailing reason is what `nolintlint
  --require-explanation` enforces, and `//nolint` must have **no leading space**: `// nolint:x` is
  not honoured and the lint fires.

Not directives, despite appearances: `stringer`, `mockgen` and `protoc-gen` have none of their own
(they run via `//go:generate`); `gqlgen` uses GraphQL schema directives in `.graphql` files;
`//go:notinheap` was removed in Go 1.20. Wire has no directive either, but its `//go:build
wireinject` tag is load-bearing — delete it and the injector template compiles into the real build.

### Generated files

Any file containing a line matching `^// Code generated .* DO NOT EDIT\.$`. Two details a naive
check gets wrong: **"by" is not part of the pattern**, and the line **need not be first** — it
legitimately follows a build constraint or licence header, and is only guaranteed to precede the
first non-comment, non-blank text. Also treat as generated: `vendor/`, `*.pb.go`, `*_gen.go`,
`*.gen.go`, `zz_generated*.go`, `*_string.go`, `wire_gen.go`, `mock_*.go`, `*_easyjson.go`.

### Tests

Test files are in scope. A comment above a table-driven case restating its `name` field is slop; one
explaining *why* the expectation is what it is — a rounding rule, a regulatory edge — is not.
Fixture and golden *data* is not in scope; see the last section.

## TypeScript

A JSDoc block whose `@param` and `@returns` lines restate the annotated signature is slop: the
compiler already has that information and editors surface it on hover. Keep the prose summary when
it says something the types cannot; delete the ceremonial tag list.

Keep the TSDoc tags that express what types cannot: `@deprecated`, `@throws`, `@example`, `@see`,
`@internal`, `@remarks`, `@defaultValue`. Keep them **as tags**, not reworded into prose — if the
package publishes docs via TypeDoc or api-extractor, they are API surface.

Suppression directives: `// @ts-ignore`, `// @ts-expect-error`, `// @ts-nocheck`, `// @ts-check`,
`/* eslint-disable */`, `// eslint-disable-next-line`, `// prettier-ignore`, and coverage hints of
the form `/* istanbul ignore next|if|else|file */`. The scope token on `istanbul ignore` is
structurally required — bare `/* istanbul ignore */` does nothing, so never trim it to that.

A comment explaining why a `useEffect` dependency array is deliberately incomplete, or why an
`as unknown as` cast is safe, is rationale. Keep it — it is usually the only thing stopping someone
from "fixing" the code back into a bug.

## Python

With annotations present, a Google- or NumPy-style `Args:` entry that names a parameter and repeats
its type is restatement — drop it. Keep entries stating units, ranges, ownership, or which exception
is raised. If every entry restates, drop the block and keep a one-line summary.

**A docstring that is the entire body cannot be deleted** — removing it is an `IndentationError`.
This covers one-line private helpers and `Protocol`/ABC stubs. Tighten it or leave it; if it must
go, the body needs `...` in its place.

**Docstrings are runtime objects.** They drive Click and Typer `--help` output, FastAPI route
descriptions, and `help()`. Rewriting one of those *is* a user-visible behaviour change, so treat
CLI command and route-handler docstrings as out of scope unless the user asked for them.

A docstring containing `>>>` may be collected as a doctest (`python -m doctest`, pytest's
`--doctest-modules`, Sphinx's doctest builder). Treat the body as code: never reflow it, and note
that `<BLANKLINE>` is load-bearing — a literal blank line ends the expected output.

Suppression comments, with their exact-form hazards:

| Directive | Hazard |
|---|---|
| `# noqa`, `# noqa: E501` | flake8 matches codes by prefix, so `# noqa: D` silences all of pydocstyle; **Ruff rejects `# noqa: D`** and reports the violations |
| `# flake8: noqa` | flake8's file-level regex ignores appended codes, so `# flake8: noqa: E501` silences the **entire file**; Ruff parses the codes. Same comment, different blast radius |
| `# type: ignore`, `# type: ignore[arg-type]` | must come first in a stacked comment |
| `# mypy: ...` | own line, column 0, one space after the colon; indented or trailing forms are silently ignored (anywhere in the file is fine) |
| `# ruff: noqa`, `# ruff: isort:` | file-level |
| `# isort: skip` / `skip_file` | accept both spacings, but `# isort: off` / `on` / `split` are compared literally — **`# isort:off` is silently ignored** |
| `# pragma: no cover` | on a clause header it excludes the whole body, so deleting one line can change coverage by dozens; the default regex's case alternations are literal, so `# Pragma: No Cover` does not match |
| `# fmt: off` / `# fmt: on` / `# fmt: skip` | `# yapf: disable` / `# yapf: enable` are honoured as aliases by Black and Ruff; no-space forms work |
| `# pylint: disable`, `# pyright: ignore`, `# nosec` (also `# nosec assert_used`) | — |
| `# -*- coding: … -*-` | PEP 263, line 1 or 2. Removing it from a non-UTF-8 file is a `SyntaxError` |

Public API keeps a docstring even when short; private helpers (`_name`) do not need one, and a
module docstring that merely names the module is slop.

## Other languages

The general rule in `SKILL.md` still applies — could a fluent reader derive this from the code? —
with two adjustments. Check the language's doc-comment convention before rewriting one. And in
languages with weak structural tools, shell above all, a section banner in a long script is more
defensible than in application code; a banner over three lines is still slop.

Shell: the `#!` shebang and `# shellcheck disable=SCxxxx` are functional. Keep comments explaining
non-obvious quoting, `set -euo pipefail` consequences, or why a subshell or `eval` is needed — that
is exactly the knowledge shell syntax hides.

SQL: comments on index choice, planner hints, join shape, lock behaviour and migration ordering are
keepers. **Never edit comments inside an already-applied migration** — some tools verify its
checksum, and an applied migration is history.

## Comment-shaped things that are not comments

Confirm you are looking at a comment before deleting it:

- the **cgo preamble** above `import "C"` — C code, not commentary
- `#` inside a YAML or TOML *value*, or a `#` fragment inside a URL string
- `--` inside a SQL string literal; `//` inside any URL
- `/* */` inside a CSS or TS string, or inside a regex literal
- comments in test fixtures, golden files or snapshots whose exact bytes are asserted on
- heredocs and template literals, whose contents are data
