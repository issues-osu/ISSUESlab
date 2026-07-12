---
title: ISSUES Lab
date: 2024-05-11
type: landing

sections:



  - block: markdown
    content:
      title: ""
      text: |
        <div style="text-align: left;">
          <img src="media/issues_banner_new.png" alt="ISSUES Banner" style="max-width: 100%; height: auto;">
          <br>
          <h1 style="margin-top: 20px; font-size: 2.5rem; line-height: 1.2; font-weight: 700;">Investigating Spatial Structures in Urban Environments (ISSUES)</h1>
          <p style="font-size: 1.25rem; font-weight: 500; color: #666; margin-top: 10px; margin-bottom: 5px;">Translating structural inequality into social and legal policy</p>
          <p style="font-size: 1.25rem; font-weight: 500; color: #666; margin-top: 0;">The Ohio State University</p>
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

  - block: collection
    content:
      title: In the News
      subtitle:
      count: 10
      filters:
        exclude_featured: false
      order: desc
      page_type: news
    design:
      view: compact
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
      page_type: presentations
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
        - Faculty
        - Graduate Students
        - Undergraduates
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
