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
        style: "max-width: 600px; height: auto; margin: 0 auto; display: block;"
      text: |
        The ISSUES Lab is a research group that applies advanced statistical and spatial analysis to understand neighborhood conditions and translate data into actionable insights that inform public health policies and legal strategies aimed at building healthier communities.

        Our work bridges law, public health, and statistics by combining geospatial methods and participatory approaches to address structural inequities. We translate complex spatial and legal analysis into actionable insights that support communities most affected by violence, childhood adversity, and harmful environmental exposures.

        <br /><br />
        <div>
          <ul class="network-icon" aria-hidden="true">
            <li>
              <a itemprop="sameAs" href="mailto:barboza-salerno.1@osu.edu">
                <i class="fas fa-envelope big-icon"></i>
              </a>
            </li>
            <li>
              <a itemprop="sameAs" href="https://bsky.app/profile/data4socialjustice.bsky.social" target="_blank" rel="noopener">
                <i class="fas fa-cloud-sun"></i>
              </a>
            </li>
            <li>
              <a itemprop="sameAs" href="https://www.linkedin.com/in/gia-barboza-895bb07/" target="_blank" rel="noopener">
                <i class="fab fa-linkedin big-icon"></i>
              </a>
            </li>
            <li>
              <a itemprop="sameAs" href="https://scholar.google.com/citations?user=ej_48AcAAAAJ&hl=en" target="_blank" rel="noopener">
                <i class="ai ai-google-scholar big-icon"></i>
              </a>
            </li>
            <li>
              <a itemprop="sameAs" href="https://www.researchgate.net/profile/Gia-Barboza-Salerno" target="_blank" rel="noopener">
                <i class="ai ai-researchgate big-icon"></i>
              </a>
            </li>
            <li>
              <a itemprop="sameAs" href="https://github.com/issues-osu/" target="_blank" rel="noopener">
                <i class="fab fa-github big-icon"></i>
              </a>
            </li>
          </ul>
        </div>
    design:
      background:
        color: 'white'
        text_color_light: false

  - block: markdown
    content:
      title: About us
      text: |
        <div style="padding:56.25% 0 0 0;position:relative;">
          <iframe src="https://player.vimeo.com/video/1111768496?badge=0&amp;autopause=0&amp;player_id=0&amp;app_id=58479" style="position:absolute;top:0;left:0;width:100%;height:100%;" frameborder="0" allow="autoplay; fullscreen; picture-in-picture" allowfullscreen></iframe>
        </div>
        <script src="https://player.vimeo.com/api/player.js"></script>
        <br />

        Our work is driven by advances in machine learning, geospatial science, and the growing availability of big data. We focus on applying these tools to investigate how environmental exposures—such as neighborhood disinvestment, surveillance, and built environment risks—contribute to harm and system involvement. Our goal is to translate data into legal, policy, and practice solutions that promote the health and well-being of children, adolescents, and families. We use advanced methods—including Bayesian spatial models, geographically weighted regression, and geospatial machine learning—to examine how environmental exposures and spatial structures influence key outcomes such as child abuse, gun violence, adverse childhood experiences, and intimate partner violence. Our transdisciplinary approach brings together geospatial science, law, and public health to produce actionable insights for lawyers, judges, and policymakers, with a particular focus on housing and food security.

        We are a multidisciplinary team of scholar/activists from diverse disciplines with a shared research goal of strengthening families by highlighting their assets while addressing barriers to health. Each individual has a bio page that can be accessed [here](/people).
        
        We are proudly based at the <a href="https://cde.nus.edu.sg/arch/">Colleges of Social Work and Public Health</a> at the <a href="https://www.osu.edu">The Ohio State University</a>, a leading global university in the state of Ohio, USA.
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

  - block: people
    content:
      title: People
      text: We are an ensemble of scholars from diverse disciplines and countries, driving forward our shared research goal of making cities smarter and more data-driven. Since 2019, we have been fortunate to collaborate with many talented alumni, whose invaluable contributions have shaped and enriched our research group, and set the scene for future developments. The full list of our members is available [here](people ). <br /><br />

      # Choose which groups/teams of users to display.
      #   Edit `user_groups` in each user's profile to add them to one or more of these groups.
      user_groups:
          - People
      sort_by: Params.last_name
      sort_ascending: true
    design:
      show_interests: false
      show_role: true
      show_social: false

  - block: collection
    content:
      title: Presentations
      subtitle: Updates from our group
      text: Feel free to follow us on <a href="https://www.linkedin.com/in/gia-barboza-895bb07">LinkedIn</a>, <a href="https://bsky.app/profile/data4socialjustice.bsky.social">Blusky</a>, and through our [RSS feed]({{< ref path="/post" outputFormat="rss" >}}).
      count: 5
      featured_image: "featured.png"
      filters:
        exclude_featured: false
      order: desc
      page_type: news
    design:
      view: card
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
