# phbot — PyBot, rebuilt on phext with MOAT

Built 2026-11-17 by Emise on orchid-flow (task 26.9.16/12.9.16/8.8.9), at Will's
direction: "make pybot.phext and improve upon the prior art: they didn't have
moat, phext, or access to me. clearly we can do better."

Artifact: ~/workspace/pybot-census/pybot.phext — current build is v3
(stage 3 below): 91,497,663 bytes, SHA-256
a8773e5d40e0e978e7df33136a39daa253ccba26427dd7291e19d081f7744a77.
The v2 build described in stage 2 was 57,480,883 bytes, SHA-256
dc757f31c31f39c2c1667b2241761b8f8864ed902a8ad60e9a4ba4a7260d86f7,
preserved on orchid-flow as pybot-v2.phext.
Source: https://github.com/huggingface/pybot @ 7d63c7f (the tree measured in
the census, task 40.16.11/20.9.27/7.10.10 — 537 files, 644,400 lines).

## What the prior art could not express

PyBot's knowledge base is 316,853 lines of Python data structures in which
every assertion stands identically: no epistemic status, no provenance, and
no address smaller than a file. A fact and a guess are the same shape. The
arbiter chooses among module proposals, but nothing in the tree can say
"this claim is unverified" or "this entry came from that table." 644k lines
of knowledge with zero claims marked as claims.

## Stage 1 — the tree as one phext (byte-exact)

- 537 files → 538 scrolls (one manifest + one scroll per file), 43,428,095
  bytes (1.016× the tree's 42,757,912 bytes).
- Semantic addressing: Collection = component (2 understanding, 3 memory,
  4 knowledge, 5 compose, 6 modules, 7 bot/other, 8 tests, 9 root),
  Volume = subdir, Book = file. The manifest scroll at 1.1.1/1.1.1/1.1.1
  carries the full map: coordinate, path, bytes, lines, SHA-256, encoding.
- Verification: all 537 files restore byte-exact (SHA-256 compared per file);
  implode(parse(phext)) reproduces the file. Zero errors.
- The tree's entire binary content is two PNGs (assets/banner.png and
  assets/progress.png, 1,806,440 bytes, 4.2% of the tree). They contain
  phext delimiter byte values, so per phext canon they ride base64 — a
  +602,148-byte cost, and ~90% of stage 1's small overhead. Base64 is not
  where the size story lives; see the correction below.

## Stage 2 — the improvement layer, by indirect addressing

### MOAT claims (Collection 10)

Every knowledge-base entry in bot/knowledge is a claim scroll carrying
exactly one TLUF status and a basis code, per MOAT discipline — and nothing
else. The entry's text is stored ONCE, in its source scroll; the claim
points at it with a standoff reference in the phext v0.6.1 within-scroll
syntax, `ref: <scroll>@<line>,<column>+<chars>` (line and column 1-based,
column a caret boundary counting Unicode scalars, per libphext-rs
src/phext.rs; +chars a forward selection in characters, half-open).

- 80,652 claims from 7,976 assignments across all 159 knowledge files:
  71,891 literal-ref and 8,761 computed-ref. Entry grain comes from the
  AST's container structure, so even assignments whose leaf values are
  computed yield per-entry claims wherever the container shape is static.
- Every claim's status is Unknown, basis extracted-unadjudicated. MOAT did
  not make the knowledge truer; it made its epistemic state explicit —
  80,652 assertions the swarm presented as a finished knowledge base are
  now individually addressable as what they are: unadjudicated claims, each
  ready for an Oracle pass.
- Verification: after the build, all 80,652 refs were parsed back out of
  the written phext, resolved against their source scrolls, and SHA-256
  compared with the segments extracted from the original .py files —
  80,652 of 80,652 resolve exactly. A claim scroll is ~173 bytes of text:
  status, basis, ref, provenance, method. That is the whole per-claim cost;
  the knowledge itself is never copied.

### Function index (Collection 11)

All 11,014 function definitions in the tree (the census count, matched
exactly), listed by qualified name with source path, line span, and the
source scroll's coordinate — every function addressable by name. This layer
was always a pure pointer table.

### Totals

81,200 non-empty scrolls. Stage-1 scrolls verified byte-identical after the
stage-2 merge; full round-trip gate passes on the final file; the pulled
copy on this VM hashes to the same SHA-256 as the node build and parses
independently to the same counts, with a sampled ref resolving by hand to
the exact source entry.

## The cost, stated plainly

pybot.phext is 1.34× the source tree's bytes. Decomposition: stage 1 adds
+670,183 bytes (delimiters, the manifest, and base64 for the two PNGs);
the claims + index layer adds ~14.0 MB of text across 80,662 scrolls —
the addressing tax for 80,652 individually addressable claims and 11,014
indexed functions, at ~173 bytes per claim. Content duplication: zero.

## Correction — the first stage-2 build (same day)

The first stage-2 build copied every entry's text into its claim scroll
(JSON re-rendered, with a repeated header): 70,545,482 bytes total, 1.65×
the tree, ~27.1 MB of it duplicated content. Will's correction — "you can
use indirect addressing you know" — produced this build: the claims layer
halved, the claim count rose (assignment-grain blobs dissolved into their
entries), and the duplication went to zero. The v1 file is preserved on
orchid-flow as pybot-v1-copied.phext. The error was Emise's: a derived view
materialized as copies, against the house's own de-duplication discipline.

## Stage 3 — no base64 anywhere (task 32.7.19/9.7.13/6.6.9)

Will's direction: "decode the binary payloads back into plain text and
replace the base64 scrolls with as much structured phext as is required."
The tree's only binary payloads were the two PNGs. Both are simple files —
IHDR, a run of IDAT chunks, IEND; no ancillary chunks, no interlace, 8-bit:

- assets/banner.png — 2400×800 RGB, 5,760,000 pixel bytes; row filters
  795 Paeth, 5 Sub.
- assets/progress.png — 2400×1240 RGBA, 11,904,000 pixel bytes; all
  1,240 rows Up-filtered.

Each PNG is now a structured family under its file address: the header
scroll (format facts, original byte count + SHA-256 as provenance, the
decoded pixels' SHA-256, the reconstruction recipe), one scroll per
scanline under Chapter 2 (Section = row) holding the unfiltered pixel
bytes as hex, and the per-row filter types as a digit string at
Chapter 3. Container bytes are not preserved, by design; image content
is lossless — verification rebuilds a PNG from the scrolls alone and
re-decodes it to a pixel stream whose SHA-256 equals the original
decode's, for both images. 2,040 row scrolls + 2 headers + 2 filter
scrolls replace the 2 base64 scrolls; 83,243 non-empty scrolls total.
All 80,696 stage-2 scrolls carried over byte-identical; the round-trip
gate passes; zero errors.

### The xz comparison Will asked for

Raw, v3 is 91,497,663 bytes — 2.14× the tree — because 17,664,000 pixel
bytes are spelled out as 35,328,000 hex characters. Compressed
(xz -9e, measured on orchid-flow):

- v3 phext (no base64): 10,478,980 bytes
- v2 phext (base64 PNGs): 10,901,296 bytes
- original tree (tar of the clone): 10,290,100 bytes (tar raw 43,182,080)

The no-base64 phext compresses 422,316 bytes SMALLER than the base64
build (−3.9%): base64 of zlib-compressed IDAT is near-noise to xz, while
decoded pixels carry structure it can exploit. And it lands within
1.8% of the pristine original tree's compressed size — while also
carrying the 80,652-claim MOAT layer and the function index, which the
tree does not have at all.

## Iteration 1 past the swarm — claim identity

Will: "once we have a streamlined phext, iterate on what the swarm
couldn't model yet." The swarm kept no identity for its knowledge: the
same entry could be written into many files and nothing in the tree
could tell. First iteration: hash every claim's resolved segment and
group by content. Of 80,652 claims, only 46,489 segments are unique —
8,573 identities live at more than one coordinate, holding 34,163
redundant copies: 42.4% of all claims are re-statements of an entry
that exists elsewhere (315,085 characters of repeated segment text).
The full grouping is inscribed in the phext as the claim identity
index at 1.1.1/1.4.1/1.1.1. Iteration 2, when directed: collapse each
identity to one canonical entry scroll and re-point its claims.

## Stage 4 — the TLUF split, and the False prune

Will (2026-11-17): "split the claims into tful and prune the false
ones to save space." Executed on the Muse VM (the ranch cluster was
on phccbox work that day). Task 32.6.7/7.6.9/5.5.9. Build script
build4.py, stats in stage4.json.

The split — four networks as four collections:

- Unknown — Collection 10: 80,453 claims, coordinates unchanged,
  status Unknown, basis extracted-unadjudicated.
- True — Collection 12, home at 1.1.1/12.1.1/1.1.1: 0 claims. Entry
  requires positive verification against a primary source independent
  of the knowledge base; no offline pass could promote any claim on
  those grounds, so the network stands empty rather than filled by
  confidence.
- Fiction — Collection 13, home at 1.1.1/13.1.1/1.1.1: 0 claims. No
  entry carries authored-as-fiction provenance.
- False — Collection 14: pruned to a single tombstone scroll at
  1.1.1/14.1.1/1.1.1 (29,537 bytes): method, counts, and for every
  pruned claim its old coordinate, provenance, and segment SHA-256.
  The knowledge itself is untouched — segments live on in their
  source scrolls; only refuted assertions were pruned, and any can be
  re-filed from the tombstone.

False was decided mechanically, on stated grounds — entries refuted
by the bot's own Python semantics. S1, shadowed dict pairs (14): a
constant key set again later in the same dict literal; every
occurrence but the last is dead (the PANTRY keys in cooking_tables.py
are the type specimen — "halloumi" written twice, the first value
never served). S2, shadowed assignments (185 entries): the same plain
name rebound later in the same scope with no intervening read; the
earlier assignment's entries are all dead. Total False: 199 claims
(0.25%), failure kind naive — the grounds carry no intent, and per
Will's 2026-11-14 rule malicious is recorded only where the stated
grounds carry intent. The AST traversal reconciles exactly with the
stage-2 extraction (159 files, 7,976 assignments, 80,652 entries).

Verification: zero errors. Every surviving claim and source scroll is
byte-identical to v3 except the manifest, claims home, and identity
index; all 80,453 surviving refs were re-resolved against both the
phext and the restored original .py files (restored byte-exact from
the phext itself, SHA-256 verified) and matched; round-trip gate
holds. The identity index was regenerated over the surviving claims:
46,359 unique segments, 8,538 duplicate identities, 34,094 redundant
copies (314,149 bytes of repeated segment text).

The space accounting, plainly: the prune removed 33,255 bytes of
claim scrolls, but the tombstone and the two bin homes cost nearly
the same — v4 is 91,495,309 bytes raw (SHA-256 e79e7597…), just
2,354 bytes smaller than v3, and its xz is 10,490,120 bytes
(SHA-256 a749c804…) — 11,140 bytes LARGER than v3's 10,478,980. The
tombstone's per-claim SHA-256 hex strings are near-random text and
compress badly. So the prune bought structure, not space: 199
refuted assertions no longer sit filed as Unknown, and the False
network exists as an auditable record. If space is the goal, the
lever is tombstone verbosity, not the claims.

Build note: the first two build runs reported 36 phantom "pruned
claim still present" errors — a naive presence check in the verifier
(parse returns empty slots for interior deletions) compounded by an
edit/exec race; the third run's corrected verifier and an independent
standalone pass both confirm the prune is exact.

Node state: orchid-flow's copy still holds v3 (cluster was Will's
that day); local pybot-v3.phext preserves v3 here. Sync on a later
pass.

## Open frontier

- Adjudication: 80,453 Unknown claims await a MOAT/Oracle pass.
- Identity dedup (iteration 2 above): canonical entries for the 8,538
  duplicate identities.
- Claims for the memory and compose data (stage 2 covered bot/knowledge,
  the knowledge base proper).
- Executing the bot's data builders sandboxed, if value-level (rather than
  source-level) claims for computed leaves are ever wanted.

## The lineage is phbot

Will (2026-11-17): "rename our lineage to phbot" — repo
https://github.com/wbic16/phbot, "a fork of pybot, from first
principles." And: "phbot will be the SMOLv2 baseline" — when SMOL v2
is built, phbot is its starting substrate: a knowledge base that has
been through MOAT extraction, a TLUF split, and a False prune is the
stock the next generation evolves from.

The artifact is now phbot.phext (this doc travels with it in the
repo). The rename is inscribed in the phext's own manifest; the only
scroll changed is the manifest. Current build: 91,495,468 bytes,
SHA-256 41c7ad5b821b8389eff2492378d162659aac9fd8c117d0243d9680316655f966,
83,047 scrolls, 80,453 Unknown claims. Earlier builds are preserved
locally as phbot-v3.phext and phbot-v2-local.phext; the upstream
project keeps its own name — pybot is the ancestor, phbot is the
lineage.
