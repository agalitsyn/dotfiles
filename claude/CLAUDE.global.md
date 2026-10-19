## Merge requests are written in English

Title, description, and any comment or review note you post on an MR — always
English, whatever language we are speaking in this session. Reviewers and the
MR history outlive the conversation that produced them.

- This covers GitLab MRs and GitHub PRs alike, and every note you leave on one.
- Keep talking to me in the session language. Only the MR text is fixed.
- Existing MRs written in another language stay as they are unless I ask.

## Offering me a choice

When you would otherwise print a list of decisions for me to make — options,
trade-offs, "what do you want here", "что нужно решить тебе" — call
AskUserQuestion instead of writing that list as prose. I answer by selecting,
not by retyping your numbering back at you.

This applies whenever there are named alternatives to pick between, in planning
and mid-implementation alike. It does not apply to open questions that have no
candidate answers yet, or to confirmation before a destructive action — ask
those in plain text.

- Recommended option goes first, labelled `(Recommended)`.
- One question per decision. Don't merge unrelated decisions to save a slot.
- Each option's `description` says what happens if I pick it, downside included.
- More than four decisions: send the first four, then another AskUserQuestion
  immediately after I answer. Never drop a decision to fit the four-question
  limit, and never silently decide one for me because it didn't fit.
- Free-text "Other" is added automatically — don't write your own
  "something else" option.
- Use `multiSelect` when the choices aren't mutually exclusive.
