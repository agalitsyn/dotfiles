# Examples

Worked pairs. The commentary matters more than the diffs: it is the reasoning that transfers to code
you haven't seen.

One rule governs every pair here, and it is the rule most easily lost. **Each clause of an "after"
comment must be traceable to something visible in the code above it.** A comment that asserts a
plausible-sounding contract — a retry window, a rounding rule, an error the function does not raise
— is worse than the bloat it replaced: bloat wastes two seconds, a fabricated contract gets acted
on. When the interesting facts are not visible, the honest rewrite is the short one.

## 1. Narration and banners

```go
// ---- User handling ----

// getUser fetches a user
func getUser(ctx context.Context, id string) (*User, error) {
	// Validate the input
	if id == "" {
		return nil, ErrInvalidID
	}

	// Query the database
	row := db.QueryRowContext(ctx, userQuery, id)

	// Scan the result into a user struct
	var u User
	if err := row.Scan(&u.ID, &u.Email, &u.Tier); err != nil {
		// Check if no rows were found
		if errors.Is(err, sql.ErrNoRows) {
			return nil, ErrNotFound
		}
		// Return the error
		return nil, err
	}

	return &u, nil
}
```

```go
func getUser(ctx context.Context, id string) (*User, error) {
	if id == "" {
		return nil, ErrInvalidID
	}

	row := db.QueryRowContext(ctx, userQuery, id)

	var u User
	if err := row.Scan(&u.ID, &u.Email, &u.Tier); err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, ErrNotFound
		}
		return nil, err
	}

	return &u, nil
}
```

Seven comments to zero, including the doc comment — `getUser` is unexported **and** the comment says
strictly less than the signature. Both conditions matter: unexported alone would not justify
deleting a doc comment that carried the error contract (compare example 4). Seven-to-zero is a normal
ratio for generated code, and the function reads better for it.

## 2. Doc comment on exported API — tighten, don't delete

```go
const idempotencyWindow = 24 * time.Hour

// ChargeCard charges a card.
//
// Parameters:
//   - ctx: the context
//   - cardID: the ID of the card to charge
//   - amount: the amount to charge
//
// Returns:
//   - *Charge: the resulting charge
//   - error: an error if the charge fails
func (s *Service) ChargeCard(ctx context.Context, cardID string, amount Money) (*Charge, error) {
	card, err := s.cards.Get(ctx, cardID)
	if err != nil {
		return nil, err
	}
	if amount.Currency != card.Currency {
		return nil, ErrCurrencyMismatch
	}
	key := cardID + ":" + amount.String()
	if prior, ok := s.idem.Lookup(key, idempotencyWindow); ok {
		return prior, nil
	}
	return s.gateway.Charge(ctx, card, amount)
}
```

```go
// ChargeCard charges cardID and returns the resulting charge. amount must be in the card's own
// currency; a mismatch returns ErrCurrencyMismatch rather than converting. Retries are safe —
// cardID and amount form the idempotency key, so a duplicate call within idempotencyWindow
// returns the original charge.
```

Longer than a one-liner, and that is the right outcome. The original spent twelve lines restating the
signature; the replacement spends four on things a caller cannot see and would otherwise learn from
an incident. Every clause is read off the body: the currency branch, the key construction, the named
window. The comment still opens with `ChargeCard`, so Go's convention survives the rewrite.

Now the counterfactual, because it is the whole lesson. Had the body **not** been shown — just the
signature — the only honest rewrite would be:

```go
// ChargeCard charges cardID and returns the resulting charge.
```

Writing the currency rule or the idempotency window from a signature alone is fabrication, however
plausible it sounds. Note also what the original got right and the temptation to lose: it said "the
resulting charge", not "the settled charge". Upgrading a vague-but-true word to a precise-and-unproven
one is the same error in miniature.

## 3. Chat residue

```python
# Added retry logic as requested
# NOTE: this fixes the timeout issue you mentioned
# Changed from requests to httpx for async support
async def fetch_rates(client: httpx.AsyncClient) -> dict[str, Decimal]:
```

```python
async def fetch_rates(client: httpx.AsyncClient) -> dict[str, Decimal]:
```

All three address whoever requested the change, not whoever will read the code in a year. "As
requested" by whom? "You mentioned" — who is *you*? This is conversation transcript that leaked into
the file, and git history records it properly. The `httpx` note is the closest call, but the
`httpx.AsyncClient` annotation and the `async def` carry it.

Note what is *not* being deleted here. If the retry policy is non-obvious — three attempts, only on
429 and 502, because the upstream rate-limits per minute — that is rationale and a keeper. What goes
is the framing that addresses the requester, not the knowledge.

## 4. Drift — rewrite, and flag it

```go
// pollStatus polls every 5 seconds, up to 3 times, then gives up.
func pollStatus(ctx context.Context, id string) (Status, error) {
	tick := time.NewTicker(30 * time.Second)
	defer tick.Stop()
	for {
		select {
		case <-ctx.Done():
			return StatusUnknown, ctx.Err()
		case <-tick.C:
			s, err := fetch(ctx, id)
			if err != nil {
				return StatusUnknown, err
			}
			if s.Terminal() {
				return s, nil
			}
		}
	}
}
```

```go
// pollStatus polls id every 30s until it reaches a terminal status, returning StatusUnknown and
// ctx.Err() if ctx is done first.
```

Then, in the report:

```
### Needs your eyes
- poll.go:1 — comment documented 5s intervals with a 3-attempt cap; the code polls every 30s with no
  attempt cap, exiting only on a terminal status or ctx being done. Rewrote the comment to match the
  code. If the cap was the intent, its absence is the bug, not the comment.
```

This is the most important behaviour in the skill. Quietly rewriting the comment converts a possible
bug into blessed behaviour — the comment was the last witness to the original intent.

Three details worth copying. The rewrite keeps the error contract (`StatusUnknown`, `ctx.Err()`),
which is exactly the class a doc comment exists to carry — that is why this unexported function keeps
a comment where example 1's did not. It says "ctx is done", not "ctx is cancelled", because
`ctx.Done()` also fires on deadline expiry. And the report says "no attempt cap" rather than "never
gives up", because the loop *does* exit — overstating a flag trains the reader to distrust the next
one.

## 5. Python docstring — drop the restatement, keep the constraints

```python
def split_settlement(total: Decimal, parties: list[Party]) -> dict[str, Decimal]:
    """Split a settlement.

    Args:
        total: The total amount.
        parties: The list of parties.

    Returns:
        A dictionary mapping party IDs to amounts.
    """
    if sum(p.weight for p in parties) != Decimal("1"):
        raise ValueError("weights must sum to 1")
    cents = int(total.scaleb(2))
    shares = [(cents * p.weight, p) for p in parties]
    out = {p.id: Decimal(int(v)).scaleb(-2) for v, p in shares}
    for _, p in sorted(shares, key=lambda s: s[0] % 1, reverse=True)[
        : cents - sum(int(v) for v, _ in shares)
    ]:
        out[p.id] += Decimal("0.01")
    return out
```

```python
    """Split total across parties in proportion to Party.weight, apportioned to cents by the
    largest-remainder method.

    Keys are party IDs; the values always sum to total. Leftover cents go to the parties with the
    largest fractional remainders. Raises ValueError unless the weights sum to exactly 1.
    """
```

Every `Args:` entry was the parameter name plus its annotation in prose. But notice what the original
had that was *not* restatement: "mapping party IDs to amounts" — the annotation says `dict[str, ...]`,
and `str` does not say *party ID*. That fact survives into the rewrite. Dropping a load-bearing
clause while adding ceremony is the trade inverted.

The named algorithm has to match the code, too. "Largest-remainder" distributes leftovers to the
largest *fractional remainders* — which is what the `sorted(..., key=lambda s: s[0] % 1)` line does.
Writing "the residual cent goes to the largest party" would name one algorithm and specify a
different one, and would also be wrong about cardinality: there can be up to `len(parties) - 1` cents
to place.

## 6. TypeScript JSDoc

```ts
/**
 * Formats a date.
 * @param date {Date} The date to format.
 * @param locale {string} The locale to use.
 * @returns {string} The formatted date string.
 */
export function formatDate(date: Date, locale: string): string {
  const month = new Intl.DateTimeFormat(locale, { month: "short" }).format(date);
  return `${String(date.getDate()).padStart(2, "0")} ${month} ${date.getFullYear()}`;
}
```

```ts
/**
 * Formats as `05 Mar 2026`; locale selects the month name only, not the field order.
 * @throws {RangeError} if locale is not a valid BCP 47 tag — propagated from Intl.DateTimeFormat.
 */
```

The `@param` and `@returns` tags duplicated the signature, which TypeScript already publishes to
editors on hover. `@throws` stays — and stays **as a tag**, not reworded into prose, because TypeDoc
and api-extractor read it as API surface.

The output description has to be precise about the interaction the code actually implements: the
field order is hard-coded in the template literal and only the month name is localised. Writing
"formats in the given locale" would imply locale-appropriate ordering, which this function does not
do — `ja-JP` would produce `05 3月 2026`, not `2026年3月5日`.

## Borderline calls

**`//nolint:gosec // path is from a fixture, not user input`** — keep whole. The directive is
functional and the trailing justification is the only thing distinguishing a reasoned suppression
from a lazy one. Note the absent space after `//`: `// nolint:gosec` is not honoured by
golangci-lint, so never "tidy" the spacing. For staticcheck's `//lint:ignore` the reason is a
*required field* — removing it breaks the directive outright.

**`// TODO(DL-1841): drop once the legacy tier is migrated`** — keep. Owner, ticket, exit condition.

**`// TODO: add error handling`** — do not delete it silently. It is almost certainly generated, but
you cannot prove that from the file, and the user's own bare TODO looks identical. List it in the
report.

**`// HACK: sleep 100ms — the upstream returns 200 before the record is queryable`** — keep, and
resist tidying the wording. It reads badly because it is honest about something ugly, and that
honesty is what stops someone deleting the sleep and shipping a flake.

**`// Deprecated: use ChargeCardV2 instead.`** — keep verbatim, and keep the bare `//` line above it.
`Deprecated:` is machine-read by staticcheck's `SA1019`, gopls and pkg.go.dev, but only when it
starts its own paragraph — so compressing a doc comment by joining paragraphs destroys the notice.
Don't reduce a doc comment to *only* the notice either: revive then reports the function as having no
comment at all.

**A commented-out block of former implementation** — out of scope. It is dead code wearing comment
syntax, not commentary. Note it in the report and leave it.

**A comment that is only redundant because the function is 200 lines of nesting** — keep it, and note
that the code wants splitting. Removing the reader's only handhold makes the file worse.

## Calibration for this codebase

Paste real comments here — a few you would defend keeping, a few you would delete on sight. What
counts as load-bearing is domain-specific: in a compliance codebase a one-line note about a
regulatory cutoff may be the most valuable line in the file, while the same terseness elsewhere reads
as noise. Local examples calibrate this pass better than any general rule above.
