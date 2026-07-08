# ISSUES Lab Member Page Template

Please share this template with new or existing lab members to gather the information needed for their website profiles.

---

## 1. Information to Email to the Lab Director

Copy and paste the section below into an email to members:

```text
Hi everyone,

We are updating the ISSUES Lab website member directory. Please reply to this email with the following details so I can create or update your profile page:

1. Full Name: (e.g., Jemima Grace)
2. Preferred Display Name: (e.g., Jemima Grace)
3. Title/Role in Lab: (e.g., PhD Student, Graduate Research Assistant)
4. OSU College/Department: (e.g., College of Social Work)
5. Short Bio (1-2 sentences): (A brief summary of your background or research motivation)
6. Research Interests (3 to 5 bullet points):
   - Interest 1
   - Interest 2
   - Interest 3
7. Education (List your degrees):
   - Degree (e.g., MSW, BS), Field/Subject, Institution, Year
8. Contact Info & Social Links (Only provide what you want public on the site):
   - Email:
   - LinkedIn Profile Link:
   - Google Scholar Link:
   - GitHub Profile Link:
   - X (Twitter) Profile Link:
9. Profile Photo: Please attach a high-quality headshot image. 
   - Rename the file to: firstname-lastname.jpg (or .png)
   - Close-cropped square photos work best!
```

---

## 2. Markdown File Structure (For Website Upload)

When a member sends back their details, create a file named `_index.md` inside a new folder `content/authors/firstname-lastname/` using this format:

```yaml
---
name: "First Last"
title: "First Last"
weight: 30                  # 1=PI, 10=Co-Director, 20-39=Graduate Students, 40+=Undergraduates
authors:
- firstname-lastname
superuser: false
role: "Role Name"
organizations:
- name: "The Ohio State University"
  url: "https://www.osu.edu/"
bio: "Short 1-2 sentence bio goes here."
interests:
- Interest 1
- Interest 2
- Interest 3
education:
  courses:
  - course: "Degree Name"
    institution: "Institution Name"
    year: 2026
social:
- icon: envelope
  icon_pack: fas
  link: "mailto:email@buckeyemail.osu.edu"
- icon: linkedin
  icon_pack: fab
  link: "https://www.linkedin.com/in/username"
# Email for Gravatar (optional)
email: "email@buckeyemail.osu.edu"
user_groups:
- Graduate Students         # Use "Faculty", "Graduate Students", or "Undergraduates"
---

Detailed biography paragraphs go here...
```

Save their headshot photo as `avatar.jpg` or `avatar.png` in the same folder.
