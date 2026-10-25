# CIE Paper Marking Skill

A reusable skill for marking completed CIE/CAIE exam papers against the matching Cambridge mark scheme.

- Find the correct mark scheme by syllabus code, year, session, paper and variant, preferring cie.craft.cn.
- Review handwritten work, calculations, diagrams and extended responses.
- Apply subject-specific marking points or level descriptors, explain mistakes and show how to improve.
- Deliver two PDFs by default: the original answered paper annotated with marks for every question/subpart, and a separate guide covering only errors and substantive areas for improvement.
- Follow the user's preferred explanation language; keep model exam answers in the language required by the paper.
- Flag unreadable answers, missing evidence and uncertain marks instead of guessing.

## Install in Codex

Run this one-line command in a macOS or Linux terminal with Bash and curl:

```bash
curl -fsSL https://raw.githubusercontent.com/rogeryeoh49-bot/cie-paper-marking-skill/main/install.sh | bash
```

The installer downloads the skill into `~/.codex/skills/mark-cie-papers` (or `$CODEX_HOME/skills/mark-cie-papers` when configured). Run the same command to update; any existing installation is backed up under the Codex home directory's `skill-backups/`. Failed downloads leave the existing installation unchanged. Start a new Codex session after installation.

Alternatively, copy the `mark-cie-papers` folder into `~/.codex/skills/` manually.

## Use

Invoke `$mark-cie-papers` with your completed paper and any language preference. The skill supports different subjects; reliability depends on having readable answers and the correct marking materials.

## Default deliverables

1. **Marked paper PDF:** preserve the original questions and handwritten work, annotate each question/subpart with marks earned and available, and prominently display **score / total on the first page of the original paper**. A separate summary page does not replace this first-page score. Keep annotations clear of existing content and flag uncertain marks.
2. **Corrections PDF:** explain only incorrect, partially correct or substantively weak answers, ordered by question number. Show the specific issue, why it matters, and how to fix it. Clearly distinguish non-penalized improvement advice from lost marks.

Render and inspect both PDFs before delivery. Keep submitted papers and grading outputs private; they are not uploaded to this repository.
