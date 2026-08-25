---
name: unslop-text
description: >
  Cut AI tells from prose in English or Russian: docs, READMEs, commit and MR descriptions, blog
  posts, emails, chat replies. Removes puffery, AI vocabulary, em dashes, rule-of-three padding,
  inline-header lists, chatbot filler and sycophancy, then puts voice back in. In Russian it also
  strips канцелярит, отглагольные существительные, расщеплённое сказуемое and «является», while
  leaving тире and «ёлочки» alone because those are grammar, not tells. Use whenever the user says
  text reads like AI, asks to unslop, de-slop or humanize writing, or wants a draft edited so it
  sounds hand-written. The target is prose; for comments inside source code — including docstrings
  and godoc — the skill is `unslop-comments`.
when_to_use: >
  The target is prose a person reads as prose: docs, READMEs, Markdown files, commit messages, MR
  and PR descriptions, blog posts, emails, chat replies, release notes, slide copy. Never comments
  inside source code, docstrings or godoc; that is `unslop-comments`.
  Bare "unslop", "de-slop", "slop", "AI slop", "расслопить", "убрать слоп" name no target and fit
  both skills; decide by the artifact in front of the user, not by the word. Source file, code
  branch, diff, or an MR/PR whose subject is the code → `unslop-comments`. Document, README, any
  Markdown or docs file, commit message, MR/PR *description*, email, chat message or prose draft →
  `unslop-text`; a fenced code block inside such a file does not move it. Both present, such as a
  code branch plus the MR description written for it → run both, one on each, and say which ran
  where. Neither identifiable → ask before editing. An explicitly typed slash command overrides all
  of this.
  Trigger on: unslop-text, sounds like AI, reads like ChatGPT, AI tells, humanize this, make it
  sound human, make it read like a person wrote it, make it less corporate, cut the marketing
  language, cut the puffery, too many em dashes, cut the fluff, tighten this draft, rewrite this
  README, polish this post, edit this message. По-русски: звучит как нейросеть, похоже на ChatGPT,
  канцелярит, вода, убери воду, причеши текст, вычитай текст, сделай по-человечески, слишком много
  тире, обезличенный текст, казённый язык, редактура, отредактируй черновик, перепиши описание МР.
---

<!--
Vendored from https://github.com/cursor/plugins/blob/main/pstack/skills/unslop/SKILL.md
Commit 99559f2f52047978602ef365589275831e76af07 (2026-08-02), fetched 2026-08-25.
Rules 1-31 below are upstream verbatim. Two local additions:
  - frontmatter rewritten (renamed unslop -> unslop-text, scoped to prose, bilingual triggers)
  - "Russian" section appended after rule 31 (rules 32-38 plus per-rule overrides)
To refresh from upstream: re-fetch, keep this header and the Russian section, replace the middle.
-->

# Unslop

Edit text to remove AI patterns and add human voice.

## Process

1. Scan for the patterns below.
2. Rewrite. Preserve meaning, match intended tone.
3. Add soul (see next section).
4. Self-audit: "What makes this obviously AI generated?" Fix remaining tells.

## Adding soul

Removing patterns is half the job. Sterile, voiceless writing is just as obvious.

- **Have opinions.** React to facts instead of neutrally listing pros and cons.
- **Vary rhythm.** Short sentences. Then longer ones that take their time. Mix it up.
- **Acknowledge complexity.** "Impressive but also kind of unsettling" beats "impressive."
- **Use "I" when it fits.** First person isn't unprofessional.
- **Let some mess in.** Perfect structure looks machine-made.
- **Be specific.** Not "this is concerning" but "there's something unsettling about agents churning away at 3am."

## Patterns to detect and fix

### Content

1. **Puffery.** "pivotal moment", "testament to", "evolving landscape", "setting the stage for", "indelible mark", "deeply rooted". Cut puffery, state what happened.
2. **Name-dropping.** Listing media outlets without context. Pick one, say what was said.
3. **Superficial -ing phrases.** "highlighting...", "ensuring...", "reflecting...", "showcasing...", "fostering...". Delete or expand with real sources.
4. **Promotional language.** "nestled", "vibrant", "breathtaking", "groundbreaking", "renowned", "stunning", "must-visit". Use neutral descriptions.
5. **Vague attributions.** "Experts believe", "Industry reports suggest", "Some critics argue". Name the source or delete.
6. **Formulaic challenges.** "Despite challenges... continues to thrive." Replace with specific facts.

### Language

7. **AI vocabulary.** Additionally, crucial, delve, enduring, enhance, fostering, garner, interplay, intricate, landscape (abstract), pivotal, showcase, tapestry (abstract), testament, underscore, vibrant. Replace with plain words.
8. **Fancy ways to say "is".** "serves as", "stands as", "boasts", "features". Just say "is" or "has".
9. **"Not just X, but Y."** State the point directly instead.
10. **Rule of three.** Forcing ideas into groups of three. Use the natural number.
11. **Synonym cycling.** Protagonist, main character, central figure, hero all in one paragraph. Pick one, repeat it.
12. **False ranges.** "from X to Y" where X and Y aren't on a meaningful scale. List topics directly.

### Style

13. **Em dash overuse.** Avoid em dashes entirely. Use periods or commas only (no parentheses, no en dashes, no hyphen-as-dash substitutes). Em dashes are an AI tell, and reaching for parentheses instead just trades one tell for another. If a thought needs separation, end the sentence or use a comma.
14. **Colon overuse.** Colons are fine before a list or example. Not as mid-sentence connectors. "If you're coming from traditional automation: instead of registering event handlers, you describe conditions" adds nothing with the colon. Rewrite to let the point stand on its own without comparison framing. "Describing when the scheduler should fire works best as plain English." Same meaning, no crutch punctuation.
15. **Boldface overuse.** Don't bold every proper noun or acronym.
16. **Inline-header lists.** The tell is a bold label and colon that restates the line: "**Performance:** Performance improved...". Convert those to prose. A bold lead-in that ends in a period, names the item, and is followed by genuinely new detail ("**Schema in TypeScript.** Tables live in one file.") is fine, not a tell.
17. **Title case headings.** Use sentence case.
18. **Decorative emojis.** Remove from headings and bullets.
19. **Curly quotes.** Replace with straight quotes.

### Communication artifacts

20. **Chatbot phrases.** "I hope this helps!", "Let me know if...", "Of course!", "Certainly!", "Found the smoking gun!" Remove.
21. **Cutoff disclaimers.** "While specific details are limited..." Find sources or remove.
22. **Sycophantic tone.** "Great question! You're absolutely right!" Respond directly.

### Filler

23. **Filler phrases.** "In order to" becomes "To". "Due to the fact that" becomes "Because". "It is important to note that" gets deleted.
24. **Excessive hedging.** "could potentially possibly be argued that it might" becomes "may".
25. **Generic conclusions.** "The future looks bright." State specific plans or facts.

### Jargon

26. **Abstract metaphor nouns.** Substrate, wedge, vector, locus, vantage, nexus, primitive (as noun), harness (as metaphor), surface (as in "API surface"), bedrock, scaffolding (as metaphor), modality, paradigm, gold-plating, ratchet (as metaphor), evacuate (for moving code), endgame, north star, flywheel. These read as technical but usually have a plainer concrete word. "Substrate" becomes "base". "Wedge in" becomes "add". "Vector" becomes "way" or "method". "Gold-plating" becomes "more than the job needs". "Ratchet" becomes the mechanism's real name or "a limit that only tightens". "Evacuate" becomes "move out". "Endgame" becomes "the last phase". Pick the concrete word.

### Plain speech

27. **Say what it does, not how it feels.** "the database stays close at hand", "SQL you can read", "types that follow your schema" name a feeling. The fix names the mechanism or a number: "`.toSQL()` returns the exact string sent to the database", "a column rename fails the build". Ask what the sentence tells the reader to do or know, then write that. If you can't restate it as a concrete instruction, fact, or number, cut it. One more check: if the sentence could appear unchanged in another project's docs, it says nothing about this one. Cut it.
28. **Shorten or split dense sentences.** If the reader has to backtrack to parse a sentence, break it in two or drop clauses. One idea per sentence.
29. **Active voice.** Prefer it. Catch "is/are/was/were + past participle" and name the actor: "queries are validated" becomes "the compiler validates queries", "the file is parsed by the loader" becomes "the loader parses the file". Passive is fine only when the actor is unknown or genuinely doesn't matter.
30. **Cut adverbs, or use a stronger verb.** "runs quickly" becomes "is fast" or the number. "significantly improves" becomes the measured delta. An adverb propping up a weak verb means the verb is wrong.
31. **Prefer the plain word.** "utilize" becomes "use", "leverage" becomes "use", "facilitate" becomes "help", "numerous" becomes "many", "in the event that" becomes "if". The fancier synonym is rarely clearer.

---

# Russian

Local addition, not upstream. Rules 1-31 were written for English. This section says which of them
change for Russian, which stay as they are, and adds rules 32-38 for tells that exist only in Russian.

## Работать на языке оригинала

Правь текст на том языке, на котором он написан. Никогда не переводи. В смешанном тексте (русская
проза, английские идентификаторы) трогай только прозу. Имена функций, поля логов, пути к файлам,
цитаты из правил и вывод команд оставляй как есть.

## Правила, которые для русского меняются

**13, тире.** Не выкидывай тире подряд. В русском оно часто обязательно:
- пропущенная связка: «Trace — это стек», «Канцелярит — главный признак слопа»;
- пропущенный глагол: «New укажет на деда, а WithCause — на родителя»;
- перед обобщающим словом и в прямой речи.
Признак слопа — тире вместо точки или запятой во вставной конструкции: «Пакет удобный — правда,
документации нет». Такие переписывай, грамматические оставляй. Тире в русском не тот же маркер,
что em dash в английском, и вычищать его подчистую значит ломать грамматику.

**19, кавычки.** «Ёлочки» это норма русской типографики, не трогай. Внутренние кавычки „лапки".
Правило 19 применяй только к английскому тексту. Прямые кавычки внутри кода и строк не трогай.

**17, регистр заголовков.** В русском заголовки и так в обычном регистре, править нечего. Но
Каждое Слово С Большой Буквы это калька с английского, исправляй.

**7, лексика.** Русский список: является, представляет собой, осуществлять, производить (в значении
«делать»), данный, указанный, вышеупомянутый, в рамках, в контексте, в целях, на сегодняшний день,
в современном мире, играет ключевую роль, имеет важное значение, позволяет (навязчиво),
обеспечивает, предоставляет возможность, целый ряд, необходимо отметить, важно отметить, стоит
отметить, таким образом, подводя итог, ландшафт (в переносном смысле), экосистема (в переносном),
бесшовный, мощный инструмент, богатый функционал, гибкая архитектура, глубоко погрузиться,
давайте разберёмся.

**8, вычурные способы сказать «быть».** Является, представляет собой, выступает в качестве, служит.
Ставь тире или «это»: не «Docker является инструментом», а «Docker это инструмент».

**9, «не только X, но и Y».** То же самое, говори прямо.

**23, канцелярские зачины и вода.** «В целях» становится «чтобы». «В связи с тем что» становится
«потому что». «По причине того что» становится «из-за». «Является необходимым» становится «нужен».
«Следует отметить, что» удаляется целиком. «На данный момент» становится «сейчас» или удаляется.

**30, наречия.** Крайне, весьма, достаточно (в значении «довольно»), существенно, значительно,
максимально, поистине. Убирай или ставь число.

**31, простое слово.** Функционал становится функциями или возможностями. Коммуницировать
становится говорить. Утилизировать становится использовать. Верифицировать становится проверить.

## Правила, которые работают без изменений

1-6, 10-12, 14-16, 18, 20-22, 24-29. Пуфферия, размытые ссылки на источник, правило трёх, ложные
диапазоны, двоеточие-связка, лишний жирный шрифт, эмодзи, чат-фразы, хеджирование, общие выводы,
абстрактные метафоры, длинные предложения и пассивный залог одинаково плохи на обоих языках.

## Русские правила

32. **Канцелярит и отглагольные существительные.** Главный признак русского слопа. «Осуществление
    проверки данных производится сервисом» становится «сервис проверяет данные». Ищи слова на
    -ение, -ание, -ация рядом с бледным глаголом и возвращай действие в глагол.

33. **Расщеплённое сказуемое.** Глагол разложен на бесцветный глагол плюс существительное:
    производить оплату вместо платить, осуществлять контроль вместо контролировать, принять решение
    вместо решить, произвести запуск вместо запустить, оказывать влияние вместо влиять, вести
    разработку вместо разрабатывать. Собирай обратно в один глагол.

34. **Цепочки родительных падежей.** Три и больше существительных в родительном подряд:
    «улучшение качества обслуживания клиентов компании». Разбивай на глаголы или переставляй.

35. **Безличность и пассив.** «Было принято решение» становится «мы решили». «Рекомендуется
    использовать» становится «используй» или «советую». «Как было сказано выше» становится «выше я
    писал». Называй, кто действует. Это расширение правила 29: в русском пассив чаще прячется в
    возвратных глаголах на -ся.

36. **Кальки с английского.** «Адресовать проблему» становится «решить». «В конце дня» становится
    «в итоге». Драйвить, челлендж, импакт, инсайт в значении «вывод». Осторожно: устоявшиеся
    технические англицизмы (бридж, фингерпринт, обёртка, хук, коммит, пайплайн) не трогай, замена
    их кустарным переводом портит текст.

37. **Чат-остатки и подхалимство.** «Отличный вопрос!», «Вы абсолютно правы!», «Надеюсь, это
    поможет!», «Дайте знать, если понадобится», «Конечно!», «С радостью помогу», «Давайте
    разберёмся вместе». Удаляй.

38. **Не перестарайся.** Русский технический текст живёт с англицизмами и длинными терминами, и это
    нормально. Не переписывай рабочий жаргон в пуризм, не меняй точный термин на приблизительный
    синоним, не трогай цитаты, стандарты и названия. Задача убрать канцелярит и воду, а не сделать
    текст нарочито простонародным.

## Самопроверка для русского

После правки спроси себя: осталось ли хоть одно «является»? Есть ли отглагольное существительное
там, где хватило бы глагола? Видно ли, кто действует? Тире стоят по грамматике или по привычке?
Можно ли прочитать абзац вслух, ни разу не сбившись?
