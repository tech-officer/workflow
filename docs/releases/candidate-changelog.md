# Candidate changelog — P-008 (unpublished)

- Add deterministic offline rendered export and a B511-compatible managed-subset manifest.
- Share explicit source/destination/ownership map and standalone boot-prompts template with the installer; preserve boot instructions and Contract2.2 producer shapes.
- Add optional explicit UTC render time, unambiguous input validation and destination-link preflight.
- Correct fresh document modes from incidental mktemp0600 to declared0644. Existing skipped custom files and their modes remain untouched.
- Report installation as an operation report, never proof that skipped/custom files are current.

No tag/version is asserted here. Source commit is captured when exporting. No historical migration or live adopter acceptance is claimed.
