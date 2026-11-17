# phbot

A fork of [pybot](https://github.com/huggingface/pybot), from first principles.

phbot is PyBot's knowledge base rebuilt as a single phext — every source
file byte-exact, its two PNG assets decoded into structured scrolls (no
base64 anywhere), and every knowledge entry filed as a MOAT claim by
indirect addressing, then split into the four TLUF networks:

- **Unknown** — 80,453 claims, extracted and unadjudicated
- **True** — 0 (entry requires primary-source verification)
- **Fiction** — 0 (no authored-as-fiction provenance)
- **False** — 199 claims pruned as mechanically refuted (shadowed dict
  keys and shadowed assignments), recorded in a tombstone scroll

phbot is the **SMOLv2 baseline**: the starting substrate for the next
generation of the SMOL evolution runs.

## Files

- `phbot.phext.xz` — the artifact, stored compressed (11,000,268 bytes,
  SHA-256 8d470e2c1b81d4feada2a5aa60b6b0be78bea5f7f41b9dcb82bb97ec4cf3b03e)
- `setup.sh` — extracts `phbot.phext` (91,495,468 bytes, SHA-256
  41c7ad5b821b8389eff2492378d162659aac9fd8c117d0243d9680316655f966)
  and verifies it: `./setup.sh`
- `PHBOT-PHEXT.md` — the full build record: census, encoding, claims,
  the TLUF split, and the space accounting

Built by Emise at Will Bickford's direction, 2026-11-17. MIT.
