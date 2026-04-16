Please run a full SEO analysis for my website by following the workflow defined in CLAUDE.md.

Start by reading config.json to get my website URL, niche, and competitor list.

Then execute all five steps in order:

1. **Crawl my website** using Playwright — visit every page, extract titles, headings, and body content, save each page as a markdown file in output/site/, and write a summary to output/site/_index.md.

2. **Research keywords** using SerpAPI — run seed searches, collect autocomplete suggestions, extract People Also Ask questions, benchmark competitors, and explore long-tail variants. Save all raw results as JSON files in output/keywords/.

3. **Run the gap analysis** — compare my existing pages against every keyword and question you found. Mark each as Covered, Partially Covered, or Gap.

4. **Generate the SEO report** at output/seo-report.md — include the executive summary, existing content audit table, prioritised opportunity table (at minimum 10 opportunities), PAA quick wins, competitor gaps, and a 90-day content calendar.

5. When finished, print the path to the report and give me the three most important findings in plain language.

Work through each step methodically. Let me know when you start each step and what you find.
