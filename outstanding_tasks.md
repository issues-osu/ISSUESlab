# ISSUES Lab Website — Outstanding Tasks & Missing Pages

This document tracks all outstanding, missing, or pending items on the ISSUES Lab website that need to be addressed.

---

## 1. Member Profile Completion (Missing Info & Images)

The structural directories and stubs have been set up for all lab members, but several require bio/education data and headshot images:

### A. Awaiting Member Questionnaire Submissions
The following members need to submit their bio, education, and links using the [Member Template](file:///c:/Users/barboza-salerno.1/Documents/lab/content/authors/member_template.md) questionnaire:
*   **Jemima Grace** (Graduate Student) — Stub created: [`content/authors/jemima-grace/`](file:///c:/Users/barboza-salerno.1/Documents/lab/content/authors/jemima-grace/)
*   **Clare Dolan** (Undergraduate Student) — Stub created: [`content/authors/clare-dolan/`](file:///c:/Users/barboza-salerno.1/Documents/lab/content/authors/clare-dolan/)
*   **Randi Ellis** (Graduate Student) — Stub created: [`content/authors/randi-ellis/`](file:///c:/Users/barboza-salerno.1/Documents/lab/content/authors/randi-ellis/)
*   **Yunzi Yu** (Graduate Student) — Stub created: [`content/authors/yunzi-yu/`](file:///c:/Users/barboza-salerno.1/Documents/lab/content/authors/yunzi-yu/)
*   **Bruna Atalaya de Almeida Rocha** (Graduate Student) — Stub created: [`content/authors/bruna-atalaya-de-almeida-rocha/`](file:///c:/Users/barboza-salerno.1/Documents/lab/content/authors/bruna-atalaya-de-almeida-rocha/)
*   **Mingjun Gao** (Graduate Student) — Stub created: [`content/authors/mingjun-gao/`](file:///c:/Users/barboza-salerno.1/Documents/lab/content/authors/mingjun-gao/)
*   **Kaleb Masterson** (Undergraduate Student) — Stub created: [`content/authors/kaleb-masterson/`](file:///c:/Users/barboza-salerno.1/Documents/lab/content/authors/kaleb-masterson/)

### B. Missing Profile Headshots (Avatars)
The following profiles do not have an `avatar.jpg` file and are currently displaying a default silhouette placeholder. Headshot images need to be placed in their respective author folders:
*   **Dr. Keith Warren** — Folder: [`content/authors/keith-warren/`](file:///c:/Users/barboza-salerno.1/Documents/lab/content/authors/keith-warren/)
*   **Dr. Henriikka Weir** — Folder: [`content/authors/henriikka-weir/`](file:///c:/Users/barboza-salerno.1/Documents/lab/content/authors/henriikka-weir/)
*   **Jemima Grace** — Folder: [`content/authors/jemima-grace/`](file:///c:/Users/barboza-salerno.1/Documents/lab/content/authors/jemima-grace/)
*   **Clare Dolan** — Folder: [`content/authors/clare-dolan/`](file:///c:/Users/barboza-salerno.1/Documents/lab/content/authors/clare-dolan/)
*   **Randi Ellis** — Folder: [`content/authors/randi-ellis/`](file:///c:/Users/barboza-salerno.1/Documents/lab/content/authors/randi-ellis/)
*   **Yunzi Yu** — Folder: [`content/authors/yunzi-yu/`](file:///c:/Users/barboza-salerno.1/Documents/lab/content/authors/yunzi-yu/)
*   **Bruna Atalaya de Almeida Rocha** — Folder: [`content/authors/bruna-atalaya-de-almeida-rocha/`](file:///c:/Users/barboza-salerno.1/Documents/lab/content/authors/bruna-atalaya-de-almeida-rocha/)
*   **Mingjun Gao** — Folder: [`content/authors/mingjun-gao/`](file:///c:/Users/barboza-salerno.1/Documents/lab/content/authors/mingjun-gao/)
*   **Kaleb Masterson** — Folder: [`content/authors/kaleb-masterson/`](file:///c:/Users/barboza-salerno.1/Documents/lab/content/authors/kaleb-masterson/)

---

## 3. Upcoming APHA 2026 Presentations (Abstracts & Details)

The 6 placeholders under [`content/event/`](file:///c:/Users/barboza-salerno.1/Documents/lab/content/event/) have been updated with the correct titles, dates, locations, and authors list. However, because they are currently flagged as **Forthcoming**, the specific session schedule times, presentation slides, and abstracts must be added once they are finalized closer to November 2026.

---

## 4. How to Update

### A. Adding Profile Data
Once a member submits their template response:
1. Open [`content/authors/<member-name>/_index.md`](file:///c:/Users/barboza-salerno.1/Documents/lab/content/authors/).
2. Populate the `bio`, `interests`, `education`, and `social` links in the YAML front matter.
3. Save their square headshot image in the same directory as `avatar.jpg`.

### B. Adding APHA Presentation Abstracts
1. Open the corresponding index file inside [`content/event/apha-2026-presentation-*`](file:///c:/Users/barboza-salerno.1/Documents/lab/content/event/).
2. Replace the `**Forthcoming**` text with the presentation abstract.
3. If slides or PDFs become available, add the paths or links to `url_slides: ""` and `url_pdf: ""` respectively.
