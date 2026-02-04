---
title: ISSUES Lab
date: 2024-05-11
type: landing

sections:

  - block: hero
    content:
      title: Investigating Spatial Structures in Urban Environments (ISSUES)
      image:
        filename: urbanity3.png
        style: "width: 100%; height: auto; object-fit: contain;"
      text: |
        The Ohio State University
    design:
      background:
        color: '#ffffff'
        text_color_light: false

  - block: markdown
    content:
      title: ""
      text: |
        <div style="background-color: #f8f9fa; border-left: 5px solid #b00; padding: 20px; margin: 2rem 0; box-shadow: 0 4px 6px rgba(0,0,0,0.1); border-radius: 4px;">
          <h3 style="margin-top: 0; color: #b00;">🌟 In the News</h3>
          <ul style="list-style: none; padding-left: 0;">
            <li style="margin-bottom: 1rem;">
              <strong><a href="/authors/gia-barboza-salerno/" style="color: #2b2b2b; text-decoration: none;">Dr. Barboza-Salerno</a> Addresses Grand Challenge to Prevent Gun Violence</strong><br>
              <a href="https://csw.osu.edu/blog/2026/01/06/dr-barboza-salerno-addresses-grand-challenge-to-prevent-gun-violence/" target="_blank" style="color: #b00;">Read more &rarr;</a>
            </li>
            <li style="margin-bottom: 1rem;">
              <strong>📅 Upcoming: IPR Seminar on Abortion Accessibility & Maternal Health</strong><br>
              <span style="color: #666;">March 10, 2026 | 12:30-1:30 PM | Townshend Hall & Zoom</span><br>
              Dr. Barboza-Salerno presents on spatial accessibility to abortion care and maternal vulnerability.<br>
              <a href="/event/ipr-seminar-2026/" style="color: #b00;">Event details &rarr;</a>
            </li>
            <li style="margin-bottom: 1rem;">
              <strong>📅 Upcoming: Ohio Recovery Housing Conference</strong><br>
              <span style="color: #666;">April 15, 2026 | 1:00-2:15 PM | Breakout Session D</span><br>
              Dr. Barboza-Salerno and Taylor Harrington present research on recovery housing.<br>
              <a href="/event/ohio-recovery-housing-2026/" style="color: #b00;">Event details &rarr;</a>
            </li>
            <li style="margin-bottom: 1rem;">
              <strong><a href="/authors/amy-watson-grace/" style="color: #2b2b2b; text-decoration: none;">Amy Watson-Grace</a> Awarded the Prestigious Presidential Fellowship</strong>
            </li>
            <li>
              <strong><a href="/authors/olivia-mclucas/" style="color: #2b2b2b; text-decoration: none;">Olivia McLucas</a> Receives Scholarship for Outstanding Statistics Student</strong>
            </li>
          </ul>
        </div>
    design:
      columns: '1'

  - block: markdown
    content:
      title: About us
      text: |
        The ISSUES Lab is a research group that applies advanced statistical and spatial analysis to understand neighborhood conditions and translate data into actionable insights that inform public health policies and legal strategies aimed at building healthier communities.

        Our work is driven by advances in machine learning, geospatial science, and the growing availability of big data. We focus on applying these tools to investigate how environmental exposures—such as neighborhood disinvestment, surveillance, and built environment risks—contribute to harm and system involvement. Our goal is to translate data into legal, policy, and practice solutions that promote the health and well-being of children, adolescents, and families. We use advanced methods—including Bayesian spatial models, geographically weighted regression, and geospatial machine learning—to examine how environmental exposures and spatial structures influence key outcomes such as child abuse, gun violence, adverse childhood experiences, and intimate partner violence. Our transdisciplinary approach brings together geospatial science, law, and public health to produce actionable insights for lawyers, judges, and policymakers, with a particular focus on housing and food security.

        We are a multidisciplinary team of scholar/activists from diverse disciplines with a shared research goal of strengthening families by highlighting their assets while addressing barriers to health. Each individual has a bio page that can be accessed [here](/people).

        We are proudly based at the <a href="https://csw.osu.edu">Colleges of Social Work and Public Health</a> at the <a href="https://cph.osu.edu">The Ohio State University</a>, a leading global university in the state of Ohio, USA.
    design:
      columns: '2'

  - block: markdown
    content:
      title: Media Engagement
      text: |
        <div style="display:flex;justify-content:center;align-items:center;">
          <div class="substack-post-embed">
            <p lang="en">Ep 29. Gun violence exposure on walkable routes to and from school by David Riedman, PhD</p>
            <p>Using data from acoustic-detection sensors, a new study found alarming spatial patterns of gun-violence exposure along walkable routes to and from schools in Englewood, Chicago.</p>
            <a data-post-link href="https://k12ssdb.substack.com/p/ep-29-gun-violence-exposure-on-walkable">Read on Substack</a>
          </div>
        </div>
        <script async src="https://substack.com/embedjs/embed.js" charset="utf-8"></script>
    design:
      columns: '2'

  - block: collection
    content:
      title: Featured publications
      subtitle: For the full list of publications see [here](/publication/).
      count: 4
      filters:
        featured_only: true
      order: desc
      page_type: publication
    design:
      view: card
      columns: '2'

  - block: collection
    content:
      title: Presentations
      subtitle: Updates from our group
      text: Feel free to follow us on <a href="https://www.linkedin.com/in/gia-barboza-895bb07">LinkedIn</a>, <a href="https://bsky.app/profile/data4socialjustice.bsky.social">Bluesky</a>, and through our [RSS feed]({{< ref path="/post" outputFormat="rss" >}}).
      count: 5
      featured_image: "featured.png"
      filters:
        exclude_featured: false
      order: desc
      page_type: news
    design:
      view: card
      columns: '2'

  - block: collection
    content:
      title: Recent & Upcoming Talks
      subtitle: 
      count: 5
      filters:
        exclude_featured: false
      order: desc
      page_type: event
    design:
      view: card
      columns: '2'

  - block: people
    content:
      title: People
      text: We are a group of multidisciplinary scholars from diverse backgrounds. We are united around our passion for improving the lives of children and families. The full list of our members is available [here](/people).
      user_groups:
        - People
      sort_by: Params.last_name
      sort_ascending: true
    design:
      show_interests: false
      show_role: true
      show_social: false
      columns: '2'

  - block: contact
    id: contact
    content:
      title: Contact
      email: barboza-salerno.1@osu.edu
      address:
        street: 1947 College Road
        city: Columbus
        region: Ohio
        postcode: '43017'
        country: United States of America
      contact_links:
        - icon: twitter
          name: X
          link: 'https://x.com/bigdata4justice'
        - icon: linkedin
          name: LinkedIn
          link: 'https://www.linkedin.com/in/gia-barboza-895bb07/'
    design:
      columns: '2'
---
